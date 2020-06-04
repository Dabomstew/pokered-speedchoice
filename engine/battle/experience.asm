GainExperience:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z ; return if link battle
	; kill immediately if no exp
	mboptioncheck EXP_FORMULA, NO_EXP
	ret z
	call CalculateEXPGainDivisors
; give exp to each participant exp divisors and shared exp divisors, this code requires them to be adjacent in WRAM
	ld de, wParticipantEXPDivisors
.outerLoop
	ld hl, wPartyMon1
	ld c, PARTY_LENGTH
	ld b, 0
.giveLoop
	ld a, [de]
	and a
	jp z, .nextRecipientNoPop
	ld [wCurrentDivisor], a
	ld a, b
	ld [wWhichPokemon], a
; give exp and stat exp
	push bc
	push de
	push hl
; stat exp stuff
	ld de, (wPartyMon1HPExp + 1) - (wPartyMon1)
	add hl, de
	ld d, h
	ld e, l
	ld hl, wEnemyMonBaseStats
	ld c, NUM_STATS
.gainStatExpLoop
	push de
	ld a, [hli]
	ld d, a ; enemy mon base stat
	ld a, [wCurrentDivisor]
	ld e, a
	call SingleByteDivide
	ld b, d
	pop de
	ld a, [de] ; stat exp
	add b ; add result to exp
	ld [de], a
	jr nc, .nextBaseStat
; if there was a carry, increment the upper byte
	dec de
	ld a, [de]
	inc a
	jr z, .maxStatExp ; jump if the value overflowed
	ld [de], a
	inc de
	jr .nextBaseStat
.maxStatExp ; if the upper byte also overflowed, then we have hit the max stat exp
	dec a ; a = $ff
	ld [de], a
	inc de
	ld [de], a
.nextBaseStat
	dec c
	jr z, .statExpDone
	inc de
	inc de
	jr .gainStatExpLoop
.statExpDone
	pop de ; base of party entry, was pushed from hl earlier
	push de ; store it back for the loop
	mboptioncheck EXP_FORMULA, BLACKWHITE
	jr z, .doBW
	call CalculateNonScalingExperienceGain
	jr .continue
.doBW
	call CalculateScalingExperienceGain
.continue
; add the gained exp to the party mon's exp
	pop de ; base of party entry, was pushed from hl earlier
	push de ; store it back for the loop
	ld hl, (wPartyMon1Exp + 2 - wPartyMon1)
	add hl, de
	ld b, [hl]
	ld a, [H_PRODUCT + 3]
	ld [wExpAmountGained + 2], a
	add b
	ld [hld], a
	ld b, [hl]
	ld a, [H_PRODUCT + 2]
	ld [wExpAmountGained + 1], a
	adc b
	ld [hld], a
	ld b, [hl]
	ld a, [H_PRODUCT + 1]
	ld [wExpAmountGained], a
	adc b
	ld [hl], a
	jr nc, .expNotMaxedOut
; if we overflowed the most significant byte then EXP is obviously maxed out, so reset it to the cap for this mon
	call CalcMaxExperience
	jr .writeExperience
; if exp isn't obviously maxed out, we should now compare the actual value to the cap for this mon
.expNotMaxedOut
	inc hl
	inc hl
	call CalcMaxExperience
; compare max exp with current exp
	ld a, [hld]
	sub d
	ld a, [hld]
	sbc c
	ld a, [hl]
	sbc b
	jr c, .next2
; the mon's exp is greater than the max exp, so overwrite it with the max exp
.writeExperience
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hld], a
	dec hl
.next2
; print text
	push hl
; must always load name in case of gaining level
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld a, [wBoostExpByExpAll]
	and a
	jr z, .printIndividual
	ld a, [EXP_SPLITTING_ADDRESS]
	and EXP_SPLITTING_MASK
	jr z, .printIndividual
	ld a, [wPrintedShareText]
	and a
	jr nz, .afterPrinting
	inc a
	ld [wPrintedShareText], a
	ld hl, GainedWithShareText
	call PrintText
	jr .afterPrinting
.printIndividual
	ld hl, GainedText
	call PrintText
.afterPrinting
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	call LoadMonData
	pop hl
	ld bc, wPartyMon1Level - wPartyMon1Exp
	add hl, bc
	push hl
	callba CalcLevelFromExperience
	pop hl
	ld a, [hl] ; current level
	ld [wTempLevel], a ; store current level
	cp d
	jp z, .nextRecipient ; if level didn't change, go to next mon
	ld a, [wCurEnemyLVL]
	push af
	push hl
	ld a, d
	ld [wCurEnemyLVL], a
	ld [hl], a
	ld bc, wPartyMon1Species - wPartyMon1Level
	add hl, bc
	ld a, [hl] ; species
	ld [wd0b5], a
	ld [wd11e], a
	call GetMonHeader
	ld bc, (wPartyMon1MaxHP + 1) - wPartyMon1Species
	add hl, bc
	push hl
	ld a, [hld]
	ld c, a
	ld b, [hl]
	push bc ; push max HP (from before levelling up)
	ld d, h
	ld e, l
	ld bc, (wPartyMon1HPExp - 1) - wPartyMon1MaxHP
	add hl, bc
	ld b, $1 ; consider stat exp when calculating stats
	call CalcStats
	pop bc ; pop max HP (from before levelling up)
	pop hl
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	ld b, a ; bc = difference between old max HP and new max HP after levelling
	ld de, (wPartyMon1HP + 1) - wPartyMon1MaxHP
	add hl, de
; add to the current HP the amount of max HP gained when levelling
	ld a, [hl] ; wPartyMon1HP + 1
	add c
	ld [hld], a
	ld a, [hl] ; wPartyMon1HP + 1
	adc b
	ld [hl], a ; wPartyMon1HP
	ld a, [wPlayerMonNumber]
	ld b, a
	ld a, [wWhichPokemon]
	cp b ; is the current mon in battle?
	jr nz, .printGrewLevelText
; current mon is in battle
	ld de, wBattleMonHP
; copy party mon HP to battle mon HP
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
; copy other stats from party mon to battle mon
	ld bc, wPartyMon1Level - (wPartyMon1HP + 1)
	add hl, bc
	push hl
	ld de, wBattleMonLevel
	ld bc, 1 + NUM_STATS * 2 ; size of stats
	call CopyData
	pop hl
	ld a, [wPlayerBattleStatus3]
	bit 3, a ; is the mon transformed?
	jr nz, .recalcStatChanges
; the mon is not transformed, so update the unmodified stats
	ld de, wPlayerMonUnmodifiedLevel
	ld bc, 1 + NUM_STATS * 2
	call CopyData
.recalcStatChanges
	xor a ; battle mon
	ld [wCalculateWhoseStats], a
	callab CalculateModifiedStats
	callab ApplyBurnAndParalysisPenaltiesToPlayer
	callab ApplyBadgeStatBoosts
	callab DrawPlayerHUDAndHPBar
	callab PrintEmptyString
.printGrewLevelText
	ld hl, GrewLevelText
	call PrintText
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	call LoadMonData
	call SaveScreenTilesToBuffer1
	ld hl, wOAMBuffer
	ld bc, 160
	ld de, wTempOAMBuffer
	call CopyData
	call HideSprites
	ld d, $1
	callab PrintStatsBox
	call WaitForTextScrollButtonPress
	call LoadScreenTilesFromBuffer1
	ld hl, wTempOAMBuffer
	ld bc, 160
	ld de, wOAMBuffer
	call CopyData
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	ld a, [wd0b5]
	ld [wd11e], a
	sboptioncheck DONT_SKIP_MOVES
	jr z, .lastLevel
	ld a, [wTempLevel]
	ld b, a
	ld a, [wCurEnemyLVL]
	ld c, a
.level_loop
	inc b
	ld a, b
	ld [wCurEnemyLVL], a
	cp c
	jr z, .lastLevel
	push bc
	predef LearnMoveFromLevelUp
	pop bc
	jr .level_loop
.lastLevel
	predef LearnMoveFromLevelUp
	ld hl, wCanEvolveFlags
	ld a, [wWhichPokemon]
	ld c, a
	ld b, FLAG_SET
	predef FlagActionPredef
	pop hl
	pop af
	ld [wCurEnemyLVL], a
.nextRecipient
	pop hl
	pop de
	pop bc
.nextRecipientNoPop
	inc de
	push bc
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	pop bc
	inc b
	dec c
	jp nz, .giveLoop
	ld a, [wBoostExpByExpAll]
	and a
	ret nz
	inc a
	ld [wBoostExpByExpAll], a
	jp .outerLoop

; calc max experience for current mon and load it into bcd
CalcMaxExperience:
	push hl
	ld a, [wWhichPokemon]
	ld c, a
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl] ; species
	ld [wd0b5], a
	call GetMonHeader
	ld d, MAX_LEVEL
	callab CalcExperience ; get max exp
	ld a, [hExperience]
	ld b, a
	ld a, [hExperience + 1]
	ld c, a
	ld a, [hExperience + 2]
	ld d, a
	pop hl
	ret

; divide d by e; quotient in d, remainder in a
SingleByteDivide:
; check for fast exit if e=1; worth it given how often the divisor will be 1 for this code
	ld a, e
	dec a
	ret z
	xor a
	ld b, 8
.loop
	sla d
	rla
	cp e
	jr c, .dontsubinc
	sub e
	inc d
.dontsubinc
	dec b
	jr nz, .loop
	ret

CalculateEXPGainDivisors:
	ld bc, wEXPCalcsEnd - wHasExpAll
	ld hl, wHasExpAll
	xor a
	call ByteFill
	ld b, EXP_ALL
	call IsItemInBag
	ld a, 0
	jr z, .write
	inc a
.write
	ld [wHasExpAll], a
	ld a, [wPartyGainExpFlags]
	ld b, 0
	ld c, PARTY_LENGTH
.countSetBitsLoop ; loop to count set bits in wPartyGainExpFlags
	srl a
	jr nc, .next
	inc b
.next
	dec c
	jr nz, .countSetBitsLoop
	ld a, b
	ld [wParticipantCount], a
; what behavior do we actually have?
; vanilla = upper bit cleared, gen6+ = upper bit set
; vanilla = divide by number of participants and by a further 2 if no exp share, gen6+ = all participants get full exp
	ld a, [EXP_SPLITTING_ADDRESS]
	bit EXP_SPLITTING_SHIFT + 1, a
	ld a, 1
	jr nz, .setBaseValue
	ld a, [wParticipantCount]
	ld b, a
	ld a, [wHasExpAll]
	and a
	ld a, b
	jr z, .setBaseValue
	sla a
.setBaseValue
	ld b, a
	ld d, PARTY_LENGTH
	ld a, [wPartyGainExpFlags]
	ld e, a
	ld a, b
	ld hl, wParticipantEXPDivisors
.participantLoop
	srl e
	jr nc, .nextParticipant
	ld [hl], a
.nextParticipant
	inc hl
	dec d
	jr nz, .participantLoop
; next up, calc exp split flags
; behavior heavily changes depending on exp splitting flag
	ld a, [EXP_SPLITTING_ADDRESS]
	bit EXP_SPLITTING_SHIFT + 1, a
	jr z, .vanillaSplitting ; %00 or %01 = vanilla behavior
	bit EXP_SPLITTING_SHIFT, a
	jr nz, .splitToNonParticipants ; %11 = always split to non-participants
	ld a, [wHasExpAll]
	and a
	ret z ; %10 = split to non-participants if exp share (all) item obtained
.splitToNonParticipants
; give 50% exp to ALL alive non-participants
	ld c, 0
	ld b, c
	ld de, wParticipantEXPDivisors
	ld hl, wPartyMon1HP
.splitLoop1
	push hl
	ld a, [de]
	and a
	jr nz, .nextSplit ; don't give to participants
	ld a, [hli]
	or [hl]
	jr z, .nextSplit ; don't give to dedmons
	ld hl, wSharedEXPDivisors
	add hl, bc
	ld [hl], 2
.nextSplit
	pop hl
	inc de
	push bc
	ld c, wPartyMon2HP - wPartyMon1HP
	add hl, bc
	pop bc
	inc c
	ld a, [wPartyCount]
	cp c
	jr nz, .splitLoop1
	ret
.vanillaSplitting
; split exp/(party count*2) to all alive mons if expall in bag. the divisor for the split includes dead mons intentionally
	ld a, [wHasExpAll]
	and a
	ret z
	ld c, 0
	ld b, c
	ld hl, wPartyMon1HP
	ld de, wSharedEXPDivisors
.splitLoop2
	ld a, [hli]
	or [hl]
	jr z, .nextSplit2 ; don't give to ded mons
	ld a, [wPartyCount]
	sla a
	ld [de], a
.nextSplit2
	push bc
	ld c, wPartyMon2HP - (wPartyMon1HP + 1)
	add hl, bc
	pop bc
	inc de
	inc c
	ld a, [wPartyCount]
	cp c
	jr nz, .splitLoop2
	ret

GainedText:
	TX_FAR _GainedText
	TX_ASM
	ld a, [wBoostExpByExpAll]
	ld hl, WithExpAllText
	and a
	ret nz
	ld a, [wExpAmountGained]
	and a
	jr nz, .longEXP
	ld a, [wExpAmountGained + 1]
	cp $27
	jr nc, .longEXP
	ld hl, ExpPointsText
	ld a, [wGainBoostedExp]
	and a
	ret z
	ld hl, BoostedText
	ret
.longEXP
	ld hl, ExpPointsLongText
	ld a, [wGainBoostedExp]
	and a
	ret z
	ld hl, BoostedLongText
	ret

WithExpAllText:
	TX_FAR _WithExpAllText
	TX_ASM
	ld hl, ExpPointsText
	ret

BoostedText:
	TX_FAR _BoostedText

ExpPointsText:
	TX_FAR _ExpPointsText
	db "@"

BoostedLongText:
	TX_FAR _BoostedText

ExpPointsLongText:
	TX_FAR _ExpPointsLongText
	db "@"

GrewLevelText:
	TX_FAR _GrewLevelText
	TX_SFX_LEVEL_UP
	db "@"

GainedWithShareText:
	TX_ASM
	ld a, [EXP_SPLITTING_ADDRESS]
	and EXP_SPLITTING_MASK
	cp EXP_SPLITTING_NOSPAM << EXP_SPLITTING_SHIFT
	ld hl, ExpAllTruncatedText
	ret z
	cp EXP_SPLITTING_EXPSHARE << EXP_SPLITTING_SHIFT
	ld hl, ExpShareText
	ret z
	ld hl, AlwaysExpShareText
	ret

ExpAllTruncatedText:
	TX_FAR _ExpAllTruncatedText
	db "@"

ExpShareText:
	TX_FAR _ExpShareText
	db "@"

AlwaysExpShareText:
	TX_FAR _AlwaysExpShareText
	db "@"

INCLUDE "engine/battle/experience_nonscaling.asm"
INCLUDE "engine/battle/experience_scaling.asm"
