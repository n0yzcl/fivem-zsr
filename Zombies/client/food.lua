Citizen.CreateThread(function()
	-- these were never local since they are unique anyway, but you do you i guess
	local defaultHungerLoss = 0.0003
	local defaultThirstLoss = 0.0005
	local SprintingHungerLoss = 0.0005
	local SprintingThirstLoss = 0.0007
	local drivingHungerLoss = 0.0002
	local drivingThirstLoss = 0.0003
	local Saturation = 0 -- hey, this is a thing i wanted to implement, but never did, horayy
	while true do
		Citizen.Wait(1)
		if DecorGetFloat(PlayerPedId(),"hunger") > 100.0 then
			DecorSetFloat(PlayerPedId(), "hunger", 100.0)
		end
		if DecorGetFloat(PlayerPedId(),"thirst") > 100.0 then
			DecorSetFloat(PlayerPedId(), "thirst", 100.0)
		end
		if IsPedSprinting(PlayerPedId()) then
			DecorSetFloat(PlayerPedId(), "hunger", DecorGetFloat(PlayerPedId(),"hunger")-SprintingHungerLoss)
			DecorSetFloat(PlayerPedId(), "thirst", DecorGetFloat(PlayerPedId(),"thirst")-SprintingThirstLoss)
		elseif IsPedInVehicle(PlayerPedId()) then
			DecorSetFloat(PlayerPedId(), "hunger", DecorGetFloat(PlayerPedId(),"hunger")-drivingHungerLoss)
			DecorSetFloat(PlayerPedId(), "thirst", DecorGetFloat(PlayerPedId(),"thirst")-drivingThirstLoss)
		else
			DecorSetFloat(PlayerPedId(), "hunger", DecorGetFloat(PlayerPedId(),"hunger")-defaultHungerLoss)
			DecorSetFloat(PlayerPedId(), "thirst", DecorGetFloat(PlayerPedId(),"thirst")-defaultThirstLoss)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if DecorGetFloat(PlayerPedId(),"hunger") < 0.0 then
			ShowNotification("You are starting to feel hungry, you need to find and eat some food soon.")
		end
		if DecorGetFloat(PlayerPedId(),"thirst") < 0.0 then
			ShowNotification("You are starting to feel thirsty, you need to find and drink some water soon.")
		end
		if DecorGetFloat(PlayerPedId(),"hunger") < -25.0 and DecorGetFloat(PlayerPedId(),"hunger") > -50.0 then
			SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())-1)
			ShowNotification("You are starving, you need to eat some food.")
		end
		if DecorGetFloat(PlayerPedId(),"thirst") < -25.0 and DecorGetFloat(PlayerPedId(),"thirst") > -50.0 then
			SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())-1)
			ShowNotification("You are dehydrated, you need to drink some water.")
		end
		if DecorGetFloat(PlayerPedId(),"hunger") < -50.0 then
			SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId())-5)
			ShowNotification("You are starving to death, you need to eat some food immediately.")
		end
		if DecorGetFloat(PlayerPedId(),"thirst") < -50.0 then
			SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId())-5)
			ShowNotification("You are very dehydrated, you need to drink some water immediately.")
		end
	end
end)

consumableItems = {
	{
		name = "Fresh Apple",
		hunger = 15.0,
		thirst = 3.0,
		health = 5,
		desc = "The healthy snack for Everyone!",
		consumable = true
	},
	{
		name = "Purified Water",
		hunger = 0.0,
		thirst = 50.0,
		health = 5,
		desc = "Fresh, clean water, delicious.",
		consumable = true
	},
	{
		name = "Raw Meat",
		hunger = 0.0,
		thirst = 50.0,
		health = 0,
		illness = 5,
		desc = "Raw meat found when harvesting animals.",
		consumable = true
	},
	{
		name = "Bandage",
		hunger = 0.0,
		thirst = 0.0,
		health = 20,
		desc = "A bandage to heal your wounds",
		consumable = true
	},
	{
		name = "Small Medkit",
		hunger = 0.0,
		thirst = 0.0,
		health = 25,
		desc = "Useful to patch minor gunshot wounds.",
		consumable = true
	},
	{
		name = "Large Medkit",
		hunger = 0.0,
		thirst = 0.0,
		health = 75,
		desc = "Useful for larger wounds such as exit wounds.",
		consumable = true
	},	
	{
		name = "Dirty Water",
		hunger = 0.0,
		thirst = 25.0,
		health = -5,
		desc = "Dirty water, only refills half the thirst that purified would.",
		consumable = true
	},
	{
		name = "Engine Repair Kit",
		desc = "Usable to repair most types of combustion engines",
		property = "vehiclerepair",
		consumable = false
	},
	{
		name = "Tyre Repair Kit",
		desc = "Usable to repair various types of tires",
		property = "tyrerepair",
		consumable = false
	},
	{
		name = "Ez-Way-Out Pills",
		hunger = 0.0,
		thirst = 0.0,
		health = -100,
		desc = "Tired of living? You can take the EZ way out instead.",
		consumable = true
	},
	{
		name = "Z-Pills",
		desc = "These pills were made to extend your life when infected, however you are still infected as there is no cure.",
		property = "cureinfection",
		hunger = 0.0,
		thirst = 0.0,
		health = 0,
		infection = -25,
		consumable = true
	},
	{
		name = "Antibiotics",
		desc = "These pills are used to get rid of an illness such as influenza.",
		hunger = 0.0,
		thirst = 0.0,
		health = 0,
		illness = -20,
		consumable = true
	},
	{
		name = "Duct Tape",
		desc = "Used to jerry rig items together",
		property = "fixit",
		consumable = false
	},
}

consumableItems.count = {}
for i,Consumable in ipairs(consumableItems) do
	consumableItems.count[i] = 0.0
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end