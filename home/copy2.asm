FarCopyData2::
; Identical to FarCopyData, but uses hROMBankTemp
; as temp space instead of wBuffer.
	ld [hROMBankTemp], a
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [hROMBankTemp]
	rst BankswitchCommon
	call CopyData
	pop af
	jp BankswitchCommon

FarCopyData3::
; Copy bc bytes from a:de to hl.
	ld [hROMBankTemp], a
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [hROMBankTemp]
	rst BankswitchCommon
	push hl
	push de
	push de
	ld d, h
	ld e, l
	pop hl
	call CopyData
	pop de
	pop hl
	pop af
	jp BankswitchCommon

FarCopyDataDouble::
; Expand bc bytes of 1bpp image data
; from a:hl to 2bpp data at de.
	ld [hROMBankTemp], a
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [hROMBankTemp]
	rst BankswitchCommon
.loop
	ld a, [hli]
	ld [de], a
	inc de
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, .loop
	pop af
	jp BankswitchCommon

CopyVideoData::
; transfer tiles in HBlank.
; from b:de to hl, c tiles.
; copies 8 bytes per HBlank (cgbds), so length = (roughly) c/52 frames.
; supports vram as src, unlike my CopyVideoDataDouble implementation.
; speed = about 54 tiles per frame (assuming VBlank exits with LY ~= x12)
	push hl
	push de
	push bc
	ld a, [H_AUTOBGTRANSFERENABLED]
	push af
	xor a ; disable auto-transfer while copying
	ld [H_AUTOBGTRANSFERENABLED], a
	call CopyVideoDataDelay
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, b
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
; swap de and hl
	push de
	ld d,h
	ld e,l
	pop hl
.outerloop
	ld b, 2
; high ly is B&
.checkLY
	ld a, [rLY]
	cp $7E
	jr c, .nhblWaitL
	call DelayFrame
; make sure we hit a transition from non-HBL to HBL
.nhblWaitL
	ld a, [rSTAT]
	and $3
	jr z, .nhblWaitL
.hblWaitL
	ld a, [rSTAT]
	and $3
	jr nz, .hblWaitL
	di
rept 7
	ld a, [hli]
	ld [de], a
	inc e
endr
	ld a, [hli]
	ld [de], a
	ei
	inc de
	dec b
	jr nz, .checkLY
	dec c
	jr nz, .outerloop
CopyVideoDataFinish:
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	pop af
	ld [H_AUTOBGTRANSFERENABLED], a
	pop bc
	pop de
	pop hl
	ret
	
CopyVideoDataDouble::
; transfer 1bpp tiles in HBlank, doubling them to 2bpp in the process
; b:de to hl, c tiles
; uses some preloading to safely copy a full tile (= 8 1bpp bytes) per HBlank
; unlike the above, does NOT support copies with src=VRAM
; but it doesn't really need to.
; speed = about 108 tiles per frame (assuming VBlank exits with LY ~= x12)
	push hl
	push de
	push bc
	ld a, [H_AUTOBGTRANSFERENABLED]
	push af
	xor a ; disable auto-transfer while copying
	ld [H_AUTOBGTRANSFERENABLED], a
	call CopyVideoDataDelay
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, b
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
; high ly is B&
.checkLY
	ld a, [rLY]
	cp $7E
	jr c, .preload
	call DelayFrame
.preload
	push bc
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld [H_COPYDOUBLETEMP], a
	inc de
	ld a, [de]
	inc de
	push de
	ld e, a
	ld a, [H_COPYDOUBLETEMP]
	ld d, a
; make sure we hit a transition from non-HBL to HBL
.nhblWaitL
	ld a, [rSTAT]
	and $3
	jr z, .nhblWaitL
.hblWaitL
	ld a, [rSTAT]
	and $3
	jr nz, .hblWaitL
	di
	ld a, b
	ld [hli], a
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hli], a
	pop de
rept 3
	ld a, [de]
	ld [hli], a
	ld [hli], a
	inc de
endr
	ld a, [de]
	ld [hli], a
	ld [hli], a
	ei
	inc de
	pop bc
	dec c
	jr nz, .checkLY
	jp CopyVideoDataFinish
	
; simulates the original delay of CopyVideoData if short delays is off
CopyVideoDataDelay::
	ld a, [H_INGAME]
	and a
	ret z
	ld a, [wPermanentOptions2]
	and (1 << SHORT_DELAYS)
	ret nz
; delay frames to pretend we aren't doing this super fast
	ld a, c
	add 7
	srl a
	srl a
	srl a
	push bc
	ld c, a
	call DelayFrames
	pop bc
	ret

ClearScreenArea::
; Clear tilemap area cxb at hl.
	ld a, " " ; blank tile
	ld de, 20 ; screen width
.y
	push hl
	push bc
.x
	ld [hli], a
	dec c
	jr nz, .x
	pop bc
	pop hl
	add hl, de
	dec b
	jr nz, .y
	ret

CopyScreenTileBufferToVRAM::
; Copy wTileMap to the BG Map starting at b * $100.
; This is really weird why not just use autoBG...
; Anyhow, this is basically a wrapper to emulate old functionality but use autoBG instead.
	ld a, [rLY]
	cp $7E
	jr c, .begin
	call DelayFrame
.begin
	ld h, (H_AUTOBGTRANSFERDEST + 2) - H_AUTOBGTRANSFERENABLED
	ld c, H_AUTOBGTRANSFERENABLED % $100
.pushloop
	ld a, [$ff00+c]
	push af
	inc c
	dec h
	jr nz, .pushloop
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a
	xor a
	ld [H_AUTOBGTRANSFERPORTION], a
	ld [H_AUTOBGTRANSFERDEST], a
	ld a, b
	ld [H_AUTOBGTRANSFERDEST + 1], a
	call DelayFrame
	ld c, (H_AUTOBGTRANSFERDEST + 1) % $100
	ld h, (H_AUTOBGTRANSFERDEST + 2) - H_AUTOBGTRANSFERENABLED
.poploop
	pop af
	ld [$ff00+c], a
	dec c
	dec h
	jr nz, .poploop
	ret

ClearScreen::
; Clear wTileMap, then wait
; for the bg map to update.
	ld bc, 20 * 18
	inc b
	coord hl, 0, 0
	ld a, " "
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	jp Delay3
	
ByteFill::
; fill bc bytes with the value of a, starting at hl
	inc b  ; we bail the moment b hits 0, so include the last run
	inc c  ; same thing; include last byte
	jr .HandleLoop
.PutByte
	ld [hli], a
.HandleLoop
	dec c
	jr nz, .PutByte
	dec b
	jr nz, .PutByte
	ret
