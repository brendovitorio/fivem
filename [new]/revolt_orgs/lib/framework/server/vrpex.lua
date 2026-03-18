local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')
local resourceName = GetCurrentResourceName()

local framework = {}

local config = module(resourceName, 'config/config')

vRP._prepare("mengazo/getAllDataTable","SELECT * FROM vrp_user_data WHERE dkey = 'vRP:datatable'")
vRP._prepare('mengazo/getFactions','SELECT * FROM revolt_orgpainel')
vRP._prepare('mengazo/checkFac','SELECT * FROM revolt_orgpainel WHERE faction = @fac')
vRP._prepare('mengazo/updatePlayerTime', 'UPDATE revolt_orgfacs SET playedTime =  @time WHERE user_id = @user_id')
vRP._prepare('mengazo/setFarm','UPDATE revolt_orgpainel SET meta = @meta WHERE faction = @fac')
vRP._prepare('mengazo/setBank','UPDATE revolt_orgpainel SET bank = @bank WHERE faction = @fac')
vRP._prepare('mengazo/getPlayedTime','SELECT * FROM revolt_orgfacs WHERE user_id = @user_id')
vRP._prepare('mengazo/setPlayedTime','UPDATE revolt_orgfacs SET playedTime = playedTime + @time WHERE user_id = @user_id')
vRP._prepare('mengazo/setFac','INSERT INTO revolt_orgpainel (faction, bank, data, max_members, contractions, meta) VALUES (@faction, @bank, @data, @members, 0, @meta)')
vRP._prepare('addPlayerOnFac',[[
    INSERT INTO revolt_orgfacs (user_id,entered,fac,lastLogin,playedTime,farmed) 
    VALUES(@user_id,@entered,@fac,@lastLogin,@playedTime,@farmed)
    ON DUPLICATE KEY UPDATE
    entered = @entered,
    fac = @fac,
    lastLogin = @lastLogin,
    playedTime = @playedTime,
    farmed = @farmed;
]])
vRP._prepare('removePlayerFac','DELETE FROM revolt_orgfacs WHERE user_id = @user_id')
vRP._prepare('getPlayerFarm','SELECT * FROM revolt_orgfacs WHERE user_id = @user_id')
vRP._prepare('setPlayerFarm','UPDATE revolt_orgfacs SET farmed = @farmed WHERE user_id = @user_id')
vRP._prepare('updateLastLogin','UPDATE revolt_orgfacs SET lastLogin = @lastLogin WHERE user_id = @user_id')
vRP._prepare('updatePlayerFarm','UPDATE revolt_orgfacs SET farmed = @farmed WHERE user_id = @user_id')
vRP._prepare('selectPlayerStatus','SELECT * FROM revolt_orgfacs WHERE user_id = @user_id')
vRP._prepare('addPlayerGettedReward','UPDATE revolt_orgfacs SET gettedReward = gettedReward + @gettedReward WHERE user_id = @user_id')
vRP._prepare('updateContractions', 'UPDATE revolt_orgpainel SET contractions = contractions + @contractions where faction = @faction')
vRP._prepare('updateValueRecompensa', 'UPDATE revolt_orgpainel SET value = @value where faction = @faction')
vRP._prepare('getValueRecompensa', 'SELECT value FROM revolt_orgpainel WHERE faction = @faction')
vRP._prepare('getSemanal','SELECT * FROM revolt_orgpainel ORDER BY contractions DESC')
vRP._prepare('getMoneyRanking','SELECT * FROM revolt_orgpainel ORDER BY bank DESC')
vRP._prepare('getDataFac','SELECT data FROM revolt_orgpainel WHERE faction = @faction')
vRP._prepare('setDataFac','UPDATE revolt_orgpainel SET data = @data WHERE faction = @faction')
vRP._prepare('setImagemFac','UPDATE revolt_orgpainel SET imagem = @imagem WHERE faction = @faction')
vRP._prepare('setFactionPix','UPDATE revolt_orgpainel SET pix = @pix WHERE faction = @faction')
vRP._prepare('mengazo/addBlackList','INSERT INTO revolt_orgblacklist (user_id,time) VALUES(@user_id,@time)')
vRP._prepare('mengazo/deleteBlackLists','DELETE FROM revolt_orgblacklist WHERE time + '..config.BLACKLIST_DAYS..' * 24 * 60 * 60 <= @time')
vRP._prepare('mengazo/deleteUserBlackLists','DELETE FROM revolt_orgblacklist WHERE user_id = @user_id')
vRP._prepare("mengazo/getUserBlacklist", "SELECT * FROM revolt_orgblacklist WHERE user_id = @user_id")
vRP._prepare("mengazo/updateUserBlacklist", "UPDATE revolt_orgblacklist SET time = @time WHERE user_id = @user_id")
vRP._prepare('mengazo/getPlayersFromFac', 'SELECT user_id FROM revolt_orgfacs WHERE fac = @faction')

function framework.getPlayerId(source)
    local playerId = vRP.getUserId(source)
    return playerId
end

function framework.getPlayerName(playerId)
    local identity = vRP.getUserIdentity(playerId)

    if identity and identity.name then
        return '#'..playerId..' '..identity.name
    end

    return '#'..playerId
end

function framework.startScript()

end

function framework.setPlayerOnBlacklist(playerId)
    if playerId then
        vRP.execute('mengazo/addBlackList',{playerId = playerId, time = os.time()})
    end
end

function framework.isPlayerInBlacklist(playerId)
    local query = vRP.query("mengazo/getUserBlacklist", { user_id = playerId })

    local blacklistInSeconds = config.BLACKLIST_DAYS * 24 * 60 * 60

    local timeBeforeBlacklist = os.time() - blacklistInSeconds


    if query[1] then
        if tonumber(query[1].time) <= timeBeforeBlacklist then
            framework.deleteUserBlacklist(playerId)
            return false
        else
            return true
        end
    end

    return false
end

function framework.deleteUserBlacklist(playerId)
    vRP.execute('mengazo/deleteUserBlackLists', {
        user_id = playerId
    })
end

function framework.sendWebhook(link, message)
    if link ~= nil and link ~= "" then
		PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

function tableHasValue(table, index)
    for key, value in pairs(table) do
        if type(index) == 'table' then
            for _, information in ipairs(index) do
                if information == key then
                    return value
                end
            end
        else
            if key == index then
                return value
            end
        end
    end
end

function framework.getPlayerName(playerId)
    local identity = vRP.getUserIdentity(playerId)

    if identity then

        local name = tableHasValue(identity, {
            'name', 'nome', 'Name'
        })

        local firstname = tableHasValue(identity, {
            'firstname', 'name2', 'FirstName', 'Lastname', 'Name2'
        })

        return name .. ' ' .. firstname

    end

    return false
end

function framework.setPlayerInBlacklist(playerId)
    if framework.isPlayerInBlacklist(playerId) then
        vRP.execute("mengazo/updateUserBlacklist", { user_id = playerId, time = parseInt(os.time()) })
    else
        vRP.execute("mengazo/addBlackList", { user_id = playerId, time = parseInt(os.time()) })
    end
    local playerName = framework.getPlayerName(playerId)

    if playerName then
        framework.sendWebhook(config.BLACKLIST_WEBHOOK,"```prolog\n[ID]: "..playerId.. " "..playerName.."\n[ENTROU EM BLACKLIST]: "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    end
end

function framework.playerCanPayForSomething(playerId, value)
    return vRP.tryFullPayment(playerId, value) 
end

function framework.sendPlayerRequest(playerSource, request)
    local requisition = vRP.request(playerSource,request,30)

    return requisition
end

function framework.getPlayerDatatable(playerId)

    local userData = vRP.getUserDataTable(playerId)
    if userData then
        
        return userData, true

    else
        local userData = json.decode(vRP.getUData(playerId, 'vRP:datatable')) or {}
        
        return userData, false
    end

    -- here is a return of data and online player status
end

function framework.getPlayerSource(playerId)
    local playerSource = vRP.getUserSource(playerId)

    return playerSource
end

function framework.getFactionData(faction)
    if faction then
        local data = vRP.query('getDataFac', {faction = faction})
        if type(data) == 'table' and data[1] then
            local correctData = json.decode(data[1].data) or {}

            return correctData
        end
    end

    return {}
end

function framework.setFactionData(faction, data)
    if faction then
        vRP.execute('setDataFac', {data = json.encode(data), faction = faction})
    end
end

function framework.getPlayerStatus(playerId)
    local status = vRP.query('selectPlayerStatus', {
        user_id = playerId
    })

    if status[1] then
        return status
    end

    return {}
end

function framework.getCurrentReward(faction)
    return vRP.query('getValueRecompensa', {faction = faction})
end

function framework.givePlayerMoney(playerId, amount)
    vRP.giveBankMoney(playerId, amount)
end

function framework.setPlayerRewardCollected(playerId, value)
    framework.givePlayerMoney(playerId, value)
    vRP.execute('addPlayerGettedReward', {user_id = playerId, gettedReward = 1})
end

function framework.hasPermission(playerId, permission)
    return vRP.hasPermission(playerId, permission)
end

function framework.removePlayerGroup(playerId, group, ignoreUpdate)
    vRP.removeUserGroup(playerId, group, ignoreUpdate)
end

function framework.addPlayerGroup(playerId, group, ignoreUpdate)
    vRP.addUserGroup(playerId, group, ignoreUpdate)
end

function framework.deletePlayerFromFaction(playerId)
    vRP.execute('removePlayerFac', {user_id = playerId})
end

function framework.query(prepare, params)
    local query = vRP.query(prepare, params)
    return query
end

function framework.execute(prepare, params)
    return vRP.execute(prepare, params)
end

local notificationsLangage = {
    ['outSpace'] = 'Organização cheia!',
    ['inOtherOrg'] = 'Cidadão já pertence à outra organização!',
    ['biggerRole'] = 'Cidadão já está no cargo mais alto!',
    ['lowerRole'] = 'Cidadão já está no menor cargo!',
    ['denyRequest'] = 'Cidadão recusou o pedido!',
    ['inBlackList'] = 'Cidadão em blacklist',
    ['payedBlacklist'] = 'Você pagou para a remoção da blacklist!',
    ['noMoney'] = 'Você não tem dinheiro suficiente!',
    ['removedFromBlacklist'] = 'Você removeu a blacklist do id %s',
    ['acceptedRequestJoin'] = 'Você entrou na organização %s',
    ['promoted'] = 'Voce acaba de ser promovido a %s',
    ['demoted'] = 'Voce acaba de ser rebaixado a %s',
    ['playerOffline'] = 'Jogador está ausente',
    ['requestedJoin'] = 'Voce enviou a solicitação para o jogador %s',
    ['removedFromOrg'] = 'Voce foi removido da organizacao %s',
    ['removedPlayer'] = 'Voce removeu o cidadao %s da organizacao',
    ['rewardCollected'] = 'Voce coletou %s com sucesso!',
    ['autoExitOrganization'] = 'Voce saiu da organizacao!'
}

function framework.notify(source, typeNotify, index, ...)
    local args = { ... }

    local message = notificationsLangage[index]

    if not timer then timer = 10000 end

    if args[1] ~= nil then
        message = string.format(message, table.unpack(args))
    end

    TriggerClientEvent('Notify', source, typeNotify, message, timer)
end

function framework.dataGroups(group)
    return vRP.DataGroups(group)
end


vRP.prepare('mengazo/getMembersFromFac', 'select * from revolt_orgfacs where fac = @fac')
RegisterCommand('cleanpanel', function(source, args)
    local playerId = vRP.getUserId(source)

    if args[1] and vRP.hasPermission(playerId, config.ADMIN_PERMISSION) then
        local members = vRP.query('mengazo/getMembersFromFac', {
            fac = args[1]
        })

        if members[1] then
            for key, object in pairs(members) do
                local player = tonumber(object.user_id)
                
                local playerData, online = framework.getPlayerDatatable(player)

                if playerData and playerData.groups then
                    
                    local userOrg, userGroup = getUserInfo(player, playerData.groups)
                    
                    if userGroup then
                        if online then
                            framework.removePlayerGroup(player, userGroup)
                        else
                            demotePlayerOffLine(player, userOrg)
                        end
                        
                        removePlayerFromData(userOrg, player)
                        setUserInBlacklist(player)
                        
                        if online then
                            local playerSource = framework.getUserSource(player)
                            
                            removeUserRole(playerSource, userOrg, userGroup)      
                            
                            framework.notify(playerSource, 'importante', 'removedFromOrg', args[1])
                        end
                        
                        print('removendo player da fac', player, userGroup, userOrg)
                    end
                end
            end
        else
            TriggerClientEvent('Notify', source, 'importante', 'Facção não possui membros.', 5000)

        end

    end
end)

return framework