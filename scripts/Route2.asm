Route2_Script:
	call Route2_RemoveCutBush
	jp EnableAutoTextBoxDrawing
	
Route2_RemoveCutBush:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ldafarbyte KeyItemRandoActive
	and a
	ret z
	ld a, $6D ; no cut bush
	ld [wNewTileBlockID], a
	lb bc, $0B, $07 ; y, x
	predef_jump ReplaceTileBlock

Route2_TextPointers:
	dw PickUpItemText
	dw PickUpItemText
	dw Route2Text3
	dw Route2Text4

Route2Text3:
	TX_FAR _Route2Text3
	db "@"

Route2Text4:
	TX_FAR _Route2Text4
	db "@"
