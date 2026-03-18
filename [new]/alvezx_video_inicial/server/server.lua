local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")


RegisterNetEvent("alvezx_video_inicial:Start",function()
    local Source = source
    local Passport = rEVOLT.Passport(Source)
    local user = exports["oxmysql"]:query_async([[
        SELECT seevideo FROM characters WHERE id = ?
    ]], {Passport})

    if user[1] then
        local data = user[1]
        local seevideo = data["seevideo"]

        if seevideo == 0 then
            TriggerClientEvent("alvezx_video_inicial:play", Source)
        end
    end 
end)

RegisterNetEvent("alvezx_video_inicial:check")
AddEventHandler("alvezx_video_inicial:check", function()
    local source = source
    local Passport = rEVOLT.Passport(source)
    
    local user = exports["oxmysql"]:query_async([[
        SELECT seevideo FROM characters WHERE id = ?
    ]], {Passport})

    if user[1] then
        if user[1]["seevideo"] == 0 then
            TriggerClientEvent("alvezx_video_inicial:play", source)
        end
    end 
end)


RegisterNetEvent("alvezx_video_inicial:seen")
AddEventHandler("alvezx_video_inicial:seen", function()
    local Passport = rEVOLT.Passport(source)
    
    exports["oxmysql"]:query_async([[
        UPDATE characters SET seevideo = 1 WHERE id = ?
    ]], {Passport})
end)