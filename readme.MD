Stopgap Nukes expansion for Factorio 1.1
https://mods.factorio.com/mod/StopgapNukes

Known bugs:
- there is a bug where in map mode, if you open the crafting menu, nukes added by this mod WON'T show the ingredients to make them in the tooltip. Items added by other mods sometimes don't have this bug. I *think* the cause of this is that the def names of the recipes and their items don't match. Fixing this would be a lot of work but it should be possible.

Known bugs that I don't know how to fix:
- explosion effects aren't as good as in True Nukes
- the explosions are a lot less optimized than in True Nukes. You can't realistically use anything larger than the 15kt nuke without it crashing your game in Stopgap Nukes. True Nukes has really efficient and sophisticated explosion code but I have not yet found a way to either reuse that code or make my own that's at least almost as good.


values from nukemaps that im using (more or less):
15kt:
vaporize 200m
heavy damage 400m
moderate blast damage 1.67km
light damage 4.52km

500kt:
vaporize 2km
moderate blast damage 3.63km
light damage 9.34km

2mt:
vaporize 2km
moderate blast damage 7.47km
light blast damage 21km

120t:
vaporize: 45m
heavy damage: 150m
moderate damage: 275m
light damage: 0.75km

20t:
vaporize: 18.5m
heavy damage: 59m
moderate damage: 124m
light damage: 319mm
