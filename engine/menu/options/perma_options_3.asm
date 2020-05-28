PermaOptions3String::
	db "NERF BROCK<LNBRK>"
	db "        :<LNBRK>"
	db "BETTER GAMECORNER<LNBRK>"
	db "        :<LNBRK>"
	db "EASY SAFARI<LNBRK>"
	db "        :<LNBRK>"
	db "EARLY V. ROAD<LNBRK>"
	db "        :<LNBRK>"
	db "B TO GO FAST<LNBRK>"
	db "        :<LNBRK>"
	db "START WITH BIKE<LNBRK>"
	db "        :<LNBRK>"
	db "#DEX AREA BEEP<LNBRK>"
	db "        :@"

PermaOptions3Pointers::
	dw Options_NerfBrock
	dw Options_BetterGameCorner
	dw Options_EasySafari
	dw Options_EarlyVRoad
	dw Options_BFastMovement
	dw Options_StartWithBike
	dw Options_DexAreaBeep
	dw Options_PermaOptionsPage

Options_NerfBrock::
	ld hl, wPermanentOptions
	ld b, NERF_PEWTER_GYM
	ld c, 3
	jp Options_OnOff
	
Options_BetterGameCorner::
	ld hl, wPermanentOptions2
	ld b, BETTER_GAME_CORNER
	ld c, 5
	jp Options_OnOff
	
Options_EasySafari::
	ld hl, wPermanentOptions2
	ld b, EASY_SAFARI
	ld c, 7
	jp Options_OnOff
	
Options_EarlyVRoad::
	ld hl, wPermanentOptions4
	ld b, EARLY_VICTORY_ROAD
	ld c, 9
	jp Options_OnOff
	
Options_BFastMovement::
	ld hl, wPermanentOptions4
	ld b, B_FAST_MOVEMENT
	ld c, 11
	jp Options_OnOff
	
Options_StartWithBike::
	ld hl, wPermanentOptions4
	ld b, START_WITH_BIKE
	ld c, 13
	jp Options_OnOff
	
Options_DexAreaBeep::
	ld hl, wPermanentOptions4
	ld b, DEX_AREA_BEEP
	ld c, 15
	jp Options_OnOff
