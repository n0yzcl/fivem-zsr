-- CONFIG --

-- A list of vehicles that should be spawned
local spawnableBikes =
{
	"scorcher",
	"cruiser",
	"fixter"
}

-- CODE --

-- CODE --

players = {}

RegisterNetEvent("Z:playerUpdate")
AddEventHandler("Z:playerUpdate", function(mPlayers)
	players = mPlayers
end)

RegisterNetEvent("spawnNewVehicle")

bikes = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if #bikes < 5 then
			x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))

			local newVehicleX = x
			local NewVehicleY = y
			local NewVehicleZ = 0

			repeat
				Citizen.Wait(1)
				newVehicleX = x + math.random(-500, 500)
				NewVehicleY = y + math.random(-500, 500)
				_,NewVehicleZ = GetGroundZFor_3dCoord(newVehicleX+.0,NewVehicleY+.0,z+999.0, 1)
			until NewVehicleZ ~= 0

			choosenBike = spawnableBikes[math.random(1, #spawnableBikes)]
			RequestModel(choosenBike)
			while not HasModelLoaded(choosenBike) or not HasCollisionForModelLoaded(choosenBike) do
				Citizen.Wait(100)
			end

			bike = CreateVehicle(choosenBike, newVehicleX, NewVehicleY, NewVehicleZ, math.random(), true, true)
			SetVehicleFuelLevel(bike, math.random() + math.random(10, 80))
			SetVehicleEngineHealth(bike, math.random(400,1000)+0.0)
			PlaceObjectOnGroundProperly(bike)
			SetEntityAsMissionEntity(bike, true, true)
			if not NetworkGetEntityIsNetworked(bike) then
				NetworkRegisterEntityAsNetworked(bike)
			end
			--TriggerServerEvent("registerNewVehicle", NetworkGetNetworkIdFromEntity(bike)) -- these events are dummies, they don't do anything
			table.insert(bikes, bike)
		end

		for i, bike in pairs(bikes) do
			if not DoesEntityExist(bike) or GetEntityHealth(bike) == 0 then
				SetEntityAsNoLongerNeeded(bike)
				table.remove(bikes, i)
				--TriggerServerEvent("removeOldVehicle", NetworkGetNetworkIdFromEntity(bike))
			else
				local	playerX, playerY = table.unpack(GetEntityCoords(PlayerPedId(), true))
				local	bikeX, bikeY = table.unpack(GetEntityCoords(bike, false))

				if bikeX < playerX - 500 or bikeX > playerX + 500 or bikeY < playerY - 500 or bikeY > playerY + 500 then
					-- Set bike as no longer needed for despawning
					SetEntityAsNoLongerNeeded(bike)
					table.remove(bikes, i)
					--TriggerServerEvent("removeOldVehicle", NetworkGetNetworkIdFromEntity(bike))
				end
			end
		end
	end
end)

--[[ Debug
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for i, car in pairs(cars) do
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
			carX, carY, carZ = table.unpack(GetEntityCoords(car, false))
			--	DrawLine(playerX,playerY, playerZ, carX, carY, carZ, 255.0,0.0,0.0,255.0)
		end
	end
end)
--]]

--[[RegisterNetEvent("Z:cleanup")
AddEventHandler("Z:cleanup", function()
	for i, bike in pairs(bikes) do
		-- Set bike as no longer needed for despawning
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(bike))
		TriggerServerEvent("removeOldVehicle", NetworkGetNetworkIdFromEntity(bike))
		table.remove(bikes, i)
	end
end)--]]
