MainOptionsString::
	db "TEXT SPEED<LNBRK>"
	db "        :<LNBRK>"
	db "HOLD TO MASH<LNBRK>"
	db "        :<LNBRK>"
	db "BATTLE SCENE<LNBRK>"
	db "        :<LNBRK>"
	db "BATTLE STYLE<LNBRK>"
	db "        :<LNBRK>"
	db "PALETTE<LNBRK>"
	db " :@"

MainOptionsPointers::
	dw Options_TextSpeed
	dw Options_HoldToMash
	dw Options_BattleScene
	dw Options_BattleStyle
	dw Options_Palette
	dw Options_OptionsPage
; e42f5

Options_TextSpeed:
	ld hl, .Data
	jp Options_Multichoice
	
.Data:
	multichoiceoptiondata wOptions, TEXT_SPEED_SHIFT, TEXT_SPEED_SIZE, 3, NUM_OPTIONS, .Strings

.Strings
	dw .Inst
	dw .Fast
	dw .Mid
	dw .Slow
.Strings_End:
	
.Inst
	db "INST@"

.Fast
	db "FAST@"
.Mid
	db "MID @"
.Slow
	db "SLOW@"

Options_BattleScene:
	ld hl, wOptions
	ld b, BATTLE_SHOW_ANIMATIONS
	ld c, 7
	jp Options_OnOff

Options_BattleStyle:
	ld hl, wOptions
	ld b, BATTLE_SHIFT
	ld c, 9
	ld de, .ShiftSet
	jp Options_TrueFalse
.ShiftSet
	dw .Set
	dw .Shift

.Shift
	db "SHIFT@"
.Set
	db "SET  @"

Options_HoldToMash:
	ld hl, wOptions
	ld b, HOLD_TO_MASH
	ld c, 5
	jp Options_OnOff

Options_Palette:
	ld a, [wCurPalette]
	ld c, a
	ld a, [hJoyPressed]
	bit BIT_D_LEFT, a
	jr nz, .LeftPressed
	bit BIT_D_RIGHT, a
	jr z, .NonePressed
	ld a, c ; right pressed
	cp NUM_GBC_PALETTES
	jr c, .Increase
	ld c, $ff

.Increase
	inc c
	jr .Save

.LeftPressed
	ld a, c
	and a
	jr nz, .Decrease
	ld c, NUM_GBC_PALETTES + 1

.Decrease
	dec c

.Save
	ld a, c
	ld [wCurPalette], a

.NonePressed
	ld l, c
	ld h, 0
	ld b, h
	add hl, hl ; *2
	add hl, hl ; *4
	add hl, bc
	add hl, bc
	add hl, bc ; *7
	add hl, hl ; *14
	add hl, bc ; *15
	ld bc, .Strings
	add hl, bc
	ld e, l
	ld d, h
	hlcoord 4, 11
	call PlaceString
	and a
	ret

.Strings
	db "DEFAULT       @"
	db "BROWN         @"
	db "RED           @"
	db "DARK BROWN    @"
	db "PASTEL        @"
	db "ORANGE        @"
	db "YELLOW        @"
	db "BLUE          @"
	db "DARK BLUE     @"
	db "GRAY          @"
	db "GREEN         @"
	db "DARK GREEN    @"
	db "INVERTED      @"
	db "<pkmn> BLUE        @"
	db "TRUE INVERTED @"
	db "CHEATER PASTEL@"
	db "HOT PINK      @"

