RegisterNetEvent("showNotification")

Citizen.CreateThread(function()
	AddEventHandler("showNotification", function(text)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(text)
		DrawNotification(0,1)
	end)
end)

Citizen.CreateThread(function()
	local alreadyDead = false
	while true do
		Citizen.Wait(100)
		local playerPed = GetPlayerPed(-1)

		if IsEntityDead(playerPed) and not alreadyDead then
			local killer = GetPedKiller(playerPed)
			local killername = "unknown"
			local killerId = 0
			_,weapon = GetCurrentPedWeapon(killer,1)
			killerweapon = reverseWeaponHash( tostring(weapon) )
			for id = 0, 64 do
				if killer == GetPlayerPed(id) then
					killerId = id
					killername = GetPlayerName(id)
					break
				end
			end
			if killer == playerPed then
				TriggerServerEvent('playerDied',0,0)
			elseif killername and killername ~= "unknown" then
				TriggerServerEvent('playerDied',killername,1,killerweapon)
				TriggerServerEvent("registerKill",GetPlayerServerId(killerId))
			else
				TriggerServerEvent('playerDied',0,2)
			end
			alreadyDead = true
		end
		if not IsEntityDead(playerPed) then
			alreadyDead = false
		end
	end
end)
