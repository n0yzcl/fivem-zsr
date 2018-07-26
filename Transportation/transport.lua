local transportCoords = {
	{name="Junkyard Safezone", x=2334.3840332031, y=3142.8776855469, z=48.206085205078}, 
	{name="Grapeseed Safezone", x=2476.564453125, y=4947.8588867188, z=45.012302398682}, 
	{name="City Safezone", x=118.87306213379, y=-1052.7121582031, z=29.192356109619}, 
}

transportCount = 0
order = 1

-- Reset transport count every minute
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1 * 60000)
		transportCount = 0
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
        for k,v in ipairs(transportCoords) do
            if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 20.0)then
                DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5001, 255, 255, 0,165, 0, 0, 0,0)
				DrawText3d(v.x, v.y, v.z + 1, 0.5, 0, "Transport to another safe zone", 255, 255, 255, false)
				if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0)then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to go to another safezone.")
					if IsControlJustReleased(1, 51) then
						if transportCount > 0 then
							TriggerEvent('chatMessage', "^1TRANSPORT", {255, 255, 255}, "You must wait a minute before transporting again.")
						else
							transportCount = transportCount + 1
							--randomSafezone = transportCoords[math.random(1, #transportCoords)]
							local currentSafezone = transportCoords[order]
							if order == #transportCoords then
								order = 1
							else
								order = order + 1
							end
							SetEntityCoords(PlayerPedId(), currentSafezone.x, currentSafezone.y, currentSafezone.z, 1, 0, 0, 1)
							TriggerEvent('chatMessage', "^2TRANSPORT", {255, 255, 255}, "Transported to  " ..currentSafezone.name)
						end
					end
				end
			end
		end
	end
end)
				
				
-- Handles 3D Text
function DrawText3d(x,y,z, size, font, text, r, g, b, outline)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
	
	if onScreen then
		SetTextScale(size*scale, size*scale)
		SetTextFont(font)
		SetTextProportional(1)
		SetTextColour(r, g, b, 255)
		if not outline then
			SetTextDropshadow(0, 0, 0, 0, 55)
			SetTextEdge(2, 0, 0, 0, 150)
			SetTextDropShadow()
			SetTextOutline()
		end
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		SetDrawOrigin(x,y,z, 0)
		DrawText(0.0, 0.0)
		ClearDrawOrigin()
	end
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end