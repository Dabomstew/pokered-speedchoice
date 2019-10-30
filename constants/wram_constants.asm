; macros for options
optionbytestart: MACRO
optionbit = 0
ENDM

sboption: MACRO
\1 EQU optionbit
\1_VAL EQU (1 << optionbit)
optionbit = optionbit + 1
ENDM

mboption: MACRO
\1_SHIFT EQU optionbit
\1_SIZE EQU \2
\1_MASK EQU (1 << (optionbit + \2)) - (1 << optionbit)
optionbit = optionbit + \2
ENDM

; wOptions:
	optionbytestart
	mboption TEXT_SPEED, 2
	sboption BATTLE_SHIFT
	sboption BATTLE_SHOW_ANIMATIONS
	sboption HOLD_TO_MASH

TEXT_INSTANT EQU %00
TEXT_FAST    EQU %01
TEXT_MEDIUM  EQU %10
TEXT_SLOW    EQU %11

; wOptions2:
	optionbytestart
	mboption FRAME, 4

; wPermanentOptions:
	optionbytestart
	mboption SPINNERS, 2 ; 0
	sboption MAX_RANGE ; 2
	mboption EXP, 2 ; 3
	sboption BETTER_MARTS ; 5
	sboption NERF_PEWTER_GYM ; 6
	sboption ALL_MOVES_SHAKE ; 7

EXP_NORMAL     EQU %00
EXP_BLACKWHITE EQU %01
EXP_NONE       EQU %10

SPINNERHELL_NORMAL_SPEED EQU %1111
SPINNERHELL_WHY_SPEED EQU %11

; wPermanentOptions2:
	optionbytestart
	sboption SHORT_DELAYS ; 0
	sboption GOOD_EARLY_WILDS ; 1
	sboption BACKWARDS_BOAT ; 2
	sboption METRONOME_ONLY ; 3
	mboption SELECTTO, 2 ; 4
	sboption BETTER_GAME_CORNER ; 6
	sboption EASY_SAFARI ; 7
	
SELECTTO_NONE EQU %00
SELECTTO_BIKE EQU %01
SELECTTO_JACK EQU %10

; wPermanentOptions3:
	optionbytestart
	mboption STARTIN, 4 ; 0 - there are only 5 atm, but leaving space for up to 16
	mboption RACEGOAL, 2 ; 4

RACEGOAL_MANUAL    EQU %00
RACEGOAL_ELITEFOUR EQU %01
RACEGOAL_151DEX    EQU %10

; wPermanentOptions4:
	optionbytestart
	mboption PICSET, 3 ; 0 - only 3 atm, but leaving space for up to 8

; wSpeedchoiceFlags:
DEX_RACEGOAL_DONE EQU 0
DEX_RACEGOAL_EXITING EQU 1
HOF_STATS_SCREEN EQU 2
DEX_RACEGOAL_CHECK EQU 3

; wOverworldSelectFlags:
SELECT_JACK EQU 0
SELECT_BICYCLE EQU 1

; hTimerType:
TIMER_OVERWORLD EQU 0
TIMER_BATTLE EQU 1
TIMER_MENUS EQU 2
TIMER_INTROS EQU 3
