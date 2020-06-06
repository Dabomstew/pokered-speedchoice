MainOptions2String::
	db "FRAME<LNBRK>"
	db "        :TYPE <LNBRK>"
	db "PALETTE<LNBRK>"
	db " :@"

MainOptions2Pointers::
	dw Options_Frame
	dw Options_Palette
	dw Options_OptionsPage

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
	hlcoord 4, 5
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
	
NUM_TEXTBOX_FRAMES EQUS "((TextBoxFramesEnd - TextBoxFrames)/2 + 1)"
	
Options_Frame:
	ld a, [FRAME_ADDRESS]
	and FRAME_MASK
	ld c, a
	ld a, [hJoyPressed]
	bit BIT_D_LEFT, a
	jr nz, .LeftPressed
	bit BIT_D_RIGHT, a
	jr z, .NonePressed
	ld a, c ; right pressed
	cp NUM_TEXTBOX_FRAMES - 1
	jr c, .Increase
	ld c, $ff

.Increase
	inc c
	jr .Save

.LeftPressed
	ld a, c
	and a
	jr nz, .Decrease
	ld c, NUM_TEXTBOX_FRAMES

.Decrease
	dec c

.Save
	ld a, [FRAME_ADDRESS]
	and $ff ^ FRAME_MASK
	or c
	ld [FRAME_ADDRESS], a
	push bc
	call LoadTextBoxTilePatterns
	pop bc
.NonePressed
	inc c
	ld a, c
	ld [wBuffer], a
	ld de, wBuffer
	coord hl, 16, 3
; empty the space for the new number
	ld a, " "
	ld [hli], a
	ld [hld], a
	lb bc, PRINTNUM_LEFTALIGN | 1, 2
	call PrintNumber
	and a
	ret
