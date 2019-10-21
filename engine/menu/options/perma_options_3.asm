PermaOptions3String::
	db "NERF BROCK<LNBRK>"
	db "        :<LNBRK>"
	db "BIKESLIPRUN<LNBRK>"
	db "        :<LNBRK>"
	db "BOAT<LNBRK>"
	db "        :@"

PermaOptions3Pointers::
	dw Options_NerfBrock
	dw Options_BikeSlipRun
	dw Options_Boat
	dw Options_PermaOptionsPage

Options_NerfBrock::
	ld hl, wPermanentOptions
	ld b, NERF_PEWTER_GYM
	ld c, 3
	jp Options_OnOff
	
Options_BikeSlipRun:: ; 5
	ret
	
Options_Boat:: ; 7
	ld hl, wPermanentOptions2
	ld b, BACKWARDS_BOAT
	ld c, 7
	ld de, .NormalMeme
	jp Options_TrueFalse
.NormalMeme
	dw .Off
	dw .On
.Off
	db "NORMAL@"
.On
	db "MEME  @"
