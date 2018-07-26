local pillAreas = {
	{x= 2449.52, y= 4940.89, z= 45.64},
	{x= 136.52, y= -1079.29, z= 29.39},
}

local pillCount = 0

-- Resets the usage for Z-pills to prevent abuse per player
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10 * 60000)
		pillCount = 0
	end
end)
		
-- Z-Pills Main Code
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		for k,v in ipairs(pillAreas) do
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			if(Vdist(playerX, playerY, playerZ, v.x, v.y, v.z) < 3.0) then
				if pillCount > 1 then
					TriggerEvent("chatMessage", "", {255, 0, 0}, "There are currently no more Z-Pills to take at this time.")
				end
				if pillCount == 0 then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to use Z-Pills.")
					if IsControlJustReleased(1, 51) then
						--Citizen.Trace("Player entered greenzone")
						DecorSetFloat(PlayerPedId(), "infection", 0)
						pillCount = pillCount + 1
					end
				end
			end
		end
	end
end)

-- Z-Pills Blips
Citizen.CreateThread(function()
	for _, map in pairs(pillAreas) do
		map.blip = AddBlipForCoord(map.x, map.y, map.z)
		SetBlipSprite(map.blip, 51)
		SetBlipAsShortRange(map.blip, true)
		SetBlipAlpha(map.blip, 255)
		SetBlipScale(map.blip, 0.99)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Z-Pills Area")
		EndTextCommandSetBlipName(map.blip)
	end
end)