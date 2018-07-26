
ESX = nil

local firstSpawn = {}


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("CreateData")
AddEventHandler("CreateData", function(variables)
	identifier = GetPlayerIdentifiers(source)[1]
	print('creating data')
	MySQL.Async.execute("INSERT INTO `crafting` (identifier, bandages, cleanwater, cookedmeat, dirtywater, drinkitems, ducktape, emptybottles, enginekit, fooditems, gunpowder, rawmeat, scrapcloth, scrapmetal, woodlogs, woodmaterials, zblood, zcredits) VALUES (@identifier, @bandages, @cleanwater, @cookedmeat, @dirtywater, @drinkitems, @ducktape, @emptybottles, @enginekit, @fooditems, @gunpowder, @rawmeat, @scrapcloth, @scrapmetal, @woodlogs, @woodmaterials, @zblood, @zcredits)",
	{
		['@identifier'] = identifier,
		['@bandages'] = variables.bandages,
		['@cleanwater'] = variables.cleanWater,
		['@cookedmeat'] = variables.cookedMeat,
		['@dirtywater'] = variables.dirtyWater,
		['@drinkitems'] = variables.drinkItems,
		['@ducktape'] = variables.ductTape,
		['@emptybottles'] = variables.emptyBottles,
		['@enginekit'] = variables.engineKit,
		['@fooditems'] = variables.foodItems,
		['@gunpowder'] = variables.gunPowder,
		['@rawmeat'] = variables.rawMeat,
		['@scrapcloth'] = variables.scrapCloth,
		['@scrapmetal'] = variables.scrapMetal,
		['@woodlogs'] = variables.woodLogs,
		['@woodmaterials'] = variables.woodMaterials,
		['@zblood'] = variables.zBlood,
		['@zcredits'] = variables.zCredits,
	})
end)


RegisterServerEvent('saveData')
AddEventHandler('saveData', function(variables)

	print('saving data')
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Async.execute("UPDATE `crafting` SET bandages=@bandages, cleanwater = @cleanwater, cookedmeat=@cookedmeat, dirtywater=@dirtywater, drinkitems=@drinkitems, ducktape=@ducktape, emptybottles=@emptybottles, enginekit=@enginekit, fooditems=@fooditems, gunpowder=@gunpowder, rawmeat=@rawmeat, scrapcloth=@scrapcloth, scrapmetal=@scrapmetal, woodlogs=@woodlogs, woodmaterials=@woodmaterials, zblood=@zblood, zcredits=@zcredits WHERE identifier=@identifier",
	{
		['@identifier'] = identifier,
		['@bandages'] = variables.bandages,
		['@cleanwater'] = variables.cleanWater,
		['@cookedmeat'] = variables.cookedMeat,
		['@dirtywater'] = variables.dirtyWater,
		['@drinkitems'] = variables.drinkItems,
		['@ducktape'] = variables.ductTape,
		['@emptybottles'] = variables.emptyBottles,
		['@enginekit'] = variables.engineKit,
		['@fooditems'] = variables.foodItems,
		['@gunpowder'] = variables.gunPowder,
		['@rawmeat'] = variables.rawMeat,
		['@scrapcloth'] = variables.scrapCloth,
		['@scrapmetal'] = variables.scrapMetal,
		['@woodlogs'] = variables.woodLogs,
		['@woodmaterials'] = variables.woodMaterials,
		['@zblood'] = variables.zBlood,
		['@zcredits'] = variables.zCredits,
	})

end)

RegisterServerEvent('loadData')
AddEventHandler('loadData', function()

	print('loading data')
	local identifier = GetPlayerIdentifiers(source)[1]
	
	MySQL.Async.fetchAll('SELECT `bandages`, `cleanwater`, `cookedmeat`, `dirtywater`, `drinkitems`, `ducktape`, `emptybottles`, `enginekit`, `fooditems`, `gunpowder`, `rawmeat`, `scrapcloth`, `scrapmetal`, `woodlogs`, `woodmaterials`, `zblood`, `zcredits` FROM `crafting` WHERE identifier = @identifier', {['@identifier'] = identifier}, function(serverVars)
		print(players[1].identifier)
		print('data loaded')
		--TriggerClientEvent("sendData", serverVars)
	end)

end)
