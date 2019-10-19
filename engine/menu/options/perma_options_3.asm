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
	ret
