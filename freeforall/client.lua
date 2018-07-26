RegisterNetEvent('showFFA');
--RegisterNetEvent('showInfo');        --Add more chat commands

local location = {
	"Sandy Shores",
	"Paleto Bay",
	"Grapeseed"
}

AddEventHandler('showFFA', function()
	ped = GetPlayerPed(-1);
	nextlocation = nextlocation + 1
	
	if ped then
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For All starts in 5 minutes, get geared up. Free For All will be in Sandy Shores");
		Citizen.Wait(240000)
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For ALl Starts In 1 Minute. Find some guns and be prepared to fight to the death.");
		Citizen.Wait(30000)
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For ALl Starts In 30 seconds.");
		Citizen.Wait(20000)
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For ALl Starts In 10 seconds.");
		Citizen.Wait(10000)
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For All has started. PvP is now only allowed until time is up. Free For All ends in 15 minutes.");
		Citizen.Wait(900000)
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For ALl has ended. PvP is now no longer allowed, resume normal gameplay.");
	end
end)