peds = {}
Citizen.CreateThread(function()
	RegisterServerEvent("registerNewZombie")
	AddEventHandler("registerNewZombie", function(ped)
		pedX, pedY, pedZ = table.unpack(GetEntityCoords(ped, true))
		table.insert(peds, ped)
		TriggerClientEvent("ZombieSync", -1, ped)
	end)
end)