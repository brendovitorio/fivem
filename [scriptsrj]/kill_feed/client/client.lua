
AddEventHandler('gameEventTriggered', function(eventName, args)
    if eventName == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]

        if victim == PlayerPedId() and GetEntityHealth(victim) <= 100 and IsPedAPlayer(attacker) then
            local playerAttacker = NetworkGetPlayerIndexFromPed(attacker)
            local sourceAttacker = GetPlayerServerId(playerAttacker)

            TriggerServerEvent('kill_feed:tryRegisterKill', sourceAttacker)
        end
    end
end)

RegisterNetEvent('kill_feed:insertKill', function(data)
    SendNUIMessage({
        action = 'insertKill',
        data = {
            killer = data.killer,
            killed = data.killed
        }
    })
end)