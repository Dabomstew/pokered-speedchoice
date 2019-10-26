PermaOptions3String::
	db "NERF BROCK<LNBRK>"
	db "        :<LNBRK>"
	db "BETTER GAMECORNER<LNBRK>"
	db "        :<LNBRK>"
	db "EASY SAFARI<LNBRK>"
	db "        :<LNBRK>"
	db "BOAT<LNBRK>"
	db "        :@"

PermaOptions3Pointers::
	dw Options_NerfBrock
	dw Options_BetterGameCorner
	dw Options_EasySafari
	dw Options_Boat
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
	
Options_Boat::
	ld hl, wPermanentOptions2
	ld b, BACKWARDS_BOAT
	ld c, 9
	ld de, .NormalMeme
	jp Options_TrueFalse
.NormalMeme
	dw .Off
	dw .On
.Off
	db "NORMAL@"
.On
	db "MEME  @"
