local sounds = require("__base__/prototypes/entity/sounds")
local smoke_animations = require("__base__/prototypes/entity/smoke-animations")
local smoke_fast_animation = smoke_animations.trivial_smoke_fast
local trivial_smoke = smoke_animations.trivial_smoke
local item_sounds = require("__base__.prototypes.item_sounds")
local fallout_duration = 180

data:extend({
  {
    type = "ammo",
    name = "dirty-bomb",
    icon = "__StopgapNukes__/graphics/icons/dirty-bomb.png",
    ammo_category = "rocket",
    ammo_type =
    {
      range_modifier = 3.5,
      cooldown_modifier = 5,
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "dirty-bomb",
          starting_speed = 0.1,
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-hit",
            only_when_visible = true
          }
        }
      }
    },
    subgroup = "ammo",
    order = "d[rocket-launcher]-0[explosive]",
    inventory_move_sound = item_sounds.ammo_large_inventory_move,
    pick_sound = item_sounds.ammo_large_inventory_pickup,
    drop_sound = item_sounds.ammo_large_inventory_move,
    stack_size = 20,
    weight = 50*kg
  }
})

data:extend({
{
    type = "recipe",
    name = "dirty-bomb",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 15,
    ingredients =
    {
      {type = "fluid", name = "sulfuric-acid", amount = 100},
      {type = "item", name = "uranium-235", amount = 10},
      --{type = "item", name = "polonium-210", amount = 20},
      {type = "item", name = "coal", amount = 20},--placeholder
      {type = "item", name = "rocket", amount = 1},
    },
    results = {{type="item", name="dirty-bomb", amount=1}}
  },
})

data:extend({
    {
    type = "projectile",
    name = "dirty-bomb",
    flags = {"not-on-map"},
    hidden = true,
    acceleration = 0.01,
    turn_speed = 0.003,
    turning_speed_increases_exponentially_with_projectile_speed = true,
    action =
    {
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = true,
              entity_name = "nukeage-cloud",
              initial_height = 0
            },
            {
              type = "create-particle",
              particle_name = "poison-capsule-metal-particle",
              repeat_count = 50,
              initial_height = 2,
              initial_vertical_speed = 0.2,
              initial_vertical_speed_deviation = 0.1,
              offset_deviation = {{-0.1, -0.1}, {0.1, 0.1}},
              speed_from_center = 0.2,
              speed_from_center_deviation = 0.01
            },
            {
                type = "create-entity",
                entity_name = "big-explosion",
                only_when_visible = true
            },
            {
            type = "nested-result",
            action =
            {
              type = "area",
              radius = 6.5,
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "damage",
                    damage = {amount = 100, type = "explosion"}
                  },
                  {
                    type = "create-entity",
                    entity_name = "explosion",
                    only_when_visible = true
                  }
                }
              }
            }
          }
          }
        }
      }
    },
    final_action=
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
        	type = "script",
        	effect_id = "dirty_bomb_explosion"
      	  }
        }
      }
    },
    --light = {intensity = 0.5, size = 4},
    animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({1, 0.2, 0.2}),
    shadow =
    {
      filename = "__base__/graphics/entity/poison-capsule/poison-capsule-shadow.png",
      frame_count = 16,
      line_length = 8,
      animation_speed = 0.250,
      width = 54,
      height = 42,
      shift = util.by_pixel(1, 2),
      priority = "high",
      draw_as_shadow = true,
      scale = 0.5
    },
    smoke =
    {
      {
        name = "poison-capsule-smoke",
        deviation = {0.15, 0.15},
        frequency = 1,
        position = {0, 0},
        starting_frame = 3,
        starting_frame_deviation = 5,
      }
    }
  }
})

data:extend({
    {
    name = "nukeage-cloud",
    type = "smoke-with-trigger",
    flags = {"not-on-map"},
    hidden = true,
    show_when_smoke_off = true,
    particle_count = 100,
    particle_spread = { 3.6 * 1.05, 3.6 * 0.6 * 1.05 },
    particle_distance_scale_factor = 1.5,
    particle_scale_factor = { 1, 0.707 },
    wave_speed = { 1/80, 1/60 },
    wave_distance = { 0.3, 0.2 },
    spread_duration_variation = 20,
    particle_duration_variation = 60 * 3,
    render_layer = "object",

    affected_by_wind = false,
    cyclic = true,
    duration = fallout_duration * 20,
    fade_away_duration = 2 * 60,
    spread_duration = 20,
    color = { 0.133, 0.869, 0.0, 0.690 }, -- #3ddffdb0,

    animation =
    {
      width = 152,
      height = 120,
      line_length = 5,
      frame_count = 60,
      shift = {-0.53125, -0.4375},
      priority = "high",
      animation_speed = 0.25,
      filename = "__base__/graphics/entity/smoke/smoke.png",
      flags = { "smoke" }
    },

    created_effect =
    {
      {
        type = "cluster",
        cluster_count = 250,
        distance = 4,
        distance_deviation = 65,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = false,
              entity_name = "nukeage-cloud-visual-dummy",
              initial_height = 0
            },
            {
              type = "play-sound",
              sound = sounds.poison_capsule_explosion
            }
          }
        }
      },
      {
        type = "cluster",
        cluster_count = 50,
        distance = 32 * 1.1,
        distance_deviation = 10,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = false,
              entity_name = "nukeage-cloud-visual-dummy",
              initial_height = 0
            }
          }
        }
      }
    },
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "nested-result",
          action =
          {
            type = "area",
            radius = 35,
            entity_flags = {"breaths-air", "placeable-enemy"},
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                type = "damage",
                damage = { amount = 350, type = "poison"}
              }
            }
          }
        }
      }
    },
    action_cooldown = 30
  }
})


data:extend({
    {
    type = "smoke-with-trigger",
    name = "nukeage-cloud-visual-dummy",
    flags = {"not-on-map"},
    hidden = true,
    show_when_smoke_off = true,
    particle_count = 100,
    particle_spread = { 3.6 * 3.05, 3.6 * 0.6 * 3.05 },
    particle_distance_scale_factor = 1.5,
    particle_scale_factor = { 1, 0.707 },
    particle_duration_variation = 60 * 3,
    wave_speed = { 0.5 / 80, 0.5 / 60 },
    wave_distance = { 1, 0.5 },
    spread_duration_variation = 300 - 20,

    render_layer = "object",

    affected_by_wind = false,
    cyclic = true,
    duration = fallout_duration * 20 + 4 * fallout_duration,
    fade_away_duration = 3 * 60,
    spread_duration = (300 - 20) / 2 ,
    color = { 0.133, 0.869, 0.0, 0.690 },

    animation =
    {
      width = 152,
      height = 120,
      line_length = 5,
      frame_count = 60,
      shift = {-0.53125, -0.4375},
      priority = "high",
      animation_speed = 0.25,
      filename = "__base__/graphics/entity/smoke/smoke.png",
      flags = { "smoke" }
    },
    working_sound =
    {
      sound = {filename = "__StopgapNukes__/MushroomCloudInBuilt/sound/radiation_ticking.ogg", volume = 1.5, audible_distance_modifier = 3.0},
      max_sounds_per_prototype = 1,
      match_volume_to_activity = true
    }
  }
})

--dirty bomb in artillery form
data:extend({
  {
    type = "ammo",
    name = "dirty-bomb-artillery-shell",
    icon = "__StopgapNukes__/graphics/icons/dirty-bomb-artillery-shell.png",
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
          projectile = "dirty-bomb-artillery-projectile",
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
})

data:extend({
  {
    type = "artillery-projectile",
    name = "dirty-bomb-artillery-projectile",
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
  }
})

data:extend({
  {
    type = "recipe",
    name = "dirty-bomb-artillery-shell",
    enabled = false,
    energy_required = 30,
    category = "crafting-with-fluid",
    ingredients =
    {
      {type = "fluid", name = "sulfuric-acid", amount = 100},
      {type = "item", name = "uranium-235", amount = 10},
      {type = "item", name = "coal", amount = 20},
      {type = "item", name = "artillery-shell", amount = 1},
    },
    results = {{type="item", name="dirty-bomb-artillery-shell", amount=1}}
  }
})

--the poison gas bomb
data:extend({
  {
    type = "ammo",
    name = "poison-bomb",
    icon = "__StopgapNukes__/graphics/icons/poison-bomb.png",
    ammo_category = "rocket",
    ammo_type =
    {
      range_modifier = 3.5,
      cooldown_modifier = 5,
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "poison-bomb",
          starting_speed = 0.1,
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-hit",
            only_when_visible = true
          }
        }
      }
    },
    subgroup = "ammo",
    order = "d[rocket-launcher]-0[explosive]",
    inventory_move_sound = item_sounds.ammo_large_inventory_move,
    pick_sound = item_sounds.ammo_large_inventory_pickup,
    drop_sound = item_sounds.ammo_large_inventory_move,
    stack_size = 20,
    weight = 50*kg
  }
})

data:extend({
{
    type = "recipe",
    name = "poison-bomb",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 15,
    ingredients =
    {
      {type = "fluid", name = "heavy-oil", amount = 100},
      {type = "item", name = "poison-capsule", amount = 30},
      {type = "item", name = "electronic-circuit", amount = 2},--placeholder
      {type = "item", name = "rocket", amount = 1},
    },
    results = {{type="item", name="poison-bomb", amount=1}}
  },
})

data:extend({
    {
    type = "projectile",
    name = "poison-bomb",
    flags = {"not-on-map"},
    hidden = true,
    acceleration = 0.01,
    turn_speed = 0.003,
    turning_speed_increases_exponentially_with_projectile_speed = true,
    action =
    {
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = true,
              entity_name = "poison-bomb-cloud",
              initial_height = 0
            },
            {
              type = "create-particle",
              particle_name = "poison-capsule-metal-particle",
              repeat_count = 50,
              initial_height = 2,
              initial_vertical_speed = 0.2,
              initial_vertical_speed_deviation = 0.1,
              offset_deviation = {{-0.1, -0.1}, {0.1, 0.1}},
              speed_from_center = 0.2,
              speed_from_center_deviation = 0.01
            },
            {
                type = "create-entity",
                entity_name = "big-explosion",
                only_when_visible = true
            },
            {
            type = "nested-result",
            action =
            {
              type = "area",
              radius = 6.5,
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "damage",
                    damage = {amount = 100, type = "explosion"}
                  },
                  {
                    type = "create-entity",
                    entity_name = "explosion",
                    only_when_visible = true
                  }
                }
              }
            }
          }
          }
        }
      }
    },
    --light = {intensity = 0.5, size = 4},
    animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({1, 0.2, 0.2}),
    shadow =
    {
      filename = "__base__/graphics/entity/poison-capsule/poison-capsule-shadow.png",
      frame_count = 16,
      line_length = 8,
      animation_speed = 0.250,
      width = 54,
      height = 42,
      shift = util.by_pixel(1, 2),
      priority = "high",
      draw_as_shadow = true,
      scale = 0.5
    },
    smoke =
    {
      {
        name = "poison-capsule-smoke",
        deviation = {0.15, 0.15},
        frequency = 1,
        position = {0, 0},
        starting_frame = 3,
        starting_frame_deviation = 5,
      }
    }
  }
})

data:extend({
    {
    name = "poison-bomb-cloud",
    type = "smoke-with-trigger",
    flags = {"not-on-map"},
    hidden = true,
    show_when_smoke_off = true,
    particle_count = 100,
    particle_spread = { 3.6 * 1.05, 3.6 * 0.6 * 1.05 },
    particle_distance_scale_factor = 1.5,
    particle_scale_factor = { 1, 0.707 },
    wave_speed = { 1/80, 1/60 },
    wave_distance = { 0.3, 0.2 },
    spread_duration_variation = 20,
    particle_duration_variation = 60 * 3,
    render_layer = "object",

    affected_by_wind = false,
    cyclic = true,
    duration = 60 * 20,
    fade_away_duration = 2 * 20,
    spread_duration = 20,
    color = {0.563, 0.0, 0.869, 0.322},

    animation =
    {
      width = 152,
      height = 120,
      line_length = 5,
      frame_count = 60,
      shift = {-0.53125, -0.4375},
      priority = "high",
      animation_speed = 0.25,
      filename = "__base__/graphics/entity/smoke/smoke.png",
      flags = { "smoke" }
    },

    created_effect =
    {
      {
        type = "cluster",
        cluster_count = 250,
        distance = 4,
        distance_deviation = 65,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = false,
              entity_name = "poison-bomb-cloud-visual-dummy",
              initial_height = 0
            },
            {
              type = "play-sound",
              sound = sounds.poison_capsule_explosion
            }
          }
        }
      },
      {
        type = "cluster",
        cluster_count = 50,
        distance = 32 * 1.1,
        distance_deviation = 10,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = false,
              entity_name = "poison-bomb-cloud-visual-dummy",
              initial_height = 0
            }
          }
        }
      }
    },
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "nested-result",
          action =
          {
            type = "area",
            radius = 35,
            --entity_flags = {"breaths-air", "placeable-enemy"},
            entity_flags = {"breaths-air"}, --not as good as the tetrakalis cyanide bomb
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                type = "damage",
                damage = { amount = 100, type = "poison"}
              }
            }
          }
        }
      }
    },
    action_cooldown = 30
  }
})


data:extend({
    {
    type = "smoke-with-trigger",
    name = "poison-bomb-cloud-visual-dummy",
    flags = {"not-on-map"},
    hidden = true,
    show_when_smoke_off = true,
    particle_count = 100,
    particle_spread = { 3.6 * 3.05, 3.6 * 0.6 * 3.05 },
    particle_distance_scale_factor = 1.5,
    particle_scale_factor = { 1, 0.707 },
    particle_duration_variation = 60 * 3,
    wave_speed = { 0.5 / 80, 0.5 / 60 },
    wave_distance = { 1, 0.5 },
    spread_duration_variation = 300 - 20,

    render_layer = "object",

    affected_by_wind = false,
    cyclic = true,
    duration = 60 * 20 + 4 * 60,
    fade_away_duration = 3 * 60,
    spread_duration = (300 - 20) / 2 ,
    color = {0.563, 0.0, 0.869, 0.322}, -- #035b6452

    animation =
    {
      width = 152,
      height = 120,
      line_length = 5,
      frame_count = 60,
      shift = {-0.53125, -0.4375},
      priority = "high",
      animation_speed = 0.25,
      filename = "__base__/graphics/entity/smoke/smoke.png",
      flags = { "smoke" }
    },
    working_sound =
    {
      sound = {filename = "__base__/sound/fight/poison-cloud.ogg", volume = 0.5, audible_distance_modifier = 0.8},
      max_sounds_per_prototype = 1,
      match_volume_to_activity = true
    }
  }
})

--poison cannon shell
data:extend({
{
  type = "ammo",
    name = "poison-cannon-shell",
    icon = "__StopgapNukes__/graphics/icons/poison-cannon-shell.png",
    pictures =
    {
      layers =
      {
        {
          size = 64,
          filename = "__StopgapNukes__/graphics/icons/poison-cannon-shell.png",
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
          projectile = "poison-cannon-projectile",
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
    order = "d[explosive-cannon-shell]-c[uranium]-0",--everyone says whats in the [] brackets doesnt matter. the documentation says it doesnt matter. BUT IT DOES MATTER.
    inventory_move_sound = item_sounds.ammo_large_inventory_move,
    pick_sound = item_sounds.ammo_large_inventory_pickup,
    drop_sound = item_sounds.ammo_large_inventory_move,
    stack_size = 20,
    weight = 100*kg
  }
})

data:extend({
  {
    type = "projectile",
    name = "poison-cannon-projectile",
    flags = {"not-on-map"},
    hidden = true,
    collision_box = {{-0.3, -1.1}, {0.3, 1.1}},
    acceleration = 0,
    piercing_damage = 100,
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "damage",
            damage = {amount = 180, type = "physical"}
          },
          {
            type = "create-entity",
            entity_name = "explosion"
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
            type = "create-entity",
            entity_name = "big-explosion"
          },
          {
              type = "create-smoke",
              show_in_tooltip = true,
              entity_name = "poison-bomb-cloud",
              initial_height = 0
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              radius = 4,
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "damage",
                    damage = {amount = 300, type = "explosion"}
                  },
                  {
                    type = "create-entity",
                    entity_name = "explosion"
                  }
                }
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
          from_render_layer = "decorative",
          to_render_layer = "object",
          include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
          include_decals = false,
          invoke_decorative_trigger = true,
          decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
          radius = 2 -- large radius for demostrative purposes
          }
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

data:extend({
{
    type = "recipe",
    name = "poison-cannon-shell",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 15,
    ingredients =
    {
      {type = "fluid", name = "heavy-oil", amount = 100},
      {type = "item", name = "poison-capsule", amount = 30},
      {type = "item", name = "electronic-circuit", amount = 2},--placeholder
      {type = "item", name = "explosive-cannon-shell", amount = 1},
    },
    results = {{type="item", name="poison-cannon-shell", amount=1}}
  },
})

--acid bomb
data:extend({
  {
    type = "ammo",
    name = "acid-bomb",
    icon = "__StopgapNukes__/graphics/icons/acid-bomb.png",
    ammo_category = "rocket",
    ammo_type =
    {
      range_modifier = 3.5,
      cooldown_modifier = 5,
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "acid-bomb",
          starting_speed = 0.1,
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-hit",
            only_when_visible = true
          }
        }
      }
    },
    subgroup = "ammo",
    order = "d[rocket-launcher]-0[poison]",
    inventory_move_sound = item_sounds.ammo_large_inventory_move,
    pick_sound = item_sounds.ammo_large_inventory_pickup,
    drop_sound = item_sounds.ammo_large_inventory_move,
    stack_size = 20,
    weight = 50*kg
  }
})

data:extend({
{
    type = "recipe",
    name = "acid-bomb",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 15,
    ingredients =
    {
      {type = "fluid", name = "sulfuric-acid", amount = 200},
      {type = "item", name = "storage-tank", amount = 1},
      {type = "item", name = "advanced-circuit", amount = 2},
      {type = "item", name = "rocket", amount = 1},
    },
    results = {{type="item", name="acid-bomb", amount=1}}
  },
})

data:extend({
    {
    type = "projectile",
    name = "acid-bomb",
    flags = {"not-on-map"},
    hidden = true,
    acceleration = 0.01,
    turn_speed = 0.003,
    turning_speed_increases_exponentially_with_projectile_speed = true,
    action =
    {
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = true,
              entity_name = "acid-bomb-cloud",
              initial_height = 0
            },
            {
              type = "create-particle",
              particle_name = "poison-capsule-metal-particle",
              repeat_count = 50,
              initial_height = 2,
              initial_vertical_speed = 0.2,
              initial_vertical_speed_deviation = 0.1,
              offset_deviation = {{-0.1, -0.1}, {0.1, 0.1}},
              speed_from_center = 0.2,
              speed_from_center_deviation = 0.01
            },
            {
                type = "create-entity",
                entity_name = "big-explosion",
                only_when_visible = true
            },
            {
            type = "nested-result",
            action =
            {
              type = "area",
              radius = 6.5,
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "damage",
                    damage = {amount = 100, type = "explosion"}
                  },
                  {
                    type = "create-entity",
                    entity_name = "explosion",
                    only_when_visible = true
                  }
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
        	effect_id = "acid_weapon_explosion"
      	  }
        }
      }
    },
    --light = {intensity = 0.5, size = 4},
    animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({1, 0.2, 0.2}),
    shadow =
    {
      filename = "__base__/graphics/entity/poison-capsule/poison-capsule-shadow.png",
      frame_count = 16,
      line_length = 8,
      animation_speed = 0.250,
      width = 54,
      height = 42,
      shift = util.by_pixel(1, 2),
      priority = "high",
      draw_as_shadow = true,
      scale = 0.5
    },
    smoke =
    {
      {
        name = "poison-capsule-smoke",
        deviation = {0.15, 0.15},
        frequency = 1,
        position = {0, 0},
        starting_frame = 3,
        starting_frame_deviation = 5,
      }
    }
  }
})

local acid_cloud_duration = 400
data:extend({
    {
    name = "acid-bomb-cloud",
    type = "smoke-with-trigger",
    flags = {"not-on-map"},
    hidden = true,
    show_when_smoke_off = true,
    particle_count = 100,
    particle_spread = { 3.6 * 1.05, 3.6 * 0.6 * 1.05 },
    particle_distance_scale_factor = 1.5,
    particle_scale_factor = { 1, 0.707 },
    wave_speed = { 1/80, 1/60 },
    wave_distance = { 0.3, 0.2 },
    spread_duration_variation = 20,
    particle_duration_variation = 60 * 3,
    render_layer = "object",

    affected_by_wind = false,
    cyclic = true,
    duration = acid_cloud_duration,
    fade_away_duration = 120,
    spread_duration = 20,
    color = {0.461, 0.675, 0.0, 0.322},

    animation =
    {
      width = 152,
      height = 120,
      line_length = 5,
      frame_count = 60,
      shift = {-0.53125, -0.4375},
      priority = "high",
      animation_speed = 0.25,
      filename = "__base__/graphics/entity/smoke/smoke.png",
      flags = { "smoke" }
    },

    created_effect =
    {
      {
        type = "cluster",
        cluster_count = 250,
        distance = 4,
        distance_deviation = 65,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = false,
              entity_name = "acid-bomb-cloud-visual-dummy",
              initial_height = 0
            },
            {
              type = "play-sound",
              sound = sounds.poison_capsule_explosion
            }
          }
        }
      },
      {
        type = "cluster",
        cluster_count = 50,
        distance = 32 * 1.1,
        distance_deviation = 10,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = false,
              entity_name = "acid-bomb-cloud-visual-dummy",
              initial_height = 0
            }
          }
        }
      }
    },
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "nested-result",
          action =
          {
            type = "area",
            radius = 35,
            --entity_flags = {"breaths-air", "placeable-enemy"},
            entity_flags = { "placeable-player", "placeable-enemy", "placeable-off-grid", "not-repairable", "breaths-air" },
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                type = "damage",
                damage = { amount = 200, type = "acid"}
              }
            }
          }
        }
      }
    },
    action_cooldown = 30
  }
})


data:extend({
    {
    type = "smoke-with-trigger",
    name = "acid-bomb-cloud-visual-dummy",
    flags = {"not-on-map"},
    hidden = true,
    show_when_smoke_off = true,
    particle_count = 100,
    particle_spread = { 3.6 * 3.05, 3.6 * 0.6 * 3.05 },
    particle_distance_scale_factor = 1.5,
    particle_scale_factor = { 1, 0.707 },
    particle_duration_variation = 60 * 3,
    wave_speed = { 0.5 / 80, 0.5 / 60 },
    --wave_speed = { 0.5, 0.5 },
    wave_distance = { 1, 0.5 },
    spread_duration_variation = 300 - 20,

    render_layer = "object",

    affected_by_wind = false,
    cyclic = true,
    --duration = 60 * 20 + 4 * 60,
    duration = acid_cloud_duration,
    --fade_away_duration = 3 * 60,
    fade_away_duration = 6 * 60,
    spread_duration = (300 - 20) / 2 ,
    color = {0.461, 0.675, 0.0, 0.322},

    animation =
    {
      width = 152,
      height = 120,
      line_length = 5,
      frame_count = 60,
      shift = {-0.53125, -0.4375},
      priority = "high",
      animation_speed = 0.25,
      filename = "__base__/graphics/entity/smoke/smoke.png",
      flags = { "smoke" }
    },
    working_sound =
    {
      sound = {filename = "__base__/sound/fight/poison-cloud.ogg", volume = 0.5, audible_distance_modifier = 0.8},
      max_sounds_per_prototype = 1,
      match_volume_to_activity = true
    }
  }
})

--acid artillery shell
data:extend({
{
    type = "ammo",
    name = "acid-artillery-shell",
    icon = "__StopgapNukes__/graphics/icons/acid-artillery-shell.png",
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
          projectile = "acid-artillery-projectile",
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
    order = "d[explosive-cannon-shell]-d[artillery]0",
    inventory_move_sound = item_sounds.artillery_large_inventory_move,
    pick_sound = item_sounds.artillery_large_inventory_pickup,
    drop_sound = item_sounds.artillery_large_inventory_move,
    stack_size = 1,
    weight = 100*kg
    }
})


--acid artillery shell projectile
data:extend({
{
    type = "artillery-projectile",
    name = "acid-artillery-projectile",
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
      filename = "__StopgapNukes__/graphics/artillery/acid-artillery-map-visualization.png",
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

--recipe for acid artillery shell
data:extend({
  {
		type = "recipe",
		name = "acid-artillery-shell",
		category = "crafting-with-fluid",
		enabled = false,
		energy_required = 10,
		ingredients = 
		{
			{type = "fluid", name = "sulfuric-acid", amount = 200},
      {type = "item", name = "storage-tank", amount = 1},
      {type = "item", name = "advanced-circuit", amount = 2},
      {type = "item", name = "artillery-shell", amount = 1},
		},
		results = 
    {
			{type = "item", name = "acid-artillery-shell", amount = 1},
		},
  },
})