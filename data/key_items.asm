keyitemflag: MACRO
key_val = 0
rept _NARG
key_val = key_val + (1 << ((\1 - 1) % 8))
SHIFT
endr
	db key_val
ENDM

KeyItemBitfield:
	keyitemflag TOWN_MAP, BICYCLE, SURFBOARD, SAFARI_BALL ; 01-08
	keyitemflag TEA ; 09-10
	keyitemflag BOULDERBADGE, CASCADEBADGE, THUNDERBADGE, RAINBOWBADGE ; 11-18
	keyitemflag SOULBADGE, MARSHBADGE, VOLCANOBADGE, EARTHBADGE, OLD_AMBER ; 19-20
	keyitemflag ; 21-28
	keyitemflag DOME_FOSSIL, HELIX_FOSSIL, SECRET_KEY, POKEDEX_NEW, BIKE_VOUCHER, CARD_KEY ; 29-30
	keyitemflag ; 31-38
	keyitemflag S_S_TICKET, GOLD_TEETH ; 39-40
	keyitemflag COIN_CASE, OAKS_PARCEL, ITEMFINDER, SILPH_SCOPE ; 41-48
	keyitemflag POKE_FLUTE, LIFT_KEY, OLD_ROD, GOOD_ROD, SUPER_ROD ; 49-50
	keyitemflag ; 51-58
