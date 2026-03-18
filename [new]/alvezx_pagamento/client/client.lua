-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("alvezx_pagamento",cRP)
vSERVER = Tunnel.getInterface("alvezx_pagamento")

RegisterNetEvent("pagamento:cobrar")
AddEventHandler("pagamento:cobrar", function(id)
    local location = cfg.locations[id]
    vSERVER.handlePayment(location)
end)

RegisterCommand("cobrar",function()
    local hasAnyPerm = vSERVER.hasAnyPerm()
    if not hasAnyPerm then return end
    vSERVER.handlePayment(hasAnyPerm)    
end)

Citizen.CreateThread(function()
    for k,v in pairs(cfg.locations) do
        exports['target']:AddCircleZone('TradeLoc:'..k,vec3(v["cds"][1], v["cds"][2], v["cds"][3]),0.5,{
            name = 'TradeLoc:'..k,
            heading = 3374176
        },{
            Distance = 1.75,
            shop = k,
            options = {
                {
                    event = "pagamento:cobrar",
                    label = v.label,
                    tunnel = 'shop'
                }
            }
        })
    end
end)