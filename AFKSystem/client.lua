local afk = false
local playerPed = GetPlayerPed(-1)

RegisterCommand("afk", function(source,args,raw)
	if afk == false then
		ShowNotification("You are away from keyboard.")
		afk = true
	else
		ShowNotification("You are no longer away from keyboard.")
		afk = false
	end
end)

-- AFK code
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if afk == true then
			FreezeEntityPosition(playerPed, true)
			SetPedCanSwitchWeapon(PlayerPedId(), false)
			SetCurrentPedWeapon(PlayerPedId(), "WEAPON_UNARMED", true)
			DisablePlayerFiring(PlayerId(), true)
			SetEntityProofs(playerPed, true, true, true, true, true, true, true, true)
			DisableControlAction(1, 23, true)
			DisableControlAction(1, 26, true)
			DisableControlAction(1, 32, true)
			DisableControlAction(1, 33, true)
			DisableControlAction(1, 34, true)
			DisableControlAction(1, 35, true)
			DisableControlAction(1, 36, true)
			DisableControlAction(1, 37, true)
			DisableControlAction(1, 44, true)
			DisableControlAction(1, 45, true)
			DisableControlAction(1, 71, true)
			DisableControlAction(1, 72, true)
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
		elseif afk == false then
			FreezeEntityPosition(playerPed, false)
			SetPedCanSwitchWeapon(PlayerPedId(), true)
			--DisablePlayerFiring(PlayerId(), false)
			SetEntityProofs(playerPed, false, false, false, false, false, false, false, false)
		end
	end
end)

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end