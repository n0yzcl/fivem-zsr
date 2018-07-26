local startingLevel = 1.0
local experience = 0
local firstSpawn = false

DecorRegister("level",1)
DecorRegister("experience",1)
DecorSetFloat(PlayerPedId(), "level", startingLevel)
DecorSetFloat(PlayerPedId(), "experience", 0)

Citizen.CreateThread(function()
		
		while true do
			Citizen.Wait(1)
			
			level = DecorGetFloat(PlayerPedId(), "level")
			if level then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.5)
				
				SetTextColour(255, 255, 255, 255)

				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("LEVEL: " .. math.round(level))
				DrawText(0.90, 0.25)
			end
			
			experience = DecorGetFloat(PlayerPedId(), "experience")
			if experience then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.5)
				
				SetTextColour(255, 255, 255, 255)

				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("EXP: " .. math.round(experience))
				DrawText(0.90, 0.30)
			end
		end
end)

-- Gives experience points to player by killing AI
--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		-- Give XP from Looter killing
		if IsPedDeadOrDying(looter, 1) == 1 then
			if GetPedSourceOfDeath(looter) == PlayerPedId() then
				randomXP = math.random(10, 20)
				experience = experience + randomXP
			end
		end
		
		-- Give XP from Bad Animal killing
		if IsPedDeadOrDying(badanimal, 1) == 1 then
			if GetPedSourceOfDeath(badanimal) == PlayerPedId() then
				randomXP = math.random(20, 40)
				experience = experience + randomXP
			end
		end
	end
end)--]]

-- Levels up the player if he gains the experience required
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if experience < 99 then
			DecorSetFloat(PlayerPedId(), "level", 1.0)
		end
		if experience > 99 then
			DecorSetFloat(PlayerPedId(), "level", 2.0)
		end
		if experience > 199 then
			DecorSetFloat(PlayerPedId(), "level", 3.0)
		end
		if experience > 399 then
			DecorSetFloat(PlayerPedId(), "level", 4.0)
		end
		if experience > 799 then
			DecorSetFloat(PlayerPedId(), "level", 5.0)
		end
		if experience > 1599 then
			DecorSetFloat(PlayerPedId(), "level", 6.0)
		end
		if experience > 3199 then
			DecorSetFloat(PlayerPedId(), "level", 7.0)
		end
		if experience > 6399 then
			DecorSetFloat(PlayerPedId(), "level", 8.0)
		end
		if experience > 12799 then
			DecorSetFloat(PlayerPedId(), "level", 9.0)
		end
		if experience > 25599 then
			DecorSetFloat(PlayerPedId(), "level", 10.0)
		end
	end
end)



function math.round(num, numDecimalPlaces)
	if numDecimalPlaces and numDecimalPlaces>0 then
		local mult = 10^numDecimalPlaces
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

function round(a,b)
	math.round(a,b)

end