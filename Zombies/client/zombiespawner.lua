-- CONFIG --

-- Zombies have a 1 in 150 chance to spawn with guns
-- It will choose a gun in this list when it happens
-- Weapon list here: https://www.se7ensins.com/forums/threads/weapon-and-explosion-hashes-list.1045035/


local pedModels = {
	"A_M_M_Hillbilly_02",
	"U_M_Y_Zombie_01",
	"u_f_m_corpse_01",
	"a_m_y_vindouche_01",
	"s_m_m_scientist_01",
	"s_m_y_swat_01",
}

local loot = {
	"WEAPON_PISTOL",
	"WEAPON_MG",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_SNIPERRIFLE",
	"WEAPON_MACHETE",
	"WEAPON_CROWBAR",
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_COMBATMG",
	"WEAPON_BAT",
	"WEAPON_HATCHET",
	"WEAPON_CARBINERIFLE",
}

local walkStyles = {
	"move_m@drunk@verydrunk",
	"move_m@drunk@moderatedrunk",
	"move_m@drunk@a",
	"anim_group_move_ballistic",
	"move_lester_CaneUp",
}

-- CODE --

-- Spawn Settings
local maxZombies = 15
local maxSpawnradius = 200
local minSpawnDistance = 35
local despawnDistance = 225

-- Misc variables
--playingsound = false
--spawned = false
infected = false
hasBeenHit = false
hasNotBeenHit = true
experienceEarned = false
--zombieCountAdd = false
fingerCount = 0
zombieCount = 0
hitCount = 0

players = {}

RegisterNetEvent("Z:playerUpdate")
AddEventHandler("Z:playerUpdate", function(mPlayers)
	players = mPlayers
end)

peds = {}

Citizen.CreateThread(function()
	AddRelationshipGroup("zombeez")
	SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("looters"))
	SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("zombeez"))

	SetAiMeleeWeaponDamageModifier(1.0)

	while true do
		Wait(1)
		if #peds < maxZombies then
			x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

			choosenPed = pedModels[math.random(1, #pedModels)]
			choosenPed = string.upper(choosenPed)
			RequestModel(GetHashKey(choosenPed))
			while not HasModelLoaded(GetHashKey(choosenPed)) or not HasCollisionForModelLoaded(GetHashKey(choosenPed)) do
				Wait(1)
			end

			local newX = x
			local newY = y
			local newZ = z + 999.0

			repeat
				Wait(1)

				newX = x + math.random(-maxSpawnradius, maxSpawnradius)
				newY = y + math.random(-maxSpawnradius , maxSpawnradius)
				_,newZ = GetGroundZFor_3dCoord(newX+.0,newY+.0,z, 1)

				for _, player in pairs(players) do
					Wait(1)
					playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					if newX > playerX - minSpawnDistance and newX < playerX + minSpawnDistance or newY > playerY - minSpawnDistance and newY < playerY + minSpawnDistance then
						canSpawn = false
						break
					else
						canSpawn = true
					end
				end
			until canSpawn

			ped = CreatePed(4, GetHashKey(choosenPed), newX, newY, newZ, 0.0, true, true)
			SetPedArmour(ped, 100)
			SetPedAccuracy(ped, 25)
			SetPedSeeingRange(ped, 10.0)
			SetPedHearingRange(ped, 1000.0)

			SetPedFleeAttributes(ped, 0, 0)
			SetPedCombatAttributes(ped, 16, 1)
			SetPedCombatAttributes(ped, 17, 0)
			SetPedCombatAttributes(ped, 46, 1)
			SetPedCombatAttributes(ped, 1424, 0)
			SetPedCombatAttributes(ped, 5, 1)
			SetPedCombatRange(ped,2)
			SetPedAlertness(ped,3)
			SetAmbientVoiceName(ped, "ALIENS")
			SetPedEnableWeaponBlocking(ped, true)
			SetPedRelationshipGroupHash(ped, GetHashKey("zombeez"))
			DisablePedPainAudio(ped, true)
			SetPedDiesInWater(ped, false)
			SetPedDiesWhenInjured(ped, false)
			--	PlaceObjectOnGroundProperly(ped)
			SetPedDiesInstantlyInWater(ped,true)
			SetPedIsDrunk(ped, true)
			SetPedConfigFlag(ped,100,1)
			ApplyPedDamagePack(ped,"BigHitByVehicle", 0.0, 9.0)
			ApplyPedDamagePack(ped,"SCR_Dumpster", 0.0, 9.0)
			ApplyPedDamagePack(ped,"SCR_Torture", 0.0, 9.0)
			StopPedSpeaking(ped,true)

			walkStyle = walkStyles[math.random(1, #walkStyles)]
				
			RequestAnimSet(walkStyle)
			while not HasAnimSetLoaded(walkStyle) do
				Citizen.Wait(1)
			end
			
			SetPedMovementClipset(ped, walkStyle, 1.0)
			TaskWanderStandard(ped, 1.0, 10)
			local pspeed = math.random(20,70)
			local pspeed = pspeed/10
			local pspeed = pspeed+0.01
			SetEntityMaxSpeed(ped, 5.0)

			if not NetworkGetEntityIsNetworked(ped) then
				NetworkRegisterEntityAsNetworked(ped)
			end

			table.insert(peds, ped)
		end

		for i, ped in pairs(peds) do
			if DoesEntityExist(ped) == false then
				table.remove(peds, i)
			end
				
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			pedX, pedY, pedZ = table.unpack(GetEntityCoords(ped, true))
			-- Delete far away unlooted dead zombies after 60 seconds
			if IsPedDeadOrDying(ped, 1) == 1 then
				if(Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) > 75.0)then
					-- Set ped as no longer needed for despawning
					--local dropChance = math.random(0,100)
					--Citizen.Trace("Delete unlooted dead Zombie")
					--RemoveBlip(blip)
					local model = GetEntityModel(ped)
					SetEntityAsNoLongerNeeded(ped)
					SetModelAsNoLongerNeeded(model)
					--DeleteEntity(ped)
					table.remove(peds, i)
				end			
			else
				playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				SetPedArmour(ped, 100)
				SetPedAccuracy(ped, 25)
				SetPedSeeingRange(ped, 10.0)
				SetPedHearingRange(ped, 1000.0)

				SetPedFleeAttributes(ped, 0, 0)
				SetPedCombatAttributes(ped, 16, 1)
				SetPedCombatAttributes(ped, 17, 0)
				SetPedCombatAttributes(ped, 46, 1)
				SetPedCombatAttributes(ped, 1424, 0)
				SetPedCombatAttributes(ped, 5, 1)
				SetPedCombatRange(ped,2)
				SetAmbientVoiceName(ped, "ALIENS")
				SetPedEnableWeaponBlocking(ped, true)
				SetPedRelationshipGroupHash(ped, GetHashKey("zombeez"))
				DisablePedPainAudio(ped, true)
				SetPedDiesInWater(ped, false)
				SetPedDiesWhenInjured(ped, false)
				
				if pedX < playerX - despawnDistance or pedX > playerX + despawnDistance or pedY < playerY - despawnDistance or pedY > playerY + despawnDistance then
					-- Set ped as no longer needed for despawning
					local model = GetEntityModel(ped)
					SetEntityAsNoLongerNeeded(ped)
					SetModelAsNoLongerNeeded(model)
					table.remove(peds, i)
				end
			end
		end
	end
end)

-- Handles all the other shit
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for i, ped in pairs(peds) do
			-- Gets the player infected when a zombie attacks them
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			pedX, pedY, pedZ = table.unpack(GetEntityCoords(ped, true))
			infection = DecorGetFloat(PlayerPedId(),"infection")
			if(Vdist(pedX, pedY, pedZ, playerX, playerY, playerZ) < 2.0)then
				if IsPedInMeleeCombat(ped) then
					if HasEntityBeenDamagedByEntity(PlayerPedId(), ped, 1) then
						Citizen.Trace("Player has been hit by zombie.")
						hitCount = hitCount + 1
						hasBeenHit = true
					end
				end
			end
				
			if hitCount > 2 then
				infected = true
			end
				
			if infected == false then
				DecorSetFloat(PlayerPedId(),"infection", 0)
			end
				
			if infected == true then
				DecorSetFloat(PlayerPedId(),"infection", infection + 1)
				Citizen.Wait(15000)
			end
			
			-- Finish guard missions Zombie killing
			if zombieCount > 9 then
				killedZombies = true
				guardMission = false
				ShowNotification("Return to the guard.")
			end
				
			-- Return collected fingers to Jason
			if fingerCount > 4 then
				hasFingers = true
				jasonMission = false
				ShowNotification("You have all the fingers Jason wants, return them to him.")
			end
			
			-- Increase Zombie Count for Guard Mission
			if guardMission == true then
				if IsPedDeadOrDying(ped, 1) == 1 then
					if GetPedSourceOfDeath(ped) == PlayerPedId() then
						zombieCount = zombieCount + 1
						local model = GetEntityModel(ped)
						SetEntityAsNoLongerNeeded(ped)
						SetModelAsNoLongerNeeded(model)
						table.remove(peds, i)
						zombieCountAdd = true
					end
				end
			end
			
			if IsPedDeadOrDying(ped, 1) == 1 then
				playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				pedX, pedY, pedZ = table.unpack(GetEntityCoords(ped, true))	
				if not IsPedInAnyVehicle(PlayerPedId(), false) then
					if(Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) < 3.0)then
						DisplayHelpText("Press ~INPUT_CONTEXT~ to loot zombie.")
						if IsControlJustReleased(1, 51) then -- E key
							if DoesEntityExist(GetPlayerPed(-1)) then
								RequestAnimDict("pickup_object")
								while not HasAnimDictLoaded("pickup_object") do
								Citizen.Wait(1)
								end
								TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8, -1, 49, 0, 0, 0, 0)
								experience = DecorGetFloat(PlayerPedId(), "experience")
								
								if jasonMission == true then
									fingerCount = fingerCount + 1
									Citizen.Trace("Finger collected")
								end
									
								randomChance = math.random(1, 100)
								randomLoot = loot[math.random(1, #loot)]
								DecorSetFloat(PlayerPedId(), "experience", experience + 10)
								Citizen.Wait(2000)
								if randomChance > 0 and randomChance < 20 then
									GiveWeaponToPed(PlayerPedId(), randomLoot, 8, true, false)
									ShowNotification("You found " .. randomLoot)
								elseif randomChance >= 20 and randomChance < 40 then
									randomCredits = math.random(2, 15)
									zCredits = zCredits + randomCredits
									ShowNotification("You found " .. randomCredits.. " Zombie Credits")
								elseif randomChance >= 40 and randomChance < 60 then
									zBlood = zBlood + 1
									ShowNotification("You found Zombie blood")
								elseif randomChance >= 60 and randomChance < 80 then
									randomLogs = math.random(1, 5)
									woodLogs = woodLogs + randomLogs
									ShowNotification("You found " ..randomLogs.. " wood logs")
								elseif randomChance >= 80 and randomChance < 100 then
									ShowNotification("You found nothing.")
								end
								ClearPedSecondaryTask(GetPlayerPed(-1))
								--RemoveBlip(blip)
								local model = GetEntityModel(ped)
								SetEntityAsNoLongerNeeded(ped)
								SetModelAsNoLongerNeeded(model)
								--DeleteEntity(ped)
								table.remove(peds, i)
							end
						end
					end
				end
			end
			
			-- Makes zombies ragdoll in vehicle
			if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
				SetPedCanRagdoll(ped, true)
			elseif not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
				SetPedCanRagdoll(ped, false)
			end
		end
	end
end)

RegisterNetEvent("Z:cleanup")
AddEventHandler("Z:cleanup", function()
	for i, ped in pairs(peds) do
		-- Set ped as no longer needed for despawning
		local model = GetEntityModel(ped)
		SetEntityAsNoLongerNeeded(ped)
		SetModelAsNoLongerNeeded(model)

		table.remove(peds, i)
	end
end)
