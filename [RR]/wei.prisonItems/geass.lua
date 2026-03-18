
local Proxy = module("revolt","lib/Proxy")
local rEVOLT = Proxy.getInterface("rEVOLT")

local sql = exports['oxmysql']
local weiS = {}

local blacklistedItems = {
    ['radio'] = true,
    ['cellphone'] = true
}

weiS.apreender = function(charId)
    local src = rEVOLT.Source(charId)
    local apreendido = {}
    local charInv = rEVOLT.Inventory(charId)
    for k,v in pairs(charInv) do
        local item
        if v.item:find('-') then
            item = v.item:sub(1,v.item:find('-')-1)
        else
            item = v.item
        end
        if blacklistedItems[item] then
            rEVOLT.TakeItem(charId,v.item,v.amount,true,k)
            apreendido[v.item] = v.amount
        end
    end
    sql:execute("INSERT INTO wei_prisonitems(charId,Items) VALUES("..charId..",'"..json.encode(apreendido).."')")
    TriggerClientEvent('Notify',src,'amarelo','Alguns de seus items foram apreendidos e serão devolvidos quando você cumprir sua pena',10000)
end

weiS.devolver = function(charId)
    local src = rEVOLT.Source(charId)
    local hasItems = sql:query_async("SELECT * FROM wei_prisonitems WHERE charId = "..charId.." AND retrieved = b'0'")
    if #hasItems < 1 then return end

    for k,v in pairs(hasItems) do
        for i,j in pairs(json.decode(v.items)) do
            rEVOLT.GiveItem(charId,i,j,true)
        end
    end
    sql:execute("UPDATE wei_prisonitems SET retrieved = b'1' WHERE charId = "..charId.." AND retrieved = b'0'")
    TriggerClientEvent('Notify',src,'verde','Seus itens apreendidos foram devolvidos',5000)
end

execS = function(func,...)
    return weiS[func](...)
end
exports('server',execS)