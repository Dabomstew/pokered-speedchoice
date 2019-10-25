sramstatmethod: MACRO
\1::
    ld hl, \1_
    jp SRAMStatsStart
    ENDM
    
    sramstatmethod SRAMStatsFrameCount

SRAMStatsFrameCount_::
    ld hl, sStatsFrameCount
    call FourByteIncrement
    ld hl, sStatsOWFrameCount
    ld a, [hTimerType]
SRAMStatsFourByteIndexCommon::
    sla a
    sla a
    add l
    ld l, a
    jr nc, .noOverflow
    inc h
.noOverflow
    jp FourByteIncrement
	
	sramstatmethod SRAMStatsStepCount
	
SRAMStatsStepCount_::
	ld hl, sStatsStepCount
	call FourByteIncrement
	ld hl, sStatsStepCountWalk
	ld a, [wWalkBikeSurfState]
	jr SRAMStatsFourByteIndexCommon
	
	sramstatmethod SRAMStatsBoughtItem
	sramstatmethod SRAMStatsOtherPurchase
	
SRAMStatsBoughtItem_::
; first record the quantity
	ld hl, sStatsItemsBought
	ld a, [wItemQuantity]
	add [hl]
	ld [hli], a
	jr nc, SRAMStatsOtherPurchase_
	inc [hl]
SRAMStatsOtherPurchase_::
	call ConverthMoneyToBytes
	ld hl, sStatsMoneySpent
SRAMStatsAddMoneyCommon:
	ld de, H_MULTIPLICAND + 2
	ld a, [de]
	add [hl]
	ld [hli], a
	dec de
	ld a, [de]
	adc [hl]
	ld [hli], a
	dec de
	ld a, [de]
	adc [hl]
	ld [hli], a
	ret nc
	inc [hl]
	ret
	
	sramstatmethod SRAMStatsSoldItem
	
SRAMStatsSoldItem_::
; first record the quantity
	ld hl, sStatsItemsSold
	ld a, [wItemQuantity]
	add [hl]
	ld [hli], a
	jr nc, .recordMoney
	inc [hl]
.recordMoney
	ld de, hMoney
	jr SRAMStatsRecordMoneyMade_
	
	sramstatmethod SRAMStatsUsedVendingMachine
	
SRAMStatsUsedVendingMachine_::
; first record the quantity
	ld hl, sStatsItemsBought
	call TwoByteIncrement
	ld de, hVendingMachinePrice
	call ConvertBCDToBytes
	ld hl, sStatsMoneySpent
	jr SRAMStatsAddMoneyCommon
	
	sramstatmethod SRAMStatsBlackedOut
	
SRAMStatsBlackedOut_::
	ld hl, sStatsBlackouts
	call TwoByteIncrement
; record money lost (note this is called BEFORE the game deducts it, so we halve it ourselves)
	ld de, wPlayerMoney
	call ConvertBCDToBytes
	ld hl, H_MULTIPLICAND
	srl [hl]
	inc hl
	rr [hl]
	inc hl
	rr [hl]
; carry now contains the least significant bit of their money
; if it's on, they actually lost $1 more than the halved amount, so do an extra increment in addition to this amount
	jr nc, .addamount
	ld hl, sStatsMoneyLost
	call FourByteIncrement
.addamount
	ld hl, sStatsMoneyLost
	jr SRAMStatsAddMoneyCommon
	
	sramstatmethod SRAMStatsRecordMoneyMade
    
SRAMStatsRecordMoneyMade_::
    call ConvertBCDToBytes
	ld hl, sStatsMoneyMade
	jr SRAMStatsAddMoneyCommon
	
	sramstatmethod SRAMStatsDamageDealt

SRAMStatsDamageDealt_::
; raw damage
	ld hl, sStatsTotalDamageDealt
	ld de, wEnemyMonHP
SRAMStatsDamageCommon:
	ld a, [wDamage + 1]
	add [hl]
	ld [hli], a
	ld a, [wDamage]
	adc [hl]
	ld [hli], a
	jr nc, .actualdamage
	inc [hl]
.actualdamage
	inc hl
	inc hl ; hl now moved to "actual damage" directly after total damage
	ld c, 2
	push hl
	push de
	ld hl, wDamage
	call StringCmp ; tests de < hl
	pop de
	pop hl
	jr c, .record ; carry set means HP < damage so record HP
	ld de, wDamage
.record
	inc de
	ld a, [de]
	add [hl]
	ld [hli], a
	dec de
	ld a, [de]
	adc [hl]
	ld [hli], a
	ret nc
	inc [hl]
	ret
	
	sramstatmethod SRAMStatsDamageTaken

SRAMStatsDamageTaken_::
; raw damage
	ld hl, sStatsTotalDamageTaken
	ld de, wBattleMonHP
	jr SRAMStatsDamageCommon
	
	sramstatmethod SRAMStatsHitCritOHKO
	
SRAMStatsHitCritOHKO_::
; start with hit/miss
	ld a, [H_WHOSETURN]
	and a
	jr z, .checkHit
	ld a, 4
.checkHit
	ld b, a ; store WHOSETURN*4 in b for all the 
	ld a, [wMoveMissed]
	and a
	jr z, .recordHit
	ld a, 2
.recordHit
	ld hl, sStatsOwnMovesHit
	call .incrementHLPlusAPlusB
; none of the others should be recorded if it missed
	and a
	ret nz
; now critical/ohko
	ld a, [wCriticalHitOrOHKO]
	and a
	jr z, .effectiveness ; do nothing if there was no critical hit or successful OHKO
	dec a
	add a
	ld hl, sStatsCriticalsDealt
	call .incrementHLPlusAPlusB
.effectiveness
; gen 1 doesn't have a record of true type effectiveness in ram, so sadly we have to recalculate it
	push bc
	callab StatsGetEffectiveness
	pop bc
	ld a, d
	cp 10
	ret z
	ld a, 0
	jr nc, .recordEff ; super effective
	ld a, 2
.recordEff
	ld hl, sStatsOwnMovesSE
	jp .incrementHLPlusAPlusB
.incrementHLPlusAPlusB
	add b
SRAMStatsIncrementHLPlusA:
	ld e, a
	ld d, 0
	add hl, de
	jp TwoByteIncrement
	
	sramstatmethod SRAMStatsStatMoveHit
	
SRAMStatsStatMoveHit_::
	ld hl, sStatsOwnMovesHit
SRAMStatsStatMoveCommon:
	ld a, [H_WHOSETURN]
	and a
	jr z, .record
	ld a, 4
.record
	jp SRAMStatsIncrementHLPlusA
	
	sramstatmethod SRAMStatsStatMoveMissed
	
SRAMStatsStatMoveMissed_::
	ld hl, sStatsOwnMovesMissed
	jr SRAMStatsStatMoveCommon

    sramstatmethod SRAMStatsIncrement2Byte
    
SRAMStatsIncrement2Byte_::
    ld h, d
    ld l, e
    jp TwoByteIncrement
    
    sramstatmethod SRAMStatsIncrement4Byte
    
SRAMStatsIncrement4Byte_::
    ld h, d
    ld l, e
    jp FourByteIncrement
    
SRAMStatsStart::
; takes return address in hl
; check enable
    ld a, [hStatsDisabled]
    and a
    ret nz
; backup old sram enable state
	ld a, [hSRAMEnabled]
	push af
; enable sram for stat tracking
	ld a, SRAM_ENABLE
	rst SetSRAMEnabled
; backup old sram bank
    ld a, [hSRAMBank]
    push af
	ld a, 1
	ld [MBC1SRamBankingMode], a
; switch to correct bank
    ld a, BANK(sStatsStart)
	rst SetSRAMBank
; done, set return address and move to actual code
; bc is safe to use because Bankswitch already clobbered it
	ld bc, .Return
	push bc
    jp hl
.Return
; restore old sram bank
    pop af
    rst SetSRAMBank
	pop af
	jp SetSRAMEnabled
	
SetupStats::
	ld a, 1
	ld [hStatsDisabled], a
	ld a, SRAM_ENABLE
	rst SetSRAMEnabled
	ld [MBC1SRamBankingMode], a
	ld a, BANK(sStatsStart)
	rst SetSRAMBank
	xor a
	ld hl, sStatsStart
	ld bc, sStatsEnd - sStatsStart
	call ByteFill
; a is still 0, reuse it
	rst SetSRAMEnabled
	ld [hStatsDisabled], a
	ret
    
FourByteIncrement::
; address in hl
    inc [hl]
    ret nz
    inc hl
    inc [hl]
    ret nz
    inc hl
TwoByteIncrement::
    inc [hl]
    ret nz
    inc hl
    inc [hl]
    ret
	
ConverthMoneyToBytes:
	ld de, hMoney
ConvertBCDToBytes:
	; input: de = address of first byte of a 3-byte big-endian BCD number
	; output: 3 byte big-endian money in H_MULTIPLICAND
	ld a, [de]
	call .ConvertByte
	ld c, a
	xor a
	ld hl, H_MULTIPLICAND
	ld [hli], a
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], 100
	push de
	call Multiply
	pop de
	inc de
	ld a, [de]
	call .ConvertByte
	call .AddByteToResult
	ld a, 100
	ld [H_MULTIPLIER], a
	push de
	call Multiply
	pop de
	inc de
	ld a, [de]
	call .ConvertByte
	jp .AddByteToResult
.ConvertByte
	ld b, a
	and $F0
	swap a
	add a
	ld c, a
	add a
	add a
	add c
	ld c, a
	ld a, b
	and $0F
	add c
	ret
.AddByteToResult
	ld hl, H_MULTIPLICAND + 2
	add [hl]
	ld [hld], a
	ret nc
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ret
	
