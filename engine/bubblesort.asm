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
	ld a, STRUGGLE - 1
	ld [hBubbleSortInitialC], a
.bubbleSortLoop
	ld hl, $d004
	ld de, $d001
	ld c, a
	ld b, 0
.swapLoop
	push hl
	ld a, [de]
	cp [hl]
	jr c, .doSwapInc
	jr nz, .doneCycle
; maybe swap
	inc de
	inc hl
	ld a, [de]
	cp [hl]
	jr c, .doSwap
.doneCycle
	pop de
	ld hl, $3
	add hl, de
	dec c
	jr nz, .swapLoop
	ld a, b
	and a
	jr z, .done
	ld a, [hBubbleSortInitialC]
	sub b
	ld [hBubbleSortInitialC], a
	jr .bubbleSortLoop
; done - copy the result to sSpriteBuffer0
.done
	ld a, BANK(sSpriteBuffer0)
	rst SetSRAMBank
	ld hl, $d000
	ld de, sSpriteBuffer0
	ld bc, STRUGGLE*3
	call CopyData
	ld a, BANK(sStatsStart)
	rst SetSRAMBank
	xor a
	ld [rSVBK], a
	ld [rIF], a
	reti
.doSwapInc
	inc hl
.doSwap
	ld d, h
	ld e, l
	ld a, [hld]
	ld [hSortTemp+2], a
	ld a, [hld]
	ld [hSortTemp+1], a
	ld a, [hld]
	ld [hSortTemp], a
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
	ld b, c
	jr .doneCycle
	

	