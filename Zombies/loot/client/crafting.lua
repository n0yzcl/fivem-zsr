crafting = false
inventory = false
GUIOpen = false
dataloaded = false
dataChecked = false

ESX = {}

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(1)
  end
end)

clientVars = {
	-- Inventory Variables
	drinkItems = 0,
	foodItems = 0,
	bandages = 0,
	ductTape = 0,
	engineKit = 0,
	dirtyWater = 0,
	cleanWater = 0,
	cookedMeat = 0,
	rawMeat = 0,
	zCredits = 0,

	-- Crafting Variables
	emptyBottles = 0,
	woodMaterials = 0,
	scrapMetal = 0,
	scrapCloth = 0,
	gunPowder = 0,
	zBlood = 0,
	woodLogs = 0,
}

--TriggerServerEvent('CreateData', clientVars)

--[[Citizen.CreateThread(function()
	if dataChecked == false then
		TriggerServerEvent('checkServerData')
		dataChecked = true
	else
		TriggerServerEvent('CreateData', clientVars)
	end
end)--]]

function SyncToDatabase()
    TriggerServerEvent('CreateData', clientVars)
end

-- Arrays
campfires = {}

-- Load data after connecting
AddEventHandler('playerSpawned', function()
	TriggerServerEvent('loadData', clientVars)
	dataloaded = true
end)

-- Check whitelist
whitelisted = nil
AddEventHandler('playerSpawned', function(spawn)
    TriggerServerEvent('white')
end)
RegisterNetEvent('checkwhitelist')
AddEventHandler('checkwhitelist', function(whitelist) 

print(whitelisted)
whitelisted = whitelist
print('checked')



end)

--[[RegisterNetEvent("sendData")
AddEventHandler("sendData", function(rows)
	bandages = ['@bandages']
	cleanwater = ['@cleanwater']
end)--]]

-- Saves data to MySQL database every so often
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		TriggerServerEvent('saveData', clientVars)
	end
end)




Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsEntityDead(GetPlayerPed(-1)) then
			-- Remove old crafting materials
			clientVars.emptyBottles = 0
			clientVars.woodMaterials = 0
			clientVars.scrapMetal = 0
			clientVars.scrapCloth = 0
			clientVars.gunPowder = 0
			clientVars.zBlood = 0
			clientVars.woodLogs = 0
			
			-- Remove old inventory items
			clientVars.drinkItems = 0
			clientVars.foodItems = 0
			clientVars.bandages = 0
			clientVars.ductTape = 0
			clientVars.engineKit = 0
			clientVars.dirtyWater = 0
			clientVars.cleanWater = 0
			clientVars.cookedMeat = 0
			clientVars.rawMeat = 0
			clientVars.zCredits = 0
		end
	end
end)

-- Eat Food
RegisterCommand("eatfood", function(source,args,raw)
	if clientVars.foodItems > 0 then
		hunger = DecorGetFloat(PlayerPedId(), "hunger")
		randomHunger = math.random(5, 15)
		DecorSetFloat(PlayerPedId(), "hunger", hunger + randomHunger)
		clientVars.foodItems = clientVars.foodItems - 1
		TriggerEvent('chatMessage', "^1SYSTEM", {255, 255, 255}, "You ate some food.")
	else
		TriggerEvent('chatMessage', "^1SYSTEM", {255, 255, 255}, "You have no food to eat.")
	end
end)

-- Drink Bottles
RegisterCommand("drink", function(source,args,raw)
	if clientVars.drinkItems > 0 then
		thirst = DecorGetFloat(PlayerPedId(), "thirst")
		randomThirst = math.random(15, 30)
		DecorSetFloat(PlayerPedId(), "thirst", thirst + randomThirst)
		clientVars.drinkItems = clientVars.drinkItems - 1
		TriggerEvent('chatMessage', "^2SYSTEM", {255, 255, 255}, "You guzzled down your drink.")
	else
		TriggerEvent('chatMessage', "^1SYSTEM", {255, 255, 255}, "You have nothing to drink.")
	end
end)

-- Drink dirty water
RegisterCommand("drinkdirty", function(source,args,raw)
	if clientVars.dirtyWater > 0 then
		thirst = DecorGetFloat(PlayerPedId(), "thirst")
		illness = DecorGetFloat(PlayerPedId(), "illness")
		randomThirst = math.random(5, 15)
		DecorSetFloat(PlayerPedId(), "thirst", thirst + randomThirst)
		DecorSetFloat(PlayerPedId(), "illness", illness + 5)
		clientVars.dirtyWater = clientVars.dirtyWater - 1
		TriggerEvent('chatMessage', "^2SYSTEM", {255, 255, 255}, "You consumed dirty water.")
	else
		TriggerEvent('chatMessage', "^1SYSTEM", {255, 255, 255}, "You have no dirty water to drink.")
	end
end)

-- Drink purified water
RegisterCommand("drinkclean", function(source,args,raw)
	if clientVars.cleanWater > 0 then
		thirst = DecorGetFloat(PlayerPedId(), "thirst")
		randomThirst = math.random(25, 50)
		DecorSetFloat(PlayerPedId(), "thirst", thirst + randomThirst)
		clientVars.cleanWater = clientVars.cleanWater - 1
		TriggerEvent('chatMessage', "^2SYSTEM", {255, 255, 255}, "You consumed purified water.")
	else
		TriggerEvent('chatMessage', "^1SYSTEM", {255, 255, 255}, "You have no purified water to drink.")
	end
end)

-- Bandage up
RegisterCommand("heal", function(source,args,raw)
	if clientVars.bandages > 0 then
		health = GetEntityHealth(PlayerPedId())
		randomHealth = math.random(20, 40)
		if health < 200 then
			SetEntityHealth(PlayerPedId(), health + randomHealth)
			clientVars.scrapCloth = clientVars.scrapCloth - 1
			TriggerEvent('chatMessage', "^2SYSTEM", {255, 255, 255}, "You bandaged yourself up.")
		end
	else
		if clientVars.bandages == 0 then
			TriggerEvent('chatMessage', "^1SYSTEM", {255, 255, 255}, "You don't have any bandages or scrap cloth.")
		end
	end
end)

-- Repair engine
RegisterCommand("repair", function(source,args,raw)
	if clientVars.engineKit > 0 then
		health = GetEntityHealth(PlayerPedId())
		randomHealth = math.random(20, 40)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
			--vehicle = GetVehiclePedIsUsing(PlayerPedId())
			SetVehicleEngineHealth(vehicle, 1000)
			SetVehicleFixed(vehicle)
			clientVars.engineKit = clientVars.engineKit - 1
			TriggerEvent('chatMessage', "^2SYSTEM", {255, 255, 255}, "You repaired your engine.")
		else
			TriggerEvent('chatMessage', "^1SYSTEM", {255, 255, 255}, "You need to be in a vehicle to repair your engine.")
		end
	else
		if clientVars.engineKit == 0 then
			TriggerEvent('chatMessage', "^1SYSTEM", {255, 255, 255}, "You don't have any engine repair kits.")
		end
	end
end)

-- Craft bandages
RegisterCommand("bandage", function(source,args,raw)
	if clientVars.scrapCloth > 1 then
		clientVars.bandages = bandages + 1
		clientVars.scrapCloth = scrapCloth - 2
		TriggerEvent('chatMessage', "^2CRAFTED", {255, 255, 255}, "1 bandage.")
	else
		TriggerEvent('chatMessage', "^1REQUIRED MATERIALS", {255, 255, 255}, "2 scrap cloth.")
	end
end)

-- Craft landmine
RegisterCommand("landmine", function(source,args,raw)
	if clientVars.gunPowder > 24 and clientVars.ductTape > 0 and clientVars.scrapMetal > 1 then
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PROXMINE"), 1, false, false)
		clientVars.gunPowder = clientVars.gunPowder - 25
		clientVars.ductTape = clientVars.ductTape - 1
		clientVars.scrapMetal = clientVars.scrapMetal - 2
		TriggerEvent('chatMessage', "^2CRAFTED", {255, 255, 255}, "1 landmine.")
	else
		TriggerEvent('chatMessage', "^1REQUIRED MATERIALS", {255, 255, 255}, "25 gunPowder, 2 scrap metal, 1 duct tape.")
	end
end)

-- Craft dirty water
RegisterCommand("collectwater", function(source,args,raw)
	if clientVars.emptyBottles > 0 then
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			if not IsPedSwimming(PlayerPedId()) then
				if IsEntityInWater(PlayerPedId()) then
					clientVars.emptyBottles = clientVars.emptyBottles - 1
					clientVars.dirtyWater = clientVars.dirtyWater + 1
					TriggerEvent('chatMessage', '^2CRAFTED', {255,255,255}, "1 dirty water.")
				elseif not IsEntityInWater(PlayerPedId()) then
					TriggerEvent('chatMessage', '^1SYSTEM', {255,255,255}, "You need to find a water source such as a lake or pond first.")
				end
			end
		end
	else
		TriggerEvent('chatMessage', '^1REQUIRED MATERIALS', {255,255,255}, "1 empty bottle.")
	end
end)

-- Toggle Both Menus with key Bind
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if inventory == false and crafting == false then
			if IsControlJustPressed(1, 244) then
				inventory = true
				crafting = true
			end
		elseif inventory == true and crafting == true then
			if IsControlJustPressed(1, 244) then
				inventory = false
				crafting = false
			end
		end
	end
end)

-- Crafts a foundation
local prevfoundation = 0
RegisterCommand('foundation', function(source, args, rawCommand)
	if clientVars.scrapMetal > 74 then
		if prevfoundation > 0 then
			TriggerEvent('chatMessage', '^1SYSTEM', {255,255,255}, 'You can only have one foundation, delete your old one first.')
			--[[SetEntityAsMissionEntity(prevfoundation)
			DeleteObject(prevfoundation)
			prevfoundation = 0--]]
		elseif prevfoundation == 0 then
			local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, -1.02))
			local foundation = {
				'stt_prop_stunt_bowlpin_stand',
			}
			local randomint = math.random(1,1)
			local foundation = GetHashKey(foundation[randomint])
			local prop = CreateObject(foundation, x, y, z-3, true, false, true)
			SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
			FreezeEntityPosition(prop, true)
			prevfoundation = prop
			clientVars.scrapMetal = clientVars.scrapMetal - 75
			TriggerEvent('chatMessage', '^2CRAFTED', {255,255,255}, "1 foundation.")
		end
	else
		TriggerEvent('chatMessage', '^1REQUIRED MATERIALS', {255,255,255}, "75 scrap metal.")
	end
end, false)

-- Crafts a barricade
local prevbarricade = 0
RegisterCommand('barricade', function(source, args, rawCommand)
	if clientVars.woodMaterials > 7 then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.02))
		local barricade = {
			'prop_fncwood_03a',
			'prop_fncwood_07a',
			'prop_fncwood_16a',
		}
		local randomint = math.random(1,3)
		local barricade = GetHashKey(barricade[randomint])
		local prop = CreateObject(barricade, x, y, z, true, false, true)
		SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
		FreezeEntityPosition(prop, true)
		PlaceObjectOnGroundProperly(prop)
		prevbarricade = prop
		clientVars.woodMaterials = clientVars.woodMaterials - 8
		TriggerEvent('chatMessage', '^2CRAFTED', {255,255,255}, "1 barricade.")
	else
		TriggerEvent('chatMessage', '^1REQUIRED MATERIALS', {255,255,255}, "8 wood materials.")
	end
end, false)

-- Crafts a tent
local prevtent = 0
RegisterCommand('tent', function(source, args, rawCommand)
    if clientVars.woodMaterials > 2 and clientVars.scarpCloth > 14 then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.95))
		local tents = {
			'prop_skid_tent_01',
			'prop_skid_tent_01b',
			'prop_skid_tent_03',
		}
		local randomint = math.random(1,3)
		local tent = GetHashKey(tents[randomint])
		local prop = CreateObject(tent, x, y, z, true, false, true)
		SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
		PlaceObjectOnGroundProperly(prop)
		prevtent = prop
		FreezeEntityPosition(prop, true)
		clientVars.woodMaterials = clientVars.woodMaterials - 3
		clientVars.scrapCloth = clientVars.scrapCloth - 15
		TriggerEvent('chatMessage', '^2CRAFTED', {255,255,255}, "1 tent.")
	else
		TriggerEvent('chatMessage', '^1REQUIRED MATERIALS', {255,255,255}, "4 wood materials, 15 scrap cloth.")
	end
end, false)

-- Crafts a chair
local prevchair = 0
RegisterCommand('chair', function(source, args, rawCommand)
    if clientVars.woodMaterials > 3 and clientVars.scrapMetal > 1 then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.02))
		local chair = {
			'prop_chair_02',
			'prop_chair_05',
			'prop_chair_10'
		}
		local randomint = math.random(1,3)
		local chair = GetHashKey(chair[randomint])
		local prop = CreateObject(chair, x, y, z, true, false, true)
		SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
		FreezeEntityPosition(prop, true)
		PlaceObjectOnGroundProperly(prop)
		prevchair = prop
		clientVars.woodMaterials = clientVars.woodMaterials - 4
		clientVars.scrapMetal = clientVars.scrapMetal - 2
		TriggerEvent('chatMessage', '^2CRAFTED', {255,255,255}, "1 chair.")
	else
		TriggerEvent('chatMessage', '^1REQUIRED MATERIALS', {255,255,255}, "4 wood materials, 2 scrap metal.")
	end
end, false)

-- Use campfires
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		objectX, objectY, objectZ = table.unpack(GetEntityCoords(campfire, true))
		playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
		if(Vdist(objectX, objectY, objectZ, playerX, playerY, playerZ) < 4.0)then
			DrawGUI()
			if IsControlJustReleased(1, 51) then
				if clientVars.rawMeat > 0 then
					TriggerEvent('chatMessage', '^2SYSTEM', {255,255,255}, "You are cooking your meat.")
					Citizen.Wait(8000)
					clientVars.rawMeat = clientVars.rawMeat - 1
					clientVars.cookedMeat = clientVars.cookedMeat + 1
					TriggerEvent('chatMessage', '^2SYSTEM', {255,255,255}, "You cooked your meat.")
				else
					TriggerEvent('chatMessage', '^1SYSTEM', {255,255,255}, "You need to harvest raw meat from dead animals first.")
				end
			end
			if IsControlJustReleased(1, 23) then
				if clientVars.dirtyWater > 0 then
					TriggerEvent('chatMessage', '^2SYSTEM', {255,255,255}, "You boiling your water.")
					Citizen.Wait(5000)
					clientVars.dirtyWater = clientVars.dirtyWater - 1
					clientVars.cleanWater = clientVars.cleanWater + 1
					TriggerEvent('chatMessage', '^2SYSTEM', {255,255,255}, "You boiled dirty water.")
				else
					TriggerEvent('chatMessage', '^1SYSTEM', {255,255,255}, "You don't have any dirty water to boil.")
				end
			end
		end
	end
end)


function DrawGUI()
		DrawRect(0.50, 0.30, 0.20, 0.10, 155, 0, 0, 100)
		if clientVars.rawMeat then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.5)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("Press (E) to cook meat.")
			DrawText(0.40, 0.25)
		end
		if clientVars.dirtyWater then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.5)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("Press (F) to boil water.")
			DrawText(0.40, 0.275)
		end
end

RegisterCommand('maxinventory', function(source, args, rawCommand)
	if whitelisted == nil then
		TriggerEvent("chatMessage", "^1SYSTEM", {255, 255, 255}, "You are not allowed to use this command.")
	else
		clientVars.drinkItems = 9999
		clientVars.foodItems = 9999
		clientVars.bandages = 9999
		clientVars.ductTape = 9999
		clientVars.engineKit = 9999
		clientVars.dirtyWater = 9999
		clientVars.cleanWater = 9999
		clientVars.cookedMeat = 9999
		clientVars.rawMeat = 9999
		clientVars.zCredits = 9999
		TriggerEvent("chatMessage", "^2SYSTEM", {255, 255, 255}, "You have maximum inventory.")
	end
end)

RegisterCommand('maxcrafting', function(source, args, rawCommand)
	if whitelisted == nil then
		TriggerEvent("chatMessage", "^1SYSTEM", {255, 255, 255}, "You are not allowed to use this command.")
	else
		clientVars.emptyBottles = 9999
		clientVars.woodMaterials = 9999
		clientVars.scrapMetal = 9999
		clientVars.scrapCloth = 9999
		clientVars.gunPowder = 9999
		clientVars.zBlood = 9999
		clientVars.woodLogs = 9999
		TriggerEvent("chatMessage", "^2SYSTEM", {255, 255, 255}, "You have maximum crafting materials.")
	end
end)

-- Crafts a campfire
local prevfire = 0
RegisterCommand('campfire', function(source, args, rawCommand)
	if clientVars.woodLogs > 2 then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.55))
		local objectX, objectY, objectZ = table.unpack(GetEntityCoords(campfire, true))
		campfire = CreateObject(GetHashKey("prop_beach_fire"), x, y, z, true, false, true)
		SetEntityHeading(campfire, GetEntityHeading(PlayerPedId()))
		--DrawLightWithRange(objectX, objectY, objectZ+1, 255, 255, 255, 10, 0.75)
		--PlaceObjectOnGroundProperly(campfire)
		prevfire = campfire
		clientVars.woodLogs = clientVars.woodLogs - 3
		TriggerEvent('chatMessage', '^2CRAFTED', {255,255,255}, "1 campfire.")
	else
		TriggerEvent('chatMessage', '^1REQUIRED MATERIALS', {255,255,255}, "3 wood logs.")
	end
	for i, campfire in pairs(campfires) do
		table.insert(campfires, campfire)
	end
end, false)

-- Eat Cooked Meat
RegisterCommand("eatmeat", function(source,args,raw)
	if clientVars.cookedMeat > 0 then
		hunger = DecorGetFloat(PlayerPedId(), "hunger")
		randomHunger = math.random(25, 50)
		DecorSetFloat(PlayerPedId(), "hunger", hunger + randomHunger)
		clientVars.cookedMeat = clientVars.cookedMeat - 1
		TriggerEvent('chatMessage', "^2SYSTEM", {255, 255, 255}, "You ate some cooked meat.")
	else
		TriggerEvent('chatMessage', "^1SYSTEM", {255, 255, 255}, "You have no cooked meat to eat.")
	end
end)

-- Eat raw Meat
RegisterCommand("eatrawmeat", function(source,args,raw)
	if clientVars.rawMeat > 0 then
		hunger = DecorGetFloat(PlayerPedId(), "hunger")
		illness = DecorGetFloat(PlayerPedId(), "illness")
		randomHunger = math.random(10, 20)
		DecorSetFloat(PlayerPedId(), "hunger", hunger + randomHunger)
		DecorSetFloat(PlayerPedId(), "illness", illness + 10)
		clientVars.rawMeat = clientVars.rawMeat - 1
		TriggerEvent('chatMessage', "^2SYSTEM", {255, 255, 255}, "You ate some raw meat.")
	else
		TriggerEvent('chatMessage', "^1SYSTEM", {255, 255, 255}, "You have no raw meat to eat.")
	end
end)

-- Crafting Menu
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if crafting == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.40)

			SetTextColour(255, 255, 255, 255)
				
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('CRAFTING MATERIALS')
			DrawText(0.75, 0.25)
			DrawRect(0.82, 0.45, 0.15, 0.40, 155, 0, 0, 75)
				
			if clientVars.emptyBottles then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				
				SetTextColour(255, 255, 255, 255)
				
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Empty Bottles: ' .. clientVars.emptyBottles)
				DrawText(0.75, 0.28)
			end
			if clientVars.woodMaterials then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)

				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Wood Materials: ' .. clientVars.woodMaterials)
				DrawText(0.75, 0.30)
			end
			if clientVars.scrapMetal then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)

				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Scrap Metals: ' .. clientVars.scrapMetal)
				DrawText(0.75, 0.32)
			end
			if clientVars.scrapCloth then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)

				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Scrap Cloth: ' .. clientVars.scrapCloth)
				DrawText(0.75, 0.34)
			end
			if clientVars.gunPowder then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)

				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('gunPowder: ' .. clientVars.gunPowder)
				DrawText(0.75, 0.36)
			end
			if clientVars.zBlood then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)

				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Zombie Blood: ' .. clientVars.zBlood)
				DrawText(0.75, 0.38)
			end
			if clientVars.woodLogs then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)

				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Wood Logs: ' .. clientVars.woodLogs)
				DrawText(0.75, 0.40)
			end
		end
	end
end)

-- Inventory Menu
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if inventory == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.40)

			SetTextColour(255, 255, 255, 255)
				
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('INVENTORY')
			DrawText(0.60, 0.25)
			DrawRect(0.67, 0.45, 0.15, 0.40, 155, 0, 0, 75)
				
			if clientVars.drinkItems then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)

				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Drinks: ' .. clientVars.drinkItems)
				DrawText(0.60, 0.28)
			end
			if clientVars.foodItems then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)

				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Food: ' .. clientVars.foodItems)
				DrawText(0.60, 0.30)
			end
			if clientVars.bandages then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Bandages: ' .. clientVars.bandages)
				DrawText(0.60, 0.32)
			end
			if clientVars.ductTape then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Duct Tape: ' .. clientVars.ductTape)
				DrawText(0.60, 0.34)
			end
			if clientVars.engineKit then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Engine Repair Kits: ' .. clientVars.engineKit)
				DrawText(0.60, 0.36)
			end
			if clientVars.rawMeat then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Raw Meat: ' .. clientVars.rawMeat)
				DrawText(0.60, 0.38)
			end
			if clientVars.cookedMeat then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Cooked Meat: ' .. clientVars.cookedMeat)
				DrawText(0.60, 0.40)
			end
			if clientVars.zCredits then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Zombie Credits: ' .. clientVars.zCredits)
				DrawText(0.60, 0.42)
			end
			if clientVars.dirtyWater then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Dirty Water: ' .. clientVars.dirtyWater)
				DrawText(0.60, 0.44)
			end
			if clientVars.cleanWater then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)

				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString('Purified Water: ' .. clientVars.cleanWater)
				DrawText(0.60, 0.46)
			end
		end
	end
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end