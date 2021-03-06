VBlank::

	push af
	push bc
	push de
	push hl
	
	ld a, [rSVBK]
	ld [hSVBKBackup], a
	xor a ; most things in vblank rely on seeing normal d000-dfff
	ld [rSVBK], a

	ld a, [H_LOADEDROMBANK]
	ld [wVBlankSavedROMBank], a

	ld a, [hSCX]
	ld [rSCX], a
	ld a, [hSCY]
	ld [rSCY], a

	ld a, [wDisableVBlankWYUpdate]
	and a
	jr nz, .ok
	ld a, [hWY]
	ld [rWY], a
.ok

	call AutoBgMapTransfer
	call RedrawRowOrColumn
	call UpdateMovingBgTiles
	call WriteCGBPalettes
	call $ff80 ; hOAMDMA
	ld a, BANK(PrepareOAMData)
	rst BankswitchCommon
	call PrepareOAMData

	; VBlank-sensitive operations end.

	call Random
	callab SRAMStatsFrameCount

	ld a, [H_VBLANKOCCURRED]
	and a
	jr z, .skipZeroing
	xor a
	ld [H_VBLANKOCCURRED], a

.skipZeroing
	ld a, [H_FRAMECOUNTER]
	and a
	jr z, .skipDec
	dec a
	ld [H_FRAMECOUNTER], a

.skipDec
	call UpdateSound

	callba TrackPlayTime ; keep track of time played

	ld a, [hDisableJoypadPolling]
	and a
	call z, ReadJoypad

	ld a, [wVBlankSavedROMBank]
	rst BankswitchCommon
	
	ld a, [hSVBKBackup]
	ld [rSVBK], a

	pop hl
	pop de
	pop bc
	pop af
	reti


DelayFrame::
; Wait for the next vblank interrupt.
; As a bonus, this saves battery.

NOT_VBLANKED EQU 1

	ld a, NOT_VBLANKED
	ld [H_VBLANKOCCURRED], a
.halt
	halt
	ld a, [H_VBLANKOCCURRED]
	and a
	jr nz, .halt
	ret
