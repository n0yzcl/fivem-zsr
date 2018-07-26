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

local walkStyles = {
	"move_m@drunk@verydrunk",
	"move_m@drunk@moderatedrunk",
	"move_m@drunk@a",
	"anim_group_move_ballistic",
	"move_lester_CaneUp",
}

local greenZones = {
	{name="Junkyard Base", x= 2384.00, y= 3090.00, z= 48.00},
	{name="Grapeseed Base", x= 2447.10, y= 4977.18, z= 46.82},
	{name="NRF Base", x= -1116.87, y= 4925.92, z= 218.23},
	{name="City Spawn", x= 142.73, y= -1076.33, z= 29.19},
	{name="Undead MC Faction", x= 61.86, y= 3691.09, z= 39.83},
	{name="Bandit Faction Base", x= 2650.86, y= 3512.87, z= 53.25},
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

playingsound = false
spawned = false
infected = false
hasBeenHit = false
hasNotBeenHit = true
experienceEarned = false
fingerCount = 0
zombieCount = 0
hitCount = 0

local zombieCountAdd = false
experience = DecorGetFloat(PlayerPedId(), "experience")

-- Determines how many zombies can spawn per client
local maxZombies = 10
-- Determines how far zombies have to be from player to despawn
local despawnDistance = 250
-- Determines how far away from the player until zombies can spawn
local minSpawnDistance = 40
-- Determines the maximum spawn radius zombies can spawn around the player
local maxSpawnRadius = 250

--local volume = 0.0

local sounds = {
	"groans/zmoan01.ogg",
	"groans/zmoan02.ogg",
	"groans/zmoan03.ogg",
	"groans/zmoan04.ogg",
}

-- CODE --

players = {}

RegisterNetEvent("Z:playerUpdate")
AddEventHandler("Z:playerUpdate", function(mPlayers)
	players = mPlayers
end)


peds = {}


Citizen.Trace("Start Zombie thread")
Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			
			SetAiMeleeWeaponDamageModifier(1.0)
			AddRelationshipGroup("zombeez")
			SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("PLAYER"))
			SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("looters"))
			SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("badanimals"))
			SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("animals"))
			SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("friends"))
			SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("ngf"))
			SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("zombeez"))
			
			if #peds < maxZombies then
				x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

				choosenPed = pedModels[math.random(1, #pedModels)]
				choosenPed = string.upper(choosenPed)
				RequestModel(GetHashKey(choosenPed))
				while not HasModelLoaded(GetHashKey(choosenPed)) or not HasCollisionForModelLoaded(GetHashKey(choosenPed)) do
					Citizen.Wait(1)
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
				
				ped = CreatePed(4, GetHashKey(choosenPed), newX, newY, newZ, 0.0, true, false)
				Citizen.Trace("Zombie spawned")
				
				SetPedAccuracy(ped, 25)
				SetEntityHealth(ped, 400)
				SetEntityMaxHealth(ped, 400)
				SetPedPathCanUseClimbovers(ped, false)
				SetPedPathCanUseLadders(ped, false)
				SetPedPathAvoidFire(ped, false)
				SetPedPathCanDropFromHeight(ped, true)
				
				AddRelationshipGroup("zombeez")
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("looters"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("badanimals"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("animals"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("friends"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("ngf"))
				SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("zombeez"))

				SetAiMeleeWeaponDamageModifier(1.0)

				SetPedFleeAttributes(ped, 0, 0)
				SetPedCombatAttributes(ped, 16, 1)
				SetPedCombatAttributes(ped, 17, 0)
				SetPedCombatAttributes(ped, 46, 1)
				SetPedCombatAttributes(ped, 1424, 0)
				SetPedCombatAttributes(ped, 5, 1)
				SetPedCombatRange(ped,2)
				SetPedAlertness(ped,3)
				SetPedTargetLossResponse(ped, 2)
				SetPedSeeingRange(ped, 15.0)
				SetPedHearingRange(ped, 1500.0)
				SetAmbientVoiceName(ped, "ALIENS")
				SetPedEnableWeaponBlocking(ped, false)
				SetPedRelationshipGroupHash(ped, GetHashKey("zombeez"))
				DisablePedPainAudio(ped, true)
				SetPedDiesInWater(ped, false)
				SetPedDiesWhenInjured(ped, false)
				--	PlaceObjectOnGroundProperly(ped)
				SetPedDiesInstantlyInWater(ped,true)
				SetPedIsDrunk(ped, true)
				SetPedConfigFlag(ped,100,1)
				
				walkStyle = walkStyles[math.random(1, #walkStyles)]
				
				RequestAnimSet(walkStyle)
				while not HasAnimSetLoaded(walkStyle) do
					Citizen.Wait(1)
				end
				SetPedMovementClipset(ped, walkStyle, 1.0)
				ApplyPedDamagePack(ped,"BigHitByVehicle", 0.0, 9.0)
				ApplyPedDamagePack(ped,"SCR_Dumpster", 0.0, 9.0)
				ApplyPedDamagePack(ped,"SCR_Torture", 0.0, 9.0)
				StopPedSpeaking(ped,true)
				
				--[[blip = AddBlipForEntity(ped)
				SetBlipSprite(blip, 84)
				SetBlipAsShortRange(blip, true)--]]
				
				TaskWanderStandard(ped, 1.0, 10)
				local pspeed = math.random(20,70)
				local pspeed = pspeed/10
				local pspeed = pspeed+0.01
				SetEntityMaxSpeed(ped, 5.0)
					
				-- Network Natives
				NetworkRegisterEntityAsNetworked(ped)
				SetEntityAsMissionEntity(ped, true)
				
				table.insert(peds, ped)
			end

			for i, ped in pairs(peds) do
				if DoesEntityExist(ped) == false then
					table.remove(peds, i)
				end
				playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				pedX, pedY, pedZ = table.unpack(GetEntityCoords(ped, true))
							
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
				
				if hitCount > 5 then
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
				if IsPedDeadOrDying(ped, 1) == 1 then
					if GetPedSourceOfDeath(ped) == PlayerPedId() then
						if guardMission == true then
							zombieCount = zombieCount + 1
							SetEntityAsNoLongerNeeded(ped)
							table.remove(peds, i)
							zombieCountAdd = true
						end
					end
				end
				
				-- Loot Dead Zombies				
				if IsPedDeadOrDying(ped, 1) == 1 then
					volume = 0.0
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
									end
									if randomChance >= 20 and randomChance < 40 then
										randomCredits = math.random(2, 15)
										zCredits = zCredits + randomCredits
										ShowNotification("You found " .. randomCredits.. " Zombie Credits")
									end
									if randomChance >= 40 and randomChance < 60 then
										zBlood = zBlood + 1
										ShowNotification("You found Zombie blood")
									end
									if randomChance >= 60 and randomChance < 80 then
										randomLogs = math.random(1, 5)
										woodLogs = woodLogs + randomLogs
										ShowNotification("You found " ..randomLogs.. " wood logs")
									end
									if randomChance >= 60 and randomChance < 100 then
										ShowNotification("You found nothing.")
									end
									ClearPedSecondaryTask(GetPlayerPed(-1))
									RemoveBlip(blip)
									SetEntityAsNoLongerNeeded(ped)
									DeleteEntity(ped)
									table.remove(peds, i)
								end
							end
						end
					end
				end
				
				-- Delete far away unlooted dead zombies after 60 seconds
				if IsPedDeadOrDying(ped, 1) == 1 then
					if(Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) > 75.0)then
						-- Set ped as no longer needed for despawning
						--local dropChance = math.random(0,100)
						Citizen.Trace("Delete unlooted dead Zombie")
						RemoveBlip(blip)
						SetEntityAsNoLongerNeeded(ped)
						DeleteEntity(ped)
						table.remove(peds, i)
					end
				else
					playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					pedX, pedY, pedZ = table.unpack(GetEntityCoords(ped, true))
					
					--DrawText3d(pedX, pedY, pedZ + 1, 0.5, 0, "a zombie", 255, 0, 0, false)
					
					-- Alert Zombie Voices
					--[[closeDistance1 = Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) < 30
					farDistance1 = Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) > 30
					if farDistance1 then
						if (playingsound) then
							volume = 0.0
							StopAlertVoice()
							playingsound = false
						end
					elseif closeDistance1 then
						if not (playingsound) then
							volume = 0.5
							if IsPedInMeleeCombat(ped) then
								playingsound = true
								PlayAlertVoice()
								Citizen.Wait(10000)
							end
						end
					end
					
					-- Normal Zombie Voices
					closeDistance2 = Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) < 15
					farDistance2 = Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) > 15
					if farDistance2 then
						if (playingsound) then
							volume = 0.0
							StopNormalVoices()
							playingsound = false
						end
					elseif closeDistance2 then
						if not (playingsound) then
							volume = 0.5
							if not IsPedInMeleeCombat(ped) then
								playingsound = true
								PlayNormalVoices()
								Citizen.Wait(4000)
							end
						end
					end--]]
										
					playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					SetPedArmour(ped, 0)
					SetPedAccuracy(ped, 25)

					SetAiMeleeWeaponDamageModifier(0.1)
					SetPedFleeAttributes(ped, 0, 0)
					SetPedCombatAttributes(ped, 16, 1)
					SetPedCombatAttributes(ped, 17, 0)
					SetPedCombatAttributes(ped, 46, 1)
					SetPedCombatAttributes(ped, 1424, 0)
					SetPedCombatAttributes(ped, 5, 1)
					SetPedCombatRange(ped,2)
					SetPedSeeingRange(ped, 15.0)
					SetPedHearingRange(ped, 1500.0)
					SetAmbientVoiceName(ped, "ALIENS")
					SetPedEnableWeaponBlocking(ped, false)
					SetPedRelationshipGroupHash(ped, GetHashKey("zombeez"))
					DisablePedPainAudio(ped, true)
					SetPedDiesInWater(ped, false)
					SetPedDiesWhenInjured(ped, false)
					
					-- Kill and delete zombies in greenzones
					for k,v in ipairs(greenZones) do
						if(Vdist(pedX, pedY, pedZ, v.x, v.y, v.z) < 200.0)then
							--Citizen.Trace("Zombie entered greenzone")
							SetEntityHealth(ped, 0)
							SetEntityAsNoLongerNeeded(ped)
							RemoveBlip(blip)
							DeleteEntity(ped)
							table.remove(peds, i)
						end
					end
					
					-- Makes zombies ragdoll in vehicle
					if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						SetPedCanRagdoll(ped, true)
					elseif not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						SetPedCanRagdoll(ped, false)
					end
					
					if pedX < playerX - despawnDistance or pedX > playerX + despawnDistance or pedY < playerY - despawnDistance or pedY > playerY + despawnDistance then
						-- Set ped as no longer needed for despawning
						local model = GetEntityModel(ped)
						SetEntityAsNoLongerNeeded(ped)
						SetModelAsNoLongerNeeded(model)
						DeleteEntity(ped)
						table.remove(peds, i)
						Citizen.Trace("Deleted far away Zombie")
					end
				end
			end
		end
	--end)
end)


-- Alert Zombie Voices Thread
--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsPedInMeleeCombat(ped) then
			PlayAlertVoice()
			Citizen.Wait(4000)
			volume = 1.0
		end
	end
end)--]]

-- Normal Zombie Voices Thread
--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		if not IsPedInMeleeCombat(ped) then
			PlayNormalVoices()
			Citizen.Wait(4000)
		end
	end
end)--]]

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
end

-- Stops the normal voice sound
function StopNormalVoices()
	SendNUIMessage({
		stopsound = sounds[math.random(1, #sounds)],
	})
end
-- Sound for normal zombie groan.
function PlayAlertVoice()
	SendNUIMessage({
		playsound = "groans/alerted.ogg",
		soundvolume = volume
	})
end

-- Stop alert voice
function StopAlertVoice()
	SendNUIMessage({
		stopsound = "groans/alerted.ogg",
	})
end--]]

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

-- Handles 3D Text above AI
function DrawText3d(x,y,z, size, font, text, r, g, b, outline)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
	
	if onScreen then
		SetTextScale(size*scale, size*scale)
		SetTextFont(font)
		SetTextProportional(1)
		SetTextColour(r, g, b, 255)
		if not outline then
			SetTextDropshadow(0, 0, 0, 0, 55)
			SetTextEdge(2, 0, 0, 0, 150)
			SetTextDropShadow()
			SetTextOutline()
		end
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		SetDrawOrigin(x,y,z, 0)
		DrawText(0.0, 0.0)
		ClearDrawOrigin()
	end
end

RegisterNetEvent("Z:cleanup")
AddEventHandler("Z:cleanup", function()
	for i, ped in pairs(peds) do
		-- Set ped as no longer needed for despawning
		local model = GetEntityModel(ped)
		SetEntityAsNoLongerNeeded(ped)
		SetModelAsNoLongerNeeded(model)
		DeleteEntity(ped)

		table.remove(peds, i)
	end
end)
