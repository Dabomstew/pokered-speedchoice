musicheader: MACRO
	; number of tracks, track idx, address
	dbw ((\1 - 1) << 6) + (\2 - 1), \3
ENDM

note: MACRO
	dn (\1), (\2) - 1
ENDM

sound: MACRO
	note \1, \2
	db \3 ; intensity
	dw \4 ; frequency
ENDM

noise: MACRO
	note \1, \2 ; duration
	db \3 ; intensity
	db \4 ; frequency
ENDM

; MusicCommands indexes (see audio/engine.asm)
	enum_start $d0, +8
FIRST_MUSIC_CMD EQU __enum__

	enum octave_cmd ; $d0
octave: MACRO
	db octave_cmd | 8 - (\1)
ENDM

__enumdir__ = +1

	enum notetype_cmd ; $d8
notetype: MACRO
	db notetype_cmd
	db \1 ; note_length
if _NARG >= 2
	db \2 ; intensity
endc
ENDM

	enum pitchoffset_cmd ; $d9
pitchoffset: MACRO
	db pitchoffset_cmd
	dn \1, \2 - 1 ; octave, key
ENDM

	enum tempo_cmd ; $da
tempo: MACRO
	db tempo_cmd
	bigdw \1 ; tempo
ENDM

	enum dutycycle_cmd ; $db
dutycycle: MACRO
	db dutycycle_cmd
	db \1 ; duty_cycle
ENDM

	enum intensity_cmd ; $dc
intensity: MACRO
	db intensity_cmd
	db \1 ; intensity
ENDM

	enum soundinput_cmd ; $dd
soundinput: MACRO
	db soundinput_cmd
	db \1 ; input
ENDM

	enum sound_duty_cmd ; $de
sound_duty: MACRO
	db sound_duty_cmd
if _NARG == 4
	db \1 | (\2 << 2) | (\3 << 4) | (\4 << 6) ; duty sequence
else
	db \1 ; LEGACY: Support for one-byte duty value
endc
ENDM

	enum togglesfx_cmd ; $df
togglesfx: MACRO
	db togglesfx_cmd
ENDM

	enum slidepitchto_cmd ; $e0
slidepitchto: MACRO
	db slidepitchto_cmd
	db \1 - 1 ; duration
	dn \2, \3 ; octave, pitch
ENDM

	enum vibrato_cmd ; $e1
vibrato: MACRO
	db vibrato_cmd
	db \1 ; delay
	db \2 ; extent
ENDM

	enum unknownmusic0xe2_cmd ; $e2
unknownmusic0xe2: MACRO
	db unknownmusic0xe2_cmd
	db \1 ; unknown
ENDM

	enum togglenoise_cmd ; $e3
togglenoise: MACRO
	db togglenoise_cmd
	db \1 ; id
ENDM

	enum panning_cmd ; $e4
panning: MACRO
	db panning_cmd
	db \1 ; tracks
ENDM

	enum volume_cmd ; $e5
volume: MACRO
	db volume_cmd
	db \1 ; volume
ENDM

	enum tone_cmd ; $e6
tone: MACRO
	db tone_cmd
	bigdw \1 ; tone
ENDM

	enum unknownmusic0xe7_cmd ; $e7
unknownmusic0xe7: MACRO
	db unknownmusic0xe7_cmd
	db \1 ; unknown
ENDM

	enum unknownmusic0xe8_cmd ; $e8
unknownmusic0xe8: MACRO
	db unknownmusic0xe8_cmd
	db \1 ; unknown
ENDM

	enum tempo_relative_cmd ; $e9
tempo_relative: MACRO
	db tempo_relative_cmd
	bigdw \1 ; value
ENDM

	enum restartchannel_cmd ; $ea
restartchannel: MACRO
	db restartchannel_cmd
	dw \1 ; address
ENDM

	enum newsong_cmd ; $eb
newsong: MACRO
	db newsong_cmd
	bigdw \1 ; id
ENDM

	enum sfxpriorityon_cmd ; $ec
sfxpriorityon: MACRO
	db sfxpriorityon_cmd
ENDM

	enum sfxpriorityoff_cmd ; $ed
sfxpriorityoff: MACRO
	db sfxpriorityoff_cmd
ENDM

	enum unknownmusic0xee_cmd ; $ee
unknownmusic0xee: MACRO
	db unknownmusic0xee_cmd
	dw \1 ; address
ENDM

	enum stereopanning_cmd ; $ef
stereopanning: MACRO
	db stereopanning_cmd
	db \1 ; tracks
ENDM

	enum sfxtogglenoise_cmd ; $f0
sfxtogglenoise: MACRO
	db sfxtogglenoise_cmd
	db \1 ; id
ENDM

	enum music0xf1_cmd ; $f1
music0xf1: MACRO
	db music0xf1_cmd
ENDM

	enum music0xf2_cmd ; $f2
music0xf2: MACRO
	db music0xf2_cmd
ENDM

	enum music0xf3_cmd ; $f3
music0xf3: MACRO
	db music0xf3_cmd
ENDM

	enum music0xf4_cmd ; $f4
music0xf4: MACRO
	db music0xf4_cmd
ENDM

	enum music0xf5_cmd ; $f5
music0xf5: MACRO
	db music0xf5_cmd
ENDM

	enum music0xf6_cmd ; $f6
music0xf6: MACRO
	db music0xf6_cmd
ENDM

	enum music0xf7_cmd ; $f7
music0xf7: MACRO
	db music0xf7_cmd
ENDM

	enum music0xf8_cmd ; $f8
music0xf8: MACRO
	db music0xf8_cmd
ENDM

	enum unknownmusic0xf9_cmd ; $f9
unknownmusic0xf9: MACRO
	db unknownmusic0xf9_cmd
ENDM

	enum setcondition_cmd ; $fa
setcondition: MACRO
	db setcondition_cmd
	db \1 ; condition
ENDM

	enum jumpif_cmd ; $fb
jumpif: MACRO
	db jumpif_cmd
	db \1 ; condition
	dw \2 ; address
ENDM

	enum jumpchannel_cmd ; $fc
jumpchannel: MACRO
	db jumpchannel_cmd
	dw \1 ; address
ENDM

	enum loopchannel_cmd ; $fd
loopchannel: MACRO
	db loopchannel_cmd
	db \1 ; count
	dw \2 ; address
ENDM

	enum callchannel_cmd ; $fe
callchannel: MACRO
	db callchannel_cmd
	dw \1 ; address
ENDM

	enum endchannel_cmd ; $ff
endchannel: MACRO
	db endchannel_cmd
ENDM

; red-crysaudio exclusives
unknownnoise0x20: MACRO
	db \1
	db \2
	db \3
ENDM

unknownsfx0x10: MACRO
	db $dd ; soundinput
	db \1
ENDM

unknownsfx0x20: MACRO
    ; noise/sound
    db \1
	db \2
	db \3
	db \4
ENDM

executemusic: MACRO
	togglesfx
ENDM

toggleperfectpitch: MACRO ; XXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	ENDM
	
ftempo: MACRO
	db $f1
	bigdw \1
	ENDM
fdutycycle: MACRO
	db $f2, \1
	ENDM
incoctave: MACRO
	db $f4
	ENDM
decoctave: MACRO
	db $f5
	ENDM
unknownmusic0xde: MACRO
	db $de, \1
	ENDM
unknownmusic0xe0: MACRO
	db $e0, \1, \2
	ENDM
	
StopAllMusic: MACRO
	ld a, $ff
	call PlaySound
ENDM

channel_struct: MACRO
; Addreses are wChannel1 (c101).
\1MusicID::           dw
\1MusicBank::         db
\1Flags1::            db ; 0:on/off 1:subroutine 3:sfx 4:noise 5:rest
\1Flags2::            db ; 0:vibrato on/off 2:duty 4:cry pitch
\1Flags3::            db ; 0:vibrato up/down
\1MusicAddress::      dw
\1LastMusicAddress::  dw
                      dw
\1NoteFlags::         db ; 5:rest
\1Condition::         db ; conditional jumps
\1DutyCycle::         db ; bits 6-7 (0:12.5% 1:25% 2:50% 3:75%)
\1Intensity::         db ; hi:pressure lo:velocity
\1Frequency::         dw ; 11 bits
\1Pitch::             db ; 0:rest 1-c:note
\1Octave::            db ; 7-0 (0 is highest)
\1PitchOffset::       db ; raises existing octaves (to repeat phrases)
\1NoteDuration::      db ; frames remaining for the current note
\1Field16::           ds 1
                      ds 1
\1LoopCount::         db
\1Tempo::             dw
\1Tracks::            db ; hi:left lo:right
\1SFXDutyLoop::       db
\1VibratoDelayCount:: db ; initialized by \1VibratoDelay
\1VibratoDelay::      db ; number of frames a note plays until vibrato starts
\1VibratoExtent::     db
\1VibratoRate::       db ; hi:frames for each alt lo:frames to the next alt
\1PitchWheelTarget::  dw ; frequency endpoint for pitch wheel
\1PitchWheelAmount::  db
\1PitchWheelAmountFraction::   db
\1Field25::           db
                      ds 1
\1CryPitch::          dw
\1Field29::           ds 1
\1Field2a::           ds 2
\1Field2c::           ds 1
\1NoteLength::        db ; frames per 16th note
\1Field2e::           ds 1
\1Field2f::           ds 1
\1Field30::           ds 1
                      ds 1
ENDM
