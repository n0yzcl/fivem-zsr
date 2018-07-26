spawned = false

local walkStyles = {
	"move_m@drunk@verydrunk",
	"move_m@drunk@moderatedrunk",
	"move_m@drunk@a",
	"anim_group_move_ballistic",
	"move_lester_CaneUp",
}


AddEventHandler("playerSpawned", function(spawn)
	spawned = false
end)


-- Resurrects the dead player as a zombie upon respawn
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(20000)
		--if IsPedFatallyInjured(GetPlayerPed(-1)) then
		if IsPedDeadOrDying(GetPlayerPed(-1), 1) == 1 then
			if spawned == false then
				newzombie = ClonePed(PlayerPedId(), GetEntityHeading(PlayerPedId()), true, true)
				Citizen.Trace("Cloned Player")
				
				AddRelationshipGroup("zombeez")
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("looters"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("badanimals"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("animals"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("friends"))
				SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("ngf"))
				SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("zombeez"))
				
				SetPedArmour(newzombie, 100)
				SetPedAccuracy(newzombie, 25)
				SetPedSeeingRange(newzombie, 10.0)
				SetPedHearingRange(newzombie, 1500.0)
				SetEntityHealth(newzombie, 500)
				SetEntityMaxHealth(newzombie, 500)
				SetPedPathCanUseClimbovers(newzombie, false)
				SetPedPathCanUseLadders(newzombie, false)
				SetPedPathAvoidFire(newzombie, false)
				SetPedPathCanDropFromHeight(newzombie, true)
							
				SetAiMeleeWeaponDamageModifier(1.0)

				SetPedFleeAttributes(newzombie, 0, 0)
				SetPedCombatAttributes(newzombie, 16, 1)
				SetPedCombatAttributes(newzombie, 17, 0)
				SetPedCombatAttributes(newzombie, 46, 1)
				SetPedCombatAttributes(newzombie, 1424, 0)
				SetPedCombatAttributes(newzombie, 5, 1)
				SetPedCombatRange(newzombie,2)
				SetPedAlertness(newzombie,3)
				SetPedTargetLossResponse(newzombie, 2)
				SetAmbientVoiceName(newzombie, "ALIENS")
				SetPedEnableWeaponBlocking(newzombie, true)
				SetPedRelationshipGroupHash(newzombie, GetHashKey("zombeez"))
				DisablePedPainAudio(newzombie, true)
				SetPedDiesInWater(newzombie, false)
				SetPedDiesWhenInjured(newzombie, false)
				
				SetPedIsDrunk(newzombie, true)
				SetPedConfigFlag(newzombie,100,1)
							
				walkStyle = walkStyles[math.random(1, #walkStyles)]
							
				RequestAnimSet(walkStyle)
				while not HasAnimSetLoaded(walkStyle) do
					Citizen.Wait(100)
				end
				SetPedMovementClipset(newzombie, walkStyle, 1.0)
				ApplyPedDamagePack(newzombie,"BigHitByVehicle", 0.0, 9.0)
				ApplyPedDamagePack(newzombie,"SCR_Dumpster", 0.0, 9.0)
				ApplyPedDamagePack(newzombie,"SCR_Torture", 0.0, 9.0)
				StopPedSpeaking(newzombie,true)
							
				blip = AddBlipForEntity(newzombie)
				SetBlipSprite(blip, 84)
				SetBlipAsShortRange(blip, true)

				TaskWanderStandard(newzombie, 1.0, 10)
				local pspeed = math.random(20,70)
				local pspeed = pspeed/10
				local pspeed = pspeed+0.01
				SetEntityMaxSpeed(newzombie, 5.0)
				
				spawned = true
			end
		end
	end
end)