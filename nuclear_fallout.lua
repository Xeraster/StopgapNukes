local sounds = require("__base__/prototypes/entity/sounds")
local smoke_animations = require("__base__/prototypes/entity/smoke-animations")
local smoke_fast_animation = smoke_animations.trivial_smoke_fast
local trivial_smoke = smoke_animations.trivial_smoke

local fallout_color = { 0.239, 0.239, 0.239, 0.690 }
local fallout_duration = 180

data:extend({
    {
    name = "small-fallout-cloud",
    type = "smoke-with-trigger",
    flags = {"not-on-map"},
    hidden = true,
    show_when_smoke_off = true,
    particle_count = 100,
    particle_spread = { 3.6 * 1.05, 3.6 * 0.6 * 1.05 },
    particle_distance_scale_factor = 0.5,
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
    color = fallout_color, -- #3ddffdb0,

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
        cluster_count = 10,
        distance = 4,
        distance_deviation = 5,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = false,
              entity_name = "small-fallout-cloud-visual-dummy",
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
        cluster_count = 15,
        distance = 8 * 1.1,
        distance_deviation = 2,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = false,
              entity_name = "small-fallout-cloud-visual-dummy",
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
            radius = 15,
            entity_flags = {"breaths-air", "placeable-enemy"},
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                type = "damage",
                damage = { amount = 200, type = "poison"}
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
    name = "small-fallout-cloud-visual-dummy",
    flags = {"not-on-map"},
    hidden = true,
    show_when_smoke_off = true,
    particle_count = 36,
    particle_spread = { 3.6 * 1.05, 3.6 * 0.6 * 1.05 },
    particle_distance_scale_factor = 0.5,
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
    color = fallout_color, -- #035b6452

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

data:extend({
    {
    name = "large-fallout-cloud",
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
    color = fallout_color, -- #3ddffdb0,

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
              entity_name = "large-fallout-cloud-visual-dummy",
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
              entity_name = "large-fallout-cloud-visual-dummy",
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
                damage = { amount = 200, type = "poison"}
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
    name = "large-fallout-cloud-visual-dummy",
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
    color = fallout_color, -- #035b6452

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

--turns out a massive fallout cloud is needed
data:extend({
    {
    name = "massive-fallout-cloud",
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
    color = fallout_color, -- #3ddffdb0,

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
        distance_deviation = 80,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = false,
              entity_name = "massive-fallout-cloud-visual-dummy",
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
        cluster_count = 1000,
        distance = 60,
        distance_deviation = 60,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-smoke",
              show_in_tooltip = false,
              entity_name = "massive-fallout-cloud-visual-dummy",
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
            radius = 100,
            entity_flags = {"breaths-air", "placeable-enemy"},
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                type = "damage",
                damage = { amount = 200, type = "poison"}
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
    name = "massive-fallout-cloud-visual-dummy",
    flags = {"not-on-map"},
    hidden = true,
    show_when_smoke_off = true,
    particle_count = 150,
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
    color = fallout_color, -- #035b6452

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