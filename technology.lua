
--large atomic bomb research
data:extend
({
{
    type = "technology",
    name = "large-atomic-bomb",
    icon = "__StopgapNukes__/graphics/icons/advanced-atomic-bomb.png",
    icon_size = 256,
    effects = {
      {
        type = "unlock-recipe",
        recipe = "stopgapnukes_neutronreflector_recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "heavy-water-recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "stopgapnukes_big_nuclear_artillery_shell_recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "1kt-artillery-shell-recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "stopgapnukes_big_nuclear_cannon_shell_recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "stopgapnukes_big_nuclear_cannon_shell_recipe_noheavywater"
      },
      {
        type = "unlock-recipe",
        recipe = "stopgapnukes_big_atomic_bomb_recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "stopgapnukes_big_atomic_bomb_recipe-neutron-reflectors"
      },
      {
        type = "unlock-recipe",
        recipe = "1kt_atomic_bomb_recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "1kt_atomic_bomb_heavywater_recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "15kt_atomic_bomb_recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "15kt-artillery-shell-recipe"
      }
    },
    --prerequisites = {"military-4", "kovarex-enrichment-process", "rocketry", "atomic-bomb"},
    prerequisites = {"atomic-bomb"},
    unit =
    {
      count = 10000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1}
      },
      time = 45
    }
  },
  })

--thermobaric bomb research
data:extend
({
{
    type = "technology",
    name = "thermobarics",
    icon = "__StopgapNukes__/graphics/icons/thermobaric-tech.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "stopgapnukes_thermobaric_rocket_recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "stopgapnukes_thermobaric_cannon_shell_recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "stopgapnukes_thermobaric_artillery_shell_recipe"
      },
    },
    prerequisites = {"military-4", "rocketry","flamethrower"},
    unit =
    {
      count = 2000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
      },
      time = 45
    }
  },
  })
  
--thermonuclear bomb
data:extend
({
{
    type = "technology",
    name = "thermonuclear-fusion",
    icon = "__StopgapNukes__/graphics/icons/thermonuclear-fusion.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tritium-recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "thermonuclear-bomb-recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "stopgapnukes_nuclearbullet_recipe"
      }
    },
    prerequisites = {"large-atomic-bomb"},
    unit =
    {
      count = 15000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
        --{"metallurgic-science-pack", 1},
      },
      time = 45
    }
  },
  })
  
--girdler sulfide process (make heavy water fast)
data:extend
({
{
    type = "technology",
    name = "girdler-sulfide",
    icon = "__StopgapNukes__/graphics/icons/gs-process.png",
    icon_size = 64,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "hydrogen-sulfide-recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "girdler-sulfide-recipe"
      }
    },
    prerequisites = {"large-atomic-bomb"},
    unit =
    {
      count = 5000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
        --{"metallurgic-science-pack", 1},--was originally intended for this to require space age metalurgic, this is added if running space age
      },
      time = 30
    }
  },
  })
  
--fusion weapons
data:extend
({
{
    type = "technology",
    name = "full-fusion-weapons",
    icon = "__StopgapNukes__/graphics/icons/fusion-bomb-tech.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "fusion-bomb-recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "fusion-artillery-shell-recipe"
      }
    },
    --prerequisites = {"fusion-reactor", "railgun", "thermonuclear-fusion"},--gets reapplied if running space age
    prerequisites = { "thermonuclear-fusion" },
    unit =
    {
      count = 20000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
        --{"metallurgic-science-pack", 1},
        --{"agricultural-science-pack", 1},
        --{"electromagnetic-science-pack", 1},
        --{"cryogenic-science-pack", 1}	--the commented out values get reapplied if running space age
      },
      time = 45
    }
  },
  })
