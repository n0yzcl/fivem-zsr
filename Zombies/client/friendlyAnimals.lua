---- Original author of RottenV 3.0: Mr.Scammer
---- Some code used from Zombiespawner and converted to work as animals
---- Edited fully by Cody196
---- Some pieces of code put in place by Cody196


local animalmodelhash = {
	0xD86B5A95, -- Deer
	0xFCFA9E1E, -- Cow
	0xCE5FF074, -- Boar
	0xB11BAB56, -- Pig
	0xC3B52966, -- Rat
}
-- Total count of hashes for animalmodelhash
local hashTotal = 5
-- Determines maximum amount of animals per client
local maxAnimals = 10
-- Determines how far animals have to be from player to despawn
local despawnDistance = 250
-- Determines how far away from the player until animals can spawn
local minSpawnDistance = 50
-- Determines the maximum spawn radius animals can spawn around the player
local maxSpawnRadius = 250

--The Main Code--
players = {}

RegisterNetEvent("Z:playerUpdate")
AddEventHandler("Z:playerUpdate", function(mPlayers)
	players = mPlayers
end)

animals = {}

Citizen.CreateThread(function()
	AddRelationshipGroup("animals")
	SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("animals"))
	
	while true do
		Citizen.Wait(1)
		-- spawn animals
		AnimalSpawner()
				
		for i, animal in pairs(animals) do
			if not DoesEntityExist(animal) then
				table.remove(animals, i)
			end
			
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			pedX, pedY, pedZ = table.unpack(GetEntityCoords(animal, true))
			if IsPedDeadOrDying(animal, 1) then
				if(Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) < 3.0)then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to harvest animal.")
					if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
						if DoesEntityExist(GetPlayerPed(-1)) then
							RequestAnimDict("pickup_object")
							while not HasAnimDictLoaded("pickup_object") do
							Citizen.Wait(10)
							end
							TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8, -1, 49, 0, 0, 0, 0)
							rawMeat = rawMeat + 1
							Citizen.Wait(2000)
							ClearPedSecondaryTask(GetPlayerPed(-1))
							DeleteEntity(animal)
							table.remove(animals, i)
							ShowNotification("You harvested raw meat from dead animal")
						end
					end
				end
			end
			
			if IsPedDeadOrDying(animal, 1) then
				if(Vdist(playerX, playerY, playerZ, pedX, pedY, pedZ) > 75.0)then
					DeleteEntity(animal)
					table.remove(animals, i)
				end
			else
				playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				pedX, pedY = table.unpack(GetEntityCoords(animal, true))

				if pedX < playerX - despawnDistance or pedX > playerX + despawnDistance or pedY < playerY - despawnDistance or pedY > playerY + despawnDistance then
					-- Set animal as no longer needed for despawning
					Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(animal))
					table.remove(animals, i)
				end
			end
		end
	end
end)

function AnimalSpawner()
	if #animals < maxAnimals then
		x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			
		-- load all the skins 
		for i, skinhash in pairs(animalmodelhash) do
			RequestModel(skinhash)
			while not HasModelLoaded(skinhash) do
				Citizen.Wait(100)
			end
		end
		
		repeat
			Citizen.Wait(1)

			newX = x + math.random(-maxSpawnRadius, maxSpawnRadius)
			newY = y + math.random(-maxSpawnRadius, maxSpawnRadius)

			--for _, player in pairs(players) do
			player = PlayerId()
				Citizen.Wait(1)
				playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(player), true))
				if newX > playerX - minSpawnDistance and newX < playerX + minSpawnDistance or newY > playerY - minSpawnDistance and newY < playerY + minSpawnDistance then
					canSpawn = false
					break
				else
					canSpawn = true
				end
			--end
		until canSpawn
		

		-- set a random skin
		hashint = math.random(1, hashTotal)
		animal = CreatePed(28, animalmodelhash[hashint], newX, newY, z - 500, 0.0, false, false)
		
		--Citizen.Trace("Animal Spawned")
		
		-- Adds the blips for Zombies
		--SetEntityCoords(entity, X, Y, Z, xAxis, yAxis, zAxis, p7)
		blip = AddBlipForEntity(animal)
		SetBlipSprite(blip, 141)
		SetBlipAsShortRange(blip, true)
		
		SetPedSeeingRange(animal, 50.0)
		SetPedHearingRange(animal, 150.0)
		SetPedFleeAttributes(animal, 1, 1)
		SetPedRelationshipGroupHash(animal, GetHashKey("animals"))
		SetPedDiesInWater(animal, true)
		SetPedDiesWhenInjured(animal, true)
		
		x, y, z = table.unpack(GetEntityCoords(animal, true))
		TaskWanderStandard(animal, 1.0, 10)
		
		table.insert(animals, animal)
	end
end


function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end


function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end