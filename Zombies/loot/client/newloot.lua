local searchableProps = {
	"bkr_prop_duffel_bag_01a",
	"p_ld_heist_bag_s_1",
	"p_ld_heist_bag_s_2",
	"p_ld_heist_bag_s_pro",
	"prop_beach_bag_01a",
	"prop_beach_bag_01b",
	"prop_big_bag_01",
	"prop_cs_heist_bag_02",
	"prop_med_bag_01b",
	"xm_prop_x17_bag_med_01a",
}

local searchCount = 0

spawned = false

-- Spawn Settings
local maxSpawnRadius = 250
local maxSearchables = 5
local despawnDistance = 300
local minSpawnDistance = 50

-- Weapons loot
local weapons = {
	"WEAPON_BAT",
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_DAGGER",
	"WEAPON_WRENCH",
	"WEAPON_CROWBAR",
	"WEAPON_GOLFCLUB",
	"WEAPON_HATCHET",
	"WEAPON_MOLOTOV",
	"WEAPON_FLARE",
	"WEAPON_FLAREGUN",
}

props = {}

RegisterNetEvent("Z:playerUpdate")
AddEventHandler("Z:playerUpdate", function(mPlayers)
	players = mPlayers
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		if #props < maxSearchables then
			x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			local newPropX = x
			local newPropY = y
			local newPropZ = z + 999.0
			
			repeat
				Citizen.Wait(1)

				newPropX = x + math.random(-maxSpawnRadius, maxSpawnRadius)
				newPropY = y + math.random(-maxSpawnRadius, maxSpawnRadius)
				_,newPropZ = GetGroundZFor_3dCoord(newPropX+.0,newPropY+.0,z, 1)
				
				for _, player in pairs(players) do
					Citizen.Wait(1)
					playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					if newPropX > playerX - minSpawnDistance and newPropX < playerX + minSpawnDistance or newPropY > playerY - minSpawnDistance and newPropY < playerY + minSpawnDistance then
						canSpawn = false
						break
					else
						canSpawn = true
					end
				end
			until canSpawn
			
			searchableProp = searchableProps[math.random(1, #searchableProps)]
			searchProp = CreateObject(GetHashKey(searchableProp), newPropX, newPropY, newPropZ - 1, false, false, true)
			
			blip = AddBlipForEntity(searchProp)
			SetBlipSprite(blip, 274)
			SetBlipAsShortRange(blip, true)
			
			PlaceObjectOnGroundProperly(searchProp)
			table.insert(props, searchProp)
			Citizen.Trace("Bag spawned")
		end
		for i, searchProp in pairs(props) do
			if DoesEntityExist(searchProp) == false then
				table.remove(props, i)
			end
			
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			propX, propY, propZ = table.unpack(GetEntityCoords(searchProp, true))
			
			PlaceObjectOnGroundProperly(searchProp)
			
			if(Vdist(playerX, playerY, playerZ, propX, propY, propZ) < 50) then
				DrawText3d(propX, propY, propZ + 1, 0.5, 0, "a bag of loot", 255, 255, 255, false)
			end

			if(Vdist(playerX, playerY, playerZ, propX, propY, propZ) < 1.5) then				
				DisplayHelpText("Press ~INPUT_CONTEXT~ to search bag.")
				if IsControlJustReleased(1, 51) then
					TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 1, true)
					Citizen.Wait(5000)
					randomChance = math.random(1, 100)
					randomWeapon = weapons[math.random(1, #weapons)]
					randomAmmo = math.random(5, 20)
					--randomItem = math.random(1, 4)
					if randomChance > 0 and randomChance < 10 then
						GiveWeaponToPed(PlayerPedId(), GetHashKey(randomWeapon), randomAmmo, false, false)
						ShowNotification("You found " .. randomWeapon)
					elseif randomChance > 10 and randomChance < 20 then
						randomCloth = math.random(1, 10)
						scrapCloth = scrapCloth + randomCloth
						ShowNotification("You found " ..randomCloth.. " scrap cloth.")
					elseif randomChance >= 20 and randomChance < 30 then
						randomMetal = math.random(1, 10)
						scrapMetal = scrapMetal + randomMetal
						ShowNotification("You found " ..randomMetal.. " scrap metal.")
					elseif randomChance >= 30 and randomChance < 40 then
						randomWood = math.random(1, 10)
						woodMaterials = woodMaterials + randomWood
						ShowNotification("You found " ..randomWood.. " wood materials.")
					elseif randomChance >= 40 and randomChance < 50 then
						randomTape = math.random(1, 5)
						ductTape = ductTape + randomTape
						ShowNotification("You found " ..randomTape.. " duct tape.")
					elseif randomChance >= 50 and randomChance < 60 then
						randomKit = math.random(1, 5)
						engineKit = engineKit + randomKit
						ShowNotification("You found " ..randomKit.. " engine repair kits.")
					elseif randomChance >= 60 and randomChance < 70 then
						randomPowder = math.random(1, 5)
						gunpowder = gunpowder + randomPowder
						ShowNotification("You found " ..randomPowder.. " gunpowder.")
					elseif randomChance >= 70 and randomChance < 100 then
						ShowNotification("You found nothing.")
					end
					ClearPedTasksImmediately(PlayerPedId())
					RemoveBlip(blip)
					DeleteObject(searchProp)
					table.remove(props, i)
				end
			end
			
			if propX < playerX - despawnDistance or propX > playerX + despawnDistance or propY < playerY - despawnDistance or propY > playerY + despawnDistance then
				SetEntityAsNoLongerNeeded(searchProp)
				DeleteObject(searchProp)
				RemoveBlip(blip)
				table.remove(props, i)
			end
		end
	end
end)

-- Handles 3D Text above Entity
function DrawText3d(x,y,z, size, font, text, r, g, b, outline)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*80
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

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end