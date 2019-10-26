; macros for options
optionbytestart: MACRO
optionbit = 0
ENDM

sboption: MACRO
\1 EQU optionbit
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

; wPermanentOptions:
	optionbytestart
	mboption SPINNERS, 2
	sboption MAX_RANGE
	mboption EXP, 2
	sboption BETTER_MARTS
	sboption NERF_PEWTER_GYM
	sboption ALL_MOVES_SHAKE

EXP_NORMAL     EQU %00
EXP_BLACKWHITE EQU %01
EXP_NONE       EQU %10

SPINNERHELL_NORMAL_SPEED EQU %1111
SPINNERHELL_WHY_SPEED EQU %11

; wPermanentOptions2:
	optionbytestart
	sboption SHORT_DELAYS
	sboption GOOD_EARLY_WILDS
	sboption BACKWARDS_BOAT
	sboption METRONOME_ONLY
	mboption SELECTTO, 2
	sboption BETTER_GAME_CORNER

; wPermanentOptions3:
	optionbytestart
	mboption STARTIN, 4 ; there are only 5 atm, but leaving space for up to 16
	mboption RACEGOAL, 2

RACEGOAL_MANUAL    EQU %00
RACEGOAL_ELITEFOUR EQU %01
RACEGOAL_151DEX    EQU %10

; wOverworldSelectFlags:
SELECT_JACK EQU 0
SELECT_BICYCLE EQU 1

; hTimerType:
TIMER_OVERWORLD EQU 0
TIMER_BATTLE EQU 1
TIMER_MENUS EQU 2
TIMER_INTROS EQU 3
