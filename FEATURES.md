# Red Speedchoice Features
This is a list of what is different in Red Speedchoice relative to a vanilla Pokemon Red game.

## Engine Changes
These are changes that are integral to the game itself and cannot be influenced by options.

* [Permanent options](#permanent-options) screen is displayed when you hit New Game.
* [Options menu](#normal-options) now has support for multiple pages and uses the Yellow/Gen2 format.
* [Done screen](#done-screen) has been added. It shows stats that are counted through the playthrough including resets without saving. It can also be displayed automatically if you reach a set goal.
* Power and accuracy of moves is shown to the player in battle above their current PP. This remedies the complete lack of any place to see them in the vanilla game.
* You can press left/right on quantity selection at marts to change the quantity by 10. Same mapping as later gens - right = +10, left = -10
* Animations are no longer forced on for the Champion battle.

And the more technical changes:
* GBC double speed mode is active all the time. This reduces lag in some places.
* Crystal audio engine has been added. Credit to Sanqui for the initial port. This does not have much impact right now, but will make adding music later easier.
* LZ compression is used for Pokemon/trainer pictures. This severely reduces the amount of time required to decompress and load them.
