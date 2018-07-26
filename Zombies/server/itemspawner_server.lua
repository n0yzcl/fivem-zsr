spawnedItems = {}

Citizen.CreateThread(function()
	RegisterServerEvent("registerNewPickup")
	AddEventHandler("registerNewPickup", function(pickupInfo)
		table.insert(spawnedItems, pickupInfo)
		TriggerClientEvent("createPickup", -1, pickupInfo)
	end)

	RegisterServerEvent("removePickup")
	AddEventHandler("removePickup", function(pickupInfo, reason)
		for i,pickup in pairs(spawnedItems) do
			if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y and pickup.z == pickupInfo.z then
				table.remove(spawnedItems, i)
				TriggerClientEvent("removePickup", -1, pickupInfo)
				break
			end
		end
	end)

	RegisterServerEvent("Z:newplayerID")
	AddEventHandler("Z:newplayerID", function(playerid)
		for i,pickupInfo in pairs(spawnedItems) do
			TriggerClientEvent("createPickup", playerid, pickupInfo)
		end
	end)

	RegisterServerEvent("collectPickup")
	AddEventHandler("collectPickup", function(pickupInfo)
		local s = source
		for i,pickup in pairs(spawnedItems) do
			if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y and pickup.z == pickupInfo.z then
				table.remove(spawnedItems, i)
				TriggerClientEvent("removePickup", -1, pickupInfo, "pickup was collected\n")
				TriggerClientEvent("collectPickup", s, pickupInfo)
				break
			end
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(6000)
		for i, pickupInfo in pairs(spawnedItems) do
			if GetPlayerName(pickupInfo.owner) ~= pickupInfo.ownerName then
				TriggerEvent("removePickup", pickupInfo,"old client dead, removing their pickup\n")
			end
			Citizen.Wait(1)
		end
	end
end)

--[[
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10800000)
		for i, pickupInfo in pairs(spawnedItems) do
			if math.random(0,100) > 50 then
				TriggerEvent("removePickup", pickupInfo, "pickup items overflow\n")
			end
		end
	end
end)
--]]