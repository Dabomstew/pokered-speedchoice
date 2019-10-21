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
    sla a
    sla a
    add l
    ld l, a
    jr nc, .noOverflow
    inc h
.noOverflow
    call FourByteIncrement
    jp SRAMStatsEnd

    sramstatmethod SRAMStatsIncrement2Byte
    
SRAMStatsIncrement2Byte_::
    ld h, d
    ld l, e
    call TwoByteIncrement
    jp SRAMStatsEnd
    
    sramstatmethod SRAMStatsIncrement4Byte
    
SRAMStatsIncrement4Byte_::
    ld h, d
    ld l, e
    call FourByteIncrement
    jp SRAMStatsEnd
    
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
; done, move to actual code
    jp hl
    
SRAMStatsEnd::
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
