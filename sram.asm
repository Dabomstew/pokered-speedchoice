SECTION "Sprite Buffers", SRAM ; BANK 0

sSpriteBuffer0:: ds SPRITEBUFFERSIZE ; a000
sSpriteBuffer1:: ds SPRITEBUFFERSIZE ; a188
sSpriteBuffer2:: ds SPRITEBUFFERSIZE ; a310

	ds $100

sHallOfFame:: ds HOF_TEAM * HOF_TEAM_CAPACITY ; a598

SECTION "Speedchoice Stats", SRAM ; BANK 1
sStatsStart::
sStatsFrameCount:: ds 4
sStatsOWFrameCount:: ds 4
sStatsBattleFrameCount:: ds 4
sStatsMenuFrameCount:: ds 4
sStatsIntrosFrameCount:: ds 4
sStatsSaveCount:: ds 2
sStatsReloadCount:: ds 2
sStatsStepCount:: ds 4
sStatsStepCountWalk:: ds 4
sStatsStepCountBike:: ds 4 ; reordered to match wWalkBikeSurfState
sStatsStepCountSurf:: ds 4
sStatsBonks:: ds 2
sStatsTotalDamageDealt:: ds 4
sStatsActualDamageDealt:: ds 4
sStatsTotalDamageTaken:: ds 4
sStatsActualDamageTaken:: ds 4
sStatsOwnMovesHit:: ds 2
sStatsOwnMovesMissed:: ds 2
sStatsEnemyMovesHit:: ds 2
sStatsEnemyMovesMissed:: ds 2
sStatsOwnMovesSE:: ds 2
sStatsOwnMovesNVE:: ds 2
sStatsEnemyMovesSE:: ds 2
sStatsEnemyMovesNVE:: ds 2
sStatsCriticalsDealt:: ds 2
sStatsOHKOsDealt:: ds 2
sStatsCriticalsTaken:: ds 2
sStatsOHKOsTaken:: ds 2
sStatsPlayerHPHealed:: ds 4
sStatsEnemyHPHealed:: ds 4
sStatsPlayerPokemonFainted:: ds 2
sStatsEnemyPokemonFainted:: ds 2
sStatsExperienceGained:: ds 4
sStatsSwitchouts:: ds 2
sStatsBattles:: ds 2
sStatsTrainerBattles:: ds 2
sStatsWildBattles:: ds 2
sStatsBattlesFled:: ds 2
sStatsFailedRuns:: ds 2
sStatsMoneyMade:: ds 4
sStatsMoneySpent:: ds 4
sStatsMoneyLost:: ds 4
sStatsItemsPickedUp:: ds 2
sStatsItemsBought:: ds 2
sStatsItemsSold:: ds 2
sStatsMovesLearnt:: ds 2
sStatsBallsThrown:: ds 2
sStatsPokemonCaughtInBalls:: ds 2
sStatsEnd::

SECTION "Save Data", SRAM ; BANK 1
sPlayerName::  ds NAME_LENGTH ; a598
sMainData::    ds $789 ; a5a3. hardcoded length to ensure pikasav compatibility
sSpriteData::  ds wSpriteDataEnd - wSpriteDataStart ; ad2c
sPartyData::   ds wPartyDataEnd  - wPartyDataStart ; af2c
sCurBoxData::  ds wBoxDataEnd    - wBoxDataStart ; b0c0
sTilesetType:: ds 1 ; b522
sMainDataCheckSum:: ds 1 ; b523


SECTION "Saved Boxes 1", SRAM ; BANK 2

sBox1:: ds wBoxDataEnd - wBoxDataStart ; a000
sBox2:: ds wBoxDataEnd - wBoxDataStart ; a462
sBox3:: ds wBoxDataEnd - wBoxDataStart ; a8c4
sBox4:: ds wBoxDataEnd - wBoxDataStart ; ad26
sBox5:: ds wBoxDataEnd - wBoxDataStart ; b188
sBox6:: ds wBoxDataEnd - wBoxDataStart ; b5ea
sBank2AllBoxesChecksum:: ds 1 ; ba4c
sBank2IndividualBoxChecksums:: ds 6 ; ba4d


SECTION "Saved Boxes 2", SRAM ; BANK 3

sBox7::  ds wBoxDataEnd - wBoxDataStart ; a000
sBox8::  ds wBoxDataEnd - wBoxDataStart ; a462
sBox9::  ds wBoxDataEnd - wBoxDataStart ; a8c4
sBox10:: ds wBoxDataEnd - wBoxDataStart ; ad26
sBox11:: ds wBoxDataEnd - wBoxDataStart ; b188
sBox12:: ds wBoxDataEnd - wBoxDataStart ; b5ea
sBank3AllBoxesChecksum:: ds 1 ; ba4c
sBank3IndividualBoxChecksums:: ds 6 ; ba4d
