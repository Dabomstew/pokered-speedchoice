PermaOptions2String::
	db "DELAYS<LNBRK>"
	db "        :<LNBRK>"
	db "SHAKE MOVES<LNBRK>"
	db "        :<LNBRK>"
	db "EXPERIENCE<LNBRK>"
	db "        :<LNBRK>"
	db "EXP SPLITTING<LNBRK>"
	db "        :<LNBRK>"
	db "CATCH EXP<LNBRK>"
	db "        :<LNBRK>"
	db "GOOD EARLY WILDS<LNBRK>"
	db "        :<LNBRK>"
	db "BETTER MARTS<LNBRK>"
	db "        :@"
	
PermaOptions2Pointers::
	dw Options_Delays
	dw Options_ShakeMoves
	dw Options_EXP
	dw Options_EXPSplitting
	dw Options_CatchEXP
	dw Options_GoodEarlyWilds
	dw Options_BetterMarts
	dw Options_PermaOptionsPage
PermaOptions2PointersEnd::

Options_Delays:: ; 3
	ld hl, SHORT_DELAYS_ADDRESS
	ld b, SHORT_DELAYS
	ld c, 3
	ld de, .NormalFast
	jp Options_TrueFalse
.NormalFast
	dw .Off
	dw .On
.Off
	db "NORMAL@"
.On
	db "FAST  @"
	
Options_ShakeMoves::
	ld hl, ALL_MOVES_SHAKE_ADDRESS
	ld b, ALL_MOVES_SHAKE
	ld c, 5
	ld de, .NormalAll
	jp Options_TrueFalse
.NormalAll
	dw .Off
	dw .On
.Off
	db "NORMAL@"
.On
	db "ALL   @"
	
Options_EXP:
	ld hl, .Data
	jp Options_Multichoice
	
.Data:
	multichoiceoptiondata EXP_FORMULA_ADDRESS, EXP_FORMULA_SHIFT, EXP_FORMULA_SIZE, 7, NUM_OPTIONS, .Strings
.Strings:
	dw .Normal
	dw .BW
	dw .None
.Strings_End:
	
.Normal
	db "NORMAL@"
.BW
	db "B/W   @"
.None
	db "NONE  @"
	
Options_EXPSplitting:
	ld hl, .Data
	jp Options_Multichoice
	
.Data:
	multichoiceoptiondata EXP_SPLITTING_ADDRESS, EXP_SPLITTING_SHIFT, EXP_SPLITTING_SIZE, 9, NUM_OPTIONS, .Strings
.Strings:
	dw .Normal
	dw .NoSpam
	dw .Gen67
	dw .Gen8
.Strings_End:
	
.Normal
	db "NORMAL @"
.NoSpam
	db "NO SPAM@"
.Gen67
	db "GEN 6/7@"
.Gen8
	db "GEN 8  @"
	
Options_CatchEXP::
	ld hl, CATCH_EXP_ADDRESS
	ld b, CATCH_EXP
	ld c, 11
	jp Options_OnOff
	
Options_GoodEarlyWilds::
	ld hl, GOOD_EARLY_WILDS_ADDRESS
	ld b, GOOD_EARLY_WILDS
	ld c, 13
	jp Options_OnOff
	
Options_BetterMarts::
	ld hl, BETTER_MARTS_ADDRESS
	ld b, BETTER_MARTS
	ld c, 15
	jp Options_OnOff
