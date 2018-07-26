local injured = false

-- Main injury thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		health = GetEntityHealth(PlayerPedId())
		playerPed = GetPlayerPed(-1)
		
		if health < 125 then
			ShowNotification("You are bleeding and weak, you need to find a med kit or bandage up quickly.")
			RequestClipSet("move_m@injured")
			SetPedMovementClipset(playerPed, "move_m@injured", 1.0)
			--ShakeGameplayCam("DRUNK_SHAKE", 1.0)
			SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
			SetPlayerMeleeWeaponDamageModifier(PlayerId(), 0.0)
			SetPedEnableWeaponBlocking(playerPed, false)
			SetRunSprintMultiplierForPlayer(PlayerId(), 0.0)
			SetEntityMaxSpeed(playerPed,4.00)
			Citizen.Wait(5000)
			SetEntityHealth(PlayerPedId(), health - 1)
		end
				
		if health < 150 and ( injured == false ) then
			injured = true
			ShowNotification("You are bleeding and injured, you need to bandage up or find a med kit")
			RequestClipSet("move_m@injured")
			SetPedMovementClipset(playerPed, "move_m@injured", 1.0)
			--ShakeGameplayCam("DRUNK_SHAKE", 1.0)
			SetPlayerHealthRechargeMultiplier(PlayerId(), 0.025)
			SetPlayerMeleeWeaponDamageModifier(PlayerId(), 0.25)
			SetPedEnableWeaponBlocking(playerPed, false)
			SetRunSprintMultiplierForPlayer(PlayerId(), 0.25)
			SetEntityMaxSpeed(playerPed, 4.00)
			
		elseif health > 150 and ( injured == true ) then
			--StopGameplayCamShaking(true)
			injured = false
			ResetPedMovementClipset(playerPed, 1.0)
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.00)
			SetPedEnableWeaponBlocking(playerPed, true)
			SetPlayerMeleeWeaponDamageModifier(PlayerId(), 5.00)
			SetEntityMaxSpeed(playerPed, 80.00)
		end
	end
end)


function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end