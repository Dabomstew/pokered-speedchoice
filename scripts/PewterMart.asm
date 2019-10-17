PewterMart_Script:
	call PewterMart_ChooseTextPointer
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	ret
	
PewterMart_ChooseTextPointer:
	ld a, [wPermanentOptions]
	and (1 << BETTER_MARTS)
	ld hl, PewterMart_TextPointers
	jr z, .write
	ld hl, PewterMart_TextPointers_BM
.write
	ld a, l
	ld [wMapTextPtr], a
	ld a, h
	ld [wMapTextPtr+1], a
	ret

PewterMart_TextPointers:
	dw PewterCashierText
	dw PewterMartText2
	dw PewterMartText3
PewterMart_TextPointers_BM:
	dw BetterEarlyMartCashierText
	dw PewterMartText2
	dw PewterMartText3
	
; Pewter
PewterCashierText::
	TX_MART POKE_BALL, POTION, ESCAPE_ROPE, ANTIDOTE, BURN_HEAL, AWAKENING, PARLYZ_HEAL

PewterMartText2:
	TX_ASM
	ld hl, .Text
	call PrintText
	jp TextScriptEnd
.Text
	TX_FAR _PewterMartText2
	db "@"

PewterMartText3:
	TX_ASM
	ld hl, .Text
	call PrintText
	jp TextScriptEnd
.Text
	TX_FAR _PewterMartText3
	db "@"
