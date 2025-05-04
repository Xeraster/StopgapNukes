--get the relevant user settings for the stuff this lua file
local atomic_pollution_mult = settings.startup["stopgapnukes_atomicpollution_behaviour"].value
local thermobaric_pollution_mult = settings.startup["stopgapnukes_thermobaricpollution_behaviour"].value
local vt_effects = settings.startup["stopgapnukes_20t_effects_behaviour"].value
local kt_effects = settings.startup["stopgapnukes_1kt_effects_behaviour"].value

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

  for _,f in pairs(game.forces) do
    f.chart(game.surfaces[surface_index], {{position.x-visable_r,position.y-visable_r},{position.x+visable_r,position.y+visable_r}})
  end
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
end
--nuke-explosion

local function really_big_nuke_explosion(surface_index, source, position, explosion_r, blast_max_r, fire_r, load_r, visable_r, exp1spacing, exp2spacing)
--game.surfaces[surface_index].pollute(position, 20000*atomic_pollution_mult)
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
elseif (event.effect_id=="kt atomic bomb explosion") then
--game.print("running really_big_nuke_explosion")
game.surfaces[event.surface_index].pollute(position, 20000*atomic_pollution_mult)
	if kt_effects then
		really_big_nuke_explosion(event.surface_index, source, position, 280, 350, 330, 600, 600, 1024, 64)
	end
elseif (event.effect_id=="multikt atomic bomb explosion") then
--game.print("running really_big_nuke_explosion")
game.surfaces[event.surface_index].pollute(position, 20000*atomic_pollution_mult)
--really_big_nuke_explosion(event.surface_index, source, position, 1500, 1650, 1650, 6000, 6000, 16384, 4096)
elseif (event.effect_id=="stupid bullet nuke explosion") then
bullet_nuke_explosion(event.surface_index, source, position, 15, 15)
end
end)

remote.add_interface("StopgapNukes Scripts", {
  thermobaricWeaponHit = thermobaric_weapon_hit,
  bigNukeExplosion = big_nuke_explosion
});
