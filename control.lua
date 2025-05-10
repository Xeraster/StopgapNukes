--get the relevant user settings for the stuff this lua file
local mushroomFunctions = require("MushroomCloudInBuilt.control")
local atomic_pollution_mult = settings.startup["stopgapnukes_atomicpollution_behaviour"].value
local thermobaric_pollution_mult = settings.startup["stopgapnukes_thermobaricpollution_behaviour"].value
local vt_effects = settings.startup["stopgapnukes_20t_effects_behaviour"].value
local kt_effects = settings.startup["stopgapnukes_1kt_effects_behaviour"].value

--i tried copy-pasting this block of code from True Nukes to circumvent "attempt to index gloval 'global' a nil value" but it didn't make a differernce
local createBlastSoundsAndFlash = mushroomFunctions[1]
script.on_init(function()
  storage.nuclearTests = {}       -- a map of force-index to maps from atomic-test-pack to count...
  storage.thermalBlasts = {}				-- a simple array, with elements: {surface_index, position, force, thermal_max_r, initialDamage, fireball_r, x, y}, each as a key of the map
  storage.blastWaves = {}					-- a simple array, with elements:
  --{r = currrent explosion radius, pos = centre position, pow = initial blast multiplier (usually initial r*r)
  -- , max = maximum radius, s = surface index, fire = leave fires (true for thermobarics, false for nukes), damage_init = starting damage, speed = how far to jump every round, fire_rad = the radius to which the fire wave is solid
  -- , blast_min_damage = amount of extra damage to add all the time, itt = the number of itterations done, doItts = whether to time slice the blast, ittframe = keeps track of frame count for time slicing
  -- , force = force of the cause of the explosion - allows allocating kills correctly, cause = allows allocating kills to the originator})

  storage.nukeBuildings = {} 				-- array of the LuaEntities for any nukeBuildings
  storage.optimisedNukes = {} 				-- has keys:
  --position, surface_index, crater_internal_r, crater_external_r, fireball_r, fire_outer_r, blast_max_r, tree_fire_max_r, thermal_max_r, check_craters
  --used for doing chunk-by-chunk loading of detonation results

  storage.cratersFast = {} 				-- map: cratersFast[surface index][xposition][yposition] = the highest water height in that area (x, y in units of 10)
  storage.cratersFastData = {}				-- map: cratersFastData[surface index] =
  -- {synch =  1-4 making deep water travel slower, xCount = number of x chunks on this surface, xCountSoFar = number of x chunks done so far this round, xDone = all x values done so far this round}
  storage.cratersFastItterationCount = 0	-- the counter of ticks for circling x chunks - counts up to 53


  storage.cratersSlow = {} 				-- array of {t = time waiting - 20s units, x = xin units of 32, y = y in units of 32, surface = the surface index}
end)

--a psuedorandom seed-based random number generator that SHOULD work without causing desyncs in multiplayer
local A1 = 710425941047
local B1 = 813633012810
local M1 = 711719770602
local function psuedorandom(position, offset)
	X = position.x + (position.y) + offset
	X = (A1 * X + B1) % M1
    	return X
end

local function thermobaric_weapon_hit(surface_index, source, position, explosion_r, blast_max_r, fire_r, load_r, visable_r)
game.surfaces[surface_index].pollute(position, 2000*thermobaric_pollution_mult)
  local force;
  local cause = source;
  if(not (source==nil)) then
    force = source.force
  else
    force = "enemy"
  end
  game.surfaces[surface_index].request_to_generate_chunks(position, load_r/32)
  game.surfaces[surface_index].force_generate_chunk_requests()

  for _,f in pairs(game.forces) do
    f.chart(game.surfaces[surface_index], {{position.x-visable_r,position.y-visable_r},{position.x+visable_r,position.y+visable_r}})
  end
  fireRadius = explosion_r * 2;
  for _,v in pairs(game.surfaces[surface_index].find_tiles_filtered{position=position, radius=fireRadius}) do
    game.surfaces[surface_index].create_entity{name="thermobaric-explosion-fire",position=v.position}
  end
  --nah, fixing that fire shockwave code to work in 2.0 would take ages
end

--advanced atomic bomb. 20t usually
local function big_nuke_explosion(surface_index, source, position, explosion_r, blast_max_r, fire_r, load_r, visable_r)
--game.surfaces[surface_index].pollute(position, 5000*atomic_pollution_mult)
  local force;
  local cause = source;
  if(not (source==nil)) then
    force = source.force
  else
    force = "enemy"
  end
  game.surfaces[surface_index].request_to_generate_chunks(position, load_r/32)
  game.surfaces[surface_index].force_generate_chunk_requests()

  --this gets handled in a different function now
  --for _,f in pairs(game.forces) do
  --  f.chart(game.surfaces[surface_index], {{position.x-visable_r,position.y-visable_r},{position.x+visable_r,position.y+visable_r}})
  --end
  ctr = 0
  expctr = 0
  --modd = ctr % 4--only spawn one of these explosions sometimes
  local modd = psuedorandom(position, ctr)
  for _,v in pairs(game.surfaces[surface_index].find_tiles_filtered{position=position, radius=explosion_r}) do
    if modd % 32 == 0 then
        game.surfaces[surface_index].create_entity{name="massive-explosion",position=v.position}
        expctr = expctr + 1
    end
    ctr = ctr + 1
    --modd = ctr % 4
    modd = psuedorandom(position, ctr)
  end
  --game.print("[big_nuke_explosion]spawned "..expctr.." secondary explosions")
  
  ctr = 0
  expctr = 0
  modd = ctr % 32
  --now spawn a few extra nuke explosions near the middle
  for _,v in pairs(game.surfaces[surface_index].find_tiles_filtered{position=position, radius=(explosion_r/4)}) do
    if modd == 0 then
        game.surfaces[surface_index].create_entity{name="nuke-explosion",position=v.position}
        expctr = expctr + 1
    end
    ctr = ctr + 1
    modd = ctr % 32
  end
  --game.print("[big_nuke_explosion]spawned "..expctr.." nuke explosions")
  
  createBlastSoundsAndFlash(position, game.surfaces[surface_index], explosion_r, blast_max_r, 1800, 15000, 160, 1);
end
--nuke-explosion

local function really_big_nuke_explosion(surface_index, source, position, explosion_r, blast_max_r, fire_r, load_r, visable_r, exp1spacing, exp2spacing)
--game.surfaces[surface_index].pollute(position, 20000*atomic_pollution_mult)

if kt_effects then
  local force;
  local cause = source;
  if(not (source==nil)) then
    force = source.force
  else
    force = "enemy"
  end
  game.surfaces[surface_index].request_to_generate_chunks(position, load_r/32)
  game.surfaces[surface_index].force_generate_chunk_requests()

  --this gets handled in a different function now
  --for _,f in pairs(game.forces) do
  --  f.chart(game.surfaces[surface_index], {{position.x-visable_r,position.y-visable_r},{position.x+visable_r,position.y+visable_r}})
  --end
  ctr = 0
  expctr = 0
  --modd = ctr % exp1spacing--only spawn one of these explosions sometimes
  modd = psuedorandom(position, ctr) % exp1spacing
  for _,v in pairs(game.surfaces[surface_index].find_tiles_filtered{position=position, radius=explosion_r}) do
    if modd == 0 then
        game.surfaces[surface_index].create_entity{name="massive-explosion",position=v.position}
        expctr = expctr + 1
    end
    ctr = ctr + 1
    --modd = ctr % exp1spacing
    modd = psuedorandom(position, ctr) % exp1spacing
  end
  game.print("[really_big_nuke_explosion]spawned "..expctr.." secondary explosions")
  
  ctr = 0
  expctr = 0
  --modd = ctr % exp2spacing
  modd = psuedorandom(position, ctr) % exp2spacing
  --now spawn a few extra nuke explosions near the middle
  for _,v in pairs(game.surfaces[surface_index].find_tiles_filtered{position=position, radius=(explosion_r/4)}) do
    if modd == 0 then
        game.surfaces[surface_index].create_entity{name="nuke-explosion",position=v.position}
        expctr = expctr + 1
    end
    ctr = ctr + 1
    --modd = ctr % exp2spacing
    modd = psuedorandom(position, ctr) % exp2spacing
  end
  game.print("[really_big_nuke_explosion]spawned "..expctr.." nuke explosions")
end
  createBlastSoundsAndFlash(position, game.surfaces[surface_index], explosion_r, blast_max_r, 1800, 15000, 160, 1);
end

local function find_event_position(event)
  if(event.target_position)then
    return event.target_position;
  elseif(event.target_entity and event.target_entity.position) then
    return event.target_entity.position;
  elseif(event.source_position)then
    return event.source_position;
  elseif(event.source_entity and event.source_entity.position) then
    return event.source_entity.position
  else
    return nil;
  end
end

local function bullet_nuke_explosion(surface_index, source, position, radius)
  --meh
  local explosion_r = radius
  local blast_max_r = radius
  local fire_r  = radius
  local load_r = radius
  local visable_r = radius
  local force;
  local cause = source;
  if(not (source==nil)) then
    force = source.force
  else
    force = "enemy"
  end
  game.surfaces[surface_index].request_to_generate_chunks(position, load_r/32)
  game.surfaces[surface_index].force_generate_chunk_requests()

  for _,f in pairs(game.forces) do
    f.chart(game.surfaces[surface_index], {{position.x-visable_r,position.y-visable_r},{position.x+visable_r,position.y+visable_r}})
  end
  ctr = 0
  --128 is too laggy, higher than 256 doesnt work well because the random function sucks too much
  --modd = psuedorandom(position, ctr) % 128
  modd = ctr % 8--actually just do this instead its close enough
  for _,v in pairs(game.surfaces[surface_index].find_tiles_filtered{position=position, radius=explosion_r}) do
    if modd == 0 then
        game.surfaces[surface_index].create_entity{name="massive-explosion",position=v.position}
    end
    ctr = ctr + 1
    --modd = ctr % 4
    --modd = psuedorandom(position, ctr) % 128
    modd = ctr % 8
  end
end

local function reveal_map_area(surface_index, position, visable_r)
  for _,f in pairs(game.forces) do
    f.chart(game.surfaces[surface_index], {{position.x-visable_r,position.y-visable_r},{position.x+visable_r,position.y+visable_r}})
  end
end


script.on_event(defines.events.on_script_trigger_effect, function(event)
local mult = 25
local thermal_mult = 30
local position = find_event_position(event);

local source = event.source_entity
--local inputForce = event.source_entity.force

if(event.effect_id=="Thermobaric Weapon hit large") then
thermobaric_weapon_hit(event.surface_index, source, position, 15, 120, 100, 120, 100);
elseif (event.effect_id=="Thermobaric Weapon hit medium") then
thermobaric_weapon_hit(event.surface_index, source, position, 9, 90, 80, 90, 80);
elseif (event.effect_id=="Big atomic bomb explosion") then
local valmult=5000*atomic_pollution_mult
game.surfaces[event.surface_index].pollute(position, 5000*atomic_pollution_mult)
	if vt_effects then
		big_nuke_explosion(event.surface_index, source, position, 45, 120, 100, 120, 100)
	end
	reveal_map_area(event.surface_index, position, 100)
elseif (event.effect_id=="120t atomic bomb explosion") then
	game.surfaces[event.surface_index].pollute(position, 10000*atomic_pollution_mult)
	createBlastSoundsAndFlash(position, game.surfaces[event.surface_index], 300, 700, 1000, 20000, 200, 1)
	reveal_map_area(event.surface_index, position, 200)
elseif (event.effect_id=="kt atomic bomb explosion") then
--game.print("running really_big_nuke_explosion")
game.surfaces[event.surface_index].pollute(position, 20000*atomic_pollution_mult)
	--if kt_effects then
	--improved so that it's less laggy, there is no longer a reason to completely disable this
	really_big_nuke_explosion(event.surface_index, source, position, 280, 350, 330, 600, 600, 1024, 64)
	reveal_map_area(event.surface_index, position, 250)
	--end
elseif (event.effect_id=="multikt atomic bomb explosion") then
--game.print("running really_big_nuke_explosion")
game.surfaces[event.surface_index].pollute(position, 20000*atomic_pollution_mult)
createBlastSoundsAndFlash(position, game.surfaces[event.surface_index], 1500, 3000, 20000, 100000, 1500, 8)
reveal_map_area(event.surface_index, position, 350)
--really_big_nuke_explosion(event.surface_index, source, position, 1500, 1650, 1650, 6000, 6000, 16384, 4096)
elseif (event.effect_id=="stupid bullet nuke explosion") then
bullet_nuke_explosion(event.surface_index, source, position, 15, 15)
createBlastSoundsAndFlash(position, game.surfaces[event.surface_index], 60, 100, 200, 700, 10, 0.06)
--createBlastSoundsAndFlash(position, game.surfaces[event.surface_index], explosion_r, blast_max_r, 1800, 15000, 160, 1);
elseif (event.effect_id=="vanilla_atomic_bomb_doradar") then
reveal_map_area(event.surface_index, position, 60)
end
end)

remote.add_interface("StopgapNukes Scripts", {
  thermobaricWeaponHit = thermobaric_weapon_hit,
  bigNukeExplosion = big_nuke_explosion
});
