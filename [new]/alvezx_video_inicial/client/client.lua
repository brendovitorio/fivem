-- RegisterCommand("ttt", function()
--     TriggerEvent("alvezx_video_inicial:start")
-- end)

RegisterNetEvent("alvezx_video_inicial:start")
AddEventHandler("alvezx_video_inicial:start", function()
    TriggerServerEvent("alvezx_video_inicial:check")
end)

RegisterNetEvent("alvezx_video_inicial:play")
AddEventHandler("alvezx_video_inicial:play", function()
    SendNUIMessage({Action = "Open"})
    SetNuiFocus(true, true)
end)

RegisterNUICallback("Close", function()
    TriggerServerEvent("alvezx_video_inicial:seen")
    SetNuiFocus(false, false)
end)