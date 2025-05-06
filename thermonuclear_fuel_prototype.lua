--add nuclear fuel to the mod because why not
local item_sounds = require("__base__.prototypes.item_sounds")

local acceleration = settings.startup["stopgapnukes_thermonuclear_fuel_acceleration"].value
local topspeed = settings.startup["stopgapnukes_thermonuclear_fuel_topspeed"].value
local power = settings.startup["stopgapnukes_thermonuclear_fuel_power"].value

--make it impossible for the user to input settings that might crash the game
if power < 0.1 then
	power = 0.1
end

if acceleration < 1 then
	acceleration = 1;
elseif acceleration > 100000 then
	acceleration = 10
end

if topspeed < 1 then
	topspeed = 1;
elseif topspeed > 100000 then
	topspeed = 10
end

local thermonuclear_fuel =
{
    type = "item",
    name = "thermonuclear-fuel",
    icon = "__StopgapNukes__/graphics/icons/thermonuclear-fuel.png",
    pictures =
    {
      layers =
      {
        {
          size = 64,
          filename = "__StopgapNukes__/graphics/icons/thermonuclear-fuel.png",
          scale = 0.5,
          mipmap_count = 4
        },
        {
          draw_as_light = true,
          size = 64,
          filename = "__StopgapNukes__/graphics/icons/thermonuclear-fuel-light.png",
          scale = 0.5
        }
      }
    },
    fuel_category = "chemical",
    fuel_value = power.."GJ",
    fuel_acceleration_multiplier = acceleration,
    fuel_top_speed_multiplier = topspeed,
    -- fuel_glow_color = {r = 0.1, g = 1, b = 0.1},
    subgroup = "uranium-processing",
    order = "r[uranium-processing]-e[nuclear-fuel]1",
    inventory_move_sound = item_sounds.fuel_cell_inventory_move,
    pick_sound = item_sounds.fuel_cell_inventory_pickup,
    drop_sound = item_sounds.fuel_cell_inventory_move,
    stack_size = 1,
    weight = 100*kg
  }
  
--recipe for the thermonuclear fuel
local thermonuclear_fuel_recipe =
  {
		type = "recipe",
		name = "thermonuclear-fuel",
		category = "crafting-with-fluid",
		enabled = false,
		energy_required = 120,
		ingredients = 
		{
			{type="item", name="nuclear-fuel", amount = 1},
			{type="fluid", name="tritium", amount = 10},
		},
		results = 
    {
			{type = "item", name = "thermonuclear-fuel", amount = 1},
		},
		icon = "__StopgapNukes__/graphics/icons/thermonuclearfuel_crafting_icon.png",
  }
  
data:extend({ thermonuclear_fuel })  
data:extend({ thermonuclear_fuel_recipe })  
