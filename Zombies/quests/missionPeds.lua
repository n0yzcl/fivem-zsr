local injuredPeds = {
	"a_m_y_hiker_01"
}

local jesusPeds = {
	"u_m_m_jesus_01"
}

local tomPeds = {
	"s_m_y_grip_01",
}

local jimmyPeds = {
	"s_m_y_robber_01"
}

local firstspawn = false

injuredpeds = {}
jesuspeds = {}
tompeds = {}
jimmypeds = {}
markped = {}
zinnped = {}
jasonped = {}
douglasped = {}

-- Injured Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		SpawnInjured()
		
		injuredpedX, injuredpedY, injuredPedZ = table.unpack(GetEntityCoords(injuredPed, true))
		playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
		if(Vdist(playerX, playerY, playerZ, injuredpedX, injuredpedY, injuredpedZ) < 25.0)then		
			DrawText3d(injuredpedX, injuredpedY, injuredPedZ + 1, 0.5, 0, "[An Injured Survivor]", 255, 255, 255, false)
		end
	end
end)

-- Jesus Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		SpawnJesus()
		
		jesusX, jesusY, jesusZ = table.unpack(GetEntityCoords(Jesus, true))	
		playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
		if(Vdist(playerX, playerY, playerZ, jesusX, jesusY, jesusZ) < 25.0)then	
			DrawText3d(jesusX, jesusY, jesusZ + 1, 0.5, 0, "[Jesus]", 255, 255, 255, false)
		end
	end
end)

-- Jimmy Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		SpawnJimmy()
		
		jimmyX, jimmyY, jimmyZ = table.unpack(GetEntityCoords(Jimmy, true))
		playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
		if(Vdist(playerX, playerY, playerZ, jimmyX, jimmyY, jimmyZ) < 25.0)then	
			DrawText3d(jimmyX, jimmyY, jimmyZ + 1, 0.5, 0, "[Jimmy Philips]", 255, 255, 255, false)
		end
	end
end)

-- Tom Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		SpawnTom()
		
		tomX, tomY, tomZ = table.unpack(GetEntityCoords(Tom, true))	
		playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
		if(Vdist(playerX, playerY, playerZ, tomX, tomY, tomZ) < 25.0)then			
			DrawText3d(tomX, tomY, tomZ + 1, 0.5, 0, "[Tom Jaredson]", 255, 255, 255, false)
		end
	end
end)

-- Mark Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		SpawnMark()
		
		markX, markY, markZ = table.unpack(GetEntityCoords(Mark, true))
		playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
		if(Vdist(playerX, playerY, playerZ, markX, markY, markZ) < 25.0)then	
			DrawText3d(markX, markY, markZ + 1, 0.5, 0, "[Mark Theodore]", 255, 255, 255, false)
		end
	end
end)

-- Zinn Looter Leader Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		SpawnZinn()
		
		zinnX, zinnY, zinnZ = table.unpack(GetEntityCoords(Zinn, true))
		playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
		if(Vdist(playerX, playerY, playerZ, zinnX, zinnY, zinnZ) < 25.0)then			
			DrawText3d(zinnX, zinnY, zinnZ + 1, 0.5, 0, "[Zinn Jaredson]", 255, 0, 0, false)
		end
	end
end)

-- Jason Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		SpawnJason()
		
		jasonX, jasonY, jasonZ = table.unpack(GetEntityCoords(Jason, true))
		playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
		if(Vdist(playerX, playerY, playerZ, jasonX, jasonY, jasonZ) < 25.0)then	
			DrawText3d(jasonX, jasonY, jasonZ + 1, 0.5, 0, "[Jason Marcus]", 255, 255, 255, false)
		end
	end
end)

-- Douglas Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		SpawnDouglas()
		
		dougX, dougY, dougZ = table.unpack(GetEntityCoords(Douglas, true))
		playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
		if(Vdist(playerX, playerY, playerZ, dougX, dougY, dougZ) < 25.0)then	
			DrawText3d(dougX, dougY, dougZ + 1, 0.5, 0, "[Douglas Martin]", 255, 255, 255, false)
		end
	end
end)

-- Spawn injured Civilians (Mission peds)
function SpawnInjured()
	--if NetworkIsHost() then
		--if NetworkIsPlayerConnected(PlayerId()) then
			if firstspawn == false then
										
					injuredped = injuredPeds[math.random(1, #injuredPeds)]
					injuredped = string.upper(injuredped)
					RequestModel(GetHashKey(injuredped))
					while not HasModelLoaded(GetHashKey(injuredped)) or not HasCollisionForModelLoaded(GetHashKey(injuredped)) do
						Citizen.Wait(1)
					end
					
					
					AddRelationshipGroup("injured")
					SetRelationshipBetweenGroups(0, GetHashKey("injured"), GetHashKey("PLAYER"))
					SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("injured"))
					
					injuredPed = CreatePed(4, GetHashKey(injuredped), 1691.59, 3586.49, 34.62, 29.48, false, false)
					SetPedFleeAttributes(injuredPed, 0, 0)
					SetPedCombatAttributes(injuredPed, 46, 1)
					SetPedCombatAttributes(injuredPed, 1424, 0)
					SetPedCombatAttributes(injuredPed, 5, 1)
					SetPedCombatRange(injuredPed, 2)
					SetPedRelationshipGroupHash(injuredPed, GetHashKey("injured"))
					SetPedAccuracy(injuredPed, 100)
					SetPedSeeingRange(injuredPed, 100.0)
					SetPedHearingRange(injuredPed, 1000.0)
					SetEntityHeading(injuredPed, 237)
					SetEntityInvincible(injuredPed, true) -- Keep entity from being killed
					SetPedCanRagdoll(injuredPed, false) -- Keeps ped from reacting to shots or melee
					SetEntityDynamic(injuredPed, true) -- False Keeps ped static
					SetEntityAsMissionEntity(injuredPed, true, true) -- Set ped as mission related
					SetEntityMaxSpeed(injuredPed, 0.00) -- True Freezes peds position
					FreezeEntityPosition(injuredPed, true)
					--GiveWeaponToPed(injuredPed, GetHashKey("WEAPON_CARBINERIFLE"), 9999, true, true)
					
					playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					injuredpedX, injuredpedY, injuredPedZ = table.unpack(GetEntityCoords(injuredPed, true))
										
					RequestAnimSet("move_m@injured")
					while not HasAnimSetLoaded("move_m@injured") do
						Citizen.Wait(1)
					end
					SetPedMovementClipset(injuredPed, "move_m@injured", 1.0)
					ApplyPedDamagePack(injuredPed,"BigHitByVehicle", 0.0, 9.0)
					table.insert(injuredpeds, injuredPed)
					
					firstspawn = true
			end
					
				for i, injuredPed in pairs(injuredpeds) do
					if not DoesEntityExist(injuredPed) then
						table.remove(injuredpeds, i)
					end
						
					SetPedFleeAttributes(injuredPed, 0, 0)
					SetPedCombatAttributes(injuredPed, 46, 1)
					SetPedCombatAttributes(injuredPed, 1424, 0)
					SetPedCombatAttributes(injuredPed, 5, 1)
					SetPedCombatRange(injuredPed, 2)
					SetPedRelationshipGroupHash(injuredPed, GetHashKey("injured"))
					SetPedAccuracy(injuredPed, 100)
					SetPedSeeingRange(injuredPed, 100.0)
					SetPedHearingRange(injuredPed, 1000.0)
					SetEntityHeading(injuredPed, 237)
					SetEntityInvincible(injuredPed, true) -- Keep entity from being killed
					SetPedCanRagdoll(injuredPed, false) -- Keeps ped from reacting to shots or melee
					SetEntityDynamic(injuredPed, true) -- False Keeps ped static
					SetEntityAsMissionEntity(injuredPed, true, true) -- Set ped as mission related
					SetEntityMaxSpeed(injuredPed, 0.00) -- True Freezes peds position
					FreezeEntityPosition(injuredPed, true)
				end
		--end
	--end
end

-- Spawn Jesus looking guy
function SpawnJesus()
	--if NetworkIsHost() then
		--if NetworkIsPlayerConnected(PlayerId()) then
			if firstspawn == false then
		
				for i, Jesus in pairs(jesuspeds) do
					if not DoesEntityExist(Jesus) then
						table.remove(jesuspeds, i)
					end
				end
								
					jesus = jesusPeds[math.random(1, #jesusPeds)]
					jesus = string.upper(jesus)
					RequestModel(GetHashKey(jesus))
					while not HasModelLoaded(GetHashKey(jesus)) or not HasCollisionForModelLoaded(GetHashKey(jesus)) do
						Citizen.Wait(1)
					end
					
					
					AddRelationshipGroup("Jesus")
					SetRelationshipBetweenGroups(0, GetHashKey("Jesus"), GetHashKey("PLAYER"))
					SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("Jesus"))
					
					Jesus = CreatePed(4, GetHashKey(jesus), 1858.13, 3854.10, 32.08, 0.0, false, false)
					SetPedFleeAttributes(Jesus, 0, 0)
					SetPedCombatAttributes(Jesus, 46, 1)
					SetPedCombatAttributes(Jesus, 1424, 0)
					SetPedCombatAttributes(Jesus, 5, 1)
					SetPedCombatRange(Jesus, 2)
					SetPedRelationshipGroupHash(Jesus, GetHashKey("Jesus"))
					SetPedAccuracy(Jesus, 100)
					SetPedSeeingRange(Jesus, 100.0)
					SetPedHearingRange(Jesus, 1000.0)
					SetEntityHeading(Jesus, 237)
					SetEntityInvincible(Jesus, true) -- Keep entity from being killed
					SetPedCanRagdoll(Jesus, false) -- Keeps ped from reacting to shots or melee
					SetEntityDynamic(Jesus, true) -- False Keeps ped static
					SetEntityAsMissionEntity(Jesus, true, true) -- Set ped as mission related
					SetEntityMaxSpeed(Jesus, 0.00) -- True Freezes peds position
					--GiveWeaponToPed(Jesus, GetHashKey("WEAPON_CARBINERIFLE"), 9999, true, true)
					table.insert(jesuspeds, Jesus)
					
					firstspawn = true
			end
		--end
	--end
end

-- Spawn Tom Jaredson
function SpawnTom()
	--if NetworkIsHost() then
		--if NetworkIsPlayerConnected(PlayerId()) then
			if firstspawn == false then
		
				for i, Tom in pairs(tompeds) do
					if not DoesEntityExist(Tom) then
						table.remove(tompeds, i)
					end
				end
								
					tom = tomPeds[math.random(1, #tomPeds)]
					tom = string.upper(tom)
					RequestModel(GetHashKey(tom))
					while not HasModelLoaded(GetHashKey(tom)) or not HasCollisionForModelLoaded(GetHashKey(tom)) do
						Citizen.Wait(1)
					end
					
					
					AddRelationshipGroup("Tom")
					SetRelationshipBetweenGroups(0, GetHashKey("Tom"), GetHashKey("PLAYER"))
					SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("Tom"))
					
					Tom = CreatePed(4, GetHashKey(tom), 1867.07, 3843.71, 31.48, 0.0, false, false)
					SetPedFleeAttributes(Tom, 0, 0)
					SetPedCombatAttributes(Tom, 46, 1)
					SetPedCombatAttributes(Tom, 1424, 0)
					SetPedCombatAttributes(Tom, 5, 1)
					SetPedCombatRange(Tom, 2)
					SetPedRelationshipGroupHash(Tom, GetHashKey("Tom"))
					SetPedAccuracy(Tom, 100)
					SetPedSeeingRange(Tom, 100.0)
					SetPedHearingRange(Tom, 1000.0)
					SetEntityHeading(Tom, 237)
					SetEntityInvincible(Tom, true) -- Keep entity from being killed
					SetPedCanRagdoll(Tom, false) -- Keeps ped from reacting to shots or melee
					SetEntityDynamic(Tom, true) -- False Keeps ped static
					SetEntityAsMissionEntity(Tom, true, true) -- Set ped as mission related
					SetEntityMaxSpeed(Tom, 0.00) -- True Freezes peds position
					--GiveWeaponToPed(injuredPed, GetHashKey("WEAPON_CARBINERIFLE"), 9999, true, true)
					table.insert(tompeds, Tom)
					
					firstspawn = true
			end
		--end
	--end
end

-- Spawn Jimmy NPC
function SpawnJimmy()
	--if NetworkIsHost() then
		--if NetworkIsPlayerConnected(PlayerId()) then
			if firstspawn == false then
		
				for i, Jimmy in pairs(jimmypeds) do
					if not DoesEntityExist(Jimmy) then
						table.remove(jimmypeds, i)
					end
				end
								
					jimmy = jimmyPeds[math.random(1, #jimmyPeds)]
					jimmy = string.upper(jimmy)
					RequestModel(GetHashKey(jimmy))
					while not HasModelLoaded(GetHashKey(jimmy)) or not HasCollisionForModelLoaded(GetHashKey(jimmy)) do
						Citizen.Wait(1)
					end
					
					
					AddRelationshipGroup("Jimmy")
					SetRelationshipBetweenGroups(0, GetHashKey("Jimmy"), GetHashKey("PLAYER"))
					SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("Jimmy"))
					
					Jimmy = CreatePed(4, GetHashKey(jimmy), 2340.64, 3126.45, 47.20, 0.0, false, false)
					SetPedFleeAttributes(Jimmy, 0, 0)
					SetPedCombatAttributes(Jimmy, 46, 1)
					SetPedCombatAttributes(Jimmy, 1424, 0)
					SetPedCombatAttributes(Jimmy, 5, 1)
					SetPedCombatRange(Jimmy, 2)
					SetPedRelationshipGroupHash(Jimmy, GetHashKey("Jimmy"))
					SetPedAccuracy(Jimmy, 100)
					SetPedSeeingRange(Jimmy, 100.0)
					SetPedHearingRange(Jimmy, 1000.0)
					SetEntityHeading(Jimmy, 237)
					SetEntityInvincible(Jimmy, true) -- Keep entity from being killed
					SetPedCanRagdoll(Jimmy, false) -- Keeps ped from reacting to shots or melee
					SetEntityDynamic(Jimmy, true) -- False Keeps ped static
					SetEntityAsMissionEntity(Jimmy, true, true) -- Set ped as mission related
					SetEntityMaxSpeed(Jimmy, 0.00) -- True Freezes peds position
					--GiveWeaponToPed(Jimmy, GetHashKey("WEAPON_CARBINERIFLE"), 9999, true, true)
					table.insert(jimmypeds, Jimmy)
					
					firstspawn = true
			end
		--end
	--end
end

-- Spawns Mark NPC
function SpawnMark()
	--if NetworkIsHost() then
		--if NetworkIsPlayerConnected(PlayerId()) then
				if firstspawn == false then
			
					for i, Mark in pairs(markped) do
						if not DoesEntityExist(Mark) then
							table.remove(markped, i)
						end
					end
									
						RequestModel(GetHashKey("a_m_m_farmer_01"))
						while not HasModelLoaded(GetHashKey("a_m_m_farmer_01")) or not HasCollisionForModelLoaded(GetHashKey("a_m_m_farmer_01")) do
							Citizen.Wait(1)
						end
						
						
						AddRelationshipGroup("Mark")
						SetRelationshipBetweenGroups(0, GetHashKey("Mark"), GetHashKey("PLAYER"))
						SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("Mark"))
						
						Mark = CreatePed(4, GetHashKey("a_m_m_farmer_01"), 2453.10, 4945.23, 44.12, 0.0, false, false)
						SetPedFleeAttributes(Mark, 0, 0)
						SetPedCombatAttributes(Mark, 46, 1)
						SetPedCombatAttributes(Mark, 1424, 0)
						SetPedCombatAttributes(Mark, 5, 1)
						SetPedCombatRange(Mark, 2)
						SetPedRelationshipGroupHash(Mark, GetHashKey("Mark"))
						SetPedAccuracy(Mark, 100)
						SetPedSeeingRange(Mark, 100.0)
						SetPedHearingRange(Mark, 1000.0)
						SetEntityHeading(Mark, 237)
						SetEntityInvincible(Mark, true) -- Keep entity from being killed
						SetPedCanRagdoll(Mark, false) -- Keeps ped from reacting to shots or melee
						SetEntityDynamic(Mark, true) -- False Keeps ped static
						SetEntityAsMissionEntity(Mark, true, true) -- Set ped as mission related
						SetEntityMaxSpeed(Mark, 0.00) -- True Freezes peds position
						--GiveWeaponToPed(Mark, GetHashKey("WEAPON_CARBINERIFLE"), 9999, true, true)
						table.insert(markped, Mark)
						
						firstspawn = true
				end
		--end
	--end
end

-- Spawns Zinn Looter Leader NPC
function SpawnZinn()
		if firstspawn == false then
			
			for i, Zinn in pairs(zinnped) do
				if not DoesEntityExist(Zinn) then
					table.remove(zinnped, i)
				end
			end
									
				RequestModel(GetHashKey("a_m_m_trampbeac_01"))
				while not HasModelLoaded(GetHashKey("a_m_m_trampbeac_01")) or not HasCollisionForModelLoaded(GetHashKey("a_m_m_trampbeac_01")) do
					Citizen.Wait(1)
				end
						
						
				AddRelationshipGroup("Zinn")
				SetRelationshipBetweenGroups(5, GetHashKey("Zinn"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("Zinn"))
						
				Zinn = CreatePed(4, GetHashKey("a_m_m_trampbeac_01"), 715.92, 111.82, 79.95, 0.0, false, false)
				SetPedFleeAttributes(Zinn, 0, 0)
				SetPedCombatAttributes(Zinn, 46, 1)
				SetPedCombatAttributes(Zinn, 1424, 0)
				SetPedCombatAttributes(Zinn, 5, 1)
				SetPedCombatRange(Zinn, 2)
				SetPedRelationshipGroupHash(Zinn, GetHashKey("Zinn"))
				SetPedAccuracy(Zinn, 100)
				SetPedSeeingRange(Zinn, 100.0)
				SetPedHearingRange(Zinn, 1000.0)
				SetEntityHeading(Zinn, 237)
				SetEntityMaxHealth(Zinn, 200)
				SetEntityHealth(Zinn, 200)
				SetEntityInvincible(Zinn, false)
				SetPedCanRagdoll(Zinn, true) -- Keeps ped from reacting to shots or melee
				SetEntityDynamic(Zinn, true) -- False Keeps ped static
				SetEntityAsMissionEntity(Zinn, true, true) -- Set ped as mission related
				SetEntityMaxSpeed(Zinn, 0.00) -- True Freezes peds position
				GiveWeaponToPed(Zinn, GetHashKey("WEAPON_ASSAULTRIFLE"), 9999, true, true)
				table.insert(zinnped, Zinn)
				
				firstspawn = true
		end
end

-- Spawns Jason NPC
function SpawnJason()
	--if NetworkIsHost() then
		--if NetworkIsPlayerConnected(PlayerId()) then
				if firstspawn == false then
			
					for i, Jason in pairs(jasonped) do
						if not DoesEntityExist(Jason) then
							table.remove(jasonped, i)
						end
					end
									
						RequestModel(GetHashKey("g_m_m_chicold_01"))
						while not HasModelLoaded(GetHashKey("g_m_m_chicold_01")) or not HasCollisionForModelLoaded(GetHashKey("g_m_m_chicold_01")) do
							Citizen.Wait(1)
						end
						
						
						AddRelationshipGroup("Jason")
						SetRelationshipBetweenGroups(0, GetHashKey("Jason"), GetHashKey("PLAYER"))
						SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("Jason"))
						
						Jason = CreatePed(4, GetHashKey("g_m_m_chicold_01"), 2664.15, 3520.20, 51.73, 0.0, false, false)
						SetPedFleeAttributes(Jason, 0, 0)
						SetPedCombatAttributes(Jason, 46, 1)
						SetPedCombatAttributes(Jason, 1424, 0)
						SetPedCombatAttributes(Jason, 5, 1)
						SetPedCombatRange(Jason, 2)
						SetPedRelationshipGroupHash(Jason, GetHashKey("Jason"))
						SetPedAccuracy(Jason, 100)
						SetPedSeeingRange(Jason, 100.0)
						SetPedHearingRange(Jason, 1000.0)
						SetEntityHeading(Jason, 237)
						SetEntityInvincible(Jason, true) -- Keep entity from being killed
						SetPedCanRagdoll(Jason, false) -- Keeps ped from reacting to shots or melee
						SetEntityDynamic(Jason, true) -- False Keeps ped static
						SetEntityAsMissionEntity(Jason, true, true) -- Set ped as mission related
						SetEntityMaxSpeed(Jason, 0.00) -- True Freezes peds position
						--GiveWeaponToPed(Jason, GetHashKey("WEAPON_CARBINERIFLE"), 9999, true, true)
						table.insert(jasonped, Jason)
						
						firstspawn = true
				end
		--end
	--end
end

-- Spawns Douglas NPC
function SpawnDouglas()
	--if NetworkIsHost() then
		--if NetworkIsPlayerConnected(PlayerId()) then
				if firstspawn == false then
			
					for i, Douglas in pairs(douglasped) do
						if not DoesEntityExist(Douglas) then
							table.remove(douglasped, i)
						end
					end
									
					RequestModel(GetHashKey("s_m_m_armoured_02"))
					while not HasModelLoaded(GetHashKey("s_m_m_armoured_02")) or not HasCollisionForModelLoaded(GetHashKey("s_m_m_armoured_02")) do
						Citizen.Wait(1)
					end
						
						
						AddRelationshipGroup("Douglas")
						SetRelationshipBetweenGroups(0, GetHashKey("Douglas"), GetHashKey("PLAYER"))
						SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("Douglas"))
						
						Douglas = CreatePed(4, GetHashKey("s_m_m_armoured_02"), 2446.24, 4956.91, 44.52, 0.0, false, false)
						SetPedFleeAttributes(Douglas, 0, 0)
						SetPedCombatAttributes(Douglas, 46, 1)
						SetPedCombatAttributes(Douglas, 1424, 0)
						SetPedCombatAttributes(Douglas, 5, 1)
						SetPedCombatRange(Douglas, 2)
						SetPedRelationshipGroupHash(Douglas, GetHashKey("Douglas"))
						SetPedAccuracy(Douglas, 100)
						SetPedSeeingRange(Douglas, 100.0)
						SetPedHearingRange(Douglas, 1000.0)
						SetEntityHeading(Douglas, 237)
						SetEntityInvincible(Douglas, true) -- Keep entity from being killed
						SetPedCanRagdoll(Douglas, false) -- Keeps ped from reacting to shots or melee
						SetEntityDynamic(Douglas, true) -- False Keeps ped static
						SetEntityAsMissionEntity(Douglas, true, true) -- Set ped as mission related
						SetEntityMaxSpeed(Douglas, 0.00) -- True Freezes peds position
						--GiveWeaponToPed(Douglas, GetHashKey("WEAPON_CARBINERIFLE"), 9999, true, true)
						table.insert(douglasped, Douglas)
						
						firstspawn = true
				end
		--end
	--end
end

-- Handles 3D Text above AI
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