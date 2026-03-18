local ACTIVED_INSPECTS <const> = {}



AddEventHandler("playerDropped", function()
    local src = source
    if ACTIVED_INSPECTS[src] then
        local type = ACTIVED_INSPECTS[src].type
        if type == "thief" then
            local target = ACTIVED_INSPECTS[src].user
            local targetInfo = ACTIVED_INSPECTS[target]
            ClearPedTasksImmediately(GetPlayerPed(target))
            rEVOLTc._playAnim(target, true, {{ "random@arrests@busted", "exit" }}, false)
            ACTIVED_INSPECTS[src] = nil
            ACTIVED_INSPECTS[target] = nil
        else
            local target = ACTIVED_INSPECTS[src].user
            ClearPedTasksImmediately(GetPlayerPed(target))
            ACTIVED_INSPECTS[src] = nil
            ACTIVED_INSPECTS[target] = nil
            Remote._sendNuiEvent(target, {
                route = "CLOSE_INVENTORY",
                ignoreRight = true
            })
        end
    end
end)

AddCloseListener(function(src, user_id)
    if ACTIVED_INSPECTS[src] then
        local type = ACTIVED_INSPECTS[src].type
        if type == "thief" then
            local target = ACTIVED_INSPECTS[src].user
            local targetInfo = ACTIVED_INSPECTS[target]
            ACTIVED_INSPECTS[src] = nil
            ACTIVED_INSPECTS[target] = nil
            ClearPedTasksImmediately(GetPlayerPed(target))
            ClearPedTasksImmediately(GetPlayerPed(src))
            rEVOLTc._stopAnim(src)
            FreezeEntityPosition(GetPlayerPed(target), false)
            rEVOLTc._playAnim(target, true, {{ "random@arrests@busted", "exit" }}, false)
        end
    end
end)

vPOLICIA = Tunnel.getInterface("policia")


---@param source number
RegisterCommand("revistar", function(source)
    local source = source
    local ped = GetPlayerPed(source)
    if (GetEntityHealth(ped) <= 101) then
        print('_a')
        return
    end
    if GetPlayerRoutingBucket(source) ~= 0 then
        print('_bucket')
        return
    end
    local user_id = rEVOLT.getUserId(source)
    if user_id then
        local nplayer = rEVOLTc.getNearestPlayer(source, 5)

        if not nplayer then
            Notify(source, 'negado', 'Ninguém por perto.')
            return
        end

        if vPOLICIA.inSafe(source) then
            TriggerClientEvent('Notify', source, 'negado', 'Você não pode revistar dentro de uma safe-zone.')
            return
        end
 

        if GetVehiclePedIsIn(ped) > 0 then
            TriggerClientEvent('Notify', source, 'negado', 'Você não pode revistar dentro do veiculo.')
            return
        end

        if rEVOLTc.checkAnim(nplayer) then
            return Notify(source, 'negado', 'O jogador não está rendido.')
        end

        if ACTIVED_INSPECTS[source] then
            Notify(source, 'negado', 'Você já está revistando alguém.')
            return
        elseif ACTIVED_INSPECTS[nplayer] then
            Notify(source, 'negado', 'Este jogador já está revistando ou sendo revistado.')
            return
        end

        local targetPed = GetPlayerPed(nplayer)
        local plyPed = GetPlayerPed(source)

        if (GetEntityHealth(plyPed) <= 101) then
            Notify(source, 'negado', 'Voce nao pode fazer isto morto.')
            return
        end

        if #(GetEntityCoords(targetPed) - GetEntityCoords(plyPed)) > 5 then
            Notify(source, 'negado', 'Este jogador está muito longe.')
            return
        end
        local blockedTime = exports.admin:isUserBlocked(user_id)
        if blockedTime then
            Notify(source, 'negado', 'Você está em modo novato! Aguarde até '..blockedTime.." para poder lootear alguém.")
            return
        end
        Remote.sendNuiEvent(
            nplayer,
            {
                route = 'CLOSE_INVENTORY'
            }
        )

        local targetId = rEVOLT.getUserId(nplayer)
        if rEVOLT.hasPermission(targetId,"perm.disparo") and rEVOLT.checkPatrulhamento(targetId) then 
            return false 
        end

        local identity = rEVOLT.getUserIdentity(user_id)
        if (GetEntityHealth(targetPed) <= 101 or 
            vPOLICIA.checkAnim(nplayer) or 
            rEVOLTc.isHandcuffed(nplayer) or 
            rEVOLT.hasPermission(user_id, 'policia.permissao') or 
            rEVOLT.hasPermission(user_id, 'perm.disparo') or 
            rEVOLT.hasPermission(user_id, 'admin.permissao') or 
            rEVOLT.request(nplayer, 'Você aceita ser revistado por ' .. identity.nome .. ' ' .. identity.sobrenome .. '?', 30)) then
            Remote.SetInventoryBlocked(nplayer, 5)

            if GetPlayerRoutingBucket(nplayer) ~= 0 then
                Notify(source, 'negado', 'Jogador no PVP.')
                Notify(nplayer, 'negado', 'Você não pode ser revistado na arena.')
                return false
            end

            -- if rEVOLT.hasPermission(targetId, 'developer.permissao')  or rEVOLT.hasGroup(targetId, 'respilegallotusgroup@445') then
            --     Notify(source, 'negado', 'Esse jogador não pode ser revistado.')
            --     return false
            -- end

            if rEVOLT.hasPermission(targetId, 'policia.permissao') or rEVOLT.hasPermission(targetId, 'perm.judiciario') then
                Notify(source, 'negado', 'Este jogador é um policial.')
                return false
            end
            
            if rEVOLT.hasGroup(targetId, 'block') then
                Notify(source, 'negado', 'Este jogador não pode ser revistado.')
                return
            end

            if (rEVOLT.hasPermission(targetId, 'perm.bombeiro') or rEVOLT.hasPermission(targetId, 'perm.bombeirocivil') or rEVOLT.hasPermission(targetId, 'perm.unizk') or rEVOLT.hasPermission(targetId, 'perm.judiciario')) and rEVOLT.checkPatrulhamento(targetId) then
                Notify(source, 'negado', 'Este jogador faz parte do Hospital.')
                return false
            end

            -- if rEVOLT.hasPermission(targetId, 'admin.permissao') then
            --     Notify(source, 'negado', 'Este jogador faz parte da administração.')
            --     return false
            -- end

            ACTIVED_INSPECTS[nplayer] = {
                type = 'stolen',
                user = source,
                drag_and_drop = true
            }

            ACTIVED_INSPECTS[source] = {
                type = 'thief',
                user = nplayer,
                drag_and_drop = false
            }
            Remote.sendNuiEvent(
                nplayer,
                {
                    route = 'CLOSE_INVENTORY'
                }
            )
            local weapons = rEVOLT.clearWeapons(targetId)
            for k, v in pairs(weapons) do
                local item = string.lower(k)
                rEVOLT.giveInventoryItem(targetId, item, 1)
                if v.ammo > 0 then
                    rEVOLT.giveInventoryItem(targetId, 'ammo_' .. (item:gsub("weapon_", "")), v.ammo)
                end
            end

            if (GetEntityHealth(targetPed) <= 101) then
                rEVOLTc._playAnim(source, false, {{ 'amb@medic@standing@tendtodead@idle_a', 'idle_a' }}, true)
            else
                rEVOLTc._playAnim(source, false, {{ 'misscarsteal4@director_grip', 'end_loop_grip' }}, true)
                FreezeEntityPosition(GetPlayerPed(nplayer), true)
                rEVOLTc._playAnim(nplayer, true, {{ 'random@arrests@busted', 'idle_a' }}, true)
                Notify(nplayer, 'importante', 'Você está sendo revistado!')
            end

            local identity = rEVOLT.getUserIdentity(targetId)
            Remote._openInspect(
                source,
                {
                    target = {
                        target_id = targetId,
                        target_name = identity.nome .. ' ' .. identity.sobrenome,
                        inventory = rEVOLT.getInventory(targetId),
                        weight = rEVOLT.computeInvWeight(targetId),
                        max_weight = rEVOLT.getInventoryMaxWeight(targetId)
                    },
                    source = {
                        inventory = rEVOLT.getInventory(user_id),
                        weight = rEVOLT.computeInvWeight(user_id),
                        max_weight = rEVOLT.getInventoryMaxWeight(user_id)
                    }
                }
            )
        else
            Notify(source, 'negado', 'Este jogador não aceitou ser revistado.')
        end
    end
end, false)

RegisterCommand("invsee", function(source, args)
    local user_id = rEVOLT.getUserId(source)
    if not user_id then return end

    local targetId = tonumber(args[1])
    if not targetId or targetId <= 0 then 
        return 
    end

    local perms = {
        { permType = 'perm', perm = 'developer.permissao' },
        { permType = 'perm', perm = 'perm.respilegal' },
        { permType = 'group', perm = 'resploglotusgroup@445' },
        { permType = 'group', perm = 'respstafflotusgroup@445' },
    }

    local hasPermission = false
    for _, perm in ipairs(perms) do
        if perm.permType == 'perm' and rEVOLT.hasPermission(user_id, perm.perm) then
            hasPermission = true
            break
        elseif perm.permType == 'group' and rEVOLT.hasGroup(user_id, perm.perm) then
            hasPermission = true
            break
        end
    end

    if not hasPermission then 
        return 
    end

    local nplayer = rEVOLT.getUserSource(targetId)
    if not nplayer then
        Notify(source, 'negado', 'Jogador não encontrado.')
        return
    end

    if rEVOLT.hasGroup(targetId, 'block') then
        Notify(source, 'negado', 'Este jogador não pode ser revistado.')
        return
    end

    Remote.sendNuiEvent(
        nplayer,
        {
            route = 'CLOSE_INVENTORY'
        }
    )
    Remote.SetInventoryBlocked(nplayer, 5)

    ACTIVED_INSPECTS[nplayer] = {
        type = 'stolen',
        user = source,
        drag_and_drop = false
    }
    ACTIVED_INSPECTS[source] = {
        type = 'thief',
        user = nplayer,
        drag_and_drop = false
    }

    Remote.sendNuiEvent(
        nplayer,
        {
            route = 'CLOSE_INVENTORY'
        }
    )

    local weapons = rEVOLT.clearWeapons(targetId)
    for k, v in pairs(weapons) do
        local item = string.lower(k)
        rEVOLT.giveInventoryItem(targetId, item, 1)
        if v.ammo > 0 then
            rEVOLT.giveInventoryItem(targetId, 'ammo_' .. (item:gsub("weapon_", "")), v.ammo)
        end
    end

    local identity = rEVOLT.getUserIdentity(targetId)
    Remote._openInspect(
        source,
        {
            target = {
                target_id = targetId,
                target_name = identity.nome .. ' ' .. identity.sobrenome,
                inventory = rEVOLT.getInventory(targetId),
                weight = rEVOLT.computeInvWeight(targetId),
                max_weight = rEVOLT.getInventoryMaxWeight(targetId)
            },
            source = {
                inventory = rEVOLT.getInventory(user_id),
                weight = rEVOLT.computeInvWeight(user_id),
                max_weight = rEVOLT.getInventoryMaxWeight(user_id)
            }
        }
    )

    rEVOLT.sendLog('', ( [[O USER_ID %s REVISTOU O USER_ID %s]] ):format(user_id, targetId))
end)

---@param from_slot string
---@param to_slot string
---@param amount number
---@return boolean | table
function API.takeInspectItem(from_slot, to_slot, amount)
    local source = source
    local user_id = rEVOLT.getUserId(source)
    if user_id then
        if (ACTIVED_INSPECTS[source] and ACTIVED_INSPECTS[source].type == "thief") then
            if rEVOLT.checkPatrulhamento(user_id) or rEVOLT.checkPatrulhamento(target_id) or rEVOLT.hasPermission(user_id,"perm.disparo") or rEVOLT.hasPermission(target_id,"perm.disparo") then 
                return false, TriggerClientEvent("Notify",source,"negado","Você não pode fazer isso.",5)
            end

            local target_source = ACTIVED_INSPECTS[source].user
            local target_id     = rEVOLT.getUserId(target_source)
            local slot_data     = rEVOLT.getSlotItem(target_id, from_slot)
            if slot_data then
                if rEVOLT.computeInvWeight(user_id) + ((ResolveItemData(slot_data.item) and ResolveItemData(slot_data.item).weight or 0) * amount) > rEVOLT.getInventoryMaxWeight(user_id) then
                    Notify(source, "negado", "Espaço insuficiente na mochila.")
                    return {
                        error = "Espaço insuficiente na mochila."
                    }
                end

                if (slot_data.item):upper() == 'WEAPON_PISTOL' or (slot_data.item):upper() == 'AMMO_PISTOL' 
                or (slot_data.item):lower() == 'riopan' or (slot_data.item):lower() == 'coumadin' then
                    TriggerClientEvent("Notify",source,"negado","Você não pode pegar armas ou munições.")
                    return
                end
                amount = ((amount or 1) > slot_data.amount) and slot_data.amount or amount
                if rEVOLT.tryGetInventoryItem(target_id, slot_data.item, amount, from_slot) then
                    rEVOLT.giveInventoryItem(user_id, slot_data.item, amount, to_slot)
                    exports["admin"]:generateLog({
                        category = "inventario",
                        room = "saquear",
                        user_id = user_id,
                        target_id = target_id,
                        message = ( [[O USER_ID %s RETIROU %s %s DO INVENTARIO DO USER_ID %s]] ):format(user_id,amount, slot_data.item,target_id)
                    })
                    rEVOLT.sendLog('https://discord.com/api/webhooks/1313515436603736065/0S5MlfLJNcUW0bisjUCVIIODx2AL0SKz9bVftATBllXIp8c2FX8Sbx-oQ6E6AfF0eeoK', ( [[O USER_ID %s RETIROU %s %s DO INVENTARIO DO USER_ID %s]] ):format(user_id,amount, slot_data.item,target_id))

                    return true
                end
            end
        else
            return {
                error = "Reviste novamente!"
            }
        end
    end
    return {
        error = "Reviste novamente!"
    }
end

---@param from_slot string
---@param to_slot string
---@param amount number
---@return boolean | table
function API.putInspectItem(from_slot, to_slot, amount)
    local source = source
    local user_id = rEVOLT.getUserId(source)
    if user_id then
        if (ACTIVED_INSPECTS[source] and ACTIVED_INSPECTS[source].type == "thief") then
            local target_source = ACTIVED_INSPECTS[source].user
            local target_source_ped = GetPlayerPed(target_source)
            local target_source_health = GetEntityHealth(target_source_ped)
            local target_source_ped_coords = GetEntityCoords(target_source_ped)
            local ped = GetPlayerPed(source)
            local ped_coords = GetEntityCoords(ped)
            local dist = #(target_source_ped_coords - ped_coords)
            if (dist >= 10.0) then
                return {
                    error = 'Você não pode enviar itens para um player distante.'
                }
            end
            if (target_source_health <= 101) then
                return {
                    error = 'Você não pode enviar itens para um morto.'
                }
            end
            local target_id = rEVOLT.getUserId(target_source)
            local slot_data = rEVOLT.getSlotItem(user_id, from_slot)
            if slot_data then
                if rEVOLT.computeInvWeight(target_id) + ((ResolveItemData(slot_data.item) and ResolveItemData(slot_data.item).weight or 0) * amount) > rEVOLT.getInventoryMaxWeight(target_id) then
                    return {
                        error = "Espaço insuficiente na mochila."
                    }
                end
                amount = ((amount or 1) > slot_data.amount) and slot_data.amount or amount
                if rEVOLT.tryGetInventoryItem(user_id, slot_data.item, amount, from_slot) then
                    rEVOLT.giveInventoryItem(target_id, slot_data.item, amount, to_slot)
                    local identity = rEVOLT.getUserIdentity(user_id)
                    return true
                end
            end
        else
            return {
                error = "Reviste novamente!"
            }
        end
    end
    return {
        error = "Reviste novamente!"
    }
end

_G.isPlayerInspecting = function(src)
    return ACTIVED_INSPECTS[src] ~= nil
end
