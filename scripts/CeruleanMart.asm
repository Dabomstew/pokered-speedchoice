CeruleanMart_Script:
	call CeruleanMart_ChooseTextPointer
	jp EnableAutoTextBoxDrawing
	
CeruleanMart_ChooseTextPointer:
	sboptioncheck BETTER_MARTS
	ld hl, CeruleanMart_TextPointers
	jr z, .write
	ld hl, CeruleanMart_TextPointers_BM
.write
	ld a, l
	ld [wMapTextPtr], a
	ld a, h
	ld [wMapTextPtr+1], a
	ret

CeruleanMart_TextPointers:
	dw CeruleanCashierText
	dw CeruleanMartText2
	dw CeruleanMartText3
CeruleanMart_TextPointers_BM:
	dw BetterEarlyMartCashierText
	dw CeruleanMartText2
	dw CeruleanMartText3
	
; Cerulean
CeruleanCashierText::
	TX_MART POKE_BALL, POTION, REPEL, ANTIDOTE, BURN_HEAL, AWAKENING, PARLYZ_HEAL

CeruleanMartText2:
	TX_FAR _CeruleanMartText2
	db "@"

CeruleanMartText3:
	TX_FAR _CeruleanMartText3
	db "@"
