; a place to store all the speedchoice-unique data that randomizers should parse/change 
; also serves as a way to keep offsets static for mission-critical data
RandomizerData::
; version number OF THIS DATA BLOCK. not the same as the version of the rom itself
; used to make sure randomizer understands what it's reading from here
RandomizerDataVersion::
	dw 1
; encounter slot type
RandomizerDataVanillaEncounterSlots::
IF DEF(_VANILLAWILDS)
	db $01
ELSE
	db $00
ENDC
; key item rando key items and logic-enable flag
; key item rando should write to these items and also turn on the flag to enable the logic
KeyItemRandoDataBegin::
KeyItemBicycle::
	db BICYCLE
KeyItemBikeVoucher::
	db BIKE_VOUCHER
KeyItemCardKey::
	db CARD_KEY
KeyItemCoinCase::
	db COIN_CASE
KeyItemDomeFossil::
	db DOME_FOSSIL
KeyItemHelixFossil::
	db HELIX_FOSSIL
KeyItemGoldTeeth::
	db GOLD_TEETH
KeyItemGoodRod::
	db GOOD_ROD
KeyItemHM01::
	db HM_01
KeyItemHM02::
	db HM_02
KeyItemHM03::
	db HM_03
KeyItemHM04::
	db HM_04
KeyItemHM05::
	db HM_05
KeyItemItemfinder::
	db ITEMFINDER
KeyItemLiftKey::
	db LIFT_KEY
KeyItemOaksParcel::
	db OAKS_PARCEL
KeyItemOldAmber::
	db OLD_AMBER
KeyItemOldRod::
	db OLD_ROD
KeyItemPokeFlute::
	db POKE_FLUTE
KeyItemSecretKey::
	db SECRET_KEY
KeyItemSilphScope::
	db SILPH_SCOPE
KeyItemSSTicket::
	db S_S_TICKET
KeyItemSuperRod::
	db SUPER_ROD
KeyItemTea::
	db 0 ; db TEA - to be implemented
KeyItemTownMap::
	db TOWN_MAP
KeyItemRandoActive::
	db $00
KeyItemRandoSeed::
	ds 11 ; up to 10 numbers + terminator
KeyItemRandoDataEnd::

; other rando stuff
RandomizerCheckValue::
	ds 4
RandomizerSeed::
	ds 16 ; up to 15 numbers + terminator
	
RandomizerDataEnd::
