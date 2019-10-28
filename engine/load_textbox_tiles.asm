_LoadTextBoxTilePatterns::
; start by transferring the normal textbox
	ld a, [rLCDC]
	bit 7, a ; is the LCD enabled?
	jr nz, .on
.off
	ld hl, DefaultTextBoxGraphics
	ld de, vChars2 + $600
	ld bc, DefaultTextBoxGraphicsEnd - DefaultTextBoxGraphics
	call CopyData ; if LCD is off, transfer all at once
	jr _LoadTextBoxFrame
.on
	ld de, DefaultTextBoxGraphics
	ld hl, vChars2 + $600
	lb bc, BANK(DefaultTextBoxGraphics), (DefaultTextBoxGraphicsEnd - DefaultTextBoxGraphics) / $10
	call CopyVideoData ; if LCD is on, transfer during V-blank
; fallthrough

_LoadTextBoxFrame::
; load the custom frame if set
	ld a, [wOptions2]
	and FRAME_MASK
	ret z
	dec a
	add a
	ld c, a
	ld b, 0
	ld hl, TextBoxFrames
	add hl, bc
; load graphics offset
	rst UnHL
; lcd check
	ld a, [rLCDC]
	bit 7, a ; is the LCD enabled?
	jr nz, .on2
.off2
	ld de, vChars2 + $790
	ld bc, $30 ; 6 tiles
	ld a, BANK(TextBoxFrames)
	jp FarCopyDataDouble ; LCD is off, transfer now
.on2
	ld d, h
	ld e, l
	ld hl, vChars2 + $790
	lb bc, BANK(TextBoxFrames), $06
	jp CopyVideoDataDouble ; if LCD is on, transfer during V-blank
	
INCLUDE "data/textbox_frames.asm"
