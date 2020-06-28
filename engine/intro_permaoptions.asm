VersionNumberText::
    db "v1.0"
	INCLUDE "git-revision.asm"
	db "@"
VersionNumberTextEnd::

IntroPermaOptions::
	xor a
	ld hl, wPermanentOptions
	rept NUM_PERMAOPTIONS_BYTES - 1
	ld [hli], a
	endr
	ld [hl], a
	ld a, [HOLD_TO_MASH_ADDRESS]
	push af
	and $ff ^ HOLD_TO_MASH_VAL
	ld [HOLD_TO_MASH_ADDRESS], a
	ld hl, PleaseSetOptions
	call PrintText
	pop af
	ld [HOLD_TO_MASH_ADDRESS], a
	ld a, "@"
	ld [wPlayerName], a
	ld [wRivalName], a
.setOptions
	callba PermaOptionsMenu
	call ClearScreen
	call PrintPermaOptionsToScreen
	ld hl, AreOptionsAcceptable
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .setOptions
; setup stats now
    jpab SetupStats
	
PrintPermaOptionsToScreen::
	coord hl, 0, 1
	ld de, (VersionNumberText - VersionNumberTextEnd) & $ffff
	add hl, de
	ld de, VersionNumberText
	call PlaceString
; start in + race goal
	coord hl, 1, 1
	ld a, [STARTIN_ADDRESS]
	ld b, a
; start in
	and STARTIN_MASK
	add a
	push hl
	ld hl, .StartInOptionsStrings
	add l
	ld l, a
	jr nc, .loadPtr3
	inc h
.loadPtr3
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	call PlaceStringIncHL
; race goal
	ld a, b
	and RACEGOAL_MASK
	swap a
	add a
	push hl
	ld hl, .RaceGoalOptionsStrings
	add l
	ld l, a
	jr nc, .loadPtr4
	inc h
.loadPtr4
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	call PlaceStringIncHL
; byte 1 stuff
	ld a, [SPINNERS_ADDRESS]
	ld b, a
; spinners
	and SPINNERS_MASK
	add a
	push hl
	ld hl, .SpinnerOptionsStrings
	add l
	ld l, a
	jr nc, .loadPtr
	inc h
.loadPtr
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	call PlaceStringIncHL
; vision
	bit MAX_RANGE, b
	ld de, NormalVisionText
	jr z, .placeVisionSetting
	ld de, MaxVisionText
.placeVisionSetting
	call PlaceStringIncHL
; exp
	ld a, b
	and EXP_FORMULA_MASK
	srl a
	srl a
	push hl
	ld hl, .EXPOptionsStrings
	add l
	ld l, a
	jr nc, .loadPtr2
	inc h
.loadPtr2
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	call PlaceStringIncHL
; marts
	bit BETTER_MARTS, b
	ld de, NormalMartsText
	jr z, .placeMartSetting
	ld de, BetterMartsText
.placeMartSetting
	call PlaceStringIncHL
; key item rando?
	ld a, [KeyItemRandoActive]
	and a
	jr z, .checkvalue
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld de, KeyItemRandoText
	call PlaceStringIncHL
	ld [hl], "S"
	inc hl
	ld [hl], ":"
	inc hl
	inc hl
	ld de, KeyItemRandoSeed
	call PlaceString
; checkvalue stuff
.checkvalue
	coord hl, 1, 11
	ld [hl], "C"
	inc hl
	ld [hl], "V"
	inc hl
	ld [hl], ":"
	inc hl
	inc hl
	push hl
	ld hl, RandomizerCheckValue
	ld de, wBuffer
	ld bc, 4
	call CopyData
bnum = 0
	rept NUM_PERMAOPTIONS_BYTES
bnum = bnum + 1
if bnum % 4 == 1
	ld hl, wBuffer
endc
	ld a, [wPermanentOptions + bnum - 1]
	xor [hl]
	ld [hli], a
	endr
	pop hl
	ld de, wBuffer
	ld c, 4
.checkValueLoop
	ld a, [de]
	inc de
	call PrintHexByte
	dec c
	jr nz, .checkValueLoop
	ret
.SpinnerOptionsStrings
	dw NormalSpinnersText
	dw SpinnerHellText
	dw SuperSpinnerHellText
.EXPOptionsStrings
	dw NormalEXPText
	dw BWEXPText
	dw NoEXPText
.StartInOptionsStrings
	dw StartInNormalText
	dw StartInEeveeText
	dw StartInLaprasText
	dw StartInSafariText
	dw StartInTowerText
.RaceGoalOptionsStrings
	dw ManualGoalText
	dw E4GoalText
	dw FullDexGoalText
	
PlaceStringIncHL::
	push bc
	call PlaceString
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	ret
	
PrintHexByte::
; a contains the value to be displayed
	ld b, a
; upper nibble
	swap b
	call .printNibble
	swap b
.printNibble
	ld a, b
	and $0F
	add "0"
	or $80
	ld [hli], a
	ret
	
KeyItemRandoText::
	db "KEYRANDO ON@"
StartInNormalText::
	db "NORMAL START LOC.@"
StartInEeveeText::
	db "START IN EEVEE@"
StartInLaprasText::
	db "START IN LAPRAS@"
StartInSafariText::
	db "START IN SAFARI@"
StartInTowerText::
	db "START IN TOWER @"
ManualGoalText::
	db "NO AUTO GOAL@"
E4GoalText::
	db "GOAL: ELITE 4@"
FullDexGoalText::
	db "GOAL: 151 DEX@"
NormalSpinnersText::
	db "NO SPINNERS@"
SpinnerHellText::
	db "SPINNER HELL@"
SuperSpinnerHellText::
	db "SUPER SPINNER HELL@"
NormalVisionText::
	db "NORMAL VISION@"
MaxVisionText::
	db "MAX VISION@"
NormalEXPText::
	db "NORMAL EXP@"
BWEXPText::
	db "B/W EXP@"
NoEXPText::
	db "NO EXP@"
NormalMartsText::
	db "NORM MARTS@"
BetterMartsText::
	db "GOOD MARTS@"
NormalWildsText::
	db "NORM WILDS@"
BetterWildsText::
	db "GOOD WILDS@"

PleaseSetOptions::
	TX_FAR _PleaseSetOptions
	db "@"

AreOptionsAcceptable::
	TX_FAR _AreOptionsAcceptable
	db "@"
