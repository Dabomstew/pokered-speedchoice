; input de = base of party mon entry
CalculateNonScalingExperience:
	xor a
	ld [H_MULTIPLICAND], a
	ld [H_MULTIPLICAND + 1], a
	push de
	ld a, [wEnemyMonBaseExp]
	ld d, a
	ld a, [wCurrentDivisor]
	ld e, a
	call SingleByteDivide
	ld a, d
	pop de
	ld [H_MULTIPLICAND + 2], a
	ld a, [wEnemyMonLevel]
	ld [H_MULTIPLIER], a
	call Multiply
	ld a, 7
	ld [H_DIVISOR], a
	ld b, 4
	call Divide
	ld hl, wPartyMon1OTID - wPartyMon1
	add hl, de
	ld b, [hl] ; party mon OTID
	inc hl
	ld a, [wPlayerID]
	cp b
	jr nz, .tradedMon
	ld b, [hl]
	ld a, [wPlayerID + 1]
	cp b
	ld a, 0
	jr z, .next
.tradedMon
	call BoostExp ; traded mon exp boost
	ld a, 1
.next
	ld [wGainBoostedExp], a
	ld a, [wIsInBattle]
	dec a ; is it a trainer battle?
	jp nz, BoostExp ; if so, boost exp
	ret
	
; multiplies exp by 1.5
BoostExp:
	ld a, [H_QUOTIENT + 2]
	ld b, a
	ld a, [H_QUOTIENT + 3]
	ld c, a
	srl b
	rr c
	add c
	ld [H_QUOTIENT + 3], a
	ld a, [H_QUOTIENT + 2]
	adc b
	ld [H_QUOTIENT + 2], a
	ret
