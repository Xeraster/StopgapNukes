script.on_init(function() onInit() end)

function onInit()
    storage.TN_shockwave_approaching = storage.TN_shockwave_approaching or false
    storage.TN_shockwave_impact_tick = storage.TN_shockwave_impact_tick or {}
	storage.TN_lightEffects = storage.TN_lightEffects or {}
    -- WIP
end

function dist_a_b(PositionA, PositionB)
    return math.sqrt((PositionB.x - PositionA.x)^2+(PositionB.y-PositionA.y)^2) 
end

function shockwaveTravelTimeInTicks(distance)
    return (distance*60)/330
    -- WIP
end

--so lemme get this straight... this is used in True Nukes UNMODIFIED and it WORKS but when I do THE EXACT SAME SHIT here and use it THE EXACT SAME WAY it DOESN'T WORK. WHAT THE FUCK?
function createBlastSoundsAndFlash(position, surface, radius_1, radius_2, radius_3, radius_4, radius_radiation, light_scale)
	local evtSurfaceID 
	if surface then
		evtSurfaceID = surface.index 
	end
	local dist = 0
	local renderFlashForPlayers = {}
	for i, player in pairs(game.connected_players) do
		--if player.mod_settings["TN-mushroom-cloud-style-nuclear-flash"].value == true then
			--in stopgap nukes this needs to not be disable-able because reasons
			renderFlashForPlayers[#renderFlashForPlayers + 1] = player
		--end
	end
	local flashBase
	local flash
	if #renderFlashForPlayers > 0 then
		flashBase = rendering.draw_light{sprite = "utility/light_medium", scale = 5*light_scale, intensity = 1, minimum_darkness = 0, 
			target = position, surface = surface, time_to_live = 300, players = renderFlashForPlayers}
		flash = rendering.draw_sprite{sprite = "utility/light_medium", x_scale = 5*light_scale, y_scale = 5*light_scale, render_layer = "light-effect", 
			minimum_darkness = 0, tint = {0.95, 0.95, 1, 1}, target = position, surface = surface, time_to_live = 300, players = renderFlashForPlayers}
	end
	local lightGlow = rendering.draw_light{sprite = "utility/light_medium", scale = 50*light_scale, intensity = 0.4, minimum_darkness = 0, 
		target = position, surface = surface, color = {1, 0.5, 0.2, 0.1}, time_to_live = 1700}	
	local lightBase = rendering.draw_light{sprite = "utility/light_medium", scale = 20*light_scale, intensity = 1, minimum_darkness = 0, 
		target = position, surface = surface, time_to_live = 1700}
	local lightSurface = rendering.draw_sprite{sprite = "utility/light_medium", x_scale = 20*light_scale, y_scale = 17*light_scale, render_layer = "lower-object-above-shadow", 
		minimum_darkness = 0, tint = {0.75, 0.65, 0.6, 0.2}, target = position, surface = surface, time_to_live = 1700}
	local lightObjects = rendering.draw_sprite{sprite = "utility/light_medium", x_scale = 25*light_scale, y_scale = 21.5*light_scale, render_layer = "entity-info-icon-above", 
		minimum_darkness = 0, tint = {1, 0.9, 0.5, 0.4}, target = position, surface = surface, time_to_live = 1700}
	local lightCenterGlow = rendering.draw_sprite{sprite = "utility/light_medium", x_scale = 10*light_scale, y_scale = 8*light_scale, render_layer = "light-effect", 
		minimum_darkness = 0, tint = {1, 0.5, 0.2, 0.4}, target = position, surface = surface, time_to_live = 1700}
	local effects = {}
	--game.print("got here") 
	effects.maxDur = 500
	effects.ttl = 500
	effects.tickstart = game.tick
	effects.tickend = game.tick + effects.ttl
	effects.ids = {glow = lightGlow, light = lightBase, surface = lightSurface, objects = lightObjects, center = lightCenterGlow}
	if flashBase ~= nil then
		--game.print("got here 2") 
		effects.flashDuration = 5
		effects.flashMaxScale = 100*light_scale
		effects.flashTransition = 300		
		effects.flashTransitionScale = 20
		effects.flashTransitionStartFadeOut = 150 	--FADE OUT MY ASS
		local flashTransitionColorStart = {0.95, 0.95, 1, 1}
		--local flashTransitionColorEnd = {0.0, 0.0, 0.0, 0.0}--DOESNT FUCKING DO ANYTHING
		local flashTransitionColorEnd = {1, 0.5, 0.2, 0.4}
		local flashTransitionTicks = effects.flashDuration - effects.flashTransitionStartFadeOut	--math is incorrect but it doesn't matter BECAUSE THIS DOESNT WORK
		--local flashTransitionTicks = 200
		local flashTransitionColorStep = {
			(flashTransitionColorStart[1] - flashTransitionColorEnd[1]) / flashTransitionTicks,  
			(flashTransitionColorStart[2] - flashTransitionColorEnd[2]) / flashTransitionTicks,
			(flashTransitionColorStart[3] - flashTransitionColorEnd[3]) / flashTransitionTicks,
			(flashTransitionColorStart[4] - flashTransitionColorEnd[4]) / flashTransitionTicks}			
		effects.flashTransitionColorStep = flashTransitionColorStep
		effects.flashTransitionColorEnd = flashTransitionColorEnd
		effects.ids.flashBase = flashBase
		effects.ids.flash = flash
	end
	effects.light_scale = light_scale;
	if storage.TN_lightEffects == nil then
		storage.TN_lightEffects = {}
	end

	--game.print("got here 3") 
	
	storage.TN_lightEffects[#storage.TN_lightEffects+1] = effects
		
        for i, player in pairs(game.connected_players) do
		if player.surface.index == evtSurfaceID then
			dist = dist_a_b(player.position, position)
			if dist < radius_1 then
				player.play_sound{path = "nuclear-detonation-close-proximity"}
				--player.surface.create_entity({name = "nuclears-detonation-close-proximity", position = player.position})
			elseif dist < radius_2 then
				player.play_sound{path = "nuclear-detonation-in-vincinity"}
				--player.surface.create_entity({name = "nuclear-detonation-in-vincinity", position = player.position})
			elseif dist < radius_3 then
				player.play_sound{path = "nuclear-detonation-distant-boom"}
				--player.surface.create_entity({name = "nuclear-detonation-distant-boom", position = player.position})
			elseif dist < radius_4 then
				player.play_sound{path = "nuclear-detonation-far-away"}
				--player.surface.create_entity({name = "nuclear-detonation-far-away", position = player.position})
			end
			if dist < radius_radiation then
				player.play_sound{path = "nuclear-detonation-radiation-ticking"}
			end
		end
        end
end

--somehow this doesnt do anything. its sets the colors but nothing actually changes. Wish I would've known changing colors isn't something you can do BEFORE FUCKING MAKING THIS
function everyTick_useless(event)
	if storage.TN_lightEffects == nil then
		storage.TN_lightEffects = {}
	end

	if storage.TN_lightEffects ~= nil then
		for i, effects in pairs(storage.TN_lightEffects) do
			--effects.ttl = effects.ttl - 1
			if effects.ids ~= nil then
				local flash = effects.ids.flash
				local flashBase = effects.ids.flashBase
				local light = effects.ids.light
				local lightglow = effects.ids.glow
				local surface = effects.ids.surface
				local objects = effects.ids.objects
				local center = effects.ids.center

				if flash ~= nil and flash.valid and flash.color ~= nil and flash.color.a ~= nil then
					if flash.color.a < 0.01 then
						flash.color = {r = 0, g = 0, b = 0, a = 0}
					else
						flash.color = {r = flash.color.r, g = flash.color.g, b = flash.color.b, a= flash.color.a - 0.001}
					end
					game.print("flash.color.a = "..flash.color.a)
				end

				if flashBase ~= nil and flashBase.valid and flashBase.color ~= nil and flashBase.color.a ~= nil then
					if flashBase.color.a < 0.01 then
						flashBase.color = {r = 0, g = 0, b = 0, a = 0}
					else
						flashBase.color = {r = flashBase.color.r, g = flashBase.color.g, b = flashBase.color.b, a= flashBase.color.a - 0.001}
					end
					game.print("flashBase.color.a = "..flashBase.color.a)
				end

				if light ~= nil and light.valid and light.color ~= nil and light.color.a ~= nil then
					if light.color.a < 0.01 then
						light.color = {r = 0, g = 0, b = 0, a = 0}
					else
						light.color = {r = light.color.r, g = light.color.g, b = light.color.b, a= light.color.a - 0.001}
					end
					game.print("light.color.a = "..light.color.a)
				end

				if lightglow ~= nil and lightglow.valid and lightglow.color ~= nil and lightglow.color.a ~= nil then
					if lightglow.color.a < 0.01 then
						lightglow.color = {r = 0, g = 0, b = 0, a = 0}
					else
						lightglow.color = {r = lightglow.color.r, g = lightglow.color.g, b = lightglow.color.b, a= lightglow.color.a - 0.001}
					end
					game.print("lightglow.color.a = "..lightglow.color.a)
				end

				if surface ~= nil and surface.valid and surface.color ~= nil and surface.color.a ~= nil then
					if surface.color.a < 0.01 then
						surface.color = {r = 0, g = 0, b = 0, a = 0}
					else
						surface.color = {r = surface.color.r, g = surface.color.g, b = surface.color.b, a= surface.color.a - 0.001}
					end
					game.print("surface.color.a = "..surface.color.a)
				end

				if objects ~= nil and objects.valid and objects.color ~= nil and objects.color.a ~= nil then
					if objects.color.a < 0.01 then
						objects.color = {r = 0, g = 0, b = 0, a = 0}
					else
						objects.color = {r = objects.color.r, g = objects.color.g, b = objects.color.b, a= objects.color.a - 0.001}
					end
					game.print("objects.color.a = "..objects.color.a)
				end

				if center ~= nil and center.valid and center.color ~= nil and center.color.a ~= nil then
					if center.color.a < 0.01 then
						center.color = {r = 0, g = 0, b = 0, a = 0}
					else
						center.color = {r = center.color.r, g = center.color.g, b = center.color.b, a= center.color.a - 0.001}
					end
					game.print("center.color.a = "..center.color.a)
				end

				if surface.valid and surface.color.a <= 0.01 and objects.color.a <= 0.01 and center.color.a <= 0.01 and light.color.a <= 0.01 and lightglow.color.a <= 0.01 then
					storage.TN_lightEffects[i] = nil
					game.print("delete")
				end
			end
		end
	end
end

--this useless fucking function is broken and doesn't do anything but generate errors.
function everyTick(event)	
	if storage.TN_lightEffects == nil then
		storage.TN_lightEffects = {}
	end
	if storage.TN_lightEffects ~= nil then
		for i, effects in pairs(storage.TN_lightEffects) do
			effects.ttl = effects.ttl - 1
			if effects.ttl <= 0 then 
				storage.TN_lightEffects[i] = nil
			else
				local maxDur = effects.maxDur
				if effects.ids.flash ~= nil then
					local fs = 0
					local ftProgress = 0
					
					local flashBase = effects.ids.flashBase
					local flash = effects.ids.flash
					
					if flashBase.valid and (maxDur - effects.ttl) < effects.flashDuration then
						fs = ((maxDur - effects.ttl) / effects.flashDuration) * effects.flashMaxScale
						
						flashBase.scale = fs
						flash.x_scale = fs
						flash.y_scale = fs
						
					elseif flashBase.valid and (maxDur - effects.ttl) < effects.flashTransition then
						fs = effects.flashMaxScale - ((effects.flashMaxScale - effects.flashTransitionScale) / (effects.flashTransition - effects.flashDuration)) * (maxDur - effects.ttl - effects.flashDuration)
						ftProgress = (effects.flashMaxScale - fs) / effects.flashTransitionScale
						
						flash.x_scale = fs
						flash.y_scale = fs
						flashBase.scale = math.max(1 - ftProgress, 0.001)
						
						if (maxDur - effects.ttl) < effects.flashTransitionStartFadeOut then
							local fctProgress = (maxDur - effects.ttl - effects.flashDuration) / (effects.flashTransitionStartFadeOut - effects.flashDuration) 
							
							local currentColor = flash.color
							
							flash.color = {currentColor.r + effects.flashTransitionColorStep[1], currentColor.g + effects.flashTransitionColorStep[2], currentColor.b + effects.flashTransitionColorStep[3], currentColor.a + effects.flashTransitionColorStep[4]}
						else
							local ffaProgress = 1 - ((maxDur - effects.ttl - effects.flashTransitionStartFadeOut) / (effects.flashTransition - effects.flashTransitionStartFadeOut))
							
							flash.color = {effects.flashTransitionColorEnd[1] * ffaProgress, effects.flashTransitionColorEnd[2] * ffaProgress, effects.flashTransitionColorEnd[3] * ffaProgress, effects.flashTransitionColorEnd[4] * ffaProgress}
						end
					end
				end
				
				local p0 = math.min(math.max(0, (effects.ttl - 100)) / 400, 1)
				local p02 = math.min(math.max(0, (effects.ttl - 200)) / 300, 1)
				local p03 = math.min(math.max(0, (effects.ttl - 200)) / 300, 1)
				local p1 = math.min(effects.ttl / 400, 1)
				local p2 = math.min(effects.ttl / 300, 1)
				local p3 = math.min(effects.ttl / 240, 1)
				local p4 = math.min(effects.ttl / 180, 1)
				local a1 = math.max((maxDur - effects.ttl) / 250, 1)
				local a2 = math.min((maxDur - effects.ttl) / 120, 1)
				local a3 = math.min((maxDur / effects.ttl) * 5, 2)
				
				
				local glow = effects.ids.glow
				local light = effects.ids.light
				local surface = effects.ids.surface
				local objects = effects.ids.objects
				local center = effects.ids.center

				if glow.valid and light.valid and surface.valid and objects.valid and center.valid then
				
					glow.intensity = p2 * 0.4
					light.intensity = a1 * p3 * 1
					light.scale = a3 * p3 * 20 * effects.light_scale
					light.color = {1, math.min(a3/2 * p4, 1), math.min(a3/2 * p4, 1), 1}
					
					surface.color = {p02 * 0.75, p02 * 0.65, p02 * 0.6, p02 * 0.2}
					surface.x_scale = p1 * 20 * effects.light_scale
					surface.y_scale = p1 * 17 * effects.light_scale
					
					objects.color = {p02 * 1, p02 * 0.9, p02 * 0.5, p02 * 0.4}
					objects.x_scale = p2 * 25 * effects.light_scale
					objects.y_scale = p2 * 21.5 * effects.light_scale
					
					center.color = {p03 * a2 * 1, p03 * a2 * 0.3, p03 * a2 * 0.1, p03 * a2 * 0.4}
					center.x_scale = p1 * 10 * effects.light_scale
					center.y_scale = p1 * 8 * effects.light_scale
				end
			end
		end
	end
end
return {createBlastSoundsAndFlash, everyTick}
