local Proxy = module('revolt', 'lib/Proxy')
local rEVOLT = Proxy.getInterface('rEVOLT')

function getName(source)
    local Passport = rEVOLT.Passport(source)
    local Identity = rEVOLT.Identities(Passport)

    if Identity then
        return '#'.. Passport .. ' ' .. Identity.name .. ' ' .. Identity.name2
    end

    return 'Desconhecido'
end

function getOrganization(source)
    local Passport = rEVOLT.Passport(source)

    for permission, _ in pairs(Organizations) do
        if rEVOLT.HasGroup(Passport, permission) then
            return permission
        end
    end
end

RegisterServerEvent('kill_feed:tryRegisterKill', function(sourceKiller)
    local sourceKilled = source

    if sourceKilled and sourceKiller then
        local organization = getOrganization(sourceKiller)
        if organization then
            local nameKiller = getName(sourceKiller)
            local nameKilled = getName(sourceKilled)

            local users = rEVOLT.NumPermission(organization)

            for Passports, Sources in pairs(users) do
                async(function()
                    TriggerClientEvent('kill_feed:insertKill', Sources, {
                        killer = nameKiller,
                        killed = nameKilled
                    })
                end)
            end
        end
    end
end)