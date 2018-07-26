local weaponsConfig = {
	"pickup_weapon_Nightstick",
	"pickup_weapon_Hammer",
	"pickup_weapon_Bat",
	"pickup_weapon_GolfClub",
	"pickup_weapon_Crowbar",
	"pickup_weapon_SwitchBlade",
	"pickup_weapon_Pistol",
	"pickup_weapon_CombatPistol",
	"pickup_weapon_APPistol",
	"pickup_weapon_Pistol50",
	"pickup_weapon_FlareGun",
	"pickup_weapon_MarksmanPistol",
	"pickup_weapon_Revolver",
	"pickup_weapon_MicroSMG",
	"pickup_weapon_SMG",
	"pickup_weapon_AssaultSMG",
	"pickup_weapon_CombatPDW",
	"pickup_weapon_AssaultRifle",
	"pickup_weapon_CarbineRifle",
	"pickup_weapon_AdvancedRifle",
	"pickup_weapon_CompactRifle",
	"pickup_weapon_MG",
	"pickup_weapon_CombatMG",
	"pickup_weapon_PumpShotgun",
	"pickup_weapon_SawnOffShotgun",
	"pickup_weapon_AssaultShotgun",
	"pickup_weapon_BullpupShotgun",
	"pickup_weapon_DoubleBarrelShotgun",
	"pickup_weapon_StunGun",
	"pickup_weapon_SniperRifle",
	"pickup_weapon_HeavySniper",
	"pickup_weapon_Grenade",
	"pickup_weapon_StickyBomb",
	"pickup_weapon_SmokeGrenade",
	"pickup_weapon_Molotov",
	"pickup_weapon_FireExtinguisher",
	"pickup_weapon_PetrolCan",
	"pickup_weapon_SNSPistol",
	"pickup_weapon_SpecialCarbine",
	"pickup_weapon_HeavyPistol",
	"pickup_weapon_BullpupRifle",
	"pickup_weapon_VintagePistol",
	"pickup_weapon_Dagger",
	"pickup_weapon_Musket",
	"pickup_weapon_MarksmanRifle",
	"pickup_weapon_HeavyShotgun",
	"pickup_weapon_Gusenberg",
	"pickup_weapon_Machete",
	"pickup_weapon_MachinePistol",
	"pickup_weapon_SweeperShotgun",
	"pickup_weapon_BattleAxe",
	"pickup_weapon_MiniSMG",
	"pickup_weapon_PipeBomb",
	"pickup_weapon_PoolCue",
	"pickup_weapon_Wrench",
	"pickup_weapon_Pistol_Mk2",
	"pickup_weapon_AssaultRifle_Mk2",
	"pickup_weapon_CarbineRifle_Mk2",
	"pickup_weapon_CombatMG_Mk2",
	"pickup_weapon_HeavySniper_Mk2",
	--"pickup_weapon_SMG_Mk2",
	"PICKUP_HEALTH_STANDARD"
}

local spawnedPickups = {}
local localPickups = {}
local localFood = 0
local localWeapons = 0
local isThreadActive = false
local threadCheckAttempts = 0

-- Function init thread
Citizen.CreateThread(function(choices, weights)
	function ForceCreateFoodPickupAtCoord(spawnPosX, spawnPosY, SpawnPosZ, Pickups, PickupCounts)
		if Pickups == nil then
			Pickups = math.random(1, #consumableItems)
			local chance = math.random(0,100)
			if chance > 80 then
				PickupCounts = math.round(math.random(1,3))+0.0
			else
				PickupCounts = 1.0
			end
		end

		local itemInfo = {
			x = spawnPosX,
			y = spawnPosY,
			z = SpawnPosZ,
			pickupItem = Pickups,
			pickupItemCount = PickupCounts,
			owner = GetPlayerServerId(PlayerId()),
			ownerName = GetPlayerName(PlayerId()),
			spawned = false
		}

		TriggerServerEvent("registerNewPickup", itemInfo)
		table.insert(localPickups, itemInfo)
	end
	function ForceCreateWeaponPickupAtLocation(spawnPosX, spawnPosY, SpawnPosZ, Pickup, AmmoCount)
		if not Pickup then
			Pickup = weaponsConfig[math.random(1, #weaponsConfig)]
			Pickup = string.upper(Pickup)
			AmmoCount = math.random(10,100)
		end

		local weaponInfo = {
			weapon = Pickup,
			x = spawnPosX,
			y = spawnPosY,
			z = SpawnPosZ,
			chance = AmmoCount,
			owner = GetPlayerServerId(PlayerId()),
			ownerName = GetPlayerName(PlayerId()),
			spawned = false
		}

		table.insert(localPickups, weaponInfo)
		TriggerServerEvent("registerNewPickup", weaponInfo)
	end
	function DeletePickup(pickup)
		if (DoesPickupObjectExist(pickup) == 1 or DoesPickupObjectExist(pickup) == true) then
			--SetEntityAsMissionEntity(pickup, true, true)
			SetEntityAsNoLongerNeeded(pickup)
			RemovePickup(pickup)
			DeleteObject(pickup)
			return true
		end
	end
end)

-- Network handlers
Citizen.CreateThread(function()
	RegisterNetEvent("createPickup")
	AddEventHandler("createPickup", function(pickup)
		pickup.spawned = false
		table.insert(spawnedPickups, pickup)
	end)

	RegisterNetEvent("removePickup")
	AddEventHandler("removePickup", function(pickupInfo)
		-- Remove the pickup...
		for i, pickup in pairs(spawnedPickups) do
			if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y and pickup.z == pickupInfo.z then
				table.remove(spawnedPickups, i)
				TriggerEvent("DeletePickup", pickup.pickup)
			end
		end

		-- Remove it if someone else picked it up...
		for i, pickup in ipairs(localPickups) do
			if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y and pickup.z == pickupInfo.z then
				table.remove(localPickups, i)
				if pickup.pickupItem ~= nil then
					localFood = localFood - 1
				else
					localWeapons = localWeapons - 1
				end
			end
		end
	end)

	RegisterNetEvent("collectPickup")
	AddEventHandler("collectPickup", function(pickupInfo) -- if the pickup has been collected and is valid
		Citizen.Trace("Collecting pickup: " .. table.tostring(pickupInfo))
		local pickupString = ""
		if type(pickupInfo.pickupItem) == "table" then
			for i, pickupData in pairs(pickupInfo.pickupData) do
				local itemCount = math.round(pickupInfo.pickupItemCount[i])
				consumableItems.count[pickupData] = consumableItems.count[pickupData] + itemCount
				pickupString = pickupString + "You Found: ~g~" .. itemCount .." " .. consumableItems[pickupData].name .. "\n"
				if itemCount > 1 then pickupString = pickupString.."s" end
			end
		else
			local itemCount = math.floor(pickupInfo.pickupItemCount)
			consumableItems.count[pickupInfo.pickupItem] = consumableItems.count[pickupInfo.pickupItem] + itemCount
			pickupString = "You Found: ~g~" .. itemCount .. " " .. consumableItems[pickupInfo.pickupItem].name
			if itemCount > 1 then pickupString = pickupString.."s" end
		end
		TriggerEvent('showNotification', pickupString)
	end)

	RegisterNetEvent("DeletePickup")
	AddEventHandler("DeletePickup", function(pickup)
		DeletePickup(pickup)
	end)

	RegisterNetEvent("createLootThread")
	AddEventHandler("createLootThread", function()
		createLootThread(true)
	end)
end)

-- Spawn items thread
Citizen.CreateThread(function()
	while loaded == true do
		Citizen.Wait(100)

		if localWeapons < 2 or localFood < 5 then
			--Citizen.Trace("Spawning pickups: Weapons: " .. localWeapons .. ", Food: " .. localFood)
			local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
			local canSpawn = false
			local spawnX = posX
			local spawnY = posY
			local spawnZ = 0

			repeat
				repeat
					posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
					Citizen.Wait(1)
					spawnX = posX + math.random(-250, 250)
					spawnY = posY + math.random(-250, 250)
					_,spawnZ = GetGroundZFor_3dCoord(spawnX+.0, spawnY+.0, 99999.0, 1)
					--Citizen.Trace("Player cords: [" .. posX .. "," .. posY .. "," .. posZ .. "]")
					--Citizen.Trace("Pickup cords: [" .. spawnX .. "," .. spawnY .. "," .. spawnZ .. "]")
				until spawnZ ~= 0

				spawnZ = spawnZ + 1

				if spawnZ >= posZ-12 and spawnZ <= posZ+12 then
					for player, _ in pairs(players) do
						local playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(player), true))
						if DistanceBetweenCoords2D(spawnX, spawnY, playerX, playerY) < 60 then
							canSpawn = false
							--Citizen.Trace("Pickup is within 60 meters of: " .. GetPlayerName(player))
							break
						else
							canSpawn = true
						end
					end
				else
					canSpawn = false
					--Citizen.Trace("Pickup height is out of limit!")
				end
			until canSpawn

			if localWeapons < 2 then
				ForceCreateWeaponPickupAtLocation(spawnX, spawnY, spawnZ)
				localWeapons = localWeapons + 1
			elseif localFood < 5 then
				ForceCreateFoodPickupAtCoord(spawnX, spawnY, spawnZ)
				localFood = localFood + 1
			end
		end
	end
end)

-- Collect pickups thread
Citizen.CreateThread(function()
	while loaded == true do
		Citizen.Wait(1)

		local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
		for i, pickupInfo in pairs(spawnedPickups) do
			if pickupInfo.spawned then
				if HasPickupBeenCollected(pickupInfo.pickup) and DistanceBetweenCoords(posX,posY,posZ,pickupInfo.x,pickupInfo.y,pickupInfo.z) < 2.5 then
					table.remove(spawnedPickups, i)
					Citizen.Trace("pickup was collected\n")

					-- No need to validate weapon pickups....
					if pickupInfo.pickupItem ~= nil then
						TriggerServerEvent("collectPickup", pickupInfo)
					else
						TriggerServerEvent("removePickup", pickupInfo, "pickup was collected\n")
					end
					break
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while loaded == true do
		Citizen.Wait(100)

		-- Light
		for i, pickupInfo in pairs(spawnedPickups) do
			if pickupInfo.spawned then
				local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
				--DrawLightWithRangeAndShadow(pickupInfo.x, pickupInfo.y, pickupInfo.z + 0.1, 255, 255, 255, 3.0, 50.0, 5.0)
			end
		end

		-- Distance
		for i, pickupInfo in pairs(localPickups) do
			local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
			if DistanceBetweenCoords(posX, posY, posZ, pickupInfo.x, pickupInfo.y, pickupInfo.z) > 300.0 then
				TriggerServerEvent("removePickup", pickupInfo, "pickup too far, deleting\n")
				Citizen.Trace("pickup too far, deleting: " .. table.tostring(pickupInfo))
				table.remove(localPickups, i)
				if pickupInfo.pickupItem ~= nil then
					localFood = localFood - 1
				else
					localWeapons = localWeapons - 1
				end
			end
		end
	end
end)

-- Creating the pickup thread
function createLootThread(crashed)
	if crashed ~= nil then
		TriggerEvent('showNotification', "Loot fixed...")
	end
	Citizen.CreateThread(function()
		while loaded == true do
			Citizen.Wait(100)
			isThreadActive = true

			local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
			for i, pickupInfo in ipairs(spawnedPickups) do
				if pickupInfo.spawned == false then
					if DistanceBetweenCoords(posX, posY, posZ, pickupInfo.x, pickupInfo.y, pickupInfo.z) < 300.0 then
						local pickup = 0
						if pickupInfo.pickupItem ~= nil then
							pickup = CreatePickupRotate(GetHashKey("PICKUP_PORTABLE_PACKAGE"), pickupInfo.x, pickupInfo.y, pickupInfo.z, 0.0, 0.0, 0.0, 8, 1, 24, 24, true, GetHashKey("PICKUP_PORTABLE_PACKAGE"))
						else
							pickup = CreatePickupRotate(pickupInfo.weapon, pickupInfo.x, pickupInfo.y, pickupInfo.z, 0.0, 0.0, 0.0, 8, pickupInfo.chance, 24, 24, true, pickupInfo.weapon)
						end
						if (DoesPickupExist(pickup) == 1 or DoesPickupExist(pickup) == true) then
							SetEntityAsMissionEntity(pickup, true, true)
							pickupInfo.pickup = pickup
							pickupInfo.spawned = true
							spawnedPickups[i] = pickupInfo
							if pickupInfo.pickupItem ~= nil then
								if type(pickupInfo.pickupItem) == "table" then
									Citizen.Trace(pickupInfo.pickup .. " Items " .. table.tostring(pickupInfo.pickupItem) .. " Spawned!")
								else
									Citizen.Trace(pickupInfo.pickup .. " Item " .. consumableItems[pickupInfo.pickupItem].name .. " Spawned!")
								end
							else
								Citizen.Trace(pickupInfo.pickup .." Weapon ".. pickupInfo.weapon .." Spawned!")
							end
						end
					end
				elseif pickupInfo.spawned == true then
					if DistanceBetweenCoords(posX, posY, posZ, pickupInfo.x, pickupInfo.y, pickupInfo.z) > 300.0 then
						TriggerEvent("DeletePickup", pickupInfo.pickup)
						pickupInfo.spawned = false
						spawnedPickups[i] = pickupInfo
						Citizen.Trace("Removed pickup")
					elseif DistanceBetweenCoords(posX, posY, posZ, pickupInfo.x, pickupInfo.y, pickupInfo.z) > 5.0 then
						if not HasPickupBeenCollected(pickupInfo.pickup) and (DoesPickupObjectExist(pickupInfo.pickup) == 0 or DoesPickupObjectExist(pickupInfo.pickup) == false) then
							pickupInfo.pickup = 0
							pickupInfo.spawned = false
							spawnedPickups[i] = pickupInfo
						end
					end
				end
			end
		end
	end)
end

Citizen.CreateThread(function()
	while loaded == true do
		Citizen.Wait(100)
		if isThreadActive then
			threadCheckAttempts = 0
			isThreadActive = false
		else
			threadCheckAttempts = threadCheckAttempts + 1
			if threadCheckAttempts >= 100 then
				threadCheckAttempts = 0
				TriggerEvent("createLootThread")
			end
		end
	end
end)

loaded = true
createLootThread()
