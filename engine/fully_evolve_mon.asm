FullyEvolveMonInCF91:
; exactly what it says on the tin.
	ld a, [wcf91]
	ld [wd11e], a
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, 0
	ld hl, FullyEvolvedMonTable
	add hl, bc
	ld a, [hl]
	and a
	jr z, .Eeveelutions
.done
	ld [wcf91], a
	ret
.Eeveelutions
	ldafarbyte RandomizerCheckValue
	and $1C ; $7 << 2
	srl a
	srl a
	ld c, a
	ld b, 0
	ld hl, EeveelutionsTable
	add hl, bc
	ld a, [hl]
	jr .done
	
EeveelutionsTable::
; there are only 3 eeveelutions but that's an awkward value to seed.
; so give 3/8 jolteon 3/8 vaporeon 2/8 flareon
	db JOLTEON
	db JOLTEON
	db JOLTEON
	db VAPOREON
	db VAPOREON
	db VAPOREON
	db FLAREON
	db FLAREON
	
	
femon: MACRO
	rept \1
	db \2
	endr
ENDM
	
FullyEvolvedMonTable::
	femon 3, VENUSAUR
	femon 3, CHARIZARD
	femon 3, BLASTOISE
	femon 3, BUTTERFREE
	femon 3, BEEDRILL
	femon 3, PIDGEOT
	femon 2, RATICATE
	femon 2, FEAROW
	femon 2, ARBOK
	femon 2, RAICHU
	femon 2, SANDSLASH
	femon 3, NIDOQUEEN
	femon 3, NIDOKING
	femon 2, CLEFABLE
	femon 2, NINETALES
	femon 2, WIGGLYTUFF
	femon 2, GOLBAT
	femon 3, VILEPLUME
	femon 2, PARASECT
	femon 2, VENOMOTH
	femon 2, DUGTRIO
	femon 2, PERSIAN
	femon 2, GOLDUCK
	femon 2, PRIMEAPE
	femon 2, ARCANINE
	femon 3, POLIWRATH
	femon 3, ALAKAZAM
	femon 3, MACHAMP
	femon 3, VICTREEBEL
	femon 2, TENTACRUEL
	femon 3, GOLEM
	femon 2, RAPIDASH
	femon 2, SLOWBRO
	femon 2, MAGNETON
	db FARFETCHD
	femon 2, DODRIO
	femon 2, DEWGONG
	femon 2, MUK
	femon 2, CLOYSTER
	femon 3, GENGAR
	db ONIX
	femon 2, HYPNO
	femon 2, KINGLER
	femon 2, ELECTRODE
	femon 2, EXEGGUTOR
	femon 2, MAROWAK
	db HITMONLEE
	db HITMONCHAN
	db LICKITUNG
	femon 2, WEEZING
	femon 2, RHYDON
	db CHANSEY
	db TANGELA
	db KANGASKHAN
	femon 2, SEADRA
	femon 2, SEAKING
	femon 2, STARMIE
	db MR_MIME
	db SCYTHER
	db JYNX
	db ELECTABUZZ
	db MAGMAR
	db PINSIR
	db TAUROS
	femon 2, GYARADOS
	db LAPRAS
	db DITTO
	db $00 ; eevee
	db VAPOREON
	db JOLTEON
	db FLAREON
	db PORYGON
	femon 2, OMASTAR
	femon 2, KABUTOPS
	db AERODACTYL
	db SNORLAX
	db ARTICUNO
	db ZAPDOS
	db MOLTRES
	femon 3, DRAGONITE
	db MEWTWO
	db MEW
