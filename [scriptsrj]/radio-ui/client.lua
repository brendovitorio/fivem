local Tunnel = module('revolt', 'lib/Tunnel')
local apiServer = Tunnel.getInterface(GetCurrentResourceName())

local registeredInformation = {}
local playersTalking = {}

RegisterNetEvent('radioUi:removeSourceInformation', function(plySource)
    if registeredInformation[plySource] then
        registeredInformation[plySource] = nil
    end
end)

function updatePlayerTalking(plySource, talking)
    playersTalking[plySource] = talking

    local informations = {
        source = plySource
    }

    if talking then
        if not registeredInformation[plySource] then
            registeredInformation[plySource] = apiServer.getPlayerName(plySource)
        end

        informations.name = registeredInformation[plySource]
    end



    SendNUIMessage({
        action = 'update',
        data = {
            talking = talking,
            informations = informations
        }
    })
end

RegisterNetEvent('radio:updateUi', function(plySource, talking)
    updatePlayerTalking(plySource, talking)
end)