data:extend({
    {
    	--multiplier for thermobaric explosive pollution
        type = "double-setting",
        name = "stopgapnukes_thermobaricpollution_behaviour",
        setting_type = "startup",
        order = "a1",
		default_value = 1.0,
    },
    {
    	--multiplier for atomic bomb explosive pollution
        type = "double-setting",
        name = "stopgapnukes_atomicpollution_behaviour",
        setting_type = "startup",
        order = "a2",
		default_value = 1.0,
    },
    {
        --thermobaric cliff destroy radius multiplier
        type = "double-setting",
        name = "stopgapnukes_thermobaric_cliff_radius_behaviour",
        setting_type = "startup",
        order = "a3",
		default_value = 1.0,
    },
    {
    	--atomic bomb cliff destroy radius multiplier
        type = "double-setting",
        name = "stopgapnukes_atomic_cliff_radius_behaviour",
        setting_type = "startup",
        order = "a4",
		default_value = 1.0,
    },
    {
    	--basic heavy water recipe crafting time
        type = "double-setting",
        name = "stopgapnukes_basic_heavy_water_time_behaviour",
        setting_type = "startup",
        order = "a5",
		default_value = 60.0,
    },
    {
    	--heavy water recipe requirement multiplier
        type = "double-setting",
        name = "stopgapnukes_basic_heavy_water_requirement_behaviour",
        setting_type = "startup",
        order = "a6",
		default_value = 1.0,
    },
    {
    	--advanced cannon shell heavy water recipe requires neutron plates
        type = "bool-setting",
        name = "stopgapnukes_advanced_cannon_shell_heavy_water_neutronplates_behaviour",
        setting_type = "startup",
        order = "a7",
		default_value = true,
    },
    {
    	--enable effects for 20 ton explosions
        type = "bool-setting",
        name = "stopgapnukes_20t_effects_behaviour",
        setting_type = "startup",
        order = "a8",
		default_value = true,
    },
    {
    	--enable effects for 1kt explosions
        type = "bool-setting",
        name = "stopgapnukes_1kt_effects_behaviour",
        setting_type = "startup",
        order = "a9",
		default_value = false,
    },
    {
    	--whether or not neutron reflectors reqire tungsten if playing space age
        type = "bool-setting",
        name = "stopgapnukes_neutronplate_tungsten_behaviour",
        setting_type = "startup",
        order = "a10",
		default_value = true,
    },
    --{
    --	--damage amount for center of explosions
    --    type = "int-setting",
    --    name = "stopgapnukes_medium_nuke_fireball_behaviour",
    --    setting_type = "startup",
    --    order = "a11",
--		default_value = 500000,
    --},
    --this has the potential to cause more issues than it solves, get rid of it
    --{
    --	--damage amount for center of explosions for large nukes
    --    type = "int-setting",
    --    name = "stopgapnukes_large_nuke_fireball_behaviour",
    --    setting_type = "startup",
    --    order = "a12",
--		default_value = 500000,
  --  },
    --{
    	--damage amount for center of explosions for superweapon-sized nukes and fusion bombs
    --    type = "int-setting",
     --   name = "stopgapnukes_superweapon_fireball_behaviour",
     --   setting_type = "startup",
     --   order = "a13",
--		default_value = 500000,
    --},
    {
    	--500kt nuke research option - advanced nuclear weapons or thermonuclear? Let the user decide.
        type = "bool-setting",
        name = "stopgapnukes_boosted_fission_tech_behaviour",
        setting_type = "startup",
        order = "a14",
		default_value = true,
    },
    {
    	--the vanilla nuke explosion is so useless it's not even worth its ingredients
        type = "int-setting",
        name = "stopgapnukes_vanila_recipe_amount_behaviour",
        setting_type = "startup",
        order = "a15",
		default_value = 30,
    },
    {
    	--allow users to modify the damage that the secondary blast radius does
        type = "int-setting",
        name = "stopgapnukes_secondary_blast_damage_amt",
        setting_type = "startup",
        order = "a16",
		default_value = 0,
    },
    {
    	--thermonuclear fuel acceleration
        type = "double-setting",
        name = "stopgapnukes_thermonuclear_fuel_acceleration",
        setting_type = "startup",
        order = "b5",
		default_value = 3.75,
    },
    {
    	--thermonuclear fuel acceleration
        type = "double-setting",
        name = "stopgapnukes_thermonuclear_fuel_topspeed",
        setting_type = "startup",
        order = "b6",
		default_value = 1.5,
    },
    {
    	--thermonuclear fuel acceleration
        type = "double-setting",
        name = "stopgapnukes_thermonuclear_fuel_power",
        setting_type = "startup",
        order = "b6",
		default_value = 20.69,
    }

})
