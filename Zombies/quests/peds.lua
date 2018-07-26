local militiaPeds = {
	"s_m_y_blackops_01"
}

local localPlayerId = PlayerId()
local serverId = GetPlayerServerId(localPlayerId)
local firstspawn = false

militiapeds = {}

-- Spawn Militia Ped #1
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		--if NetworkIsHost() then
			--if NetworkIsPlayerConnected(PlayerId()) then
				if firstspawn == false then
				
					if not DoesEntityExist(guardPed) then
						table.remove(militiapeds, i)
					end
							
					militiaPed = militiaPeds[math.random(1, #militiaPeds)]
					militiaPed = string.upper(militiaPed)
					RequestModel(GetHashKey(militiaPed))
					while not HasModelLoaded(GetHashKey(militiaPed)) or not HasCollisionForModelLoaded(GetHashKey(militiaPed)) do
						Citizen.Wait(1)
					end
					
					AddRelationshipGroup("militia")
					SetRelationshipBetweenGroups(0, GetHashKey("militia"), GetHashKey("PLAYER"))
					SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("militia"))
					SetRelationshipBetweenGroups(5, GetHashKey("militia"), GetHashKey("zombeez"))
					
					guardPed = CreatePed(4, GetHashKey(militiaPed), 2489.76, 4952.66, 47.13, 237, false, false)
					SetPedFleeAttributes(guardPed, 0, 0)
					SetPedCombatAttributes(guardPed, 46, 1)
					SetPedCombatAttributes(guardPed, 1424, 0)
					SetPedCombatAttributes(guardPed, 5, 1)
					SetPedCombatRange(guardPed, 2)
					SetPedRelationshipGroupHash(guardPed, GetHashKey("militia"))
					SetPedAccuracy(guardPed, 100)
					SetPedSeeingRange(guardPed, 100.0)
					SetPedHearingRange(guardPed, 1000.0)
					SetEntityHeading(guardPed, 237)
					SetEntityInvincible(guardPed, true) -- Keep entity from being killed
					SetPedCanRagdoll(guardPed, false) -- Keeps ped from reacting to shots or melee
					SetEntityDynamic(guardPed, true) -- False Keeps ped static
					SetEntityAsMissionEntity(guardPed, true, true) -- Set ped as mission related
					SetEntityMaxSpeed(guardPed, 0.00) -- True Freezes peds position
					GiveWeaponToPed(guardPed, GetHashKey("WEAPON_CARBINERIFLE"), 9999, true, true)
					
					table.insert(militiapeds, guardPed)
					firstspawn = true
				end
			--end
	end
end)

-- Spawn Militia Ped #2
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		--if NetworkIsHost() then
			--if NetworkIsPlayerConnected(PlayerId()) then
				if firstspawn == false then
			
					if not DoesEntityExist(guardPed2) then
						table.remove(militiapeds, i)
					end
							
					militiaPed2 = militiaPeds[math.random(1, #militiaPeds)]
					militiaPed2 = string.upper(militiaPed2)
					RequestModel(GetHashKey(militiaPed2))
					while not HasModelLoaded(GetHashKey(militiaPed2)) or not HasCollisionForModelLoaded(GetHashKey(militiaPed2)) do
						Citizen.Wait(1)
					end
					
					AddRelationshipGroup("militia")
					SetRelationshipBetweenGroups(0, GetHashKey("militia"), GetHashKey("PLAYER"))
					SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("militia"))
					SetRelationshipBetweenGroups(5, GetHashKey("militia"), GetHashKey("zombeez"))
					
					guardPed2 = CreatePed(4, GetHashKey(militiaPed2), 2327.44, 3128.95, 50.44, 0, false, false)
					SetPedFleeAttributes(guardPed2, 0, 0)
					SetPedCombatAttributes(guardPed2, 46, 1)
					SetPedCombatAttributes(guardPed2, 1424, 0)
					SetPedCombatAttributes(guardPed2, 5, 1)
					SetPedCombatRange(guardPed2, 2)
					SetPedRelationshipGroupHash(guardPed2, GetHashKey("militia"))
					SetPedAccuracy(guardPed2, 100)
					SetPedSeeingRange(guardPed2, 100.0)
					SetPedHearingRange(guardPed2, 1000.0)
					SetEntityHeading(guardPed2, 237)
					SetEntityInvincible(guardPed2, true) -- Keep entity from being killed
					SetPedCanRagdoll(guardPed2, false) -- Keeps ped from reacting to shots or melee
					SetEntityDynamic(guardPed2, true) -- False Keeps ped static
					SetEntityAsMissionEntity(guardPed2, true, true) -- Set ped as mission related
					SetEntityMaxSpeed(guardPed2, 0.00) -- True Freezes peds position
					GiveWeaponToPed(guardPed2, GetHashKey("WEAPON_CARBINERIFLE"), 9999, true, true)
					
					table.insert(militiapeds, guardPed2)
					firstspawn = true
				end
			--end
	end
end)