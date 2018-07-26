--[[ EatShit SCRIPT ]]--
shitcount = 0
volume = 1.0

-- Resets shit count and allows shitting again
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5 * 60000)
		shitcount = 0
	end
end)

RegisterCommand("shit", function(source,args,raw)
	shitcount = shitcount + 1
		if shitcount <= 1 then
			local lPed = GetPlayerPed(-1)
				if not IsEntityPlayingAnim(lPed, "switch@trevor@on_toilet", "piss_loop", 3) then
					RequestAnimDict("switch@trevor@on_toilet")
					while not HasAnimDictLoaded("switch@trevor@on_toilet") do
						Citizen.Wait(100)
					end
					TaskPlayAnim(lPed, "switch@trevor@on_toilet", "piss_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
					SetCurrentPedWeapon(lPed, GetHashKey("WEAPON_UNARMED"), true)
					PlayFart()
					TriggerEvent("chatMessage", "", {255, 0, 0}, "You ate your own shit.")
					Citizen.Wait(5000)
					DecorSetFloat(PlayerPedId(), "hunger", DecorGetFloat(PlayerPedId(),"hunger")+1)
					SetEntityHealth(lPed, GetEntityHealth(lPed) - 5)
					DecorSetFloat(PlayerPedId(), "illness", DecorGetFloat(PlayerPedId(),"illness")+15)
					ClearPedTasksImmediately(lPed)
				end
		elseif shitcount > 1 then
			TriggerEvent("chatMessage", "", {255, 0, 0}, "You cannot shit again for a while.")
		end
end)


function PlayFart()
	SendNUIMessage({
		playsound = "fart.ogg",
		soundvolume = volume
	})
end