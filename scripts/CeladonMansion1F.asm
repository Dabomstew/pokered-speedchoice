CeladonMansion1F_Script:
	jp EnableAutoTextBoxDrawing

CeladonMansion1F_TextPointers:
	dw CeladonMansion1Text1
	dw CeladonMansion1Text2
	dw CeladonMansion1Text3
	dw CeladonMansion1Text4
	dw CeladonMansion1Text5

CeladonMansion1_486a1:
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text1:
	TX_FAR _CeladonMansion1Text1
	TX_ASM
	ld a, MEOWTH
	jp CeladonMansion1_486a1
	
CeladonMansion1Text2:
	TX_ASM
	ldafarbyte KeyItemRandoActive
	and a
	jr z, .vanilla
	CheckEvent EVENT_GOT_TEA
	jr z, .GiveTea
.vanilla
	ld hl, TeaVanillaText
.PrintTextAndEnd
	call PrintText
	jp TextScriptEnd
.GiveTea
	ld hl, TeaPreGiveText
	call PrintText
	ldafarbyte KeyItemTea
	ld b, a
	ld c, 1
	call GiveItem
	jr nc, .BagFull
	SetEvent EVENT_GOT_TEA
	ld hl, TeaPostGiveText
	jr .PrintTextAndEnd
.BagFull
	ld hl, TeaNoRoomText
	jr .PrintTextAndEnd

TeaVanillaText::
	TX_FAR _CeladonMansion1Text2
	db "@"

TeaPreGiveText::
	TX_FAR _TeaPreGiveText
	db "@"

TeaPostGiveText::
	TX_FAR _TeaPostGiveText
	db "@"
	
TeaNoRoomText:
	TX_FAR _TM21NoRoomText
	db "@"

CeladonMansion1Text3:
	TX_FAR _CeladonMansion1Text3
	TX_ASM
	ld a, CLEFAIRY
	jp CeladonMansion1_486a1

CeladonMansion1Text4:
	TX_FAR _CeladonMansion1Text4
	TX_ASM
	ld a, NIDORAN_F
	jp CeladonMansion1_486a1

CeladonMansion1Text5:
	TX_FAR _CeladonMansion1Text5
	db "@"
