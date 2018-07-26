players = {}

RegisterServerEvent("Z:newplayer")
AddEventHandler("Z:newplayer", function(id)
	players[source] = id
	TriggerClientEvent("Z:playerUpdate", -1, players)
end)

AddEventHandler("playerDropped", function(reason)
	players[source] = nil
	TriggerClientEvent("Z:playerUpdate", -1, players)
	local pname = GetPlayerName(source)
	Citizen.Trace("Player dropped: " .. pname)
	--[[for i, pickupInfo in pairs(spawnedItems) do
		if pname == pickupInfo.ownerName then
			TriggerEvent("removeOldItem", pickupInfo, "old client disconnected, removing their pickup\n")
		end
	end--]]
end)

RegisterServerEvent("Z:killedPlayer")
AddEventHandler("Z:killedPlayer", function(playerId)
	TriggerClientEvent("Z:killedPlayer", playerId)
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
