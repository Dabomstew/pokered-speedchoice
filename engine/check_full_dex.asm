Check151DexRaceGoal::
	ld a, [wSpeedchoiceFlags]
	bit DEX_RACEGOAL_DONE, a
	ret nz
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 151
	ret c
	ld hl, wSpeedchoiceFlags
	set DEX_RACEGOAL_DONE, [hl]
; display 
	
	ld a, [wJoyIgnore]
	push af
	ld a, [hSpriteIndexOrTextID]
	push af
	xor a
	ld [wJoyIgnore], a
	inc a
	ld [hSpriteIndexOrTextID], a
	callba DisplayTextIDInit
	pop af
	ld [hSpriteIndexOrTextID], a
	call GBPalNormal
	callab PlaythroughStatsScreen
	pop af
	ld [wJoyIgnore], a
	ld hl, wSpeedchoiceFlags
	set DEX_RACEGOAL_EXITING, [hl]
	jp CloseTextDisplay
