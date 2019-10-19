SafariZoneWest_Script:
	call ReplaceGoldTeeth
	jp EnableAutoTextBoxDrawing
	
ReplaceGoldTeeth:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ldafarbyte KeyItemGoldTeeth
	ld [wMapSpriteExtraData + $06], a
	ret

SafariZoneWest_TextPointers:
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw SafariZoneWestText5
	dw SafariZoneWestText6
	dw SafariZoneWestText7
	dw SafariZoneWestText8

SafariZoneWestText5:
	TX_FAR _SafariZoneWestText5
	db "@"

SafariZoneWestText6:
	TX_FAR _SafariZoneWestText6
	db "@"

SafariZoneWestText7:
	TX_FAR _SafariZoneWestText7
	db "@"

SafariZoneWestText8:
	TX_FAR _SafariZoneWestText8
	db "@"
