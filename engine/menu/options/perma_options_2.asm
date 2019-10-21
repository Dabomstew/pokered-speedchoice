PermaOptions2String::
	db "DELAYS<LNBRK>"
	db "        :<LNBRK>"
	db "METRONOME ONLY<LNBRK>"
	db "        :<LNBRK>"
	db "SHAKE MOVES<LNBRK>"
	db "        :<LNBRK>"
	db "EXPERIENCE<LNBRK>"
	db "        :<LNBRK>"
	db "GOOD EARLY WILDS<LNBRK>"
	db "        :<LNBRK>"
	db "BETTER MARTS<LNBRK>"
	db "        :<LNBRK>"
	db "SELECT TO<LNBRK>"
	db "        :@"

PermaOptions2Pointers::
	dw Options_Delays
	dw Options_MetronomeOnly
	dw Options_ShakeMoves
	dw Options_EXP
	dw Options_GoodEarlyWilds
	dw Options_BetterMarts
	dw Options_SelectTo
	dw Options_PermaOptionsPage
	
Options_Delays:: ; 3
	ld hl, wPermanentOptions2
	ld b, SHORT_DELAYS
	ld c, 3
	ld de, .NormalFast
	jp Options_TrueFalse
.NormalFast
	dw .Off
	dw .On
.Off
	db "NORMAL@"
.On
	db "FAST  @"
	
Options_MetronomeOnly:: ; 5
	ret
	
Options_ShakeMoves::
	ld hl, wPermanentOptions
	ld b, ALL_MOVES_SHAKE
	ld c, 7
	ld de, .NormalAll
	jp Options_TrueFalse
.NormalAll
	dw .Off
	dw .On
.Off
	db "NORMAL@"
.On
	db "ALL   @"
	
Options_EXP:
	ld hl, wPermanentOptions
	bit BIT_D_LEFT, a
	jr nz, .LeftPressed
	bit BIT_D_RIGHT, a
	jr nz, .RightPressed
	jr .UpdateDisplay

.RightPressed
	call .GetEXPVal
	inc a
	jr .Save

.LeftPressed
	call .GetEXPVal
	dec a

.Save
	cp $ff
	jr nz, .nextCheck
	ld a, NUM_OPTIONS - 1
	jr .store
.nextCheck
	cp NUM_OPTIONS
	jr nz, .store
	xor a
.store
	ld b, a
	sla b
	sla b
	sla b
	ld a, [hl]
	and $ff ^ EXP_MASK
	or b
	ld [hl], a
	
.UpdateDisplay:
	call .GetEXPVal
	ld c, a
	ld b, 0
	ld hl, .Strings
rept 2
	add hl, bc
endr
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 11, 9
	call PlaceString
	and a
	ret
	
.GetEXPVal:
	ld a, [hl]
	and EXP_MASK
	srl a
	srl a
	srl a
	ret
	
.Strings:
	dw .Normal
	dw .BW
	dw .None
.Strings_End:
	
.Normal
	db "NORMAL@"
.BW
	db "B/W   @"
.None
	db "NONE  @"
	
Options_GoodEarlyWilds:: ; 11
	ld hl, wPermanentOptions2
	ld b, GOOD_EARLY_WILDS
	ld c, 11
	jp Options_OnOff
	
Options_BetterMarts::
	ld hl, wPermanentOptions
	ld b, BETTER_MARTS
	ld c, 13
	jp Options_OnOff
	
Options_SelectTo:: ; 15
	ret
