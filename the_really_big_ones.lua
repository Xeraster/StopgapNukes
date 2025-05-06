--get the relevant user settings for the stuff this lua file
local cliff_destroy_mult = settings.startup["stopgapnukes_atomic_cliff_radius_behaviour"].value
local large_nuke_damage = 500000--settings.startup["stopgapnukes_large_nuke_fireball_behaviour"].value
local superweapon_nuke_damage = 500000--settings.startup["stopgapnukes_superweapon_fireball_behaviour"].value

--calculate the cliff destroy radii
local multikt_cliff_radius = cliff_destroy_mult * 4500
if multikt_cliff_radius > 4500 then
	--don't go higher than 4500
	multikt_cliff_radius = 4500
end

local boosted_fission_cliff_radius = cliff_destroy_mult * 7000
if boosted_fission_cliff_radius > 7000 then
	boosted_fission_cliff_radius = 7000
end

local thermonuclear_cliff_radius = cliff_destroy_mult * 12500
if thermonuclear_cliff_radius > 12500 then
	--don't go higher than 12500
	thermonuclear_cliff_radius = 12500
end

--using values greater than 500000 doesn't seem to work so don't let the user try to use them
if large_nuke_damage > 500000 then
	large_nuke_damage = 500000
end
if superweapon_nuke_damage > 500000 then
	superweapon_nuke_damage = 500000
end

local item_sounds = require("__base__.prototypes.item_sounds")

local secondary_blast_damage = settings.startup["stopgapnukes_secondary_blast_damage_amt"].value
local secondary_blast_damage_15kt = 85
local secondary_blast_damage_500kt = 85
local secondary_blast_damage_2mt = 120
if secondary_blast_damage > 0 then
	secondary_blast_damage_15kt = secondary_blast_damage
	secondary_blast_damage_500kt = secondary_blast_damage
	secondary_blast_damage_2mt = secondary_blast_damage
elseif secondary_blast_damage == -1 then
	secondary_blast_damage_15kt = 0
	secondary_blast_damage_500kt = 0
	secondary_blast_damage_2mt = 0
end

--these need to be in the same file as the projectile that uses them or it wont work
local multikt_nuke_explosion_action = {
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
            --type = "nested-result",
            --action =
            --{
              --type = "area",
              --show_in_tooltip = false,
              --target_entities = false,
              --trigger_from_target = true,
              --repeat_count = 1000,
              --radius = 6000,
              --action_delivery =
              --{
                --type = "projectile",
                --projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
                --starting_speed = 0.5 * 0.65,
               -- starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              --}
            --}
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
          --{
          --  type = "destroy-decoratives",
            --from_render_layer = "decorative",
            --to_render_layer = "object",
            --i think commenting this out does it for all layers
          --  include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
           -- include_decals = true,
           -- invoke_decorative_trigger = true,
           -- decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
           -- radius = 1500
          --},
        --  {
         --   type = "nested-result",
         --   action =
	--	{
	--	  type = "area",
	--	  radius = 6000,
	--	  action_delivery =
	--	  {
	--	    type = "instant",
	--	    target_effects =
	--	    {
	--	      type = "damage",
	--	      damage = {amount = 0.1, type = "fire"}
	--	    }
	--	  }
	--	}
          --},
      --{
      --  type = "nested-result",
      --  action =
      --  {
       --   type = "area",
       --   radius = 6000,
       --   action_delivery =
       --   {
        --    type = "instant",
         --   target_effects =
         --   {
          --    {
          --      type = "damage",
          --      damage = {amount = 200, type = "explosion"}
          --    }
         --   }
        --  }
        --}
      --}
        }
      }
    }

--these need to be in the same file as the projectile that uses them or it wont work
local multikt_nuke_explosion_action_final = {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
        	type = "script",
        	effect_id = "multikt atomic bomb explosion"
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
            type = "damage",
            damage = {amount = 200, type = "explosion"}
          },
          {
            type = "create-entity",
            entity_name = "really-huge-uranium-explosion-LUQ"
          },
          {
            type = "create-entity",
            entity_name = "really-huge-uranium-explosion-RUQ"
          },
          {
            type = "create-entity",
            entity_name = "really-huge-uranium-explosion-LLQ"
          },
          {
            type = "create-entity",
            entity_name = "really-huge-uranium-explosion-RLQ"
          },
          {
            type = "destroy-cliffs",
            radius = multikt_cliff_radius,
            explosion_at_trigger = "explosion"
          },
          {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 1000,
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 10000, type = "explosion"}
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
          radius = 2500,--nukemaps says a 15kt atomic bomb moderately damages things 1.67km away but i think thats not enough for the way this mod is balanced
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 3000, type = "explosion"}
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
          radius = 4520,--nukemaps says a 15kt atomic bomb only damages things 4.52km away
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = secondary_blast_damage_15kt, type = "explosion"}
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
          radius = 400,--15kt atomic bomb vaporization radius in meters
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = large_nuke_damage, type = "physical"}
              }
            }
          }
        }
      },
      --{
           -- type = "nested-result",
           -- action =
            --{
             -- type = "area",
            --  target_entities = false,
            --  trigger_from_target = true,
            --  repeat_count = 1000,--was 20000
            --  radius = 1000,--was 10000
            --  action_delivery =
            --  {
           --     type = "projectile",
            --    projectile = "atomic-bomb-wave",
             --   starting_speed = 0.5 * 0.7,
            --    starting_speed_deviation = nuke_shockwave_starting_speed_deviation
             -- }
           -- }
          --},
          --{
           -- type = "nested-result",
           -- action =
            --{
            --  type = "area",
            --  show_in_tooltip = false,
            --  target_entities = false,
            --  trigger_from_target = true,
            --  repeat_count = 10000,
            --  radius = 2500,
             -- action_delivery =
             -- {
             --   type = "projectile",
             --   projectile = "atomic-bomb-wave-spawns-cluster-nuke-explosion",
             --   starting_speed = 0.5 * 0.7,
             --   starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              --}
            --}
          --},
          {
            type = "nested-result",
            action =
            {
              type = "area",
              show_in_tooltip = false,
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 300,
              radius = 200,--was 1500
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
              radius = 100,
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
            radius = 300,
            apply_projection = true,
            tile_collision_mask = { layers={water_tile=true} }
          },
          --{
            --type = "nested-result",
            --action =
           -- {
              --type = "area",
              --target_entities = false,
              --trigger_from_target = true,
              --repeat_count = 1000,
             -- radius = 6000,
              --action_delivery =
             -- {
              --  type = "projectile",
              --  projectile = "atomic-bomb-ground-zero-projectile",
              --  starting_speed = 0.6 * 0.8,
              --  starting_speed_deviation = nuke_shockwave_starting_speed_deviation
             -- }
           -- }
          --},
        }
      }
    }
    
--these need to be in the same file as the projectile that uses them or it wont work
local boosted_fission_nuke_explosion_action = {
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
          --no time for all this fancy shit. this explosion is TOO SLOW
            --type = "nested-result",
            --action =
            --{
              --type = "area",
              --show_in_tooltip = false,
              --target_entities = false,
              --trigger_from_target = true,
              --repeat_count = 1000,
              --radius = 6000,
              --action_delivery =
              --{
                --type = "projectile",
                --projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
                --starting_speed = 0.5 * 0.65,
                --starting_speed_deviation = nuke_shockwave_starting_speed_deviation
              --}
            --}
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
            --from_render_layer = "decorative",
            --to_render_layer = "object",
            --i think commenting this out does it for all layers
            include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
            include_decals = true,
            invoke_decorative_trigger = true,
            decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
            radius = 3000
          },
      --{
      --  type = "nested-result",
      --  action =
      --  {
      --    type = "area",
      --    radius = 9000,
      --    action_delivery =
      --    {
      --      type = "instant",
      --      target_effects =
      --      {
      --        {
      --          type = "damage",
      --          damage = {amount = 200, type = "explosion"}
      --        }
      --      }
      --    }
      --  }
      --}
        }
      }
    }

--these need to be in the same file as the projectile that uses them or it wont work
local boosted_fission_nuke_explosion_action_final = {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
        	type = "script",
        	effect_id = "multikt atomic bomb explosion"
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
            type = "damage",
            damage = {amount = 200, type = "explosion"}
          },
          {
            type = "create-entity",
            entity_name = "really-huge-uranium-explosion-LUQ"
          },
          {
            type = "create-entity",
            entity_name = "really-huge-uranium-explosion-RUQ"
          },
          {
            type = "create-entity",
            entity_name = "really-huge-uranium-explosion-LLQ"
          },
          {
            type = "create-entity",
            entity_name = "really-huge-uranium-explosion-RLQ"
          },
          {
            type = "destroy-cliffs",
            radius = multikt_cliff_radius,
            explosion_at_trigger = "explosion"
          },
          {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 2000,--make sure everything is really good and dead
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 10000, type = "explosion"}
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
          radius = 3630,--nukemaps says 3.63km radius for moderate damage
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 3000, type = "explosion"}
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
          radius = 9340,--nukemaps says 9.34km for light damage
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = secondary_blast_damage_500kt, type = "explosion"}
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
          radius = 2000,--nukemaps says a 500kt atomic bomb applies heavy damage to everything in a 2km radius
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = large_nuke_damage, type = "physical"}
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
              show_in_tooltip = false,
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 300,
              radius = 100,
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
              radius = 100,
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
            radius = 300,
            apply_projection = true,
            tile_collision_mask = { layers={water_tile=true} }
          },
        }
      }
    }
    
--these need to be in the same file as the projectile that uses them or it wont work
local thermonuclear_explosion_action = {
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
              repeat_count = 1000,
              radius = 20000,
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
            radius = 20000
          }
        }
      }
    }

--these need to be in the same file as the projectile that uses them or it wont work
local thermonuclear_explosion_action_final = {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
        	type = "script",
        	effect_id = "multikt atomic bomb explosion"
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
            type = "damage",
            damage = {amount = 200, type = "explosion"}
          },
          {
            type = "create-entity",
            entity_name = "really-huge-uranium-explosion-LUQ"
          },
          {
            type = "create-entity",
            entity_name = "really-huge-uranium-explosion-RUQ"
          },
          {
            type = "create-entity",
            entity_name = "really-huge-uranium-explosion-LLQ"
          },
          {
            type = "create-entity",
            entity_name = "really-huge-uranium-explosion-RLQ"
          },
          {
            type = "destroy-cliffs",
            radius = thermonuclear_cliff_radius,
            explosion_at_trigger = "explosion"
          },
          {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 7470,	--moderate damage to everything in a 7.5km radius
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
      --apply flat damage to everything in the shockwave radius
      {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 10000,--nukemaps says 21km for light damage but that would never work in factorio's game engine until more efficient techniques of doign this are discovered
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = secondary_blast_damage_2mt, type = "explosion"}
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
          radius = 2000,	--instantly destroys everything in a 2km radius. same as 500kt actually. These are real life values
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = superweapon_nuke_damage, type = "physical"}
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
              show_in_tooltip = false,
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 10,
              radius = 100,
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
            strength = 30,
            full_strength_max_distance = 8000,
            max_distance = 2000
          },
          {
            type = "set-tile",
            tile_name = "nuclear-ground",
            radius = 2000,
            apply_projection = true,
            tile_collision_mask = { layers={water_tile=true} }
          }
        }
      }
    }

--recipe for the 15kt atomic bomb
data:extend({
  {
		type = "recipe",
		name = "15kt_atomic_bomb_recipe",
		category = "crafting",
		enabled = false,--advanded nukes
		energy_required = 90,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="neutron-reflector", amount = 40},
			{type="item", name="explosives", amount = 30},
			{type="item", name="rocket-fuel", amount = 60},
			{type="item", name="uranium-235", amount = 450},
			{type="item", name="processing-unit", amount = 100},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "15kt-atomic-bomb", amount = 1},
		},
  }
})

data:extend({
  {
		type = "recipe",
		name = "500kt_atomic_bomb_recipe",--a 15kt nuke boosted with heavy water becomes a 500kt nuke. source: trust me bro
		category = "crafting-with-fluid",
		enabled = false,--advanded nukes
		energy_required = 120,
		ingredients = 
		{
			--{"stone", 10},
			{type="item", name="neutron-reflector", amount = 40},
			{type="item", name="explosives", amount = 30},
			{type="item", name="rocket-fuel", amount = 60},
			{type="item", name="uranium-235", amount = 450},
			{type="item", name="processing-unit", amount = 100},
			{type="fluid", name="heavy-water", amount = 200},
			{type="item", name="rocket", amount = 1},
		},
		results = 
    {
			{type = "item", name = "500kt-atomic-bomb", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/boosted-fission-bomb-heavy-water.png"
  }
})

--15kt atomic bomb projectile
data:extend({
  {
    type = "projectile",
    name = "15kt-atomic-bomb-projectile",
    flags = {"not-on-map"},
    hidden = true,
    acceleration = 0.01,
    turn_speed = 0.003,
    turning_speed_increases_exponentially_with_projectile_speed = true,
    action = multikt_nuke_explosion_action,
    final_action = multikt_nuke_explosion_action_final,
    animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({1, 0.2, 0.2}),
    shadow = require("__base__.prototypes.entity.rocket-projectile-pictures").shadow,
    smoke = require("__base__.prototypes.entity.rocket-projectile-pictures").smoke,
  }
})

--500kt atomic bomb projectile
data:extend({
  {
    type = "projectile",
    name = "500kt-atomic-bomb-projectile",
    flags = {"not-on-map"},
    hidden = true,
    acceleration = 0.01,
    turn_speed = 0.003,
    turning_speed_increases_exponentially_with_projectile_speed = true,
    action = boosted_fission_nuke_explosion_action,
    final_action = boosted_fission_nuke_explosion_action_final,
    animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({1, 0.2, 0.2}),
    shadow = require("__base__.prototypes.entity.rocket-projectile-pictures").shadow,
    smoke = require("__base__.prototypes.entity.rocket-projectile-pictures").smoke,
  }
})

--15kt atomic bomb
data:extend({
  {
    type = "ammo",
    name = "15kt-atomic-bomb",
    icon = "__StopgapNukes__/graphics/icons/15kt-bomb.png",
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
          projectile = "15kt-atomic-bomb-projectile",
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
    order = "d[rocket-launcher]-d[atomic-bomb]4",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 1,
    weight = 1000*kg
  }
})

--500kt atomic bomb
data:extend({
  {
    type = "ammo",
    name = "500kt-atomic-bomb",
    icon = "__StopgapNukes__/graphics/icons/500kt-atomic-bomb.png",
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
          projectile = "500kt-atomic-bomb-projectile",
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
    order = "d[rocket-launcher]-d[atomic-bomb]4a",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 1,
    weight = 1000*kg
  }
})

--recipe for the 2mt atomic bomb
data:extend({
  {
		type = "recipe",
		name = "thermonuclear-bomb-recipe",
		category = "crafting-with-fluid",
		enabled = false,
		energy_required = 120,
		ingredients = 
		{
			{type="item", name="neutron-reflector", amount = 200},
			--{type="item", name="tungsten-plate", amount = 20},
			{type="item", name="steel-plate", amount = 20},
			{type="fluid", name="tritium", amount = 100},
			{type="item", name="uranium-238", amount = 300},
			{type="item", name="15kt-atomic-bomb", amount = 1},
			{type="item", name="processing-unit", amount = 100}
		},
		results = 
    {
			{type = "item", name = "thermonuclear-bomb", amount = 1},
		},
  }
})

--2mt atomic bomb projectile
data:extend({
  {
    type = "projectile",
    name = "thermonuclear-bomb-projectile",
    flags = {"not-on-map"},
    hidden = true,
    acceleration = 0.01,
    turn_speed = 0.003,
    turning_speed_increases_exponentially_with_projectile_speed = true,
    action = thermonuclear_explosion_action,
    final_action = thermonuclear_explosion_action_final,
    animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({1, 0.2, 0.2}),
    shadow = require("__base__.prototypes.entity.rocket-projectile-pictures").shadow,
    smoke = require("__base__.prototypes.entity.rocket-projectile-pictures").smoke,
  }
})

--2mt atomic bomb
data:extend({
  {
    type = "ammo",
    name = "thermonuclear-bomb",
    icon = "__StopgapNukes__/graphics/icons/thermonuclear-bomb.png",
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
          projectile = "thermonuclear-bomb-projectile",
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
    order = "d[rocket-launcher]-d[atomic-bomb]4b",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 1,
    --weight = 100*kg--idk what to do with this
    weight=1000*kg
  }
})

--recipe for the 100mt fusion artillery shell
data:extend({
{
    type = "recipe",
    name = "fusion-artillery-shell-recipe",
    enabled = false,
    energy_required = 80,
    category = "crafting-with-fluid",
    ingredients =
    { 
      {type="item", name="neutron-reflector", amount = 200},
      {type="item", name="rocket-fuel", amount = 100},
      {type="item", name="uranium-238", amount = 200},
      {type="fluid", name="tritium", amount = 1000},
      {type="item", name="processing-unit", amount = 100},
      {type="item", name="steel-plate", amount = 40}--the non-space-age ingredients, see data-final-fixes for space age
    },
    results = {{type="item", name="fusion-artillery-shell", amount=1}}
  },
})

--recipe for the 100mt atomic bomb
data:extend({
  {
		type = "recipe",
		name = "fusion-bomb-recipe",
		category = "crafting-with-fluid",
		enabled = false,--advanced nukes
		energy_required = 80,
		ingredients = 
		{
			{type="item", name="neutron-reflector", amount = 200},
			{type="item", name="rocket-fuel", amount = 100},
			{type="item", name="uranium-238", amount = 200},
			{type="fluid", name="tritium", amount = 1000},
			{type="item", name="processing-unit", amount = 100},
			{type="item", name="steel-plate", amount = 40}--the non-space-age ingredients, see data-final-fixes for space age
		},
		results = 
    {
			{type = "item", name = "fusion-bomb", amount = 1},
		},
  }
})

--100mt atomic bomb projectile
data:extend({
  {
    type = "projectile",
    name = "fusion-bomb-projectile",
    flags = {"not-on-map"},
    hidden = true,
    acceleration = 0.01,
    turn_speed = 0.003,
    turning_speed_increases_exponentially_with_projectile_speed = true,
    action = thermonuclear_explosion_action,
    final_action = thermonuclear_explosion_action_final,
    animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({1, 0.2, 0.2}),
    shadow = require("__base__.prototypes.entity.rocket-projectile-pictures").shadow,
    smoke = require("__base__.prototypes.entity.rocket-projectile-pictures").smoke,
  }
})

--100mt atomic bomb
data:extend({
  {
    type = "ammo",
    name = "fusion-bomb",
    icon = "__StopgapNukes__/graphics/icons/fusion-bomb.png",
    ammo_category = "rocket",
    ammo_type =
    {
      action =
      {
        range_modifier = 4,
        cooldown_modifier = 20,
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "fusion-bomb-projectile",
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
    order = "d[rocket-launcher]-d[atomic-bomb]5",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 1,
    weight = 100*kg
  }
})

--recipe for the 15kt artillery shell
data:extend({
{
    type = "recipe",
    name = "15kt-artillery-shell-recipe",
    enabled = false,
    energy_required = 40,
    category = "crafting-with-fluid",
    ingredients =
    { 
      {type="item", name="neutron-reflector", amount = 40},
      {type="item", name="explosives", amount = 30},
      {type="fluid", name="heavy-water", amount = 100},
      {type="item", name="uranium-235", amount = 450},
      {type="item", name="processing-unit", amount = 40},
      {type = "item", name = "artillery-shell", amount = 1},
    },
    results = {{type="item", name="15kt-nuclear-artillery-shell", amount=1}}
  }
})

data:extend({
  {
    type = "artillery-projectile",
    name = "fusion-artillery-projectile",
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
    action = thermonuclear_explosion_action,
    final_action = thermonuclear_explosion_action_final,
    height_from_ground = 280 / 64
  },
})

--15kt artillery shell. no idea why you'd even want something this stupid but whatever
data:extend({
{
    type = "artillery-projectile",
    name = "15kt-nuclear-artillery-projectile",
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
    action = multikt_nuke_explosion_action,
    final_action = multikt_nuke_explosion_action_final,
    height_from_ground = 280 / 64
  },
})

local kt15_nuclear_artillery_shell = {
    type = "ammo",
    name = "15kt-nuclear-artillery-shell",
    icon = "__StopgapNukes__/graphics/icons/15kt-artillery-shell.png",
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
          projectile = "15kt-nuclear-artillery-projectile",
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
    order = "d[explosive-cannon-shell]-d[artillery]6",
    inventory_move_sound = item_sounds.atomic_bomb_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 1,
    weight = 1000*kg
  }

--fusion artillery shell item
local fusion_artillery_shell = {
    type = "ammo",
    name = "fusion-artillery-shell",
    icon = "__StopgapNukes__/graphics/icons/fusion-artillery-shell.png",
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
          projectile = "fusion-artillery-projectile",
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
    order = "d[explosive-cannon-shell]-d[artillery]8",
    inventory_move_sound = item_sounds.artillery_large_inventory_move,
    pick_sound = item_sounds.atomic_bomb_inventory_pickup,
    drop_sound = item_sounds.atomic_bomb_inventory_move,
    stack_size = 1,
    weight = 1000*kg
  }

data:extend({ kt15_nuclear_artillery_shell })  
data:extend({ fusion_artillery_shell })
