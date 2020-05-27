PermaOptions3String::
	db "NERF BROCK<LNBRK>"
	db "        :<LNBRK>"
	db "BETTER GAMECORNER<LNBRK>"
	db "        :<LNBRK>"
	db "EASY SAFARI<LNBRK>"
	db "        :<LNBRK>"
	db "EARLY V. ROAD<LNBRK>"
	db "        :<LNBRK>"
	db "BOAT<LNBRK>"
	db "        :<LNBRK>"
	db "POKéMON PICS<LNBRK>"
	db "        :@"

PermaOptions3Pointers::
	dw Options_NerfBrock
	dw Options_BetterGameCorner
	dw Options_EasySafari
	dw Options_EarlyVRoad
	dw Options_Boat
	dw Options_PokemonPics
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
	
Options_Boat::
	ld hl, wPermanentOptions2
	ld b, BACKWARDS_BOAT
	ld c, 11
	ld de, .NormalMeme
	jp Options_TrueFalse
.NormalMeme
	dw .Off
	dw .On
.Off
	db "NORMAL@"
.On
	db "MEME  @"

Options_PokemonPics:
	ld hl, .Data
	jp Options_Multichoice
	
.Data:
	multichoiceoptiondata wPermanentOptions4, PICSET_SHIFT, PICSET_SIZE, 13, NUM_OPTIONS, .Strings
.Strings:
	dw .Normal
	dw .Green
	dw .Yellow
.Strings_End:
	
.Normal
	db "NORMAL@"
.Green
	db "GREEN @"
.Yellow
	db "YELLOW@"
