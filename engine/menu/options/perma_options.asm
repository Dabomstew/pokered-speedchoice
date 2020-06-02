PermaOptionsString::
	db "PRESET (A: SET)<LNBRK>"
	db "        :<LNBRK>"
	db "PLAYER NAME<LNBRK>"
	db "        :<LNBRK>"
	db "RIVAL NAME<LNBRK>"
	db "        :<LNBRK>"
	db "START IN<LNBRK>"
	db "        :<LNBRK>"
	db "RACE GOAL<LNBRK>"
	db "        :<LNBRK>"
	db "SPINNERS<LNBRK>"
	db "        :<LNBRK>"
	db "TRAINER VISION<LNBRK>"
	db "        :@"

PermaOptionsPointers::
	dw Options_Preset
	dw Options_Name
	dw Options_RivalName
	dw Options_StartIn
	dw Options_RaceGoal
	dw Options_Spinners
	dw Options_TrainerVision
	dw Options_PermaOptionsPage
	
permaoptionspreset: MACRO
	dw \1
rept NUM_PERMAOPTIONS_BYTES
	db \2
	shift
endr
ENDM

PermaOptionsPresets:
	; Vanilla
	permaoptionspreset Preset_VanillaName, 0, 0, 0, 0
	; Bingo
	permaoptionspreset Preset_BingoName, (EXP_FORMULA_BLACKWHITE << EXP_FORMULA_SHIFT) | BETTER_MARTS_VAL | NERF_PEWTER_GYM_VAL | ALL_MOVES_SHAKE_VAL, SHORT_DELAYS_VAL | BACKWARDS_BOAT_VAL | BETTER_GAME_CORNER_VAL | (SELECTTO_BIKE << SELECTTO_SHIFT) | EASY_SAFARI_VAL, 0, EARLY_VICTORY_ROAD_VAL | B_FAST_MOVEMENT_VAL | KEEP_WARDEN_CANDY_VAL | DEX_AREA_BEEP_VAL
	; 251
	permaoptionspreset Preset_CEAName, (EXP_FORMULA_BLACKWHITE << EXP_FORMULA_SHIFT) | BETTER_MARTS_VAL | NERF_PEWTER_GYM_VAL | ALL_MOVES_SHAKE_VAL, SHORT_DELAYS_VAL | BACKWARDS_BOAT_VAL | BETTER_GAME_CORNER_VAL | (SELECTTO_BIKE << SELECTTO_SHIFT) | EASY_SAFARI_VAL, (RACEGOAL_151DEX << RACEGOAL_SHIFT), EARLY_VICTORY_ROAD_VAL | B_FAST_MOVEMENT_VAL | KEEP_WARDEN_CANDY_VAL | DEX_AREA_BEEP_VAL
PermaOptionsPresetsEnd:

Preset_VanillaName:
	db "VANILLA @"
Preset_BingoName:
	db "BINGO   @"
Preset_CEAName:
	db "151 RACE@"

Options_Preset::
	ld hl, wOptionsMenuPreset
	ld c, [hl]
	bit BIT_D_LEFT, a
	jr nz, .decr
	bit BIT_D_RIGHT, a
	jr nz, .incr
	bit BIT_A_BUTTON, a
	jr z, .print
	call .get_pointer
	inc hl
	inc hl
	ld b, NUM_PERMAOPTIONS_BYTES
	ld de, wPermanentOptions
.setloop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .setloop
	ld a, SFX_PURCHASE
	call PlaySound
	call WaitForSoundToFinish
	call DrawOptionsMenu
	and a
	ret

.incr
	inc c
	ld a, c
	cp (PermaOptionsPresetsEnd - PermaOptionsPresets) / (NUM_PERMAOPTIONS_BYTES + 2)
	jr c, .okay
	ld c, 0
	jr .okay

.decr
	ld a, c
	dec c
	and a
	jr nz, .okay
	ld c, (PermaOptionsPresetsEnd - PermaOptionsPresets) / (NUM_PERMAOPTIONS_BYTES + 2) - 1
.okay
	ld [hl], c
.print
	call .get_pointer
	ld a, [hli]
	ld d, [hl]
	ld e, a
	hlcoord 11, 3
	call PlaceString
	and a
	ret

.get_pointer
	ld b, 0
	ld hl, PermaOptionsPresets
rept (NUM_PERMAOPTIONS_BYTES + 2)
	add hl, bc
endr
	ret

Options_Name:
	and A_BUTTON
	jr z, .GetText
	ld a, [wJumptableIndex]
	push af
	ld de, wPlayerName
	xor a ; NAME_PLAYER_SCREEN
	ld [wNamingScreenType], a
	callab FarcallNamingScreen
	call DrawOptionsMenu
	pop af
	ld [wJumptableIndex], a
.GetText
	ld de, wPlayerName
	ld a, [de]
	cp "@"
	jr nz, .Display
	ld de, .NotSetString
.Display
	hlcoord 11, 5
	call PlaceString
	and a
	ret

.NotSetString
	db "NOT SET@"
	
Options_RivalName:
	and A_BUTTON
	jr z, .GetText
	ld a, [wJumptableIndex]
	push af
	ld de, wRivalName
	ld a, NAME_RIVAL_SCREEN
	ld [wNamingScreenType], a
	callab FarcallNamingScreen
	call DrawOptionsMenu
	pop af
	ld [wJumptableIndex], a
.GetText
	ld de, wRivalName
	ld a, [de]
	cp "@"
	jr nz, .Display
	ld de, .NotSetString
.Display
	hlcoord 11, 7
	call PlaceString
	and a
	ret

.NotSetString
	db "NOT SET@"
	
Options_StartIn::
	ldafarbyte KeyItemRandoActive
	and a
	jr z, .normal
; with KeyItemRando on, disable startin and set it to normal (0)
	ld a, [STARTIN_ADDRESS]
	and $ff ^ STARTIN_MASK
	ld [STARTIN_ADDRESS], a
	ld de, .KIROn
	coord hl, 11, 8
	call PlaceString
	ld de, .Normal
	coord hl, 11, 9
	jp PlaceString
.normal
	ld hl, .Data
	jp Options_Multichoice
	
.Data:
	multichoiceoptiondata STARTIN_ADDRESS, STARTIN_SHIFT, STARTIN_SIZE, 9, NUM_OPTIONS, .Strings
	
.Strings:
	dw .Normal
	dw .Eevee
	dw .Lapras
	dw .Safari
	dw .Tower
.Strings_End:

.Normal:
	db "NORMAL@"
.Eevee:
	db "EEVEE @"
.Lapras:
	db "LAPRAS@"
.Safari:
	db "SAFARI@"
.Tower:
	db "TOWER @"
.KIROn:
	db "(KIR ON)@"
	
Options_RaceGoal:: ; 11
	ld hl, .Data
	jp Options_Multichoice
	
.Data:
	multichoiceoptiondata RACEGOAL_ADDRESS, RACEGOAL_SHIFT, RACEGOAL_SIZE, 11, NUM_OPTIONS, .Strings
	
.Strings:
	dw .Manual
	dw .E4
	dw .FullDex
.Strings_End:

.Manual:
	db "MANUAL @"
.E4:
	db "ELITE 4@"
.FullDex:
	db "151 DEX@"
	
Options_Spinners:
	ld hl, .Data
	jp Options_Multichoice
	
.Data:
	multichoiceoptiondata SPINNERS_ADDRESS, SPINNERS_SHIFT, SPINNERS_SIZE, 13, NUM_OPTIONS, .Strings
	
.Strings:
	dw .Normal
	dw .Hell
	dw .Why
.Strings_End:
	
.Normal
	db "NORMAL@"
.Hell
	db "HELL  @"
.Why
	db "WHY   @"
	
Options_TrainerVision:
	ld hl, MAX_RANGE_ADDRESS
	ld b, MAX_RANGE
	ld c, 15
	ld de, .NormalMax
	jp Options_TrueFalse
.NormalMax
	dw .Off
	dw .On
.Off
	db "NORMAL@"
.On
	db "MAX   @"
