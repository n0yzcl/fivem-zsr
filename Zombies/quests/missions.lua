-- Citizen.CreateThread(function()
-- local blips = {
	-- {id=47, x= 1614.95, y= 3598.97, z= 34.90}
-- }

	-- for _, map in pairs(blips) do
	-- map.blip = AddBlipForCoord(map.x, map.y, map.z)
	-- SetBlipSprite(map.blip, map.id)
	-- SetBlipAsShortRange(map.blip, true)
	-- end
-- end)

local jesusChats = {
	"Welcome to the church of Christ my friend. We are all about peace and restoration.",
	"You are welcome to stay here just don't cause any trouble.",
	"I don't have any tasks for you right now sorry friend.",
}

local guardChats = {
	"Can you help clear some zombies around the base?",
	"Help us kill these fucking zombies before they pack up in numbers.",
	"Don't need help right now, come back shortly.",
}

local injuredChats = {
	"I was shot by a looter, can you kill some looters for me? They have Lost MC jackets on them.",
	"I got shot by someone with a sniper rifle can you find him and kill him? in return you can keep the rifle.",
	"A guy shot me with a machine gun, can you find and kill him for me? The gun is yours for a reward.",
}

local tomChats = {
	"I don't have anything for you right now, come back another time and I might have something.",
	"Not today, sorry.",
	"Nothing to give you right now, maybe another time.",
	"I don't have any tasks, ask someone else around here maybe?",
}

local jimmyChats = {
	--"Not today, sorry man.",
	"Can you deliver these radios to Mark over at the Grapeseed Safezone?",
	--"Come back soon, and I might have something.",
}

local humaneLabInfo = {
	"The government has allowed us to use the inmates for testing our DNA modification experiment between the chimps DNA and regular human DNA.",
	"We have partnered with the IAA, FIB and Merryweather to begin testing our new experiment.",
	"All the prison buses must line up single file, each individual is to be checked for any signs of weakness. Including old age. The weak ones must be locked up on the outside quarantine fence. The rest are to be locked in the cages before proceeding.",
	"All patients are required to wear the special suits to prevent spreading of disease.",
	"The military has provided us with weapons, chemicals, and suits out back.",
	"Patients are dying as a result of the DNA modification, however we designed a syringe chemical labeled 'RES-457'.",
	"'RES-457' is suppose to do is bring back dead brain cells and re-activate the brain before permanent death.",
	"After injecting 'RES-457' into the last prisoner, the dead prisoner remained motionless for about 30 seconds before scientists notice something strange happening in the brain stem of the patient.",
	"Ever since resurrection 401 spread around the state, we have decided to move offshore to make a mass weapon that will wipe out the whole state to prevent it from spreading to other places.",
}

local looterMissions = {
	{name="Injured", id=47, x= 1692.66, y= 3587.85, z= 35.62},
}

local guardMissions = {
	{name="Guards", id=47, x= 2490.16, y= 4954.79, z= 48.23},
	{name="Guards", id=47, x= 2329.54, y= 3129.99, z= 51.44},
}

local jesusMissions = {
	{name="Jesus", id=47, x= 1858.75, y= 3852.40, z= 33.04},
}

local tomMissions = {
	{name="Tommy", id=47, x= 1866.00, y= 3844.44, z= 32.53},
}

local jimmyMissions = {
	{name="Jimmy", id=47, x= 2341.10, y= 3128.54, z= 48.20},
}

local markMissions = {
	{name="Mark", id=47, x= 2454.12, y= 4946.46, z= 45.12},
}

local jasonMissions = {
	{name="Jason", id=47, x= 2665.29, y= 3519.75, z= 52.73},
}

local douglasMissions = {
	{name="Douglas", id=47, x= 2446.24, y= 4956.91, z= 44.52},
}

local investigation = {
	{x=492.18, y=5589.69, z=794.28}, 
}

local humaneLabMissions = {
	{name="Merryweather", id=47, x= 3560.00, y= 3675.00, z= 28.00},
	{name="Merryweather", id=47, x= 3541.00, y= 3644.00, z= 28.00},
	{name="Merryweather", id=47, x= 3537.00, y= 3668.00, z= 28.00},
}

local looterBases = {
	{id=66, x= 686.00, y= 136.00, z= 85.00},
}

-- Mission Variables
local hasRadios = false
local hasMedkit = false
local killZinn = false


-- Global Variables
hasFingers = false
gaveMedkit = false
gaveRadios = false
hasKilledZinn = false
hasInvestigated = false
killedZombies = false
guardMission = false
jasonMission = false
jimmyMission = false
jesusMission = false
tomMission = false
douglasMission = false
fingerCount = 0
zombieCount = 0

-- Mission Completed Variables
local tomComplete = false
local jesusComplete = false
local jimmyComplete = false
local jasonComplete = false
local douglasComplete = false


-- Injured Survivor mission
Citizen.CreateThread(function()
	for _, item in pairs(looterMissions) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipColour(item.blip, item.colour)
		SetBlipAsShortRange(item.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.name)
		EndTextCommandSetBlipName(item.blip)
	end
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		local injured = GetEntityCoords(injuredPed, true)
        for k,v in ipairs(looterMissions) do
            --if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 15.0)then
                --DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5001, 0, 255, 0,165, 0, 0, 0,0)
                if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0)then
                    DisplayHelpText("Press ~INPUT_CONTEXT~ to interact with NPC.")
                    incircle = true
                    if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
						if hasMedkit == true then
							TaskTurnPedToFaceEntity(injuredPed, PlayerPedId(), 10000)
							TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Are you okay?")
							Citizen.Wait(3000)
							TriggerEvent('chatMessage', "^4an injured survivor(NPC)", {255, 255, 255}, "I was shot in the leg by a looter, I can't really move around for a while.")
							Citizen.Wait(3000)
							TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Here is a first aid kit from Jesus.")
							Citizen.Wait(3000)
							TriggerEvent('chatMessage', "^4an injured survivor(NPC)", {255, 255, 255}, "Tell him I said thank you.")
							Citizen.Wait(3000)
							ShowNotification("Return to Jesus in order for him to give you a reward.")
							hasMedkit = false
							jesusMission = false
							gaveMedkit = true
						elseif hasMedkit == false then
							TaskTurnPedToFaceEntity(injuredPed, PlayerPedId(), 10000)
							TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "What happened to you?")
							Citizen.Wait(3000)
							TriggerEvent('chatMessage', "^4an injured survivor(NPC)", {255, 255, 255}, "" .. injuredChats[math.random(1, #injuredChats)])
						end
					end
				end
			--end
		end
	end
end)

-- Base Guard Missions
Citizen.CreateThread(function()
	for _, item in pairs(guardMissions) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipColour(item.blip, item.colour)
		SetBlipAsShortRange(item.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.name)
		EndTextCommandSetBlipName(item.blip)
	end
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
        for k,v in ipairs(guardMissions) do
            --if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 15.0)then
                --DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5001, 0, 255, 0,165, 0, 0, 0,0)
                if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0)then
                    DisplayHelpText("Press ~INPUT_CONTEXT~ to interact with NPC.")
                    if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
						if killedZombies == true then
							TaskTurnPedToFaceEntity(guardPed, PlayerPedId(), 10000)
							TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Some of the Zombies have been dealt with sir.")
							Citizen.Wait(3000)
							TriggerEvent('chatMessage', "^4Base Guard(NPC)", {255, 255, 255}, "Good, thank you.")
							zombieCount = 0
							experience = DecorGetFloat(PlayerPedId(), "experience")
							DecorSetFloat(PlayerPedId(), "experience", experience + 100)
							ShowNotification("You have earned 100 EXP.")
							killedZombies = false
							guardComplete = true
						else
							if guardMission == true then
								TaskTurnPedToFaceEntity(guardPed, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^4Base Guard(NPC)", {255, 255, 255}, "What are you waiting for? Kill some dead guys.")
							end
							if guardComplete == true then
								TaskTurnPedToFaceEntity(guardPed, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^4Base Guard(NPC)", {255, 255, 255}, "I don't have any more tasks for you right at this time.")
							end
							if guardMission == false and not guardComplete then
								TaskTurnPedToFaceEntity(guardPed, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Need any help?")
								Citizen.Wait(3000)
								TriggerEvent('chatMessage', "^4Base Guard(NPC)", {255, 255, 255}, "Can you help clear some zombies around the base?")
								Citizen.Wait(3000)
								guardMission = true
							end
						end
					end
				end
			--end
		end
	end
end)

-- Jesus Mission
Citizen.CreateThread(function()
	for _, item in pairs(jesusMissions) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipColour(item.blip, item.colour)
		SetBlipAsShortRange(item.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.name)
		EndTextCommandSetBlipName(item.blip)
	end
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		local jesus = GetEntityCoords(Jesus, true)
        for k,v in ipairs(jesusMissions) do
            --if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 15.0)then
               -- DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5001, 0, 255, 0,165, 0, 0, 0,0)
                if(Vdist(pos.x, pos.y, pos.z, jesus.x, jesus.y, jesus.z) < 4.0)then
                    DisplayHelpText("Press ~INPUT_CONTEXT~ to interact with NPC.")
                    if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
						if gaveMedkit == true then
							TaskTurnPedToFaceEntity(Jesus, PlayerPedId(), 10000)
							TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "I have gave him that med kit.")
							Citizen.Wait(3000)
							TriggerEvent('chatMessage', "^4Jesus(NPC)", {255, 255, 255}, "Good job, here is your reward.")
							Citizen.Wait(3000)
							experience = DecorGetFloat(PlayerPedId(), "experience")
							DecorSetFloat(PlayerPedId(), "experience", experience + 75)
							GiveWeaponToPed(GetPlayerPed(-1), "WEAPON_APPISTOL", 30, true, true)
							cleanWater = cleanWater + 5
							zCredits = zCredits + 50
							ShowNotification("You were given an AP Pistol, 50 zombie credits, some water and 75 XP as a reward.")
							jesusComplete = true
							gaveMedkit = false
						else
							if jesusMission == true then
								TaskTurnPedToFaceEntity(Jesus, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^4Jesus(NPC)", {255, 255, 255}, "Please go give him that med kit before he bleeds out.")
							end
							if jesusComplete == true then
								TaskTurnPedToFaceEntity(Jesus, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^4Jesus(NPC)", {255, 255, 255}, "I got no more tasks for you right now, sorry friend.")
							end
							if jesusMission == false and not jesusComplete then
								TaskTurnPedToFaceEntity(Jesus, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Have anything I can do?")
								Citizen.Wait(3000)
								TriggerEvent('chatMessage', "^4Jesus(NPC)", {255, 255, 255}, "There is someone injured in the fire station, can you give them this first aid kit?")
								ShowNotification("You were given a first aid kit, go to the Sandy Shores Fire Station and give the injured guy the kit.")
								hasMedkit = true
								jesusMission = true
							end
						end
					end
				end
			--end
		end
	end
end)

-- Tom Jaredsons Mission
Citizen.CreateThread(function()
	for _, item in pairs(tomMissions) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipColour(item.blip, item.colour)
		SetBlipAsShortRange(item.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.name)
		EndTextCommandSetBlipName(item.blip)
	end
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		local tom = GetEntityCoords(Tom, true)
        for k,v in ipairs(tomMissions) do
           -- if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 15.0)then
               -- DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5001, 0, 255, 0,165, 0, 0, 0,0)
                if(Vdist(pos.x, pos.y, pos.z, tom.x, tom.y, tom.z) < 4.0)then
                    DisplayHelpText("Press ~INPUT_CONTEXT~ to interact with NPC.")
                    if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
						if hasKilledZinn == true then
							TaskTurnPedToFaceEntity(Tom, PlayerPedId(), 10000)
							TriggerEvent('chatMessage', "^2You", {255, 0, 0}, "Your cousin is no more.")
							Citizen.Wait(3000)
							TriggerEvent('chatMessage', "^4Tom Jaredson(NPC)", {255, 0, 0}, "Thank you, that means a lot to me. Here is your reward as promised.")
							Citizen.Wait(3000)
							experience = DecorGetFloat(PlayerPedId(), "experience")
							DecorSetFloat(PlayerPedId(), "experience", experience + 200)
							GiveWeaponToPed(GetPlayerPed(-1), "WEAPON_ASSAULTRIFLE", 30, true, true)
							scrapCloth = scrapCloth + 10
							bandages = bandages + 10
							scrapMetal = scrapMetal + 5
							foodItems = foodItems + 5
							cleanWater = cleanWater + 5
							zCredits = zCredits + 500
							ShowNotification("You was given an assault rifle, 500 zombie credits, bandages, some crafting materials and 200 XP as a reward")
							tomComplete = true
							hasKilledZinn = false
						else
							if tomMission == true then
								TaskTurnPedToFaceEntity(Tom, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^4Tom Jaredson(NPC)", {255, 255, 255}, "Please go take care of my cousin first then come back to me.")
							end
							if tomComplete == true then
								TaskTurnPedToFaceEntity(Tom, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^4Tom Jaredson(NPC)", {255, 255, 255}, "I don't have any more tasks for you, sorry pal.")
							end
							if tomMission == false and not tomComplete then
								TaskTurnPedToFaceEntity(Tom, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^2You", {255, 0, 0}, "^0Need anything?")
								Citizen.Wait(3000)
								TriggerEvent('chatMessage', "^4Tom Jaredson(NPC)", {255, 255, 255}, "My cousin is who is behind the looter situation, his name is Zinn. Can you do me a favor, and take him out? I cannot do it myself.")
								Citizen.Wait(3000)
								TriggerEvent('chatMessage', "^2You", {255, 0, 0}, "^0Do you know where he is?")
								Citizen.Wait(3000)
								TriggerEvent('chatMessage', "^4Tom Jaredson(NPC)", {255, 255, 255}, "He is at the water plant in Los Santos near the Vinewood Bowl, it should be marked on your map.")
								ShowNotification("Go to the water plant marked on your map.")
								tomMission = true
							end
						end
					end
				end
			--end
		end
	end
end)

-- Jimmys Mission
Citizen.CreateThread(function()
	for _, item in pairs(jimmyMissions) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipColour(item.blip, item.colour)
		SetBlipAsShortRange(item.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.name)
		EndTextCommandSetBlipName(item.blip)
	end
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		local jimmy = GetEntityCoords(Jimmy, true)
        for k,v in ipairs(jimmyMissions) do
           -- if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 15.0)then
               -- DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5001, 0, 255, 0,165, 0, 0, 0,0)
                if(Vdist(pos.x, pos.y, pos.z, jimmy.x, jimmy.y, jimmy.z) < 4.0)then
                    DisplayHelpText("Press ~INPUT_CONTEXT~ to interact with NPC.")
                    if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
						if gaveRadios == true then
							TaskTurnPedToFaceEntity(Jimmy, PlayerPedId(), 10000)
							TriggerEvent('chatMessage', "^4Jimmy(NPC)", {255, 255, 255}, "Did you give Mark the radios?")
							Citizen.Wait(3000)
							TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Yes, I did.")
							Citizen.Wait(3000)
							TriggerEvent('chatMessage', "^4Jimmy(NPC)", {255, 255, 255}, "Thank you, here you go.")
							Citizen.Wait(3000)
							experience = DecorGetFloat(PlayerPedId(), "experience")
							DecorSetFloat(PlayerPedId(), "experience", experience + 75)
							zCredits = zCredits + 75
							GiveWeaponToPed(GetPlayerPed(-1), "WEAPON_CARBINERIFLE", 30, true, true)
							ShowNotification("You were given a carbine rifle with 30 rounds, 75 zombie credits and 75 XP as a reward")
							jimmyComplete = true
							gaveRadios = false
						else
							if jimmyMission == true then
								TaskTurnPedToFaceEntity(Jimmy, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^4Jimmy(NPC)", {255, 255, 255}, "Please deliver those radios I gave you.")
							end
							if jimmyComplete == true then
								TaskTurnPedToFaceEntity(Jimmy, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^4Jimmy(NPC)", {255, 255, 255}, "I don't have any more tasks for you right now, sorry.")
							end
							if jimmyMission == false and not jimmyComplete then
								TaskTurnPedToFaceEntity(Jimmy, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Got anything I can do?")
								Citizen.Wait(3000)
								TriggerEvent('chatMessage', "^4Jimmy(NPC)", {255, 255, 255}, "" .. jimmyChats[math.random(1, #jimmyChats)])
								ShowNotification("You were given a couple radios, take them over to Mark at Grapeseed Safezone.")
								hasRadios = true
								jimmyMission = true
							end
						end
					end
				end
			--end
		end
	end
end)

-- Humane Lab Merryweather Mission
Citizen.CreateThread(function()
	for _, item in pairs(humaneLabMissions) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipColour(item.blip, item.colour)
		SetBlipAsShortRange(item.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.name)
		EndTextCommandSetBlipName(item.blip)
	end
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
        for k,v in ipairs(humaneLabMissions) do
            if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 15.0)then
                DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5001, 0, 255, 0,165, 0, 0, 0,0)
                if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0)then
                    if (incircle == false) then
                        DisplayHelpText("Press ~INPUT_CONTEXT~ to interact with NPC.")
                    end
                    incircle = true
                    if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
						TriggerEvent('chatMessage', "^4Merryweather Security(Document)", {255, 0, 0}, "^0" .. humaneLabInfo[math.random(1, #humaneLabInfo)])
						DisplayHelpText("You found a highly classified Merryweather document with information.")
					end
				end
			end
		end
	end
end)

-- Mark Mission
Citizen.CreateThread(function()
	for _, item in pairs(markMissions) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipColour(item.blip, item.colour)
		SetBlipAsShortRange(item.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.name)
		EndTextCommandSetBlipName(item.blip)
	end
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		local mark = GetEntityCoords(Mark, true)
		for k,v in ipairs(markMissions) do
			--if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 15.0)then
				--markMission = DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5001, 0, 255, 0,165, 0, 0, 0,0)
				if(Vdist(pos.x, pos.y, pos.z, mark.x, mark.y, mark.z) < 4.0)then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to interact with NPC.")
					if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
						if hasRadios == true then
							TaskTurnPedToFaceEntity(Mark, PlayerPedId(), 10000)
							TriggerEvent('chatMessage', "^2You", {255, 0, 0}, "^0I got radios to give you.")
							Citizen.Wait(3000)
							TriggerEvent('chatMessage', "^4Mark(NPC)", {255, 255, 255}, "Thank you.")
							Citizen.Wait(3000)
							ShowNotification("Return to Jimmy.")
							hasRadios = false
							jimmyMission = false
							gaveRadios = true
						elseif hasRadios == false then
							TriggerEvent('chatMessage', "^4Mark(NPC)", {255, 0, 0}, "^0I don't have anything for you right now, sorry.")
						end
					end
				end
			--end
		end
	end
end)

-- Kill Zinn Mission
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if tomMission == true then
			DrawMarker(1, 715.92, 111.82, 79.95 - 1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 500.0, 255, 0, 0,100, 0, 0, 0,0)
			if IsPedDeadOrDying(Zinn, 1) == 1 then
				hasKilledZinn = true
				tomMission = false
				Citizen.Wait(5000)
				DeleteEntity(Zinn)
				ShowNotification("Return to Tom in Sandy Shores.")
			end
		end
	end
end)

-- Jasons Mission
Citizen.CreateThread(function()
	for _, item in pairs(jasonMissions) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipColour(item.blip, item.colour)
		SetBlipAsShortRange(item.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.name)
		EndTextCommandSetBlipName(item.blip)
	end
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		local jason = GetEntityCoords(Jason, true)
		for k,v in ipairs(jasonMissions) do
			--if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 15.0)then
					--DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5001, 0, 255, 0,165, 0, 0, 0,0)
					if(Vdist(pos.x, pos.y, pos.z, jason.x, jason.y, jason.z) < 4.0)then
						DisplayHelpText("Press ~INPUT_CONTEXT~ to interact with NPC.")
						if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
							if hasFingers == true then
								TaskTurnPedToFaceEntity(Jason, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^4Jason(NPC)", {255, 255, 255}, "Do you have them fingers?")
								Citizen.Wait(3000)
								TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Yes, here is your fingers.")
								Citizen.Wait(3000)
								TriggerEvent('chatMessage', "^4Jason(NPC)", {255, 255, 255}, "Thank you, here is your reward.")
								Citizen.Wait(3000)
								hasFingers = false
								fingerCount = 0
								experience = DecorGetFloat(PlayerPedId(), "experience")
								DecorSetFloat(PlayerPedId(), "experience", experience + 100)
								zCredits = zCredits + 150
								cleanWater = cleanWater + 5
								GiveWeaponToPed(GetPlayerPed(-1), "WEAPON_ASSAULTRIFLE", 30, true, true)
								ShowNotification("You were given an assault rifle with 30 rounds, 5 clean water, 150 zombie credits and 100 XP as a reward")
								jasonComplete = true
							else
								if jasonMission == true then
									TaskTurnPedToFaceEntity(Jason, PlayerPedId(), 10000)
									TriggerEvent('chatMessage', "^4Jason(NPC)", {255, 255, 255}, "Go get me some fingers.")
								end
								if jasonComplete == true then
									TaskTurnPedToFaceEntity(Jason, PlayerPedId(), 10000)
									TriggerEvent('chatMessage', "^4Jason(NPC)", {255, 255, 255}, "I have no business with you.")
								end
								if jasonMission == false and not jasonComplete then
									TaskTurnPedToFaceEntity(Jason, PlayerPedId(), 10000)
									TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Do you got any tasks available?")
									Citizen.Wait(3000)
									TriggerEvent('chatMessage', "^4Jason(NPC)", {255, 255, 255}, "Would you be willing to collect a few dead fingers for me?")
									Citizen.Wait(3000)
									TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Sure thing.")
									Citizen.Wait(3000)
									ShowNotification("Jason gave you a task to collect a couple zombie fingers, go kill and loot a few zombies.")
									jasonMission = true
								end
							end
						end
					end
			--end
		end
	end
end)

-- Douglas Mission
Citizen.CreateThread(function()
	for _, item in pairs(douglasMissions) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipColour(item.blip, item.colour)
		SetBlipAsShortRange(item.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.name)
		EndTextCommandSetBlipName(item.blip)
	end
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		local doug = GetEntityCoords(Douglas, true)
		for k,v in ipairs(douglasMissions) do
			--if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 15.0)then
					--DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5001, 0, 255, 0,165, 0, 0, 0,0)
					if(Vdist(pos.x, pos.y, pos.z, doug.x, doug.y, doug.z) < 4.0)then
						DisplayHelpText("Press ~INPUT_CONTEXT~ to interact with NPC.")
						if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
							if hasInvestigated == true then
								TaskTurnPedToFaceEntity(Douglas, PlayerPedId(), 10000)
								TriggerEvent('chatMessage', "^4Douglas(NPC)", {255, 255, 255}, "What did you find up there?")
								Citizen.Wait(3000)
								TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Two dead survivors and a group of marauders.")
								Citizen.Wait(3000)
								TriggerEvent('chatMessage', "^4Douglas(NPC)", {255, 255, 255}, "Seriously? Damn it... Okay here is your reward for checking out the campsite, thank you.")
								Citizen.Wait(3000)
								hasInvestigated = false
								experience = DecorGetFloat(PlayerPedId(), "experience")
								DecorSetFloat(PlayerPedId(), "experience", experience + 100)
								zCredits = zCredits + 200
								woodMaterials = woodMaterials + 10
								scrapCloth = scrapCloth + 20
								woodLogs = woodLogs + 6
								scrapMetal = scrapMetal + 20
								GiveWeaponToPed(GetPlayerPed(-1), "WEAPON_PUMPSHOTGUN", 30, true, true)
								ShowNotification("You were given a pump shotgun with 30 rounds, 200 zombie credits, crafting materials and 100 XP as a reward")
								douglasComplete = true
							else
								if douglasMission == true then
									TaskTurnPedToFaceEntity(Douglas, PlayerPedId(), 10000)
									TriggerEvent('chatMessage', "^4Douglas(NPC)", {255, 255, 255}, "Please go to Chiliad and see if they are still there..")
								end
								if douglasComplete == true then
									TaskTurnPedToFaceEntity(Douglas, PlayerPedId(), 10000)
									TriggerEvent('chatMessage', "^4Douglas(NPC)", {255, 255, 255}, "Thank you for investigating that campsite, I don't have anything else right now.")
								end
								if douglasMission == false and not douglasComplete then
									TaskTurnPedToFaceEntity(Douglas, PlayerPedId(), 10000)
									TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Is there anything you need?")
									Citizen.Wait(3000)
									TriggerEvent('chatMessage', "^4Douglas(NPC)", {255, 255, 255}, "Yes, we lost radio contact with a couple survivors who farmed here.")
									Citizen.Wait(5000)
									TriggerEvent('chatMessage', "^4Douglas(NPC)", {255, 255, 255}, "They were last heard camping out at the top of Mount Chiliad. Mind checking it out?")
									Citizen.Wait(3000)
									TriggerEvent('chatMessage', "^2You", {255, 255, 255}, "Yeah I suppose I can take a look.")
									Citizen.Wait(3000)
									TriggerEvent('chatMessage', "^4Douglas(NPC)", {255, 255, 255}, "Watch out for marauders.")
									Citizen.Wait(3000)
									ShowNotification("Douglas wants you to investigate a campsite at the top of Mount Chiliad.")
									douglasMission = true
								end
							end
						end
					end
			--end
		end
	end
end)

-- Finish Douglas Investigation
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if douglasMission == true then
			for k,v in ipairs(investigation) do
				local pos = GetEntityCoords(GetPlayerPed(-1), true)
				if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 5.0)then
					Citizen.Wait(5000)
					douglasMission = false
					hasInvestigated = true
					ShowNotification("Return the bad news back to Douglas")
				end
			end
		end
	end
end)

-- Displays Finger Count text
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if jasonMission == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('Quest: "Finger Chopping."')
			DrawText(0.85, 0.15)
		end
		if jasonMission == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.25)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")	
			AddTextComponentString('Fingers: ' .. fingerCount ..'/5')
			DrawText(0.85, 0.175)
		end
		
		-- Return Fingers
		if fingerCount > 4 then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('Quest: "Finger Chopping."')
			DrawText(0.85, 0.15)
		end
		if fingerCount > 4 then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.25)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")	
			AddTextComponentString('Return the fingers to Jason')
			DrawText(0.85, 0.175)
		end
	end
end)

-- Displays Toms Mission
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if tomMission == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('Quest: "A Cousins Deathwish."')
			DrawText(0.85, 0.15)
		end
		if tomMission == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.25)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")	
			AddTextComponentString('Go and eliminate Zinn at Water Plant.')
			DrawText(0.85, 0.175)
		end
		
		-- Return to Tom
		if hasKilledZinn == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('Quest: "A Cousins Deathwish."')
			DrawText(0.85, 0.15)
		end
		if hasKilledZinn == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.25)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")	
			AddTextComponentString('Return to Tom in Sandy Shores.')
			DrawText(0.85, 0.175)
		end
	end
end)

-- Displays Jesus Mission
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if jesusMission == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('Quest: "Saving The Wounded"')
			DrawText(0.85, 0.15)
		end
		if jesusMission == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.25)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")	
			AddTextComponentString('Give the injured survivor the medkit.')
			DrawText(0.85, 0.175)
		end
		
		-- Return to Jesus
		if gaveMedkit == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('Quest: "Saving The Wounded"')
			DrawText(0.85, 0.15)
		end
		if gaveMedkit == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.25)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")	
			AddTextComponentString('Return to Jesus at the abandoned church.')
			DrawText(0.85, 0.175)
		end
	end
end)

-- Displays Jimmys Mission
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if jimmyMission == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('Quest: "Special Delivery"')
			DrawText(0.85, 0.15)
		end
		if jimmyMission == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.25)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")	
			AddTextComponentString('Give the radios to Mark.')
			DrawText(0.85, 0.175)
		end
		
		-- Return to Jimmy
		if gaveRadios == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('Quest: "Special Delivery"')
			DrawText(0.85, 0.15)
		end
		if gaveRadios == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.25)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")	
			AddTextComponentString('Return to Jimmy at the Junkyard.')
			DrawText(0.85, 0.175)
		end
	end
end)

-- Displays Guard Missions
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if guardMission == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('Quest: "Cleaning Up The Mess"')
			DrawText(0.85, 0.15)
		end
		if guardMission == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.25)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")	
			AddTextComponentString('Zombies Killed: ' .. zombieCount .. '/10')
			DrawText(0.85, 0.175)
		end
		
		-- Return to Jimmy
		if zombieCount > 9 then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('Quest: "Cleaning Up The Mess"')
			DrawText(0.85, 0.15)
		end
		if zombieCount > 9 then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.25)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")	
			AddTextComponentString('Return to the Guard.')
			DrawText(0.85, 0.175)
		end
	end
end)

-- Displays Douglas Missions
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if douglasMission == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('Quest: "Criminal Investigation"')
			DrawText(0.85, 0.15)
		end
		if douglasMission == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.25)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")	
			AddTextComponentString('Go investigate a campsite at the top of Mt.Chiliad')
			DrawText(0.85, 0.175)
		end
		
		-- Return to Douglas
		if hasInvestigated == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString('Quest: "Criminal Investigation"')
			DrawText(0.85, 0.15)
		end
		if hasInvestigated == true then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.25)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")	
			AddTextComponentString('Return the news to Douglas.')
			DrawText(0.85, 0.175)
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