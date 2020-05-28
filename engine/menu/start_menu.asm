DisplayStartMenu::
	ld a, TIMER_MENUS
	ld [hTimerType], a
	ld a, BANK(StartMenu_Pokedex)
	rst BankswitchCommon
	ld a, [wWalkBikeSurfState] ; walking/biking/surfing
	ld [wWalkBikeSurfStateCopy], a
	ld a, SFX_START_MENU
	call PlaySound

RedisplayStartMenu::
	callba DrawStartMenu
	callba PrintSafariZoneSteps ; print Safari Zone info, if in Safari Zone
	call UpdateSprites
.loop
	call HandleMenuInput
	ld b, a
.checkIfUpPressed
	bit 6, a ; was Up pressed?
	jr z, .checkIfDownPressed
	ld a, [wCurrentMenuItem] ; menu selection
	and a
	jr nz, .loop
	ld a, [wLastMenuItem]
	and a
	jr nz, .loop
; if the player pressed tried to go past the top item, wrap around to the bottom
	CheckEvent EVENT_GOT_POKEDEX
	ld a, 6 ; there are 7 menu items with the pokedex, so the max index is 6
	jr nz, .wrapMenuItemId
	dec a ; there are only 6 menu items without the pokedex
.wrapMenuItemId
	ld [wCurrentMenuItem], a
	call EraseMenuCursor
	jr .loop
.checkIfDownPressed
	bit 7, a
	jr z, .buttonPressed
; if the player pressed tried to go past the bottom item, wrap around to the top
	CheckEvent EVENT_GOT_POKEDEX
	ld a, [wCurrentMenuItem]
	ld c, 7 ; there are 7 menu items with the pokedex
	jr nz, .checkIfPastBottom
	dec c ; there are only 6 menu items without the pokedex
.checkIfPastBottom
	cp c
	jr nz, .loop
; the player went past the bottom, so wrap to the top
	xor a
	ld [wCurrentMenuItem], a
	call EraseMenuCursor
	jr .loop
.buttonPressed ; A, B, or Start button pressed
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	ld [wBattleAndStartSavedMenuItem], a ; save current menu selection
	ld a, b
	and %00001010 ; was the Start button or B button pressed?
	jp nz, CloseStartMenu
	call SaveScreenTilesToBuffer2 ; copy background from wTileMap to wTileMapBackup2
	CheckEvent EVENT_GOT_POKEDEX
	ld a, [wCurrentMenuItem]
	jr nz, .displayMenuItem
	inc a ; adjust position to account for missing pokedex menu item
.displayMenuItem
	cp 0
	jp z, StartMenu_Pokedex
	cp 1
	jp z, StartMenu_Pokemon
	cp 2
	jp z, StartMenu_Item
	cp 3
	jp z, StartMenu_TrainerInfo
	cp 4
	jp z, StartMenu_SaveReset
	cp 5
	jp z, StartMenu_Option
; EXIT or retire
	ld a, [wCurMap]
	cp SAFARI_ZONE_EAST
	jr c, CloseStartMenu
	cp CERULEAN_CAVE_2F
	jr nc, CloseStartMenu
; retire from safari zone
	ld hl, .AreYouDoneText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr z, .quit
	call LoadScreenTilesFromBuffer2 ; restore saved screen
	call LoadTextBoxTilePatterns
	call UpdateSprites
	jp RedisplayStartMenu

.AreYouDoneText
	TX_FAR _SafariZoneRetireText
	db "@"

.quit
	xor a
	ld [wPlayerMovingDirection], a
	ld a, SAFARI_ZONE_GATE
	ld [hWarpDestinationMap], a
	ld a, $3
	ld [wDestinationWarpID], a
	ld a, $5
	ld [wSafariZoneGateCurScript], a
	SetEvent EVENT_SAFARI_GAME_OVER
	ld a, 1
	ld [wSafariZoneGameOver], a
	; fallthrough

CloseStartMenu::
	call Joypad
	ld a, [hJoyPressed]
	bit 0, a ; was A button newly pressed?
	jr nz, CloseStartMenu
	call LoadTextBoxTilePatterns
	jp CloseTextDisplay

