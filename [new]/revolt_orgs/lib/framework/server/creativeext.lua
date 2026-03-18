local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')
local resourceName = GetCurrentResourceName()

local framework = {}

local config = module(resourceName, 'config/config')

vRP.Prepare("mengazo/getAllDataTable","SELECT * FROM playerdata WHERE dkey = 'Datatable'")
vRP.Prepare('mengazo/getFactions','SELECT * FROM revolt_org')
vRP.Prepare('mengazo/checkFac','SELECT * FROM revolt_org WHERE faction = @fac')
vRP.Prepare('mengazo/setFarm','UPDATE revolt_org SET meta = @meta WHERE faction = @fac')
vRP.Prepare('mengazo/setBank','UPDATE revolt_org SET bank = @bank WHERE faction = @fac')
vRP.Prepare('mengazo/getPlayedTime','SELECT * FROM mengazo_facs WHERE user_id = @user_id')
vRP.Prepare('mengazo/updatePlayerTime', 'UPDATE mengazo_facs SET playedTime =  @time WHERE user_id = @user_id')
vRP.Prepare('mengazo/setPlayedTime','UPDATE mengazo_facs SET playedTime = playedTime + @time WHERE user_id = @user_id')
vRP.Prepare('mengazo/setFac','INSERT INTO revolt_org (faction, bank, data, max_members, contractions, meta) VALUES (@faction, @bank, @data, @members, 0, @meta)')
vRP.Prepare('addPlayerOnFac',[[
    INSERT INTO mengazo_facs (user_id,entered,fac,lastLogin,playedTime,farmed) 
    VALUES(@user_id,@entered,@fac,@lastLogin,@playedTime,@farmed)
    ON DUPLICATE KEY UPDATE
    entered = @entered,
    fac = @fac,
    lastLogin = @lastLogin,
    playedTime = @playedTime,
    farmed = @farmed;
]])
vRP.Prepare('removePlayerFac','DELETE FROM mengazo_facs WHERE user_id = @user_id')
vRP.Prepare('getPlayerFarm','SELECT * FROM mengazo_facs WHERE user_id = @user_id')
vRP.Prepare('setPlayerFarm','UPDATE mengazo_facs SET farmed = @farmed WHERE user_id = @user_id')
vRP.Prepare('updateLastLogin','UPDATE mengazo_facs SET lastLogin = @lastLogin WHERE user_id = @user_id')
vRP.Prepare('updatePlayerFarm','UPDATE mengazo_facs SET farmed = @farmed WHERE user_id = @user_id')
vRP.Prepare('selectPlayerStatus','SELECT * FROM mengazo_facs WHERE user_id = @user_id')
vRP.Prepare('addPlayerGettedReward','UPDATE mengazo_facs SET gettedReward = gettedReward + @gettedReward WHERE user_id = @user_id')
vRP.Prepare('updateContractions', 'UPDATE revolt_org SET contractions = contractions + @contractions where faction = @faction')
vRP.Prepare('updateValueRecompensa', 'UPDATE revolt_org SET value = @value where faction = @faction')
vRP.Prepare('getValueRecompensa', 'SELECT value FROM revolt_org WHERE faction = @faction')
vRP.Prepare('getSemanal','SELECT * FROM revolt_org ORDER BY contractions DESC')
vRP.Prepare('getDataFac','SELECT data FROM revolt_org WHERE faction = @faction')
vRP.Prepare('setDataFac','UPDATE revolt_org SET data = @data WHERE faction = @faction')
vRP.Prepare('setImagemFac','UPDATE revolt_org SET imagem = @imagem WHERE faction = @faction')
vRP.Prepare('setFactionPix','UPDATE revolt_org SET pix = @pix WHERE faction = @faction')
vRP.Prepare('mengazo/addBlackList','INSERT INTO mengazo_blacklist (user_id,time) VALUES(@user_id,@time)')
vRP.prepare('mengazo/deleteBlackLists','DELETE FROM mengazo_blacklist WHERE time + '..config.BLACKLIST_DAYS..' * 24 * 60 * 60 <= @time')
vRP.prepare('mengazo/deleteUserBlackLists','DELETE FROM mengazo_blacklist WHERE user_id = @user_id')
vRP.Prepare("mengazo/getUserBlacklist", "SELECT * FROM mengazo_blacklist WHERE user_id = @user_id")
vRP.Prepare("mengazo/updateUserBlacklist", "UPDATE mengazo_blacklist SET time = @time WHERE user_id = @user_id")
vRP.Prepare('mengazo/getPlayersFromFac', 'SELECT user_id FROM mengazo_facs WHERE fac = @faction')

function framework.getPlayerId(source)
    local playerId = vRP.Passport(source)
    return playerId
end

function framework.getPlayerName(playerId)
    local identity = vRP.Identity(playerId)

    if identity and identity.Name then
        return '#'..playerId..' '..identity.Name
    end

    return '#'..playerId
end

function framework.startScript()

end

function framework.setPlayerOnBlacklist(playerId)
    if playerId then
        vRP.Query('mengazo/addBlackList',{playerId = playerId, time = os.time()})
    end
end

function framework.isPlayerInBlacklist(playerId)
    local query = vRP.Query("mengazo/getUserBlacklist", { user_id = playerId })

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
    vRP.Query('mengazo/deleteUserBlackLists', {
        user_id = playerId
    })
end

function framework.sendWebhook(link, message)
    if link ~= nil and link ~= "" then
		PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

function framework.setPlayerInBlacklist(playerId)
    if framework.isPlayerInBlacklist(playerId) then
        vRP.Query("mengazo/updateUserBlacklist", { user_id = playerId, time = parseInt(os.time()) })
    else
        vRP.Query("mengazo/addBlackList", { user_id = playerId, time = parseInt(os.time()) })
    end
    local userIdentity = vRP.Identity(playerId)
    if userIdentity then
        local name = userIdentity.Name or userIdentity.name or ''
        local firstname = userIdentity.Lastname or userIdentity.firstname or ''
        framework.sendWebhook(config.BLACKLIST_WEBHOOK,"```prolog\n[ID]: "..playerId.. " "..name.. " "..firstname.."\n[ENTROU EM BLACKLIST]: "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    end
end

function framework.playerCanPayForSomething(playerId, value)
    return vRP.PaymentFull(playerId, value) 
end

function framework.sendPlayerRequest(playerSource, request)
    local requisition = vRP.Request(playerSource,request,'Sim','Nao')

    return requisition
end

function framework.getPlayerDatatable(playerId)

    local userData = vRP.Datatable(playerId)
    if userData then
        
        return userData, true

    else
        local userData = vRP.UserData(playerId, 'Datatable')
        
        return userData, false
    end

    -- here is a return of data and online player status
end

function framework.getPlayerSource(playerId)
    local playerSource = vRP.Source(playerId)

    return playerSource
end

function framework.getFactionData(faction)
    if faction then
        local data = vRP.Query('getDataFac', {faction = faction})
        if data then
            local correctData = json.decode(data[1].data) or {}

            return correctData
        end
    end

    return {}
end

function framework.setFactionData(faction, data)
    if faction then
        vRP.Query('setDataFac', {data = json.encode(data), faction = faction})
    end
end

function framework.getPlayerStatus(playerId)
    local status = vRP.Query('selectPlayerStatus', {user_id = playerId})

    if status[1] then
        return status
    end

    return {}
end

function framework.getCurrentReward(faction)
    return vRP.Query('getValueRecompensa', {faction = faction})
end

function framework.givePlayerMoney(playerId, amount)
    vRP.GiveBank(playerId, amount)
end

function framework.setPlayerRewardCollected(playerId, value)
    framework.givePlayerMoney(playerId, value)
    vRP.Query('addPlayerGettedReward', {user_id = playerId, gettedReward = 1})
end

function framework.hasPermission(playerId, permission)
    return vRP.HasPermission(playerId, permission)
end

function framework.removePlayerGroup(playerId, group, ignoreUpdate)
    vRP.RemovePermission(playerId, group)

    --[[ local dataGroup = vRP.DataGroups(group)
    dataGroup[tostring(playerId)] = nil
    vRP.SetSrvData('Permissions:'..group, dataGroup, true) ]]
end

function framework.addPlayerGroup(playerId, group, ignoreUpdate, hierarchy)
    vRP.SetPermission(playerId, group, tostring(hierarchy))

    --[[ local dataGroup = vRP.DataGroups(group)
    dataGroup[tostring(playerId)] = hierarchy
    vRP.SetSrvData('Permissions:'..group, dataGroup, true) ]]
end

function framework.deletePlayerFromFaction(playerId)
    vRP.Query('removePlayerFac', {user_id = playerId})
end

function framework.query(prepare, params)
    local query = vRP.Query(prepare, params)
    return query
end

function framework.execute(prepare, params)
    return vRP.Query(prepare, params)
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
}

local translatedNotifications = {
    ['sucesso'] = 'verde',
    ['negado'] = 'vermelho',
    ['importante'] = 'amarelo'
}

function framework.notify(source, typeNotify, index, ...)
    local args = { ... }

    local message = notificationsLangage[index]
    if message then
        if not timer then timer = 10000 end
        
        if args[1] ~= nil then
            message = string.format(message, table.unpack(args))
        end

        local typeNotify = translatedNotifications[typeNotify] or 'verde'
        
        TriggerClientEvent('Notify', source, typeNotify, message, timer)
    end
end

function framework.dataGroups(group)
    return vRP.DataGroups(group)
end


vRP.Prepare('mengazo/getMembersFromFac', 'select * from mengazo_facs where fac = @fac')
RegisterCommand('cleanpanel', function(source, args)
    local playerId = vRP.Passport(source)

    if args[1] and vRP.HasPermission(playerId, config.ADMIN_PERMISSION) then
        local members = vRP.Query('mengazo/getMembersFromFac', {
            fac = args[1]
        })

        if members[1] then
            for key, object in pairs(members) do
                local player = object.user_id
                
                local playerData, online = framework.getPlayerDatatable(player)

                local userOrg, userGroup = getUserInfo(player, playerData.groups)


                if userGroup then
                    if online then
                        framework.removePlayerGroup(player, userGroup)
                    else
                        demotePlayerOffLine(player, userOrg)
                    end

                    demotePlayerFromFaction(userOrg, player, online and vRP.Source(player) or nil, userGroup)
                end
            end
        else
            TriggerClientEvent('Notify', source, 'vermelho', 'Facção não possui membros.', 5000)
        end
    end
end)


return framework