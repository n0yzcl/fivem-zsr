
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		SetTextFont(0)
		SetTextProportional(1)
		SetTextScale(0.0, 0.3)

		SetTextColour(128, 0, 0, 255)

		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString("Resurrection 408")
		DrawText(0.18, 0.95)
		
		DrawRect(0.225, 0.840, 0.10, 0.15, 155, 0, 0, 75)

		health = GetEntityHealth(PlayerPedId())
		if health then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.40)
			if health < 120 then
				SetTextColour(100, 0, 0, 255)
			else
				SetTextColour(100, 0, 0, 255)
			end
			SetTextColour(255, 0, 0, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			local str = "Health: " .. health - 100
			if infected then str = "Health: " .. health - 100 .." ( INFECTED )" end
			AddTextComponentString(str)
			DrawText(0.19, 0.775)
		end
		hunger = DecorGetFloat(PlayerPedId(), "hunger")
		if hunger then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.40)
			if hunger < 20.0 and hunger > 0.0 then
				SetTextColour(0, 200, 0, 255)
			elseif hunger < 0.0 then
				SetTextColour(0, 100, 0, 255)
			else
				SetTextColour(0, 255, 0, 255)
			end
			SetTextColour(0, 255, 0, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("Hunger: " .. math.round(hunger))
			DrawText(0.19, 0.80)
		end
		thirst = DecorGetFloat(PlayerPedId(), "thirst")
		if thirst then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.40)
			if thirst < 20.0 and thirst > 0.0 then
				SetTextColour(0, 0, 200, 255)
			elseif thirst < 0.0 then
				SetTextColour(0, 0, 100, 255)
			else
				SetTextColour(0, 0, 255, 255)
			end
			SetTextColour(0, 0, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("Thirst: " .. math.round(thirst))
			DrawText(0.19, 0.825)
		end

		local infection = DecorGetFloat(PlayerPedId(), "infection")
		if infection then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.40)
			if infection < 200.0 then
				SetTextColour(255, 191, 0, 255)
			elseif infection > 700.0 then
				SetTextColour(255, 0, 0, 255)
			else
				SetTextColour(255, 255, 0, 255)
			end--]]
			SetTextColour(150, 10, 0, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("Infection: " .. math.round(infection))
			DrawText(0.19, 0.85)
		end
		illness = DecorGetFloat(PlayerPedId(), "illness")
		if illness then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.40)
			if illness < 20.0 and illness > 0.0 then
				SetTextColour(0, 200, 200, 255)
			elseif illness < 0.0 then
				SetTextColour(0, 100, 100, 255)
			else
				SetTextColour(0, 255, 255, 255)
			end
			SetTextColour(0, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("Illness: " .. math.round(illness))
			DrawText(0.19, 0.875)
		end
	end
end)


function math.round(num, numDecimalPlaces)
	if numDecimalPlaces and numDecimalPlaces>0 then
		local mult = 10^numDecimalPlaces
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

function round(a,b)
	math.round(a,b)

end