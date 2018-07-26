RegisterServerEvent('playerDied')
AddEventHandler('playerDied',function(killer,reason,weapon)
	if killer == "**Invalid**" or not GetPlayerName(source) then --Can't figure out what's generating invalid, it's late. If you figure it out, let me know. I just handle it as a string for now.
		reason = 2
	end
	if reason == 0 then
		TriggerClientEvent('showNotification', -1,"~o~".. GetPlayerName(source).."~w~ committed suicide. ")
	elseif reason == 1 and weapon then
		TriggerClientEvent('showNotification', -1,"~o~".. killer .. "~w~ killed ~o~"..GetPlayerName(source).."~w~ with ~o~"..weapon.."~w~.")
	end
end)


RegisterServerEvent("registerKill")
AddEventHandler("registerKill", function(player)
	if GetPlayerName(player) then
		TriggerClientEvent("Z:killedPlayer", player)
	end
end)
