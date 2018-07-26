local foodAreas = {
	{x= 1959.68, y= 3740.42, z= 32.34},
}

local drinkAreas = {
	{x= 1967.11, y= 3745.47, z= 32.34},
}

local foodprops = {
	"prop_food_bag1",
	"prop_food_bag2",
	"prop_orang_can_01",
}

local drinkprops = {
	"prop_beer_bottle",
	"prop_water_bottle",
}

local foodCount = 0
local drinkCount = 0
local foodObject = false
local drinkObject = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(15 * 60000)
		foodCount = 0
		drinkCount = 0
		foodObject = false
		drinkObject = false
	end
end)

-- Spawn the food props
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for k,v in ipairs(foodAreas) do
			DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.5, 0, 255, 0, 25, 0, 0, 0,0)
			if foodObject == false then
				choosenFood = foodprops[math.random(1, #foodprops)]
				food = CreateObject(GetHashKey(choosenfood), v.x, v.y, v.z, true, false, true)
				foodObject = true
			end
		end
	end
end)

-- Spawn the drink props
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for k,v in ipairs(drinkAreas) do
			DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.5, 0, 0, 255, 25, 0, 0, 0,0)
			if drinkObject == false then
				choosenDrink = drinkprops[math.random(1, #drinkprops)]
				drink = CreateObject(GetHashKey(choosenDrink), v.x, v.y, v.z - 1, true, false, true)
				drinkObject = true
			end
		end
	end
end)


		
-- Food Spawning Main Code
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		for k,v in ipairs(foodAreas) do
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			if(Vdist(playerX, playerY, playerZ, v.x, v.y, v.z) < 3.0) then
				if foodCount == 0 then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to pickup hunger consumable.")
					if IsControlJustReleased(1, 51) then
						--Citizen.Trace("Player entered greenzone")
						hunger = DecorGetFloat(PlayerPedId(), "hunger")
						randomHunger = math.random(5, 15)
						DecorSetFloat(PlayerPedId(), "hunger", hunger + randomHunger)
						foodCount = foodCount + 1
						DeleteObject(food)
					end
				end
			end
		end
	end
end)

-- Drink Spawning Main Code
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		for k,v in ipairs(drinkAreas) do
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			if(Vdist(playerX, playerY, playerZ, v.x, v.y, v.z) < 3.0) then
				if drinkCount > 1 then
					TriggerEvent("chatMessage", "", {255, 0, 0}, "There are currently no more Z-Pills to take.")
				end
				if drinkCount == 0 then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to pickup thirst consumable.")
					if IsControlJustReleased(1, 51) then
						--Citizen.Trace("Player entered greenzone")
						thirst = DecorGetFloat(PlayerPedId(), "thirst")
						randomThirst = math.random(5, 15)
						DecorSetFloat(PlayerPedId(), "thirst", thirst + randomThirst)
						drinkCount = drinkCount + 1
						DeleteObject(drink)
					end
				end
			end
		end
	end
end)