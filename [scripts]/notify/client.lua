local notificationTypes = {
    -- GLOBAL
    verde = "success",
    azul = "bluish",
    branco = "info",
    vermelho = "error",
    amarelo = "warning",
    sms = "sms",
    long = "long",

    -- VEHICLES
    locked = "locked",
    unlocked = "unlocked",
}

function Alert(message, time, color)
    local type = notificationTypes[color:lower()]
    SendNUIMessage({
        action = 'open',
        type = type,
        message = message,
        time = time,
    })
end

RegisterNetEvent('Notify')
AddEventHandler('Notify', function(color, message, time)
    if notificationTypes[color:lower()] then
        Alert(message, time, color:lower())
    else
        Alert(message, time, "info")
    end
end)