local item_sounds = require("__base__.prototypes.item_sounds")

--maybe putting this before all the other stuff in the load order will make the effects work beter. update: it didn't even make a difference
require("MushroomCloudInBuilt.explosions")
require("MushroomCloudInBuilt.radiation_noise")
require("MushroomCloudInBuilt.ground_zero")
require("MushroomCloudInBuilt.explosion_sizes")

require("fluid")
require("thermonuclear_fuel_prototype")
require("thermobarics")
require("bigger_nukes")
require("the_really_big_ones")
require("technology")

--for some reason its harder to catch things on fire in 2.0, idk why
local fireutil = require("__base__.prototypes.fire-util")
data:extend({
  fireutil.add_basic_fire_graphics_and_effects_definitions
  {
    type = "fire",
    name = "thermobaric-explosion-fire",
    flags = {"placeable-off-grid", "not-on-map"},
    damage_per_tick = {amount = 13 / 60, type = "fire"},
    maximum_damage_multiplier = 6,
    damage_multiplier_increase_per_added_fuel = 1,
    damage_multiplier_decrease_per_tick = 0.005,

    spawn_entity = "fire-flame-on-tree",

    spread_delay = 30,
    spread_delay_deviation = 180,
    maximum_spread_count = 1000,

    --it changed in 2.0
    --emissions_per_second = 0.005,
    emissions_per_second = { pollution = 0.005 },

    initial_lifetime = 50,
    lifetime_increase_by = 150,
    lifetime_increase_cooldown = 4,
    maximum_lifetime = 1800,
    delay_between_initial_flames = 10,
  --initial_flame_count = 1,

  }})
  
local vanilla_235_override = settings.startup["stopgapnukes_vanila_recipe_amount_behaviour"].value

--sanitize possibly invalid values
if vanilla_235_override < 1 then
	vanilla_235_override = 1--i don't know what happens if it gets set to something lower than 1
elseif vanilla_235_override > 10000 then
	vanilla_235_override = 10000--using numbers that are too big caused problems one time, so dont let users do that
end

data:extend({
{
		type = "recipe",
		name = "stopgapnukes_neutronreflector_recipe",
		category = "chemistry",
		enabled = false,
		energy_required = 2,
		ingredients = 
		{
			{type="item", name="low-density-structure", amount = 1},
			--{type="item", name="tungsten-plate", amount = 1},
			{type="item", name="steel-plate", amount = 2},
			{type="item", name="plastic-bar", amount = 10},
			{type="fluid", name="petroleum-gas", amount = 10},
			{type="item", name="iron-plate", amount = 5}
		},
		results = 
    		{
			{type = "item", name = "neutron-reflector", amount = 1}
		},
		allow_productivity = true,
		always_show_made_in = true,
  },

{
    type = "item",
    name = "neutron-reflector",
    icon = "__StopgapNukes__/graphics/stuff/neutron-reflector.png",
    subgroup = "intermediate-product",
    color_hint = { text = "3" },
    order = "c-c",
    inventory_move_sound = item_sounds.resource_inventory_move,
    pick_sound = item_sounds.resource_inventory_pickup,
    drop_sound = item_sounds.resource_inventory_move,
    stack_size = 100,
    ingredient_to_weight_coefficient = 0.25
  },

})

data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_nuclearbullet_recipe",
		category = "crafting-with-fluid",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			{type="item", name="uranium-235", amount = 100},
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
  },
  {
    type = "recipe",
    name = "stopgapnukes_nuclear_artillery_shell_recipe",
    enabled = false,
    energy_required = 30,
    ingredients =
    {
      {type = "item", name = "artillery-shell", amount = 1},
      {type = "item", name = "uranium-235", amount = vanilla_235_override}
    },
    results = {{type="item", name="nuclear_artillery_shell", amount=1}}
  },
  {
    type = "recipe",
    name = "stopgapnukes_nuclear_cannon_shell_recipe",
    enabled = false,
    energy_required = 35,
    ingredients =
    {
      {type = "item", name = "explosive-cannon-shell", amount = 1},
      {type = "item", name = "uranium-235", amount = vanilla_235_override},
      {type = "item", name = "low-density-structure", amount = 10},
      {type = "item", name = "processing-unit", amount = 10}
    },
    results = {{type="item", name="nuclear_cannon_shell", amount=1}}
  },
  {
    type = "projectile",
    name = "nuclear_cannon_projectile",
    flags = {"not-on-map"},
    hidden = true,
    collision_box = {{-0.3, -1.1}, {0.3, 1.1}},
    acceleration = 0,
    piercing_damage = 150,
    --action has to get overridden in data-final-fixes, the nuke explosion works differently from the others
    --action = { basic_nuke_explode_action },
    animation =
    {
      filename = "__base__/graphics/entity/bullet/bullet.png",
      draw_as_glow = true,
      width = 3,
      height = 50,
      priority = "high"
    }
  },
  {
    type = "artillery-projectile",
    name = "nuclear_artillery_projectile",
    flags = {"not-on-map"},
    hidden = true,
    reveal_map = true,
    map_color = {1, 1, 0},
    picture =
    {
      filename = "__base__/graphics/entity/artillery-projectile/shell.png",
      draw_as_glow = true,
      width = 64,
      height = 64,
      scale = 0.5
    },
    shadow =
    {
      filename = "__base__/graphics/entity/artillery-projectile/shell-shadow.png",
      width = 64,
      height = 64,
      scale = 0.5
    },
    chart_picture =
    {
      filename = "__StopgapNukes__/graphics/artillery/atomic-artillery-map-visualization.png",
      flags = { "icon" },
      width = 64,
      height = 64,
      priority = "high",
      scale = 0.25
    },
    --action gets set in data final fixes
    height_from_ground = 280 / 64
  },
})

local nuclear_bullet_ammo_action = 
    {
        type = "direct",
        action_delivery =
        {
            type = "instant",
            source_effects =
            {
                type = "create-explosion",
                entity_name = "explosion-gunshot"
            },
            target_effects =
            {
                {
                    type = "create-entity",
                    entity_name = "explosion-hit",
                    offsets = { { 0, 1 } },
                    offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } }
                },
                {
                    type = "damage",
                    damage = { amount = 5400, type = "physical" }
                },
                {
		    type = "create-entity",
		    entity_name = "medium-scorchmark-tintable",
		    check_buildability = true
		},
                {
                    type = "activate-impact",
                    deliver_category = "bullet"
                },
                {
		    type = "create-entity",
		    entity_name = "small-uranium-explosion-LUQ"
		  },
		  {
		    type = "create-entity",
		    entity_name = "small-uranium-explosion-RUQ"
		  },
		  {
		    type = "create-entity",
		    entity_name = "small-uranium-explosion-LLQ"
		  },
		  {
		    type = "create-entity",
		    entity_name = "small-uranium-explosion-RLQ"
		  },
                {
		    type = "create-entity",
		    entity_name = "nuke-explosion"
		  },
		  {
		    type = "destroy-cliffs",
		    radius = 10,
		    explosion_at_trigger = "explosion"
		  },
                {
                    type = "nested-result",
                    action =
                    {
                        type = "area",
                        radius = 16.5,
                        action_delivery =
                        {
                            type = "instant",
                            target_effects =
                            {
                                {
                                --i have no idea why this works and essentially nothing else does. You can't even call a script and have it evenpass the correct position as a parameter
                                    type = "damage",
                                    damage = { amount = 3500, type = "explosion" }
                                },
                                {
                                    type = "create-entity",
                                    entity_name = "explosion"
                                },
                                
                            }
                        },
                    }
                },
            }
        }
}

local nuclear_bullet_ammo = {
  type = "ammo",
  name = "nuclear_bullet_ammo",
  icon = "__StopgapNukes__/graphics/icons/nuclear-rounds-magazine.png",
  icon_size = 64, icon_mipmaps = 4,
  ammo_category="bullet",
  ammo_type = {
    --category = "bullet",
    action = nuclear_bullet_ammo_action
  },
  magazine_size = 10,
  subgroup = "ammo",
  order = "b[basic-clips]-b[firearm-magazine]",
  inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
  pick_sound = item_sounds.atomic_bomb_inventory_pickup,
  drop_sound = item_sounds.atomic_bomb_inventory_move,
  stack_size = 100,
  weight = 10*kg
}

local nuclear_artillery_shell = {
    type = "ammo",
    name = "nuclear_artillery_shell",
    icon = "__StopgapNukes__/graphics/icons/nuclear-artillery-shell.png",
    ammo_category = "artillery-shell",
    ammo_type =
    {
      range_modifier = 4,
      target_type = "position",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "artillery",
          projectile = "nuclear_artillery_projectile",
          starting_speed = 1,
          direction_deviation = 0,
          range_deviation = 0,
          source_effects =
          {
            type = "create-explosion",
            entity_name = "artillery-cannon-muzzle-flash"
          }
        }
      }
    },
    subgroup = "ammo",
    order = "d[explosive-cannon-shell]-d[artillery]2",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 1,
    weight = 100*kg
  }
  
local nuclear_cannon_shell = {
    type = "ammo",
    name = "nuclear_cannon_shell",
    icon = "__StopgapNukes__/graphics/icons/nuclear-cannon-shell.png",
    pictures =
    {
      layers =
      {
        {
          size = 64,
          filename = "__StopgapNukes__/graphics/icons/nuclear-cannon-shell.png",
          scale = 0.5,
          mipmap_count = 4
        },
        {
          draw_as_light = true,
          flags = {"light"},
          size = 64,
          filename = "__base__/graphics/icons/uranium-cannon-shell-light.png",
          scale = 0.5
        }
      }
    },
    ammo_category = "cannon-shell",
    ammo_type =
    {
      range_modifier = 3.5,
      cooldown_modifier = 10,
      target_type = "direction",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "nuclear_cannon_projectile",
          starting_speed = 1,
          direction_deviation = 0.1,
          range_deviation = 0.1,
          max_range = 60,
          min_range = 5,
          source_effects =
          {
            type = "create-explosion",
            entity_name = "explosion-gunshot"
          }
        }
      }
    },
    subgroup = "ammo",
    order = "d[explosive-cannon-shell]-c[uranium]2",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 20,
    weight = 100*kg
  },

data:extend({ nuclear_bullet_ammo })
data:extend({ nuclear_artillery_shell })
data:extend({ nuclear_cannon_shell })

--attempt at a ks combat revival compatibility patch. too bad it didn't work
--if mods["KS_Combat_Updated"] then
--	data.raw.projectile["nuclear_cannon_projectile-stream"] = data.raw.projectile["cannon-shell-stream"]--why not
--end
