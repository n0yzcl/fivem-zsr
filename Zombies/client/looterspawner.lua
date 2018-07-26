-- CONFIG --

-- Zombies have a 1 in 150 chance to spawn with guns
-- It will choose a gun in this list when it happens
-- Weapon list here: https://www.se7ensins.com/forums/threads/weapon-and-explosion-hashes-list.1045035/


local pedModels = {
	"a_m_m_tramp_01",
	"a_m_o_tramp_01",
	"a_m_m_trampbeac_01",
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

local pedWeps = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_REVOLVER",
	"WEAPON_MACHETE",
	"WEAPON_CROWBAR",
	"WEAPON_BAT",
	"WEAPON_HATCHET",
	"WEAPON_WRENCH",
	"WEAPON_GOLFCLUB",
	"WEAPON_SWITCHBLADE",
	"WEAPON_KNIFE",
	"WEAPON_DAGGER",
	"WEAPON_BOTTLE"
}

local maxLooters = 5

local minDespawnDistance = 1500
local minSpawnDistance = 50
local maxSpawnRadius = 1500

-- CODE --

players = {}

RegisterNetEvent("Z:playerUpdate")
AddEventHandler("Z:playerUpdate", function(mPlayers)
	players = mPlayers
end)

looters = {}

Citizen.Trace("Start looter thread")
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if #looters < maxLooters then
			x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

			choosenLooter = pedModels[math.random(1, #pedModels)]
			choosenLooter = string.upper(choosenLooter)
			RequestModel(GetHashKey(choosenLooter))
			while not HasModelLoaded(GetHashKey(choosenLooter)) or not HasCollisionForModelLoaded(GetHashKey(choosenLooter)) do
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
			
			--Citizen.Trace("Looter spawning")
			looter = CreatePed(4, GetHashKey(choosenLooter), newX, newY, newZ, 0.0, true, true)
			
			SetPedAccuracy(looter, 25)
			SetPedSeeingRange(looter, 100.0)
			SetPedHearingRange(looter, 1000.0)
			SetPedCanBeDraggedOut(looter, true)
			SetPedPathCanUseClimbovers(looter, true)
			SetPedPathCanUseLadders(looter, true)
			SetPedPathAvoidFire(looter, true)
			SetPedPathCanDropFromHeight(looter, false)
			
			AddRelationshipGroup("looters")
			SetRelationshipBetweenGroups(5, GetHashKey("looters"), GetHashKey("PLAYER"))
			SetRelationshipBetweenGroups(5, GetHashKey("looters"), GetHashKey("ngf"))
			SetRelationshipBetweenGroups(5, GetHashKey("looters"), GetHashKey("zombeez"))
			SetRelationshipBetweenGroups(5, GetHashKey("looters"), GetHashKey("friends"))
			SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("looters"))

			SetAiMeleeWeaponDamageModifier(1.0)

			SetPedFleeAttributes(looter, 0, 0)
			SetPedCombatAttributes(looter, 16, 1)
			SetPedCombatAttributes(looter, 17, 0)
			SetPedCombatAttributes(looter, 46, 1)
			SetPedCombatAttributes(looter, 1424, 0)
			SetPedCombatAttributes(looter, 5, 1)
			SetPedCombatRange(looter,2)
			SetPedAlertness(looter,3)
			SetPedTargetLossResponse(looter, 2)
			SetPedEnableWeaponBlocking(looter, true)
			SetPedRelationshipGroupHash(looter, GetHashKey("looters"))
			SetPedDiesInWater(looter, true)
			SetPedDiesWhenInjured(looter, true)
			--	PlaceObjectOnGroundProperly(looter)
			SetPedDiesInstantlyInWater(looter,false)
			SetPedConfigFlag(looter,100,1)
						
			ApplyPedDamagePack(looter,"SCR_Dumpster", 0.0, 9.0)
			randomWep = math.random(1, #pedWeps)
			GiveWeaponToPed(looter, GetHashKey(pedWeps[randomWep]), 9999, true, true)
			
			blip = AddBlipForEntity(looter)
			SetBlipSprite(blip, 126)
			SetBlipAsShortRange(blip, true)

			TaskWanderStandard(looter, 1.0, 10)
			local pspeed = math.random(20,70)
			local pspeed = pspeed/10
			local pspeed = pspeed+0.01
			SetEntityMaxSpeed(looter, 5.0)
						
			NetworkRegisterEntityAsNetworked(looter)
		
			table.insert(looters, looter)
		end

		for i, looter in pairs(looters) do
			if DoesEntityExist(looter) == false then
				table.remove(looters, i)
			end
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			pedX, pedY, pedZ = table.unpack(GetEntityCoords(looter, true))
			if IsPedDeadOrDying(looter, 1) == 1 then
				volume = 0.0
				playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				pedX, pedY, pedZ = table.unpack(GetEntityCoords(looter, true))
				if not IsPedInAnyVehicle(PlayerPedId(), false) then
					if(Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) < 3.0)then
						DisplayHelpText("Press ~INPUT_CONTEXT~ to loot looter.")
						if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
							if DoesEntityExist(GetPlayerPed(-1)) then
								RequestAnimDict("pickup_object")
								while not HasAnimDictLoaded("pickup_object") do
								Citizen.Wait(1)
								end
								TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8, -1, 49, 0, 0, 0, 0)
								GiveWeaponComponentToPed(PlayerPedId(), "WEAPON_ASSAULTRIFLE", "COMPONENT_AT_AR_FLSH")
								GiveWeaponComponentToPed(PlayerPedId(), "WEAPON_ASSAULTRIFLE", "COMPONENT_AT_AR_SUPP")
								GiveWeaponComponentToPed(PlayerPedId(), "WEAPON_CARBINERIFLE", "COMPONENT_AT_AR_SUPP")
								GiveWeaponComponentToPed(PlayerPedId(), "WEAPON_CARBINERIFLE", "COMPONENT_AT_AR_FLSH")
								GiveWeaponComponentToPed(PlayerPedId(), "WEAPON_PUMPSHOTGUN", "COMPONENT_AT_SR_SUPP")
								GiveWeaponComponentToPed(PlayerPedId(), "WEAPON_PUMPSHOTGUN", "COMPONENT_AT_SR_FLSH")									
								Citizen.Wait(2000)
								ClearPedSecondaryTask(GetPlayerPed(-1))
								RemoveBlip(blip)
								SetEntityAsNoLongerNeeded(looter)
								DeleteEntity(looter)
								table.remove(looters, i)
							end
						end
					end
				end
			end
				
			if IsPedDeadOrDying(looter, 1) == 1 then
				if(Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) > 75.0)then
					RemoveBlip(blip)
					SetEntityAsNoLongerNeeded(looter)
					DeleteEntity(looter)
					table.remove(looters, i)
				end
			else
				playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				pedX, pedY, pedZ = table.unpack(GetEntityCoords(looter, true))
				
				--DrawText3d(pedX, pedY, pedZ + 1, 0.5, 0, "a looter", 255, 0, 0, false)
				
				playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				SetPedAccuracy(looter, 25)
				SetPedSeeingRange(looter, 100.0)
				SetPedHearingRange(looter, 1000.0)

				SetPedFleeAttributes(looter, 0, 0)
				SetPedCombatAttributes(looter, 16, 1)
				SetPedCombatAttributes(looter, 17, 0)
				SetPedCombatAttributes(looter, 46, 1)
				SetPedCombatAttributes(looter, 1424, 0)
				SetPedCombatAttributes(looter, 5, 1)
				SetPedCombatRange(looter,2)
				SetPedEnableWeaponBlocking(looter, true)
				SetPedRelationshipGroupHash(looter, GetHashKey("looters"))
				SetPedDiesInWater(looter, true)
				SetPedDiesWhenInjured(looter, true)
				
				-- Kill and delete looter in greenzones
				for k,v in ipairs(greenZones) do
					if(Vdist(pedX, pedY, pedZ, v.x, v.y, v.z) < 200.0)then
						Citizen.Trace("Looter entered greenzone")
						SetEntityHealth(looter, 0)
						DeleteEntity(looter)
						SetEntityAsNoLongerNeeded(looter)
						RemoveBlip(blip)
						table.remove(looters, i)
					end
				end
				
				
				if pedX < playerX - minDespawnDistance or pedX > playerX + minDespawnDistance or pedY < playerY - minDespawnDistance or pedY > playerY + minDespawnDistance then
					-- Set looter as no longer needed for despawning
					local model = GetEntityModel(looter)
					SetEntityAsNoLongerNeeded(looter)
					SetModelAsNoLongerNeeded(model)
					table.remove(looters, i)
				end
			end
		end
	end
end)


function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
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

--[[RegisterNetEvent("Z:cleanup")
AddEventHandler("Z:cleanup", function()
	for i, looter in pairs(looters) do
		-- Set looter as no longer needed for despawning
		local model = GetEntityModel(looter)
		SetEntityAsNoLongerNeeded(looter)
		SetModelAsNoLongerNeeded(model)

		table.remove(looters, i)
	end
end)--]]
