local item_sounds = require("__base__.prototypes.item_sounds")

--get the relevant user settings for the stuff this lua file
local cliff_destroy_mult = settings.startup["stopgapnukes_atomic_cliff_radius_behaviour"].value
local heavy_water_mult = settings.startup["stopgapnukes_basic_heavy_water_requirement_behaviour"].value
local advanced_cannon_neutronplates = settings.startup["stopgapnukes_advanced_cannon_shell_heavy_water_neutronplates_behaviour"].value
local medium_nuke_damage = 500000--settings.startup["stopgapnukes_medium_nuke_fireball_behaviour"].value
local large_nuke_damage = 500000--settings.startup["stopgapnukes_large_nuke_fireball_behaviour"].value

--using values greater than 500000 doesn't seem to work
if medium_nuke_damage > 500000 then
	medium_nuke_damage = 500000
end

--calculate the cliff destroy radii
local bignuke_cliff_radius = cliff_destroy_mult * 60
if bignuke_cliff_radius > 120 then
	bignuke_cliff_radius = 120
end
local onekt_cliff_radius = cliff_destroy_mult * 330
if onekt_cliff_radius > 800 then
	onekt_cliff_radius = 800
end
local mediumnuke_cliff_radius = cliff_destroy_mult * 160
if mediumnuke_cliff_radius > 350 then
	mediumnuke_cliff_radius = 350
end

local advanced_cannon_shell_heavy_water_amount = math.floor(40 * heavy_water_mult)
advanced_cannon_shell_recipe_ingredients =
    {
    	{type="item", name="neutron-reflector", amount = 20},
	{type="item", name="explosives", amount = 10},
	{type="item", name="uranium-235", amount = 150},
	{type="item", name="processing-unit", amount = 30},
        {type = "item", name = "explosive-cannon-shell", amount = 1},
        {type = "fluid", name = "heavy-water", amount = advanced_cannon_shell_heavy_water_amount}
    }

if advanced_cannon_neutronplates then
	advanced_cannon_shell_recipe_ingredients = 
	{
		{type="item", name="explosives", amount = 10},
		{type="item", name="uranium-235", amount = 150},
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
	{type="item", name="uranium-235", amount = 250},
	{type="item", name="processing-unit", amount = 40},
        {type = "item", name = "explosive-cannon-shell", amount = 1},
        {type = "fluid", name = "heavy-water", amount = medium_cannon_shell_heavy_water_amount}
    }
    
if advanced_cannon_neutronplates then
	medium_cannon_shell_recipe_ingredients =
    {
	{type="item", name="explosives", amount = 20},
	{type="item", name="uranium-235", amount = 250},
	{type="item", name="processing-unit", amount = 40},
        {type = "item", name = "explosive-cannon-shell", amount = 1},
        {type = "fluid", name = "heavy-water", amount = medium_cannon_shell_heavy_water_amount + 20}
    }
end

local secondary_blast_damage = settings.startup["stopgapnukes_secondary_blast_damage_amt"].value
local secondary_blast_damage_1kt = 65
if secondary_blast_damage > 0 then
	secondary_blast_damage_1kt = secondary_blast_damage
elseif secondary_blast_damage == -1 then
	secondary_blast_damage_1kt = 0;
end

--these need to be in the same file as the projectile that uses them or it wont work
local big_nuke_explosion_action = {
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
          --{
          --  type = "nested-result",
          --  action =
          --  {
          --    type = "area",
          --    show_in_tooltip = false,
          --    target_entities = false,
          --    trigger_from_target = true,
          --    repeat_count = 1000,
          --    radius = 9,
          --    action_delivery =
          --    {
          --      type = "projectile",
          --      projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
          --      starting_speed = 0.5 * 0.65,
          --      starting_speed_deviation = nuke_shockwave_starting_speed_deviation
          --    }
          --  }
          --},
          {
            type = "create-entity",
            entity_name = "medium-scorchmark-tintable",
            check_buildability = true
          },
          --{
          --  type = "invoke-tile-trigger",
          --  repeat_count = 1
          --},
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
    }

--these need to be in the same file as the projectile that uses them or it wont work
local big_nuke_explosion_action_final = {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
        	type = "script",
        	effect_id = "Big atomic bomb explosion"
      	  },
      	  {
            type = "create-entity",
            entity_name = "nuke-explosion"
          },
          {
            type = "create-entity",
            entity_name = "huge-uranium-explosion-LUQ"
          },
          {
            type = "create-entity",
            entity_name = "huge-uranium-explosion-RUQ"
          },
          {
            type = "create-entity",
            entity_name = "huge-uranium-explosion-LLQ"
          },
          {
            type = "create-entity",
            entity_name = "huge-uranium-explosion-RLQ"
          },
          {
            type = "create-entity",
            entity_name = "radiation-cloud"
          },
          {
            type = "create-entity",
            entity_name = "huge-scorchmark",
            offsets = {{ 0, -0.5 }},
            check_buildability = true
          },
          {
            type = "damage",
            damage = {amount = 50, type = "explosion"}
          },
          {
            type = "destroy-cliffs",
            radius = bignuke_cliff_radius,
            explosion_at_trigger = "explosion"
          },
          {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 38,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 4000, type = "explosion"}
              }
            }
          }
        }
      },
          {
            type = "destroy-decoratives",
            --from_render_layer = "decorative",
            --to_render_layer = "object",
            --i think commenting this out does it for all layers
            include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
            include_decals = true,
            invoke_decorative_trigger = true,
            decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
            radius = 20
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
          radius = 60,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 200, type = "explosion"}
              }
            }
          }
        }
      },
      {
      	--use this one for the "direct hit" damage
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
                damage = {amount = medium_nuke_damage, type = "physical"}
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
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 1000,
              radius = 50,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-wave",
                starting_speed = 0.5 * 0.7,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
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
              radius = 60,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-wave-spawns-cluster-nuke-explosion",
                starting_speed = 0.5 * 0.7,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              show_in_tooltip = false,
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 300,
              radius = 26,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-wave-spawns-nuclear-smoke",
                starting_speed = 0.5 * 0.65,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              show_in_tooltip = false,
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 10,
              radius = 8,
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "create-entity",
                    entity_name = "nuclear-smouldering-smoke-source",
                    tile_collision_mask = {layers={water_tile=true}}
                  }
                }
              }
            }
          },
          {
          --this is the white blinding flash effect
            type = "camera-effect",
            duration = 120,
            ease_in_duration = 2,
            ease_out_duration = 120,
            delay = 0,
            strength = 20,
            full_strength_max_distance = 200,
            max_distance = 800
          },
          {
            type = "set-tile",
            tile_name = "nuclear-ground",
            radius = 20,
            apply_projection = true,
            tile_collision_mask = { layers={water_tile=true} }
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 1000,
              radius = 7,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-ground-zero-projectile",
                starting_speed = 0.6 * 0.8,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
          },
        }
      }
    }
    
--medium nuke, AKA the 120 ton nuke
local medium_nuke_explosion_action = {
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
          --{
          --  type = "nested-result",
          --  action =
          --  {
          --    type = "area",
          --    show_in_tooltip = false,
          --    target_entities = false,
          --    trigger_from_target = true,
          --    repeat_count = 1000,
          --    radius = 9,
          --    action_delivery =
          --    {
          --      type = "projectile",
          --      projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
          --      starting_speed = 0.5 * 0.65,
          --      starting_speed_deviation = nuke_shockwave_starting_speed_deviation
          --    }
          --  }
          --},
          {
            type = "create-entity",
            entity_name = "medium-scorchmark-tintable",
            check_buildability = true
          },
          --{
          --  type = "invoke-tile-trigger",
          --  repeat_count = 1
          --},
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
    }

--medium nuke, AKA the 120 ton nuke
local medium_nuke_explosion_action_final = {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
        	type = "script",
        	effect_id = "120t atomic bomb explosion"
      	  },
      	  {
            type = "create-entity",
            entity_name = "nuke-explosion"
          },
          {
            type = "create-entity",
            entity_name = "huge-uranium-explosion-LUQ"
          },
          {
            type = "create-entity",
            entity_name = "huge-uranium-explosion-RUQ"
          },
          {
            type = "create-entity",
            entity_name = "huge-uranium-explosion-LLQ"
          },
          {
            type = "create-entity",
            entity_name = "huge-uranium-explosion-RLQ"
          },
          {
            type = "create-entity",
            entity_name = "radiation-cloud"
          },
          {
            type = "create-entity",
            entity_name = "huge-scorchmark",
            offsets = {{ 0, -0.5 }},
            check_buildability = true
          },
          {
            type = "damage",
            damage = {amount = 50, type = "explosion"}
          },
          {
            type = "destroy-cliffs",
            radius = bignuke_cliff_radius,
            explosion_at_trigger = "explosion"
          },
          {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 80,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 4500, type = "explosion"}
              }
            }
          }
        }
      },
          {
            type = "destroy-decoratives",
            --from_render_layer = "decorative",
            --to_render_layer = "object",
            --i think commenting this out does it for all layers
            include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
            include_decals = true,
            invoke_decorative_trigger = true,
            decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
            radius = 20
          },
          {
            type = "nested-result",
            action =
		{
		  type = "area",
		  radius = 200,
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
          radius = 300,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 200, type = "explosion"}
              }
            }
          }
        }
      },
      {
      	--use this one for the "direct hit" damage
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
                damage = {amount = medium_nuke_damage, type = "physical"}
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
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 1000,
              radius = 50,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-wave",
                starting_speed = 0.5 * 0.7,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
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
              radius = 60,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-wave-spawns-cluster-nuke-explosion",
                starting_speed = 0.5 * 0.7,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              show_in_tooltip = false,
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 300,
              radius = 26,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-wave-spawns-nuclear-smoke",
                starting_speed = 0.5 * 0.65,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              show_in_tooltip = false,
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 10,
              radius = 8,
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "create-entity",
                    entity_name = "nuclear-smouldering-smoke-source",
                    tile_collision_mask = {layers={water_tile=true}}
                  }
                }
              }
            }
          },
          {
          --this is the white blinding flash effect
            type = "camera-effect",
            duration = 120,
            ease_in_duration = 2,
            ease_out_duration = 120,
            delay = 0,
            strength = 20,
            full_strength_max_distance = 200,
            max_distance = 800
          },
          {
            type = "set-tile",
            tile_name = "nuclear-ground",
            radius = 20,
            apply_projection = true,
            tile_collision_mask = { layers={water_tile=true} }
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 1000,
              radius = 7,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-ground-zero-projectile",
                starting_speed = 0.6 * 0.8,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
          },
        }
      }
    }
  
--doesn't work  
--add_mushroom_cloud_effect(big_nuke_explosion_action_final, "really-huge-")

--these need to be in the same file as the projectile that uses them or it wont work
local kt_nuke_explosion_action = {
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
            type = "nested-result",
            action =
            {
              type = "area",
              show_in_tooltip = false,
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 800,--lowering it from 1000 to 800 makes it do slightly less damage i think
              radius = 750,
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
            entity_name = "medium-scorchmark-tintable",
            check_buildability = true
          },
          {
            type = "invoke-tile-trigger",
            repeat_count = 1
          },
          {
            type = "destroy-decoratives",
            --from_render_layer = "decorative",
            --to_render_layer = "object",
            --i think commenting this out does it for all layers
            include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
            include_decals = true,
            invoke_decorative_trigger = true,
            decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
            radius = 330
          },
          {
            type = "nested-result",
            action =
		{
		  type = "area",
		  radius = 750,
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
          }
          --too much lag
      --{
      --  type = "nested-result",
      --  action =
      --  {
      --    type = "area",
      --    radius = 750,
      --    action_delivery =
      --    {
      --      type = "instant",
      --      target_effects =
      --      {
      --        {
      --          type = "damage",
      --          damage = {amount = 50, type = "explosion"}
      --        }
      --      }
      --    }
      --  }
      --}
        }
      }
    }

--these need to be in the same file as the projectile that uses them or it wont work
local kt_nuke_explosion_action_final = {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
        	type = "script",
        	effect_id = "kt atomic bomb explosion"
      	  },
      	  {
            type = "create-entity",
            entity_name = "nuke-explosion"
          },
          {
            type = "create-entity",
            entity_name = "huge-scorchmark",
            offsets = {{ 0, -0.5 }},
            check_buildability = true
          },
          {
            type = "create-entity",
            entity_name = "huge-uranium-explosion-LUQ"
          },
          {
            type = "create-entity",
            entity_name = "huge-uranium-explosion-RUQ"
          },
          {
            type = "create-entity",
            entity_name = "huge-uranium-explosion-LLQ"
          },
          {
            type = "create-entity",
            entity_name = "huge-uranium-explosion-RLQ"
          },
          {
            type = "damage",
            damage = {amount = 10000, type = "explosion"}
          },
          {
            type = "destroy-cliffs",
            radius = onekt_cliff_radius,--too much lag, was 330
            explosion_at_trigger = "explosion"
          },
          --apply a lot of damage to everything in the fireball zone
          {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 500,--too much lag, was 600
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 5000, type = "explosion"}
              }
            }
          }
        }
      },
      {
      --use this one for the "direct hit" damage
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 100,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = medium_nuke_damage, type = "physical"}
              }
            }
          }
        }
      },
      --apply flat damage to everything in the shockwave radius
      {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 1000,--was 1000, will reduce lag a bit. that's a 1km safety range
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = secondary_blast_damage_1kt, type = "explosion"}
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
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 10000,
              radius = 330,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-wave",
                starting_speed = 0.5 * 0.7,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              show_in_tooltip = false,
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 10000,
              radius = 330,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-wave-spawns-cluster-nuke-explosion",
                starting_speed = 0.5 * 0.7,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
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
              radius = 750,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-wave-spawns-nuclear-smoke",
                starting_speed = 0.5 * 0.65,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              show_in_tooltip = false,
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 100,
              radius = 250,
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "create-entity",
                    entity_name = "nuclear-smouldering-smoke-source",
                    tile_collision_mask = {layers={water_tile=true}}
                  }
                }
              }
            }
          },
          {
          --this is the white blinding flash effect
            type = "camera-effect",
            duration = 180,
            ease_in_duration = 2,
            ease_out_duration = 180,
            delay = 0,
            strength = 20,
            full_strength_max_distance = 800,
            max_distance = 2000
          },
          {
            type = "set-tile",
            tile_name = "nuclear-ground",
            radius = 75,
            apply_projection = true,
            tile_collision_mask = { layers={water_tile=true} }
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 1000,
              radius = 330,
              action_delivery =
              {
                type = "projectile",
                projectile = "atomic-bomb-ground-zero-projectile",
                starting_speed = 0.6 * 0.8,
                starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              }
            }
          },
        }
      }
    }

data:extend({
  {
    type = "recipe",
    name = "stopgapnukes_big_nuclear_artillery_shell_recipe",
    enabled = false,
    energy_required = 30,
    ingredients =
    {
    {type="item", name="neutron-reflector", amount = 10},
	{type="item", name="explosives", amount = 10},
	{type="item", name="uranium-235", amount = 180},
	{type="item", name="processing-unit", amount = 40},
      {type = "item", name = "artillery-shell", amount = 1},
      {type = "item", name = "low-density-structure", amount = 10}
    },
    results = {{type="item", name="big_nuclear_artillery_shell", amount=1}}
  },
  {
    type = "recipe",
    name = "1kt-artillery-shell-recipe",
    enabled = false,
    energy_required = 40,
    ingredients =
    { 
      {type="item", name="neutron-reflector", amount = 40},
      {type="item", name="explosives", amount = 30},
      {type="item", name="rocket-fuel", amount = 60},
      {type="item", name="uranium-235", amount = 350},
      {type="item", name="processing-unit", amount = 40},
      {type = "item", name = "artillery-shell", amount = 1}
    },
    results = {{type="item", name="1kt-nuclear-artillery-shell", amount=1}}
  },
  {
    type = "recipe",
    name = "stopgapnukes_big_nuclear_cannon_shell_recipe",
    enabled = false,
    energy_required = 35,
    category = "crafting-with-fluid",
    ingredients = advanced_cannon_shell_recipe_ingredients,
    icon = "__StopgapNukes__/graphics/icons/nuclear-cannon-shell-big-heavy.png",
    results = {{type="item", name="big_nuclear_cannon_shell", amount=1}}
  },
  {
    type = "recipe",
    name = "stopgapnukes_big_nuclear_cannon_shell_recipe_noheavywater",
    enabled = false,
    energy_required = 35,
    category = "crafting",
    ingredients =
    {
    	{type="item", name="neutron-reflector", amount = 40},
	{type="item", name="explosives", amount = 10},
	{type="item", name="uranium-235", amount = 150},
	{type="item", name="processing-unit", amount = 30},
      {type = "item", name = "explosive-cannon-shell", amount = 1},
      {type = "item", name = "low-density-structure", amount = 10}
    },
    results = {{type="item", name="big_nuclear_cannon_shell", amount=1}}
  },
  {
    type = "recipe",
    name = "stopgapnukes_medium_nuclear_cannon_shell_recipe",
    enabled = false,
    energy_required = 55,
    category = "crafting-with-fluid",
    ingredients = medium_cannon_shell_recipe_ingredients,
    icon = "__StopgapNukes__/graphics/icons/nuclear-cannon-shell-120t-heavy.png",
    results = {{type="item", name="medium_nuclear_cannon_shell", amount=1}}
  },
  {
    type = "recipe",
    name = "stopgapnukes_medium_nuclear_cannon_shell_recipe_noheavywater",
    enabled = false,
    energy_required = 50,
    category = "crafting",
    ingredients =
    {
    	{type="item", name="neutron-reflector", amount = 60},
	{type="item", name="explosives", amount = 20},
	{type="item", name="uranium-235", amount = 250},
	{type="item", name="processing-unit", amount = 40},
      {type = "item", name = "explosive-cannon-shell", amount = 1},
      {type = "item", name = "low-density-structure", amount = 10}
    },
    results = {{type="item", name="medium_nuclear_cannon_shell", amount=1}}
  },
  {
    type = "projectile",
    name = "big_nuclear_cannon_projectile",
    flags = {"not-on-map"},
    hidden = true,
    collision_box = {{-0.3, -1.1}, {0.3, 1.1}},
    acceleration = 0,
    piercing_damage = 150,
    --action has to get overridden in data-final-fixes, the nuke explosion works differently from the others
    --action = { basic_nuke_explode_action },
    action = big_nuke_explosion_action,
    final_action = big_nuke_explosion_action_final,
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
    type = "projectile",
    name = "medium_nuclear_cannon_projectile",
    flags = {"not-on-map"},
    hidden = true,
    collision_box = {{-0.3, -1.1}, {0.3, 1.1}},
    acceleration = 0,
    piercing_damage = 150,
    --action has to get overridden in data-final-fixes, the nuke explosion works differently from the others
    --action = { basic_nuke_explode_action },
    action = medium_nuke_explosion_action,
    final_action = medium_nuke_explosion_action_final,
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
    name = "big_nuclear_artillery_projectile",
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
    action = big_nuke_explosion_action,
    final_action = big_nuke_explosion_action_final,
    height_from_ground = 280 / 64
  },
  {
    type = "artillery-projectile",
    name = "1kt-nuclear-artillery-projectile",
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
    action = kt_nuke_explosion_action,
    final_action = kt_nuke_explosion_action_final,
    height_from_ground = 280 / 64
  },
})

--recipe for the big atomic bomb with heavy water. heavy water is easier to get in early game but a pain to deal with in late game
data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_big_atomic_bomb_recipe",
		category = "crafting-with-fluid",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			{type="fluid", name="heavy-water", amount = (100 * heavy_water_mult)},
			{type="item", name="explosives", amount = 10},
			{type="item", name="rocket-fuel", amount = 30},
			{type="item", name="uranium-235", amount = 180},
			{type="item", name="processing-unit", amount = 20},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "big_atomic_bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/big-atomic-bomb-heavy-water.png",
  }
})

--recipe for the big atomic bomb with neutron reflectors instead of heavy water
data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_big_atomic_bomb_recipe-neutron-reflectors",
		category = "crafting",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="neutron-reflector", amount = 20},
			{type="item", name="explosives", amount = 10},
			{type="item", name="rocket-fuel", amount = 30},
			{type="item", name="uranium-235", amount = 180},
			{type="item", name="processing-unit", amount = 20},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "big_atomic_bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/big-atomic-bomb-neutron-reflectors.png",
  }
})

--recipe for the 120 ton atomic bomb with heavy water.
data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_medium_atomic_bomb_recipe",
		category = "crafting-with-fluid",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			{type="fluid", name="heavy-water", amount = (100 * heavy_water_mult)},
			{type="item", name="explosives", amount = 20},
			{type="item", name="rocket-fuel", amount = 45},
			{type="item", name="uranium-235", amount = 250},
			{type="item", name="processing-unit", amount = 30},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "medium_atomic_bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/120t-atomic-bomb-heavy-water.png",
  }
})

--recipe for the 120 ton atomic bomb with neutron reflectors instead of heavy water
data:extend({
  {
		type = "recipe",
		name = "stopgapnukes_medium_atomic_bomb_recipe-neutron-reflectors",
		category = "crafting",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="neutron-reflector", amount = 22},
			{type="item", name="explosives", amount = 10},
			{type="item", name="rocket-fuel", amount = 40},
			{type="item", name="uranium-235", amount = 250},
			{type="item", name="processing-unit", amount = 20},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "medium_atomic_bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/120t-atomic-bomb-neutron-reflectors.png",
  }
})

--recipe for the 1kt atomic bomb
data:extend({
  {
		type = "recipe",
		name = "1kt_atomic_bomb_recipe",
		category = "crafting",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="neutron-reflector", amount = 40},
			{type="item", name="explosives", amount = 30},
			{type="item", name="rocket-fuel", amount = 60},
			{type="item", name="uranium-235", amount = 350},
			{type="item", name="processing-unit", amount = 40},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "1kt-atomic-bomb", amount = 1},
		},
  }
})

--recipe for the 1kt atomic bomb with heavy water and less uranium
data:extend({
  {
		type = "recipe",
		name = "1kt_atomic_bomb_heavywater_recipe",
		category = "crafting-with-fluid",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			{type="item", name="neutron-reflector", amount = 40},
			{type="item", name="explosives", amount = 30},
			{type="item", name="rocket-fuel", amount = 60},
			{type="item", name="uranium-235", amount = 250},
			{type="item", name="processing-unit", amount = 40},
			{type="fluid", name="heavy-water", amount = 100},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "1kt-atomic-bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/kt-atomic-bomb-heavy-water.png",
  }
})

--big/20ton atomic bomb
data:extend({

  {
    type = "projectile",
    name = "big_atomic_bomb_projectile",
    flags = {"not-on-map"},
    hidden = false,
    acceleration = 0.01,
    turn_speed = 0.003,
    turning_speed_increases_exponentially_with_projectile_speed = true,
    action = big_nuke_explosion_action,
    final_action = big_nuke_explosion_action_final,
    animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({1, 0.2, 0.2}),
    shadow = require("__base__.prototypes.entity.rocket-projectile-pictures").shadow,
    smoke = require("__base__.prototypes.entity.rocket-projectile-pictures").smoke,
  }
})

--big atomic bomb
data:extend({
  {
    type = "ammo",
    name = "big_atomic_bomb",
    icon = "__StopgapNukes__/graphics/icons/big-atomic-bomb.png",
    ammo_category = "rocket",
    ammo_type =
    {
      range_modifier = 4,
      cooldown_modifier = 20,
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "big_atomic_bomb_projectile",
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
    order = "d[rocket-launcher]-d[atomic-bomb]2",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 10,
    weight = 50*kg
  }
})

--120 ton atomic bomb
data:extend({

  {
    type = "projectile",
    name = "medium_atomic_bomb_projectile",
    flags = {"not-on-map"},
    hidden = false,
    acceleration = 0.01,
    turn_speed = 0.003,
    turning_speed_increases_exponentially_with_projectile_speed = true,
    action = medium_nuke_explosion_action,
    final_action = medium_nuke_explosion_action_final,
    animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({1, 0.2, 0.2}),
    shadow = require("__base__.prototypes.entity.rocket-projectile-pictures").shadow,
    smoke = require("__base__.prototypes.entity.rocket-projectile-pictures").smoke,
  }
})

--120 ton atomic bomb
data:extend({
  {
    type = "ammo",
    name = "medium_atomic_bomb",
    icon = "__StopgapNukes__/graphics/icons/120t-atomic-bomb.png",
    ammo_category = "rocket",
    ammo_type =
    {
      range_modifier = 4,
      cooldown_modifier = 20,
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "medium_atomic_bomb_projectile",
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
    order = "d[rocket-launcher]-d[atomic-bomb]24",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 10,
    weight = 50*kg
  }
})

--1kt atomic bomb projectile
data:extend({
  {
    type = "projectile",
    name = "1kt-atomic-bomb-projectile",
    flags = {"not-on-map"},
    hidden = true,
    acceleration = 0.01,
    turn_speed = 0.003,
    turning_speed_increases_exponentially_with_projectile_speed = true,
    action = kt_nuke_explosion_action,
    final_action = kt_nuke_explosion_action_final,
    animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({1, 0.2, 0.2}),
    shadow = require("__base__.prototypes.entity.rocket-projectile-pictures").shadow,
    smoke = require("__base__.prototypes.entity.rocket-projectile-pictures").smoke,
  }
})

--1kt atomic bomb
data:extend({
  {
    type = "ammo",
    name = "1kt-atomic-bomb",
    icon = "__StopgapNukes__/graphics/icons/1kt-atomic-bomb.png",
    ammo_category = "rocket",
    ammo_type =
    {
      range_modifier = 4,
      cooldown_modifier = 20,
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "1kt-atomic-bomb-projectile",
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
    order = "d[rocket-launcher]-d[atomic-bomb]31",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 5,
    weight = 100*kg
  }
})

local big_nuclear_artillery_shell = {
    type = "ammo",
    name = "big_nuclear_artillery_shell",
    icon = "__StopgapNukes__/graphics/icons/nuclear-artillery-shell-big.png",
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
          projectile = "big_nuclear_artillery_projectile",
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
    order = "d[explosive-cannon-shell]-d[artillery]4",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 1,
    weight = 100*kg
  }
  
local kt_nuclear_artillery_shell = {
    type = "ammo",
    name = "1kt-nuclear-artillery-shell",
    icon = "__StopgapNukes__/graphics/icons/1kt-artillery-shell.png",
    ammo_category = "artillery-shell",
    ammo_type =
    {
      range_modifier = 4,
      cooldown_modifier = 20,
      target_type = "position",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "artillery",
          projectile = "1kt-nuclear-artillery-projectile",
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
    order = "d[explosive-cannon-shell]-d[artillery]5",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 1,
    weight = 1000*kg
  }
  
local big_nuclear_cannon_shell = {
    type = "ammo",
    name = "big_nuclear_cannon_shell",
    icon = "__StopgapNukes__/graphics/icons/nuclear-cannon-shell-big.png",
    pictures =
    {
      layers =
      {
        {
          size = 64,
          filename = "__StopgapNukes__/graphics/icons/nuclear-cannon-shell-big.png",
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
      range_modifier = 4,
      cooldown_modifier = 20,
      target_type = "direction",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "big_nuclear_cannon_projectile",
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
    order = "d[explosive-cannon-shell]-c[uranium]3",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 10,
    weight = 100*kg
  }
  
 local medium_nuclear_cannon_shell = {
    type = "ammo",
    name = "medium_nuclear_cannon_shell",
    icon = "__StopgapNukes__/graphics/icons/nuclear-cannon-shell-120t.png",
    pictures =
    {
      layers =
      {
        {
          size = 64,
          filename = "__StopgapNukes__/graphics/icons/nuclear-cannon-shell-120t.png",
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
      range_modifier = 4,
      cooldown_modifier = 20,
      target_type = "direction",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "medium_nuclear_cannon_projectile",
          starting_speed = 1,
          direction_deviation = 0.1,
          range_deviation = 0.1,
          max_range = 120,
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
    order = "d[explosive-cannon-shell]-c[uranium]35",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 10,
    weight = 100*kg
  }

--data:extend({ big_nuclear_bullet_ammo })
data:extend({ kt_nuclear_artillery_shell })
data:extend({ big_nuclear_artillery_shell })
data:extend({ big_nuclear_cannon_shell })
data:extend({ medium_nuclear_cannon_shell })

