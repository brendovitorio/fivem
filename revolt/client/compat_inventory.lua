-----------------------------------------------------------------------------------------------------------------------------------------
-- CLIENT COMPAT / LEGACY WRAPPERS
-----------------------------------------------------------------------------------------------------------------------------------------
function trEVOLT.PlayAnim(...)
    return trEVOLT.playAnim(...)
end

function trEVOLT.CreateObjects(...)
    return trEVOLT.createObjects(...)
end

function trEVOLT.Destroy(...)
    return trEVOLT.removeObjects(...)
end

function trEVOLT.SetArmour(...)
    return trEVOLT.setArmour(...)
end

function trEVOLT.GetEntityCoords()
    return GetEntityCoords(PlayerPedId())
end

function trEVOLT.EntityCoordsZ()
    local Coords = GetEntityCoords(PlayerPedId())
    return Coords["z"] or Coords.z
end

function trEVOLT.InsideVehicle()
    return IsPedInAnyVehicle(PlayerPedId(), false)
end

function trEVOLT.VehicleAround(radius)
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
    local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, radius or 5.0, 0, 71)
    if Vehicle and Vehicle ~= 0 then
        local Net = NetworkGetNetworkIdFromEntity(Vehicle)
        local PlayerAround = false
        local Seats = GetVehicleModelNumberOfSeats(GetEntityModel(Vehicle))
        for Seat = -1, Seats - 2 do
            local Occupant = GetPedInVehicleSeat(Vehicle, Seat)
            if Occupant and Occupant ~= 0 and IsPedAPlayer(Occupant) then
                PlayerAround = true
                break
            end
        end
        return Vehicle, Net, PlayerAround
    end
    return nil, nil, false
end

function trEVOLT.ObjectControlling(model)
    local Ped = PlayerPedId()
    local Coords = GetOffsetFromEntityInWorldCoords(Ped, 0.0, 1.0, 0.0)
    local Heading = GetEntityHeading(Ped)
    return true, Coords, Heading
end
