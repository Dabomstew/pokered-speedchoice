STATTYPE_2BYTE EQU $1
STATTYPE_4BYTE EQU $2
STATTYPE_MONEY EQU $3
STATTYPE_TIMER EQU $4
STATTYPE_2BYTE_COMPARE EQU $5
STATTYPE_4BYTE_COMPARE EQU $6
NUM_STAT_SCREENS EQUS "(PlaythroughStatsScreensEnd - PlaythroughStatsScreens)/4"

PlaythroughStatsScreen::
	ld a, MUSIC_GAME_CORNER
	call PlayMusic
	xor a
	ld [wOptionsMenuID], a
	ld [wPlayStatsPageType], a
	ld [wPlayerMonStatsSource], a
	ld [wPlayerMonStatsOffset], a
; stop stats (mainly frame counter) actually being counted
	inc a
	ld [wPlayStatsMovesUsedOffset], a
	ld [hStatsDisabled], a
; Open SRAM for stats
	ld a, SRAM_ENABLE
	rst SetSRAMEnabled
	ld a, 1
	ld [MBC1SRamBankingMode], a
	ld a, BANK(sStatsStart)
	rst SetSRAMBank
	ld hl, hInMenu
	ld a, [hl]
	push af
	ld [hl], $1
.pageLoad
	call RetrievePlaythroughStatsConfig
	hlcoord 0, 0
	ld b, 16
	ld c, 18
	call TextBoxBorder
	call UpdateSprites
; render title
	ld hl, wPlayStatsStringPtr
	ld a, [hli]
	ld e, a
	ld d, [hl]
	hlcoord 1, 2
	call PlaceString
	hlcoord 1, 1
	ld de, PlayerStatsString
	call PlaceString
	call RenderStats
; render page display
	hlcoord 1, 16
	ld [hl], "←"
	hlcoord 18, 16
	ld [hl], "→"
	hlcoord 3, 16
	ld de, PSPageStartString
	call PlaceString
	ld a, [wOptionsMenuID]
	inc a
	ld [wBuffer], a
	hlcoord 8, 16
	lb bc, 1, 2
	ld de, wBuffer
	call PrintNumber
	hlcoord 11, 16
	ld de, PSPageOfString
	call PlaceString
	hlcoord 14, 16
	ld a, NUM_STAT_SCREENS
	ld [wBuffer], a
	lb bc, 1, 2
	ld de, wBuffer
	call PrintNumber
.joypad_loop
	ld c, 3
	call DelayFrames
	call Joypad
	ld a, [hJoyPressed]
	ld b, a
	and D_LEFT
	jr nz, .scrollLeft
	ld a, b
	and D_RIGHT
	jr nz, .scrollRight
	ld a, b
	and D_UP | D_DOWN | SELECT
	jr nz, .movesUsedControls
	ld a, b
	and START
	jr z, .joypad_loop
	pop af
	ld [hInMenu], a
	xor a
	ld [hStatsDisabled], a
	ld a, SFX_PURCHASE
	call PlaySound
	call WaitForSoundToFinish
	xor a
	rst SetSRAMEnabled
	ld hl, wSpeedchoiceFlags
	bit HOF_STATS_SCREEN, [hl]
	res HOF_STATS_SCREEN, [hl]
	ld a, $ff
	jp nz, PlaySound
	jp PlayDefaultMusic
.scrollLeft
	ld a, [wOptionsMenuID]
	and a
	jr nz, .decreasePage
	ld a, NUM_STAT_SCREENS
.decreasePage
	dec a
.scrollDone
	ld [wOptionsMenuID], a
	jp .pageLoad
.scrollRight
	ld a, [wOptionsMenuID]
	inc a
	cp NUM_STAT_SCREENS
	jr nz, .scrollDone
	xor a
	jr .scrollDone
.movesUsedControls
	ld a, [wPlayStatsPageType]
	and a
	jr z, .joypad_loop
	dec a
	jr nz, .PokemonStatsControls
	ld a, b
	and D_UP
	jr nz, .goUp
	ld a, b
	and D_DOWN
	jr nz, .goDown
; SELECT: go to metronome
	ld a, (METRONOME - 1)/6*6 + 1
.writeAndReload
	ld [wPlayStatsMovesUsedOffset], a
	jp .pageLoad
.goUp
	ld a, [wPlayStatsMovesUsedOffset]
	sub 6
	jr z, .goToBottom
	jr nc, .writeAndReload
.goToBottom
	ld a, (STRUGGLE - 1)/6*6 + 1
	jr .writeAndReload
.goDown
	ld a, [wPlayStatsMovesUsedOffset]
	add 6
	cp STRUGGLE + 1
	jr c, .writeAndReload
	ld a, 1
	jr .writeAndReload
.PokemonStatsControls
	bit BIT_D_UP, b
	jr nz, .PokemonStatsUp
	bit BIT_D_DOWN, b
	jp z, .joypad_loop
; go down
	ld a, [hJoyHeld]
	and A_BUTTON
	jr nz, .PokemonStatsPageDown
.PokemonStatsSectionDown
	ld a, [wPlayerMonStatsSource]
	and a
	ld b, MONS_PER_BOX
	jr nz, .cont
	ld b, PARTY_LENGTH
.cont
	ld a, [wPlayerMonStatsOffset]
	add 2
	cp b
	jr z, .PokemonStatsPageDown
	ld [wPlayerMonStatsOffset], a
.checkValidDown
	call CheckPokemonStatsPageEmpty
	jp c, .pageLoad
.PokemonStatsPageDown
	ld a, [wPlayerMonStatsSource]
	inc a
	cp NUM_BOXES + 1
	jr nz, .cont2
	xor a
.cont2
	ld [wPlayerMonStatsSource], a
	xor a
	ld [wPlayerMonStatsOffset], a
	jr .checkValidDown
.checkValidUp
	call CheckPokemonStatsPageEmpty
	jp c, .pageLoad
	jr .PokemonStatsSectionUp
.PokemonStatsUp
	ld a, [hJoyHeld]
	and A_BUTTON
	jr nz, .PokemonStatsPageUp
.PokemonStatsSectionUp
	ld a, [wPlayerMonStatsOffset]
	sub 2
	jr c, .PokemonStatsPageUp
	ld [wPlayerMonStatsOffset], a
	jr .checkValidUp
.PokemonStatsPageUp
	ld a, [wPlayerMonStatsSource]
	sub 1
	jr nc, .cont3
	ld a, NUM_BOXES
.cont3
	ld [wPlayerMonStatsSource], a
	and a
	ld a, MONS_PER_BOX - 2
	jr nz, .cont4
	ld a, PARTY_LENGTH - 2
.cont4
	ld [wPlayerMonStatsOffset], a
	jr .checkValidUp

; set carry if the page is not empty, clear carry if empty
CheckPokemonStatsPageEmpty::
	ld a, [wPlayerMonStatsSource]
	and a
	jr nz, .box
; party
	ld a, [wPartyCount]
	ld b, a
	ld a, [wPlayerMonStatsOffset]
	cp b
	ret
.box
	push af
	call ClearUninitializedBoxes
	pop af
	call GetAddressOfBox
	ld a, [hl]
.end
	ld b, a
	ld a, [wPlayerMonStatsOffset]
	cp b
	push af
	ld a, BANK(sStatsStart)
	rst SetSRAMBank
	pop af
	ret
	
GetAddressOfBox:
; a = box number (+1)
	ld b, a
	dec b
	ld a, [wCurrentBoxNum]
	and $7f
	cp b
	jr z, .currentBox
	ld a, b
	cp NUM_BOXES / 2
	ld a, BANK(sBox1)
	ld hl, sBox1
	jr c, .cont
	ld a, -(NUM_BOXES / 2)
	add b
	ld b, a
	ld a, BANK(sBox7)
	ld hl, sBox7
.cont
	rst SetSRAMBank
	ld a, b
	ld bc, wBoxDataEnd - wBoxDataStart
	call AddNTimes
	ret
.currentBox
	ld hl, wNumInBox
	ret
	
ClearUninitializedBoxes:
	ld hl, wCurrentBoxNum
	bit 7, [hl] ; is it the first time player is changing the box?
	ret nz
	set 7, [hl]
	ld a, 2
	rst SetSRAMBank
	callab EmptySRAMBoxesInBank
	ld a, 3
	rst SetSRAMBank
	jpab EmptySRAMBoxesInBank

RenderStats::
; render stats themselves
	ld hl, wPlayStatsConfigPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, h
	cp $fd
	jp z, RenderPokemonStats
	cp $fe
	jp nc, RenderMovesUsed
	xor a
	ld [wPlayStatsStatNum], a
	ld [wPlayStatsPageType], a
.loop
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	or e
	ret z
	push hl
	hlcoord 1, 4
	ld a, [wPlayStatsStatNum]
	sla a
	ld bc, SCREEN_WIDTH
	call AddNTimes
	push hl
	push bc
	call PlaceString
	pop bc
	pop hl
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [hli]
	ld [wStoredJumptableIndex], a
	
	push hl
	cp STATTYPE_2BYTE
	jr nz, .test2bcompare
	call Copy2ByteValueIntoPrintScratch
	jr .donecopying
.test2bcompare
	cp STATTYPE_2BYTE_COMPARE
	jr nz, .test4bcompare
	call Copy2ByteComparesIntoPrintScratch
	jr .donecopying
.test4bcompare
	cp STATTYPE_4BYTE_COMPARE
	jr nz, .do4bcopy
	call Copy4ByteComparesIntoPrintScratch
	jr .donecopying
.do4bcopy
	call Copy4ByteValueIntoPrintScratch
.donecopying
	ld h, d
	ld l, e
	ld a, [wStoredJumptableIndex]
	cp STATTYPE_2BYTE
	jr nz, .check_4byte
; print 2byte
	ld bc, (SCREEN_WIDTH - 1 - 5 - 1)
	add hl, bc
	lb bc, 2, 5
	ld de, wBuffer + 2
	call PrintNumber
	jr .next_loop
.check_4byte
	cp STATTYPE_4BYTE
	jr nz, .check_money
; print 4byte
	ld bc, (SCREEN_WIDTH - 1 - 7 - 1)
	add hl, bc
	lb bc, 3, 7
	ld de, wBuffer + 1
	call PrintNumber
	jr .next_loop
.check_money
	cp STATTYPE_MONEY
	jr nz, .check_2bytecompare
; print money (if only)
	ld bc, (SCREEN_WIDTH - 1 - 8 - 1)
	add hl, bc
	lb bc, (PRINTNUM_MONEY | 3), 7
	ld de, wBuffer + 1
	call PrintNumber
	jr .next_loop
.check_2bytecompare
	cp STATTYPE_2BYTE_COMPARE
	jr nz, .check_4bytecompare
	call Print2ByteCompare
	jr .advance_extra_then_next_loop
.check_4bytecompare
	cp STATTYPE_4BYTE_COMPARE
	jr nz, .print_timer
	call Print4ByteCompare
	jr .advance_extra_then_next_loop
.print_timer
; print timer
	call PrintTimer
.next_loop
	pop hl
.next_loop_nopop
	inc hl
	inc hl
	ld a, [wPlayStatsStatNum]
	inc a
	ld [wPlayStatsStatNum], a
	jp .loop
.advance_extra_then_next_loop
	pop hl
	inc hl
	inc hl
	jr .next_loop_nopop
	
RenderMovesUsed::
	inc a
	ld hl, sStatsEnemyMovesUsed
	jr z, .render
	inc a
	ld hl, sStatsPlayerMovesUsed
.render
; a = 0 when entering
	ld [wPlayStatsStatNum], a
	inc a ; a = 1
	ld [wPlayStatsPageType], a
	xor a
.loop
	cp 6
	ret nc
	ld b, a
	ld a, [wPlayStatsMovesUsedOffset]
	add b
	cp STRUGGLE + 1
	ret nc
	ld [wd11e], a
	push hl
	ld c, a
	ld b, 0
	dec c
	add hl, bc
	add hl, bc
; reverse the stat endianness for PrintNumber
	ld a, [hli]
	ld [wBuffer+1], a
	ld a, [hl]
	ld [wBuffer], a
	call GetMoveName
	hlcoord 1, 4
	ld a, [wPlayStatsStatNum]
	sla a
	ld bc, SCREEN_WIDTH
	call AddNTimes
	push hl
	call PlaceString
	pop hl
	ld bc, SCREEN_WIDTH*2 - 7
	add hl, bc
	ld de, wBuffer
	lb bc, 2, 5
	call PrintNumber
	pop hl
	ld a, [wPlayStatsStatNum]
	inc a
	ld [wPlayStatsStatNum], a
	jr .loop
	
RenderPokemonStats:
	ld a, 2
	ld [wPlayStatsPageType], a
	ld a, [wPlayerMonStatsSource]
	and a
	jr nz, .renderFromBox
; from party
	hlcoord 7, 3
	ld de, PartyString
	call PlaceString
	ld a, [wPlayerMonStatsOffset]
	ld c, a
	ld b, 2
.partyLoop
	ld hl, wPlayerMonStatsOffset
	ld a, c
	sub [hl]
	add a
	ld d, a
	add a
	add d ; *6
	hlcoord 1, 4
	push bc
	ld bc, SCREEN_WIDTH
	call AddNTimes
	pop bc
	ld a, c
	add "1"
	ld [hl], "£"
	inc hl
	ld [hli], a
	inc hl
	ld a, [wPartyCount]
	cp c
	jr z, .skipParty
	jr c, .skipParty
	push hl
	ld hl, wPartyMonNicks
	ld a, c
	push bc
	ld bc, NAME_LENGTH
	call AddNTimes
	pop bc
	ld d, h
	ld e, l
	pop hl
	push hl
	push bc
	call PlaceString
	pop bc
	pop hl
	ld de, SCREEN_WIDTH - 3
	add hl, de
	push hl
	ld hl, wPartyMon1
	ld a, c
	push bc
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	pop bc
	ld d, h
	ld e, l
	pop hl
	call PrintMonStats
	jr .nextParty
.skipParty
	ld de, NoMonString
	push bc
	call PlaceString
	pop bc
.nextParty
	inc c
	dec b
	jr nz, .partyLoop
	ret
.renderFromBox
	hlcoord 7, 3
	ld de, BoxString
	call PlaceString
	hlcoord 11, 3
	ld de, wPlayerMonStatsSource
	lb bc, PRINTNUM_LEFTALIGN | 1, 2
	call PrintNumber
	call ClearUninitializedBoxes
	; from box
	; get wram offset to box data
	ld a, [wPlayerMonStatsSource]
	call GetAddressOfBox
	ld a, l
	ld [wPlayerMonStatsBoxPointer], a
	ld a, h
	ld [wPlayerMonStatsBoxPointer + 1], a
	ld a, [wPlayerMonStatsOffset]
	ld c, a
	ld b, 2
.boxLoop
	ld hl, wPlayerMonStatsOffset
	ld a, c
	sub [hl]
	add a
	ld d, a
	add a
	add d ; *6
	hlcoord 1, 4
	push bc
	ld bc, SCREEN_WIDTH
	call AddNTimes
	pop bc
	ld [hl], "£"
	inc hl
	ld a, c
	push bc
	inc a
	ld [wBuffer], a
	ld de, wBuffer
	lb bc, PRINTNUM_LEFTALIGN | 1, 2
	call PrintNumber
	pop bc
	inc hl
	push hl
	ld hl, wPlayerMonStatsBoxPointer
	rst UnHL
	ld a, [hl]
	cp c
	jr z, .skipBox
	jr c, .skipBox
	ld de, wBoxMonNicks - wBoxDataStart
	add hl, de
	ld a, c
	push bc
	ld bc, NAME_LENGTH
	call AddNTimes
	pop bc
	ld d, h
	ld e, l
	pop hl
	push hl
	push bc
	call PlaceString
	pop bc
	pop hl
	ld a, c
	cp 9
	ld de, SCREEN_WIDTH - 3
	jr c, .add
	ld de, SCREEN_WIDTH - 4
.add
	add hl, de
	push hl
	ld hl, wPlayerMonStatsBoxPointer
	rst UnHL
	ld de, wBoxMons - wBoxDataStart
	add hl, de
	ld a, c
	push bc
	ld bc, wBoxMon2 - wBoxMon1
	call AddNTimes
	pop bc
	ld d, h
	ld e, l
	pop hl
	call PrintMonStats
	jr .nextBox
.skipBox
	pop hl
	ld de, NoMonString
	push bc
	call PlaceString
	pop bc
.nextBox
	inc c
	dec b
	jr nz, .boxLoop
	ld a, BANK(sStatsStart)
	rst SetSRAMBank
	ret
	
PartyString:
	db "PARTY@"

BoxString:
	db "BOX @"

NoMonString:
	db "NO #MON@"
	
PrintMonStats:
	push bc
	push de
	ld de, StatsTemplate
	push hl
	call PlaceString
	pop hl
	pop de
	ld bc, 4
	add hl, bc
	push hl
	ld hl, wPartyMon1DVs - wPartyMon1
	add hl, de
	ld a, [hli]
	ld b, a
	ld c, [hl]
	pop hl
	push bc
	swap b
	call PrintHexDigit
	swap b
	call PrintHexDigit
	ld b, c
	swap b
	call PrintHexDigit
	swap b
	call PrintHexDigit
	pop bc
; calc hp dv
	xor a
	bit 4, b
	jr z, .noAtk
	add 8
.noAtk
	bit 0, b
	jr z, .noDef
	add 4
.noDef
	bit 4, c
	jr z, .noSpd
	add 2
.noSpd
	bit 0, c
	jr z, .noSpc
	inc a
.noSpc
	inc hl
	inc hl
	call PrintDV
	ld a, b
	swap a
	and $0F
	call PrintDV
	push bc
	ld bc, 8
	add hl, bc
	pop bc
	ld a, b
	and $0F
	call PrintDV
	ld a, c
	swap a
	and $0F
	call PrintDV
	ld a, c
	and $0F
	call PrintDV
; evs
	push hl
	ld hl, wPartyMon1HPExp - wPartyMon1
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld bc, 7
	add hl, bc
	call PrintStatEXP
	ld bc, 13
	add hl, bc
	call PrintStatEXP
	call PrintStatEXP
	ld bc, 6
	add hl, bc
	call PrintStatEXP
	call PrintStatEXP
	pop bc
	ret
	
PrintStatEXP:
	push de
	lb bc, 2, 5
	call PrintNumber
	pop de
	inc de
	inc de
	inc hl
	inc hl
	ret
	
PrintDV:
	inc hl
	inc hl
	push de
	push bc
	ld [wBuffer], a
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	ld de, wBuffer
	call PrintNumber
	pop bc
	pop de
	ret

PrintHexDigit:
	ld a, b
	and $0F
	add "0"
	or $80
	ld [hli], a
	ret
	
DVsString:
	db "DVs @"
	
StatsTemplate:
	db "DVs XXXX / Hxx Axx<LNBRK>"
	db "       Dxx Sxx Cxx<LNBRK>"
	db "SXP H     <LNBRK>"
	db "    A      D     <LNBRK>"
	db "    S      C     @"
	
Print2ByteCompare:
	ld bc, SCREEN_WIDTH - 3
	add hl, bc
	ld [hl], ")"
	ld bc, -5
	add hl, bc
	lb bc, 2, 5
	ld de, wBuffer + 2
	call PrintNumber
.find_blank
	ld a, [hld]
	cp " "
	jr nz, .find_blank
	inc hl
	ld [hl], "("
	ld bc, -6
	add hl, bc
	lb bc, 2, 5
	ld de, wBuffer
	call PrintNumber
	ret
	
Print4ByteCompare:
	ld bc, SCREEN_WIDTH - 3
	add hl, bc
	ld [hl], ")"
	ld bc, -7
	add hl, bc
	lb bc, 3, 7
	ld de, wBuffer + 5
	call PrintNumber
.find_blank
	ld a, [hld]
	cp " "
	jr nz, .find_blank
	inc hl
	ld [hl], "("
	ld bc, -8
	add hl, bc
	lb bc, 3, 7
	ld de, wBuffer + 1
	call PrintNumber
	ret
	
PrintTimer:
; frames/milliseconds part
; use 4/239 as a better approximation for gbc framerate than 1/60
rept 2
	ld a, [wBuffer + 3]
	sla a
	ld [wBuffer + 3], a
	ld a, [wBuffer + 2]
	rl a
	ld [wBuffer + 2], a
	ld a, [wBuffer + 1]
	rl a
	ld [wBuffer + 1], a
	ld a, [wBuffer]
	rl a
	ld [wBuffer], a
endr
; copy wBuffer-4 into dividend
	ld a, [wBuffer]
	ld [H_DIVIDEND], a
	ld a, [wBuffer + 1]
	ld [H_DIVIDEND+1], a
	ld a, [wBuffer + 2]
	ld [H_DIVIDEND+2], a
	ld a, [wBuffer + 3]
	ld [H_DIVIDEND+3], a
; divide by 239
	ld a, 239
	ld [H_DIVISOR], a
	ld b, 4
	call Divide
; backup the result (seconds) for now
	ld a, [H_QUOTIENT]
	push af
	ld a, [H_QUOTIENT+1]
	push af
	ld a, [H_QUOTIENT+2]
	push af
	ld a, [H_QUOTIENT+3]
	push af
; multiply remainder (1/239ths of a second) by 100 then divide by 239 to approximate centiseconds
; hRemainder == hMultiplier so skip copying that
	xor a
	ld [H_MULTIPLICAND], a
	ld [H_MULTIPLICAND+1], a
	ld a, 100
	ld [H_MULTIPLICAND+2], a
	call Multiply
; divide by 239 to get a rough cs value
	ld a, 239
	ld [H_DIVISOR], a
	ld b, 4
	call Divide
; move the result elsewhere since PrintNumber uses the same hram
	ld a, [H_QUOTIENT+3]
	ld [wBuffer], a
; print the result (ms)
	ld bc, (SCREEN_WIDTH - 1 - 2 - 1)
	add hl, bc
	lb bc, (PRINTNUM_LEADINGZEROS | 1), 2
	ld de, wBuffer
	call PrintNumber
; now for seconds onwards
; from here on out we just straight up print either the quotient or the remainder
; start by restoring the quotient
	pop af
	ld [H_QUOTIENT+3], a
	pop af
	ld [H_QUOTIENT+2], a
	pop af
	ld [H_QUOTIENT+1], a
	pop af
	ld [H_QUOTIENT], a
; divide by 60 again for seconds
	ld a, 60
	ld [H_DIVISOR], a
	ld b, 4
	call Divide
; backup the result again since PrintNumber and multiply/divide share memory
	ld a, [H_QUOTIENT+1]
	push af
	ld a, [H_QUOTIENT+2]
	push af
	ld a, [H_QUOTIENT+3]
	push af
; move the printed number elsewhere
	ld a, [H_REMAINDER]
	ld [wBuffer], a
; print seconds
	ld bc, -5
	add hl, bc
	lb bc, (PRINTNUM_LEADINGZEROS | 1), 2
	ld de, wBuffer
	call PrintNumber
	ld [hl], "."
; restore result
	pop af
	ld [H_QUOTIENT+3], a
	pop af
	ld [H_QUOTIENT+2], a
	pop af
	ld [H_QUOTIENT+1], a
	xor a
	ld [H_QUOTIENT], a
; divide by 60 again for minutes
	ld a, 60
	ld [H_DIVISOR], a
	ld b, 4
	call Divide
; move the result elsewhere
	ld a, [H_REMAINDER]
	ld [wBuffer], a
	ld a, [H_QUOTIENT+2]
	ld [wBuffer + 1], a
	ld a, [H_QUOTIENT+3]
	ld [wBuffer + 2], a
; print minutes from wBuffer
	ld bc, -5
	add hl, bc
	lb bc, (PRINTNUM_LEADINGZEROS | 1), 2
	ld de, wBuffer
	call PrintNumber
	ld [hl], ":"
; print hours from wBuffer + 1-3
	ld bc, -8
	add hl, bc
	lb bc, 2, 5
	ld de, wBuffer + 1
	call PrintNumber
	ld [hl], ":"
	ret
	
	
Copy2ByteValueIntoPrintScratch:
	xor a
	ld [wBuffer], a
	ld [wBuffer + 1], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [wBuffer + 3], a
	ld a, [hl]
	ld [wBuffer + 2], a
	ret

Copy4ByteValueIntoPrintScratch:
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [wBuffer + 3], a
	ld a, [hli]
	ld [wBuffer + 2], a
	ld a, [hli]
	ld [wBuffer + 1], a
	ld a, [hl]
	ld [wBuffer], a
	ld hl, wBuffer
	jp Cap4ByteValue
	ret
	
; cap 4 byte value at hl to 9999999 because that's all the space we give it on screen
Cap4ByteValue:
	ld a, [hli]
	and a
	jr nz, .cap
	ld a, [hli]
	cp 9999999 / $10000
	ret c
	jr nz, .cap2
	ld a, [hli]
	cp (9999999 / $100) & $ff
	ret c
	jr nz, .cap3
	ld a, [hl]
	cp 9999999 & $ff
	ret c
	ret z
.cap3
	dec hl
.cap2
	dec hl
.cap
	dec hl
	xor a
	ld [hli], a
	ld a, 9999999 / $10000
	ld [hli], a
	ld a, (9999999 / $100) & $ff
	ld [hli], a
	ld [hl], 9999999 & $ff
	ret
	
Copy2ByteComparesIntoPrintScratch:
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [wBuffer + 1], a
	ld a, [hl]
	ld [wBuffer], a
	pop hl
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [wBuffer + 3], a
	ld a, [hl]
	ld [wBuffer + 2], a
	ret
	
Copy4ByteComparesIntoPrintScratch:
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [wBuffer + 3], a
	ld a, [hli]
	ld [wBuffer + 2], a
	ld a, [hli]
	ld [wBuffer + 1], a
	ld a, [hl]
	ld [wBuffer], a
	pop hl
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [wBuffer + 7], a
	ld a, [hli]
	ld [wBuffer + 6], a
	ld a, [hli]
	ld [wBuffer + 5], a
	ld a, [hl]
	ld [wBuffer + 4], a
	ld hl, wBuffer
	call Cap4ByteValue
	ld hl, wBuffer + 4
	jp Cap4ByteValue
	
	
	
RetrievePlaythroughStatsConfig::
	ld a, [wOptionsMenuID]
	ld hl, PlaythroughStatsScreens
	ld bc, wPlayStatsConfigEnds - wPlayStatsStringPtr
	call AddNTimes
	ld de, wPlayStatsStringPtr
	jp CopyData
	
stat_screen: MACRO
	dw (\1) ; title string
	dw (\2) ; pointer to config for entries on this page
ENDM

stat_screen_entry: MACRO
	dw (\1) ; description string
	db (\2) ; data type
	dw (\3) ; sram address
if \2 >= STATTYPE_2BYTE_COMPARE
	dw (\4) ; second sram address
endc
ENDM
	
PlaythroughStatsScreens::
	stat_screen PSTimersTitleString, PSTimersConfig
	stat_screen PSMovementTitleString, PSMovementConfig
	stat_screen PSBattle1TitleString, PSBattle1Config
	stat_screen PSBattle2TitleString, PSBattle2Config
	stat_screen PSBattle3TitleString, PSBattle3Config
	stat_screen PSBattle4TitleString, PSBattle4Config
	stat_screen PSMoneyItemsTitleString, PSMoneyItemsConfig
	stat_screen PSMiscTitleString, PSMiscConfig
	stat_screen PSPokemonStatsTitleString, $FD00
	stat_screen PSPlayerMovesTitleString, $FE00
	stat_screen PSEnemyMovesTitleString, $FF00
PlaythroughStatsScreensEnd::
	
PSTimersConfig::
	stat_screen_entry PSTimersOverallString, STATTYPE_TIMER, sStatsFrameCount
	stat_screen_entry PSTimersOverworldString, STATTYPE_TIMER, sStatsOWFrameCount 
	stat_screen_entry PSTimersBattleString, STATTYPE_TIMER, sStatsBattleFrameCount
	stat_screen_entry PSTimersMenuString, STATTYPE_TIMER, sStatsMenuFrameCount
	stat_screen_entry PSTimersIntroString, STATTYPE_TIMER, sStatsIntrosFrameCount
	dw 0 ; end
	
PSMovementConfig::
	stat_screen_entry PSMovementTotalStepsString, STATTYPE_4BYTE, sStatsStepCount
	stat_screen_entry PSMovementStepsWalkedString, STATTYPE_4BYTE, sStatsStepCountWalk
	stat_screen_entry PSMovementStepsBikedString, STATTYPE_4BYTE, sStatsStepCountBike
	stat_screen_entry PSMovementStepsSurfedString, STATTYPE_4BYTE, sStatsStepCountSurf
	stat_screen_entry PSMovementBonksString, STATTYPE_2BYTE, sStatsBonks
	dw 0 ; end
	
PSBattle1Config::
	stat_screen_entry PSBattle1TotalBattlesString, STATTYPE_2BYTE, sStatsBattles
	stat_screen_entry PSBattle1WildBattlesString, STATTYPE_2BYTE, sStatsWildBattles
	stat_screen_entry PSBattle1TrainerBattlesString, STATTYPE_2BYTE, sStatsTrainerBattles
	stat_screen_entry PSBattle1BattlesFledFromString, STATTYPE_2BYTE, sStatsBattlesFled
	stat_screen_entry PSBattle1FailedEscapesString, STATTYPE_2BYTE, sStatsFailedRuns
	dw 0 ; end
	
PSBattle2Config::
	stat_screen_entry PSBattle2EnemyPKMNFaintedString, STATTYPE_2BYTE, sStatsEnemyPokemonFainted
	stat_screen_entry PSBattle2EXPGainedString, STATTYPE_4BYTE, sStatsExperienceGained
	stat_screen_entry PSBattle2OwnPKMNFaintedString, STATTYPE_2BYTE, sStatsPlayerPokemonFainted
	stat_screen_entry PSBattle2SwitchoutsString, STATTYPE_2BYTE, sStatsSwitchouts
	stat_screen_entry PSBattle2BallsThrownString, STATTYPE_2BYTE, sStatsBallsThrown
	stat_screen_entry PSBattle2PokemonCaughtString, STATTYPE_2BYTE, sStatsPokemonCaughtInBalls
	dw 0 ; end
	
PSBattle3Config::
	stat_screen_entry PSBattle3MovesHitString, STATTYPE_2BYTE_COMPARE, sStatsOwnMovesHit, sStatsEnemyMovesHit
	stat_screen_entry PSBattle3MovesMissedString, STATTYPE_2BYTE_COMPARE, sStatsOwnMovesMissed, sStatsEnemyMovesMissed
	stat_screen_entry PSBattle3SEMovesString, STATTYPE_2BYTE_COMPARE, sStatsOwnMovesSE, sStatsEnemyMovesSE
	stat_screen_entry PSBattle3NVEMovesString, STATTYPE_2BYTE_COMPARE, sStatsOwnMovesNVE, sStatsEnemyMovesNVE
	stat_screen_entry PSBattle3CriticalsDealtString, STATTYPE_2BYTE_COMPARE, sStatsCriticalsDealt, sStatsCriticalsTaken
	stat_screen_entry PSBattle3OHKOsDealtString, STATTYPE_2BYTE_COMPARE, sStatsOHKOsDealt, sStatsOHKOsTaken
	dw 0
	
PSBattle4Config::
	stat_screen_entry PSBattle4TotalDmgDealtString, STATTYPE_4BYTE_COMPARE, sStatsTotalDamageDealt, sStatsActualDamageDealt
	stat_screen_entry PSBattle4TotalDmgTakenString, STATTYPE_4BYTE_COMPARE, sStatsTotalDamageTaken, sStatsActualDamageTaken
	dw 0
	
PSMoneyItemsConfig::
	stat_screen_entry PSMIMoneyMadeString, STATTYPE_MONEY, sStatsMoneyMade
	stat_screen_entry PSMIMoneySpentString, STATTYPE_MONEY, sStatsMoneySpent
	stat_screen_entry PSMIMoneyLostString, STATTYPE_MONEY, sStatsMoneyLost
	stat_screen_entry PSMIItemsPickedUpString, STATTYPE_2BYTE, sStatsItemsPickedUp
	stat_screen_entry PSMIItemsBoughtString, STATTYPE_2BYTE, sStatsItemsBought
	stat_screen_entry PSMIItemsSoldString, STATTYPE_2BYTE, sStatsItemsSold
	dw 0
	
PSMiscConfig::
	stat_screen_entry PSMiscSavesString, STATTYPE_2BYTE, sStatsSaveCount
	stat_screen_entry PSMiscReloadsString, STATTYPE_2BYTE, sStatsReloadCount
	dw 0
	
PlayerStatsString:
	db "   PLAYER STATS@"
	
PSTimersTitleString:
	db "      TIMERS@"
PSTimersOverallString:
	db "TOTAL TIME:@"
PSTimersOverworldString:
	db "OVERWORLD TIME:@"
PSTimersBattleString:
	db "TIME IN BATTLE:@"
PSTimersMenuString:
	db "TIME IN MENUS:@"
PSTimersIntroString:
	db "TIME IN INTROS:@"
	
PSMovementTitleString:
	db "     MOVEMENT@"
PSMovementTotalStepsString:
	db "TOTAL STEPS:@"
PSMovementStepsWalkedString:
	db "STEPS WALKED:@"
PSMovementStepsBikedString:
	db "STEPS BIKED:@"
PSMovementStepsSurfedString:
	db "STEPS SURFED:@"
PSMovementBonksString:
	db "BONKS:@"
	
PSBattle1TitleString:
	db "     BATTLE 1@"
PSBattle1TotalBattlesString:
	db "TOTAL BATTLES:@"
PSBattle1WildBattlesString:
	db "WILD BATTLES:@"
PSBattle1TrainerBattlesString:
	db "TRAINER BATTLES:@"
PSBattle1BattlesFledFromString:
	db "BATTLES FLED FROM:@"
PSBattle1FailedEscapesString:
	db "FAILED ESCAPES:@"
	
PSBattle2TitleString:
	db "     BATTLE 2@"
PSBattle2EnemyPKMNFaintedString:
	db "ENEMY <PK><MN> FAINTED:@"
PSBattle2EXPGainedString:
	db "EXP. GAINED:@"
PSBattle2OwnPKMNFaintedString:
	db "OWN <PK><MN> FAINTED:@"
PSBattle2SwitchoutsString:
	db "NUM. SWITCHOUTS:@"
PSBattle2BallsThrownString:
	db "BALLS THROWN:@"
PSBattle2PokemonCaughtString:
	db "<PK><MN> CAPTURED:@"
	
PSBattle3TitleString:
	db "     BATTLE 3@"

PSBattle3MovesHitString:
	db "MOVES HIT (BY):@"
PSBattle3MovesMissedString:
	db "MOVES MISSED:@"
PSBattle3SEMovesString:
	db "S.E. MOVES USED:@"
PSBattle3NVEMovesString:
	db "N.V.E. MOVES USED:@"
PSBattle3CriticalsDealtString:
	db "CRITICAL HITS:@"
PSBattle3OHKOsDealtString:
	db "OHKOs:@"
	
PSBattle4TitleString:
	db "     BATTLE 4@"
PSBattle4TotalDmgDealtString:
	db "DAMAGE DEALT:@"
PSBattle4TotalDmgTakenString:
	db "DAMAGE TAKEN:@"
	
PSMoneyItemsTitleString:
	db "  MONEY & ITEMS@"
PSMIMoneyMadeString:
	db "MONEY MADE:@"
PSMIMoneySpentString:
	db "MONEY SPENT:@"
PSMIMoneyLostString:
	db "MONEY LOST:@"
PSMIItemsPickedUpString:
	db "ITEMS PICKED UP:@"
PSMIItemsBoughtString:
	db "ITEMS BOUGHT:@"
PSMIItemsSoldString:
	db "ITEMS SOLD:@"
	
	
PSMiscTitleString:
	db "      MISC.@"
PSMiscSavesString:
	db "TIMES SAVED:@"
PSMiscReloadsString:
	db "SAVE RELOADS:@"
	
PSPlayerMovesTitleString:
	db "PLAYER MOVES USED@"
PSEnemyMovesTitleString:
	db " ENEMY MOVES USED@"
	
PSPokemonStatsTitleString:
	db "  PLAYER <pkmn> INFO@"

PSPageStartString:
	db "PAGE@"
PSPageOfString:
	db "OF@"
