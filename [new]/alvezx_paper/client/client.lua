-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("alvezx_paper",cRP)
vSERVER = Tunnel.getInterface("alvezx_paper")


RegisterNetEvent("alvezx_paper:open_paper")
AddEventHandler("alvezx_paper:open_paper", function(paperId)
    rEVOLT._createObjects("amb@medic@standing@timeofdeath@base","base","prop_notepad_01",49,60309)
    if cfg.papers[paperId] then
        SendNUIMessage({action="open", paper=cfg.papers[paperId]})
    end
    SetNuiFocus(true, true)
end)

RegisterNUICallback("close", function()
    rEVOLT._removeObjects("one")
    SetNuiFocus(false, false)
end)
