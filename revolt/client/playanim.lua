-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Flags = 0
local Dict = nil
local Name = nil
local Active = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function trEVOLT.playAnim(Upper,Sequency,Loop,blendInSpeed,blendOutSpeed,Time,Flag)
	local Ped = PlayerPedId()
	if Sequency["task"] then
		trEVOLT.stopAnim(true)
		if Sequency["task"] == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then
			local Coords = GetEntityCoords(Ped)
			local Heading = GetEntityHeading(Ped)
			TaskStartScenarioAtPosition(Ped,Sequency["task"],Coords["x"],Coords["y"],Coords["z"] - 1,Heading,0,0,false)
		else
			TaskStartScenarioInPlace(Ped,Sequency["task"],0,false)
		end
	else
		local Consecutive = 0
		trEVOLT.stopAnim(Upper)

		if Upper then
			Consecutive = Consecutive + 48
		end

		if Loop then
			Consecutive = Consecutive + 1
		end

		if LoadAnim(Sequency[1]) then
			Dict = Sequency[1]
			Name = Sequency[2]
			Flags = Consecutive

			if Consecutive == 49 then
				Active = true
			end

			TaskPlayAnim(Ped,Sequency[1],Sequency[2],blendInSpeed or 8.0,blendOutSpeed or 8.0,Time or -1,Flag or Consecutive,0,0,0,0)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if Active and GetEntityHealth(Ped) > 100 then
			TimeDistance = 1

			local Ped = PlayerPedId()
			if not IsEntityPlayingAnim(Ped,Dict,Name,3) then
				TaskPlayAnim(Ped,Dict,Name,8.0,8.0,-1,Flags,0,0,0,0)
			end

			DisableControlAction(0,18,true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,263,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,143,true)
			DisablePlayerFiring(Ped,true)
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function trEVOLT.stopAnim(Upper)
	Active = false
	local Ped = PlayerPedId()

	if Upper then
		ClearPedSecondaryTask(Ped)
	else
		ClearPedTasks(Ped)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function trEVOLT.AnimActive()
	Active = false
end