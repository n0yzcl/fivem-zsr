RegisterNetEvent("SquadCreated")
RegisterNetEvent("SquadMemberJoined")
RegisterNetEvent("SquadMemberLeft")
RegisterNetEvent("LeftSquad")
RegisterNetEvent("JoinedSquad")
rd = false	 -- KEEP THIS FALSE, OTHERWISE DEBUG FEATURES WILL BE ENABLED

curSquadMembers = {}

local playersDB = {}
for i=0, 31 do
	playersDB[i] = {}
end

AddEventHandler("SquadCreated", function(squadName)
	curSquadMembers = {}
	TriggerEvent("showNotification", "~g~"..squadName.."~w~ has been created!")
	Citizen.Trace("created new group\n")
	--table.insert( curSquadMembers,GetPlayerServerId(PlayerId()))
	UpdateSquadMembers()
end)

AddEventHandler("JoinedSquad", function(members,squadName)
	curSquadMembers = {}
	TriggerEvent("showNotification", "You joined ~g~"..squadName.."~w~!")
	Citizen.Trace("joined a new group\n")
	for i,theMember in ipairs(members) do
		table.insert(curSquadMembers,theMember.id)
	end
	UpdateSquadMembers()
end)

AddEventHandler("LeftSquad", function(squadName)
	curSquadMembers = {}
	TriggerEvent("showNotification", "You left ~g~"..squadName.."~w~!")
	Citizen.Trace("You left the group\n")
	UpdateSquadMembers()
end)

AddEventHandler("SquadMemberLeft", function(memberId,memberName)
	found = false
	for i,theTeammate in ipairs(curSquadMembers) do
		if theTeammate == memberId then
			found = true
			table.remove(curSquadMembers, i)
			TriggerEvent("showNotification", "~g~"..memberName.."~w~ left your group!")
		end
	end
	if not found then Citizen.Trace("group member left but we couldn't find him in our member list\n") else Citizen.Trace("player left us and was removed\n") end
	UpdateSquadMembers()
end)

AddEventHandler("SquadMemberJoined", function(PlayerName,PlayerId)
	TriggerEvent("showNotification", "~g~"..PlayerName.."~w~ joined your group!")
	Citizen.Trace("someone joined our group\n")
	table.insert(curSquadMembers, PlayerId)
	UpdateSquadMembers()
end)

Citizen.CreateThread(function()
	function UpdateSquadMembers()
		ptable = GetPlayers()
		for id, Player in ipairs(ptable) do
			isTeamMate = false
			for i,theTeammate in ipairs(curSquadMembers) do
				if Player == GetPlayerFromServerId(theTeammate) then
					if playersDB[Player].blip then RemoveBlip(playersDB[Player].blip) end
					isTeamMate = true
					local ped = GetPlayerPed(GetPlayerFromServerId(theTeammate))
					local blip = AddBlipForEntity(ped)
					SetBlipSprite(blip, 1)
					Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
					SetBlipNameToPlayerName(blip, Player)
					SetBlipScale(blip, 0.85)
					SetCanAttackFriendly(ped, false, false)
					NetworkSetFriendlyFireOption(false)
					playersDB[Player].blip = blip
				end
			end
			if isTeamMate == false then
				if playersDB[Player].blip then
					RemoveBlip(playersDB[Player].blip)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for i,Player in ipairs(playersDB) do
			for id,theTeammate in ipairs(curSquadMembers) do
				if Player == GetPlayerFromServerId(theTeammate) then
					local veh = GetVehiclePedIsIn(playersDB[Player].ped, false)
					if playersDB[Player].ped ~= GetPlayerPed(playersDB[Player]) then
						RemoveBlip(RemoveBlip(playersDB[Player].blip))
						local ped = GetPlayerPed(GetPlayerFromServerId(theTeammate))
						local blip = AddBlipForEntity(ped)
						SetBlipSprite(blip, 1)
						Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
						SetBlipNameToPlayerName(blip, Player)
						SetBlipScale(blip, 0.85)
						playersDB[Player].blip = blip
					end
					local blip = playersDB[Player].blip
					local blipSprite = GetBlipSprite(blip)
					if IsPedInAnyVehicle(playersDB[Player].ped, true) then
						local sprite = GetVehicleSpriteId(veh)

						if blipSprite ~= sprite then
							SetBlipSprite(blip, sprite)
							Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false)
						end
					else
						if blipSprite ~= 1 then
							SetBlipSprite(blip, 1)
							Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread( function()
	while true do
		if FreezeEngine then
			SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), false),false,true,false)
		end
		Citizen.Wait(1)
	end
end)

function UseUsable(property)

	if property == "vehiclerepair" then
		local ped = PlayerPedId()
		local veh = GetVehiclePedIsIn( ped,false)
		if veh == 0 or not veh then
			TriggerEvent("showNotification", "You need to be in a vehicle to use this kit")
			return false
		else
			SetVehicleEngineOn(veh,false,true,false)
			TriggerEvent("showNotification", "You started to repair the vehicle, this can take a bit")
			SetPedAllowVehiclesOverride(ped,false)
			SetVehicleDoorsLocked(veh,4)
			FreezeEngine = true
			Citizen.Wait(5000)
			FreezeEngine = false
			if GetVehiclePedIsIn(PlayerPedId(),false) and PlayerPedId() == ped then
				TriggerEvent("showNotification", "Engine was Fixed!")
				SetEntityHealth(veh,1000.0)
				SetVehicleEngineHealth(veh,1000.0)
				SetVehiclePetrolTankHealth(veh,1000.0)
				SetVehicleDoorsLocked(veh,0)
				SetPedAllowVehiclesOverride(PlayerPedId(),true)
				SetVehicleEngineOn(veh,true,true,false)
			else
				SetVehicleDoorsLocked(veh,0)
				SetPedAllowVehiclesOverride(PlayerPedId(),true)
				SetVehicleEngineOn(veh,true,true,false)
				return false
			end
		end

	elseif property == "tyrerepair" then
		local ped = PlayerPedId()
		local veh = GetVehiclePedIsIn(ped,false)
		if veh == 0 or not veh then
			TriggerEvent("showNotification", "You need to be in a vehicle to use this kit")
			return false
		else
			SetVehicleEngineOn(veh,false,true,false)
			TriggerEvent("showNotification", "You started to repair the vehicle, this can take a bit")
			SetPedAllowVehiclesOverride(ped,false)
			SetVehicleDoorsLocked(veh,4)
			FreezeEngine = true
			Citizen.Wait(5000)
			FreezeEngine = false
			if GetVehiclePedIsIn(PlayerPedId(),false) and PlayerPedId() == ped then
				TriggerEvent("showNotification", "Tyres were Fixed!")
				for i=0, 5 do
					SetVehicleTyreFixed(veh,i)
				end
				SetPedAllowVehiclesOverride(PlayerPedId(),true)
				SetVehicleEngineOn(veh,true,true,false)
				SetVehicleDoorsLocked(veh,0)
			else
				SetVehicleDoorsLocked(veh,0)
				SetPedAllowVehiclesOverride(PlayerPedId(),true)
				SetVehicleEngineOn(veh,true,true,false)
				return false
			end
		end

	elseif property == "cureinfection" then
		if infected then
			infected = false
			TriggerEvent("showNotification", "You are no longer infected!!")
			return true
		else
			TriggerEvent("showNotification", "I don't feel sick!")
			return false
		end
	end
	return true
end

function GetVehicleSpriteId(veh)
	vehClass = GetVehicleClass(veh)
	vehModel = GetEntityModel(veh)
	local sprite = 1

	if(vehClass == 8 or vehClass == 13)then
		sprite = 226 -- Bikes
	elseif(vehClass == 14)then
		sprite = 427 -- Boat
	elseif(vehClass == 15)then
		sprite = 422 -- Jet
	elseif(vehClass == 16)then
		sprite = 423 -- Planes
	elseif(vehClass == 19)then
		sprite = 421 -- Military
	else
		sprite = 225 -- Car
	end

	-- Model Specific Icons override Class.
	if(vehModel == GetHashKey("besra") or vehModel == GetHashKey("hydra") or vehModel == GetHashKey("lazer"))then
		sprite = 424
	elseif(vehModel == GetHashKey("insurgent") or vehModel == GetHashKey("insurgent2") or vehModel == GetHashKey("limo2"))then
		sprite = 426
	elseif(vehModel == GetHashKey("rhino"))then
		sprite = 421
	end

	return sprite
end

function GetPlayers()
	local players = {}

	for i = 0, 31 do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end
	return players
end

Citizen.CreateThread(function()
	local currentItemIndex = 1
	local selectedItemIndex = 1

	WarMenu.CreateMenu('Interaction', 'ZSR Menu')

	WarMenu.CreateSubMenu('inventory', 'Interaction', 'Inventory')
	WarMenu.CreateSubMenu('consumables', 'inventory', 'Consumables')
	WarMenu.CreateSubMenu('useables', 'inventory', 'Useables')
	if rd then
		WarMenu.CreateSubMenu('debug', 'Interaction', 'Debug Menu')
	end

	WarMenu.CreateSubMenu('squad', 'Interaction', 'Group Menu')
	WarMenu.CreateSubMenu('kys', 'Interaction', "Kill Yourself.")

	for i,Consumable in ipairs(consumableItems) do
		if consumableItems[i].consumable then
			WarMenu.CreateSubMenu(Consumable.name, 'consumables', Consumable.name)
		else
			WarMenu.CreateSubMenu(Consumable.name, 'useables', Consumable.name)
		end
	end

	while true do
		if WarMenu.IsMenuOpened('Interaction') then
			if WarMenu.MenuButton('Inventory', 'inventory') then

			elseif WarMenu.MenuButton('Group Menu', 'squad') then

			elseif WarMenu.MenuButton('Commit Suicide', 'kys') then

			elseif rd and WarMenu.MenuButton("Debug Menu", "debug") then

			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('kys') then
			if WarMenu.Button('Yes') then
				TriggerEvent("Z:killplayer")
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('No', 'Interaction') then
			end
			WarMenu.Display()

		elseif WarMenu.IsMenuOpened('inventory') then
			if WarMenu.MenuButton('Consumables', 'consumables') then
			elseif WarMenu.MenuButton('Useables', 'useables') then
				--			elseif WarMenu.Button('Drop Current Weapon') then
				--				TriggerEvent("dropweapon")
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('consumables') then
			for i,Consumable in ipairs(consumableItems) do
				if consumableItems.count[i] > 0.0 and consumableItems[i].consumable then
					WarMenu.MenuButton(Consumable.name, Consumable.name, tostring(math.round(consumableItems.count[i])))
				end
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('useables') then
			for i,Consumable in ipairs(consumableItems) do
				if consumableItems.count[i] > 0.0 and consumableItems[i].consumable == false then
					WarMenu.MenuButton(Consumable.name, Consumable.name, tostring(math.round(consumableItems.count[i])))
				end
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('squad') then
			if WarMenu.Button('Join Group') then
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP12N", "", "", "", "", "", 128 + 1)

				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 1 )
				end

				local result = GetOnscreenKeyboardResult()

				if result then
					TriggerServerEvent("joinsquad", result, GetPlayerName(PlayerId()))
				end

			elseif WarMenu.Button('Leave Group') then
				TriggerServerEvent("leavesquad", GetPlayerName(PlayerId()))
			end
			WarMenu.Display()






			------------------------------------------------ DEBUG CODE --------------------------------------------------
		elseif rd and WarMenu.IsMenuOpened('debug') then
			if rd and WarMenu.Button("Set Hunger") then

				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP12N", "", "", "", "", "", 128 + 1)

				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 1 )
				end

				local result = GetOnscreenKeyboardResult()

				if result and tonumber(result) then
					DecorSetFloat(PlayerPedId(), "hunger", tonumber(result)+0.000)
				end

			elseif rd and WarMenu.Button("Set Thirst") then

				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP12N", "", "", "", "", "", 128 + 1)

				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 1 )
				end

				local result = GetOnscreenKeyboardResult()

				if result and tonumber(result) then
					DecorSetFloat(PlayerPedId(), "thirst", tonumber(result)+0.000)
				end

			elseif rd and WarMenu.Button("Set Humanity") then


				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP12N", "", "", "", "", "", 128 + 1)

				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 1 )
				end

				local result = GetOnscreenKeyboardResult()

				if result and tonumber(result) then
					DecorSetFloat(PlayerPedId(), "humanity", tonumber(result)+0.000)
				end

			elseif rd and WarMenu.Button("Set Health") then

				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP12N", "", "", "", "", "", 128 + 1)

				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 1 )
				end

				local result = GetOnscreenKeyboardResult()

				if result and tonumber(result) then
					SetEntityHealth(PlayerPedId(), tonumber(result)+0.000 )
				end

			elseif rd and WarMenu.Button("Give All Items") then
				for i,c in ipairs(consumableItems) do
					consumableItems.count[i] = 99.0
				end
			elseif rd and WarMenu.Button("Toggle Infection") then
				infected = not infected
			elseif rd and WarMenu.Button("Toggle Possession") then
				if possessed then
					unPossessPlayer(PlayerPedId())
				else
					PossessPlayer(PlayerPedId())
				end
			end
			WarMenu.Display()

		elseif IsControlJustReleased(0, 303) then --M by default
			if possessed then
				TriggerEvent("showNotification", "~r~I am unable to reach for my pocket.")
			else
				WarMenu.OpenMenu('Interaction')
			end
		else
			local currentMenu = WarMenu.CurrentMenu()
			if currentMenu ~= nil then
				for item,Consumable in ipairs(consumableItems) do
					if currentMenu == Consumable.name then
						if consumableItems.count[item] > 0.0 then
							local title = "Use"
							if consumableItems[item].consumable then
								title = "Consume"
							end
							if WarMenu.Button(title, tostring(math.round(consumableItems.count[item]))) then
								if consumableItems[item].consumable then
									DecorSetFloat(PlayerPedId(), "hunger", DecorGetFloat(PlayerPedId(),"hunger")+consumableItems[item].hunger)
									DecorSetFloat(PlayerPedId(), "thirst", DecorGetFloat(PlayerPedId(),"thirst")+consumableItems[item].thirst)

									local newhealth = GetEntityHealth(PlayerPedId()) + consumableItems[item].health
									if newhealth > 200 then
										SetEntityHealth(PlayerPedId(), 200.0)
									else
										SetEntityHealth(PlayerPedId(), newhealth)
									end

									used = nil
									if consumableItems[item].property then
										used = nil
										used = UseUsable( consumableItems[item].property )
										while used == nil do Citizen.Wait(0) end
									else
										used = true
									end
									if used then
										consumableItems.count[item] = consumableItems.count[item]-1.0
									end

								else
									used = nil
									used = UseUsable( consumableItems[item].property )
									while used == nil do Citizen.Wait(0) end
									if used then
										consumableItems.count[item] = consumableItems.count[item]-1.0
									end
								end
							end
							local items = {}
							for j=1,consumableItems.count[item] do
								table.insert(items, j)
							end
							if WarMenu.ComboBox("Drop", items, currentItemIndex, selectedItemIndex, function(currentIndex, selectedIndex)
								currentItemIndex = currentIndex
								selectedItemIndex = selectedIndex
								end) then

								local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
								ForceCreateFoodPickupAtCoord(playerX + 3, playerY, playerZ, item, selectedItemIndex)
								consumableItems.count[item] = consumableItems.count[item] - selectedItemIndex
								currentItemIndex = 1
								selectedItemIndex = 1
							end
						else
							if consumableItems[item].consumable then
								WarMenu.OpenMenu("consumables")
							else
								WarMenu.OpenMenu("useables")
							end
						end
					end
				end
				WarMenu.Display()
			end
		end

		Citizen.Wait(1)
	end
end)
