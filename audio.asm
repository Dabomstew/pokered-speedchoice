INCLUDE "constants.asm"


SECTION "Sound Effect Headers 1", ROMX ; BANK $02
INCLUDE "audio/headers/sfxheaders1.asm"

SECTION "Sound Effect Headers 2", ROMX ; BANK $08
INCLUDE "audio/headers/sfxheaders2.asm"

SECTION "Sound Effect Headers 3", ROMX ; BANK $1f
INCLUDE "audio/headers/sfxheaders3.asm"


SECTION "Sound Effects 1", ROMX ; BANK $02

INCLUDE "audio/sfx/start_menu_1.asm"
INCLUDE "audio/sfx/pokeflute.asm"
INCLUDE "audio/sfx/cut_1.asm"
INCLUDE "audio/sfx/go_inside_1.asm"
INCLUDE "audio/sfx/swap_1.asm"
INCLUDE "audio/sfx/tink_1.asm"
INCLUDE "audio/sfx/59_1.asm"
INCLUDE "audio/sfx/purchase_1.asm"
INCLUDE "audio/sfx/collision_1.asm"
INCLUDE "audio/sfx/go_outside_1.asm"
INCLUDE "audio/sfx/press_ab_1.asm"
INCLUDE "audio/sfx/save_1.asm"
INCLUDE "audio/sfx/heal_hp_1.asm"
INCLUDE "audio/sfx/poisoned_1.asm"
INCLUDE "audio/sfx/heal_ailment_1.asm"
INCLUDE "audio/sfx/trade_machine_1.asm"
INCLUDE "audio/sfx/turn_on_pc_1.asm"
INCLUDE "audio/sfx/turn_off_pc_1.asm"
INCLUDE "audio/sfx/enter_pc_1.asm"
INCLUDE "audio/sfx/shrink_1.asm"
INCLUDE "audio/sfx/switch_1.asm"
INCLUDE "audio/sfx/healing_machine_1.asm"
INCLUDE "audio/sfx/teleport_exit1_1.asm"
INCLUDE "audio/sfx/teleport_enter1_1.asm"
INCLUDE "audio/sfx/teleport_exit2_1.asm"
INCLUDE "audio/sfx/ledge_1.asm"
INCLUDE "audio/sfx/teleport_enter2_1.asm"
INCLUDE "audio/sfx/fly_1.asm"
INCLUDE "audio/sfx/denied_1.asm"
INCLUDE "audio/sfx/arrow_tiles_1.asm"
INCLUDE "audio/sfx/push_boulder_1.asm"
INCLUDE "audio/sfx/ss_anne_horn_1.asm"
INCLUDE "audio/sfx/withdraw_deposit_1.asm"
INCLUDE "audio/sfx/safari_zone_pa.asm"
INCLUDE "audio/sfx/get_item1_1.asm"
INCLUDE "audio/sfx/pokedex_rating_1.asm"
INCLUDE "audio/sfx/get_item2_1.asm"
INCLUDE "audio/sfx/get_key_item_1.asm"


SECTION "Sound Effects 2", ROMX ; BANK $08

INCLUDE "audio/sfx/silph_scope.asm"
INCLUDE "audio/sfx/ball_toss.asm"
INCLUDE "audio/sfx/ball_poof.asm"
INCLUDE "audio/sfx/faint_thud.asm"
INCLUDE "audio/sfx/run.asm"
INCLUDE "audio/sfx/dex_page_added.asm"
INCLUDE "audio/sfx/peck.asm"
INCLUDE "audio/sfx/faint_fall.asm"
INCLUDE "audio/sfx/battle_09.asm"
INCLUDE "audio/sfx/pound.asm"
INCLUDE "audio/sfx/battle_0b.asm"
INCLUDE "audio/sfx/battle_0c.asm"
INCLUDE "audio/sfx/battle_0d.asm"
INCLUDE "audio/sfx/battle_0e.asm"
INCLUDE "audio/sfx/battle_0f.asm"
INCLUDE "audio/sfx/damage.asm"
INCLUDE "audio/sfx/not_very_effective.asm"
INCLUDE "audio/sfx/battle_12.asm"
INCLUDE "audio/sfx/battle_13.asm"
INCLUDE "audio/sfx/battle_14.asm"
INCLUDE "audio/sfx/vine_whip.asm"
INCLUDE "audio/sfx/battle_16.asm"
INCLUDE "audio/sfx/battle_17.asm"
INCLUDE "audio/sfx/battle_18.asm"
INCLUDE "audio/sfx/battle_19.asm"
INCLUDE "audio/sfx/super_effective.asm"
INCLUDE "audio/sfx/battle_1b.asm"
INCLUDE "audio/sfx/battle_1c.asm"
INCLUDE "audio/sfx/doubleslap.asm"
INCLUDE "audio/sfx/battle_1e.asm"
INCLUDE "audio/sfx/horn_drill.asm"
INCLUDE "audio/sfx/battle_20.asm"
INCLUDE "audio/sfx/battle_21.asm"
INCLUDE "audio/sfx/battle_22.asm"
INCLUDE "audio/sfx/battle_23.asm"
INCLUDE "audio/sfx/battle_24.asm"
INCLUDE "audio/sfx/battle_25.asm"
INCLUDE "audio/sfx/battle_26.asm"
INCLUDE "audio/sfx/battle_27.asm"
INCLUDE "audio/sfx/battle_28.asm"
INCLUDE "audio/sfx/battle_29.asm"
INCLUDE "audio/sfx/battle_2a.asm"
INCLUDE "audio/sfx/battle_2b.asm"
INCLUDE "audio/sfx/battle_2c.asm"
INCLUDE "audio/sfx/psybeam.asm"
INCLUDE "audio/sfx/battle_2e.asm"
INCLUDE "audio/sfx/battle_2f.asm"
INCLUDE "audio/sfx/psychic_m.asm"
INCLUDE "audio/sfx/battle_31.asm"
INCLUDE "audio/sfx/battle_32.asm"
INCLUDE "audio/sfx/battle_33.asm"
INCLUDE "audio/sfx/battle_34.asm"
INCLUDE "audio/sfx/battle_35.asm"
INCLUDE "audio/sfx/battle_36.asm"
INCLUDE "audio/sfx/level_up.asm"
INCLUDE "audio/sfx/caught_mon.asm"


SECTION "Sound Effects 3", ROMX ; BANK $1f

INCLUDE "audio/sfx/intro_lunge.asm"
INCLUDE "audio/sfx/intro_hip.asm"
INCLUDE "audio/sfx/intro_hop.asm"
INCLUDE "audio/sfx/intro_raise.asm"
INCLUDE "audio/sfx/intro_crash.asm"
INCLUDE "audio/sfx/intro_whoosh.asm"
INCLUDE "audio/sfx/slots_stop_wheel.asm"
INCLUDE "audio/sfx/slots_reward.asm"
INCLUDE "audio/sfx/slots_new_spin.asm"
INCLUDE "audio/sfx/shooting_star.asm"


SECTION "Music Routines", ROMX ; BANK $02

PlayBattleMusic::
	xor a
	ld [wMusicFade], a
	ld [wLowHealthAlarm], a
	dec a
	call PlaySound ; stop music
	call DelayFrame
	ld a, [wGymLeaderNo]
	and a
	jr z, .notGymLeaderBattle
	ld a, MUSIC_GYM_LEADER_BATTLE
	jr .playSong
.notGymLeaderBattle
	ld a, [wCurOpponent]
	cp OPP_ID_OFFSET
	jr c, .wildBattle
	cp OPP_SONY3
	jr z, .finalBattle
	cp OPP_LANCE
	jr nz, .normalTrainerBattle
	ld a, MUSIC_GYM_LEADER_BATTLE ; lance also plays gym leader theme
	jr .playSong
.normalTrainerBattle
	ld a, MUSIC_TRAINER_BATTLE
	jr .playSong
.finalBattle
	ld a, MUSIC_FINAL_BATTLE
	jr .playSong
.wildBattle
	ld a, MUSIC_WILD_BATTLE
.playSong
	jp PlayMusic

SECTION "Alt Music Routines", ROMX

; an alternate start for MeetRival which has a different first measure
Music_RivalAlternateStart::
	ld a, MUSIC_FAREWELL_RIVAL
	jp PlayMusic

; an alternate tempo for MeetRival which is slightly slower
Music_RivalAlternateTempo::
	ld a, MUSIC_MEET_RIVAL_ALT_TEMPO
	jp PlayMusic

; applies both the alternate start and alternate tempo
Music_RivalAlternateStartAndTempo::
	ld a, MUSIC_FAREWELL_RIVAL_ALT_TEMPO
	jp PlayMusic

; an alternate tempo for Cities1 which is used for the Hall of Fame room
Music_Cities1AlternateTempo::
	ld a, 10
	ld [wMusicFade], a
	ld [wMusicFadeCount], a
	xor a ; stop playing music after the fade-out is finished
	ld [wMusicFadeID], a
	ld [wMusicFadeID + 1], a
	ld c, 100
	call DelayFrames ; wait for the fade-out to finish
	ld a, MUSIC_CITIES1_ALT_TEMPO
	jp PlayMusic


SECTION "Pokedex Rating SFX Routines", ROMX ; BANK $1f

PlayPokedexRatingSfx::
	ld a, [$ffdc]
	ld c, $0
	ld hl, OwnedMonValues
.getSfxPointer
	cp [hl]
	jr c, .gotSfxPointer
	inc c
	inc hl
	jr .getSfxPointer
.gotSfxPointer
	push bc
	ld a, $ff
	call PlaySoundWaitForCurrent
	pop bc
	ld b, $0
	ld hl, PokedexRatingSfxPointers
	add hl, bc
	ld a, [hl]
	call PlaySound
	call WaitForSoundToFinish
	jp PlayDefaultMusic

PokedexRatingSfxPointers:
	db SFX_DENIED
	db SFX_POKEDEX_RATING
	db SFX_GET_ITEM_1
	db SFX_CAUGHT_MON
	db SFX_LEVEL_UP
	db SFX_GET_KEY_ITEM
	db SFX_GET_ITEM_2

OwnedMonValues:
	db 10, 40, 60, 90, 120, 150, $ff
	
SECTION "Audio Engine", ROMX

INCLUDE "audio/engine.asm"

Music:
INCLUDE "audio/red_pointers.asm"

INCLUDE "audio/music/nothing.asm"

INCLUDE "audio/cry_pointers.asm"

INCLUDE "audio/rbsfx.asm"

SECTION "RBY Songs 1", ROMX

	inc_section "audio/music/RBY/bikeriding.asm"
	inc_section "audio/music/RBY/dungeon1.asm"
	inc_section "audio/music/RBY/gamecorner.asm"
	inc_section "audio/music/RBY/titlescreen.asm"
	inc_section "audio/music/RBY/dungeon2.asm"
	inc_section "audio/music/RBY/dungeon3.asm"
	inc_section "audio/music/RBY/cinnabarmansion.asm"
	inc_section "audio/music/RBY/oakslab.asm"
	inc_section "audio/music/RBY/pokemontower.asm"
	inc_section "audio/music/RBY/silphco.asm"
	inc_section "audio/music/RBY/meeteviltrainer.asm"
	inc_section "audio/music/RBY/meetfemaletrainer.asm"
	inc_section "audio/music/RBY/meetmaletrainer.asm"
	inc_section "audio/music/RBY/introbattle.asm"
	inc_section "audio/music/RBY/surfing.asm"
	inc_section "audio/music/RBY/jigglypuffsong.asm"
	inc_section "audio/music/RBY/halloffame.asm"
	inc_section "audio/music/RBY/credits.asm"
	inc_section "audio/music/RBY/gymleaderbattle.asm"
	inc_section "audio/music/RBY/trainerbattle.asm"
	inc_section "audio/music/RBY/wildbattle.asm"
	inc_section "audio/music/RBY/finalbattle.asm"

SECTION "RBY Songs 2", ROMX

	inc_section "audio/music/RBY/defeatedtrainer.asm"
	inc_section "audio/music/RBY/defeatedwildmon.asm"
	inc_section "audio/music/RBY/defeatedgymleader.asm"
	inc_section "audio/music/RBY/pkmnhealed.asm"
	inc_section "audio/music/RBY/routes1.asm"
	inc_section "audio/music/RBY/routes2.asm"
	inc_section "audio/music/RBY/routes3.asm"
	inc_section "audio/music/RBY/routes4.asm"
	inc_section "audio/music/RBY/indigoplateau.asm"
	inc_section "audio/music/RBY/pallettown.asm"
	inc_section "audio/music/RBY/unusedsong.asm"
	inc_section "audio/music/RBY/cities1.asm"
	inc_section "audio/music/RBY/museumguy.asm"
	inc_section "audio/music/RBY/meetprofoak.asm"
	inc_section "audio/music/RBY/meetrival.asm"
	inc_section "audio/music/RBY/ssanne.asm"
	inc_section "audio/music/RBY/cities2.asm"
	inc_section "audio/music/RBY/celadon.asm"
	inc_section "audio/music/RBY/cinnabar.asm"
	inc_section "audio/music/RBY/vermilion.asm"
	inc_section "audio/music/RBY/lavender.asm"
	inc_section "audio/music/RBY/safarizone.asm"
	inc_section "audio/music/RBY/gym.asm"
	inc_section "audio/music/RBY/pokecenter.asm"
	inc_section "audio/music/RBY/yellowintro.asm"
	inc_section "audio/music/RBY/surfingpikachu.asm"
	inc_section "audio/music/RBY/meetjessiejames.asm"
	inc_section "audio/music/RBY/yellowunusedsong.asm"

SECTION "Sound Effects", ROMX

INCLUDE "audio/sfx.asm"

SECTION "Crystal Sound Effects", ROMX

INCLUDE "audio/sfx_crystal.asm"

SECTION "Cries", ROMX

INCLUDE "audio/cries.asm"

INCLUDE "data/mon_cries.asm"
