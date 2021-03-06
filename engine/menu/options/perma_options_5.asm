PermaOptions5String::
	db "BOAT<LNBRK>"
	db "        :<LNBRK>"
	db "POKéMON PICS<LNBRK>"
	db "        :@"

PermaOptions5Pointers::
	dw Options_Boat
	dw Options_PokemonPics
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
