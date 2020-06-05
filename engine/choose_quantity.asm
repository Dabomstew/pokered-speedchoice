_DisplayChooseQuantityMenu::
; text box dimensions/coordinates for just quantity
	coord hl, 15, 9
	ld b, 1 ; height
	ld c, 3 ; width
	ld a, [wListMenuID]
	cp PRICEDITEMLISTMENU
	jr nz, .drawTextBox
; text box dimensions/coordinates for quantity and price
	coord hl, 7, 9
	ld b, 1  ; height
	ld c, 11 ; width
.drawTextBox
	call TextBoxBorder
	coord hl, 16, 10
	ld a, [wListMenuID]
	cp PRICEDITEMLISTMENU
	jr nz, .printInitialQuantity
	coord hl, 8, 10
.printInitialQuantity
	ld de, InitialQuantityText
	call PlaceString
	xor a
	ld [wItemQuantity], a ; initialize current quantity to 0
	jp .incrementQuantity
.waitForKeyPressLoop
	call JoypadLowSensitivity
	ld a, [hJoyPressed] ; newly pressed buttons
	bit 0, a ; was the A button pressed?
	jp nz, .buttonAPressed
	bit 1, a ; was the B button pressed?
	jp nz, .buttonBPressed
	bit 6, a ; was Up pressed?
	jr nz, .incrementQuantity
	bit 7, a ; was Down pressed?
	jr nz, .decrementQuantity
	bit 4, a ; was Right pressed?
	jr nz, .add10
	bit 5, a ; was Left pressed?
	jr nz, .sub10
	jr .waitForKeyPressLoop
.add10
	ld a, [wMaxItemQuantity]
	ld b, a
	ld a, [wItemQuantity]
	cp b
	jr z, .set1
	add 10
	cp b
	jr c, .setAndHandle
	ld a, b
	jr .setAndHandle
.set1
	ld a, 1
.setAndHandle
	ld [wItemQuantity], a
	jr .handleNewQuantity
.sub10
	ld a, [wItemQuantity]
	cp 1
	jr z, .setMax
	sub 10
	jr z, .set1
	jr c, .set1
	jr .setAndHandle
.setMax
	ld a, [wMaxItemQuantity]
	jr .setAndHandle
.incrementQuantity
	ld a, [wMaxItemQuantity]
	inc a
	ld b, a
	ld hl, wItemQuantity ; current quantity
	inc [hl]
	ld a, [hl]
	cp b
	jr nz, .handleNewQuantity
; wrap to 1 if the player goes above the max quantity
	ld a, 1
	ld [hl], a
	jr .handleNewQuantity
.decrementQuantity
	ld hl, wItemQuantity ; current quantity
	dec [hl]
	jr nz, .handleNewQuantity
; wrap to the max quantity if the player goes below 1
	ld a, [wMaxItemQuantity]
	ld [hl], a
.handleNewQuantity
	coord hl, 17, 10
	ld a, [wListMenuID]
	cp PRICEDITEMLISTMENU
	jr nz, .printQuantity
.printPrice
	ld c, $03
	ld a, [wItemQuantity]
	ld b, a
	ld hl, hMoney ; total price
; initialize total price to 0
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
.addLoop ; loop to multiply the individual price by the quantity to get the total price
	ld de, hMoney + 2
	ld hl, hItemPrice + 2
	push bc
	predef AddBCDPredef ; add the individual price to the current sum
	pop bc
	dec b
	jr nz, .addLoop
	ld a, [hHalveItemPrices]
	and a ; should the price be halved (for selling items)?
	jr z, .skipHalvingPrice
	xor a
	ld [hDivideBCDDivisor], a
	ld [hDivideBCDDivisor + 1], a
	ld a, $02
	ld [hDivideBCDDivisor + 2], a
	predef DivideBCDPredef3 ; halves the price
; store the halved price
	ld a, [hDivideBCDQuotient]
	ld [hMoney], a
	ld a, [hDivideBCDQuotient + 1]
	ld [hMoney + 1], a
	ld a, [hDivideBCDQuotient + 2]
	ld [hMoney + 2], a
.skipHalvingPrice
	coord hl, 12, 10
	ld de, SpacesBetweenQuantityAndPriceText
	call PlaceString
	ld de, hMoney ; total price
	ld c, $a3
	call PrintBCDNumber
	coord hl, 9, 10
.printQuantity
	ld de, wItemQuantity ; current quantity
	lb bc, LEADING_ZEROES | 1, 2 ; 1 byte, 2 digits
	call PrintNumber
	jp .waitForKeyPressLoop
.buttonAPressed ; the player chose to make the transaction
	xor a
	ld [wMenuItemToSwap], a ; 0 means no item is currently being swapped
	ret
.buttonBPressed ; the player chose to cancel the transaction
	xor a
	ld [wMenuItemToSwap], a ; 0 means no item is currently being swapped
	ld a, $ff
	ret

InitialQuantityText::
	db "×01@"

SpacesBetweenQuantityAndPriceText::
	db "      @"
