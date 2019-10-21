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

PermaOptionsPresets:
	; Vanilla
	dw 0 , Preset_VanillaName
	; Bingo
	dw 0, Preset_BingoName
	; 251
	dw 0, Preset_CEAName
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
	ld de, wPermanentOptions
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld a, SFX_PURCHASE
	call PlaySound
	call WaitForSoundToFinish
	call DrawOptionsMenu
	and a
	ret

.incr
	inc c
	ld a, c
	cp (PermaOptionsPresetsEnd - PermaOptionsPresets) / 4
	jr c, .okay
	ld c, 0
	jr .okay

.decr
	ld a, c
	dec c
	and a
	jr nz, .okay
	ld c, (PermaOptionsPresetsEnd - PermaOptionsPresets) / 4 - 1
.okay
	ld [hl], c
.print
	call .get_pointer
	inc hl
	inc hl
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
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
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
	ld hl, .Data
	jp Options_Multichoice
	
.Data:
	multichoiceoptiondata wPermanentOptions3, STARTIN_SHIFT, STARTIN_SIZE, 9, NUM_OPTIONS, .Strings
	
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
	
Options_RaceGoal:: ; 11
	ret
	
Options_Spinners:
	ld hl, .Data
	jp Options_Multichoice
	
.Data:
	multichoiceoptiondata wPermanentOptions, SPINNERS_SHIFT, SPINNERS_SIZE, 13, NUM_OPTIONS, .Strings
	
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
	ld hl, wPermanentOptions
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
