-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("revolt_comida",cRP)
vCLIENT = Tunnel.getInterface("revolt_comida")

function cRP.removeItem(Full, Slot)
    local Passport = rEVOLT.Passport(source)
    if rEVOLT.TakeItem(Passport,Full,1,true,Slot) then
        return true
    end

    return false
end