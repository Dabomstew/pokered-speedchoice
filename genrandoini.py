#!/bin/python3

import argparse
import os


class Symfile(dict):
	@classmethod
	def from_fp(cls, fp):
		retval = cls()
		retval.ram_symbols = dict()
		for line in fp:
			try:
				ptr, name = line.split()
				bank, addr = (int(x, 16) for x in ptr.split(':'))
				if addr < 0x8000:
					retval[name] = (bank << 14) | (addr & 0x3fff)
				else:
					retval.ram_symbols[name] = addr
			except ValueError:
				continue
		return retval
		
class Charmap(dict):
	@classmethod
	def from_fp(cls, fp):
		retval = cls()
		for line in fp:
			if not line.startswith("charmap ") or len(line.strip()) < 14:
				continue
			line = line.strip()
			initialQuote = line[8]
			endOfQuote = line.index(initialQuote, 9)
			mapping = line[9:endOfQuote]
			restOfLine = line[endOfQuote+1:]
			if ';' in restOfLine:
				restOfLine = restOfLine[:restOfLine.index(';')]
			retval[int(restOfLine.strip()[-2:], 16)] = mapping
		return retval

def fpeek(fp, size=1):
	tell = fp.tell()
	buff = fp.read(size)
	fp.seek(tell, os.SEEK_SET)
	return buff
	
def get_bank(offset):
	return offset // 0x4000
	
def last_free_byte(fp, bank):
	fp.seek(bank*0x4000 + 0x3fff)
	while fpeek(fp) == b'\x00':
		fp.seek(-1, os.SEEK_CUR)
	return fp.tell() + 2 # just in case a 00 terminator is being used for the last data
	
def read_str(fp, address, charmap):
	fp.seek(address)
	retval = ""
	while True:
		val = fp.read(1)
		if val == b'\x50':
			return retval
		charint = int.from_bytes(val, "little")
		if charint in charmap:
			retval += charmap[charint]


def main():
	parser = argparse.ArgumentParser()
	parser.add_argument('rom', type=argparse.FileType('rb'))
	parser.add_argument('sym', type=argparse.FileType())
	parser.add_argument('out', type=argparse.FileType('w'))
	args = parser.parse_args()
	args.rom: IO
	args.sym: IO
	args.out: IO

	syms = Symfile.from_fp(args.sym)
	
	with open('charmap.asm') as fp:
		charmap = Charmap.from_fp(fp)
	
	def setconfig(key, value):
		print('{}={}'.format(key, value), file=args.out)
		
	def setconfighex(key, value):
		print('{}=0x{:X}'.format(key, value), file=args.out)

	def set_symbol(key, sym, extra=0):
		setconfig(key, '0x{:X}'.format(syms[sym] + extra))
		
	def set_ramsymbol(key, sym, extra=0):
		setconfig(key, '0x{:X}'.format(syms.ram_symbols[sym] + extra))
		
	def set_multisymbols(key, *symbols):
		vals = []
		for sym in symbols:
			if isinstance(sym, list):
				# list of name, offset
				vals.append('0x{:X}'.format(syms[sym[0]] + sym[1]))
			else:
				# just name
				vals.append('0x{:X}'.format(syms[sym]))
		setconfig(key, '[{}]'.format(", ".join(vals)))
	
	def set_tm_text(num, key, txt):
		if isinstance(key, list):
			# non-standard offset from sym
			setconfig('TMText[]',
				  '[{:d},0x{:X},{}]'.format(num, syms[key[0]] + key[1], txt))
		else:
			setconfig('TMText[]',
					  '[{:d},0x{:X},{}]'.format(num, syms[key] + 1, txt))

	# Print version
	args.rom.seek(0x14c)
	ver = int.from_bytes(args.rom.read(1), 'little')
	
	
	print('[Red SPDC {}]'.format(read_str(args.rom, syms["VersionNumberText"], charmap)), file=args.out)

	# Game code
	args.rom.seek(0x134)
	code = args.rom.read(11).decode('ascii').rstrip('\0')
	setconfig('Game', code)
	setconfig('Version', str(ver))

	# Is Japanese?
	args.rom.seek(0x14a)
	jap = int.from_bytes(args.rom.read(1), 'little')
	setconfig('NonJapanese', str(jap))

	setconfig('Type', 'RBSpeedchoice')
	setconfig('ExtraTableFile', 'gsc_english') # font/charmap have been changed to match crystal
	
	# speedchoice-exclusive stuff goes first because wynaut
	args.rom.seek(syms["RandomizerVanillaEncounterSlots"])
	setconfig('VanillaEncounterSlots', str(int.from_bytes(args.rom.read(1), 'little')))
	set_symbol('CheckValueOffset', 'RandomizerCheckValue')
	set_symbol('SeedOffset', 'RandomizerSeed')
	set_symbol('TrainersChanged', 'RandomizerTrainersChanged')
	
	setconfig('InternalPokemonCount', '190')
	set_symbol('PokedexOrder', 'PokedexOrder')
	set_symbol('PokemonNamesOffset', 'MonsterNames')
	setconfig('PokemonNamesLength', '10')
	set_symbol('PokemonStatsOffset', 'MonBaseStats')
	set_symbol('MewStatsOffset', 'MewBaseStats')
	set_symbol('WildPokemonTableOffset', 'WildDataPointers')
	set_symbol('OldRodOffset', 'ItemUseOldRod', 6)
	set_symbol('GoodRodOffset', 'GoodRodMons')
	set_symbol('SuperRodTableOffset', 'SuperRodData')
	set_symbol('MapNameTableOffset', 'ExternalMapEntries')
	setconfig('MoveCount', '165')
	set_symbol('MoveDataOffset', 'Moves')
	set_symbol('MoveNamesOffset', 'MoveNames')
	set_symbol('ItemNamesOffset', 'ItemNames')
	set_symbol('TypeEffectivenessOffset', 'TypeEffects')
	set_symbol('PokemonMovesetsTableOffset', 'EvosMovesPointerTable')
	setconfighex('PokemonMovesetsDataSize', syms["EvosMovesEnd"] - syms["EvosMovesStart"])
	
	# spare space for movesets
	setconfighex('PokemonMovesetsExtraSpaceOffset', last_free_byte(args.rom, get_bank(syms["EvosMovesStart"])))
	
	# starters
	# like ghost marowak, these were extracted into a single byte for simplicity
	set_multisymbols('StarterOffsets1', 'RandomizerStarterCharmander')
	set_multisymbols('StarterOffsets2', 'RandomizerStarterSquirtle')
	set_multisymbols('StarterOffsets3', 'RandomizerStarterBulbasaur')
	

	setconfig('PatchPokedex', '1')
	setconfig('CanChangeStarterText', '1')
	setconfig('CanChangeTrainerText', '1')
	set_multisymbols('StarterTextOffsets', ['_OaksLabCharmanderText', 1], ['_OaksLabSquirtleText', 1], ['_OaksLabBulbasaurText', 1])
	
	set_symbol('StarterPokedexOnOffset', 'StarterDex')
	set_symbol('StarterPokedexOffOffset', 'StarterDex', 0x0A)
	setconfighex('StarterPokedexBranchOffset', last_free_byte(args.rom, get_bank(syms["StarterDex"])))
	set_ramsymbol('PokedexRamOffset', 'wPokedexOwned')
	
	set_symbol('TrainerDataTableOffset', 'TrainerDataPointers')
	# jrM and brock are 1 higher vs vanilla for nerf pewter gym data
	setconfig('TrainerDataClassCounts', '[0, 13, 14, 18, 8, 10, 24, 7, 12, 14, 15, 9, 3, 0, 11, 15, 9, 7, 15, 4, 2, 8, 6, 17, 9, 9, 3, 0, 13, 3, 41, 10, 8, 1, 2, 1, 1, 1, 1, 1, 1, 5, 12, 3, 1, 24, 1, 1]')
	set_symbol('ExtraTrainerMovesTableOffset', 'TeamMoves')
	set_symbol('GymLeaderMovesTableOffset', 'LoneMoves', 1)
	set_symbol('TMMovesOffset', 'TechnicalMachines')
	set_multisymbols('TrainerClassNamesOffsets', 'YoungsterName', 'TrainerNames')
	
	set_symbol('IntroPokemonOffset', 'OakSpeechIntroPokemon', 1)
	set_symbol('IntroCryOffset', 'TextCommandSounds', 0x0F)
	set_symbol('MapBanks', 'MapHeaderBanks')
	set_symbol('MapAddresses', 'MapHeaderPointers')
	set_symbol('SpecialMapList', 'HiddenObjectMaps')
	set_symbol('SpecialMapPointerTable', 'HiddenObjectPointers')
	set_symbol('HiddenItemRoutine', 'HiddenItems')
	set_symbol('TradeTableOffset', 'TradeMons')
	setconfig('TradeTableSize', '10')
	setconfig('TradeNameLength', '11')
	setconfig('TradesUnused', '[2]')
	set_symbol('PCPotionOffset', 'OakSpeechBoxItems', 1)
	set_symbol('CatchingTutorialMonOffset', 'CatchingTutorialOpponentMon', 1)
	set_symbol('MonPaletteIndicesOffset', 'MonsterPalettes')
	set_symbol('SGBPalettesOffset', 'SuperPalettes')
	
	setconfig('StaticPokemonSupport', '1')
	# eevee and hitmons
	set_multisymbols('StaticPokemonPokeballs', ['CeladonMansion5Text2', 3], ['FightingDojoText7.GetMon', 1], ['FightingDojoText6.GetMon', 1])
	# overworlds
	set_multisymbols(
		'StaticPokemonOverworlds',
		['PowerPlant_Object', 0x16],
		['PowerPlant_Object', 0x1E],
		['PowerPlant_Object', 0x26],
		['PowerPlant_Object', 0x2E],
		['PowerPlant_Object', 0x36],
		['PowerPlant_Object', 0x3E],
		['PowerPlant_Object', 0x46],
		['PowerPlant_Object', 0x4E],
		['PowerPlant_Object', 0x56],
		['SeafoamIslandsB4F_Object', 0x2C],
		['VictoryRoad2F_Object', 0x4E],
		['CeruleanCaveB1F_Object', 0x0E],
		['Route12Snorlax', 0x01],
		['Route16Snorlax', 0x01]
	)
	# fossils
	set_multisymbols(
		'StaticPokemonOverworlds',
		['GiveFossilToCinnabarLab.choseHelixFossil', -3],
		['GiveFossilToCinnabarLab.choseHelixFossil', 1],
		['GiveFossilToCinnabarLab.choseDomeFossil', 1]
	)
	# gifts
	set_multisymbols(
		'StaticPokemonGifts',
		['SilphCo7Text1.givelapras', 0x08],
		['MagikarpSalesmanText.enoughMoney', 0x02]
	)
	# game corner
	for i in range(3):
		set_multisymbols('StaticPokemonGameCorner[]', ['PrizeMenuMon1Entries', i], ['PrizeMonLevelDictionary', i*2])
	for i in range(3):
		set_multisymbols('StaticPokemonGameCorner[]', ['PrizeMenuMon2Entries', i], ['PrizeMonLevelDictionary', 6 + i*2])
	# ghost marowak
	# some marowak offsets were in the middle of volatile code so it has just been extracted to a separate location
	set_multisymbols('StaticPokemonGhostMarowak', 'RandomizerGhostMarowak')
	
	# tm texts
	# default offset from the symbol for these is 0x01 instead of 0x00
	set_tm_text(6, '_TM06ExplanationText', '\\pTM06 contains\\n%m!\\e')
	set_tm_text(11, '_CeruleanGymText_5c7c3', 'TM11 teaches\\n%m!\\e')
	set_tm_text(13, ['_CeladonMartRoofText_484fe', 0x08], 'contains\\n%m!\\e')
	set_tm_text(18, '_TM18ExplanationText', 'TM18 is\\n%m!\\e')
	set_tm_text(21, '_TM21ExplanationText', '\\pTM21 contains\\n%m.\\e')
	set_tm_text(24, '_TM24ExplanationText', '\\pTM24 contains\\n%m!\\e')
	set_tm_text(27, '_TM27ExplanationText', '\\pTM27 is\\n%m!\\e')
	set_tm_text(28, '_CeruleanTrashedText_1d6ab', 'Those miserable\\nROCKETs!\\pLook what they\\ndid here!\\pThey stole a TM\\nfor teaching\\l[POKé]MON how to\\l%m!\\e')
	set_tm_text(28, '_CeruleanTrashedText_1d6b0', 'I figure what\'s\\nlost is lost!\\pI decided to get\\n%m\\lwithout a TM!\\e')
	set_tm_text(29, '_TM29ExplanationText', 'TM29 is\\n%m!\\e')
	set_tm_text(31, '_TM31ExplanationText1', '\\pTM31 contains my\\nfavorite,\\l%m!\\e')
	set_tm_text(34, '_TM34ExplanationText', '\\pA TM contains a\\ntechnique that\\lcan be taught to\\l[POKé]MON!\\pA TM is good only\\nonce! So when you\\luse one to teach\\la new technique,\\lpick the [POKé]MON\\lcarefully!\\pTM34 contains\\n%m!\\e')
	set_tm_text(36, '_TM36ExplanationText', 'TM36 is\\n%m!\\e')
	set_tm_text(38, '_TM38ExplanationText', '\\pTM38 contains\\n%m!\\e')
	set_tm_text(39, '_TM39ExplanationText', 'TM39 is the move\\n%m.\\e')
	set_tm_text(41, '_TM41ExplanationText', 'TM41 teaches\\n%m!\\pMany [POKé]MON\\ncan use it!\\e')
	set_tm_text(42, '_TM42Explanation', 'TM42 contains\\n%m...\\e')
	set_tm_text(46, '_TM46ExplanationText', '\\pTM46 is\\n%m!\\e')
	set_tm_text(48, ['_CeladonMartRoofText_4850f', 0x08], 'contains\\n%m!\\e')
	set_tm_text(49, '_CeladonMartRoofText_48520', '\\pTM49 is\\n%m!\\e')


if __name__ == '__main__':
	main()