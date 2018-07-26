local foodprops = {
	"prop_food_bag1",
	"prop_food_bag2",
	"prop_orang_can_01",
}

local drinkprops = {
	"prop_beer_bottle",
	"prop_water_bottle",
}

local maxFood = 5
local maxDrinks = 5

local minSpawnDistance = 30
local maxSpawnRadius = 500
local despawnDistance = 500


food = {}
drinks = {}

-- Spawn Food
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		if #food < maxFood then
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
			
			foodProps = foodprops[math.random(1, #foodprops)]
			foodProp = CreateObject(GetHashKey(foodProps), newPropX, newPropY, newPropZ, false, false, true)
			
			blip = AddBlipForEntity(foodProp)
			SetBlipSprite(blip, 274)
			SetBlipAsShortRange(blip, true)
			
			PlaceObjectOnGroundProperly(foodProp)
			table.insert(food, foodProp)
			Citizen.Trace("Food spawned")
		end
		
		for i, foodProp in pairs(food) do
			if DoesEntityExist(foodProp) == false then
				table.remove(food, i)
			end
			
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			propX, propY, propZ = table.unpack(GetEntityCoords(foodProp, true))
			
			if(Vdist(playerX, playerY, playerZ, propX, propY, propZ) < 50) then
				DrawText3d(propX, propY, propZ + 1, 0.5, 0, "a lootable food object", 255, 255, 255, false)
			end
			
			PlaceObjectOnGroundProperly(foodProp)
			
			if(Vdist(playerX, playerY, playerZ, propX, propY, propZ) < 1.5) then				
				DisplayHelpText("Press ~INPUT_CONTEXT~ to pickup food.")
				if IsControlJustReleased(1, 51) then
					RequestAnimDict("pickup_object")
					while not HasAnimDictLoaded("pickup_object") do
						Citizen.Wait(1)
					end
					TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8, -1, 49, 0, 0, 0, 0)
					Citizen.Wait(2000)
					randomChance = math.random(1, 100)
					--TriggerServerEvent("AddFoodItem")
					if randomChance > 50 then
						foodItems = foodItems + 1
						ShowNotification("You found food.")
					end
					if randomChance < 50 then
						ShowNotification("No food found.")
					end
					ClearPedTasksImmediately(PlayerPedId())
					RemoveBlip(blip)
					DeleteObject(foodProp)
					table.remove(food, i)
				end
			end

			if propX < playerX - despawnDistance or propX > playerX + despawnDistance or propY < playerY - despawnDistance or propY > playerY + despawnDistance then
				SetEntityAsNoLongerNeeded(foodProp)
				DeleteObject(foodProp)
				RemoveBlip(blip)
				table.remove(food, i)
			end
		end
	end
end)

-- Spawn Drinks
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		if #drinks < maxDrinks then
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
			
			drinkProps = drinkprops[math.random(1, #drinkprops)]
			drinkProp = CreateObject(GetHashKey(drinkProps), newPropX, newPropY, newPropZ, false, false, true)
			
			blip = AddBlipForEntity(drinkProp)
			SetBlipSprite(blip, 274)
			SetBlipAsShortRange(blip, true)
			
			PlaceObjectOnGroundProperly(drinkProp)
			table.insert(drinks, drinkProp)
			Citizen.Trace("Drink spawned")
		end
		
		for i, drinkProp in pairs(drinks) do
			if DoesEntityExist(drinkProp) == false then
				table.remove(drinks, i)
			end
			
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			propX, propY, propZ = table.unpack(GetEntityCoords(drinkProp, true))
			
			PlaceObjectOnGroundProperly(drinkProp)
			
			if(Vdist(playerX, playerY, playerZ, propX, propY, propZ) < 50) then
				DrawText3d(propX, propY, propZ + 1, 0.5, 0, "a lootable drink", 255, 255, 255, false)
			end
			
			if(Vdist(playerX, playerY, playerZ, propX, propY, propZ) < 1.5) then				
				DisplayHelpText("Press ~INPUT_CONTEXT~ to pickup drink.")
				if IsControlJustReleased(1, 51) then
					RequestAnimDict("pickup_object")
					while not HasAnimDictLoaded("pickup_object") do
						Citizen.Wait(1)
					end
					TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8, -1, 49, 0, 0, 0, 0)
					Citizen.Wait(2000)
					randomChance = math.random(1, 100)
					--TriggerServerEvent("AddDrinkItem")
					if randomChance > 50 then
						drinkItems = drinkItems + 1
						ShowNotification("You found and picked up a drink.")
					elseif randomChance < 50 then
						ShowNotification("You found an empty bottle.")
						emptyBottles = emptyBottles + 1
					end
					ClearPedTasksImmediately(PlayerPedId())
					DeleteObject(drinkProp)
					table.remove(drinks, i)
				end
			end
			
			if propX < playerX - despawnDistance or propX > playerX + despawnDistance or propY < playerY - despawnDistance or propY > playerY + despawnDistance then
				SetEntityAsNoLongerNeeded(drinkProp)
				DeleteObject(drinkProp)
				RemoveBlip(blip)
				table.remove(drinks, i)
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