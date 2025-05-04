--get the relevant user settings for the stuff this lua file
local heavy_water_crafting_time = settings.startup["stopgapnukes_basic_heavy_water_time_behaviour"].value

data:extend(
{
  {
    type = "fluid",
    name = "heavy-water",
    subgroup = "fluid",
    default_temperature = 15,
    max_temperature = 102,--heavy water has a slightly higher boiling point
    heat_capacity = "2.1kJ",
    base_color = {0, 0.24, 0.6},
    flow_color = {0.5, 0.5, 0.5},
    icon = "__StopgapNukes__/graphics/icons/heavy-water.png",
    order = "a[fluid]-a[water]-a[water]"
  },
  {
    type = "fluid",
    name = "tritium",
    subgroup = "fluid",
    default_temperature = 15,
    max_temperature = 102,--using water values because why not
    heat_capacity = "2.1kJ",
    base_color = {0, 0.95, 0.95},
    flow_color = {0.5, 0.5, 0.5},
    icon = "__StopgapNukes__/graphics/icons/tritium.png",
    order = "a[fluid]-a[water]-a[water]"
  },
  {
    type = "fluid",
    name = "hydrogen-sulfide",
    subgroup = "fluid",
    default_temperature = -70,
    max_temperature = -59.55,--heavy water has a slightly higher boiling point
    heat_capacity = "1.003kJ",
    base_color = {1, 0.95, 0.0},
    flow_color = {1.0, 1.0, 0.0},
    icon = "__StopgapNukes__/graphics/icons/hydrogen-sulfide.png",
    order = "a[fluid]-a[water]-a[water]"
  }
  })
  
  --make hydrogen sulfide
  data:extend({
  {
		type = "recipe",
		name = "hydrogen-sulfide-recipe",
		category = "chemistry",
		enabled = false,
		energy_required = 3,
		ingredients = 
		{
			--{"stone", 10},
			{type="fluid", name="water", amount = 100},
			{type="item", name="sulfur", amount = 5}
		},
		results = 
    {
			{type = "fluid", name = "hydrogen-sulfide", amount = 5},
		},
		crafting_machine_tint =
		{
		  primary = {r = 1.000, g = 0.958, b = 0.000, a = 1.000}, -- #fff400ff
            	  secondary = {r = 1.000, g = 0.852, b = 0.172, a = 1.000}, -- #ffd92bff
            	  tertiary = {r = 0.876, g = 0.869, b = 0.597, a = 1.000}, -- #dfdd98ff
            	  quaternary = {r = 0.969, g = 1.000, b = 0.019, a = 1.000}, -- #f7ff04ff
		},
		subgroup = "intermediate-product",
		allow_productivity = true,
  }
  })
  
  --make heavy water faster
  data:extend({
  {
		type = "recipe",
		name = "girdler-sulfide-recipe",
		category = "chemistry",
		enabled = false,
		energy_required = 15,
		ingredients = 
		{
			--{"stone", 10},
			{type="fluid", name="hydrogen-sulfide", amount = 1000},
			{type="fluid", name="water", amount = 1000}
		},
		results = 
    {
			{type = "fluid", name = "hydrogen-sulfide", amount = 994},
			{type = "fluid", name = "heavy-water", amount = 40}
		},
		crafting_machine_tint =
		{
		  primary = {r = 0.0, g = 0.24, b = 0.70, a = 1.000},
		  secondary = {r = 0.0, g = 0.2551, b = 0.70, a = 1.000},
		  tertiary = {r = 5.0, g = 0.37, b = 0.65, a = 1.000},
		  quaternary = {r = 1.000, g = 0.734, b = 0.290, a = 1.000}, 
		},
		subgroup = "intermediate-product",
		icon = "__StopgapNukes__/graphics/icons/gs-process.png",
		allow_productivity = true,
  }
  })
  
data:extend({
  {
		type = "recipe",
		name = "heavy-water-recipe",
		category = "chemistry",
		enabled = false,
		energy_required = heavy_water_crafting_time,
		ingredients = 
		{
			--{"stone", 10},
			{type="fluid", name="water", amount = 100},
		},
		results = 
    {
			{type = "fluid", name = "heavy-water", amount = 5},
		},
		crafting_machine_tint =
		{
		  primary = {r = 0.0, g = 0.24, b = 0.70, a = 1.000}, -- #c298c6ff
		  secondary = {r = 0.0, g = 0.2551, b = 0.70, a = 1.000}, -- #c28cd7ff
		  tertiary = {r = 0.0, g = 0.37, b = 0.65, a = 1.000}, -- #e4c597ff
		  quaternary = {r = 1.000, g = 0.734, b = 0.290, a = 1.000}, -- #ffbb49ff
		},
		subgroup = "intermediate-product",
		allow_productivity = true,
  }
  })
  
data:extend({
  {
		type = "recipe",
		name = "tritium-recipe",
		category = "chemistry",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			--{"stone", 10},
			{type="fluid", name="heavy-water", amount = 100},
			{type="item", name="uranium-fuel-cell", amount = 1},
		},
		results = 
    {
			{type = "fluid", name = "tritium", amount = 1},
			{type = "fluid", name = "water", amount = 90},
			{type = "item", name = "depleted-uranium-fuel-cell", amount = 1}
		},
		icon = "__StopgapNukes__/graphics/icons/tritium.png",
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
