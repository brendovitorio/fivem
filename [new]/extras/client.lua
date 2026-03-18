local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
vSERVER = Tunnel.getInterface(GetCurrentResourceName())

RegisterCommand("extras", function(s,a,r)
    if IsPedInAnyVehicle(PlayerPedId()) then
        local count = GetVehicleLiveryCount(GetVehiclePedIsIn(PlayerPedId()))
       print(count,type(count))
        SendNUIMessage({ action = "open", count = count })
        SetNuiFocus(true, true)
    end
end)

RegisterNUICallback("select", function(data,cb)
    if IsPedInAnyVehicle(PlayerPedId()) then
        SetVehicleLivery(GetVehiclePedIsIn(PlayerPedId()), data.livery)
    end
end)

RegisterNUICallback("close", function(data,cb)
    SetNuiFocus(false, false)
end)