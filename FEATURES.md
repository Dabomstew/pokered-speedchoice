# Red Speedchoice Features
This is a list of what is different in Red Speedchoice relative to a vanilla Pokemon Red game.

## Engine Changes
These are changes that are integral to the game itself and cannot be influenced by options.

* [Permanent options](#permanent-options) screen is displayed when you hit New Game.
  * The name entries for you and your rival have been moved to be part of the permanent options screen.
* [Options menu](#normal-options) now has support for multiple pages and uses the Yellow/Gen2 format.
* [Done screen](#done-screen) has been added. It shows stats that are counted through the playthrough including resets without saving. It can also be displayed automatically if you reach a set goal.
* Power and accuracy of moves is shown to the player in battle above their current PP. This remedies the complete lack of any place to see them in the vanilla game.
* RETIRE menu option available in Safari Zone. Behaves like it does in FRLG.
* You can press left/right on quantity selection at marts to change the quantity by 10. Same mapping as later gens - right = +10, left = -10
* Animations are no longer forced on for the Champion battle.
* Only 7 encounter slots per grass/water instead of 10. Can revert to vanilla encounter slots with a compiler flag.

And the more technical changes:
* GBC double speed mode is active all the time. This reduces lag in some places.
* Crystal audio engine has been added. Credit to Sanqui for the initial port. This does not have much impact right now, but will make adding music later easier.
* LZ compression is used for Pokemon/trainer pictures. This severely reduces the amount of time required to decompress and load them.
* Fly will behave properly without Pallet Town flypoint now (needed for non-default Start In)

## Permanent Options
These are options that are only configurable immediately after you hit New Game. They are generally settings that impact the playthrough in a way that should be the same between all racers (in a speedrun race).

**Preset** is a special selection which allows you to set a preconfigured set of option values based on what kind of run you want to do.
**Player Name** and **Rival Name** are moved here to let players enter whatever names they want without losing time (assuming a standard speedrun start time of selecting "Yes" on the permanent options confirmation screen)

* Start In:
  * Normal - start in Pallet Town as normal.
  * Eevee - start in the rooftop area of Celadon Mansion next to the free Eevee ball.
  * Lapras - start in Silph Co next to the guy who gives you Lapras.
  * Safari - start outside the Safari Zone Gate in Fuchsia City with the intent being that you catch your main in Safari Zone.
  * Tower - start in front of Mr Fuji on top of Pokemon Tower in Lavender Town. You can then explore various options for a main including the Route 16 Snorlax.
  * All non-standard Start In selections give you a free lv2 Magikarp to avoid gamebreaking glitches caused by entering battles without a Pokemon. You are also given a Pokedex item in your PC in case you need Pokedex functionality before you reach Pallet Town.
* Race Goal:
  * Manual - done screen is never automatically triggered. When you want to see it, go to your trainer card and press START followed by confirming.
  * Elite 4 - done screen is automatically triggered when you reach the Hall of Fame after beating E4+Champion. 
  * 151 Dex - done screen is automatically triggered when you return to the overworld (from battle/menus) for the first time after registering 151 caught in your dex.
* Spinners:
  * Normal - there are no spinners, as that is the case in vanilla Gen 1.
  * Hell - all trainers with line of sight spin randomly every 1-16 overworld frames. (2-32 actual frames)
  * Why - all trainers with line of sight spin randomly every 1-4 overworld frames. (2-8 actual frames)
* Trainer Vision:
  * Normal - all trainers retain their vanilla lines of sight.
  * Max - all trainers that have line of sight will have their range extended to the maximum reasonable value (5 tiles)
* Delays:
  * Normal - the original frame delays on textboxes/menus will be retained for the most part.
  * Fast - textboxes and menus will scroll super fast. Also, you can speed up the credits by holding B, and the 10 second wait at the end of them is removed.
* Shake Moves:
  * Normal - moves will retain their usual "animation" when battle animations are off, so moves with a side-effect use a shake animation that is 50 frames faster than the "flash" animation used by those without one.
  * All - all moves will use the faster shake animation when battle animations are off.
* Experience (formula):
  * Normal - battle EXP calculations are the same as vanilla Gen 1 games.
  * B/W - battle EXP calculations use a slightly modified version of the formula introduced in Gen 5 that scales experience according to the level difference between your Pokemon and its opponent. The modifications are that the experience can never be penalised even if you outlevel your opponent, but the constant divisor is increased from 5 to 7. 
  * None - no EXP or stat EXP is awarded in battle. Rare Candies and vitamins still work.
* EXP Splitting:
  * Normal - vanilla behavior for how EXP is split between participants (it is split evenly between alive participants; if Exp All is in bag, half is taken away and then is split between all mons in party after), and vanilla messaging for Exp All (separate message for every party mon)
  * No Spam - vanilla behavior for EXP splitting, but if Exp All activates, there is only a single message printed apart from levelup messages.
  * Gen 6/7 - all alive participants gain full EXP and stat EXP. When Exp All is in inventory, all alive non-participants gain 50% EXP and stat EXP.
  * Gen 8 - same as Gen 6/7, but the non-participant EXP happens without any item requirement. Exp All is completely useless with this setting on.
* Catch EXP (On/Off) - when on, catching a Pokemon awards the same experience as defeating it. Obeys the EXP formula and EXP splitting choices above.
* Good Early Wilds (On/Off) - when on, if you encounter a Pokemon in the wild below level 10, it will be fully evolved. Best suited for randomizer races to beat the game.
* Better Marts (On/Off) - when on, all early marts (Viridian/Pewter/Cerulean) use a common inventory that includes all status heals, repels and escape ropes. Celadon Mart 4F also sells Moon Stones at 2100 each.
* Nerf Brock (On/Off) - when on, Brock's party levels are nerfed to 10 and 12 for the Geodude and Onix respectively. His single gym trainer is also nerfed to have two lv9 Pokemon instead of lv11.
* Better Game Corner (On/Off) - when on, the Gen 2 interface for buying coins is used at the Game Corner. This means that you can buy 500 coins at a time instead of only 50, and you can also quickly buy multiple sets in short succession.
* Easy Safari (On/Off) - when on, 
