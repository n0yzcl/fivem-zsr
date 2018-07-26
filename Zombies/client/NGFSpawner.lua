-- CONFIG --

-- Zombies have a 1 in 150 chance to spawn with guns
-- It will choose a gun in this list when it happens
-- Weapon list here: https://www.se7ensins.com/forums/threads/weapon-and-explosion-hashes-list.1045035/


local pedModels = {
	"ngf",
}

local greenZones = {
	{name="Junkyard Base", x= 2384.00, y= 3090.00, z= 48.00},
	{name="Grapeseed Base", x= 2447.10, y= 4977.18, z= 46.82},
	{name="NRF Base", x= -1116.87, y= 4925.92, z= 218.23},
	{name="City Spawn", x= 142.73, y= -1076.33, z= 29.19},
}

local spawnAreas = {
	{x= 2384.00, y= 3090.00, z= 48.00},
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

local pedWeps = {
	"WEAPON_MINIGUN",
}

local maxNGF = 5
local despawnDistance = 2000
local minSpawnDistance = 100
local maxSpawnRadius = 2000

-- CODE --

players = {}

RegisterNetEvent("Z:playerUpdate")
AddEventHandler("Z:playerUpdate", function(mPlayers)
	players = mPlayers
end)

nextgenforces = {}

Citizen.Trace("Start NGF thread")
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		AddRelationshipGroup("ngf")
		SetRelationshipBetweenGroups(3, GetHashKey("ngf"), GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(5, GetHashKey("ngf"), GetHashKey("looters"))
		SetRelationshipBetweenGroups(5, GetHashKey("ngf"), GetHashKey("zombeez"))
		SetRelationshipBetweenGroups(5, GetHashKey("ngf"), GetHashKey("friends"))
		SetRelationshipBetweenGroups(3, GetHashKey("PLAYER"), GetHashKey("ngf"))
		
		if #nextgenforces < maxNGF then
			--x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

			choosenNGF = pedModels[math.random(1, #pedModels)]
			choosenNGF = string.upper(choosenNGF)
			RequestModel(GetHashKey(choosenNGF))
			while not HasModelLoaded(GetHashKey(choosenNGF)) or not HasCollisionForModelLoaded(GetHashKey(choosenNGF)) do
				Citizen.Wait(100)
			end
			
			for _, spawnlocation in pairs(spawnAreas) do
				x, y, z = spawnlocation.x, spawnlocation.y, spawnlocation.z
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
			
			Citizen.Trace("NGF spawning")
			NGF = CreatePed(4, GetHashKey(choosenNGF), newX, newY, newZ, 0.0, true, true)
			
			SetPedAccuracy(NGF, 25)
			SetPedSeeingRange(NGF, 100.0)
			SetPedHearingRange(NGF, 1000.0)
			SetEntityMaxHealth(NGF, 500)
			SetEntityHealth(NGF, 500)
			SetEntityProofs(NGF, true, true, false, true, true, true, 1, false)
			SetPedCanBeDraggedOut(NGF, false)
			SetPedPathCanUseClimbovers(NGF, false)
			SetPedPathCanUseLadders(NGF, false)
			SetPedPathAvoidFire(NGF, false)
			SetPedPathCanDropFromHeight(NGF, true)
			SetPedInfiniteAmmoClip(NGF, true)
			SetPedInfiniteAmmo(NGF, true)

			SetAiMeleeWeaponDamageModifier(2.0)
			SetAiWeaponDamageModifier(5.0)

			SetPedFleeAttributes(NGF, 0, 0)
			SetPedCombatAttributes(NGF, 16, 1)
			SetPedCombatAttributes(NGF, 17, 0)
			SetPedCombatAttributes(NGF, 46, 1)
			SetPedCombatAttributes(NGF, 1424, 0)
			SetPedCombatAttributes(NGF, 5, 1)
			SetPedCombatRange(NGF,2)
			SetPedAlertness(NGF,3)
			SetPedTargetLossResponse(NGF, 2)
			SetAmbientVoiceName(NGF, "ALIENS")
			SetPedEnableWeaponBlocking(NGF, true)
			SetPedRelationshipGroupHash(NGF, GetHashKey("ngf"))
			DisablePedPainAudio(NGF, true)
			SetPedDiesInWater(NGF, false)
			SetPedDiesWhenInjured(NGF, false)
			--	PlaceObjectOnGroundProperly(NGF)
			SetPedDiesInstantlyInWater(NGF,true)
			SetPedIsDrunk(NGF, true)
			SetPedConfigFlag(NGF,100,1)
						
			ApplyPedDamagePack(NGF,"BigHitByVehicle", 0.0, 9.0)
			ApplyPedDamagePack(NGF,"SCR_Dumpster", 0.0, 9.0)
			ApplyPedDamagePack(NGF,"SCR_Torture", 0.0, 9.0)
			StopPedSpeaking(NGF,true)
			randomWep = math.random(1, #pedWeps)
			GiveWeaponToPed(NGF, GetHashKey(pedWeps[randomWep]), 9999, true, true)
			
			blip = AddBlipForEntity(NGF)
			SetBlipSprite(blip, 84)
			SetBlipAsShortRange(blip, true)
						

			NetworkRegisterEntityAsNetworked(NGF)
			
			TaskWanderStandard(NGF, 1.0, 10)
			local pspeed = math.random(20,70)
			local pspeed = pspeed/10
			local pspeed = pspeed+0.01
			SetEntityMaxSpeed(NGF, 5.0)
			
			table.insert(nextgenforces, NGF)
		end
	

		for i, NGF in pairs(nextgenforces) do
			if DoesEntityExist(NGF) == false then
				table.remove(nextgenforces, i)
			end
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			pedX, pedY, pedZ = table.unpack(GetEntityCoords(NGF, true))
			if IsPedDeadOrDying(NGF, 1) == 1 then
				volume = 0.0
				-- Set NGF as no longer needed for despawning
				--local dropChance = math.random(0,100)
				playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				pedX, pedY, pedZ = table.unpack(GetEntityCoords(NGF, true))
				if not IsPedInAnyVehicle(PlayerPedId(), false) then	
					if(Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) < 3.0)then
						DisplayHelpText("Press ~INPUT_CONTEXT~ to NGF corpse.")
						if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
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
								SetEntityAsNoLongerNeeded(NGF)
								DeleteEntity(NGF)
								table.remove(nextgenforces, i)
							end
						end
					end
				end
			end
			
			if IsPedDeadOrDying(NGF, 1) == 1 then
				if(Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) > 75.0)then
					RemoveBlip(blip)
					SetEntityAsNoLongerNeeded(NGF)
					DeleteEntity(NGF)
					table.remove(nextgenforces, i)
				end
			else
				playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				pedX, pedY, pedZ = table.unpack(GetEntityCoords(NGF, true))
				
				DrawText3d(pedX, pedY, pedZ + 1, 0.5, 0, "an NGF guard", 255, 0, 0, false)
				
				playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				SetPedAccuracy(NGF, 25)
				SetPedSeeingRange(NGF, 100.0)
				SetPedHearingRange(NGF, 1000.0)

				SetPedFleeAttributes(NGF, 0, 0)
				SetPedCombatAttributes(NGF, 16, 1)
				SetPedCombatAttributes(NGF, 17, 0)
				SetPedCombatAttributes(NGF, 46, 1)
				SetPedCombatAttributes(NGF, 1424, 0)
				SetPedCombatAttributes(NGF, 5, 1)
				SetPedCombatRange(NGF,2)
				SetAmbientVoiceName(NGF, "ALIENS")
				SetPedEnableWeaponBlocking(NGF, true)
				SetPedRelationshipGroupHash(NGF, GetHashKey("ngf"))
				DisablePedPainAudio(NGF, true)
				SetPedDiesInWater(NGF, false)
				SetPedDiesWhenInjured(NGF, false)
				SetPedInfiniteAmmoClip(NGF, true)
				SetPedInfiniteAmmo(NGF, true)
				
				-- Kill and delete NGF in greenzones
				for k,v in ipairs(greenZones) do
					--DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 200.0, 200.0, 10.0, 0, 255, 0,165, 0, 0, 0,0)
					if(Vdist(pedX, pedY, pedZ, v.x, v.y, v.z) < 200.0)then
						Citizen.Trace("NGF entered greenzone")
						SetEntityHealth(NGF, 0)
						DeleteEntity(NGF)
						SetEntityAsNoLongerNeeded(NGF)
						RemoveBlip(blip)
						table.remove(nextgenforces, i)
					end
				end
				
				
				if pedX < playerX - despawnDistance or pedX > playerX + despawnDistance or pedY < playerY - despawnDistance or pedY > playerY + despawnDistance then
					-- Set NGF as no longer needed for despawning
					local model = GetEntityModel(NGF)
					SetEntityAsNoLongerNeeded(NGF)
					SetModelAsNoLongerNeeded(model)
					table.remove(nextgenforces, i)
				end
			end
		end
	end
end)

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

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent("Z:cleanup")
AddEventHandler("Z:cleanup", function()
	for i, NGF in pairs(nextgenforces) do
		-- Set NGF as no longer needed for despawning
		local model = GetEntityModel(NGF)
		SetEntityAsNoLongerNeeded(NGF)
		SetModelAsNoLongerNeeded(model)

		table.remove(nextgenforces, i)
	end
end)
