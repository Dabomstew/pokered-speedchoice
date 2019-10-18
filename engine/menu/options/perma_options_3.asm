PermaOptions3String::
	db "NERF BROCK<LNBRK>"
	db "        :<LNBRK>"
	db "SAVESCUM<LNBRK>"
	db "        :<LNBRK>"
	db "BIKESLIPRUN<LNBRK>"
	db "        :<LNBRK>"
	db "BOAT<LNBRK>"
	db "        :@"

PermaOptions3Pointers::
	dw Options_NerfBrock
	dw Options_Savescum
	dw Options_BikeSlipRun
	dw Options_Boat
	dw Options_PermaOptionsPage

Options_NerfBrock::
	ld hl, wPermanentOptions
	ld b, NERF_PEWTER_GYM
	ld c, 3
	jp Options_OnOff
	
Options_Savescum:: ; 5
	ret
	
Options_BikeSlipRun:: ; 7
	ret
	
Options_Boat:: ; 9
	ret
