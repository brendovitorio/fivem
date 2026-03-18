local notfindtrailer = true
local globalSearch = function()
    return GetVehicleInDirection(GetEntityCoords(PlayerPedId()), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0))
end
--local TrailerBuy = {}
TRAIL = {}
--TRAIL.Menu = {}
--TRAIL.Menu.Main = RageUI.CreateMenu("", "Trailer Shop", nil, nil, "root_cause", "shopui_title_elitastravel")
--TRAIL.Menu.RefoundTrailer = RageUI.CreateMenu("", "Refound Trailer", nil, nil, "root_cause", "shopui_title_elitastravel")


spawnarampe = false
RegisterCommand('setrampe', function()
    if not spawnarampe then
        spawnarampe = true
        local ped = PlayerPedId()
        local coordA = GetEntityCoords(PlayerPedId(), 1)
        local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
        local trailerfind = GetVehicleInDirection(coordA, coordB)
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            local playercoords = GetEntityCoords(PlayerPedId())
            rampe = CreateObject(GetHashKey('prop_water_ramp_02'), playercoords.x, playercoords.y, playercoords.z - 1.4, false, false, false)
            SetEntityHeading(rampe, GetEntityHeading(PlayerPedId()))
            trailerfind = nil
            notfindtrailer = true
        else
            spawnarampe = false 
        end
    else
      --  Config.SendNotification(Config.Lang["RampeAlreadySet"])
    end
end, false)

RegisterCommand('deleterampe', function()
    if spawnarampe then
        DeleteEntity(rampe)
        spawnarampe = false
    end
end, false)

local CommandTable = {
    ["attachtrailer"] = function()
        local veh = GetVehiclePedIsIn(PlayerPedId())
        local havetobreak = false
        if veh ~= nil and veh ~= 0 then
            local belowFaxMachine = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, -1.0)
            local boatCoordsInWorldLol = GetEntityCoords(veh)
            havefindclass = false
            testnb = 0.0
            while notfindtrailer do
                local trailerfind = GetVehicleInDirection(vector3(boatCoordsInWorldLol.x, boatCoordsInWorldLol.y, boatCoordsInWorldLol.z), vector3(belowFaxMachine.x, belowFaxMachine.y, belowFaxMachine.z - testnb))
                testnb = testnb + 0.1
                if not startdecompte then
                    startdecompte = true
                    Citizen.SetTimeout(5000, function()
                        if trailerfind ~= 0 and trailerfind ~= nil then
                            startdecompte = false
                            --  Config.SendNotification(Config.Lang["TrailerNotFind"])
                            havetobreak = true
                        end
                    end)
                end
                if havetobreak then
                    break
                end
                Citizen.Wait(0)
            end
            if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
                for k, v in pairs(Config.VehicleCanTrail) do
                    if v.name == GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) then
                        for x, w in pairs(v.class) do
                            if w == GetVehicleClass(veh) then
                                havefindclass = true
                            end
                        end
                        if havefindclass then
                            AttachEntityToEntity(veh, trailerfind, GetEntityBoneIndexByName(trailerfind, 'chassis'), GetOffsetFromEntityGivenWorldCoords(trailerfind, boatCoordsInWorldLol), 0.0, 0.0, 0.0, false, false, true, false, 20, true)
                            TaskLeaveVehicle(PlayerPedId(), veh, 64)
                        else
                           -- Config.SendNotification(Config.Lang["CantSetThisType"])
                        end
                    end
                end
                trailerfind = nil
                notfindtrailer = true
            else
                --  Config.SendNotification(Config.Lang["TrailerNotFind"])
            end
        else
            -- Config.SendNotification(Config.Lang["NotInVehicle"])
        end
    end,
    ["detachtrailer"] = function()
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            local veh = GetVehiclePedIsIn(PlayerPedId())
            if DoesEntityExist(veh) and IsEntityAttached(veh) then
                DetachEntity(veh, true, true)
                notfindtrailer = true
                trailerfind = nil
            else
             --   Config.SendNotification(Config.Lang["NoVehicleSet"])
            end
        else
            local vehicleintrailer = globalSearch()
            if tonumber(vehicleintrailer) ~= 0 and vehicleintrailer ~= nil and IsEntityAttached(vehicleintrailer) then
                DetachEntity(vehicleintrailer, true, true)
                notfindtrailer = true
                trailerfind = nil
            else
                --  Config.SendNotification(Config.Lang["TrailerNotFind"])
            end
        end
    end,
    ["openrampetr2"] = function()
        local trailerfind = globalSearch()
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
                SetVehicleDoorOpen(trailerfind, 4, false, false)
            end
            trailerfind = nil
            notfindtrailer = true
        else
            --  Config.SendNotification(Config.Lang["TrailerNotFind"])
        end
    end,
    ["closerampetr2"] = function()
        local trailerfind = globalSearch()
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
                SetVehicleDoorShut(trailerfind, 10, false, false)
            end
            trailerfind = nil
            notfindtrailer = true
        else
            --  Config.SendNotification(Config.Lang["TrailerNotFind"])
        end
    end,
    ["opentrunktr2"] = function()
        local trailerfind = globalSearch()
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
                SetVehicleDoorOpen(trailerfind, 5, false, false)
            end
            trailerfind = nil
            notfindtrailer = true
        else
            --  Config.SendNotification(Config.Lang["TrailerNotFind"])
        end
    end,
    ["closetrunktr2"] = function()
        local trailerfind = globalSearch()
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
                SetVehicleDoorShut(trailerfind, 5, false, false)
            end
            trailerfind = nil
            notfindtrailer = true
        else
            --  Config.SendNotification(Config.Lang["TrailerNotFind"])
        end
    end,
}

for k, v in pairs(Config.Command) do
    RegisterCommand(v, function()
        CommandTable[k]()
    end)
end

function GetVehicleInDirection(cFrom, cTo)
    trailerfind = nil
    notfindtrailer = true
    local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, PlayerPedId(), 0)
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    if vehicle == 0 then
        notfindtrailer = true
    else
        notfindtrailer = false
        trailerfind = vehicle
    end
    return trailerfind
end
