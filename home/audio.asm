PlayDefaultMusic::
	call WaitForSoundToFinish
	xor a
	ld c, a
	ld d, a
	ld [wLastMusicSoundID], a
	jr PlayDefaultMusicCommon

PlayDefaultMusicFadeOutCurrent::
; Fade out the current music and then play the default music.
	ld c, 10
	ld d, 0
	ld a, [wd72e]
	bit 5, a ; has a battle just ended?
	jr z, PlayDefaultMusicCommon
	xor a
	ld [wLastMusicSoundID], a
	ld c, 8
	ld d, c

PlayDefaultMusicCommon::
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .walking
	cp $2
	jr z, .surfing
	mboptionload BIKE_MUSIC
	jr z, .bike
	cp BIKE_MUSIC_NONE << BIKE_MUSIC_SHIFT
	jr z, .walking
	call CheckForNoBikingMusicMap
	jr c, .walking
.bike
	ld a, MUSIC_BIKE_RIDING
	jr .next

.surfing
	ld a, MUSIC_SURFING

.next
	ld b, a
	ld a, d
	jr .next3

.walking
	ld a, [wMapMusicSoundID]
	ld b, a

.next3
	ld a, [wLastMusicSoundID]
	cp b ; is the default music already playing?
	ret z ; if so, do nothing

.next4
	ld a, b
	ld [wLastMusicSoundID], a
	ld [wMusicFadeID], a
	ld a, c
	and a
	jr nz, .doFade
	inc a
.doFade
	ld [wMusicFade], a
	ret

; taken verbatim from pokeyellow
CheckForNoBikingMusicMap::
; probably used to not change music upon getting on bike
	ld a, [wCurMap]
	cp ROUTE_23
	jr z, .found
	cp VICTORY_ROAD_1F
	jr z, .found
	cp VICTORY_ROAD_2F
	jr z, .found
	cp VICTORY_ROAD_3F
	jr z, .found
	cp INDIGO_PLATEAU
	jr z, .found
	and a
	ret
.found
	scf
	ret

; plays sfx specified by a. If value is $ff, music is stopped
PlaySound:: ; 23b1 (0:23b1)
	push de
	cp $FF
	jr nz, .notstop
	xor a
	call PlayMusic
	pop de
	ret
.notstop
	ld e, a
	xor a
	ld d, a
	call PlaySFX
	pop de
	ret

UpdateSound::
	ld a, [wHaltAudio]
	and a
	ret nz

	homecall _UpdateSound
	ret

PlayMusic::
; play music a, shifted into de
	ld e, a
	xor a
	ld d, a
; now play music de
	push hl
	push de
	push bc
	push af
	homecall _PlayMusic
	jr PopAllRet

PlayCry:: ; 13d0 (0:13d0)
; Play monster a's cry.
; Play a cry given parameters in header de

	push hl
	push de
	push bc
	push af
	ld [wd11e], a
	dec a
	ld e, a
	ld d, 0

; Save current bank
	ld a, [H_LOADEDROMBANK]
	push af

; Cry headers are stuck in one bank.
	ld a, BANK(PokemonCries)
	ld [H_LOADEDROMBANK], a
	ld [$2000], a

; Each header is 6 bytes long:
	ld hl, PokemonCries
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de

	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl

	ld a, [hli]
	ld [wCryPitch], a
	ld a, [hli]
	ld [wCryPitch+1], a
	ld a, [hli]
	ld [wCryLength], a
	ld a, [hl]
	ld [wCryLength+1], a

	ld a, BANK(_PlayCry)
	ld [H_LOADEDROMBANK], a
	ld [$2000], a

	call _PlayCry

	pop af
	ld [H_LOADEDROMBANK], a
	ld [$2000], a

	call WaitForSoundToFinish

	jr PopAllRet
; 3c23


PlaySFX:: ; 3c23
; Play sound effect de.
; Sound effects are ordered by priority (lowest to highest)

	push hl
	push de
	push bc
	push af

PlaySFX_play:
.play
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(_PlaySFX)
	ld [H_LOADEDROMBANK], a
	ld [$2000], a ; bankswitch

	ld a, e
	ld [wCurSFX], a
	call _PlaySFX

	pop af
	ld [H_LOADEDROMBANK], a
	ld [$2000], a ; bankswitch
.quit
PopAllRet:
	pop af
	pop bc
	pop de
	pop hl
	ret

_LoadMusicByte::
; wCurMusicByte = [a:de]
EXPORT LoadMusicByte

	ld [H_LOADEDROMBANK], a
	ld [$2000], a

	ld a, [de]
	ld [wCurMusicByte], a
	ld a, BANK(LoadMusicByte)

	ld [H_LOADEDROMBANK], a
	ld [$2000], a
	ret

PlaySoundWaitForCurrent::
	push af
	call WaitForSoundToFinish
	pop af
	jp PlaySound

; Wait for sound to finish playing
WaitForSoundToFinish::
WaitSFX::
; infinite loop until sfx is done playing
	ld a, [wLowHealthAlarm]
	and a
	ret nz
WaitForSoundToFinishIgnoreRedbar::
	ld a, [wSFXDontWait]
	and a
	ret nz
	push hl
.loop
	; ch5 on?
	ld hl, wChannel5 + CHANNEL_FLAGS1
	bit 0, [hl]
	jr nz, .loop
	; ch6 on?
	ld hl, wChannel6 + CHANNEL_FLAGS1
	bit 0, [hl]
	jr nz, .loop
	; ch7 on?
	ld hl, wChannel7 + CHANNEL_FLAGS1
	bit 0, [hl]
	jr nz, .loop
	; ch8 on?
	ld hl, wChannel8 + CHANNEL_FLAGS1
	bit 0, [hl]
	jr nz, .loop

	pop hl
	ret

WaitForSongToFinish::
.loop
	call IsSongPlaying
	jr c, .loop
	ret

IsSongPlaying::
	; ch1 on?
	ld hl, wChannel1 + CHANNEL_FLAGS1
	bit 0, [hl]
	jr nz, .playing
	; ch2 on?
	ld hl, wChannel2 + CHANNEL_FLAGS1
	bit 0, [hl]
	jr nz, .playing
	; ch3 on?
	ld hl, wChannel3 + CHANNEL_FLAGS1
	bit 0, [hl]
	jr nz, .playing
	; ch4 on?
	ld hl, wChannel4 + CHANNEL_FLAGS1
	bit 0, [hl]
	jr z, .notPlaying
.playing
	scf
	ret
.notPlaying
	xor a
	ret
