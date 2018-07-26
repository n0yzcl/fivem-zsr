local ambientZones = {
	{x= 1848.54, y= 3690.25, z= 34.26},
	--{x= 460.54, y= -990.66, z= 30.68},
}

playingsound = false
inRange = false

-- Handles when to play sound based on range
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
        for k,v in ipairs(ambientZones) do
            playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			farDistance = Vdist(playerX, playerY, playerZ, v.x, v.y, v.z) > 10.0
			closeDistance = Vdist(playerX, playerY, playerZ, v.x, v.y, v.z) < 10.0
            if farDistance then
				if (playingsound) then
                    volume = 0.0
                    Citizen.Trace("Volume down")
					StopAmbience()
                    inRange = false
					playingsound = false
				end
            elseif closeDistance then
				if not (playingsound) then
					Citizen.Trace("Volume up")
					playingsound = true
					volume = 0.25
					PlayAmbience()
					inRange = true
				end
            end
        end
    end
end)


function PlayAmbience()
	SendNUIMessage({
		playsound = "zombiedoorbang.ogg",
		soundvolume = volume
	})
end

function StopAmbience()
	SendNUIMessage({
		stopsound = "zombiedoorbang.ogg",
	})
end