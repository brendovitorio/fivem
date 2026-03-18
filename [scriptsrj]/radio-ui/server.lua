local Tunnel = module('revolt', 'lib/Tunnel')
local Proxy = module('revolt', 'lib/Proxy')
local rEVOLT = Proxy.getInterface('rEVOLT')
local api = {}
Tunnel.bindInterface(GetCurrentResourceName(), api)

function api.getPlayerName(plySource)
    local playerId = rEVOLT.Passport(plySource)
    if playerId then
        local identity = rEVOLT.Identities(playerId)

        return '#' .. playerId .. ' ' .. (identity.name or '') .. ' ' .. (identity.name2 or '')
    end
end
