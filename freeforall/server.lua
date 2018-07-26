AddEventHandler('chatMessage', function(source, name, msg)
	if msg == "/ffa" then
		CancelEvent();
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For All starts in 5 minutes, get geared up. Do NOT PvP yet!");
		Citizen.Wait(240000)
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For All Starts In 1 Minute. Find some guns and be prepared to fight to the death.");
		Citizen.Wait(30000)
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For All Starts In 30 seconds.");
		Citizen.Wait(20000)
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For All Starts In 10 seconds.");
		Citizen.Wait(10000)
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For All has started. PvP is now only allowed until time is up. Free For All ends in 15 minutes.");
		Citizen.Wait(600000)
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For All ends in 5 minutes.");
		Citizen.Wait(300000)
		TriggerClientEvent('chatMessage', -1, "^1Server", {255, 0, 0}, "^0Free For All has ended. PvP is now no longer allowed, resume normal gameplay.");
		--TriggerClientEvent('showFFA', source);
	end
end)
