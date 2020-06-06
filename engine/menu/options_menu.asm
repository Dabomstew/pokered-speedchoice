FIRST_OPTIONS_PAGEID EQU 0
NUM_OPTIONS_PAGES EQU 2

FIRST_PERMAOPTIONS_PAGEID EQU NUM_OPTIONS_PAGES
NUM_PERMAOPTIONS_PAGES EQU 4

PermaOptionsMenu::
	ld a, FIRST_PERMAOPTIONS_PAGEID
	jr OptionsMenuCommon

OptionsMenu::
	xor a
	; fallthrough

OptionsMenuCommon::
	ld [wOptionsMenuID], a
	xor a
	ld [wStoredJumptableIndex], a
	ld [wOptionsMenuPreset], a
	ld hl, hInMenu
	ld a, [hl]
	push af
	ld [hl], $1
.pageLoad
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a ; enable auto background transfer
	call DrawOptionsMenu
.joypad_loop
	call Joypad
	ld a, [hJoyPressed]
	ld b, a
	ld a, [wOptionsExitButtons]
	and b
	jr nz, .ExitOptions
	call OptionsControl
	jr c, .dpad
	call GetOptionPointer
	jr c, .ExitOptions

.dpad
	call Options_UpdateCursorPosition
	ld c, 3
	call DelayFrames
	jr .joypad_loop

.ExitOptions
	ld a, [wOptionsNextMenuID]
	cp $FF
	jr z, .doExit
	ld [wOptionsMenuID], a
	jr .pageLoad
.doExit
	ld a, [wOptionsMenuID]
	cp FIRST_PERMAOPTIONS_PAGEID
	jr c, .exit
	ld a, [wPlayerName]
	cp "@"
	jr z, .nameMissing
	ld a, [wRivalName]
	cp "@"
	jr nz, .exit
.nameMissing
	ld a, [HOLD_TO_MASH_ADDRESS]
	push af
	and $ff ^ HOLD_TO_MASH_VAL
	ld [HOLD_TO_MASH_ADDRESS], a
	ld hl, NameNotSetText
	call PrintText
	pop af
	ld [HOLD_TO_MASH_ADDRESS], a
	jr .pageLoad
.exit
	pop af
	ld [hInMenu], a
	ld a, SFX_PURCHASE
	call PlaySound
	call WaitForSoundToFinish
	ret

DrawOptionsMenu:
	call DrawOptionsMenuLagless
	ld a, [wStoredJumptableIndex]
	ld [wJumptableIndex], a
	xor a
	ld [wStoredJumptableIndex], a
	ret
	
DrawOptionsMenuLagless_::
	ld a, [wJumptableIndex]
	push af
	call DrawOptionsMenuLagless
	pop af
	ld [wJumptableIndex], a
	ret

DrawOptionsMenuLagless::
	call RetrieveOptionsMenuConfig
	coord hl, 0, 0
	lb bc, SCREEN_HEIGHT - 2, SCREEN_WIDTH - 2
	call TextBoxBorder
	ld hl, wOptionsStringPtr
	ld a, [hli]
	ld e, a
	ld d, [hl]
	hlcoord 2, 2
	call PlaceString
	xor a
	ld [wJumptableIndex], a
	dec a
	ld [wOptionsNextMenuID], a
	ld a, [wOptionsMenuCount]
	inc a
	ld c, a ; number of items on the menu

.print_text_loop ; this next will display the settings of each option when the menu is opened
	push bc
	xor a
	ld [hJoyPressed], a
	call GetOptionPointer
	pop bc
	ld hl, wJumptableIndex
	inc [hl]
	dec c
	jr nz, .print_text_loop
	ret

RetrieveOptionsMenuConfig::
	ld a, [wOptionsMenuID]
	ld hl, OptionsMenuScreens
	ld bc, wOptionsNextMenuID - wOptionsMenuCount
	call AddNTimes
	ld de, wOptionsMenuCount
	jp CopyData
	
options_menu: MACRO
	db (\1) ; number of options except bottom option
	dw (\2) ; template string
	dw (\3) ; jumptable for options
	db (\4) ; buttons that can be pressed to exit
ENDM

OptionsMenuScreens:
	; default options page 1
	options_menu 6, MainOptionsString, MainOptionsPointers, (START | B_BUTTON)
	options_menu 2, MainOptions2String, MainOptions2Pointers, (START | B_BUTTON)
	; permaoptions page 1-3
	options_menu 7, PermaOptionsString, PermaOptionsPointers, START
	options_menu 7, PermaOptions2String, PermaOptions2Pointers, START
	options_menu 7, PermaOptions3String, PermaOptions3Pointers, START
	options_menu 7, PermaOptions4String, PermaOptions4Pointers, START

GetOptionPointer:
	ld a, [wOptionsMenuCount]
	ld b, a
	ld a, [wJumptableIndex] ; load the cursor position to a
	cp b
	jr c, .doJump
	ld a, b ; if on the bottom option, use the last item in the jumptable
.doJump
	ld e, a ; copy it to de
	ld d, 0
	ld hl, wOptionsJumptablePtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
rept 2
	add hl, de
endr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hJoyPressed] ; almost all options use this, so it's easier to just do it here
	jp hl ; jump to the code of the current highlighted item

Options_Cancel:
	and A_BUTTON
	jr nz, Options_Exit
Options_NoFunc:
	and a
	ret

Options_Exit:
	scf
	ret

Options_OptionsPage:
	lb bc, FIRST_OPTIONS_PAGEID, FIRST_OPTIONS_PAGEID + NUM_OPTIONS_PAGES - 1
	jr Options_Page

Options_PermaOptionsPage:
	lb bc, FIRST_PERMAOPTIONS_PAGEID, FIRST_PERMAOPTIONS_PAGEID + NUM_PERMAOPTIONS_PAGES - 1
Options_Page:
; assumes b = MenuID of first page, c = MenuID of last page
; also assumes all pages use sequential MenuIDs
	bit BIT_D_LEFT, a
	jr nz, .Decrease
	bit BIT_D_RIGHT, a
	jr nz, .Increase
	coord hl, 2, 16
	ld de, .PageString
	push bc
	call PlaceString
	pop bc
	ld a, [wOptionsMenuID]
	sub b
	add "1"
	coord hl, 8, 16
	ld [hl], a
	and a
	ret
.Decrease
	ld a, [wOptionsMenuID]
	cp b
	jr nz, .actuallyDecrease
	ld a, c
	jr .SaveAndChangePage
.actuallyDecrease
	dec a
	jr .SaveAndChangePage
.Increase
	ld a, [wOptionsMenuID]
	cp c
	jr nz, .actuallyIncrease
	ld a, b
	jr .SaveAndChangePage
.actuallyIncrease
	inc a
.SaveAndChangePage
	ld [wOptionsNextMenuID], a
	ld a, 7
	ld [wStoredJumptableIndex], a
	scf
	ret
.PageString
	db "PAGE:@"

OptionsControl:
	ld hl, wJumptableIndex
	ld a, [hJoyPressed]
	cp D_DOWN
	jr z, .DownPressed
	cp D_UP
	jr z, .UpPressed
	and a
	ret

.DownPressed
	ld a, [hl] ; load the cursor position to a
	cp 7
	jr nz, .clampToMenuTest
	ld [hl], $0
	scf
	ret
.clampToMenuTest
	ld c, a
	ld a, [wOptionsMenuCount]
	dec a
	cp c ; maximum index of item in real options menu
	jr nz, .Increase
	ld [hl], $6 ; bottom option minus 1

.Increase
	inc [hl]
	scf
	ret

.UpPressed
	ld a, [hl]
	cp 7
	jr z, .HandleBottomOption
	and a
	jr nz, .Decrease
	ld a, 8
	ld [hl], a ; move to bottom option

.Decrease
	dec [hl]
	scf
	ret
	
.HandleBottomOption
; move to bottommost regular option
	ld a, [wOptionsMenuCount]
	dec a
	ld [hl], a
	scf
	ret

Options_UpdateCursorPosition:
	hlcoord 1, 1
	ld de, SCREEN_WIDTH
	ld c, $10
.loop
	ld [hl], " "
	add hl, de
	dec c
	jr nz, .loop
	hlcoord 1, 2
	ld bc, 2 * SCREEN_WIDTH
	ld a, [wJumptableIndex]
	call AddNTimes
	ld [hl], "▶"
	ret
	
; b = x-coordinate
; c = y-coordinate
CoordHL:
	push bc
	ld h, 0
	ld b, h
	ld l, c
	add hl, hl
	add hl, hl ; *4
	add hl, bc ; *5
	add hl, hl
	add hl, hl ; *20
	ld bc, wTileMap
	add hl, bc
	pop bc
	ld c, b
	ld b, 0
	add hl, bc
	ret
	
; hl = ram address
; b = bit number in ram address
; c = y-coordinate to draw at
; de = table of strings to show for false/true (false first)
Options_OnOff:
	ld de, OnOffStrings
Options_TrueFalse:
	push de
	ld d, a
	ld a, 1
	and a ; clear carry
	inc b
.shiftloop
	dec b
	jr z, .doneshift
	rla
	jr .shiftloop
.doneshift
	ld b, a
	ld a, d
	and (1 << BIT_D_LEFT) | (1 << BIT_D_RIGHT)
	ld a, [hl]
	jr z, .GetText
	xor b
	ld [hl], a
.GetText
	pop de
	and b
	jr z, .Display
	ld a, 2
	add e
	ld e, a
	jr nc, .Display
	inc d
.Display
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld d, a
	ld e, l
	ld b, 11 ; x-coord, y-coord is already in c
	call CoordHL
	call PlaceString
	and a
	ret
	
OnOffStrings::
	dw .Off
	dw .On
.Off:
	db "OFF@"
.On:
	db "ON @"
	
; arguments = ram address, start bit, size in bits, y-coord, number of choices, pointer to choices
multichoiceoptiondata: macro
	dw \1 ; ram address
	db \2 ; bit number that data STARTS at
	db (1 << (\2 + \3)) - (1 << \2) ; bitmask for data
	db \4 ; y-coordinate
	db \5 ; number of choices
	dw \6 ; pointer to choices
endm

; hl = pointer to options multichoice struct	
Options_Multichoice:
	; load multichoice data to ram
	ld bc, 8
	ld de, wBuffer
	call CopyData
	ld a, [hJoyPressed]
	bit BIT_D_LEFT, a
	jr nz, .LeftPressed
	bit BIT_D_RIGHT, a
	jr nz, .RightPressed
	jr .UpdateDisplay
.RightPressed
	call .GetVal
	inc a
	jr .Save

.LeftPressed
	call .GetVal
	dec a

.Save
	cp $ff
	jr nz, .nextCheck
	ld a, [wBuffer + 5] ; max value
	dec a
	jr .store
.nextCheck
	ld b, a
	ld a, [wBuffer + 5] ; max value
	cp b
	jr nz, .storeskipmove
	xor a
.store
	ld b, a
.storeskipmove
	ld a, [wBuffer + 2] ; bitshift required
	inc a
.shiftloop
	dec a
	jr z, .calcAndStore
	sla b
	jr .shiftloop
.calcAndStore
	ld hl, wBuffer
	rst UnHL
	ld a, [hl]
	ld c, a
	ld a, [wBuffer + 3] ; bitmask for the option in question
	cpl ; invert it so we clear the option
	and c ; bitmask AND current value
	or b ; set new value
	ld [hl], a
	
.UpdateDisplay:
	call .GetVal
	ld c, a
	ld b, 0
	ld hl, wBuffer + 6 ; pointer to strings
	rst UnHL
rept 2
	add hl, bc
endr
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [wBuffer + 4] ; y-coordinate
; calculate ram address to put string at from y-coordinate
	ld c, a
	ld b, 11 ; x-coordinate
	call CoordHL
	call PlaceString
	and a
	ret
	
.GetVal:
	ld hl, wBuffer
	rst UnHL
	ld b, [hl]
	ld a, [wBuffer + 3] ; bitmask
	and b
	ld b, a
; bitshift as needed
	ld a, [wBuffer + 2] ; bitshift
	inc a
.shiftloop2
	dec a
	jr z, .done
	srl b
	jr .shiftloop2
.done
	ld a, b
	ret
	
NUM_OPTIONS EQUS "((.Strings_End - .Strings)/2)"

INCLUDE "engine/menu/options/main_options.asm"
INCLUDE "engine/menu/options/main_options_2.asm"
INCLUDE "engine/menu/options/perma_options.asm"
INCLUDE "engine/menu/options/perma_options_2.asm"
INCLUDE "engine/menu/options/perma_options_3.asm"
INCLUDE "engine/menu/options/perma_options_4.asm"

NameNotSetText::
	text "Please set the"
	line "names on page 1!@"
	TX_ASM
	ld a, SFX_DENIED
	call PlaySound
	call WaitForSoundToFinish
	ld hl, .done
	ret
.done
	text ""
	prompt
