--load in user settings first

local vanilla_235_override = settings.startup["stopgapnukes_vanila_recipe_amount_behaviour"].value
--sanitize possibly invalid values
if vanilla_235_override < 1 then
	vanilla_235_override = 1--i don't know what happens if it gets set to something lower than 1
elseif vanilla_235_override > 10000 then
	vanilla_235_override = 10000--using numbers that are too big caused problems one time, so dont let users do that
end

--edit the vanilla atomic bomb recipe to have the user setting-added values for recipe
data.raw["recipe"]["atomic-bomb"].ingredients = 
{
{type = "item", name = "processing-unit", amount = 10},
{type = "item", name = "explosives", amount = 10},
{type = "item", name = "uranium-235", amount = vanilla_235_override}
}

local neutronplates_tungsten = settings.startup["stopgapnukes_neutronplate_tungsten_behaviour"].value

local stopgapnukes_boosted_fission_tech_behaviour = settings.startup["stopgapnukes_boosted_fission_tech_behaviour"].value

local vanilla_atomicbomb_radar = settings.startup["stopgapnukes_vanilla_atomicbomb_radar"].value
if vanilla_atomicbomb_radar then
table.insert(data.raw.projectile["atomic-rocket"].action.action_delivery.target_effects, { type = "script", effect_id = "vanilla_atomic_bomb_doradar"} )
end

data.raw.projectile["nuclear_cannon_projectile"].action = data.raw.projectile["atomic-rocket"].action
--data.raw.projectile["nuclear_bullet_ammo"].action = data.raw.projectile["atomic-rocket"].action
data.raw["artillery-projectile"]["nuclear_artillery_projectile"].action = data.raw.projectile["atomic-rocket"].action
--table.insert(data.raw["artillery-projectile"]["nuclear_artillery_projectile"].action.action_delivery.target_effects, { type = "script", effect_id = "vanilla_atomic_bomb_doradar"} )
--data.raw["ammo"]["nuclear_bullet_ammo"].ammo_type.action = data.raw.projectile["atomic-rocket"].action

--table.insert(data.raw["ammo"]["nuclear_bullet_ammo"].ammo_type.action, ammoexplosion)
--data.raw["ammo"]["nuclear_bullet_ammo"].ammo_type.final_action = data.raw.projectile["thermobaric-rocket-projectile"].final_action
--warheadWeapon = data.raw.projectile["atomic-rocket"]
--data.raw["ammo"]["nuclear_bullet_ammo"] = weapontype.item.action_creator(name, weapontype.item.range_modifier * warheadWeapon.item.range_modifier, warheadWeapon.projectile.action, warheadWeapon.projectile.final_action, warheadWeapon.projectile.created_action)

data.raw["artillery-projectile"]["thermobaric_artillery_projectile"].action = data.raw.projectile["thermobaric-rocket-projectile"].action
data.raw["artillery-projectile"]["thermobaric_artillery_projectile"].final_action = data.raw.projectile["thermobaric-rocket-projectile"].final_action

--make the vanilla atomic bomb have the range and I want it to have
data.raw["ammo"]["atomic-bomb"].ammo_type.range_modifier = 3.5
data.raw["ammo"]["atomic-bomb"].stack_size = 20

--set the advanced nuclear artillery shell to have the same destroy actions as the large atomic bomb
--data.raw["artillery-projectile"]["nuclear_artillery_projectile"].action = data.raw.projectile["big_atomic_bomb_projectile"].action
--data.raw["artillery-projectile"]["nuclear_artillery_projectile"].final_action = data.raw.projectile["big_atomic_bomb_projectile"].final_action

--make the new nukes unlockable with atomic bomb research
local unlocknuclearcannonshell =
{
    type = "unlock-recipe",
    recipe = "stopgapnukes_nuclear_cannon_shell_recipe"
}

local unlockartilleryshell =
{
    type = "unlock-recipe",
    recipe = "stopgapnukes_nuclear_artillery_shell_recipe"
}


local unlocknuclearbullets =
{
    type = "unlock-recipe",
    recipe = "stopgapnukes_nuclearbullet_recipe"
}

table.insert(data.raw.technology["atomic-bomb"].effects, unlocknuclearcannonshell)
table.insert(data.raw.technology["atomic-bomb"].effects, unlockartilleryshell)
--table.insert(data.raw.technology["atomic-bomb"].effects, unlocknuclearbullets)

local unlock500ktbomb =
{
    type = "unlock-recipe",
    recipe = "500kt_atomic_bomb_recipe"
}

if stopgapnukes_boosted_fission_tech_behaviour then
	table.insert(data.raw.technology["thermonuclear-fusion"].effects, unlock500ktbomb)
else
	table.insert(data.raw.technology["large-atomic-bomb"].effects, unlock500ktbomb)
end

--next, do all the space-age specific modifications
if mods["space-age"] then

	--=======================================
	--SPACE AGE TECHNOLOGY PATCHES
	--=======================================
	--switch thermonuclear over to space-age values
	data.raw["technology"]["thermonuclear-fusion"].unit.ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
        {"metallurgic-science-pack", 1},	--space age metalurgic, so add that if running space age
      }
      
      --switch girdler sulfide research to space-age values
      data.raw["technology"]["girdler-sulfide"].unit.ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
        {"metallurgic-science-pack", 1}	--space age metalurgic, so add that if running space age
      }
      
      --switch full fusion research to stuff that makes sense in space age
      data.raw["technology"]["full-fusion-weapons"].unit.ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
        {"metallurgic-science-pack", 1},
        {"agricultural-science-pack", 1},
        {"electromagnetic-science-pack", 1},
        {"cryogenic-science-pack", 1}
      }
      data.raw["technology"]["full-fusion-weapons"].prerequisites = {"fusion-reactor", "railgun", "thermonuclear-fusion"}
      
      --=======================================
      --SPACE AGE INTERMEDIATE RECIPE PATCHES
      --=======================================
      
      --make neutron reflectors required tungsten in space-age
      if neutronplates_tungsten then
	      data.raw.recipe["stopgapnukes_neutronreflector_recipe"].ingredients = 
	      {
		{type="item", name="low-density-structure", amount = 1},
		{type="item", name="tungsten-plate", amount = 1},
		{type="item", name="plastic-bar", amount = 10},
		{type="fluid", name="petroleum-gas", amount = 10},
		{type="item", name="iron-plate", amount = 5}
	     }
     end
     
     --=======================================
      --SPACE AGE ITEM RECIPE PATCHES
      --=======================================
      
      --nuclear bullet or whatever
      data.raw.recipe["stopgapnukes_nuclearbullet_recipe"].ingredients = 
      {
	{type="item", name="uranium-235", amount = 100},
	{type="item", name="uranium-rounds-magazine", amount = 1},
	{type="item", name="processing-unit", amount = 10},
	{type="fluid", name="tritium", amount = 10},
	{type="item", name="tungsten-plate", amount = 10}
      }
      
      --thermonuclear bomb
      data.raw.recipe["thermonuclear-bomb-recipe"].ingredients = 
      {
	{type="item", name="neutron-reflector", amount = 200},
	{type="item", name="tungsten-plate", amount = 20},
	{type="fluid", name="tritium", amount = 100},
	{type="item", name="uranium-238", amount = 300},
	{type="item", name="15kt-atomic-bomb", amount = 1},
	{type="item", name="processing-unit", amount = 100}
      }
      
      --fusion bomb
      data.raw.recipe["fusion-bomb-recipe"].ingredients = 
      {
	{type="item", name="neutron-reflector", amount = 200},
	{type="item", name="tungsten-plate", amount = 20},
	{type="item", name="fusion-power-cell", amount = 100},
	{type="fluid", name="tritium", amount = 1000},
	{type="item", name="quantum-processor", amount = 100},
	{type="item", name="lithium-plate", amount = 40}
      }
      
      --fusion artillery shell
      data.raw.recipe["fusion-artillery-shell-recipe"].ingredients = 
      { 
        {type="item", name="neutron-reflector", amount = 200},
        {type="item", name="tungsten-plate", amount = 20},
	{type="item", name="fusion-power-cell", amount = 100},
	{type="fluid", name="tritium", amount = 1000},
	{type="item", name="quantum-processor", amount = 100},
	{type="item", name="lithium-plate", amount = 40}
      }
end
