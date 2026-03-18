framework = {}

local Proxy = module("revolt","lib/Proxy")
local rEVOLT = Proxy.getInterface("rEVOLT")

framework.webhookrestart = "https://discord.com/api/webhooks/1154891458214633633/6dGiOUDZq0BQWVBun5hs2BA8k-OrRQaLwgXLNyEYbrJ0SzW0yclN8vFzMuUu6QyxYXuw"

framework.notifyAll = function(time)
    local users = rEVOLT.Players()
    for _,v in pairs(users) do
        TriggerClientEvent("Notify",v,"tempestade","<b>Noticiario Revolt City informa:</b> Tempestade se aproxima em 5 minutos! ",20000)
    end
    GlobalState["Weather"] = "clearing"
    rEVOLT.SendWebhook(framework.webhookrestart, "Revolt BOT", "**O Servidor reiniciará em 5 minutos! @everyone**", 10357504)
    Wait(2*60*1000)
    for _,v in pairs(users) do
        TriggerClientEvent("Notify",v,"tempestade","<b>Noticiario Revolt City informa:</b> Tempestade se aproxima em 3 minutos! ",20000)
    end
    GlobalState["Weather"] = "rain"
    rEVOLT.SendWebhook(framework.webhookrestart, "Revolt BOT", "**O Servidor reiniciará em 3 minutos! @everyone**", 10357504)
    Wait(2*60*1000)
    for _,v in pairs(users) do
        TriggerClientEvent("Notify",v,"tempestade","<b>Noticiario Revolt City informa:</b> Tempestade se aproxima em 1 minuto! ",20000)
    end
    GlobalState["Weather"] = "thunder"
    rEVOLT.SendWebhook(framework.webhookrestart, "Revolt BOT", "**O Servidor reiniciará em 1 minuto! everyone**", 10357504)
    TriggerEvent("SaveServer",false)

end

framework.kickAll = function()
    local users = rEVOLT.Players()
    for _,v in pairs(users) do
        rEVOLT.Kick(v,'Você foi atingido pela tempestade. feche o fivem aguarde 3 minutos e volte a se divertir.')
        Wait(500)
    end
    TriggerEvent("SaveServer",false)
end

framework.sendWebhook = function(webhooklink, title, message, color)
    rEVOLT.SendWebhook(webhooklink, title, message, color)
end