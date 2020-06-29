# Red Speedchoice Features
This is a list of what is different in Red Speedchoice relative to a vanilla Pokemon Red game.

Table of contents
=================

   * [Engine Changes](#engine-changes)
   * [Permanent Options](#permanent-options)
   * [Normal Options](#normal-options)
   * [Done Screen](#done-screen)
   * [Why U No?](#why-u-no)

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
* Better Marts (On/Off) - when on, all early marts (Viridian/Pewter/Cerulean) use a common inventory that includes all status heals plus repels and escape ropes. Celadon Mart 4F also sells Moon Stones at 2100 each.
* Nerf Brock (On/Off) - when on, Brock's party levels are nerfed to 10 and 12 for the Geodude and Onix respectively. His single gym trainer is also nerfed to have two lv9 Pokemon instead of lv11.
* Better Game Corner (On/Off) - when on, the Gen 2 interface for buying coins is used at the Game Corner. This means that you can buy 500 coins at a time instead of only 50, and you can also quickly buy multiple sets in short succession.
* Easy Safari (On/Off) - when on, you receive 99 Safari Balls and 999 steps each time you enter. In addition, Safari Balls will have a 100% catch rate.
* Early Victory Road (On/Off) - when on, the first 7 badge checkers on Route 23 are removed and the Earth Badge check is moved to after Victory Road. In practice, this means that you can fish on Route 23 as soon as you have a rod, and reach its grass and the first floor of Victory Road as soon as you can Surf. Reaching the other floors of Victory Road will also require Strength, unless you have the next option switched on as well.
* Fast Victory Road (On/Off) - when on, the 4 "exit boulders" in Victory Road are removed, allowing you to bike through it extremely quickly and bypassing the need for Strength entirely. Note that this is completely separate from "Early Victory Road" - it has no impact on what badges you need to reach Victory Road in the first place.
* B To Go Fast (On/Off) - when on, holding B on the overworld will double your movement speed. If you are on a bike, this stacks with the bike speed increase to result in 4x movement speed overall.
* Start With Bike (On/Off) - when on, you begin the game with a Bicycle in your inventory.
* Start With Drink (On/Off) - when on, you begin the game with a single Fresh Water in your inventory. Make sure to not use it before reaching the Saffron guards!
* Pokedex Area Beep (On/Off) - when on, if you view the Pokedex area data for a Pokemon while you are on a map where that Pokemon appears as a grass/surfing/cave encounter, the game will briefly pause and make 3 beeping noises. This allows you to find which floor of a multi-floor area contains a certain Pokemon much easier.
* Keep Warden Candy (On/Off) - when on, picking up the Rare Candy item ball in the Safari Zone Warden's house will always give you a Rare Candy, even if the ROM has been randomized to turn that item into something else. This guarantees you can obtain at least one Rare Candy during your playthrough.
* Levelup Moves:
  * Can Skip - vanilla gen1 behavior - you skip levelup moves if you gain multiple levels at once and skip their exact level.
  * No Skip - vanilla gen2 and up behavior - all the levels you passed through are considered for levelup moves.
* Metronome Only (On/Off) - when on, you will always use Metronome every turn and so will your opponent. The move selection menu is removed entirely. You will also never run out of PP.
* Select To:
  * None - vanilla behavior, pressing SELECT in the overworld does nothing.
  * Bike - if you hit SELECT on the overworld when you have a Bicycle in your inventory, you will mount/dismount it. If you don't have one, nothing happens.
  * Jack - if you hit SELECT on the overworld you will enter a "Jack" state (named for a glitch item in vanilla Blue that gives the state) where you can clip through 1-2 tile wide walls. For more info you can read [this Glitch City Laboratories page](https://glitchcity.info/wiki/Rival%27s_effect).
* Rods Always Work (On/Off) - when on, fishing rods (Good Rod/Super Rod, Old Rod never failed regardless) will never say "not even a nibble!". You will always get an encounter every time you fish unless the map has no fishing encounters.
* Boat (Normal/Meme) - try it and see, just don't report any weird looking tiles as a glitch.
* Pokemon Pics (Normal/Green/Yellow) - select which set of Pokemon front sprites you want to use for your playthrough. This will probably be moved to be a [normal option](#normal-options) in a later release.

## Normal Options
These are options that are configurable at any time during your playthrough, including before you start. Some are retained from the vanilla game with minor changes, others are new.

* Text Speed - retained from the vanilla game with the addition of INST which gives instant text printing. Default changed to INST.
* Hold To Mash (On/Off) - When on, you can hold A or B to clear textboxes instead of having to press for each individual textbox clear. Default is ON.
* Battle Scene (On/Off) - Refers to animations in battle. Default changed to OFF.
* Battle Style (Shift/Set) - Refers to the prompt to change Pokemon after you faint an opponent trainer's Pokemon. Default changed to SET (no prompt).
* Bike Music:
  * Normal - vanilla Red/Blue behavior, bike music always plays when you get on it.
  * Yellow - vanilla Yellow behavior, bike music will always play unless you are on Route 23, Victory Road or Indigo Plateau.
  * None - bike music is completely disabled.
* Give Nicknames:
  * Yes - you will be prompted to nickname Pokemon you receive or catch as normal.
  * No - all nicknaming prompts outside of the Name Rater service will be skipped. If you run into a nicknaming prompt other than Name Rater with this option selected, please report it as a bug.
* Frame - Refers to the frame shown around textboxes ingame. Directly ported from Gen 2. Frame 1 is the default Gen 1 textbox frame, Frames 2-9 are GSC Frames 1-8, and Frame 10 is the unimplemented GSC Frame 9.
* Palette - allows you to choose the color scheme used ingame. Replaces the ability to choose palette from the GBC/GBA bios since this hack handles its own colors. Offers all possible palette choices from the BIOS as well as a few extras.

## Done Screen

This is a screen that shows you a range of stats from your playthrough, intended to be viewed once you have completed your main goal. The following stats are tracked:

* Playtime, further divided into overworld/battle/menus/intros.
* Step count, divided into walking/biking/surfing.
* Bonks (when you hit your character up against a wall and a distinct sound is heard)
* Battle count, divided into wild battles/trainer battles.
* Battles fled from as well as number of failed escapes.
* Total pokemon fainted by you and your opponent.
* Total experience gained.
* Number of times you switched out.
* Balls thrown and Pokemon captured.
* Moves hit, missed, super effective/not very effective moves used, critical hits and OHKO moves used (by both you and opponents)
* Damage dealt and taken, showing both the actual numbers (so damage is capped to the Pokemon's HP) and theoretical numbers if this were not a factor.
* Money made from battles and selling items.
* Money spent at shops & vending machines.
* Money lost to losing battles.
* Total number of items picked up, bought and sold.
* Number of times saved and number of times a save was loaded.

The third-to-last page of the Done Screen will show you the DVs and Stat Exp for all your Pokemon. You can press Up and Down to scroll between Pokemon two at a time, or hold A while pressing Up and Down to skip between Pokemon locations directly (your party, and then each of the 12 PC Boxes).

The last two pages of the Done Screen will show you the number of times you and your opponents used each individual move in the game. Metronome is deliberately double-counted as both itself and the move it chooses. You can press Up and Down to scroll through the move list, or hit SELECT to jump directly to Metronome itself in the list.

## Why U No?

This is a list of things that **aren't** in Red Speedchoice along with reasons why. Some of these things *may* be added in the future but there are no guarantees.

Q: Why no **BnMode** (Fast soft resets that bypass the game intros and dump you straight into the overworld)?  
A: This isn't in the hack currently due to the author's hesitancy regarding its effect on game balance. It can have some negative effects on optimal strats, namely making spamming resets for a low probability event (known as savescumming) a lot more appealing.

Q: Why no **BikeSlipRun** (A fast method of movement that was present in the old Red FastMenu/3 page options hack)?  
A: Luckytyphlosion (the author of Fastmenu) changed the Red movement engine a lot in his hack and introduced a few bugs. I don't want to have to deal with these bugs myself. BikeSlipRun could theoretically be added without overhauling the movement engine as much as FastMenu did, but there are enough fast movement options already in this hack anyway.

Q: Why no "true colors" (Yellow-style or GSC-style)?  
A: Loading in extra palettes is pretty much an unavoidable source of lag, and I don't want to introduce extra lag in the game. Also, most Gen1 runners are used to seeing the game in its DMG-on-GBC form, aka without "true colors".

Q: Why haven't you fixed any notable Gen 1 bugs like the 256 miss glitch?  
A: Fixing gen 1 bugs would take away from the intended experience for this hack - vanilla gen 1 gameplay but with quality-of-life speedups and minor mechanics changes.

Q: Why haven't you added physical/special split or abilities or more Pokemon (etc, etc)?  
A: Same answer as above.
