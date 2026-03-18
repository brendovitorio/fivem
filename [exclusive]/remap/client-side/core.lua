local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
Creative = Tunnel.getInterface(GetCurrentResourceName())
vSERVER = Tunnel.getInterface(GetCurrentResourceName())
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vehicleData(vehicle)
	local vehBoost = {
		driveinertia = GetVehicleHandlingFloat(vehicle,"CHandlingData","fDriveInertia"),
		steeringlock = GetVehicleHandlingFloat(vehicle,"CHandlingData","fSteeringLock"),
		tractioncurvemax = GetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveMax"),
		tractioncurvemin = GetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveMin"),
		tractioncurvelateral = GetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveLateral"),
		lowspeedtractionlossmult = GetVehicleHandlingFloat(vehicle,"CHandlingData","fLowSpeedTractionLossMult"),
		initialdragcoeff = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDragCoeff"),
		drivebiasfront = GetVehicleHandlingFloat(vehicle,"CHandlingData","fDriveBiasFront")
	}
	return vehBoost
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVEDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function saveData(vehicle,data)
	local driveinertia = data.driveinertia*1.0
	local steeringlock = data.steeringlock*1.0
	local tractioncurvemax = data.tractioncurvemax*1.0
	local tractioncurvemin = data.tractioncurvemin*1.0
	local tractioncurvelateral = data.tractioncurvelateral*1.0
	local lowspeedtractionlossmult = data.lowspeedtractionlossmult*1.0
	local initialdragcoeff = data.initialdragcoeff*1.0
	local drivebiasfront = data.drivebiasfront
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fDriveInertia",driveinertia)
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fSteeringLock",steeringlock)
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveMax",tractioncurvemax)
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveMin",tractioncurvemin)
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveLateral",tractioncurvelateral)
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fLowSpeedTractionLossMult",lowspeedtractionlossmult)
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDragCoeff",initialdragcoeff)
	if initialdragcoeff > 50.0 then
		local multiply = drivebiasfront
		ModifyVehicleTopSpeed(vehicle, initialdragcoeff*multiply)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("save",function(data,cb)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)
    	if GetEntityModel(vehicle) == -1229221301 or GetEntityModel(vehicle) == -304327697 or GetEntityModel(vehicle) == -2096912321 or GetEntityModel(vehicle) == -213537235 or GetEntityModel(vehicle) == 689090322 or GetEntityModel(vehicle) == -1696026573 then 
    	  	TriggerEvent("Notify","verde","Remap nao pode ser aplicado nesse veiculo.",5000)
    	  	SetEntityCollision(vehicle, true, true)
			FreezeEntityPosition(vehicle,false)
			SetVehicleDoorsLocked(vehicle,0)
			SetVehicleOnGroundProperly(vehicle)
			SetEntityInvincible(vehicle,false)
    	  return true
    	end
		if GetPedInVehicleSeat(vehicle,-1) == ped then
			TriggerEvent("Notify","verde","O <b>remap</b> foi aplicado.",5000)
			saveData(vehicle,data)
			SetEntityCollision(vehicle, true, true)
			FreezeEntityPosition(vehicle,false)
			SetVehicleDoorsLocked(vehicle,0)
			SetVehicleOnGroundProperly(vehicle)
			SetEntityInvincible(vehicle,false)
			vSERVER.saveRemap(vehicleData(vehicle),GetVehicleNumberPlateTextIndex(vehicle))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("exit",function()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)
		if GetPedInVehicleSeat(vehicle,-1) == ped then
			SetEntityCollision(vehicle, true, true)
			FreezeEntityPosition(vehicle,false)
			SetVehicleDoorsLocked(vehicle,0)
			SetVehicleOnGroundProperly(vehicle)
			SetEntityInvincible(vehicle,false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remap",function(data)
	local ped = PlayerPedId()
	if Creative.checkPermission("Mechanic") then
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsUsing(ped)
			if GetPedInVehicleSeat(vehicle,-1) == ped then

				SetNuiFocus(true,true)
				SetEntityCollision(vehicle, false, false)
				SetEntityInvincible(vehicle,true)
				FreezeEntityPosition(vehicle,true)
				SetVehicleOnGroundProperly(vehicle)
				SetVehicleDoorsLocked(vehicle,4)

				local default1 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fDriveInertia")
				local default2 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fSteeringLock")
				local default3 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveMax")
				local default4 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveMin")
				local default5 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveLateral")
				local default6 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fLowSpeedTractionLossMult")
				local default7 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDragCoeff")
				local default8 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fDriveBiasFront")

				SendNUIMessage({ type = "togglemenu", state = true, data = vehicleData(vehicle), driveinertiavalue = default1, steeringlockvalue = default2, tractioncurvemaxvalue = default3, tractioncurveminvalue = default4, tractioncurvelateralvalue = default5, lowspeedtractionlossmultvalue = default6, initialdragcoeffvalue = default7, drivebiasfrontvalue = default8})
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLEMENU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("togglemenu",function(data,cb)
	SetNuiFocus(false,false)
end)