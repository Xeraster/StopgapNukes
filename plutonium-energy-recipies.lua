plutonium = {}
local bigger_nukes = require("bigger_nukes")

--chatgpt came up with this one
local function remove_effect(tech, name)
  if not tech or not tech.effects then return end

  for i = #tech.effects, 1, -1 do
    if tech.effects[i].type == "unlock-recipe" and tech.effects[i].recipe == name then
      table.remove(tech.effects, i)
    end
  end
end

function plutonium.do_plutonium_recipies(vanilla_235_override)
    local pl_mult = settings.startup["stopgapnukes-PlutoniumEnergy-setting-quantity"].value

    --banning values lower than 0.01 and properly using math.ceil SHOULD prevent crash-causing values from being fed into this
    if pl_mult < 0.01 then
        pl_mult = 0.01
    end
    
    local uranium_bullet_amount = math.ceil(pl_mult * 100)
    local vanilla_nuke_amount = math.ceil(pl_mult * vanilla_235_override)

    --redundant code copied from bigger_nukes.lua. There just wasn't another way that doesn't involve restructuring and rewriting the entire mod. I'd be debugging crashes and mod conflicts for a fuckin' year if I attempted that. 
    --Did you know certain effects and explosions WONT WORK if everything in isn't declared in the same file and in a specific order that can only be figured out by guessing and reloading until it magically works? It SUCKS.
    local heavy_water_mult = settings.startup["stopgapnukes_basic_heavy_water_requirement_behaviour"].value
    local advanced_cannon_neutronplates = settings.startup["stopgapnukes_advanced_cannon_shell_heavy_water_neutronplates_behaviour"].value
    local advanced_cannon_shell_heavy_water_amount = math.floor(40 * heavy_water_mult)
advanced_cannon_shell_recipe_ingredients =
    {
    	{type="item", name="neutron-reflector", amount = 20},
	{type="item", name="explosives", amount = 10},
	{type="item", name="plutonium-239", amount = math.ceil(150 * pl_mult)},
	{type="item", name="processing-unit", amount = 30},
        {type = "item", name = "explosive-cannon-shell", amount = 1},
        {type = "fluid", name = "heavy-water", amount = advanced_cannon_shell_heavy_water_amount}
    }

if advanced_cannon_neutronplates then
	advanced_cannon_shell_recipe_ingredients = 
	{
		{type="item", name="explosives", amount = 10},
		{type="item", name="plutonium-239", amount = math.ceil(150 * pl_mult)},
		{type="item", name="processing-unit", amount = 30},
        	{type = "item", name = "explosive-cannon-shell", amount = 1},
        	{type = "fluid", name = "heavy-water", amount = advanced_cannon_shell_heavy_water_amount + 20}
    	}
end

local medium_cannon_shell_heavy_water_amount = math.floor(80 * heavy_water_mult)
medium_cannon_shell_recipe_ingredients =
    {
    	{type="item", name="neutron-reflector", amount = 20},
	{type="item", name="explosives", amount = 20},
	{type="item", name="plutonium-239", amount = math.ceil(250 * pl_mult)},
	{type="item", name="processing-unit", amount = 40},
        {type = "item", name = "explosive-cannon-shell", amount = 1},
        {type = "fluid", name = "heavy-water", amount = medium_cannon_shell_heavy_water_amount}
    }
    
if advanced_cannon_neutronplates then
	medium_cannon_shell_recipe_ingredients =
    {
	{type="item", name="explosives", amount = 20},
	{type="item", name="plutonium-239", amount = math.ceil(250 * pl_mult)},
	{type="item", name="processing-unit", amount = 40},
        {type = "item", name = "explosive-cannon-shell", amount = 1},
        {type = "fluid", name = "heavy-water", amount = medium_cannon_shell_heavy_water_amount + 20}
    }
end

data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_nuclearbullet_recipe-plutonium",
		category = "crafting-with-fluid",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			{type="item", name="plutonium-239", amount = uranium_bullet_amount},
			{type="item", name="uranium-rounds-magazine", amount = 1},
			{type="item", name="processing-unit", amount = 10},
			{type="fluid", name="tritium", amount = 10},
			--{type="item", name="tungsten-plate", amount = 10}--values used in space age
			{type="item", name="steel-plate", amount = 10}
		},
		results = 
    {
			{type = "item", name = "nuclear_bullet_ammo", amount = 1},
		},
		icon="__StopgapNukes__/graphics/icons/plutonium/nuclear-rounds-magazine.png"
  },
  {
    type = "recipe",
    name = "stopgapnukes_nuclear_artillery_shell_recipe-plutonium",
    enabled = false,
    energy_required = 30,
    ingredients =
    {
      {type = "item", name = "artillery-shell", amount = 1},
      {type = "item", name = "plutonium-239", amount = vanilla_nuke_amount}
    },
    results = {{type="item", name="nuclear_artillery_shell", amount=1}}
  },
  {
    type = "recipe",
    name = "stopgapnukes_nuclear_cannon_shell_recipe-plutonium",
    enabled = false,
    energy_required = 35,
    ingredients =
    {
      {type = "item", name = "explosive-cannon-shell", amount = 1},
      {type = "item", name = "plutonium-239", amount = vanilla_nuke_amount},
      {type = "item", name = "low-density-structure", amount = 10},
      {type = "item", name = "processing-unit", amount = 10}
    },
    results = {{type="item", name="nuclear_cannon_shell", amount=1}},
	icon="__StopgapNukes__/graphics/icons/plutonium/nuclear-artillery-shell.png",
  },
})

data:extend({
  {
    type = "recipe",
    name = "stopgapnukes_big_nuclear_artillery_shell_recipe-plutonium",
    enabled = false,
    energy_required = 30,
    ingredients =
    {
    {type="item", name="neutron-reflector", amount = 10},
	{type="item", name="explosives", amount = 10},
	{type="item", name="plutonium-239", amount = math.ceil(180 * pl_mult)},
	{type="item", name="processing-unit", amount = 40},
      {type = "item", name = "artillery-shell", amount = 1},
      {type = "item", name = "low-density-structure", amount = 10}
    },
    results = {{type="item", name="big_nuclear_artillery_shell", amount=1}},
	icon="__StopgapNukes__/graphics/icons/plutonium/nuclear-artillery-shell-big.png",
  },
  {
    type = "recipe",
    name = "1kt-artillery-shell-recipe-plutonium",
    enabled = false,
    energy_required = 40,
    ingredients =
    { 
      {type="item", name="neutron-reflector", amount = 40},
      {type="item", name="explosives", amount = 30},
      {type="item", name="rocket-fuel", amount = 60},
      {type="item", name="plutonium-239", amount = math.ceil(350 * pl_mult)},
      {type="item", name="processing-unit", amount = 40},
      {type = "item", name = "artillery-shell", amount = 1}
    },
    results = {{type="item", name="1kt-nuclear-artillery-shell", amount=1}},
	icon="__StopgapNukes__/graphics/icons/plutonium/1kt-artillery-shell.png",
  },
  {
    type = "recipe",
    name = "stopgapnukes_big_nuclear_cannon_shell_recipe-plutonium",
    enabled = false,
    energy_required = 35,
    category = "crafting-with-fluid",
    ingredients = advanced_cannon_shell_recipe_ingredients,
    icon = "__StopgapNukes__/graphics/icons/plutonium/nuclear-cannon-shell-big-heavy.png",
    results = {{type="item", name="big_nuclear_cannon_shell", amount=1}}
  },
  {
    type = "recipe",
    name = "stopgapnukes_big_nuclear_cannon_shell_recipe_noheavywater-plutonium",
    enabled = false,
    energy_required = 35,
    category = "crafting",
    ingredients =
    {
    	{type="item", name="neutron-reflector", amount = 40},
	{type="item", name="explosives", amount = 10},
	{type="item", name="plutonium-239", amount = math.ceil(pl_mult * 150)},
	{type="item", name="processing-unit", amount = 30},
      {type = "item", name = "explosive-cannon-shell", amount = 1},
      {type = "item", name = "low-density-structure", amount = 10}
    },
    results = {{type="item", name="big_nuclear_cannon_shell", amount=1}},
	icon = "__StopgapNukes__/graphics/icons/plutonium/nuclear-cannon-shell-big.png",
  },
  {
    type = "recipe",
    name = "stopgapnukes_medium_nuclear_cannon_shell_recipe-plutonium",
    enabled = false,
    energy_required = 55,
    category = "crafting-with-fluid",
    ingredients = medium_cannon_shell_recipe_ingredients,
    icon = "__StopgapNukes__/graphics/icons/nuclear-cannon-shell-120t-heavy.png",
    results = {{type="item", name="medium_nuclear_cannon_shell", amount=1}},
	icon = "__StopgapNukes__/graphics/icons/plutonium/nuclear-cannon-shell-120t-heavy.png",
  },
  {
    type = "recipe",
    name = "stopgapnukes_medium_nuclear_cannon_shell_recipe_noheavywater-plutonium",
    enabled = false,
    energy_required = 50,
    category = "crafting",
    ingredients =
    {
    	{type="item", name="neutron-reflector", amount = 60},
	{type="item", name="explosives", amount = 20},
	{type="item", name="plutonium-239", amount = math.ceil(250 * pl_mult)},
	{type="item", name="processing-unit", amount = 40},
      {type = "item", name = "explosive-cannon-shell", amount = 1},
      {type = "item", name = "low-density-structure", amount = 10}
    },
    results = {{type="item", name="medium_nuclear_cannon_shell", amount=1}},
	icon = "__StopgapNukes__/graphics/icons/plutonium/nuclear-cannon-shell-120t.png",
  },
})

--recipe for the 15kt atomic bomb
data:extend({
  {
		type = "recipe",
		name = "15kt_atomic_bomb_recipe-plutonium",
		category = "crafting",
		enabled = false,--advanded nukes
		energy_required = 90,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="neutron-reflector", amount = 40},
			{type="item", name="explosives", amount = 30},
			{type="item", name="rocket-fuel", amount = 60},
			{type="item", name="plutonium-239", amount = math.ceil(450 * pl_mult)},
			{type="item", name="processing-unit", amount = 100},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "15kt-atomic-bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/plutonium/15kt-bomb.png",
  }
})

data:extend({
  {
		type = "recipe",
		name = "500kt_atomic_bomb_recipe-plutonium",--a 15kt nuke boosted with heavy water becomes a 500kt nuke. source: trust me bro
		category = "crafting-with-fluid",
		enabled = false,--advanded nukes
		energy_required = 120,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="neutron-reflector", amount = 40},
			{type="item", name="explosives", amount = 30},
			{type="item", name="rocket-fuel", amount = 60},
			{type="item", name="plutonium-239", amount = math.ceil(450 * pl_mult)},
			{type="item", name="processing-unit", amount = 100},
			{type="fluid", name="heavy-water", amount = 200},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "500kt-atomic-bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/plutonium/boosted-fission-bomb-heavy-water.png"
  }
})

data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_big_atomic_bomb_recipe-plutonium",
		category = "crafting-with-fluid",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			{type="fluid", name="heavy-water", amount = (100 * heavy_water_mult)},
			{type="item", name="explosives", amount = 10},
			{type="item", name="rocket-fuel", amount = 30},
			{type="item", name="plutonium-239", amount = math.ceil(180 * pl_mult)},
			{type="item", name="processing-unit", amount = 20},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "big_atomic_bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/plutonium/big-atomic-bomb-heavy-water.png",
  }
})

--recipe for the big atomic bomb with neutron reflectors instead of heavy water
data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_big_atomic_bomb_recipe-neutron-reflectors-plutonium",
		category = "crafting",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="neutron-reflector", amount = 20},
			{type="item", name="explosives", amount = 10},
			{type="item", name="rocket-fuel", amount = 30},
			{type="item", name="plutonium-239", amount = math.ceil(180 * pl_mult)},
			{type="item", name="processing-unit", amount = 20},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "big_atomic_bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/plutonium/big-atomic-bomb-neutron-reflectors.png",
  }
})

--recipe for the 120 ton atomic bomb with heavy water.
data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_medium_atomic_bomb_recipe-plutonium",
		category = "crafting-with-fluid",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			{type="item", name="neutron-reflector", amount = 40},
			{type="fluid", name="heavy-water", amount = (100 * heavy_water_mult)},
			{type="item", name="explosives", amount = 20},
			{type="item", name="rocket-fuel", amount = 45},
			{type="item", name="plutonium-239", amount = math.ceil(200 * pl_mult)},
			{type="item", name="processing-unit", amount = 30},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "medium_atomic_bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/plutonium/120t-atomic-bomb-heavy-water.png",
  }
})

--recipe for the 120 ton atomic bomb with neutron reflectors instead of heavy water
data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_medium_atomic_bomb_recipe-neutron-reflectors-plutonium",
		category = "crafting",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="neutron-reflector", amount = 20},
			{type="item", name="explosives", amount = 10},
			{type="item", name="rocket-fuel", amount = 40},
			{type="item", name="plutonium-239", amount = math.ceil(250 * pl_mult)},
			{type="item", name="processing-unit", amount = 20},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "medium_atomic_bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/plutonium/120t-atomic-bomb-neutron-reflectors.png",
  }
})

--recipe for the 1kt atomic bomb
data:extend({
  {
		type = "recipe",
		name = "1kt_atomic_bomb_recipe-plutonium",
		category = "crafting",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="neutron-reflector", amount = 40},
			{type="item", name="explosives", amount = 30},
			{type="item", name="rocket-fuel", amount = 60},
			{type="item", name="plutonium-239", amount = math.ceil(350 * pl_mult)},
			{type="item", name="processing-unit", amount = 40},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "1kt-atomic-bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/plutonium/1kt-atomic-bomb.png",
  }
})

--recipe for the 1kt atomic bomb with heavy water and less uranium
data:extend({
  {
		type = "recipe",
		name = "1kt_atomic_bomb_heavywater_recipe-plutonium",
		category = "crafting-with-fluid",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			{type="item", name="neutron-reflector", amount = 40},
			{type="item", name="explosives", amount = 30},
			{type="item", name="rocket-fuel", amount = 60},
			{type="item", name="plutonium-239", amount = math.ceil(250 * pl_mult)},
			{type="item", name="processing-unit", amount = 40},
			{type="fluid", name="heavy-water", amount = 100},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "1kt-atomic-bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/plutonium/kt-atomic-bomb-heavy-water.png",
  }
})

--recipe for the 15kt atomic bomb
data:extend({
  {
		type = "recipe",
		name = "15kt_atomic_bomb_recipe-plutonium",
		category = "crafting",
		enabled = false,--advanded nukes
		energy_required = 90,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="neutron-reflector", amount = 40},
			{type="item", name="explosives", amount = 30},
			{type="item", name="rocket-fuel", amount = 60},
			{type="item", name="plutonium-239", amount = math.ceil(450 * pl_mult)},
			{type="item", name="processing-unit", amount = 100},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "15kt-atomic-bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/plutonium/15kt-bomb.png",
  }
})

data:extend({
{
    type = "recipe",
    name = "15kt-artillery-shell-recipe-plutonium",
    enabled = false,
    energy_required = 40,
    category = "crafting-with-fluid",
    ingredients =
    { 
      {type="item", name="neutron-reflector", amount = 40},
      {type="item", name="explosives", amount = 30},
      {type="fluid", name="heavy-water", amount = 100},
      {type="item", name="plutonium-239", amount = math.ceil(450 * pl_mult)},
      {type="item", name="processing-unit", amount = 40},
      {type = "item", name = "artillery-shell", amount = 1},
    },
    results = {{type="item", name="15kt-nuclear-artillery-shell", amount=1}},
	icon = "__StopgapNukes__/graphics/icons/plutonium/15kt-artillery-shell.png",
  }
})

data:extend({
{
    type = "recipe",
    name = "stopgapnukes_nuclear_artillery_shell_recipe-plutonium",
    enabled = false,
    energy_required = 30,
    ingredients =
    {
      {type = "item", name = "artillery-shell", amount = 1},
      {type = "item", name = "plutonium-239", amount = math.ceil(vanilla_235_override * pl_mult)}
    },
    results = {{type="item", name="nuclear_artillery_shell", amount=1}},
	icon = "__StopgapNukes__/graphics/icons/plutonium/nuclear-artillery-shell.png",
  },
  {
    type = "recipe",
    name = "stopgapnukes_nuclear_cannon_shell_recipe-plutonium",
    enabled = false,
    energy_required = 35,
    ingredients =
    {
      {type = "item", name = "explosive-cannon-shell", amount = 1},
      {type = "item", name = "plutonium-239", amount = math.ceil(vanilla_235_override * pl_mult)},
      {type = "item", name = "low-density-structure", amount = 10},
      {type = "item", name = "processing-unit", amount = 10}
    },
    results = {{type="item", name="nuclear_cannon_shell", amount=1}},
	icon = "__StopgapNukes__/graphics/icons/plutonium/nuclear-cannon-shell.png",
  },
  {
    type = "recipe",
    name = "atomic-bomb-plutonium",
    enabled = false,
    energy_required = 50,
	order = "d[rocket-launcher]-d[atomic-bomb]",
    ingredients =
    {
		{type = "item", name = "processing-unit", amount = 10},
		{type = "item", name = "explosives", amount = 10},
		{type = "item", name = "plutonium-239", amount = math.ceil(vanilla_235_override * pl_mult)}
	},
    results = {{type="item", name="atomic-bomb", amount=1}},
	icon = "__StopgapNukes__/graphics/icons/plutonium/atomic-bomb.png",
  },
})

data:extend({
  {
		type = "recipe",
		name = "tritium-recipe-plutonium",
		category = "chemistry",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			--{"stone", 10},
			{type="fluid", name="heavy-water", amount = 100},
			{type="item", name="plutonium-fuel-cell", amount = 1},
		},
		results = 
    {
			{type = "fluid", name = "tritium", amount = math.ceil(1 / pl_mult)},
			{type = "fluid", name = "water", amount = 90},
			{type = "item", name = "depleted-plutonium-fuel-cell", amount = 1}
		},
		icon = "__StopgapNukes__/graphics/icons/plutonium/plutonium_tritium_crafting_icon.png",
		subgroup = "intermediate-product",
		allow_productivity = true,
		crafting_machine_tint =
		{
		  primary = {r = 0.0, g = 0.96, b = 0.97, a = 1.000}, -- #c298c6ff
		  secondary = {r = 0.0, g = 0.96, b = 0.80, a = 1.000}, -- #c28cd7ff
		  tertiary = {r = 0.0, g = 0.65, b = 0.80, a = 1.000}, -- #e4c597ff
		  quaternary = {r = 1.000, g = 0.734, b = 0.290, a = 1.000}, -- #ffbb49ff
		}
		--main_product = "",
    --allow_decomposition = false,
    --allow_productivity = true,
  }
  })

data:extend({
  {
    type = "recipe",
    name = "dirty-bomb-artillery-shell-plutonium",
    enabled = false,
    energy_required = 30,
    category = "crafting-with-fluid",
    ingredients =
    {
      {type = "fluid", name = "sulfuric-acid", amount = 100},
      {type = "item", name = "plutonium-239", amount = math.ceil(10 * pl_mult)},
      {type = "item", name = "coal", amount = 20},
      {type = "item", name = "artillery-shell", amount = 1},
    },
    results = {{type="item", name="dirty-bomb-artillery-shell", amount=1}},
	icon = "__StopgapNukes__/graphics/icons/plutonium/dirty-bomb-artillery-shell.png",
  }
})

data:extend({
{
    type = "recipe",
    name = "dirty-bomb-plutonium",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 15,
    ingredients =
    {
      {type = "fluid", name = "sulfuric-acid", amount = 100},
      {type = "item", name = "plutonium-239", amount = math.ceil(10 * pl_mult)},
      {type = "item", name = "coal", amount = 20},
      {type = "item", name = "rocket", amount = 1},
    },
    results = {{type="item", name="dirty-bomb", amount=1}},
	icon = "__StopgapNukes__/graphics/icons/plutonium/dirty-bomb.png",
  },
})

if mods["space-age"] then
    data.raw.recipe["stopgapnukes_nuclearbullet_recipe-plutonium"].ingredients = 
      {
	{type="item", name="plutonium-239", amount = math.ceil(100 * pl_mult)},
	{type="item", name="uranium-rounds-magazine", amount = 1},
	{type="item", name="processing-unit", amount = 10},
	{type="fluid", name="tritium", amount = 10},
	{type="item", name="tungsten-plate", amount = 10}
    }
end
end

--insert the plutonium recipies to all of their respective tech researches
function plutonium.insert_plutonium_techs()
	local effect_table3 = data.raw.technology["atomic-bomb"].effects
    local effect_table1 = data.raw.technology["thermonuclear-fusion"].effects
	local dirtybomb_tech_table = data.raw.technology["dirty-bomb"].effects
    table.insert(effect_table1,{ type = "unlock-recipe", recipe="stopgapnukes_nuclearbullet_recipe-plutonium" })

    local effect_table2 = data.raw.technology["large-atomic-bomb"].effects
    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="stopgapnukes_big_nuclear_artillery_shell_recipe-plutonium" })
    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="1kt-artillery-shell-recipe-plutonium" })
    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="stopgapnukes_big_nuclear_cannon_shell_recipe-plutonium" })
    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="stopgapnukes_big_nuclear_cannon_shell_recipe_noheavywater-plutonium" })
    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="stopgapnukes_medium_nuclear_cannon_shell_recipe-plutonium" })
    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="stopgapnukes_medium_nuclear_cannon_shell_recipe_noheavywater-plutonium" })

    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="stopgapnukes_big_atomic_bomb_recipe-plutonium" })
    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="stopgapnukes_big_atomic_bomb_recipe-neutron-reflectors-plutonium" })

    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="stopgapnukes_medium_atomic_bomb_recipe-plutonium" })
    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="stopgapnukes_medium_atomic_bomb_recipe-neutron-reflectors-plutonium" })
    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="1kt_atomic_bomb_recipe-plutonium" })
    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="1kt_atomic_bomb_heavywater_recipe-plutonium" })

    table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="15kt_atomic_bomb_recipe-plutonium" })
	table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="15kt-artillery-shell-recipe-plutonium" })

	table.insert(effect_table3 ,{ type = "unlock-recipe", recipe="stopgapnukes_nuclear_artillery_shell_recipe-plutonium" })
	table.insert(effect_table3 ,{ type = "unlock-recipe", recipe="stopgapnukes_nuclear_cannon_shell_recipe-plutonium" })
	table.insert(effect_table3 ,{ type = "unlock-recipe", recipe="atomic-bomb-plutonium" })
	
	table.insert(effect_table1 ,{ type = "unlock-recipe", recipe="tritium-recipe-plutonium" })

	table.insert(dirtybomb_tech_table, { type = "unlock-recipe", recipe="dirty-bomb-plutonium" })
	table.insert(dirtybomb_tech_table, { type = "unlock-recipe", recipe="dirty-bomb-artillery-shell-plutonium" })

	--yay more unavoidable redundant code thats going to cause unforseeable issues for random people months from now. woot woot.
	local stopgapnukes_boosted_fission_tech_behaviour = settings.startup["stopgapnukes_boosted_fission_tech_behaviour"].value
	if stopgapnukes_boosted_fission_tech_behaviour then
		table.insert(effect_table1 ,{ type = "unlock-recipe", recipe="500kt_atomic_bomb_recipe-plutonium" })
	else
		table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="500kt_atomic_bomb_recipe-plutonium" })
	end
    --table.insert(effect_table2 ,{ type = "unlock-recipe", recipe="500kt_atomic_bomb_recipe-plutonium" })


end

--remove the uranium versions of the recipies
function plutonium.remove_uranium_techs()
    local tech1 = data.raw.technology["thermonuclear-fusion"]
    local tech2 = data.raw.technology["large-atomic-bomb"]
	local tech3 = data.raw.technology["atomic-bomb"]
	local dirtybomb_tech_table = data.raw.technology["dirty-bomb"]
    remove_effect(tech1, "stopgapnukes_nuclearbullet_recipe")

    remove_effect(tech2, "stopgapnukes_big_nuclear_artillery_shell_recipe")
    remove_effect(tech2, "1kt-artillery-shell-recipe")
    remove_effect(tech2, "stopgapnukes_big_nuclear_cannon_shell_recipe")
    remove_effect(tech2, "stopgapnukes_big_nuclear_cannon_shell_recipe_noheavywater")
    remove_effect(tech2, "stopgapnukes_medium_nuclear_cannon_shell_recipe")
    remove_effect(tech2, "stopgapnukes_medium_nuclear_cannon_shell_recipe_noheavywater")
    remove_effect(tech2, "stopgapnukes_big_atomic_bomb_recipe")
    remove_effect(tech2, "stopgapnukes_big_atomic_bomb_recipe-neutron-reflectors")
    remove_effect(tech2, "stopgapnukes_medium_atomic_bomb_recipe")
    remove_effect(tech2, "stopgapnukes_medium_atomic_bomb_recipe-neutron-reflectors")
    remove_effect(tech2, "1kt_atomic_bomb_recipe")
    remove_effect(tech2, "1kt_atomic_bomb_heavywater_recipe")
    remove_effect(tech2, "15kt_atomic_bomb_recipe")
	remove_effect(tech2, "15kt-artillery-shell-recipe")

	remove_effect(tech1, "500kt_atomic_bomb_recipe")
    remove_effect(tech2, "500kt_atomic_bomb_recipe")

	remove_effect(tech3, "stopgapnukes_nuclear_artillery_shell_recipe")
	remove_effect(tech3, "stopgapnukes_nuclear_cannon_shell_recipe")
	remove_effect(tech3, "atomic-bomb")

	remove_effect(dirtybomb_tech_table, "dirty-bomb")
	remove_effect(dirtybomb_tech_table, "dirty-bomb-artillery-shell")

end

return plutonium