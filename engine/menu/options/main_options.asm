MainOptionsString:: ; e4241
	db "TEXT SPEED<LNBRK>"
	db "        :<LNBRK>"
	db "HOLD TO MASH<LNBRK>"
	db "        :<LNBRK>"
	db "BATTLE SCENE<LNBRK>"
	db "        :<LNBRK>"
	db "BATTLE STYLE<LNBRK>"
	db "        :<LNBRK>"
	db "PALETTE<LNBRK>"
	db "        :@"
; e42d6

MainOptionsPointers::
	dw Options_TextSpeed
	dw Options_HoldToMash
	dw Options_BattleScene
	dw Options_BattleStyle
	dw Options_Palette
	dw Options_OptionsPage
; e42f5

Options_TextSpeed: ; e42f5
	call GetTextSpeed
	ld a, [hJoyPressed]
	bit BIT_D_LEFT, a
	jr nz, .LeftPressed
	bit BIT_D_RIGHT, a
	jr z, .NonePressed
	ld a, c ; right pressed
	cp TEXT_SLOW
	jr c, .Increase
	ld c, TEXT_INSTANT +- 1

.Increase
	inc c
	jr .Save

.LeftPressed
	ld a, c
	and a
	jr nz, .Decrease
	ld c, TEXT_SLOW + 1

.Decrease
	dec c

.Save
	ld a, [wOptions]
	and $ff ^ TEXT_SPEED_MASK
	or c
	ld [wOptions], a

.NonePressed
	ld b, 0
	ld hl, .Strings
rept 2
	add hl, bc
endr
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 11, 3
	call PlaceString
	and a
	ret
; e4331

.Strings
	dw .Inst
	dw .Fast
	dw .Mid
	dw .Slow
	
.Inst
	db "INST@"

.Fast
	db "FAST@"
.Mid
	db "MID @"
.Slow
	db "SLOW@"
; e4346

GetTextSpeed::
	ld a, [wOptions]
	and TEXT_SPEED_MASK
	ld c, a
	ret

Options_BattleScene: ; e4365
	ld hl, wOptions
	and (1 << BIT_D_LEFT) | (1 << BIT_D_RIGHT)
	ld a, [hl]
	jr z, .GetText
	xor (1 << BATTLE_SHOW_ANIMATIONS)
	ld [hl], a
.GetText
	bit BATTLE_SHOW_ANIMATIONS, a
	ld de, .On
	jr nz, .Display
	ld de, .Off
.Display
	hlcoord 11, 7
	call PlaceString
	and a
	ret
; e4398

.On
	db "ON @"
.Off
	db "OFF@"
; e43a0


Options_BattleStyle: ; e43a0
	ld hl, wOptions
	and (1 << BIT_D_LEFT) | (1 << BIT_D_RIGHT)
	ld a, [hl]
	jr z, .GetText
	xor (1 << BATTLE_SHIFT)
	ld [hl], a
.GetText
	bit BATTLE_SHIFT, a
	ld de, .Shift
	jr nz, .Display
	ld de, .Set
.Display
	hlcoord 11, 9
	call PlaceString
	and a
	ret
; e43d1

.Shift
	db "SHIFT@"
.Set
	db "SET  @"
; e43dd

Options_HoldToMash: ; e44c1
	ld hl, wOptions
	and (1 << BIT_D_LEFT) | (1 << BIT_D_RIGHT)
	ld a, [hl]
	jr z, .GetText
	xor (1 << HOLD_TO_MASH)
	ld [hl], a
.GetText
	bit HOLD_TO_MASH, a
	ld de, .Off
	jr z, .Display
	ld de, .On
.Display
	hlcoord 11, 5
	call PlaceString
	and a
	ret
; e44f2

.Off
	db "OFF@"
.On
	db "ON @"
; e44fa

Options_Palette:
	; todo
	ret

