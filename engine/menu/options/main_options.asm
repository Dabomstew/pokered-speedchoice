MainOptionsString::
	db "TEXT SPEED<LNBRK>"
	db "        :<LNBRK>"
	db "HOLD TO MASH<LNBRK>"
	db "        :<LNBRK>"
	db "BATTLE SCENE<LNBRK>"
	db "        :<LNBRK>"
	db "BATTLE STYLE<LNBRK>"
	db "        :<LNBRK>"
	db "BIKE MUSIC<LNBRK>"
	db "        :<LNBRK>"
	db "GIVE NICKNAMES<LNBRK>"
	db "        :@"

MainOptionsPointers::
	dw Options_TextSpeed
	dw Options_HoldToMash
	dw Options_BattleScene
	dw Options_BattleStyle
	dw Options_BikeMusic
	dw Options_Nicknames
	dw Options_OptionsPage
MainOptionsPointersEnd::

Options_TextSpeed:
	ld hl, .Data
	jp Options_Multichoice
	
.Data:
	multichoiceoptiondata TEXT_SPEED_ADDRESS, TEXT_SPEED_SHIFT, TEXT_SPEED_SIZE, 3, NUM_OPTIONS, .Strings

.Strings
	dw .Inst
	dw .Fast
	dw .Mid
	dw .Slow
.Strings_End:
	
.Inst
	db "INST@"

.Fast
	db "FAST@"
.Mid
	db "MID @"
.Slow
	db "SLOW@"

Options_BattleScene:
	ld hl, BATTLE_SHOW_ANIMATIONS_ADDRESS
	ld b, BATTLE_SHOW_ANIMATIONS
	ld c, 7
	jp Options_OnOff

Options_BattleStyle:
	ld hl, BATTLE_SHIFT_ADDRESS
	ld b, BATTLE_SHIFT
	ld c, 9
	ld de, .ShiftSet
	jp Options_TrueFalse
.ShiftSet
	dw .Set
	dw .Shift

.Shift
	db "SHIFT@"
.Set
	db "SET  @"

Options_HoldToMash:
	ld hl, HOLD_TO_MASH_ADDRESS
	ld b, HOLD_TO_MASH
	ld c, 5
	jp Options_OnOff
	
Options_BikeMusic:
	ld hl, .Data
	jp Options_Multichoice
	
.Data:
	multichoiceoptiondata BIKE_MUSIC_ADDRESS, BIKE_MUSIC_SHIFT, BIKE_MUSIC_SIZE, 11, NUM_OPTIONS, .Strings
.Strings:
	dw .Normal
	dw .Yellow
	dw .None
.Strings_End:
	
.Normal
	db "NORMAL@"
.Yellow
	db "YELLOW@"
.None
	db "NONE  @"

Options_Nicknames:
	ld hl, SKIP_NICKNAMING_ADDRESS
	ld b, SKIP_NICKNAMING
	ld c, 13
	ld de, .Options
	jp Options_TrueFalse
.Options
	dw .Yes
	dw .No

.Yes
	db "YES@"
.No
	db "NO @"
