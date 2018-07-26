--[[ EatShit SCRIPT ]]--
pisscount = 0

-- Resets piss count and allows pissing
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5 * 60000)
		pisscount = 0
	end
end)

RegisterCommand("piss", function(source,args,raw)
	pisscount = pisscount + 1
		if pisscount <= 1 then
			local lPed = GetPlayerPed(-1)
			TriggerEvent("chatMessage", "", {255, 0, 0}, "You drank your piss.")
			DecorSetFloat(PlayerPedId(), "thirst", DecorGetFloat(PlayerPedId(),"thirst")+2)
			SetEntityHealth(lPed, GetEntityHealth(lPed) - 5)
		elseif pisscount > 1 then
			TriggerEvent("chatMessage", "", {255, 0, 0}, "You cannot piss again for a while.")
		end
end)