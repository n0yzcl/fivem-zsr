-- CONFIG --

-- Zombies have a 1 in 150 chance to spawn with guns
-- It will choose a gun in this list when it happens
-- Weapon list here: https://www.se7ensins.com/forums/threads/weapon-and-explosion-hashes-list.1045035/


local pedModels = {
	"ig_orleans",
}

local greenZones = {
	{name="Junkyard Base", x= 2384.00, y= 3090.00, z= 48.00},
	{name="Grapeseed Base", x= 2447.10, y= 4977.18, z= 46.82},
	{name="NRF Base", x= -1116.87, y= 4925.92, z= 218.23},
	{name="City Spawn", x= 142.73, y= -1076.33, z= 29.19},
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
-- Determines how many Zombies there can be per client
local maxSuperZombies = 5
-- Determines how far zombies have to be from player to despawn
local despawnDistance = 1000
-- Determines how far away from the player until zombies can spawn
local minSpawnDistance = 50
-- Determines the maximum spawn radius zombies can spawn around the player
local maxSpawnRadius = 1000

--local volume = 0.0

local sounds = {
	"groans/groan.ogg",
	"groans/groan1.ogg",
	"groans/groan2.ogg",
	"groans/groan3.ogg",
	"groans/groan4.ogg",
	"groans/groan5.ogg",
	"groans/groan6.ogg",
	"groans/lowgroan.ogg",
	"groans/lowgroan2.ogg",
}

-- CODE --

players = {}

RegisterNetEvent("Z:playerUpdate")
AddEventHandler("Z:playerUpdate", function(mPlayers)
	players = mPlayers
end)

TriggerServerEvent("registerNewZombie")

superzombies = {}


Citizen.Trace("Start Super Zombie thread")
Citizen.CreateThread(function()
	RegisterNetEvent("ZombieSync")
	AddEventHandler("ZombieSync", function()
		while true do
			Citizen.Wait(1)
			
			AddRelationshipGroup("zombeez")
			SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("PLAYER"))
			SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("looters"))
			SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("badanimals"))
			SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("animals"))
			SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("friends"))
			SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("ngf"))
			SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("zombeez"))
			
			if #superzombies < maxSuperZombies then
				x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

				choosenPed = pedModels[math.random(1, #pedModels)]
				choosenPed = string.upper(choosenPed)
				RequestModel(GetHashKey(choosenPed))
				while not HasModelLoaded(GetHashKey(choosenPed)) or not HasCollisionForModelLoaded(GetHashKey(choosenPed)) do
					Citizen.Wait(100)
				end

				local newX = x
				local newY = y
				local newZ = z + 999.0

				repeat
					Citizen.Wait(1)

					newX = x + math.random(-maxSpawnRadius, maxSpawnRadius)
					newY = y + math.random(-maxSpawnRadius, maxSpawnRadius)
					_,newZ = GetGroundZFor_3dCoord(newX+.0,newY+.0,z, 1)

					for _, player in pairs(players) do
						Citizen.Wait(1)
						playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
						if newX > playerX - minSpawnDistance and newX < playerX + minSpawnDistance or newY > playerY - minSpawnDistance and newY < playerY + minSpawnDistance then
							canSpawn = false
							break
						else
							canSpawn = true
						end
					end
				until canSpawn
				
				Citizen.Trace("Super Zombie spawning")
				superzombie = CreatePed(4, GetHashKey(choosenPed), newX, newY, newZ, 0.0, true, true)
				
				SetPedArmour(superzombie, 100)
				SetPedAccuracy(superzombie, 25)
				SetEntityHealth(superzombie, 1000)
				SetEntityMaxHealth(superzombie, 1000)
				SetPedPathCanUseClimbovers(superzombie, false)
				SetPedPathCanUseLadders(superzombie, false)
				SetPedPathAvoidFire(superzombie, false)
				SetPedPathCanDropFromHeight(superzombie, true)
				
				AddRelationshipGroup("zombeez")
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("looters"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("badanimals"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("animals"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("friends"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("ngf"))
				SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("zombeez"))

				SetAiMeleeWeaponDamageModifier(4.0)

				SetPedFleeAttributes(superzombie, 0, 0)
				SetPedCombatAttributes(superzombie, 16, 1)
				SetPedCombatAttributes(superzombie, 17, 0)
				SetPedCombatAttributes(superzombie, 46, 1)
				SetPedCombatAttributes(superzombie, 1424, 0)
				SetPedCombatAttributes(superzombie, 5, 1)
				SetPedCombatRange(superzombie,2)
				SetPedAlertness(superzombie,3)
				SetPedTargetLossResponse(superzombie, 2)
				SetAmbientVoiceName(superzombie, "ALIENS")
				SetPedEnableWeaponBlocking(superzombie, true)
				SetPedRelationshipGroupHash(superzombie, GetHashKey("zombeez"))
				DisablePedPainAudio(superzombie, true)
				SetPedDiesInWater(superzombie, false)
				SetPedDiesWhenInjured(superzombie, false)
				--	PlaceObjectOnGroundProperly(superzombie)
				SetPedDiesInstantlyInWater(superzombie,true)
				SetPedIsDrunk(superzombie, true)
				SetPedConfigFlag(superzombie,100,1)
				
				ApplyPedDamagePack(superzombie,"BigHitByVehicle", 0.0, 9.0)
				ApplyPedDamagePack(superzombie,"SCR_Dumpster", 0.0, 9.0)
				ApplyPedDamagePack(superzombie,"SCR_Torture", 0.0, 9.0)
				StopPedSpeaking(superzombie,true)
				
				blip = AddBlipForEntity(superzombie)
				SetBlipSprite(blip, 84)
				SetBlipAsShortRange(blip, true)

				TaskWanderStandard(superzombie, 1.0, 10)
					
				-- Network Natives
				NetworkRegisterEntityAsNetworked(superzombie)
				SetEntityAsMissionEntity(superzombie, true)
				
				table.insert(superzombies, superzombie)
				Citizen.Wait(2500)
			end
			
			-- Changed Zombie senses on crouched players
			if crouched then
				SetPedSeeingRange(superzombie, 4.0)
				SetPedHearingRange(superzombie, 1500.0)
			else
				SetPedSeeingRange(superzombie, 30.0)
				SetPedHearingRange(superzombie, 3000.0)
			end
				

			for i, superzombie in pairs(superzombies) do
				if DoesEntityExist(superzombie) == false then
					table.remove(superzombies, i)
				end
				playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				pedX, pedY, pedZ = table.unpack(GetEntityCoords(superzombie, true))
				if IsPedDeadOrDying(superzombie, 1) == 1 then
					volume = 0.0
					-- Set superzombie as no longer needed for despawning
					--local dropChance = math.random(0,100)
					playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					pedX, pedY, pedZ = table.unpack(GetEntityCoords(superzombie, true))
							if(Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) < 3.0)then
								DisplayHelpText("Press ~INPUT_CONTEXT~ to loot zombie.")
								if IsControlJustReleased(1, 51) then -- E key
									if DoesEntityExist(GetPlayerPed(-1)) then
										RequestAnimDict("pickup_object")
										while not HasAnimDictLoaded("pickup_object") do
										Citizen.Wait(1)
										end
										TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8, -1, 49, 0, 0, 0, 0)
										GiveWeaponToPed(PlayerPedId(), loot[math.random(1, #loot)], 8, true, false)
										Citizen.Wait(2000)
										ClearPedSecondaryTask(GetPlayerPed(-1))
										RemoveBlip(blip)
										SetEntityAsNoLongerNeeded(superzombie)
										DeleteEntity(superzombie)
										table.remove(peds, i)
									end
								end
							end

					--Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(ped))
					--table.remove(peds, i)
				else
					playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					pedX, pedY, pedZ = table.unpack(GetEntityCoords(superzombie, true))
					
					-- Alert Zombie Voices
					distance1 = Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) < 30
					if distance1 then
						volume = 0.5
						if IsPedInMeleeCombat(superzombie) then
							PlayAlertVoice()
							Citizen.Wait(10000)
						end
					end
					
					-- Normal Zombie Voices
					--[[distance2 = Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) < 15
					if distance2 then
						volume = 0.5
						if not IsPedInMeleeCombat(superzombie) then
							PlayNormalVoices()
							Citizen.Wait(4000)
						end
					end--]]
					
					
					
					playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					SetPedArmour(superzombie, 100)
					SetPedAccuracy(superzombie, 25)

					SetPedFleeAttributes(superzombie, 0, 0)
					SetPedCombatAttributes(superzombie, 16, 1)
					SetPedCombatAttributes(superzombie, 17, 0)
					SetPedCombatAttributes(superzombie, 46, 1)
					SetPedCombatAttributes(superzombie, 1424, 0)
					SetPedCombatAttributes(superzombie, 5, 1)
					SetPedCombatRange(superzombie,2)
					SetAmbientVoiceName(superzombie, "ALIENS")
					SetPedEnableWeaponBlocking(superzombie, true)
					SetPedRelationshipGroupHash(superzombie, GetHashKey("zombeez"))
					DisablePedPainAudio(superzombie, true)
					SetPedDiesInWater(superzombie, false)
					SetPedDiesWhenInjured(superzombie, false)
					
					-- Kill and delete zombies in greenzones
					for k,v in ipairs(greenZones) do
						--DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 200.0, 200.0, 10.0, 0, 255, 0,165, 0, 0, 0,0)
						if(Vdist(pedX, pedY, pedZ, v.x, v.y, v.z) < 200.0)then
							Citizen.Trace("Zombie entered greenzone")
							SetEntityHealth(superzombie, 0)
							DeleteEntity(superzombie)
							SetEntityAsNoLongerNeeded(superzombie)
							RemoveBlip(blip)
							table.remove(superzombies, i)
						end
					end
					
						
					
					-- Gets the player infected when a zombie attacks them
					playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					pedX, pedY, pedZ = table.unpack(GetEntityCoords(superzombie, true))
					infection = DecorGetFloat(PlayerPedId(),"infection")
					if(Vdist(pedX, pedY, pedZ, playerX, playerY, playerZ) < 5.0)then
						if IsPedInMeleeCombat(superzombie) then
							if HasPedBeenDamagedByWeapon(PlayerPedId(), "WEAPON_UNARMED", 0) then
								DecorSetFloat(PlayerPedId(),"infection", infection + 1)
								Citizen.Wait(30000)
							end
						end
					end
						
					
					-- Makes zombies ragdoll in vehicle but not when being shot
					if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						SetPedCanRagdoll(superzombie, true)
					elseif not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						SetPedCanRagdoll(superzombie, false)
					end
					
					if pedX < playerX - despawnDistance or pedX > playerX + despawnDistance or pedY < playerY - despawnDistance or pedY > playerY + despawnDistance then
						-- Set superzombie as no longer needed for despawning
						local model = GetEntityModel(superzombie)
						SetEntityAsNoLongerNeeded(superzombie)
						SetModelAsNoLongerNeeded(model)
						table.remove(superzombies, i)
					end
				end
			end
		end
	end)
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Sound for high growl when zombie sees target
--[[function PlayNormalVoices()
	SendNUIMessage({
		playsound = sounds[math.random(1, #sounds)],
		soundvolume = volume
	})
end--]]

-- Sound for normal zombie groan.
function PlayAlertVoice()
	SendNUIMessage({
		playsound = "groans/alerted.ogg",
		soundvolume = volume
	})
end

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
