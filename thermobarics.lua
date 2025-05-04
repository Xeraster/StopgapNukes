--required fix for 2.0.19
local item_sounds = require("__base__.prototypes.item_sounds")

--get thermobaric related user settings
local cliff_destroy_mult = settings.startup["stopgapnukes_thermobaric_cliff_radius_behaviour"].value
local thermobaricCliffRadius = cliff_destroy_mult * 15
if thermobaricCliffRadius > 25 then
	thermobaricCliffRadius = 25
end

--recipe for thermobaric rocket
data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_thermobaric_rocket_recipe",
		category = "crafting",
		enabled = false,
		energy_required = 10,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="rocket", amount = 1},
			{type="item", name="explosives", amount = 20},
			{type="item", name="rocket-fuel", amount = 30},
			{type="item", name="flamethrower-ammo", amount = 10},
			{type="item", name="advanced-circuit", amount = 10},
		},
		results = 
    {
			{type = "item", name = "thermobaric-rocket", amount = 1},
		},
  },
})

--recipe for thermobaric cannon shell
data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_thermobaric_cannon_shell_recipe",
		category = "crafting",
		enabled = false,
		energy_required = 10,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="explosive-cannon-shell", amount = 1},
			{type="item", name="explosives", amount = 8},
			{type="item", name="rocket-fuel", amount = 10},
			{type="item", name="flamethrower-ammo", amount = 8},
			{type="item", name="advanced-circuit", amount = 8},
		},
		results = 
    {
			{type = "item", name = "thermobaric_cannon_shell", amount = 1},
		},
  },
})
  --recipe for thermobaric artillery shell
data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_thermobaric_artillery_shell_recipe",
		category = "crafting",
		enabled = false,
		energy_required = 10,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="artillery-shell", amount = 1},
			{type="item", name="explosives", amount = 20},
			{type="item", name="rocket-fuel", amount = 10},
			{type="item", name="flamethrower-ammo", amount = 10},
			{type="item", name="advanced-circuit", amount = 20},
		},
		results = 
    {
			{type = "item", name = "thermobaric_artillery_shell", amount = 1},
		},
  },
})

data:extend({
--- Rockets/bombs ---
  -- Thermo-nuclear --
  {
    type = "projectile",
    name = "thermobaric-rocket-projectile",
    flags = {"not-on-map"},
    hidden = true,
    acceleration = 0.01,
    turn_speed = 0.003,
    turning_speed_increases_exponentially_with_projectile_speed = true,
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          --too destructive
          --{
          --  type = "nested-result",
          --  action =
          --  {
          --    type = "area",
          --    target_entities = false,
          --    trigger_from_target = true,
          --    repeat_count = 100,
          --    radius = 20,
          --    action_delivery =
          --    {
          --      type = "projectile",
          --      projectile = "atomic-bomb-wave",
          --      starting_speed = 0.5 * 0.7,
          --      starting_speed_deviation = nuke_shockwave_starting_speed_deviation
          --    }
          --  }
          --},
          {
            type = "create-entity",
            entity_name = "medium-scorchmark-tintable",
            check_buildability = true
          },
          {
            type = "invoke-tile-trigger",
            repeat_count = 1
          },
          {
            type = "destroy-decoratives",
            from_render_layer = "decorative",
            to_render_layer = "object",
            include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
            include_decals = false,
            invoke_decorative_trigger = true,
            decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
            radius = 3
          },
      {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 9,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 50, type = "explosion"}
              }
            }
          }
        }
      }
        }
      }
    },
    final_action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
        	type = "script",
        	effect_id = "Thermobaric Weapon hit large"
      	  },
      	  {
            type = "create-entity",
            entity_name = "big-explosion"
          },
          {
            type = "damage",
            damage = {amount = 50, type = "explosion"}
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              show_in_tooltip = false,
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 1000,
              radius = 20,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
                starting_speed = 0.5 * 0.65,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
          },
          {
            type = "destroy-cliffs",
            radius = thermobaricCliffRadius,
            explosion_at_trigger = "explosion"
          },
          {
            type = "nested-result",
            action =
		{
		  type = "area",
		  radius = 120,
		  action_delivery =
		  {
		    type = "instant",
		    target_effects =
		    {
		      type = "damage",
		      damage = {amount = 0.1, type = "fire"}
		    }
		  }
		}
          },
          {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 15,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 700, type = "explosion"}
              }
            }
          }
        }
      },
      {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 15,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 1000, type = "fire"}
              }
            }
          }
        }
      },
      {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 20,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 120, type = "explosion"}
              }
            }
          }
        }
      },
      --catch everything on fire
      {
            type = "nested-result",
            action =
		{
		  type = "area",
		  radius = 120,
		  action_delivery =
		  {
		    type = "instant",
		    target_effects =
		    {
		      type = "damage",
		      damage = {amount = 1, type = "fire"}
		    }
		  }
		}
          },
        }
      }
    },
    animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({1, 0.2, 0.2}),
    shadow = require("__base__.prototypes.entity.rocket-projectile-pictures").shadow,
    smoke = require("__base__.prototypes.entity.rocket-projectile-pictures").smoke,
  }
})

--thermobaric cannon shell projectile
data:extend({
{
    type = "projectile",
    name = "thermobaric_cannon_projectile",
    flags = {"not-on-map"},
    hidden = true,
    collision_box = {{-0.3, -1.1}, {0.3, 1.1}},
    acceleration = 0,
    piercing_damage = 150,
    --action has to get overridden in data-final-fixes, the nuke explosion works differently from the others
    --action = { basic_nuke_explode_action },
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          --too destructive
          --{
          --  type = "nested-result",
          --  action =
          --  {
          --    type = "area",
          --    target_entities = false,
          --    trigger_from_target = true,
          --    repeat_count = 100,
          --    radius = 20,
          --    action_delivery =
          --    {
          --      type = "projectile",
          --      projectile = "atomic-bomb-wave",
          --      starting_speed = 0.5 * 0.7,
          --      starting_speed_deviation = nuke_shockwave_starting_speed_deviation
          --    }
          --  }
          --},
          {
            type = "create-entity",
            entity_name = "medium-scorchmark-tintable",
            check_buildability = true
          },
          {
            type = "invoke-tile-trigger",
            repeat_count = 1
          },
          {
            type = "destroy-decoratives",
            from_render_layer = "decorative",
            to_render_layer = "object",
            include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
            include_decals = false,
            invoke_decorative_trigger = true,
            decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
            radius = 3
          },
      {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 3,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 50, type = "explosion"}
              }
            }
          }
        }
      }
        }
      }
    },
    final_action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
        	type = "script",
        	effect_id = "Thermobaric Weapon hit medium"
      	  },
      	  {
            type = "nested-result",
            action =
            {
              type = "area",
              show_in_tooltip = false,
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 1000,
              radius = 15,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
                starting_speed = 0.5 * 0.65,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
          },
      	  {
            type = "create-entity",
            entity_name = "big-explosion"
          },
          {
            type = "damage",
            damage = {amount = 50, type = "explosion"}
          },
          {
            type = "destroy-cliffs",
            radius = thermobaricCliffRadius,
            explosion_at_trigger = "explosion"
          },
          {
            type = "nested-result",
            action =
		{
		  type = "area",
		  radius = 120,
		  action_delivery =
		  {
		    type = "instant",
		    target_effects =
		    {
		      type = "damage",
		      damage = {amount = 0.1, type = "fire"}
		    }
		  }
		}
          },
          {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 10,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 500, type = "explosion"}
              }
            }
          }
        }
      },
      {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 10,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 750, type = "fire"}
              }
            }
          }
        }
      },
      {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 15,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 120, type = "explosion"}
              }
            }
          }
        }
      },
        }
      }
    },
    animation =
    {
      filename = "__base__/graphics/entity/bullet/bullet.png",
      draw_as_glow = true,
      width = 3,
      height = 50,
      priority = "high"
    }
  }
})

--thermobaric artillery shell projectile
data:extend({
{
    type = "artillery-projectile",
    name = "thermobaric_artillery_projectile",
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
      filename = "__StopgapNukes__/graphics/artillery/thermobaric-artillery-map-visualization.png",
      flags = { "icon" },
      width = 64,
      height = 64,
      priority = "high",
      scale = 0.25
    },
    --action gets set in data final fixes because that works better
    height_from_ground = 280 / 64
    }
  })
  

--thermobaric rocket
data:extend({
  {
    type = "ammo",
    name = "thermobaric-rocket",
    icon = "__StopgapNukes__/graphics/icons/thermobaric-rocket.png",
    ammo_category = "rocket",
    ammo_type =
    {
      range_modifier = 2.5,
      cooldown_modifier = 5,
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "thermobaric-rocket-projectile",
          starting_speed = 0.1,
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-hit"
          }
        }
      }
    },
    subgroup = "ammo",
    order = "d[rocket-launcher]-b[explosive]",
    inventory_move_sound = item_sounds.ammo_large_inventory_move,
    pick_sound = item_sounds.ammo_large_inventory_pickup,
    drop_sound = item_sounds.ammo_large_inventory_move,
    stack_size = 20,
    weight = 50*kg
  }
})

--thermobaric cannon shell
data:extend({
{
  type = "ammo",
    name = "thermobaric_cannon_shell",
    icon = "__StopgapNukes__/graphics/icons/thermobaric-cannon-shell.png",
    pictures =
    {
      layers =
      {
        {
          size = 64,
          filename = "__StopgapNukes__/graphics/icons/thermobaric-cannon-shell.png",
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
      range_modifier = 2.5,
      cooldown_modifier = 5,
      target_type = "direction",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "thermobaric_cannon_projectile",
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
    order = "d[explosive-cannon-shell]-c[uranium]-1",
    inventory_move_sound = item_sounds.ammo_large_inventory_move,
    pick_sound = item_sounds.ammo_large_inventory_pickup,
    drop_sound = item_sounds.ammo_large_inventory_move,
    stack_size = 20,
    weight = 100*kg
  }
})

--thermobaric artillery shell
data:extend({
{
    type = "ammo",
    name = "thermobaric_artillery_shell",
    icon = "__StopgapNukes__/graphics/icons/thermobaric-artillery-shell.png",
    ammo_category = "artillery-shell",
    ammo_type =
    {
      range_modifier = 2.5,
      target_type = "position",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "artillery",
          projectile = "thermobaric_artillery_projectile",
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
    order = "d[explosive-cannon-shell]-d[artillery]1",
    inventory_move_sound = item_sounds.artillery_large_inventory_move,
    pick_sound = item_sounds.artillery_large_inventory_pickup,
    drop_sound = item_sounds.artillery_large_inventory_move,
    stack_size = 1,
    weight = 100*kg
    }
})
