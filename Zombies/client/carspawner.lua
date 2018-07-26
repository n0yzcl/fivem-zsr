-- CONFIG --

-- A list of vehicles that should be spawned
local spawnableCars =
{
	"barracks",
	"voodoo2",
	"sanctus",
	"towtruck2",
	"caddy2",
	"tornado3",
	"ratbike",
	"gargoyle",
	"tornado6",
	"ratloader",
	"rebel",
	"bfinjection",
	"dune",
	"dloader",
	"emperor2",
	"rubble",
	"bulldozer",
	"journey",
	"surfer2",
	"barracks2",
	"barracks3",
	"tractor",
	"wastelander",
	"scrap",
	"triptruck2"
}


-- CODE --

players = {}

RegisterNetEvent("Z:playerUpdate")
AddEventHandler("Z:playerUpdate", function(mPlayers)
	players = mPlayers
end)

RegisterNetEvent("spawnNewVehicle")

cars = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if #cars < 2 then
			x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))

			local newVehicleX = x
			local NewVehicleY = y
			local NewVehicleZ = 0

			repeat
				Citizen.Wait(1)
				newVehicleX = x + math.random(-1500, 1500)
				NewVehicleY = y + math.random(-1500, 1500)
				_,NewVehicleZ = GetGroundZFor_3dCoord(newVehicleX+.0,NewVehicleY+.0,z+999.0, 1)
			until NewVehicleZ ~= 0

			choosenCar = spawnableCars[math.random(1, #spawnableCars)]
			RequestModel(choosenCar)
			while not HasModelLoaded(choosenCar) or not HasCollisionForModelLoaded(choosenCar) do
				Citizen.Wait(100)
			end
			


			car = CreateVehicle(choosenCar, newVehicleX, NewVehicleY, NewVehicleZ, math.random(), true, true)
			SetVehicleFuelLevel(car, math.random() + math.random(0, 10))
			SetVehicleEngineHealth(car, math.random(50,500)+0.0)
			SetVehicleDirtLevel(car, 15.0)
			PlaceObjectOnGroundProperly(car)
			SetEntityAsMissionEntity(car, true, true)
			if not NetworkGetEntityIsNetworked(car) then
				NetworkRegisterEntityAsNetworked(car)
			end
			
			blip = AddBlipForEntity(car)
			SetBlipSprite(blip, 56)
			SetBlipAsShortRange(blip, true)
			
			--TriggerServerEvent("registerNewVehicle", NetworkGetNetworkIdFromEntity(car)) -- these events are dummies, they don't do anything
			table.insert(cars, car)
		end

		for i, car in pairs(cars) do
			if not DoesEntityExist(car) or GetEntityHealth(car) == 0 then
				SetEntityAsNoLongerNeeded(car)
				table.remove(cars, i)
				--TriggerServerEvent("removeOldVehicle", NetworkGetNetworkIdFromEntity(car))
			else
				local playerX, playerY = table.unpack(GetEntityCoords(PlayerPedId(), true))
				local carX, carY = table.unpack(GetEntityCoords(car, false))

				if carX < playerX - 1500 or carX > playerX + 1500 or carY < playerY - 1500 or carY > playerY + 1500 then
					-- Set car as no longer needed for despawning
					SetEntityAsNoLongerNeeded(car)
					table.remove(cars, i)
					--TriggerServerEvent("removeOldVehicle", NetworkGetNetworkIdFromEntity(car))
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
	for i, car in pairs(cars) do
		-- Set car as no longer needed for despawning
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(car))
		TriggerServerEvent("removeOldVehicle", NetworkGetNetworkIdFromEntity(car))
		table.remove(cars, i)
	end
end)--]]
