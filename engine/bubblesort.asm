BubbleSortMovesUsed::
	di
	ld a, 3
	ld [rSVBK], a
; create the initial list, assuming the pointer to the moves used list we want to sort is at de
; it's easier to swap these to big endian at the same time as well
	ld hl, $d002
	ld b, 1
	ld c, STRUGGLE
.createLoop
	ld a, [de]
	ld [hld], a
	inc de
	ld a, [de]
	ld [hld], a
	inc de
	ld a, b
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	inc b
	dec c
	jr nz, .createLoop
; with the initial list made, now we bubble sort it
; the order we want is [hl] < [de]

.bubbleSortLoop
	ld hl, $d004
	ld de, $d001
	ld c, STRUGGLE - 1
	ld b, 0
.swapLoop
	ld a, [de]
	cp [hl]
	jr c, .doSwapInc
	jr nz, .doneCycleInc
; maybe swap
	inc de
	inc hl
	ld a, [de]
	cp [hl]
	jr c, .doSwap
	jr .doneCycle
.doneCycleInc
	inc de
	inc hl
.doneCycle
	inc de
	inc de
	inc hl
	inc hl
	dec c
	jr nz, .swapLoop
	ld a, b
	and a
	jr nz, .bubbleSortLoop
; done - copy the result to sSpriteBuffer0
	ld a, BANK(sSpriteBuffer0)
	rst SetSRAMBank
	ld hl, $d000
	ld de, sSpriteBuffer0
	ld bc, STRUGGLE*3
	call CopyData
	xor a
	ld [rSVBK], a
	ld a, BANK(sStatsStart)
	rst SetSRAMBank
	reti
.doSwapInc
	inc de
	inc hl
.doSwap
	ld a, [de]
	ld [hSortTemp+2], a
	dec de
	ld a, [de]
	ld [hSortTemp+1], a
	dec de
	ld a, [de]
	ld [hSortTemp], a
	inc de
	inc de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	ld a, [hSortTemp]
	ld [hli], a
	ld a, [hSortTemp+1]
	ld [hli], a
	ld a, [hSortTemp+2]
	ld [hl], a
	inc de
	inc de
	ld b, 1
	jr .doneCycle
	

	