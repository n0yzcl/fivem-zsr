Squads = {}
RegisterServerEvent("joinsquad")
RegisterServerEvent("leavesquad")

Citizen.CreateThread(function()
	AddEventHandler("joinsquad", function(squadName,PlayerName)
		local theSource = source
		squadExists = false
		for i,theSquad in ipairs(Squads) do
			for theRow,theMember in ipairs(theSquad.members) do
				if theMember.name == PlayerName then
					TriggerClientEvent("LeftSquad", theMember.id, Squads[i].name)
					table.remove(Squads[i].members, theRow)
					Citizen.Trace("removed member from old squad\n")
					for ti,TM in ipairs(Squads[i].members) do
						TriggerClientEvent("SquadMemberLeft", TM.id, theMember.id, theMember.name)
						Citizen.Trace("telling members their member left\n")
					end
				end
			end
		end

		for i,theSquad in ipairs(Squads) do
			if theSquad.name == squadName then
				squadExists = true
				table.insert(Squads[i].members, {id = theSource,name = PlayerName, admin = false})
				TriggerClientEvent("JoinedSquad", theSource, Squads[i].members, Squads[i].name)
				Citizen.Trace("player joined new squad\n")
				for i,theMember in ipairs(Squads[i].members) do
					TriggerClientEvent("SquadMemberJoined", theMember.id, PlayerName, theSource)
					Citizen.Trace("telling member they have a new member\n")
				end
			end

			if #theSquad.members == 0 then
				table.remove(Squads, i)
				Citizen.Trace("removed dead squad")
			end
		end
		if squadExists == false then
			local squadtable = {name = squadName, members = { } }
			table.insert(Squads, squadtable)
			TriggerClientEvent("SquadCreated", theSource, squadName)
			Citizen.Trace("new squad created\n")
			PlayerJoinSquad(theSource, PlayerName, true, squadName)
		end
	end)

	AddEventHandler("leavesquad", function(PlayerName)
		local theSource = source
		squadExists = false
		for i,theSquad in ipairs(Squads) do
			for theRow,theMember in ipairs(theSquad.members) do
				if theMember.name == PlayerName then
					TriggerClientEvent("LeftSquad", theMember.id, Squads[i].name)
					table.remove(Squads[i].members, theRow)
					Citizen.Trace("removed member from old squad\n")
					for ti,TM in ipairs(Squads[i].members) do
						TriggerClientEvent("SquadMemberLeft", TM.id, theMember.id, theMember.name)
						Citizen.Trace("telling members their member left\n")
					end
				end
			end
		end

		for i,theSquad in ipairs(Squads) do
			if #theSquad.members == 0 then
				table.remove(Squads, i)
				Citizen.Trace("removed dead squad")
			end
		end
	end)

	function PlayerJoinSquad(PlayerId,PlayerName,admin,SquadName)
		for i,theSquad in ipairs(Squads) do
			if theSquad.name == SquadName then
				table.insert(Squads[i].members, {id = PlayerId, name = PlayerName, admin = admin})
				TriggerClientEvent("JoinedSquad", PlayerId, Squads[i].members, Squads[i].name)
			end
		end
	end

	AddEventHandler('playerDropped', function(reason)
		local PlayerName = GetPlayerName(source)
		for i,theSquad in ipairs(Squads) do
			for theRow,theMember in ipairs(theSquad.members) do
				if theMember.name == PlayerName then
					table.remove(Squads[i].members, theRow)
					for ti,TM in ipairs(Squads[i].members) do
						TriggerClientEvent("SquadMemberLeft", TM.id, theMember.id, theMember.name)
					end
				end
			end
		end
	end)
end)
