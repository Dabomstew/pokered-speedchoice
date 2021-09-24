PermaOptions5String::
	db "BOAT<LNBRK>"
	db "        :<LNBRK>"
	db "POKéMON PICS<LNBRK>"
	db "        :<LNBRK>"
	db "PRIZE MONEY<LNBRK>"
	db "        :<LNBRK>"
	db "HEART FAILURES<LNBRK>"
	db "        :@"

PermaOptions5Pointers::
	dw Options_Boat
	dw Options_PokemonPics
	dw Options_PrizeMoney
	dw Options_HeartFailures
	dw Options_PermaOptionsPage
PermaOptions5PointersEnd::

Options_Boat::
	ld hl, BACKWARDS_BOAT_ADDRESS
	ld b, BACKWARDS_BOAT
	ld c, 3
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
	multichoiceoptiondata PICSET_ADDRESS, PICSET_SHIFT, PICSET_SIZE, 5, NUM_OPTIONS, .Strings
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

Options_PrizeMoney::
	ld hl, PRIZE_MONEY_ADDRESS
	ld b, PRIZE_MONEY
	ld c, 7
	ld de, .NormalAll
	jp Options_TrueFalse
.NormalAll
	dw .Off
	dw .On
.Off
	db "NORMAL@"
.On
	db "OFF   @"

Options_HeartFailures::
	ld hl, HEART_FAILURES_ADDRESS
	ld b, HEART_FAILURES
	ld c, 9
	jp Options_OnOff
