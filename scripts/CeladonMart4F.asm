CeladonMart4F_Script:
	call CeladonMart4F_ChooseTextPointer
	jp EnableAutoTextBoxDrawing
	
CeladonMart4F_ChooseTextPointer:
	sboptioncheck BETTER_MARTS
	ld hl, CeladonMart4F_TextPointers
	jr z, .write
	ld hl, CeladonMart4F_TextPointers_BM
.write
	ld a, l
	ld [wMapTextPtr], a
	ld a, h
	ld [wMapTextPtr+1], a
	ret

CeladonMart4F_TextPointers:
	dw CeladonMart4ClerkText
	dw CeladonMart4Text2
	dw CeladonMart4Text3
	dw CeladonMart4Text4
CeladonMart4F_TextPointers_BM:
	dw CeladonMart4ClerkText_BM
	dw CeladonMart4Text2
	dw CeladonMart4Text3
	dw CeladonMart4Text4
	
; Celadon Dept. Store 4F
CeladonMart4ClerkText::
	TX_MART POKE_DOLL, FIRE_STONE, THUNDER_STONE, WATER_STONE, LEAF_STONE
	
; Celadon Dept. Store 4F
CeladonMart4ClerkText_BM::
	TX_MART POKE_DOLL, FIRE_STONE, THUNDER_STONE, WATER_STONE, LEAF_STONE, MOON_STONE

CeladonMart4Text2:
	TX_FAR _CeladonMart4Text2
	db "@"

CeladonMart4Text3:
	TX_FAR _CeladonMart4Text3
	db "@"

CeladonMart4Text4:
	TX_FAR _CeladonMart4Text4
	db "@"
