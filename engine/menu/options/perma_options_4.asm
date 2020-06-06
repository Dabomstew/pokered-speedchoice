PermaOptions4String::
	db "START WITH DRINK<LNBRK>"
	db "        :<LNBRK>"
	db "#DEX AREA BEEP<LNBRK>"
	db "        :<LNBRK>"
	db "KEEP WARDEN CANDY<LNBRK>"
	db "        :<LNBRK>"
	db "LEVELUP MOVES<LNBRK>"
	db "        :<LNBRK>"
	db "METRONOME ONLY<LNBRK>"
	db "        :<LNBRK>"
	db "SELECT TO<LNBRK>"
	db "        :<LNBRK>"
	db "RODS ALWAYS WORK<LNBRK>"
	db "        :@"

PermaOptions4Pointers::
	dw Options_StartWithDrink
	dw Options_DexAreaBeep
	dw Options_KeepWardenCandy
	dw Options_SkipLevelupMoves
	dw Options_MetronomeOnly
	dw Options_SelectTo
	dw Options_RodsAlwaysWork
	dw Options_PermaOptionsPage
	
Options_StartWithDrink::
	ld hl, START_WITH_DRINK_ADDRESS
	ld b, START_WITH_DRINK
	ld c, 3
	jp Options_OnOff
	
Options_DexAreaBeep::
	ld hl, DEX_AREA_BEEP_ADDRESS
	ld b, DEX_AREA_BEEP
	ld c, 5
	jp Options_OnOff
	
Options_KeepWardenCandy::
	ld hl, KEEP_WARDEN_CANDY_ADDRESS
	ld b, KEEP_WARDEN_CANDY
	ld c, 7
	jp Options_OnOff
	
Options_SkipLevelupMoves::
	ld hl, DONT_SKIP_MOVES_ADDRESS
	ld b, DONT_SKIP_MOVES
	ld c, 9
	ld de, .OptionNames
	jp Options_TrueFalse
.OptionNames
	dw .Off
	dw .On
.Off
	db "CAN SKIP@"
.On
	db "NO SKIP @"
	
Options_MetronomeOnly::
	ld hl, METRONOME_ONLY_ADDRESS
	ld b, METRONOME_ONLY
	ld c, 11
	jp Options_OnOff
	
Options_SelectTo::
	ld hl, .Data
	jp Options_Multichoice
	
.Data:
	multichoiceoptiondata SELECTTO_ADDRESS, SELECTTO_SHIFT, SELECTTO_SIZE, 13, NUM_OPTIONS, .Strings
.Strings:
	dw .None
	dw .Bike
	dw .Jack
.Strings_End:
	
.None
	db "NONE@"
.Bike
	db "BIKE@"
.Jack
	db "JACK@"

Options_RodsAlwaysWork::
	ld hl, ROD_ALWAYS_SUCCEEDS_ADDRESS
	ld b, ROD_ALWAYS_SUCCEEDS
	ld c, 15
	jp Options_OnOff
