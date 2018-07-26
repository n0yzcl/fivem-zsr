-- CONFIG --

local spawnWithFlashlight = true
local displayRadar = true
local bool = true

zombiekillsthislife = 0
playerkillsthislife = 0
zombiekills = 0
playerkills = 0

local smallToxicZones = {
	{x=-204.66, y=-1089.95, z=22.88},
}

local largeToxicZones = {
	{x= 3549.72, y= 3656.18, z= 28.12},
}

-- CODE --


-- Toxic Zone Main Code
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		for k,v in ipairs(smallToxicZones) do
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			health = GetEntityHealth(PlayerPedId())
			if(Vdist(playerX, playerY, playerZ, v.x, v.y, v.z) < 25.0) then
				DecorSetFloat(PlayerPedId(), "illness", DecorGetFloat(PlayerPedId(), "illness") + 1)
				Citizen.Wait(10000)
			end
		end
		
		for k,v in ipairs(largeToxicZones) do
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			health = GetEntityHealth(PlayerPedId())
			if(Vdist(playerX, playerY, playerZ, v.x, v.y, v.z) < 50.0) then
				DecorSetFloat(PlayerPedId(), "illness", DecorGetFloat(PlayerPedId(), "illness") + 1)
				Citizen.Wait(5000)
			end
		end
	end
end)

-- Toxic Zone Help Text Code
Citizen.CreateThread(function()
	for _, map in pairs(smallToxicZones) do
		map.blip = AddBlipForCoord(map.x, map.y, map.z)
		SetBlipSprite(map.blip, 303)
		SetBlipAsShortRange(map.blip, true)
		SetBlipAlpha(map.blip, 255)
		SetBlipColour(map.blip, 1)
		SetBlipScale(map.blip, 0.99)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Small Toxic Zone")
		EndTextCommandSetBlipName(map.blip)
	end
	for _, map in pairs(largeToxicZones) do
		map.blip = AddBlipForCoord(map.x, map.y, map.z)
		SetBlipSprite(map.blip, 303)
		SetBlipAsShortRange(map.blip, true)
		SetBlipAlpha(map.blip, 255)
		SetBlipColour(map.blip, 1)
		SetBlipScale(map.blip, 0.99)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Large Toxic Zone")
		EndTextCommandSetBlipName(map.blip)
	end
	while true do
		Citizen.Wait(1)
		
		for k,v in ipairs(smallToxicZones) do
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			health = GetEntityHealth(PlayerPedId())
			if(Vdist(playerX, playerY, playerZ, v.x, v.y, v.z) < 10.0) then
				ShowNotification("You have entered a small toxic area.")
			end
		end
		for k,v in ipairs(largeToxicZones) do
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			health = GetEntityHealth(PlayerPedId())
			if(Vdist(playerX, playerY, playerZ, v.x, v.y, v.z) < 50.0) then
				ShowNotification("You have entered a large toxic area.")
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if bool then
			TriggerServerEvent("Z:newplayer", PlayerId())
			TriggerServerEvent("Z:newplayerID", GetPlayerServerId(PlayerId()))
			bool = false
			SetBlackout(true)
		end
	end
end)

local welcomed = false
DecorRegister("hunger",1)
DecorRegister("thirst",1)
DecorRegister("infection",1)
DecorRegister("illness",1)

Citizen.CreateThread(function()
	AddEventHandler('baseevents:onPlayerKilled', function(killerId)
    local player = NetworkGetPlayerIndexFromPed(PlayerPedId())
    local attacker = killerId

		if GetPlayerFromServerId(attacker) and attacker ~= GetPlayerServerId(PlayerId()) then

			-- this is concept code for the "dropping loot when dying", no idea if it works, needs testing, hence, it hasn't been implemented yet
			-- NEEDS MUTLI ITEM PICKUP SUPPORT
			--[[
			for item,Consumable in ipairs(consumableItems) do
				if consumableItems.count[item] > 0.0 then
					local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), not IsEntityDead(PlayerPedId()) ))
					ForceCreateFoodPickupAtCoord(playerX + 1, playerY, playerZ, item, consumableItems.count[item])
				end
			end
			--]]
		end
		playerkillsthislife = 0
		zombiekillsthislife = 0
		--initiateSave(true)
		if possessed then
			unPossessPlayer(PlayerPedId())
			possessed = false
		end
	end)

	AddEventHandler('baseevents:onPlayerWasted', function()
		playerkillsthislife = 0
		zombiekillsthislife = 0
		--initiateSave(true)
		if possessed then
			unPossessPlayer(PlayerPedId())
			possessed = false
		end
	end)

	AddEventHandler('baseevents:onPlayerDied', function()
		playerkillsthislife = 0
		zombiekillsthislife = 0
		--initiateSave(true)
		if possessed then
			unPossessPlayer(PlayerPedId())
			possessed = false
		end
	end)
end)

Citizen.CreateThread(function()
	AddEventHandler("playerSpawned", function(spawn,pid)
		if spawnWithFlashlight then
			--[[for i,Consumable in ipairs(consumableItems) do
				consumableItems.count[i] = 0.0
			end--]]
			GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 1, false, false)
			GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"), 1, false, false)
			GiveWeaponToPed(PlayerPedId(), 0xFBAB5776, true)
			GiveWeaponComponentToPed(PlayerPedId(), 0x05FC3C11, 0xA73D4664)
			DecorSetFloat(PlayerPedId(), "hunger", 100.0)
			DecorSetFloat(PlayerPedId(), "thirst", 100.0)
			DecorSetFloat(PlayerPedId(), "infection", 0.0)
			DecorSetFloat(PlayerPedId(), "illness", 0.0)
			playerkillsthislife = 0
			zombiekillsthislife = 0
			infected = false
			hitCount = 0
			consumableItems.count[1] = 1.0
			consumableItems.count[2] = 1.0
			StatSetInt("MP0_STAMINA", 40,1)

			-- this is debug code
			--[[
			spawnindex=0
			for i,Consumable in ipairs(consumableItems) do
				spawnindex=spawnindex+1
				consumableItems.count[spawnindex] = 99.0
				DecorSetFloat(PlayerPedId(), Consumable, 99.0)
			end
			]]

			SetPedDropsWeaponsWhenDead(PlayerPedId(),true)
			NetworkSetFriendlyFireOption(true)
			SetCanAttackFriendly(PlayerPedId(), true, true)
			TriggerEvent('showNotification', "Press 'M' to open your Interaction Menu!")
			Wait(5000)
			if pid == PlayerId() then
				initiateSave(true)
			end
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if GetEntityHeightAboveGround(PlayerPedId()) < 80 and IsPedInParachuteFreeFall(PlayerPedId()) then
			ForcePedToOpenParachute(PlayerPedId())
		end
	end
end)

-- Slows down the firing rate
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsPedArmed(GetPlayerPed(-1), 6) and not IsPedInAnyVehicle(PlayerPedId(), false) then
			DisablePlayerFiring(PlayerId(), true)
			Citizen.Wait(25)
		end
	end
end)

-- Water Sources Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		thirst = DecorGetFloat(PlayerPedId(), "thirst")
		illness = DecorGetFloat(PlayerPedId(),"illness")
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			if not IsPedSwimming(PlayerPedId()) then
				if IsEntityInWater(PlayerPedId()) then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to drink the water.")
					if IsControlJustReleased(1, 51) then -- E key
						if thirst < 50 then
							TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BUM_WASH", 1, true)
							Citizen.Wait(5000)
							DecorSetFloat(PlayerPedId(), "thirst", thirst + 8)
							DecorSetFloat(PlayerPedId(), "illness", illness + 5)
							ClearPedTasksImmediately(PlayerPedId())
							ShowNotification("You drank some dirty water.")
						elseif thirst > 50 then
							ShowNotification("You are not thirsty enough to drink dirty water.")
						end
					end
				end
			end
		end
	end
end)

-- Vehicle Natives
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
		anycarX, anycarY, anycarZ = table.unpack(GetEntityCoords(vehicle, false))
		dirX, dirY, dirZ = table.unpack(GetEntityForwardVector(vehicle))
		--dirX, dirY, dirZ = table.unpack(GetEntityForwardY(vehicle))
	
		SetVehicleEngineCanDegrade(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, true)
		
		if GetIsVehicleEngineRunning(vehicle) then
			DrawSpotLight(anycarX, anycarY, anycarZ, dirX, dirY, dirZ, 255, 255, 255, 75.0, 0.5, 1.0, 25.0, 0.95)
		end
	end
end)

-- Main misc natives for each player or client
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		SetFarShadowsSuppressed(true)
		--FreezeEntityPosition(GetPlayerPed(-1), false)
		SetPlayerMeleeWeaponDamageModifier(PlayerId(), 5.00)
		SetPedCanBeDraggedOut(PlayerPedId(), false)
		
		ModifyWater(920, 3912, 1000, 5)
		SetCurrentIntensity(2.0)
		RemoveCurrentRise(1)
		--SetTimeScale(0.95)
		--RestorePlayerStamina(playerID, 1.0)
		if IsEntityDead(GetPlayerPed(-1)) then
			RemoveAllPedWeapons(GetPlayerPed(-1), true)
		end
	end
end)

-- Infection And Illness System
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		illness = DecorGetFloat(PlayerPedId(),"illness")
		infection = DecorGetFloat(PlayerPedId(),"infection")
		
		if infection > 99 then
			ShowNotification("You are dying from infection.")
			SetEntityHealth(PlayerPedId(), health - 1)
			SetPedSweat(PlayerPedId(), 100)
			SetPlayerSprint(PlayerId(), false)
			Citizen.Wait(1000)
		end
		
		if infection > 75 then
			ShowNotification("You are running a fever.")
			SetPedSweat(PlayerPedId(), 100)
			SetPlayerSprint(PlayerId(), false)
			ShakeGameplayCam("DRUNK_SHAKE", 1.0)
		end
		
		if infection > 0 then
			ShowNotification("You are infected. To extend your life, find and use Z-Pills.")
		end
		
		if illness > 99 then
			SetEntityHealth(PlayerPedId(), -100)
			ShowNotification("You died from severe illness.")
		end
		
		-- Start dropping players health when he gets very sick and also make him run a fever and puke
		if illness > 75 then
			ShowNotification("You are getting very sick and you are running a fever.")
			SetPedSweat(PlayerPedId(), 100)
			SetPlayerSprint(PlayerId(), false)
			SetEntityHealth(PlayerPedId(), health - 1)
			Citizen.Wait(5000)
		end
		
		if illness > 0 then
			DecorSetFloat(PlayerPedId(), "illness", illness-1)
			Citizen.Wait(30000)
		end
		
		if illness < 0 then
			DecorSetFloat(PlayerPedId(), "illness", 0)
		end
	end
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end