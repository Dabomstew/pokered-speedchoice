_HBlank::
	ld a, [H_AUTOBGTRANSFERENABLED]
	and a ; do we need to transfer the BG Map?
	jr z, ConvertDMGPaletteIndexesToCGB ; if not, skip to palette conversion
	ld a, 2
; change to wram bank 2
	ld [rSVBK], a
; load hl with tilemap buffer
	ld hl, $d000
; do stack copy similar to AutoBGMapTransfer
	ld [H_SPTEMP], sp
	coord sp, 0, 0
	ld bc, 32 - (20 - 1)
	ld a, 18
	
TransferBgRowsHBL:
	rept 20 / 2 - 1
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	endr

	pop de
	ld [hl], e
	inc l
	ld [hl], d

	add hl, bc
	dec a
	jr nz, TransferBgRowsHBL

	ld a, [H_SPTEMP]
	ld l, a
	ld a, [H_SPTEMP + 1]
	ld h, a
	ld sp, hl
	xor a
	ld [rSVBK], a
ConvertDMGPaletteIndexesToCGB:
	ld a, [wCurPalette]
	ld e, a
	ld hl, CGBPalettes
	and a
	jr z, .regularPalette
	ld bc, $8 * 3
.addNTimesLoop
	add hl, bc
	dec e
	jr nz, .addNTimesLoop
.regularPalette
	ld a, [wLastPalette]
	ld b, a
	ld a, [wCurPalette]
	cp b
	ld [wLastPalette], a
	jr z, .paletteHasNotChanged
	ld de, wTempOBP0
	ld a, [rOBP0]
	call HandleDMGPalettes
	ld bc, $8
	add hl, bc
	ld de, wTempOBP1
	ld a, [rOBP1]
	call HandleDMGPalettes
	ld bc, $8
	add hl, bc
	ld de, wTempBGP
	ld a, [rBGP]
	call HandleDMGPalettes
	ld hl, hLastBGP
; trick the game into transferring palettes by faking a palette change
	ld a, [rBGP]
	inc a
	ld [hli], a
	ld a, [rOBP0]
	inc a
	ld [hli], a
	ld a, [rOBP1]
	inc a
	ld [hl], a
	ret
	
.paletteHasNotChanged
	ld a, [hLastOBP0]
	ld b, a
	ld a, [rOBP0]
	cp b ; has the OBP0 changed?
	jr z, .checkOBP1 ; if not, check OBP1
	ld de, wTempOBP0
	call HandleDMGPalettes
.checkOBP1
	ld bc, $8
	add hl, bc
	ld a, [hLastOBP1]
	ld b, a
	ld a, [rOBP1]
	cp b ; has the OBP1 changed?
	jr z, .checkBGP ; if not, move on to bgp
	ld de, wTempOBP1
	call HandleDMGPalettes
.checkBGP
	ld a, [hLastBGP]
	ld b, a
	ld a, [rBGP]
	cp b ; has the BGP changed since the last check?
	ret z ; if not, done
	; store de with buffer
	ld de, wTempBGP
	ld bc, $8
	add hl, bc

; fallthrough
HandleDMGPalettes:
	ld c, 4
.loop
	push hl
	push bc
	push af
	
	and %11 ; get individual shade
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	pop af
	srl a ; get next shade
	srl a
	pop bc
	pop hl
	dec c
	jr nz, .loop
	ret
	
CGBPalettes:
INCLUDE "data/cgb_pals.asm"
