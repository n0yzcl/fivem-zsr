local pillAreas = {
	{x= 2449.52, y= 4940.89, z= 45.64},
	{x= 136.52, y= -1079.29, z= 29.39},
	{x=68.606384277344, y=-1569.7996826172, z=29.597766876221}, 
	{x=3559.6118164063, y=3671.923828125, z=28.121864318848}, 
	{x=3557.8696289063, y=3662.8403320313, z=28.121894836426}, 
	{x=3536.6240234375, y=3662.8940429688, z=28.121892929077}, 
}

local Zpills = {
	"prop_cs_pills",
}

local pillCount = 0

spawned = false

zpills = {}

-- Spawn the pills
AddEventHandler('playerSpawned', function()
	Citizen.CreateThread(function()
		for _, pillprop in pairs(pillAreas) do
			pillProps = Zpills[math.random(1, #Zpills)]
			pillProp = CreateObject(GetHashKey(pillProps), pillprop.x, pillprop.y, pillprop.z-1, false, false, true)
			--PlaceObjectOnGroundProperly(pillProp)
			table.insert(zpills, pillProp)
		end
	end)
end)

-- Handles picking up pills
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for i, pillProp in pairs(zpills) do
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			propX, propY, propZ = table.unpack(GetEntityCoords(pillProp, true))
			if(Vdist(playerX, playerY, playerZ, propX, propY, propZ) < 1.5) then				
				DisplayHelpText("Press ~INPUT_CONTEXT~ to pickup Z-Pills.")
				if IsControlJustReleased(1, 51) then
					RequestAnimDict("pickup_object")
					while not HasAnimDictLoaded("pickup_object") do
						Citizen.Wait(1)
					end
					TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8, -1, 49, 0, 0, 0, 0)
					Citizen.Wait(2000)
					infection = DecorGetFloat(PlayerPedId(), "infection")
					illness = DecorGetFloat(PlayerPedId(), "illness")
					randomChance = math.random(1, 100)
					--TriggerServerEvent("AddFoodItem")
					if randomChance > 25 then
						hitCount = 0
						infected = false
						DecorSetFloat(PlayerPedId(), "infection", 0)
						DecorSetFloat(PlayerPedId(), "illness", illness - 10)
						ShowNotification("You found Z-Pills and took a dose of it.")
					elseif randomChance < 25 then
						ShowNotification("No Z-Pills left.")
					end
					ClearPedTasksImmediately(PlayerPedId())
					DeleteObject(pillProp)
					table.remove(zpills, i)
				end
			end
			if IsPedDeadOrDying(PlayerPedId(), 1) == 1 then
				DeleteObject(pillProp)
				table.remove(zpills, i)
			end
		end
	end
end)