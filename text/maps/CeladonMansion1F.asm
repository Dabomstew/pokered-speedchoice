_CeladonMansion1Text1::
	text "MEOWTH: Meow!@@"

_CeladonMansion1Text2::
	text "My dear #MON"
	line "keep me company."

	para "MEOWTH even brings"
	line "money home!"
	done

_CeladonMansion1Text3::
	text "CLEFAIRY: Pi"
	line "pippippi!@@"

_CeladonMansion1Text4::
	text "NIDORAN: Kya"
	line "kyaoo!@@"

_CeladonMansion1Text5::
	text "CELADON MANSION"
	line "Manager's Suite"
	done

_TeaPreGiveText::
	text "You shouldn't spend"
	line "all your money"
	cont "on drinks."

	para "Try this instead."
	prompt
	done
	
_TeaPostGiveText::
	text "<PLAYER> received"
	line "@"
	TX_RAM wcf4b
	text "!@"
	TX_SFX_KEY_ITEM
	text ""

	para "Nothing beats"
	line "thirst like some"
	cont "hot TEA."

	para "It really is"
	line "the best."
	done
