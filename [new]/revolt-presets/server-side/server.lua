-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
vSKINSHOP = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("revolt-presets",cRP)

---Checar roupa do usuário
---@param job string
function cRP.checkClothes(job, userClothes, male)
    local source = source


    local isOk = true

    if male then
        for k,v in pairs(clothes[job].male) do
            if userClothes[k] then
                if userClothes[k]["item"] == v["item"] then
                    if userClothes[k]["texture"] == v["texture"] then

                    else
                        isOk = false
                    end
                else
                    isOk = false
                end
            else
                isOk = false
            end 
        end 
    else
        for k,v in pairs(clothes[job].female) do
            if userClothes[k] then
                if userClothes[k]["item"] == v["item"] then
                    if userClothes[k]["texture"] == v["texture"] then

                    else
                        isOk = false
                    end
                else
                    isOk = false
                end
            else
                isOk = false
            end 
        end 
    end

    return isOk
end