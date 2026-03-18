local blips = {}
local func = {
    getCooldown = function(self, user_id, key)
        if rEVOLT and rEVOLT.getCooldown then
            return rEVOLT.getCooldown(user_id, key)
        end
        return true, 0
    end,
    setCooldown = function(self, user_id, key, seconds)
        if rEVOLT and rEVOLT.setCooldown then
            return rEVOLT.setCooldown(user_id, key, seconds)
        end
        return true
    end,
    setBlockCommand = function(self, user_id, seconds)
        if rEVOLT and rEVOLT.setBlockCommand then
            return rEVOLT.setBlockCommand(user_id, seconds)
        end
        return true
    end,
    alertPolice = function(self, data)
        if rEVOLT and rEVOLT.alertPolice then
            return rEVOLT.alertPolice(data)
        end
        return true
    end
}


local OthersDrugs = function(user_id, source, item, slot, cb)
    if rEVOLT.hasPermission(user_id, 'perm.kids') then
        TriggerClientEvent("Notify", source, "negado", "Você não pode usar droga..", 5)
        return cb(false)
    end
    if not Remote.isInDrug(source) then
        if GetEntityHealth(GetPlayerPed(source)) > 101 then
            if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                rEVOLTc._playAnim(source, true, { { "mp_player_int_uppersmoke", "mp_player_int_smoke" } }, true)

                if item == "balinha" then
                    Remote._useBandagem(source, true, 'Balinha')
                end

                if item == 'maconha' then
                    TriggerClientEvent('activateNitro', source)
                end

                SetTimeout(2000,
                    function()
                        rEVOLTc._stopAnim(source, false)
                        TriggerClientEvent("inventory:useDrugs", source, item)
                    end)
                return cb(true)
            end
        end
    end
    return cb(false)
end

local Beber = function(user_id, source, item, slot, cb)
    TriggerClientEvent("progress", source, 5)
    play_drink(source, item, 5)
    SetTimeout(5000, function()
        if item == "water" then
            rEVOLT.giveInventoryItem(user_id, "emptybottle", amount, true)
        end
    end)
    return cb(true)
end
local Remedio = function(user_id, source, item, slot, cb)
end

local Beber_Alcoolico = function(user_id, source, item, slot, cb)
    func:setCooldown(user_id, "inventario", 10)

    TriggerClientEvent("progress", source, 10, "Bebendo")
    play_drink(source, item, 10)

    SetTimeout(15 * 1000, function()
        rEVOLTc._playScreenEffect(source, "RaceTurbo", 60)
        rEVOLTc._playScreenEffect(source, "DrugsTrevorClownsFight", 60)
        Remote._SetAnim(source, amount)
    end)
end
function play_drink(source, tipo, segundos)
    local prop = ""
    -- BEBIDAS
    if tipo == "energetico" then
        prop = "prop_energy_drink"
    elseif tipo == "water" then
        prop = "prop_ld_flow_bottle"
    elseif tipo == "cafe" then
        prop = "prop_fib_coffee"
    elseif tipo == "cocacola" then
        prop = "ng_proc_sodacan_01a"
    elseif tipo == "sucol" then
        prop = "ng_proc_sodacan_01b"
    elseif tipo == "sucol2" then
        prop = "ng_proc_sodacan_01b"
    elseif tipo == "sprunk" then
        prop = "ng_proc_sodacan_01b"

        -- BEBIDAS ALCOLICAS
    elseif tipo == "cerveja" then
        prop = "prop_amb_beer_bottle"
    elseif tipo == "whisky" then
        prop = "prop_drink_whisky"
    elseif tipo == "vodka" then
        prop = "p_whiskey_notop"
    elseif tipo == "pinga" then
        prop = "p_whiskey_notop"
    elseif tipo == "corote" then
        prop = "ng_proc_sodacan_01b"
    elseif tipo == "absinto" then
        prop = "prop_drink_whisky"
    elseif tipo == "skolb" then
        prop = "ng_proc_sodacan_01b"
    else
        prop = "prop_ld_flow_bottle"
    end

    rEVOLTc._CarregarObjeto(source, "amb@world_human_drinking@beer@male@idle_a", "idle_a", prop, 49, 28422)
    SetTimeout(segundos * 1000, function() rEVOLTc._DeletarObjeto(source) end)
end

function play_eat(source, tipo, segundos)
    local prop = ""
    -- COMIDAS
    if tipo == "pao" then
        prop = "prop_food_burg2"
    elseif tipo == "sanduiche" then
        prop = "prop_cs_burger_01"
    elseif tipo == "pizza" then
        prop = "prop_taco_01"
    elseif tipo == "barrac" then
        prop = "prop_choc_meto"
    elseif tipo == "cachorroq" then
        prop = "prop_cs_hotdog_01"
    elseif tipo == "pipoca" then
        prop = "ng_proc_food_chips01b"
    elseif tipo == "donut" then
        prop = "prop_amb_donut"
    elseif tipo == "paoq" then
        prop = "prop_food_cb_nugets"
    elseif tipo == "marmita" then
        prop = "prop_taco_01"
    elseif tipo == "coxinha" then
        prop = "prop_food_cb_nugets"
    else
        prop = "prop_cs_burger_01"
    end

    rEVOLTc._CarregarObjeto(source, "amb@code_human_wander_eating_donut@male@idle_a", "idle_c", prop, 49, 28422)
    SetTimeout(segundos * 1000, function() rEVOLTc._DeletarObjeto(source) end)
end

Items = {
    ["weapon_hammer"] = {
        index = "weapon_hammer",
        name = "Hammer",
        png = "weapon_hammer",
        weight = 3.0,
        type = "equip"
    },
    ["fueltech"] = {
        index = "fueltech",
        name = "FuelTech",
        png = "fueltech",
        weight = 0.1,
        type = "use"
    },

    ["pacote_componentes"] = {
        index = "pacote_componentes",
        name = "Pacote de Componentes",
        png = "pacote_componentes",
        weight = 5.0,
        type = "use"
    },

    ["plastico"] = {
        index = "plastico",
        name = "Plástico",
        png = "plastico",
        weight = 1.0,
        type = "use"
    },

    ["weapon_pistol_mk2"] = {
        index = "weapon_pistol_mk2",
        name = "Five-Seven",
        png = "weapon_pistol_mk2",
        weight = 3.0,
        type = "equip"
    },

    ["weapon_stungun"] = {
        index = "weapon_stungun",
        name = "Tazer",
        png = "weapon_stungun",
        weight = 1.0,
        type = "equip"
    },

    ["weapon_daegger"] = {
        index = "weapon_daegger",
        name = "Adaga",
        png = "weapon_daegger",
        weight = 8.0,
        type = "equip"
    },
    
    ["weapon_mgouroo"] = {
        index = "weapon_mgouroo",
        name = "MG OURO",
        png = "weapon_mgouroo",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_mgouroo"] = {
        index = "ammo_mgouroo",
        name = "M-MG OURO",
        png = "ammo_mgouroo",
        weight = 0.05,
        type = "recharge"
    },

    ["pacu"] = {
        index = "pacu",
        name = "Pacu",
        png = "pacu",
        weight = 1.5,
        type = "use"
    },

    ["ammo_revolver_mk2"] = {
        index = "ammo_revolver_mk2",
        name = "M-Revolver",
        png = "ammo_revolver_mk2",
        weight = 0.05,
        type = "recharge"
    },

    ["apreensao"] = {
        index = "apreensao",
        name = "Apreensao",
        png = "apreensao",
        weight = 0.2,
        type = "use"
    },
    ["ammo_microsmg"] = {
        index = "ammo_microsmg",
        name = "M-MICROSMG",
        png = "ammo_microsmg",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_flashlight"] = {
        index = "weapon_flashlight",
        name = "Lanterna",
        png = "weapon_flashlight",
        weight = 3.0,
        type = "equip"
    },

    ["m-aco"] = {
        index = "m-aco",
        name = "Aço",
        png = "m-aco",
        weight = 0.3,
        type = "use"
    },

    ["dipirona"] = {
        index = "dipirona",
        name = "Dipirona",
        png = "dipirona",
        weight = 0.05,
        type = "use"
    },

    ["opiopapoula"] = {
        index = "opiopapoula",
        name = "Pó de Opio",
        png = "opiopapoula",
        weight = 0.3,
        type = "use"
    },

    ["weapon_machinepistol"] = {
        index = "weapon_machinepistol",
        name = "Tec-9",
        png = "weapon_machinepistol",
        weight = 6.0,
        type = "equip"
    },

    ["ticket"] = {
        index = "ticket",
        name = "Ticket Corrida",
        png = "ticket",
        weight = 1.0,
        type = "use"
    },



    ["weapon_hatchet"] = {
        index = "weapon_hatchet",
        name = "Machados",
        png = "weapon_hatchet",
        weight = 3.0,
        type = "equip"
    },
    ["ammo_petrolcan"] = {
        index = "ammo_petrolcan",
        name = "Gasolina",
        png = "ammo_petrolcan",
        weight = 0.05,
        type = "recharge"
    },

    ["m-corpo_shotgun"] = {
        index = "m-corpo_shotgun",
        name = "Corpo de Shotgun",
        png = "m-corpo_shotgun",
        weight = 5.0,
        type = "use"
    },

    ["masterpick"] = {
        index = "masterpick",
        name = "MasterPick",
        png = "masterpick",
        weight = 1.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local hasPermission = false
            for group in pairs(rEVOLT.getUserGroups(user_id)) do
                if group:find('Gerente') or group:find('Lider') or group:find('Sub-Lider') then
                    hasPermission = true
                    break
                end
            end

            local inSafezone = RemoteZone.checkInZone(source)
            if inSafezone then 
                return false, TriggerClientEvent("Notify",source,"negado","Uso bloqueado.",5)
            end

            local facZone = exports["facszone"]:zoneName(user_id)
            if facZone then 
                local org = rEVOLT.getUserGroupOrg(user_id)
                if org == facZone then
                    hasPermission = true
                else
                    return false, TriggerClientEvent("Notify",source,"negado","Uso bloqueado nessa região.",5)
                end
            end


            if rEVOLT.hasPermission(user_id, 'admin.permissao') then
                hasPermission = true
            end

            if not hasPermission then
                TriggerClientEvent("Notify", source, "negado", "Você não tem permissão para usar este item.", 5)
                return cb(false)
            end

            local plate, mName, mNet, mPortaMalas, mPrice, mLock, mModel = rEVOLTc.ModelName(source, 7)
            local plateUser = rEVOLT.getUserByRegistration(plate)
            if not plate then
                TriggerClientEvent("Notify", source, "negado", "Você não perto de um veículo.", 5)
                return cb(false)
            end

            
            if rEVOLT.tryGetInventoryItem(user_id, "masterpick", 1, true, slot) then
                Remote._closeInventory(source)
                Wait(1000)
                Remote._startAnimHotwired(source)
                local finished = rEVOLTc.taskBar(source)
                if finished then
                    local entity = NetworkGetEntityFromNetworkId(mNet)
                    if entity then
                        SetVehicleDoorsLocked(entity, 1)
                        setBypassVehicle(user_id, mNet)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Veiculo <b>destrancado</b> com sucesso.')
                        TriggerClientEvent("revolt_sound:source", source, "lock", 0.1)
                        local plyCoords = GetEntityCoords(GetPlayerPed(source))
                        rEVOLT._sendLog('masterpick', ([[O USER_ID %s UTILIZOU MASTERPICK NO VEICULO %s (PLACA: %s | DONO: %s) NAS COORDENAS %s]]):format(user_id, (mName or 'Desconhecido'), plate, (plateUser or "Sem dono"), vec3(plyCoords.x, plyCoords.y, plyCoords.z)))
                        exports["revolt_admin"]:generateLog({
                            category = "inventario",
                            room = "lockpick",
                            user_id = user_id,
                            message = ([[O USER_ID %s UTILIZOU MASTERPICK NO VEICULO %s (PLACA: %s | DONO: %s) NAS COORDENAS %s]]):format(user_id, (mName or 'Desconhecido'), plate, (plateUser or "Sem dono"), vec3(plyCoords.x, plyCoords.y, plyCoords.z))
                        })
                    end

                end
                rEVOLTc._stopAnim(source, false)
            end
        end,
    },

    ["camerainstalar"] = {
        index = "camerainstalar",
        name = "Camera",
        png = "camerainstalar",
        weight = 1.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
           TriggerEvent("init:install_camera", user_id, source)
        end,
    },

    ["curadoenca"] = {
        index = "curadoenca",
        name = "Vacina",
        png = "curadoenca",
        weight = 1.0,
        type = "use",
        keep_item = false,
        func = function(user_id, source, item, slot, cb)
            exports.revolt_admin:cureDisease(user_id)
        end,
    },

    ["tabletcamera"] = {
        index = "tabletcamera",
        name = "Tablet Cameras",
        png = "tabletcamera",
        weight = 1.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
           TriggerEvent("use_camera", user_id, source)
        end,
    },

    ["valemansao1m"] = {
        index = "valemansao1m",
        name = "Vale mansao 1m",
        png = "valemansao1m",
        weight = 0.0,
        type = "use"
    },

    ["ammo_combatpdw"] = {
        index = "ammo_combatpdw",
        name = "M-Pdw",
        png = "ammo_combatpdw",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_sawnoffshotgun"] = {
        index = "ammo_sawnoffshotgun",
        name = "M-Shotgun",
        png = "ammo_sawnoffshotgun",
        weight = 0.05,
        type = "recharge"
    },

    ["safira"] = {
        index = "safira",
        name = "Safira",
        png = "safira",
        weight = 1.0,
        type = "use"
    },

    ["ammo_snowball"] = {
        index = "ammo_snowball",
        name = "M-Bola",
        png = "ammo_snowball",
        weight = 0.05,
        type = "recharge"
    },

    ["molas"] = {
        index = "molas",
        name = "Molas",
        png = "molas",
        weight = 0.15,
        type = "use"
    },

    ["weapon_carbinerifle"] = {
        index = "weapon_carbinerifle",
        name = "M4",
        png = "weapon_carbinerifle",
        weight = 8.0,
        type = "equip"
    },

    ["weapon_assaultsmg"] = {
        index = "weapon_assaultsmg",
        name = "MTAR",
        png = "weapon_assaultsmg",
        weight = 6.0,
        type = "equip"
    },

    ["zincocobre"] = {
        index = "zincocobre",
        name = "Zinco e Cobre",
        png = "zincocobre",
        weight = 0.01,
        type = "use"
    },

    ["l-alvejante"] = {
        index = "l-alvejante",
        name = "Alvejante",
        png = "l-alvejante",
        weight = 0.2,
        type = "use"
    },

    ["body_armor"] = {
        index = "body_armor",
        name = "Colete",
        png = "body_armor",
        weight = 1.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local status, time = func:getCooldown(user_id, "usecolete")
            if status then
                if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                    func:setCooldown(user_id, "usecolete", 30)
                    TriggerClientEvent("progress", source, 10)
                    func:setBlockCommand(user_id, 15)
                    rEVOLTc.playAnim(source, true, { { "clothingtie", "try_tie_negative_a" } }, true)
                    SetTimeout(15000, function()
                        Remote._closeInventory(source)
                        rEVOLTc._stopAnim(source, false)
                        rEVOLTc.setArmour(source, 100)
                        rEVOLTc._DeletarObjeto(source)
                        TriggerClientEvent("Notify", source, "sucesso", "Colete utilizado com sucesso!")
                    end)
                    return cb(true)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Aguarde " .. time .. " segundos para usar outro colete.",
                    8000)
                return cb(false)
            end
        end
    },

    ["ammo_heavysniper"] = {
        index = "ammo_heavysniper",
        name = "M-SNIPER",
        png = "ammo_heavysniper",
        weight = 0.05,
        type = "recharge"
    },

    ["pregos"] = {
        index = "pregos",
        name = "Pregos",
        png = "pregos",
        weight = 2.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if rEVOLT.tryGetInventoryItem(user_id, "pregos", 1, true, slot) then
                TriggerClientEvent("brasilBlitz:putNails",source)
                return cb(true)
            end

            return cb(false)
        end
    },

    ["algemas"] = {
        index = "algemas",
        name = "Algemas",
        png = "algemas",
        weight = 2.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local nplayer = rEVOLTc.getNearestPlayer(source, 3)
            if nplayer then
                if not Remote.checkAnim(nplayer) then
                    TriggerClientEvent("Notify", source, "importante", "O jogador não está rendido.", 5)
                    return
                end

                if rEVOLT.tryGetInventoryItem(user_id, "algemas", 1, true, slot) then
                    if not rEVOLTc.isHandcuffed(nplayer) then
                        rEVOLT.giveInventoryItem(user_id, "chave_algemas", 1, true)
                        rEVOLTc._playAnim(source, false, { { "mp_arrest_paired", "cop_p2_back_left" } }, false)
                        rEVOLTc._playAnim(nplayer, false, { { "mp_arrest_paired", "crook_p2_back_left" } }, false)
                        SetTimeout(3500, function()
                            rEVOLTc._stopAnim(source, false)
                            rEVOLTc._toggleHandcuff(nplayer)
                            TriggerClientEvent("revolt_sound:source", source, "cuff", 0.1)
                            TriggerClientEvent("revolt_sound:source", nplayer, "cuff", 0.1)
                            rEVOLTc._setHandcuffed(nplayer, true)
                        end)
                        return cb(true)
                    else
                        TriggerClientEvent("revolt_sound:source",source,'uncuff',0.4)
						TriggerClientEvent("revolt_sound:source",nplayer,'uncuff',0.4)
						rEVOLTclient._setHandcuffed(nplayer, false)
                    
                        return cb(true)
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "Você não possui algemas.", 5)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Nenhum jogador proximo.", 5)
            end
            return cb(false)
        end
    },

    ["notebook"] = {
        index = "notebook",
        name = "Notebook",
        png = "notebook",
        weight = 0.1,
        type = "use"
    },

    ["garrafanitro"] = {
        index = "garrafanitro",
        name = "Garrafa de Nitro",
        png = "garrafanitro",
        weight = 1.0,
        type = "use",
        func = function(user_id, source, item, slot, cb)
            TriggerClientEvent("recharge_nitro", source)
        end
    },

    ["carnedepuma"] = {
        index = "carnedepuma",
        name = "Carne de Puma",
        png = "carnedepuma",
        weight = 3.0,
        type = "use"
    },

    ["furadeira"] = {
        index = "furadeira",
        name = "Furadeira",
        png = "furadeira",
        weight = 3.0,
        type = "use"
    },

    ["heroina"] = {
        index = "heroina",
        name = "Heroina",
        png = "heroina",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if rEVOLT.hasPermission(user_id, 'perm.kids') then
                TriggerClientEvent("Notify", source, "negado", "Você não pode usar droga..", 5)
                return cb(false)
            end
            if not Remote.isInDrugZone(source) then
                TriggerClientEvent('Notify', source, 'negado', 'Você não está em uma zona correta para usar esse item.')
                return
            end

            local nplayer = rEVOLTc.getNearestPlayer(source, 3)
            if not nplayer then
                TriggerClientEvent('Notify', source, 'negado', 'Nenhum jogador perto.')
                return
            end

            local nuserId = rEVOLT.getUserId(nplayer)
            if not nuserId then
                TriggerClientEvent('Notify', source, 'negado', 'Nenhum jogador perto.')
                return
            end

            local nPed = GetPlayerPed(nplayer)
            if GetEntityHealth(nPed) > 101 then
                TriggerClientEvent('Notify', source, 'negado', 'Esse usuário não está morto.')
                return
            end

            if not rEVOLT.tryGetInventoryItem(user_id, 'heroina', 1) then
                TriggerClientEvent('Notify', source, 'negado', 'Você não tem esse item.')
                return
            end

            SetTimeout(3*1000, function()  
                rEVOLTc.playAnim(source, false,{{"mini@cpr@char_a@cpr_def","cpr_intro"}},true)
                -- TriggerClientEvent('blockCommands', source, 10*1000)
                SetTimeout(10*1000, function()  
                    rEVOLTc._stopAnim(source, false)
                    rEVOLTc._setHealth(nplayer, 110)
                end)
            end)
            return cb(false)
        end
    },

    ["apple_watch"] = {
        index = "apple_watch",
        name = "Apple Watch",
        png = "apple_watch",
        weight = 0.5,
        type = "use"
    },

    ["vodka"] = {
        index = "vodka",
        name = "Vodka",
        png = "vodka",
        weight = 1.0,
        type = "use",
        func = Beber_Alcoolico
    },

    ["clozapina"] = {
        index = "clozapina",
        name = "Clozapina",
        png = "clozapina",
        weight = 0.05,
        type = "use"
    },

    ["repairkit2"] = {
        index = "repairkit2",
        name = "Jogue Fora",
        png = "repairkit2",
        weight = 1.0,
        type = "use"
    },

    ["borrachaarame"] = {
        index = "borrachaarame",
        name = "Arame de Borracha",
        png = "borrachaarame",
        weight = 0.05,
        type = "use"
    },
    ["latatinta"] = {
        index = "latatinta",
        name = "Lata de Tinta",
        png = "latatinta",
        weight = 0.05,
        type = "use"
    },
    ["chaveboca"] = {
        index = "chaveboca",
        name = "Chave de Boca",
        png = "chaveboca",
        weight = 0.10,
        type = "use"
    },

    ["ammo_combatpistol"] = {
        index = "ammo_combatpistol",
        name = "M-Glock",
        png = "ammo_combatpistol",
        weight = 0.05,
        type = "recharge"
    },

    ["alterarrg"] = {
        index = "alterarrg",
        name = "Alterar RG",
        png = "alterarrg",
        weight = 0.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            Remote._closeInventory(source)
            Wait(500)
            local numero = rEVOLT.prompt(source, "Digite o numero: (MAX 6) (EXEMPLO: ABC123)", "")
            if numero ~= nil and numero ~= "" and numero and string.len(numero) == 6 then
                if checkRG(numero) then
                    if rEVOLT.request(source, "Tem certeza que deseja alterar seu rg para <b>" .. numero .. "</b> ?", 30) then
                        if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                            rEVOLT.updateIdentity(user_id)
                            rEVOLT._execute("rEVOLT/update_registro", { user_id = user_id, registro = numero })
                            TriggerClientEvent("Notify", source, "sucesso",
                                "Você trocou o seu rg para <b>" ..
                                numero .. "</b>, aguarde a cidade reiniciar para alteração ser feita.", 15)
                        end
                    end
                    return cb(true)
                else
                    TriggerClientEvent("Notify", source, "negado", "Este rg ja existe.", 5)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Digite o rg correto. (EXEMPLO: ABC123)", 5)
            end
            return cb(false)
        end
    },

    ["anfetamina"] = {
        index = "anfetamina",
        name = "Anfetamina",
        png = "anfetamina",
        weight = 0.3,
        type = "use"
    },

    ["valemansao100m"] = {
        index = "valemansao100m",
        name = "Vale mansao 100m",
        png = "valemansao100m",
        weight = 0.0,
        type = "use"
    },

    ["goiaba"] = {
        index = "goiaba",
        name = "Goiaba",
        png = "goiaba",
        weight = 1.0,
        type = "use"
    },

    ["pendrive"] = {
        index = "pendrive",
        name = "Pendrive",
        png = "pendrive",
        weight = 1.0,
        type = "use"
    },

    ["weapon_machete"] = {
        index = "weapon_machete",
        name = "Machete",
        png = "weapon_machete",
        weight = 3.0,
        type = "equip"
    },

    ["respingodesolda"] = {
        index = "respingodesolda",
        name = "Respingo de Solda",
        png = "respingodesolda",
        weight = 0.3,
        type = "use"
    },

    ["relogioroubado"] = {
        index = "relogioroubado",
        name = "Relogio",
        png = "relogioroubado",
        weight = 0.5,
        type = "use"
    },
    
  -- ["plantadourada"] = {
  --     index = "plantadourada",
  --     name = "Planta Dourada",
  --     png = "plantadourada",
  --     weight = 0.5,
  --     type = "use",
  --     keep_item = true,
  --     func = function(user_id, source, item, slot, cb)
  --         TriggerClientEvent('markPlantaDourada', source)
  --         return cb(true)
  --     end
  -- },

    ["blacklist"] = {
        index = "blacklist",
        name = "Blacklist",
        png = "blacklist",
        weight = 0.5,
        type = "use",
        func = function(user_id, source, item, slot, cb)
            rEVOLT.setUData(user_id,'facs:blacklist', 0)
            return cb(true)
        end
    },
    
    ["chavedacidade"] = {
        index = "chavedacidade",
        name = "Chave da Cidade",
        png = "chavedacidade",
        weight = 0.5,
        type = "use"
    },

    
    ["passaporteilha"] = {
        index = "passaporteilha",
        name = "Passporte da Ilha",
        png = "passaporteilha",
        weight = 0.5,
        type = "use"
    },
    

    ["ammo_bzgas"] = {
        index = "ammo_bzgas",
        name = "M-Gas",
        png = "ammo_bzgas",
        weight = 0.05,
        type = "recharge"
    },

    ["cachorroq"] = {
        index = "cachorroq",
        name = "Cachorro Quente",
        png = "cachorroq",
        weight = 0.5,
        type = "use"
    },

    ["ammo_specialcarbine_mk2"] = {
        index = "ammo_specialcarbine_mk2",
        name = "M-G3",
        png = "ammo_specialcarbine_mk2",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_tacticalrifle"] = {
        index = "ammo_tacticalrifle",
        name = "M-Rifle Tatico",
        png = "ammo_tacticalrifle",
        weight = 0.05,
        type = "recharge"
    },

    ["cocaina"] = {
        index = "cocaina",
        name = "Cocaina",
        png = "cocaina",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = OthersDrugs
    },

    ["cogumelo"] = {
        index = "cogumelo",
        name = "Cogumelo",
        png = "cogumelo",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = OthersDrugs
    },

    ["folhamaconha"] = {
        index = "folhamaconha",
        name = "Folha de Maconha",
        png = "folhamaconha",
        weight = 0.3,
        type = "use"
    },

    ["raizdecogumelo"] = {
        index = "raizdecogumelo",
        name = "Raiz de Cogumelo",
        png = "raizdecogumelo",
        weight = 0.3,
        type = "use"
    },


    ["donut"] = {
        index = "donut",
        name = "Donut",
        png = "donut",
        weight = 0.2,
        type = "use"
    },

    ["sucol2"] = {
        index = "sucol2",
        name = "Suco de Limao",
        png = "sucol2",
        weight = 0.5,
        type = "use",
        func = Beber
    },

    ["papel"] = {
        index = "papel",
        name = "Papel",
        png = "papel",
        weight = 0.05,
        type = "use"
    },

    ["c-ferro"] = {
        index = "c-ferro",
        name = "Ferro",
        png = "c-ferro",
        weight = 0.01,
        type = "use"
    },

    ["desbloqueadorsinal"] = {
        index = "desbloqueadorsinal",
        name = "Desbloqueador de Sinal",
        png = "desbloqueadorsinal",
        weight = 0.01,
        type = "use"
    },
    ["grampoprison"] = {
        index = "grampoprison",
        name = "Grampo",
        png = "grampoprison",
        weight = 0.01,
        type = "use"
    },
    ["moldeprison"] = {
        index = "moldeprison",
        name = "Molde",
        png = "moldeprison",
        weight = 0.01,
        type = "use"
    },
    ["copoprison"] = {
        index = "copoprison",
        name = "Copo",
        png = "copoprison",
        weight = 0.01,
        type = "use"
    },
    ["ferroprison"] = {
        index = "ferroprison",
        name = "Ferro",
        png = "ferroprison",
        weight = 0.01,
        type = "use"
    },
    ["cobreprison"] = {
        index = "cobreprison",
        name = "Cobre",
        png = "cobreprison",
        weight = 0.01,
        type = "use"
    },
    ["pedraprison"] = {
        index = "pedraprison",
        name = "Pedra",
        png = "pedraprison",
        weight = 0.01,
        type = "use"
    },
    ["papelprison"] = {
        index = "papelprison",
        name = "Papel",
        png = "papelprison",
        weight = 0.01,
        type = "use"
    },
    ["maconhaprison"] = {
        index = "maconhaprison",
        name = "Maconha",
        png = "maconhaprison",
        weight = 0.01,
        type = "use"
    },
    ["crackprison"] = {
        index = "crackprison",
        name = "Crack",
        png = "crackprison",
        weight = 0.01,
        type = "use"
    },
    ["plasticoprison"] = {
        index = "plasticoprison",
        name = "Plástico",
        png = "plasticoprison",
        weight = 0.01,
        type = "use"
    },
    ["garrafaquebradaprison"] = {
        index = "garrafaquebradaprison",
        name = "Garrafa Quebrada",
        png = "garrafaquebradaprison",
        weight = 0.01,
        type = "use"
    },
    ["pedacoarameprison"] = {
        index = "pedacoarameprison",
        name = "Pedaço de Arame",
        png = "pedacoarameprison",
        weight = 0.01,
        type = "use"
    },
    ["tijoloprison"] = {
        index = "tijoloprison",
        name = "Tijolo",
        png = "tijoloprison",
        weight = 0.01,
        type = "use"
    },
    ["dedodecepadoprison"] = {
        index = "dedodecepadoprison",
        name = "Dedo Decepado",
        png = "dedodecepadoprison",
        weight = 0.01,
        type = "use"
    },    

    ["fibradecarbono"] = {
        index = "fibradecarbono",
        name = "Fibra de Carbono",
        png = "fibradecarbono",
        weight = 0.05,
        type = "use"
    },

    ["maracuja"] = {
        index = "maracuja",
        name = "Maracujá",
        png = "maracuja",
        weight = 1.0,
        type = "use"
    },

    ["pacote_eletrico"] = {
        index = "pacote_eletrico",
        name = "Pacote Eletrico",
        png = "pacote_eletrico",
        weight = 3.0,
        type = "use"
    },

    ["ammo_barret"] = {
        index = "ammo_barret",
        name = "M-Barret",
        png = "ammo_barret",
        weight = 0.05,
        type = "recharge"
    },

    ["ouro"] = {
        index = "ouro",
        name = "Ouro",
        png = "ouro",
        weight = 1.0,
        type = "use"
    },

    ["alterarplaca"] = {
        index = "alterarplaca",
        name = "Alterar Placa",
        png = "alterarplaca",
        weight = 0.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local plate, mName, mNet, mPortaMalas, mPrice, mLock, mModel = rEVOLTc.ModelName(source, 7)
            if not plate then
                TriggerClientEvent("Notify", source, "negado", "Você não perto de um veículo.", 5)
                return cb(false)
            end
            plate = plate:gsub(" ", "")

            local plateUser = rEVOLT.getUserByRegistration(plate)
            if plateUser ~= user_id then
                TriggerClientEvent("Notify", source, "negado", "Este veiculo não é seu.", 5)
                return cb(false)
            end

            local new_plate = rEVOLT.prompt(source, "Digite a nova placa: (MAX 8) (EXEMPLO: ABC1234)", "")
            new_plate = tostring(new_plate)
            new_plate = new_plate:upper()

            if new_plate:len() < 7 or new_plate:len() > 8 then
                TriggerClientEvent("Notify",source,"negado","Minimo 7 caracters, maximo 8 caraceters.", 5)
                return cb(false)
            end

            if not new_plate:match("^[A-Z0-9]+$") then
                TriggerClientEvent("Notify", source, "negado", "A placa deve conter entre 7 e 8 caracteres, apenas letras de A-Z e números de 0-9.", 5000)
                return cb(false)
            end

            local plateExists = DBQuery('vehicles/GetByPlate', { placa = new_plate })
            if #plateExists > 0 then
                TriggerClientEvent("Notify",source,"negado","Placa já existe.", 5000)
                return cb(false)
            end

            if not rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                return cb(false)
            end

            DBExecute('vehicles/UpdatePlateByPlate', { new_plate = new_plate, old_plate = plate })

            DeleteEntity(NetworkGetEntityFromNetworkId(mNet))
        
            return cb(true)
        end
    },

    ["corda"] = {
        index = "corda",
        name = "Corda",
        png = "corda",
        weight = 1.0,
        type = "use",
    },

    ["m-capa_colete"] = {
        index = "m-capa_colete",
        name = "Capa Colete",
        png = "m-capa_colete",
        weight = 0.5,
        type = "use"
    },

    ["suspension"] = {
        index = "suspension",
        name = "Item de Tuning",
        png = "suspension",
        weight = 0.1,
        type = "use"
    },

    ["cicatricure"] = {
        index = "cicatricure",
        name = "Cicatricure",
        png = "cicatricure",
        weight = 0.05,
        type = "use"
    },

    


    ["weapon_navyrevolver"] = {
        index = "weapon_navyrevolver",
        name = "Navy Revolver",
        png = "weapon_navyrevolver",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_navyrevolver"] = {
        index = "ammo_navyrevolver",
        name = "M-NavyRevolver",
        png = "ammo_navyrevolver",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_specialcarbine_mk2"] = {
        index = "weapon_specialcarbine_mk2",
        name = "G3 MK2",
        png = "weapon_specialcarbine_mk2",
        weight = 8.0,
        type = "equip"
    },

    ["weapon_tacticalrifle"] = {
        index = "weapon_tacticalrifle",
        name = "Rifle Tatico",
        png = "weapon_tacticalrifle",
        weight = 8.0,
        type = "equip"
    },
    ["weapon_heavyrifle"] = {
        index = "weapon_heavyrifle",
        name = "Heavy Rifle",
        png = "weapon_heavyrifle",
        weight = 8.0,
        type = "equip"
    },

    ["weapon_akpentede90_relikiashop"] = {
        index = "weapon_akpentede90_relikiashop",
        name = "AK PENTE 90",
        png = "weapon_akpentede90_relikiashop",
        weight = 8.0,
        type = "equip"
    },

    

    ["ammo_akpentedE90_relikiashop"] = {
        index = "ammo_akpentedE90_relikiashop",
        name = "M-AK PENTE 90",
        png = "ammo_akpentedE90_relikiashop",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_akdeferro_relikiashop"] = {
        index = "weapon_akdeferro_relikiashop",
        name = "AK DE FERRO",
        png = "weapon_akdeferro_relikiashop",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_akdeferro_relikiashop"] = {
        index = "ammo_akdeferro_relikiashop",
        name = "M-AK DE FERRO",
        png = "ammo_akdeferro_relikiashop",
        weight = 0.05,
        type = "recharge"
    },


    ["weapon_akcromo"] = {
        index = "weapon_akcromo",
        name = "AK CROMO",
        png = "weapon_akcromo",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_akcromo"] = {
        index = "ammo_akcromo",
        name = "M-AK CROMO",
        png = "ammo_akcromo",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_arrelikiashopfeminino1"] = {
        index = "weapon_arrelikiashopfeminino1",
        name = "AR FEMININO 1",
        png = "weapon_arrelikiashopfeminino1",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_arrelikiashopfeminino1"] = {
        index = "ammo_arrelikiashopfeminino1",
        name = "M-AR FEMININO 1",
        png = "ammo_arrelikiashopfeminino1",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_arrelikiashopfeminino2"] = {
        index = "weapon_arrelikiashopfeminino2",
        name = "AR FEMININO 2",
        png = "weapon_arrelikiashopfeminino2",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_arrelikiashopfeminino2"] = {
        index = "ammo_arrelikiashopfeminino2",
        name = "M-AR FEMININO 2",
        png = "ammo_arrelikiashopfeminino2",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_arvasco"] = {
        index = "weapon_arvasco",
        name = "AR VASCO",
        png = "weapon_arvasco",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_arvasco"] = {
        index = "ammo_arvasco",
        name = "M-AR VASCO",
        png = "ammo_arvasco",
        weight = 0.05,
        type = "recharge"
    },
    
    ["weapon_bullpuprifle_mk2"] = {
        index = "weapon_bullpuprifle_mk2",
        name = "Famas",
        png = "weapon_bullpuprifle_mk2",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_bullpuprifle_mk2"] = {
        index = "ammo_bullpuprifle_mk2",
        name = "M-FAMAS RIFLE",
        png = "ammo_bullpuprifle_mk2",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_qbz83"] = {
        index = "weapon_qbz83",
        name = "QBZ",
        png = "weapon_qbz83",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_qbz83"] = {
        index = "ammo_qbz83",
        name = "M-QBZ83",
        png = "ammo_qbz83",
        weight = 0.05,
        type = "recharge"
    },


    ["weapon_cheytac"] = {
        index = "weapon_cheytac",
        name = "CHEYTAC",
        png = "weapon_cheytac",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_cheytac"] = {
        index = "ammo_cheytac",
        name = "M-CHEYTAC",
        png = "ammo_cheytac",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_g3relikiashopfeminino"] = {
        index = "weapon_g3relikiashopfeminino",
        name = "G3 FEMININO",
        png = "weapon_g3relikiashopfeminino",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_g3relikiashopfeminino"] = {
        index = "ammo_g3relikiashopfeminino",
        name = "M-G3 FEMININO",
        png = "ammo_g3relikiashopfeminino",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_glockrajada"] = {
        index = "weapon_glockrajada",
        name = "GLOCK RAJADA",
        png = "weapon_glockrajada",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_glockrajada"] = {
        index = "ammo_glockrajada",
        name = "M-GLOCK RAJADA",
        png = "ammo_glockrajada",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_glockrelikiashopfeminino0"] = {
        index = "weapon_glockrelikiashopfeminino0",
        name = "GLOCK FEMININO 0",
        png = "weapon_glockrelikiashopfeminino0",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_glockrelikiashopfeminino0"] = {
        index = "ammo_glockrelikiashopfeminino0",
        name = "M-GLOCK FEMININO 0",
        png = "ammo_glockrelikiashopfeminino0",
        weight = 0.05,
        type = "recharge"
    },



    ["weapon_ak472"] = {
        index = "weapon_ak472",
        name = "AK 472",
        png = "weapon_ak472",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_ak472"] = {
        index = "ammo_ak472",
        name = "M-AK 472",
        png = "ammo_ak472",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_ar10preto_relikiashop"] = {
        index = "weapon_ar10preto_relikiashop",
        name = "AR 10 PRETO",
        png = "weapon_ar10preto_relikiashop",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_ar10preto_relikiashop"] = {
        index = "ammo_ar10preto_relikiashop",
        name = "M-AR 10 PRETO",
        png = "ammo_ar10preto_relikiashop",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_ar15bege_relikiashop"] = {
        index = "weapon_ar15bege_relikiashop",
        name = "AR 15 BEGE",
        png = "weapon_ar15bege_relikiashop",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_ar15bege_relikiashop"] = {
        index = "ammo_ar15bege_relikiashop",
        name = "M-AR 15 BEGE",
        png = "ammo_ar15bege_relikiashop",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_arpenteacrilico_relikiashop"] = {
        index = "weapon_arpenteacrilico_relikiashop",
        name = "AR PENTE ACRILICO",
        png = "weapon_arpenteacrilico_relikiashop",
        weight = 8.0,
        type = "equip"
    },

    ["weapon_g3_champions"] = {
        index = "weapon_g3_champions",
        name = "G3 CHAMPIONS",
        png = "weapon_g3_champions",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_arpenteacrilico_relikiashop"] = {
        index = "ammo_arpenteacrilico_relikiashop",
        name = "M-AR PENTE ACRILICO",
        png = "ammo_arpenteacrilico_relikiashop",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_g3_champions"] = {
        index = "ammo_g3_champions",
        name = "M-G3 CHAMPIONS",
        png = "ammo_g3_champions",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_ardeluneta_relikiashop"] = {
        index = "weapon_ardeluneta_relikiashop",
        name = "AR DE LUNETA",
        png = "weapon_ardeluneta_relikiashop",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_ardeluneta_relikiashop"] = {
        index = "ammo_ardeluneta_relikiashop",
        name = "M-AR DE LUNETA",
        png = "ammo_ardeluneta_relikiashop",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_hk416_avanco"] = {
        index = "weapon_hk416_avanco",
        name = "HK416 AVANCO",
        png = "weapon_hk416_avanco",
        weight = 8.0,
        type = "equip"
    },
    ["ammo_hk416_avanco"] = {
        index = "ammo_hk416_avanco",
        name = "M-HK416 AVANCO",
        png = "ammo_hk416_avanco",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_hk416_feitico"] = {
        index = "weapon_hk416_feitico",
        name = "HK416 FEITICO",
        png = "weapon_hk416_feitico",
        weight = 8.0,
        type = "equip"
    },
    ["ammo_hk416_feitico"] = {
        index = "ammo_hk416_feitico",
        name = "M-HK416 FEITICO",
        png = "ammo_hk416_feitico",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_hk416_lua"] = {
        index = "weapon_hk416_lua",
        name = "HK416 LUA",
        png = "weapon_hk416_lua",
        weight = 8.0,
        type = "equip"
    },
    ["ammo_hk416_lua"] = {
        index = "ammo_hk416_lua",
        name = "M-HK416 LUA",
        png = "ammo_hk416_lua",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_hk416rosa"] = {
        index = "weapon_hk416rosa",
        name = "HK416 ROSA",
        png = "weapon_hk416rosa",
        weight = 8.0,
        type = "equip"
    },
    ["ammo_hk416rosa"] = {
        index = "ammo_hk416rosa",
        name = "M-HK416 ROSA",
        png = "ammo_hk416rosa",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_hkg3a3"] = {
        index = "weapon_hkg3a3",
        name = "HKG3A3",
        png = "weapon_hkg3a3",
        weight = 8.0,
        type = "equip"
    },
    ["ammo_hkg3a3"] = {
        index = "ammo_hkg3a3",
        name = "M-HKG3A3",
        png = "ammo_hkg3a3",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_hl416oceano"] = {
        index = "weapon_hl416oceano",
        name = "HL416 OCEANO",
        png = "weapon_hl416oceano",
        weight = 8.0,
        type = "equip"
    },
    ["ammo_hl416oceano"] = {
        index = "ammo_hl416oceano",
        name = "M-HL416 OCEANO",
        png = "ammo_hl416oceano",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_arlunetaprata"] = {
        index = "weapon_arlunetaprata",
        name = "AR LUNETA PRATA",
        png = "weapon_arlunetaprata",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_arlunetaprata"] = {
        index = "ammo_arlunetaprata",
        name = "M-AR LUNETA PRATA",
        png = "ammo_arlunetaprata",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_artambor"] = {
        index = "weapon_artambor",
        name = "AR TAMBOR",
        png = "weapon_artambor",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_artambor"] = {
        index = "ammo_artambor",
        name = "M-AR TAMBOR",
        png = "ammo_artambor",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_g3luneta_relikiashop"] = {
        index = "weapon_g3luneta_relikiashop",
        name = "G3 LUNETA",
        png = "weapon_g3luneta_relikiashop",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_g3luneta_relikiashop"] = {
        index = "ammo_g3luneta_relikiashop",
        name = "M-G3 LUNETA",
        png = "ammo_g3luneta_relikiashop",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_glockderoupa_relikiashop"] = {
        index = "weapon_glockderoupa_relikiashop",
        name = "GLOCK DE ROUPA",
        png = "weapon_glockderoupa_relikiashop",
        weight = 8.0,
        type = "equip"
    },

    ["weapon_fnscar"] = {
        index = "weapon_fnscar",
        name = "Scar-L",
        png = "weapon_fnscar",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_glockderoupa_relikiashop"] = {
        index = "ammo_glockderoupa_relikiashop",
        name = "M-GLOCK DE ROUPA",
        png = "ammo_glockderoupa_relikiashop",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_fnscar"] = {
        index = "ammo_fnscar",
        name = "M-Scar-L",
        png = "ammo_fnscar",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_hkg3a3"] = {
        index = "weapon_hkg3a3",
        name = "HK G3A3",
        png = "weapon_hkg3a3",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_hkg3a3"] = {
        index = "ammo_hkg3a3",
        name = "M-HK G3A3",
        png = "ammo_hkg3a3",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_hk_relikiashop"] = {
        index = "weapon_hk_relikiashop",
        name = "HK",
        png = "weapon_hk_relikiashop",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_hk_relikiashop"] = {
        index = "ammo_hk_relikiashop",
        name = "M-HK",
        png = "ammo_hk_relikiashop",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_penteduplo1"] = {
        index = "weapon_penteduplo1",
        name = "PENTE DUPLO",
        png = "weapon_penteduplo1",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_penteduplo1"] = {
        index = "ammo_penteduplo1",
        name = "M-PENTE DUPLO",
        png = "ammo_penteduplo1",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_50_relikiashop"] = {
        index = "weapon_50_relikiashop",
        name = ".50",
        png = "weapon_50_relikiashop",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_50_relikiashop"] = {
        index = "ammo_50_relikiashop",
        name = "M-.50",
        png = "ammo_50_relikiashop",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_m4cammo"] = {
        index = "weapon_m4cammo",
        name = "M4 Cammo",
        png = "weapon_m4cammo",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_m4cammo"] = {
        index = "ammo_m4cammo",
        name = "M-M4 Cammo",
        png = "ammo_m4cammo",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_pl_penhashop_crossbow_dourado"] = {
        index = "weapon_pl_penhashop_crossbow_dourado",
        name = "Crossbow Dourado",
        png = "weapon_pl_penhashop_crossbow_dourado",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_pl_penhashop_crossbow_dourado"] = {
        index = "ammo_pl_penhashop_crossbow_dourado",
        name = "M-Crossbow Dourado",
        png = "ammo_pl_penhashop_crossbow_dourado",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_dozeborracha"] = {
        index = "weapon_dozeborracha",
        name = "Doze Borracha",
        png = "weapon_dozeborracha",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_dozeborracha"] = {
        index = "ammo_dozeborracha",
        name = "M-Doze Borracha",
        png = "ammo_dozeborracha",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_paralotus"] = {
        index = "weapon_paralotus",
        name = "Paralotus",
        png = "weapon_paralotus",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_paralotus"] = {
        index = "ammo_paralotus",
        name = "M-Paralotus",
        png = "ammo_paralotus",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_pl_penhashop_crossbow_desert"] = {
        index = "weapon_pl_penhashop_crossbow_desert",
        name = "Crossbow Desert",
        png = "weapon_pl_penhashop_crossbow_desert",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_pl_penhashop_crossbow_desert"] = {
        index = "ammo_pl_penhashop_crossbow_desert",
        name = "M-Crossbow Desert",
        png = "ammo_pl_penhashop_crossbow_desert",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_pumpshotgunouro_mk2"] = {
        index = "weapon_pumpshotgunouro_mk2",
        name = "Pump Shoptgun Ouro",
        png = "weapon_pumpshotgunouro_mk2",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_pumpshotgunouro_mk2"] = {
        index = "ammo_pumpshotgunouro_mk2",
        name = "M-Pump Shoptgun Ouro",
        png = "ammo_pumpshotgunouro_mk2",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_five_gingerbread"] = {
        index = "weapon_five_gingerbread",
        name = "Five Gingerbread",
        png = "weapon_five_gingerbread",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_five_gingerbread"] = {
        index = "ammo_five_gingerbread",
        name = "M-Five Gingerbread",
        png = "ammo_five_gingerbread",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_five_summerlotus"] = {
        index = "weapon_five_summerlotus",
        name = "Five Summerlotus",
        png = "weapon_five_summerlotus",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_five_summerlotus"] = {
        index = "ammo_five_summerlotus",
        name = "M-Five Summerlotus",
        png = "ammo_five_summerlotus",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_ak_gingerbread"] = {
        index = "weapon_ak_gingerbread",
        name = "AK Gingerbread",
        png = "weapon_ak_gingerbread",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_ak_gingerbread"] = {
        index = "ammo_ak_gingerbread",
        name = "M-AK Gingerbread",
        png = "ammo_ak_gingerbread",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_g3_gingerbread"] = {
        index = "weapon_g3_gingerbread",
        name = "G3 Gingerbread",
        png = "weapon_g3_gingerbread",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_g3_gingerbread"] = {
        index = "ammo_g3_gingerbread",
        name = "M-G3 Gingerbread",
        png = "ammo_g3_gingerbread",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_g3_summerlotus"] = {
        index = "weapon_g3_summerlotus",
        name = "G3 Summerlotus",
        png = "weapon_g3_summerlotus",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_g3_summerlotus"] = {
        index = "ammo_g3_summerlotus",
        name = "M-G3 Summerlotus",
        png = "ammo_g3_summerlotus",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_m4_gingerbread"] = {
        index = "weapon_m4_gingerbread",
        name = "M4 Gingerbread",
        png = "weapon_m4_gingerbread",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_m4_gingerbread"] = {
        index = "ammo_m4_gingerbread",
        name = "M-M4 Gingerbread",
        png = "ammo_m4_gingerbread",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_mtar_gingerbread"] = {
        index = "weapon_mtar_gingerbread",
        name = "MTAR Gingerbread",
        png = "weapon_mtar_gingerbread",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_mtar_gingerbread"] = {
        index = "ammo_mtar_gingerbread",
        name = "M-MTAR Gingerbread",
        png = "ammo_mtar_gingerbread",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_mtar_summerlotus"] = {
        index = "weapon_mtar_summerlotus",
        name = "MTAR Summerlotus",
        png = "weapon_mtar_summerlotus",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_mtar_summerlotus"] = {
        index = "ammo_mtar_summerlotus",
        name = "M-MTAR Summerlotus",
        png = "ammo_mtar_summerlotus",
        weight = 0.05,
        type = "recharge"
    },


    

    ["weapon_fallflamengo"] = {
        index = "weapon_fallflamengo",
        name = "Fall Flamengo",
        png = "weapon_fallflamengo",
        weight = 8.0,
        type = "equip"
    },

    ["weapon_tempered"] = {
        index = "weapon_tempered",
        name = "Tempered",
        png = "weapon_tempered",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_tempered"] = {
        index = "ammo_tempered",
        name = "M-Tempered",
        png = "ammo_tempered",
        weight = 0.05,
        type = "recharge"
    },


    ["ammo_fallflamengo"] = {
        index = "ammo_fallflamengo",
        name = "M-FALL FLAMENGO",
        png = "ammo_fallflamengo",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_ar15"] = {
        index = "weapon_ar15",
        name = "AR 15",
        png = "weapon_ar15",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_ar15"] = {
        index = "ammo_ar15",
        name = "M-AR 15",
        png = "ammo_ar15",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_madsen"] = {
        index = "weapon_madsen",
        name = "MADSEN",
        png = "weapon_madsen",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_madsen"] = {
        index = "ammo_madsen",  
        name = "M-MADSEN",
        png = "ammo_madsen",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_qbz83"] = {
        index = "weapon_qbz83",
        name = "QBZ-83",
        png = "weapon_qbz83",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_qbz83"] = {
        index = "ammo_qbz83",  
        name = "M-QBZ-83",
        png = "ammo_qbz83",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_coltxm177"] = {
        index = "weapon_coltxm177",
        name = "COLT XM177",
        png = "weapon_coltxm177",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_coltxm177"] = {
        index = "ammo_coltxm177",
        name = "M-COLT XM177",
        png = "ammo_coltxm177",
        weight = 0.05,
        type = "recharge"
    },

    ["marmita"] = {
        index = "marmita",
        name = "Marmitex",
        png = "marmita",
        weight = 2.0,
        type = "use"
    },

    ["chavedeprisao"] = {
        index = "chavedeprisao",
        name = "chavedeprisao",
        png = "Cha de Prisão",
        weight = 0.05,
        type = "use"
    },

    ["poliester"] = {
        index = "poliester",
        name = "Poliester",
        png = "poliester",
        weight = 0.05,
        type = "use"
    },

    ["m-corpo_snspistol_mk2"] = {
        index = "m-corpo_snspistol_mk2",
        name = "Corpo de Fajuta",
        png = "m-corpo_snspistol_mk2",
        weight = 1.0,
        type = "use"
    },

    ["weapon_wrench"] = {
        index = "weapon_wrench",
        name = "Wrench",
        png = "weapon_wrench",
        weight = 3.0,
        type = "equip"
    },

    ["weapon_petrolcan"] = {
        index = "weapon_petrolcan",
        name = "Galão de gasolina",
        png = "weapon_petrolcan",
        weight = 1.0,
        type = "equip"
    },

    ["resinacannabis"] = {
        index = "resinacannabis",
        name = "Resina de Cannabis",
        png = "resinacannabis",
        weight = 0.3,
        type = "use"
    },

    ["ammo_assaultrifle"] = {
        index = "ammo_assaultrifle",
        name = "M-AK-47",
        png = "ammo_assaultrifle",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_firework"] = {
        index = "ammo_firework",
        name = "M-Fogos",
        png = "ammo_firework",
        weight = 0.05,
        type = "recharge"
    },

    ["ferro"] = {
        index = "ferro",
        name = "Ferro",
        png = "ferro",
        weight = 0.05,
        type = "use"
    },

    ["weapon_snspistol_mk2"] = {
        index = "weapon_snspistol_mk2",
        name = "Fajuta",
        png = "weapon_snspistol_mk2",
        weight = 3.0,
        type = "equip"
    },

    ["carnedejavali"] = {
        index = "carnedejavali",
        name = "Carne de Javali",
        png = "carnedejavali",
        weight = 3.0,
        type = "use"
    },

    ["fluoxetina"] = {
        index = "fluoxetina",
        name = "Fluoxetina",
        png = "fluoxetina",
        weight = 0.05,
        type = "use"
    },

    ["opio"] = {
        index = "opio",
        name = "Ópio",
        png = "opio",
        weight = 0.5,
        type = "use"
    },

    ["keycard"] = {
        index = "keycard",
        name = "Keycard",
        png = "keycard",
        weight = 1.0,
        type = "use"
    },

    ["mamadeira"] = {
        index = "mamadeira",
        name = "Mamadeira",
        png = "mamadeira",
        weight = 0.5,
        type = "use",
        func = function(user_id, source, item, slot, cb)
            Remote._useBandagem(source, true, 'Mamadeira')
            cb(true)
        end
    },

    ["paracetamol"] = {
        index = "paracetamol",
        name = "Paracetamol",
        png = "paracetamol",
        weight = 0.05,
        type = "use"
    },

    ["isca"] = {
        index = "isca",
        name = "Isca",
        png = "isca",
        weight = 0.25,
        type = "use"
    },

    ["ammo_smg"] = {
        index = "ammo_smg",
        name = "M-SMG",
        png = "ammo_smg",
        weight = 0.05,
        type = "recharge"
    },

    ["pipoca"] = {
        index = "pipoca",
        name = "Pipoca",
        png = "pipoca",
        weight = 0.3,
        type = "use"
    },

    ["metanfetamina"] = {
        index = "metanfetamina",
        name = "Metanfetamina ",
        png = "metanfetamina",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if rEVOLT.hasPermission(user_id, 'perm.kids') then
                TriggerClientEvent("Notify", source, "negado", "Você não pode usar droga..", 5)
                return cb(false)
            end
            if not Remote.isInDrug(source) then
                local armour = rEVOLTc.getArmour(source)
                if armour > 0 then
                    if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                        rEVOLTc._playAnim(source, true, { { "mp_player_int_uppersmoke", "mp_player_int_smoke" } }, true)

                        SetTimeout(2000,
                            function()
                                rEVOLTc._stopAnim(source, false)
                                TriggerClientEvent("inventory:useDrugs", source, item)
                            end)
                        return cb(true)
                    end
                else
                    TriggerClientEvent("Notify", source, "negado",
                        "Você não possui um colete equipado para usar a droga.", 5)
                end
            end
            return cb(false)
        end
    },

    ["riopan"] = {
        index = "riopan",
        name = "Riopan",
        png = "riopan",
        weight = 0.05,
        type = "use"
    },

    ["polvora"] = {
        index = "polvora",
        name = "Polvora",
        png = "polvora",
        weight = 0.01,
        type = "use"
    },
    ["capsulas"] = {
        index = "capsulas",
        name = "Capsulas",
        png = "capsulas",
        weight = 0.01,
        type = "use"
    },
    ["capsulasespecial"] = {
        index = "capsulasespecial",
        name = "Capsulas Especiais",
        png = "capsulasespecial",
        weight = 0.01,
        type = "use"
    },

    ["pulseiraroubada"] = {
        index = "pulseiraroubada",
        name = "Pulseira",
        png = "pulseiraroubada",
        weight = 0.1,
        type = "use"
    },

    ["scubagear"] = {
        index = "scubagear",
        name = "Kit de Mergulho",
        png = "scubagear",
        weight = 10.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if not Remote.checkScuba(source) then
                if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                    Remote._setScuba(source, true)
                    return cb(true)
                end
            else
                TriggerClientEvent("Notify", source, "negado",
                    "Você ja possui uma scuba equipada, para retira-la /rscuba", 5)
                return cb(false)
            end
        end

    },

    ["tucunare"] = {
        index = "tucunare",
        name = "Tucunare",
        png = "tucunare",
        weight = 2.0,
        type = "use"
    },
    
    ["piranha"] = {
        index = "piranha",
        name = "Piranha",
        png = "piranha",
        weight = 2.0,
        type = "use"
    },
    
    ["pirarucu"] = {
        index = "pirarucu",
        name = "Pirarucu",
        png = "pirarucu",
        weight = 2.0,
        type = "use"
    },
    
    ["niquel"] = {
        index = "niquel",
        name = "Niquel",
        png = "niquel",
        weight = 2.0,
        type = "use"
    },
    ["cromo"] = {
        index = "cromo",
        name = "Cromo",
        png = "cromo",
        weight = 2.0,
        type = "use"
    },
    ["niobo"] = {
        index = "niobo",
        name = "Niobo",
        png = "niobo",
        weight = 2.0,
        type = "use"
    },
    ["picareta"] = {
        index = "picareta",
        name = "Picareta",
        png = "picareta",
        weight = 0.25,
        type = "use"
    },
    ["vara"] = {
        index = "vara",
        name = "Vara de Pesca",
        png = "vara",
        weight = 0.25,
        type = "use"
    },

    ["dirty_money"] = {
        index = "dirty_money",
        name = "Dinheiro Sujo",
        png = "dirty_money",
        weight = 0.0,
        type = "use"
    },

    ["valemansao8m"] = {
        index = "valemansao8m",
        name = "Vale mansao 8m",
        png = "valemansao8m",
        weight = 0.0,
        type = "use"
    },

    ["c-fio"] = {
        index = "c-fio",
        name = "Fio",
        png = "c-fio",
        weight = 0.4,
        type = "use"
    },

    ["attachs"] = {
        index = "attachs",
        name = "Attachs",
        png = "attachs",
        weight = 0.2,
        type = "use",
        func = function(user_id, source, item, slot, cb)
            TriggerClientEvent("Weapon:Attachs", source)
            return cb(true)
        end
    },

    ["ammo_pistol"] = {
        index = "ammo_pistol",
        name = "M-Pistol",
        png = "ammo_pistol",
        weight = 0.05,
        type = "recharge"
    },

    ["sprunk"] = {
        index = "sprunk",
        name = "Sprunk",
        png = "sprunk",
        weight = 0.5,
        type = "use",
        func = Beber
    },

    ["none"] = {
        index = "none",
        name = "none",
        png = "none",
        weight = 0.0,
        type = "use"
    },

    ["anticoncepcional"] = {
        index = "anticoncepcional",
        name = "Anticoncepcional",
        png = "anticoncepcional",
        weight = 0.05,
        type = "use"
    },

 --  ["weapon_raypistol"] = {
 --      index = "weapon_raypistol",
 --      name = "RayPistol",
 --      png = "weapon_raypistol",
 --      weight = 3.0,
 --      type = "equip"
 --  },

    ["fireworks"] = {
        index = "fireworks",
        name = "Fogos de Artifício",
        png = "fireworks",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if not rEVOLTc.isInVehicle(source) then
                local status, time = func:getCooldown(user_id, "fireworks")
                if status then
                    func:setCooldown(user_id, "fireworks", 80)

                    if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                        TriggerClientEvent("progress", source, 2)
                        func:setBlockCommand(user_id, 4)
                        rEVOLTc._playAnim(source, false, { { "anim@mp_fireworks", "place_firework_3_box" } }, true)

                        SetTimeout(2000, function()
                            Remote._closeInventory(source)
                            rEVOLTc._stopAnim(source, false)
                            TriggerClientEvent("fireworks:use", source)
                        end)
                        return cb(true)
                    end
                else
                    TriggerClientEvent("Notify", source, "negado",
                        "Você não pode usar o fireworks novamente, espere um pouco: " .. time)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Você não pode usar o fireworks dentro do veículo.")
            end
            return cb(false)
        end
    },

    ["weapon_sawnoffshotgun"] = {
        index = "weapon_sawnoffshotgun",
        name = "Shotgun",
        png = "weapon_sawnoffshotgun",
        weight = 8.0,
        type = "equip"
    },

    ["balinha"] = {
        index = "balinha",
        name = "Balinha",
        png = "balinha",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = OthersDrugs
    },

    ["paoq"] = {
        index = "paoq",
        name = "Pao de Queijo",
        png = "paoq",
        weight = 0.3,
        type = "use"
    },

    ["weapon_bottle"] = {
        index = "weapon_bottle",
        name = "Bottle",
        png = "weapon_bottle",
        weight = 3.0,
        type = "equip"
    },

    ["macarico"] = {
        index = "macarico",
        name = "Maçarico",
        png = "macarico",
        weight = 1.0,
        type = "use"
    },

    ["mochila"] = {
        index = "mochila",
        name = "Mochila",
        png = "mochila",
        weight = 2.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if 3 > tonumber(rEVOLT.getMochilaAmount(user_id)) then
                if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                    rEVOLT.addMochila(user_id)
                    TriggerClientEvent("Notify", source, "importante",
                        "Você equipou a mochila, limite maximo de <b>(" ..
                        rEVOLT.getMochilaAmount(user_id) .. "/" .. 3 .. ")</b> mochilas.", 5)
                    return cb(true)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Você ja antigiu o limite maximo de <b>(3)</b> mochilas.",
                    5)
                return cb(false)
            end
        end

    },

    ["mochilax"] = {
        index = "mochilax",
        name = "Mochila X",
        png = "mochilax",
        weight = 2.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if 4 > tonumber(rEVOLT.getMochilaAmount(user_id)) then
                if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                    rEVOLT.addMochila(user_id)
                    TriggerClientEvent("Notify", source, "importante",
                        "Você equipou a mochila, limite maximo de <b>(" ..
                        rEVOLT.getMochilaAmount(user_id) .. "/" .. 3 .. ")</b> mochilas.", 5)
                    return cb(true)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Você ja antigiu o limite maximo de <b>(4)</b> mochilas.",
                    5)
                return cb(false)
            end
        end

    },

    ["roupas"] = {
        index = "roupas",
        name = "Roupas",
        png = "roupas",
        weight = 0.0,
        type = "use"
    },

    ["pacote_polvora"] = {
        index = "pacote_polvora",
        name = "Pacote de Polvora",
        png = "pacote_polvora",
        weight = 3.0,
        type = "use"
    },

    ["m-corpo_smg_mk2"] = {
        index = "m-corpo_smg_mk2",
        name = "Corpo de SMG",
        png = "m-corpo_smg_mk2",
        weight = 2.0,
        type = "use"
    },

    ["weapon_grajada"] = {
        index = "weapon_grajada",
        name = "Grajada",
        png = "weapon_grajada",
        weight = 8.0,
        type = "equip"
    },

    ["weapon_carbinerifle_mk2"] = {
        index = "weapon_carbinerifle_mk2",
        name = "M4MK2",
        png = "weapon_carbinerifle_mk2",
        weight = 8.0,
        type = "equip"
    },

    ["weapon_firework"] = {
        index = "weapon_firework",
        name = "Fogos",
        png = "weapon_firework",
        weight = 3.0,
        type = "equip"
    },

    ["kitnitro"] = {
        index = "kitnitro",
        name = "Kit de Nitro",
        png = "kitnitro",
        weight = 1.0,
        type = "use",
        func = function(user_id, source, item, slot, cb)
            TriggerClientEvent("install_nitro", source)
        end
    },

    ["weapon_heavypistol"] = {
        index = "weapon_heavypistol",
        name = "HeavyPistol",
        png = "weapon_heavypistol",
        weight = 3.0,
        type = "equip"
    },

    ["weapon_combatpistol"] = {
        index = "weapon_combatpistol",
        name = "Glock",
        png = "weapon_combatpistol",
        weight = 3.0,
        type = "equip"
    },

    ["weapon_ceramicpistol"] = {
        index = "weapon_ceramicpistol",
        name = "Pistola Ceramica",
        png = "weapon_ceramicpistol",
        weight = 3.0,
        type = "equip"
    },

    ["ammo_ceramicpistol"] = {
        index = "ammo_ceramicpistol",
        name = "M-Pistola Ceramica",
        png = "ammo_ceramicpistol",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_smg_mk2"] = {
        index = "ammo_smg_mk2",
        name = "M-Smg MK2",
        png = "ammo_smg_mk2",
        weight = 0.05,
        type = "recharge"
    },

    ["skate"] = {
        index = "skate",
        name = "Skate",
        png = "skate",
        weight = 1.0,
        type = "use"
    },

    ["money"] = {
        index = "money",
        name = "Dinheiro",
        png = "money",
        weight = 0.000001,
        type = "use"
    },

    ["valemansao500k"] = {
        index = "valemansao500k",
        name = "Vale mansao 500k",
        png = "valemansao500k",
        weight = 0.0,
        type = "use"
    },

    ["weapon_switchblade"] = {
        index = "weapon_switchblade",
        name = "SwitchBlade",
        png = "weapon_switchblade",
        weight = 3.0,
        type = "equip"
    },

    ["bandagem"] = {
        index = "bandagem",
        name = "Bandagem",
        png = "bandagem",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                -- rEVOLTc._CarregarObjeto(source, "amb@world_human_clipboard@male@idle_a", "idle_c", "v_ret_ta_firstaid", 49,
                --     60309)
                TriggerClientEvent('bandagem:anim', source)

                TriggerClientEvent("progress", source, 15)
                SetTimeout(15 * 1000, function()
                    rEVOLTc._DeletarObjeto(source)
                    Remote._useBandagem(source, true, 'Bandagem')
                    TriggerClientEvent("Notify", source, "importante",
                        "Você utilizou a bandagem, não tome nenhum tipo de dano para não ser cancelada.", 5)
                end)
                func:setCooldown(user_id, "inventario", 5)

                return cb(true)
            end
            return cb(false)
        end
    },

    ["barrier"] = {
        index = "barrier",
        name = "Tenda",
        png = "barrier",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local hash = "prop-tendarelikiashop"
            local application,Coords,heading = Remote.objectCoords(source, hash)
            if application then
                if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                    Remote.createObject(source, hash, vec4(Coords.x, Coords.y, Coords.z - 1.0, heading))
                    Remote.createItem(source, hash, Coords, heading)
                    func:setCooldown(user_id, "inventario", 5)
                    return cb(true)
                end
            end
            return cb(false)
        end
    },

    ["coordenada_balistica"] = {
        index = "coordenada_balistica",
        name = "Coordenada Balística",
        png = "coordenada_balistica",
        weight = 0.3,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local hash = "prop_laptop_01a"
            local application, Coords, heading = Remote.objectCoords(source, hash)
            if application then
                if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                    Remote.createObject(source, hash, vec4(Coords.x, Coords.y, Coords.z, heading))
                    Remote.createItem(source, hash, Coords, heading)
                    func:setCooldown(user_id, "inventario", 5)
                    TriggerClientEvent("Notify", source, "sucesso", "Coordenada balística posicionada com sucesso.", 5)
                    return cb(true)
                end
            end
            return cb(false)
        end
    },

    ["weapon_gusenberg"] = {
        index = "weapon_gusenberg",
        name = "Submetralhadora Thompson",
        png = "weapon_gusenberg",
        weight = 3.0,
        type = "equip"
    },

    ["ammo_assaultsmg"] = {
        index = "ammo_assaultsmg",
        name = "M-MTAR",
        png = "ammo_assaultsmg",
        weight = 0.05,
        type = "recharge"
    },

    ["chave_algemas"] = {
        index = "chave_algemas",
        name = "Chave de algemas",
        png = "chave_algemas",
        weight = 0.3,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local nplayer = rEVOLTc.getNearestPlayer(source, 3)
            if nplayer then

                if rEVOLTc.isHandcuffed(nplayer) then
                    if rEVOLT.tryGetInventoryItem(user_id, "chave_algemas", 1, true, slot) then
                        rEVOLTc._playAnim(source, false, { { "mp_arrest_paired", "cop_p2_back_left" } }, false)
                        rEVOLTc._playAnim(nplayer, false, { { "mp_arrest_paired", "crook_p2_back_left" } }, false)
                        SetTimeout(3500, function()
                            rEVOLTc._stopAnim(source, false)
                            rEVOLTc._toggleHandcuff(nplayer)
                            TriggerClientEvent("revolt_sound:source", source, "cuff", 0.1)
                            TriggerClientEvent("revolt_sound:source", nplayer, "cuff", 0.1)
                            rEVOLTc._setHandcuffed(nplayer, false)
                        end)
                        return cb(true)
                    else
                        TriggerClientEvent("Notify", source, "negado", "Você não possui chave da algema.", 5)
                    end
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Nenhum jogador proximo.", 5)
            end
            return cb(false)
        end
    },

    ["c-cobre"] = {
        index = "c-cobre",
        name = "Cobre",
        png = "c-cobre",
        weight = 0.4,
        type = "use"
    },

    ["weapon_appistol"] = {
        index = "weapon_appistol",
        name = "Ap Pistol",
        png = "weapon_appistol",
        weight = 3.0,
        type = "equip"
    },

    ["tiner"] = {
        index = "tiner",
        name = "Tiner",
        png = "tiner",
        weight = 0.3,
        type = "use"
    },

    ["m-gatilho"] = {
        index = "m-gatilho",
        name = "Gatilho",
        png = "m-gatilho",
        weight = 0.8,
        type = "use"
    },

    ["ammo_doubleaction"] = {
        index = "ammo_doubleaction",
        name = "M-DOUBLEACTION",
        png = "ammo_doubleaction",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_snspistol_mk2"] = {
        index = "ammo_snspistol_mk2",
        name = "M-Fajuta",
        png = "ammo_snspistol_mk2",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_knuckle"] = {
        index = "weapon_knuckle",
        name = "Knuckle",
        png = "weapon_knuckle",
        weight = 3.0,
        type = "equip"
    },

    ["carnedelobo"] = {
        index = "carnedelobo",
        name = "Carne de Lobo",
        png = "carnedelobo",
        weight = 3.0,
        type = "use"
    },

    ["pacote_tecido"] = {
        index = "pacote_tecido",
        name = "Pacote de Tecido",
        png = "pacote_tecido",
        weight = 3.0,
        type = "use"
    },

    ["caixa"] = {
        index = "caixa",
        name = "Caixa de entrega",
        png = "caixa",
        weight = 0.2,
        type = "use"
    },

    ["sabao"] = {
        index = "sabao",
        name = "Sabão",
        png = "sabao",
        weight = 0.2,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if Remote.checkInWater(source) then 
                if rEVOLT.tryGetInventoryItem(user_id,item,1,true) then 
                    Remote._closeInventory(source)
                    if GetResourceState("evidence") == "started" then 
                        exports["evidence"]:ClearEvidence(user_id)
                    end

                    return cb(true)
                end
            end


            return cb(false)
        end
    },

    ["pamonha"] = {
        index = "pamonha",
        name = "Pamonha",
        png = "pamonha",
        weight = 0.2,
        type = "use"
    },
    ["milho"] = {
        index = "milho",
        name = "Milho",
        png = "milho",
        weight = 0.2,
        type = "use"
    },
    ["pacoca"] = {
        index = "pacoca",
        name = "Paçoca",
        png = "pacoca",
        weight = 0.2,
        type = "use"
    },
    ["peixe"] = {
        index = "peixe",
        name = "Peixe",
        png = "peixe",
        weight = 0.2,
        type = "use"
    },

    ["weapon_flare"] = {
        index = "weapon_flare",
        name = "Sinalizador",
        png = "weapon_flare",
        weight = 3.0,
        type = "equip"
    },

    ["doritos"] = {
        index = "doritos",
        name = "Doritos",
        png = "doritos",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                rEVOLTc._CarregarObjeto(source, "amb@code_human_wander_eating_donut@male@idle_a", "idle_a", "lg_doritos", 49,
                    28422)

                TriggerClientEvent("progress", source, 15)
                SetTimeout(15 * 1000, function()
                    rEVOLTc._DeletarObjeto(source)
                    Remote._useBandagem(source, true, 'Doritos')
                    TriggerClientEvent("Notify", source, "importante",
                        "Você utilizou doritos, não tome nenhum tipo de dano para não ser cancelada.", 5)
                end)

                func:setCooldown(user_id, "inventario", 5)

                return cb(true)
            end
            return cb(false)
        end
    },

    ["sanduiche"] = {
        index = "sanduiche",
        name = "Sanduiche",
        png = "sanduiche",
        weight = 0.5,
        type = "use"
    },

    ["ferramenta"] = {
        index = "ferramenta",
        name = "Ferramenta",
        png = "ferramenta",
        weight = 1.0,
        type = "use"
    },

    ["weapon_battleaxe"] = {
        index = "weapon_battleaxe",
        name = "Battleaxe",
        png = "weapon_battleaxe",
        weight = 3.0,
        type = "equip"
    },

    ["distintivopolicial"] = {
        index = "distintivopolicial",
        name = "Distintivo Policial",
        png = "distintivopolicial",
        weight = 0.3,
        type = "use"
    },


    ["ammo_carbinerifle_mk2"] = {
        index = "ammo_carbinerifle_mk2",
        name = "M-M4",
        png = "ammo_carbinerifle_mk2",
        weight = 0.05,
        type = "recharge"
    },

    ["m-corpo_pistol_mk2"] = {
        index = "m-corpo_pistol_mk2",
        name = "Corpo de Pistol",
        png = "m-corpo_pistol_mk2",
        weight = 1.5,
        type = "use"
    },

    ["repairkit"] = {
        index = "repairkit",
        name = "Jogue Fora",
        png = "repairkit",
        weight = 1.0,
        type = "use"
    },

    ["panetone"] = {
        index = "panetone",
        name = "Panetone",
        png = "panetone",
        weight = 0.5,
        type = "use"
    },

    ["pastabase"] = {
        index = "pastabase",
        name = "Pasta Base",
        png = "pastabase",
        weight = 0.3,
        type = "use"
    },

    ["ammo_heavypistol"] = {
        index = "ammo_heavypistol",
        name = "M-HeavyPistol",
        png = "ammo_heavypistol",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_pumpshotgun_mk2"] = {
        index = "ammo_pumpshotgun_mk2",
        name = "M-Pump Shotgun",
        png = "ammo_pumpshotgun_mk2",
        weight = 0.05,
        type = "recharge"
    },

    ["aluminio"] = {
        index = "aluminio",
        name = "Aluminio",
        png = "aluminio",
        weight = 0.05,
        type = "use"
    },

    ["dogao"] = {
        index = "dogao",
        name = "Dogão",
        png = "dogao",
        weight = 0.5,
        type = "use"
    },

    ["pao"] = {
        index = "pao",
        name = "Pao",
        png = "pao",
        weight = 0.5,
        type = "use"
    },

    ["pecadearma"] = {
        index = "pecadearma",
        name = "Peça de arma",
        png = "pecadearma",
        weight = 0.1,
        type = "use"
    },

    ["pecaespecial"] = {
        index = "pecaespecial",
        name = "Peça de arma especial",
        png = "pecaespecial",
        weight = 0.1,
        type = "use"
    },

    ["pecachampions"] = {
        index = "pecachampions",
        name = "Peça de Champions",
        png = "pecachampions",
        weight = 0.1,
        type = "use"
    },

    
    ["tecido"] = {
        index = "tecido",
        name = "Tecido",
        png = "tecido",
        weight = 0.1,
        type = "use"
    },

    ["nfairsoft"] = {
        index = "nfairsoft",
        name = "Nota fiscal de Arma",
        png = "nfairsoft",
        weight = 0.1,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            Remote._closeInventory(source)
            TriggerClientEvent('brasil_snippets:openNFE', source, 'nfairsoft')
            if rEVOLT.hasPermission(user_id, 'perm.disparo') then
                rEVOLT.tryGetInventoryItem(user_id, item, 1)
            end
            return cb(true)
        end
    },

    ["nffogosartificio"] = {
        index = "nffogosartificio",
        name = "Nota fiscal de Municao",
        png = "nffogosartificio",
        weight = 0.1,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            Remote._closeInventory(source)
            TriggerClientEvent('brasil_snippets:openNFE', source, 'nffogosartificio')
            if rEVOLT.hasPermission(user_id, 'perm.disparo') then
                rEVOLT.tryGetInventoryItem(user_id, item, 1)
            end
            return cb(true)
        end
    },

    ["nfmercado"] = {
        index = "nfmercado",
        name = "Nota fiscal de Lavagem",
        png = "nfmercado",
        weight = 0.1,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            Remote._closeInventory(source)
            TriggerClientEvent('brasil_snippets:openNFE', source, 'nfmercado')
            if rEVOLT.hasPermission(user_id, 'perm.disparo') then
                rEVOLT.tryGetInventoryItem(user_id, item, 1)
            end
            return cb(true)
        end
    },

    ["nfmed1"] = {
        index = "nfmed1",
        name = "Nota fiscal de Droga",
        png = "nfmed1",
        weight = 0.1,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            Remote._closeInventory(source)
            TriggerClientEvent('brasil_snippets:openNFE', source, 'nfmed1')
            if rEVOLT.hasPermission(user_id, 'perm.disparo') then
                rEVOLT.tryGetInventoryItem(user_id, item, 1)
            end
            return cb(true)
        end
    },
    ["nfmed2"] = {
        index = "nfmed2",
        name = "Nota fiscal de Droga 2",
        png = "nfmed2",
        weight = 0.1,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            Remote._closeInventory(source)
            TriggerClientEvent('brasil_snippets:openNFE', source, 'nfmed2')
            if rEVOLT.hasPermission(user_id, 'perm.disparo') then
                rEVOLT.tryGetInventoryItem(user_id, item, 1)
            end
            return cb(true)
        end
    },
    ["nfmed3"] = {
        index = "nfmed3",
        name = "Nota fiscal de Droga 3",
        png = "nfmed3",
        weight = 0.1,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            Remote._closeInventory(source)
            TriggerClientEvent('brasil_snippets:openNFE', source, 'nfmed3')
            if rEVOLT.hasPermission(user_id, 'perm.disparo') then
                rEVOLT.tryGetInventoryItem(user_id, item, 1)
            end
            return cb(true)
        end
    },
    ["nfmed4"] = {
        index = "nfmed4",
        name = "Nota fiscal de Droga 4",
        png = "nfmed4",
        weight = 0.1,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            Remote._closeInventory(source)
            TriggerClientEvent('brasil_snippets:openNFE', source, 'nfmed4')
            if rEVOLT.hasPermission(user_id, 'perm.disparo') then
                rEVOLT.tryGetInventoryItem(user_id, item, 1)
            end
            return cb(true)
        end
    },
    ["nfmed5"] = {
        index = "nfmed5",
        name = "Nota fiscal de Droga 5",
        png = "nfmed5",
        weight = 0.1,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            Remote._closeInventory(source)
            TriggerClientEvent('brasil_snippets:openNFE', source, 'nfmed5')
            if rEVOLT.hasPermission(user_id, 'perm.disparo') then
                rEVOLT.tryGetInventoryItem(user_id, item, 1)
            end
            return cb(true)
        end
    },

    ["nfmetalurgica"] = {
        index = "nfmetalurgica",
        name = "Nota fiscal de Desmanche",
        png = "nfmetalurgica",
        weight = 0.1,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            Remote._closeInventory(source)
            TriggerClientEvent('brasil_snippets:openNFE', source, 'nfmetalurgica')
            if rEVOLT.hasPermission(user_id, 'perm.disparo') then
                rEVOLT.tryGetInventoryItem(user_id, item, 1)
            end
            return cb(true)
        end
    },

    ["intimacao"] = {
        index = "intimacao",
        name = "Intimação",
        png = "intimacao",
        weight = 0.1,
        type = "use",
    },

    ["coin"] = {
        index = "coin",
        name = "Coin",
        png = "coin",
        weight = 0.1,
        type = "use"
    },

    ["maca"] = {
        index = "maca",
        name = "Maça",
        png = "maca",
        weight = 1.0,
        type = "use"
    },

    ["m-corpo_machinepistol"] = {
        index = "m-corpo_machinepistol",
        name = "Corpo de TEC-9",
        png = "m-corpo_machinepistol",
        weight = 2.0,
        type = "use"
    },

    ["celular"] = {
        index = "celular",
        name = "Celular",
        png = "celular",
        weight = 1.0,
        type = "use"
    },

    ["barricada"] = {
        index = "barricada",
        name = "Barricada",
        png = "barricada",
        weight = 1.0,
        type = "use"
    },

    ["radio"] = {
        index = "radio",
        name = "Radio",
        png = "radio",
        weight = 1.0,
        type = "use"
    },

    ["tomate"] = {
        index = "tomate",
        name = "Tomate",
        png = "tomate",
        weight = 1.0,
        type = "use"
    },

    ["repairkit3"] = {
        index = "repairkit3",
        name = "Kit Reparo",
        png = "repairkit3",
        weight = 1.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if rEVOLTc.isInVehicle(source) then
                TriggerClientEvent("Notify", source, "negado", "Você não pode usar o kit de reparo dentro do veiculo.", 5)
                return cb(false)
            end

			local vehicle = rEVOLTc.getNearestVehicle(source,3)
            local serverVehicle = getNearestPlayerVehicle(source, 7)
            if not vehicle then return cb(false) end

            local blockedVehicles = {
                [GetHashKey('wrarmoredcayenne')] = true,
                [GetHashKey('wrarmoredm3g80c')] = true,
                [GetHashKey('wrarmoredm5')] = true,
                [GetHashKey('wrarmoredmacan')] = true,
                [GetHashKey('wrarmoredrs7')] = true,
                [GetHashKey('wrarmoredx7m60i')] = true,
                [GetHashKey('wrbb64')] = true,
            }

            local vehicleEntity = NetworkGetEntityFromNetworkId(vehicle)
            if blockedVehicles[GetEntityModel(vehicleEntity)] then
                TriggerClientEvent("Notify", source, "negado", "Você não pode reparar este veiculo.")
                return cb(false)
            end
            
            if rEVOLT.tryGetInventoryItem(user_id, "repairkit3", 1, true, slot) then
                rEVOLTc._playAnim(source, false, { { "mini@repair", "fixing_a_player" } }, true)
                TriggerClientEvent("progress", source, 30)
                func:setBlockCommand(user_id, 35)
                TriggerClientEvent('abrircapo', source)
                exports.revolt_player:addSeatCooldown(user_id, 35)
                SetTimeout(30000, function()
                    if serverVehicle and DoesEntityExist(serverVehicle) then
                        local ownerId = NetworkGetEntityOwner(serverVehicle)
                        local vehicleNetId = NetworkGetNetworkIdFromEntity(serverVehicle)
                        TriggerClientEvent('syncrepararmotor', ownerId, vehicleNetId)
                    else
                        TriggerClientEvent("repararmotor", source, vehicle)
                    end

                    rEVOLTc._stopAnim(source, false)
                    TriggerClientEvent("Notify", source, "sucesso", "Você reparou o veiculo.", 5)
                end)
            return cb(true)
            end
            return cb(false)
        end
    },

    ["rastreador"] = {
        index = "rastreador",
        name = "Rastreador",
        png = "rastreador",
        weight = 1.0,
        type = "use",
        keep_item = true,
        
        func = function(user_id, source, item, slot, cb)

            -- if not rEVOLT.hasPermission(user_id, "perm.redline") then
            --     TriggerClientEvent("Notify", source, "negado", "Você não tem permissão para usar este item.", 5)
            --     return cb(false)
            -- end

            if rEVOLTc.isInVehicle(source) then
                TriggerClientEvent("Notify", source, "negado", "Você não pode usar o rastreador dentro do veiculo.", 5)
                return cb(false)
            end

            local plate, mName, mNet, mPortaMalas, mPrice, mLock, mModel = rEVOLTc.ModelName(source, 7)
            local plateUser = rEVOLT.getUserByRegistration(plate)


            if not plate then
                TriggerClientEvent("Notify", source, "negado", "Você não perto de um veículo.", 5)
                return cb(false)
            end


            local entity = NetworkGetEntityFromNetworkId(mNet)

            if entity and entity == 0 then
                TriggerClientEvent("Notify", source, "negado", "Veiculo não encontrado.", 5)
                return cb(false)
            end

            if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                exports["garage"]:insertTracker(source)
                return cb(true)
            end
        end
    },

    ["alicate"] = {
        index = "alicate",
        name = "Alicate",
        png = "alicate",
        weight = 1.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)

            if rEVOLTc.isInVehicle(source) then 
                TriggerClientEvent("Notify", source, "negado", "Você não pode usar o alicate dentro do veiculo.", 5)
                return cb(false)
            end

            local plate, mName, mNet, mPortaMalas, mPrice, mLock, mModel = rEVOLTc.ModelName(source, 7)
            local plateUser = rEVOLT.getUserByRegistration(plate)

            if not plate then
                TriggerClientEvent("Notify", source, "negado", "Você não perto de um veículo.", 5)
                return cb(false)
            end

            local entity = NetworkGetEntityFromNetworkId(mNet)

            if entity and entity == 0 then
                TriggerClientEvent("Notify", source, "negado", "Veiculo não encontrado.", 5)
                return cb(false)
            end

            if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                exports["garage"]:removeTracker(source)
                return cb(true)
            end
        end
    },

    ["graosimpuros"] = {
        index = "graosimpuros",
        name = "Graos",
        png = "graosimpuros",
        weight = 1.0,
        type = "use"
    },

    ["c4"] = {
        index = "c4",
        name = "C4",
        png = "c4",
        weight = 0.1,
        type = "use"
    },

    ["c-polvora"] = {
        index = "c-polvora",
        name = "Polvora",
        png = "c-polvora",
        weight = 0.3,
        type = "use"
    },

    ["laudoteorico"] = {
        index = "laudoteorico",
        name = "Laudo Teorico",
        png = "laudoteorico",
        weight = 0.3,
        type = "use"
    },

    ["laudopratico"] = {
        index = "laudopratico",
        name = "Laudo Pratico",
        png = "laudopratico",
        weight = 0.3,
        type = "use"
    },

    ["kitneon"] = {
        index = "kitneon",
        name = "Kit Neon",
        png = "kitneon",
        weight = 1.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local plate, mName, mNet, mPortaMalas, mPrice, mLock, mModel = rEVOLTc.ModelName(source, 7)
            local plateUser = rEVOLT.getUserByRegistration(plate)
            if not plate then
                TriggerClientEvent("Notify", source, "negado", "Você não está perto de um veículo.", 5)
                return cb(false)
            end

            Remote._closeInventory(source)
            Wait(1000)

            exports["rtx_neonsreloaded"]:Install(source,plate)
        end
    },

    ["lockpick"] = {
        index = "lockpick",
        name = "Lock Pick",
        png = "lockpick",
        weight = 1.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if not rEVOLT.isHandcuffed(source) then

                local plate, mName, mNet, mPortaMalas, mPrice, mLock, mModel = rEVOLTc.ModelName(source, 7)
                if plate then 
                    local plateUser = rEVOLT.getUserByRegistration(plate)
                    if not plate then
                        TriggerClientEvent("Notify", source, "negado", "Você não perto de um veículo.", 5)
                        return cb(false)
                    end

                    local inSafezone = RemoteZone.checkInZone(source)
                    if inSafezone then 
                        return false, TriggerClientEvent("Notify",source,"negado","Uso bloqueado.",5)
                    end

                    local plyCoords = GetEntityCoords(GetPlayerPed(source))
                    local distance = #(plyCoords - vec3(178.01, -1014.68, 29.35))
                    local distance2 = #(plyCoords - vec3(-450.4, -365.93, 33.3))
                    if distance <= 94.0 or distance2 <= 104.0 then
                        TriggerClientEvent("Notify", source, "negado", "Você não pode usar lockpick nesta área.", 5)
                        return cb(false)
                    end

                    if not mLock then
                        TriggerClientEvent("Notify", source, "negado", "O veículo não está trancado.", 5)
                        return cb(false)
                    end

                    if rEVOLT.tryGetInventoryItem(user_id, "lockpick", 1, true, slot) then
                        Remote._closeInventory(source)
                        Wait(1000)
                        Remote._startAnimHotwired(source)
                        local finished = rEVOLTc.taskBar(source)
                        if finished then
                            local entity = NetworkGetEntityFromNetworkId(mNet)
                            if entity then
                                SetVehicleDoorsLocked(entity, 1)
                            end

                            TriggerClientEvent("revolt_sound:source", source, "lock", 0.1)
                            TriggerClientEvent("Notify", source, "negado",
                                "Você destrancou o veiculo, cuidado a policia foi acionada.", 5)
                            rEVOLT._sendLog("lockpick",
                                "**SUCESSO** O [ID: " ..
                                user_id ..
                                "] Roubou o veiculo " ..
                                mModel .. "(ID:" .. plateUser .. ") nas nas cordenadas: " .. plyCoords.x .. "," .. plyCoords.y .. "," .. plyCoords.z)

                            
                            exports["revolt_admin"]:generateLog({
                                category = "inventario",
                                room = "lockpick",
                                user_id = user_id,
                                message = ([[O usuário %s roubou o veículo %s do usuário %s nas coordenadas %s]]):format(user_id, mModel,
                                    plateUser, vec3(plyCoords.x, plyCoords.y, plyCoords.z))
                            })
                            -- end
                            -- end
                        end

                        func:alertPolice({
                            x = x,
                            y = y,
                            z = z,
                            blipID = 161,
                            blipColor = 63,
                            blipScale = 0.5,
                            time = 20,
                            code =
                            "911",
                            title = "Veiculo Roubado (" .. mModel .. ")",
                            name =
                                "Um novo registro de tentativa de roubo de veiculo, Modelo: " ..
                                mModel .. " Placa: " .. plate .. ". "
                        })
                        rEVOLTc._stopAnim(source, false)
                    end
                end
            else
                Remote._closeInventory(source)
                Wait(1000)
                local finished = rEVOLTc.taskBar(source)
                if finished then
                    if rEVOLT.tryGetInventoryItem(user_id, "lockpick", 1, true, slot) then
                        rEVOLTc._stopAnim(source, false)
                        rEVOLTc._toggleHandcuff(source)
                        TriggerClientEvent("revolt_sound:source", source, "cuff", 0.1)
                        rEVOLTc._setHandcuffed(source, false)
                    end
                end
            end
        end
    },

    ["weapon_militaryrifle"] = {
        index = "weapon_militaryrifle",
        name = "MilitaryRifle",
        png = "weapon_militaryrifle",
        weight = 8.0,
        type = "equip"
    },

    ["valemansao10m"] = {
        index = "valemansao10m",
        name = "Vale mansao 10m",
        png = "valemansao10m",
        weight = 0.0,
        type = "use"
    },

    ["ammo_grajada"] = {
        index = "ammo_grajada",
        name = "M-Grajada",
        png = "ammo_grajada",
        weight = 0.05,
        type = "recharge"
    },

    ["m-malha"] = {
        index = "m-malha",
        name = "Malha",
        png = "m-malha",
        weight = 0.4,
        type = "use"
    },

    ["capuz"] = {
        index = "capuz",
        name = "Capuz",
        png = "capuz",
        weight = 0.1,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local nplayer = rEVOLTc.getNearestPlayer(source, 5)
            if not nplayer or nplayer <= 0 then
                TriggerClientEvent("Notify", source, "negado", "Nenhum jogador proximo.", 5)
                return
            end

            if rEVOLTc.isHandcuffed(nplayer) then
                if rEVOLTc.isCapuz(nplayer) then
                    if not rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                        return cb(false)
                    end
                    rEVOLTc._setCapuz(nplayer, false)
                    TriggerClientEvent("Notify", source, "sucesso", "Você retirou o capuz desse jogador.", 5)
                else
                    rEVOLTc._setCapuz(nplayer, true)
                    TriggerClientEvent("Notify", source, "sucesso", "Você colocou o capuz nesse jogador, para retirar use o item novamente.", 5)
                end
                local nuser_id = rEVOLT.getUserId(nplayer)
                rEVOLT._sendLog("capuz", "O USER_ID: " .. user_id .. " Usou o Capuz no USER_ID: " .. nuser_id)
                
                exports["revolt_admin"]:generateLog({
                    category = "inventario",
                    room = "capuz",
                    user_id = user_id,
                    message = ([[O USER_ID %s USOU O CAPUZ NO USER_ID %s]]):format(user_id, nuser_id)
                })
                return cb(true)
            else
                TriggerClientEvent("Notify", source, "importante", "O jogador não está rendido ou algemado!", 5)
            end

            return cb(false)
        end
    },
    ["sucol"] = {
        index = "sucol",
        name = "Suco de Laranja",
        png = "sucol",
        weight = 0.5,
        type = "use",
        func = Beber
    },

    ["pizza"] = {
        index = "pizza",
        name = "Pizza",
        png = "pizza",
        weight = 1.5,
        type = "use"
    },

    ["ammo_carbinerifle"] = {
        index = "ammo_carbinerifle",
        name = "M-M4",
        png = "ammo_carbinerifle",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_parafal"] = {
        index = "ammo_parafal",
        name = "M-PARAFAL",
        png = "ammo_parafal",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_advancedrifle"] = {
        index = "ammo_advancedrifle",
        name = "M-Aug",
        png = "ammo_advancedrifle",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_mcx"] = {
        index = "weapon_mcx",
        name = "PARAFAL",
        png = "weapon_mcx",
        weight = 8.0,
        type = "equip"
    },

    ["weapon_ar10police"] = {
        index = "weapon_ar10police",
        name = "AR10",
        png = "weapon_ar10police",
        weight = 8.0,
        type = "equip"
    },

        
    ["ammo_ar10police"] = {
        index = "ammo_ar10police",
        name = "M-AR10",
        png = "ammo_ar10police",
        weight = 0.05,
        type = "recharge"
    },

    
    ["ammo_mcx"] = {
        index = "ammo_mcx",
        name = "M-MCX",
        png = "ammo_mcx",
        weight = 0.05,
        type = "recharge"
    },

    
    ["weapon_falllotus"] = {
        index = "weapon_falllotus",
        name = "PARAFAL",
        png = "weapon_falllotus",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_falllotus"] = {
        index = "ammo_falllotus",
        name = "M-Fall Lotus",
        png = "ammo_falllotus",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_parafal"] = {
        index = "weapon_parafal",
        name = "PARAFAL",
        png = "weapon_parafal",
        weight = 8.0,
        type = "equip"
    },
    ["weapon_arpenteacrilico_relikiashop"] = {
        index = "weapon_arpenteacrilico_relikiashop ",
        name = "AR-Acrilico",
        png = "weapon_arpenteacrilico_relikiashop ",
        weight = 8.0,
        type = "equip"
    },
    ["weapon_advancedrifle"] = {
        index = "weapon_advancedrifle",
        name = "Aug",
        png = "weapon_advancedrifle",
        weight = 8.0,
        type = "equip"
    },
    ["weapon_heavysniper"] = {
        index = "weapon_heavysniper",
        name = "SNIPER",
        png = "weapon_heavysniper",
        weight = 8.0,
        type = "equip"
    },

    ["colarroubado"] = {
        index = "colarroubado",
        name = "Colar",
        png = "colarroubado",
        weight = 0.1,
        type = "use"
    },

    ["m-corpo_g3"] = {
        index = "m-corpo_g3",
        name = "Corpo de G3",
        png = "m-corpo_g3",
        weight = 5.0,
        type = "use"
    },

    ["cafe"] = {
        index = "cafe",
        name = "Cafe",
        png = "cafe",
        weight = 0.25,
        type = "use",
        func = function(user_id, source, item, slot, cb)
            TriggerClientEvent("progress", source, 3)
            play_drink(source, item, 3)
            SetTimeout(3000, function()
                TriggerClientEvent("Notify", source, "sucesso", "Café utilizado com sucesso.", 5)
                Remote._setEnergetico(source, true)
                SetTimeout(17000, function()
                    TriggerClientEvent("Notify", source, "negado", "O Efeito do café acabou.", 5)
                    Remote._setEnergetico(source, false)
                end)
            end)
        end
    },

    ["bebidaestranha"] = {
        index = "bebidaestranha",
        name = "Bebida Estranha",
        png = "bebidaestranha",
        weight = 0.25,
        type = "use",
        func = function(user_id, source, item, slot, cb)
            TriggerClientEvent("progress", source, 3)
            play_drink(source, item, 3)
            SetTimeout(35000, function()
                rEVOLTc._stopAnim(source, false)
                rEVOLTc._setHealth(source, 100)
            end)
        end
    },

    ["whisky"] = {
        index = "whisky",
        name = "Whisky",
        png = "whisky",
        weight = 1.0,
        type = "use",
        func = Beber_Alcoolico
    },

    ["weapon_assaultrifle_mk2"] = {
        index = "weapon_assaultrifle_mk2",
        name = "AK MK2",
        png = "weapon_assaultrifle_mk2",
        weight = 8.0,
        type = "equip"
    },

    ["weapon_assaultrifle"] = {
        index = "weapon_assaultrifle",
        name = "AK 47",
        png = "weapon_assaultrifle",
        weight = 8.0,
        type = "equip"
    },

    ["bronze"] = {
        index = "bronze",
        name = "Bronze",
        png = "bronze",
        weight = 1.0,
        type = "use"
    },

    ["weapon_pumpshotgun_mk2"] = {
        index = "weapon_pumpshotgun_mk2",
        name = "Pump Shotgun",
        png = "weapon_pumpshotgun_mk2",
        weight = 8.0,
        type = "equip"
    },

    ["weapon_pumpshotgun"] = {
        index = "weapon_pumpshotgun",
        name = "Pump Shotgun",
        png = "weapon_pumpshotgun",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_pumpshotgun"] = {
        index = "ammo_pumpshotgun",
        name = "M-Pump Shotgun",
        png = "ammo_pumpshotgun",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_arpenteacrilico_relikiashop"] = {
        index = "ammo_arpenteacrilico_relikiashop",
        name = "M-AR-Acrilico",
        png = "ammo_arpenteacrilico_relikiashop",
        weight = 0.05,
        type = "recharge"
    },

    ["skolb"] = {
        index = "skolb",
        name = "Skol Beats",
        png = "skolb",
        weight = 0.25,
        type = "use",
        func = Beber_Alcoolico
    },

    ["weapon_microsmg"] = {
        index = "weapon_microsmg",
        name = "MICROSMG",
        png = "weapon_microsmg",
        weight = 6.0,
        type = "equip"
    },

    ["ammo_pistol50"] = {
        index = "ammo_pistol50",
        name = "M-Desert",
        png = "ammo_pistol50",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_smg"] = {
        index = "weapon_smg",
        name = "SMG",
        png = "weapon_smg",
        weight = 6.0,
        type = "equip"
    },

    ["weapon_smg_mk2"] = {
        index = "weapon_smg_mk2",
        name = "Smg MK2",
        png = "weapon_smg_mk2",
        weight = 6.0,
        type = "equip"
    },

    ["ammo_machinepistol"] = {
        index = "ammo_machinepistol",
        name = "M-Tec-9",
        png = "ammo_machinepistol",
        weight = 0.05,
        type = "recharge"
    },

    ["weapon_pistol"] = {
        index = "weapon_pistol",
        name = "Pistol",
        png = "weapon_pistol",
        weight = 3.0,
        type = "equip"
    },

    ["identidadefalsa"] = {
        index = "identidadefalsa",
        name = "Identidade Falsa",
        png = "identidadefalsa",
        weight = 0.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            Remote._closeInventory(source)
            Wait(300)
            local nome = rEVOLT.prompt(source, "Novo nome", "")
            local firstname = rEVOLT.prompt(source, "Novo sobrenome", "")
            local idade = rEVOLT.prompt(source, "Nova idade", "")
            local identity = rEVOLT.getUserIdentity(parseInt(user_id))
            if not identity then
                return
            end

            -- Only allow a-z or A-Z for nome and firstname
            if not nome:match("^[a-zA-Z]+$") or not firstname:match("^[a-zA-Z]+$") then
                TriggerClientEvent("Notify", source, "negado", "Nome e sobrenome devem conter apenas letras de A-Z.", 5000)
                return cb(false)
            end

            if #nome > 10 or #firstname > 10 then
                TriggerClientEvent("Notify", source, "negado", "Nome e sobrenome devem ter no máximo 10 caracteres.", 5000)
                return cb(false)
            end

            if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                rEVOLT.execute("rEVOLT/update_user_identity", {
                    user_id = user_id,
                    sobrenome = firstname,
                    nome = nome,
                    idade = idade,
                    registro = identity.registro,
                    telefone = identity.telefone
                })
                TriggerClientEvent("Notify", source, "sucesso","Você renomeou o nome com sucesso. aguarde até o próximo rr da cidade para modificação ser aplicada.",5000)
            end

            return cb(true)
        end
    },


--  ["plastica"] = {
--      index = "plastica",
--      name = "Plastica",
--      png = "plastica",
--      weight = 0.0,
--      type = "use",
--      keep_item = true,
--      func = function(user_id, source, item, slot, cb)
--          if rEVOLT.request(source, "Tem certeza que deseja usar a plastica?", 30) then
--              if not rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
--                  return cb(false)
--              end
--              TriggerClientEvent("Notify", source, "sucesso", "Você usou a plastica.")
--              exports.revolt_admin:rchar(user_id)
--              return cb(true)
--          end
--          return cb(false)
--      end
--  },

    ["weapon_poolcue"] = {
        index = "weapon_poolcue",
        name = "Poolcue",
        png = "weapon_poolcue",
        weight = 3.0,
        type = "equip"
    },

    ["pacote_metalico"] = {
        index = "pacote_metalico",
        name = "Pacote Metalico",
        png = "pacote_metalico",
        weight = 10.0,
        type = "use"
    },

    ["weapon_bat"] = {
        index = "weapon_bat",
        name = "Bastão de Beisebol",
        png = "weapon_bat",
        weight = 3.0,
        type = "equip"
    },

    ["weapon_crowbar"] = {
        index = "weapon_crowbar",
        name = "CrowBar",
        png = "weapon_crowbar",
        weight = 3.0,
        type = "equip"
    },

    ["cerveja"] = {
        index = "cerveja",
        name = "Cerveja",
        png = "cerveja",
        weight = 0.5,
        type = "use",
        func = Beber_Alcoolico
    },

    ["weapon_dagger"] = {
        index = "weapon_dagger",
        name = "Dagger",
        png = "weapon_dagger",
        weight = 3.0,
        type = "equip"
    },

    ["weapon_knife"] = {
        index = "weapon_knife",
        name = "Faca",
        png = "weapon_knife",
        weight = 3.0,
        type = "equip"
    },

    ["weapon_dildo"] = {
        index = "weapon_dildo",
        name = "Dildo",
        png = "weapon_dildo",
        weight = 3.0,
        type = "equip"
    },

    ["weapon_katana"] = {
        index = "weapon_katana",
        name = "Katana",
        png = "weapon_katana",
        weight = 3.0,
        type = "equip"
    },
    
    ["weapon_knife_gold"] = {
        index = "weapon_knife_gold",
        name = "Faca Dourada",
        png = "weapon_knife_gold",
        weight = 3.0,
        type = "equip"
    },

    ["weapon_combatpdw"] = {
        index = "weapon_combatpdw",
        name = "Combat Pdw",
        png = "weapon_combatpdw",
        weight = 3.0,
        type = "equip"
    },

    ["weapon_snowball"] = {
        index = "weapon_snowball",
        name = "Bola de Neve",
        png = "weapon_snowball",
        weight = 3.0,
        type = "equip"
    },

    ["pinga"] = {
        index = "pinga",
        name = "Pinga",
        png = "pinga",
        weight = 1.0,
        type = "use",
        func = Beber_Alcoolico
    },

    ["weapon_pistol50"] = {
        index = "weapon_pistol50",
        name = "Desert Eagle",
        png = "weapon_pistol50",
        weight = 3.0,
        type = "equip"
    },

    ["ammo_gusenberg"] = {
        index = "ammo_gusenberg",
        name = "M-Thompson",
        png = "ammo_gusenberg",
        weight = 0.05,
        type = "recharge"
    },

    ["water"] = {
        index = "water",
        name = "Agua",
        png = "water",
        weight = 0.5,
        type = "use",
        func = Beber
    },

    ["laranja"] = {
        index = "laranja",
        name = "Laranja",
        png = "laranja",
        weight = 1.0,
        type = "use"
    },
    ["weapon_bzgas"] = {
        index = "weapon_bzgas",
        name = "Gas",
        png = "weapon_bzgas",
        weight = 3.0,
        type = "equip"
    },

    ["weapon_doubleaction"] = {
        index = "weapon_doubleaction",
        name = "DOUBLEACTION",
        png = "weapon_doubleaction",
        weight = 8.0,
        type = "equip"
    },

    ["ammo_appistol"] = {
        index = "ammo_appistol",
        name = "M-Ap Pistol",
        png = "ammo_appistol",
        weight = 0.05,
        type = "recharge"
    },

    ["dorflex"] = {
        index = "dorflex",
        name = "Dorflex",
        png = "dorflex",
        weight = 0.05,
        type = "use"
    },

    ["gadget_parachute"] = {
        index = "gadget_parachute",
        name = "Paraquedas",
        png = "gadget_parachute",
        weight = 3.0,
        type = "equip"
    },

    ["manga"] = {
        index = "manga",
        name = "Manga",
        png = "manga",
        weight = 1.0,
        type = "use"
    },

    ["alterartelefone"] = {
        index = "alterartelefone",
        name = "Alterar Telefone",
        png = "alterartelefone",
        weight = 0.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            Remote._closeInventory(source)
            Wait(300)
            local numero = rEVOLT.prompt(source, "Digite o numero: (MAX 6) (EXEMPLO: 123456)", "")
            if tonumber(numero) ~= nil and numero ~= "" and tonumber(numero) and string.len(numero) == 6 then
                numero = formatNumber(numero)
                if checkNumber(numero) then
                    if rEVOLT.request(source, "Tem certeza que deseja alterar o numero de telefone para <b>" .. numero .. "</b> ?", 30) then
                        if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                            rEVOLT._execute("rEVOLT/update_number", { user_id = user_id, telefone = numero })
                            TriggerClientEvent("Notify", source, "sucesso",
                                "Você trocou o numero de telefone para <b>" ..
                                numero .. "</b>, aguarde a cidade reiniciar para alteração ser feita.", 15)
                        end
                    end
                    return cb(true)
                else
                    TriggerClientEvent("Notify", source, "negado", "Este numero de telefone ja existe.", 5)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Digite o numero de telefone correto. (EXEMPLO: 123456)",
                    5)
            end
            return cb(false)
        end
    },

    ["alterarnome"] = {
        index = "alterarnome",
        name = "Alterar Nome",
        png = "alterarnome",
        weight = 0.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local function checkCaracteres(str)
                -- Permite somente letras (A-Z, a-z), sem acentos, pontuação, números ou espaços
                return string.match(str, "^[A-Za-z]+$") ~= nil
            end
            Remote._closeInventory(source)
            Wait(300)

            local nome = rEVOLT.prompt(source, "Digite o nome novo (Apenas letras, sem acentos, pontuação ou espaços)", "")
            if not nome or nome == "" then
                TriggerClientEvent("Notify", source, "negado", "Nome não pode ser vazio.", 5)
                return cb(false)
            end

            -- Garante primeira letra maiúscula e remove espaços extras
            nome = nome:gsub("^%s*(.-)%s*$", "%1")
            nome = nome:sub(1,1):upper() .. nome:sub(2):lower()

            if not checkCaracteres(nome) then
                TriggerClientEvent("Notify", source, "negado", "Nome deve conter apenas letras (A-Z), sem acentos, espaços, números ou caracteres especiais.", 5)
                return cb(false)
            end

            local sobrenome = rEVOLT.prompt(source, "Digite o sobrenome novo (Apenas letras, sem acentos, pontuação ou espaços)", "")
            if not sobrenome or sobrenome == "" then
                TriggerClientEvent("Notify", source, "negado", "Sobrenome não pode ser vazio.", 5)
                return cb(false)
            end

            sobrenome = sobrenome:gsub("^%s*(.-)%s*$", "%1")
            sobrenome = sobrenome:sub(1,1):upper() .. sobrenome:sub(2):lower()

            if not checkCaracteres(sobrenome) then
                TriggerClientEvent("Notify", source, "negado", "Sobrenome deve conter apenas letras (A-Z), sem acentos, espaços, números ou caracteres especiais.", 5)
                return cb(false)
            end

            if string.len(nome) < 3 or string.len(sobrenome) < 3 then
                TriggerClientEvent("Notify", source, "negado", "Nome e sobrenome devem ter ao menos 3 letras.", 5)
                return cb(false)
            end

            if not rEVOLT.request(source, "Tem certeza que deseja alterar o nome para <b>" .. nome .. " " .. sobrenome .. "</b> ?", 30) then
                return cb(false)
            end

            local identity = rEVOLT.getUserIdentity(user_id)
            if not identity then
                TriggerClientEvent("Notify", source, "negado", "Identidade não encontrada.", 5)
                return cb(false)
            end
            
            if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                rEVOLT._execute("rEVOLT/update_user_identity", {
                    user_id = user_id,
                    sobrenome = sobrenome,
                    nome = nome,
                    idade = identity.idade,
                    registro = identity.registro,
                    telefone = identity.telefone
                })
                rEVOLT.updateIdentity(user_id)
                TriggerClientEvent("Notify", source, "sucesso", "Você mudou o nome com sucesso. Aguarde até o próximo restart da cidade para a modificação ser aplicada.", 5)
                return cb(true)
            end

            return cb(false)
        end
    },

    ["ovodapascoa"] = {
        index = "ovodapascoa",
        name = "Ovo da Pascoa",
        png = "ovodapascoa",
        weight = 0.5,
        type = "use",
        func = function(user_id, source, item, slot, cb)
            if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                rEVOLTc._CarregarObjeto(source, "amb@world_human_clipboard@male@idle_a", "idle_c", "mah_lotus_pascoa", 49,
                    60309)

                TriggerClientEvent("progress", source, 15)
                SetTimeout(15 * 1000, function()
                    rEVOLTc._DeletarObjeto(source)
                    Remote._useBandagem(source, false)
                    TriggerClientEvent("Notify", source, "importante",
                        "Você comeu o ovo da pascoa, não tome nenhum tipo de dano para não ser cancelada.", 5)
                end)

                func:setCooldown(user_id, "inventario", 5)

                return cb(true)
            end
            return cb(false)
        end
    },

    ["tartaruga"] = {
        index = "tartaruga",
        name = "Tartaruga",
        png = "tartaruga",
        weight = 3.0,
        type = "use"
    },

    ["camisinha"] = {
        index = "camisinha",
        name = "Camisinha",
        png = "camisinha",
        weight = 0.05,
        type = "use"
    },

    ["tilapia"] = {
        index = "tilapia",
        name = "Tilapia",
        png = "tilapia",
        weight = 0.5,
        type = "use"
    },

    ["brincoroubado"] = {
        index = "brincoroubado",
        name = "Brinco",
        png = "brincoroubado",
        weight = 0.1,
        type = "use"
    },

    ["maconha"] = {
        index = "maconha",
        name = "Maconha",
        png = "maconha",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = OthersDrugs
    },

    ["coumadin"] = {
        index = "coumadin",
        name = "Coumadin",
        png = "coumadin",
        weight = 0.05,
        type = "use"
    },

    ["coumadin"] = {
        index = "coumadin",
        name = "Coumadin",
        png = "coumadin",
        weight = 0.05,
        type = "use",
    },

    ["luftal"] = {
        index = "luftal",
        name = "Luftal",
        png = "luftal",
        weight = 0.05,
        type = "use"
    },

    ["barrac"] = {
        index = "barrac",
        name = "Barra de chocolate",
        png = "barrac",
        weight = 0.5,
        type = "use"
    },

    ["cataflan"] = {
        index = "cataflan",
        name = "Cataflan",
        png = "cataflan",
        weight = 0.05,
        type = "use"
    },

    ["amoxilina"] = {
        index = "amoxilina",
        name = "Amoxilina",
        png = "amoxilina",
        weight = 0.05,
        type = "use"
    },

    ["flordelotus"] = {
        index = "flordelotus",
        name = "Flor de Lotus",
        png = "flordelotus",
        weight = 1.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                rEVOLTc._CarregarObjeto(source, "amb@world_human_clipboard@male@idle_a", "idle_c", "v_ret_ta_firstaid", 49,
                    60309)

                TriggerClientEvent("progress", source, 15)
                SetTimeout(15 * 1000, function()
                    rEVOLTc._DeletarObjeto(source)
                    Remote._useMedical(source, true)
                    TriggerClientEvent("Notify", source, "importante",
                        "Você utilizou a flor de lotus, não tome nenhum tipo de dano para não ser cancelada.", 5)
                end)
                func:setCooldown(user_id, "inventario", 5)

                return cb(true)
            end
            return cb(false)
        end
    },

    ["alianca"] = {
        index = "alianca",
        name = "Alianca",
        png = "alianca",
        weight = 1.0,
        type = "use"
    },

    ["ammo_militaryrifle"] = {
        index = "ammo_militaryrifle",
        name = "M-MilitaryRifle",
        png = "ammo_militaryrifle",
        weight = 0.05,
        type = "recharge"
    },

    ["absinto"] = {
        index = "absinto",
        name = "Absinto",
        png = "absinto",
        weight = 0.5,
        type = "use",
        func = Beber_Alcoolico
    },

    ["corote"] = {
        index = "corote",
        name = "Corote",
        png = "corote",
        weight = 0.5,
        type = "use",
        func = Beber_Alcoolico
    },

    ["weapon_golfclub"] = {
        index = "weapon_golfclub",
        name = "GolfClub",
        png = "weapon_golfclub",
        weight = 3.0,
        type = "equip"
    },

    ["metal"] = {
        index = "metal",
        name = "Placa de Metal",
        png = "metal",
        weight = 0.15,
        type = "use"
    },

    ["weapon_revolver_mk2"] = {
        index = "weapon_revolver_mk2",
        name = "Revolver",
        png = "weapon_revolver_mk2",
        weight = 3.0,
        type = "equip"
    },

    ["emptybottle"] = {
        index = "emptybottle",
        name = "Garrafa Vazia",
        png = "emptybottle",
        weight = 0.2,
        type = "use",
        func = function(user_id, source, item, slot, cb)
            local status, style = Remote.checkFountain(source)
            if status then
                if rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                    if style == "fountain" then
                        Remote._closeInventory(source)
                        rEVOLTc._playAnim(source, false,
                            { { "amb@prop_human_parking_meter@female@idle_a", "idle_a_female" } },
                            true)
                    elseif style == "floor" then
                        Remote._closeInventory(source)
                        rEVOLTc._playAnim(source, false, { { "amb@world_human_bum_wash@male@high@base", "base" } }, true)
                    end

                    TriggerClientEvent("progress", source, 10)
                    func:setBlockCommand(user_id, 10)
                    Wait(10000)
                    rEVOLT.giveInventoryItem(user_id, "water", 1, true)
                    rEVOLTc._stopAnim(source, false)
                end
            end
        end

    },

    ["ammo_assaultrifle_mk2"] = {
        index = "ammo_assaultrifle_mk2",
        name = "M-AK MK2",
        png = "ammo_assaultrifle_mk2",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_specialcarbine"] = {
        index = "ammo_specialcarbine",
        name = "M-Parafal",
        png = "ammo_specialcarbine",
        weight = 0.05,
        type = "recharge"
    },

    ["coxinha"] = {
        index = "coxinha",
        name = "Coxinha",
        png = "coxinha",
        weight = 0.5,
        type = "use"
    },

    ["rivotril"] = {
        index = "rivotril",
        name = "Rivotril",
        png = "rivotril",
        weight = 0.05,
        type = "use"
    },

    ["weapon_specialcarbine"] = {
        index = "weapon_specialcarbine",
        name = "G36",
        png = "weapon_specialcarbine",
        weight = 8.0,
        type = "equip"
    },

    ["pneus"] = {
        index = "pneus",
        name = "Pneus",
        png = "pneus",
        weight = 10.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if not rEVOLTc.isInVehicle(source) then
                local vehicle = rEVOLTc.getNearestVehicle(source, 7)
                local serverVehicle = getNearestPlayerVehicle(source, 7)
                if rEVOLT.tryGetInventoryItem(user_id, "pneus", 1, true, slot) then
                    rEVOLTc._playAnim(source, false,
                        { { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" } }, true)
                    TriggerClientEvent("progress", source, 10)
                    func:setBlockCommand(user_id, 15)
                    exports.revolt_player:addSeatCooldown(user_id, 15)
                    SetTimeout(10000, function()
                        if serverVehicle and DoesEntityExist(serverVehicle) then
                            local ownerId = NetworkGetEntityOwner(serverVehicle)
                            local vehicleNetId = NetworkGetNetworkIdFromEntity(serverVehicle)
                            TriggerClientEvent('syncrepararpneus', ownerId, vehicleNetId)
                        else
                            TriggerClientEvent('repararpneus', source, vehicle)
                        end

                        rEVOLTc._stopAnim(source, false)
                        TriggerClientEvent("Notify", source, "sucesso", "Você reparou o pneu do veiculo.", 5)
                    end)
                    return cb(true)
                end
            else
                TriggerClientEvent("Notify", source, "negado",
                    "Precisa estar próximo ou fora do veículo para efetuar os reparos.", 5)
            end
            return cb(false)
        end
    },

    ["martelinhodeouro"] = {
        index = "martelinhodeouro",
        name = "Martelinho de Ouro",
        png = "martelinhodeouro",
        weight = 10.0,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if not rEVOLTc.isInVehicle(source) then
                local vehicle = rEVOLTc.getNearestVehicle(source, 7)
                local serverVehicle = getNearestPlayerVehicle(source, 7)
                if rEVOLT.tryGetInventoryItem(user_id, "martelinhodeouro", 1, true, slot) then
                    rEVOLTc._playAnim(source, false, { { "mini@repair", "fixing_a_player" } }, true)
                    TriggerClientEvent("progress", source, 10)
                    func:setBlockCommand(user_id, 15)
                    exports.revolt_player:addSeatCooldown(user_id, 15)
                    SetTimeout(10000, function()
                        if serverVehicle and DoesEntityExist(serverVehicle) then
                            local ownerId = NetworkGetEntityOwner(serverVehicle)
                            local vehicleNetId = NetworkGetNetworkIdFromEntity(serverVehicle)
                            TriggerClientEvent('syncrepararlataria', ownerId, vehicleNetId)
                        else
                            TriggerClientEvent('repararlataria', source, vehicle)
                        end

                        rEVOLTc._stopAnim(source, false)
                        TriggerClientEvent("Notify", source, "sucesso", "Você reparou a lataria do veiculo.", 5)
                    end)
                    return cb(true)
                end
            else
                TriggerClientEvent("Notify", source, "negado",
                    "Precisa estar próximo ou fora do veículo para efetuar os reparos.", 5)
            end
            return cb(false)
        end
    },

    ["rubi"] = {
        index = "rubi",
        name = "Rubi",
        png = "rubi",
        weight = 1.0,
        type = "use"
    },

    ["ammo_pistol_mk2"] = {
        index = "ammo_pistol_mk2",
        name = "M-Five-Seven",
        png = "ammo_pistol_mk2",
        weight = 0.05,
        type = "recharge"
    },

    ["ammo_heavyrifle"] = {
        index = "ammo_heavyrifle",
        name = "M-Heavy Rifle",
        png = "ammo_heavyrifle",
        weight = 0.05,
        type = "recharge"
    },

    ["energetico"] = {
        index = "energetico",
        name = "Energetico",
        png = "energetico",
        weight = 0.25,
        type = "use",
        func = function(user_id, source, item, slot, cb)
            TriggerClientEvent("progress", source, 3)
            play_drink(source, item, 3)
            SetTimeout(3000, function()
                TriggerClientEvent("Notify", source, "sucesso", "Energetico utilizado com sucesso.", 5)
                Remote._setEnergetico(source, true)
                SetTimeout(15000, function()
                    TriggerClientEvent("Notify", source, "negado", "O Efeito do energetico acabou.", 5)
                    Remote._setEnergetico(source, false)
                end)
            end)
        end
    },

    ["adrenalina"] = {
        index = "adrenalina",
        name = "Adrenalina",
        png = "adrenalina",
        weight = 0.25,
        type = "use",
        func = function(user_id, source, item, slot, cb)
            local nplayer = rEVOLTc.getNearestPlayer(source, 2)
            if nplayer then
                local nuser_id = rEVOLT.getUserId(source)
                if GetEntityHealth(GetPlayerPed(nplayer)) > 101 then 
                    return cb(false)
                end
                
                local plyGroup = rEVOLT.getUserGroupByType(user_id, "org")
                
                if not plyGroup or plyGroup == '' then 
                    return cb(false)
                end
                
                local nplyGroup = rEVOLT.getUserGroupByType(nuser_id, "org")
                
                if not nplyGroup or nplyGroup == '' or nplyGroup ~= plyGroup then 
                    return cb(false)
                end

                local plyInDomination = GeralZone.inDomination(source)
                if plyInDomination then 
                    return cb(false)
                end
                
                rEVOLTc._playAnim(source, false,{{"mini@cpr@char_a@cpr_def","cpr_intro"}},true)
                SetTimeout(30*1000, function()  
                    print(9)
                    if GetEntityHealth(GetPlayerPed(nplayer)) > 101 then 
                        return cb(false)
                    end
                    rEVOLTc._stopAnim(source, false)
                    rEVOLTc._setHealth(nplayer, 110)
                    rEVOLTc._stopAnim(nplayer, false)
                    return cb(true)
                end)
                
            end
            TriggerClientEvent("Notify", source, "negado", "Nenhum jogador proximo.", 5)
            return cb(false)
        end
    },

    ["madeira"] = {
        index = "madeira",
        name = "Madeira",
        png = "madeira",
        weight = 2.5,
        type = "use"
    },

    ["dourado"] = {
        index = "dourado",
        name = "Dourado",
        png = "dourado",
        weight = 3.0,
        type = "use"
    },

    ["salmao"] = {
        index = "salmao",
        name = "Salmao",
        png = "salmao",
        weight = 1.0,
        type = "use"
    },

    ["podemd"] = {
        index = "podemd",
        name = "Pó de MD",
        png = "podemd",
        weight = 0.3,
        type = "use"
    },
    

    ["morfina"] = {
        index = "morfina",
        name = "Morfina",
        png = "morfina",
        weight = 0.3,
        type = "use"
    },

    ["anelroubado"] = {
        index = "anelroubado",
        name = "Anel",
        png = "anelroubado",
        weight = 0.1,
        type = "use"
    },

    ["lancaperfume"] = {
        index = "lancaperfume",
        name = "Lança Perfume",
        png = "lancaperfume",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = OthersDrugs
    },

    ["haxixe"] = {
        index = "haxixe",
        name = "Haxixe",
        png = "haxixe",
        weight = 0.5,
        type = "use"
    },

    ["compostoomega"] = {
        index = "compostoomega",
        name = "Composto Omega",
        png = "compostoomega",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local ped = GetPlayerPed(source)
            local health = GetEntityHealth(ped)

            if health < 300 then
                TriggerClientEvent("Notify", source, "negado", "Você não pode utilizar composto omega com vida baixa.", 5)
                return cb(false)
            end

            if not rEVOLT.tryGetInventoryItem(user_id, item, 1, true, slot) then
                return cb(false)
            end

            rEVOLTc._playAnim(source, true, { { "mp_player_int_uppersmoke", "mp_player_int_smoke" } }, true)

            SetTimeout(2000, function()
                rEVOLTc._stopAnim(source, false)
                health = GetEntityHealth(ped)

                if health < 300 then
                    TriggerClientEvent("Notify", source, "negado", "Você não pode utilizar composto omega com vida baixa.", 5)
                    return cb(false)
                end

                rEVOLTc._setHealth(source, 350)
                TriggerClientEvent("Notify", source, "sucesso", "Composto Omega utilizado com sucesso.", 5)
            end)
            
            return cb(true)
        end
    },

    ["m-tecido"] = {
        index = "m-tecido",
        name = "Tecido",
        png = "m-tecido",
        weight = 0.4,
        type = "use"
    },
    ["gatilho"] = {
        index = "gatilho",
        name = "Gatilho",
        png = "gatilho",
        weight = 0.2,
        type = "use"
    },

    ["m-corpo_ak47_mk2"] = {
        index = "m-corpo_ak47_mk2",
        name = "Corpo de AK47",
        png = "m-corpo_ak47_mk2",
        weight = 5.0,
        type = "use"
    },
    ["sucata"] = {
        index = "sucata",
        name = "Sucata",
        png = "sucata", 
        weight = 0.5,
        type = "use"
    },

    ["laptop"] = {
        index = "laptop",
        name = "Laptop",
        png = "laptop",
        weight = 1.0,
        type = "use"
    },

    ["perfumeroubado"] = {
        index = "perfumeroubado", 
        name = "Perfume",
        png = "perfumeroubado",
        weight = 0.3,
        type = "use"
    },

    ["carteiraroubada"] = {
        index = "carteiraroubada",
        name = "Carteira",
        png = "carteiraroubada",
        weight = 0.2,
        type = "use"
    },

    ["vibradorroubado"] = {
        index = "vibradorroubado",
        name = "Vibrador",
        png = "vibradorroubado",
        weight = 0.3,
        type = "use"
    },

    ["relogioroubado"] = {
        index = "relogioroubado",
        name = "Relógio",
        png = "relogioroubado",
        weight = 0.2,
        type = "use"
    },

    ["anelroubado"] = {
        index = "anelroubado",
        name = "Anel",
        png = "anelroubado",
        weight = 0.1,
        type = "use"
    },

    ["colarroubado"] = {
        index = "colarroubado",
        name = "Colar",
        png = "colarroubado",
        weight = 0.2,
        type = "use"
    },

    ["sapatosroubado"] = {
        index = "sapatosroubado",
        name = "Sapatos",
        png = "sapatosroubado",
        weight = 0.5,
        type = "use"
    },

    ["carregadorroubado"] = {
        index = "carregadorroubado",
        name = "Carregador",
        png = "carregadorroubado",
        weight = 0.3,
        type = "use"
    },

    ["brincoroubado"] = {
        index = "brincoroubado",
        name = "Brinco",
        png = "brincoroubado",
        weight = 0.1,
        type = "use"
    },

    ["tabletroubado"] = {
        index = "tabletroubado",
        name = "Tablet",
        png = "tabletroubado",
        weight = 0.8,
        type = "use"
    },

    ["militec"] = {
        index = "militec",
        name = "Militec",
        png = "militec",
        weight = 0.8,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            if not rEVOLTc.isInVehicle(source) then
                local vehicle = rEVOLTc.getNearestVehicle(source,3)
                local serverVehicle = getNearestPlayerVehicle(source, 7)
                if vehicle then
                    if rEVOLT.hasPermission(user_id,"mecanico.permissao") then
                        TriggerClientEvent('cancelando',source,true)
                        TriggerClientEvent("progress",source,10,"reparando motor")
                        rEVOLTc._playAnim(source,false,{"mini@repair","fixing_a_player"},true)
                        SetTimeout(10*1000, function()
                            TriggerClientEvent('cancelando',source,false)
                            rEVOLTc._stopAnim(source,false)

                            if serverVehicle and DoesEntityExist(serverVehicle) then
                                local ownerId = NetworkGetEntityOwner(serverVehicle)
                                local vehicleNetId = NetworkGetNetworkIdFromEntity(serverVehicle)
                                TriggerClientEvent('syncrepararmotor', ownerId, vehicleNetId)
                            else
                                TriggerClientEvent('repararmotor',source,vehicle)
                            end

                            Wait(3000)

                            exports.garage:saveVehicle(vnetid,source)
                        end)

                        
                        return cb(true)
                    else
                        if rEVOLT.tryGetInventoryItem(user_id,item,1,true,slot) then                                
                            TriggerClientEvent('cancelando',source,true)
                            TriggerClientEvent("progress",source,10,"reparando motor")
                            rEVOLTc._playAnim(source,false,{"mini@repair","fixing_a_player"},true)
                            SetTimeout(10*1000, function()
                                TriggerClientEvent('cancelando',source,false)
                                rEVOLTc._stopAnim(source,false)
                                
                                if serverVehicle and DoesEntityExist(serverVehicle) then
                                    local ownerId = NetworkGetEntityOwner(serverVehicle)
                                    local vehicleNetId = NetworkGetNetworkIdFromEntity(serverVehicle)
                                    TriggerClientEvent('syncrepararmotor', ownerId, vehicleNetId)
                                else
                                    TriggerClientEvent('repararmotor',source,vehicle)
                                end

                                Wait(3000)

                                exports.garage:saveVehicle(vnetid,source)
                            end)

                            return cb(true)
                        end
                    end
                end
            end

            return cb(false)
        end
    },

    ["tesoura"] = {
        index = "tesoura",
        name = "Tesoura",
        png = "tesoura",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local nplayer = rEVOLTc.getNearestPlayer(source, 3)
            if nplayer then
                local nuser_id = rEVOLT.getUserId(nplayer)
                if nuser_id then
                    if rEVOLT.tryGetInventoryItem(user_id, "tesoura", 1, true, slot) then
                        -- Animação do usuário da tesoura
                        rEVOLTc._playAnim(source, false, { { "taxi_hail", "hail_taxi" } }, true)
                        -- Animação da vítima
                        rEVOLTc._playAnim(nplayer, false, { { "missheistdockssetup1ig_10@base", "talk_pipe_base_worker1" } }, true)
                        
                        TriggerClientEvent("Notify", source, "sucesso", "Cortando o cabelo...", 3)
                        TriggerClientEvent("Notify", nplayer, "importante", "Alguém está cortando seu cabelo!", 3)
                        
                        SetTimeout(5000, function()
                            -- Para as animações
                            rEVOLTc._stopAnim(source, false)
                            rEVOLTc._stopAnim(nplayer, false)
                            
                            -- Remove o cabelo da vítima (define cabelo como careca)
                            TriggerClientEvent("tesoura:removerCabelo", nplayer)
                            
                            TriggerClientEvent("Notify", source, "sucesso", "Cabelo cortado com sucesso!", 5)
                            TriggerClientEvent("Notify", nplayer, "negado", "Seu cabelo foi cortado!", 5)
                        end)
                        
                        return cb(true)
                    else
                        TriggerClientEvent("Notify", source, "negado", "Você não possui uma tesoura.", 5)
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "Jogador inválido.", 5)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Nenhum jogador próximo.", 5)
            end
            return cb(false)
        end
    },

    ["tesoura_masc1"] = {
        index = "tesoura_masc1",
        name = "Tesoura Masculina Estilo 1",
        png = "tesoura",
        weight = 0.5,
        type = "use",
        keep_item = true,
        func = function(user_id, source, item, slot, cb)
            local nplayer = rEVOLTc.getNearestPlayer(source, 3)
            if nplayer then
                local nuser_id = rEVOLT.getUserId(nplayer)
                if nuser_id then
                    if rEVOLT.tryGetInventoryItem(user_id, "tesoura_masc1", 1, true, slot) then
                        rEVOLTc._playAnim(source, false, { { "amb@world_human_clipboard@male@idle_a", "idle_c" } }, true)
                        rEVOLTc._playAnim(nplayer, false, { { "missheistdockssetup1ig_10@base", "talk_pipe_base_worker1" } }, true)
                        
                        TriggerClientEvent("Notify", source, "sucesso", "Cortando o cabelo masculino...", 3)
                        TriggerClientEvent("Notify", nplayer, "importante", "Alguém está cortando seu cabelo!", 3)
                        
                        SetTimeout(5000, function()
                            rEVOLTc._stopAnim(source, false)
                            rEVOLTc._stopAnim(nplayer, false)
                            
                            TriggerClientEvent("tesoura:aplicarCabeloMasculino", nplayer)
                            
                            TriggerClientEvent("Notify", source, "sucesso", "Novo corte masculino aplicado!", 5)
                            TriggerClientEvent("Notify", nplayer, "sucesso", "Você ganhou um novo corte de cabelo!", 5)
                        end)
                        
                        return cb(true)
                    else
                        TriggerClientEvent("Notify", source, "negado", "Você não possui esta tesoura.", 5)
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "Jogador inválido.", 5)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Nenhum jogador próximo.", 5)
            end
            return cb(false)
        end
    },

    ["tesoura_masc2"] = {
        index = "tesoura_masc2",
        name = "Tesoura Masculina Estilo 2",
        png = "tesoura",
        weight = 0.5,
        type = "use",
        keep_item = true,

        func = function(user_id, source, item, slot, cb)
            local nplayer = rEVOLTc.getNearestPlayer(source, 3)
            if nplayer then
                local nuser_id = rEVOLT.getUserId(nplayer)
                if nuser_id then
                    if rEVOLT.tryGetInventoryItem(user_id, "tesoura_masc2", 1, true, slot) then
                        rEVOLTc._playAnim(source, false, { { "amb@world_human_clipboard@male@idle_a", "idle_c" } }, true)
                        rEVOLTc._playAnim(nplayer, false, { { "missheistdockssetup1ig_10@base", "talk_pipe_base_worker1" } }, true)
                        
                        TriggerClientEvent("Notify", source, "sucesso", "Cortando o cabelo masculino...", 3)
                        TriggerClientEvent("Notify", nplayer, "importante", "Alguém está cortando seu cabelo!", 3)
                        
                        SetTimeout(5000, function()
                            rEVOLTc._stopAnim(source, false)
                            rEVOLTc._stopAnim(nplayer, false)
                            
                            TriggerClientEvent("tesoura:aplicarCabeloMasculino", nplayer)
                            
                            TriggerClientEvent("Notify", source, "sucesso", "Novo corte masculino aplicado!", 5)
                            TriggerClientEvent("Notify", nplayer, "sucesso", "Você ganhou um novo corte de cabelo!", 5)
                        end)
                        
                        return cb(true)
                    else
                        TriggerClientEvent("Notify", source, "negado", "Você não possui esta tesoura.", 5)
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "Jogador inválido.", 5)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Nenhum jogador próximo.", 5)
            end
            return cb(false)
        end
    },

    ["tesoura_masc3"] = {
        index = "tesoura_masc3",
        name = "Tesoura Masculina Estilo 3",
        png = "tesoura",
        weight = 0.5,
        type = "use",
        keep_item = true,

        func = function(user_id, source, item, slot, cb)
            local nplayer = rEVOLTc.getNearestPlayer(source, 3)
            if nplayer then
                local nuser_id = rEVOLT.getUserId(nplayer)
                if nuser_id then
                    if rEVOLT.tryGetInventoryItem(user_id, "tesoura_masc3", 1, true, slot) then
                        rEVOLTc._playAnim(source, false, { { "amb@world_human_clipboard@male@idle_a", "idle_c" } }, true)
                        rEVOLTc._playAnim(nplayer, false, { { "missheistdockssetup1ig_10@base", "talk_pipe_base_worker1" } }, true)
                        
                        TriggerClientEvent("Notify", source, "sucesso", "Cortando o cabelo masculino...", 3)
                        TriggerClientEvent("Notify", nplayer, "importante", "Alguém está cortando seu cabelo!", 3)
                        
                        SetTimeout(5000, function()
                            rEVOLTc._stopAnim(source, false)
                            rEVOLTc._stopAnim(nplayer, false)
                            
                            TriggerClientEvent("tesoura:aplicarCabeloMasculino", nplayer)
                            
                            TriggerClientEvent("Notify", source, "sucesso", "Novo corte masculino aplicado!", 5)
                            TriggerClientEvent("Notify", nplayer, "sucesso", "Você ganhou um novo corte de cabelo!", 5)
                        end)
                        
                        return cb(true)
                    else
                        TriggerClientEvent("Notify", source, "negado", "Você não possui esta tesoura.", 5)
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "Jogador inválido.", 5)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Nenhum jogador próximo.", 5)
            end
            return cb(false)
        end
    },

    ["tesoura_fem1"] = {
        index = "tesoura_fem1",
        name = "Tesoura Feminina Estilo 1",
        png = "tesoura",
        weight = 0.5,
        type = "use",
        keep_item = true,

        func = function(user_id, source, item, slot, cb)
            local nplayer = rEVOLTc.getNearestPlayer(source, 3)
            if nplayer then
                local nuser_id = rEVOLT.getUserId(nplayer)
                if nuser_id then
                    if rEVOLT.tryGetInventoryItem(user_id, "tesoura_fem1", 1, true, slot) then
                        rEVOLTc._playAnim(source, false, { { "amb@world_human_clipboard@male@idle_a", "idle_c" } }, true)
                        rEVOLTc._playAnim(nplayer, false, { { "missheistdockssetup1ig_10@base", "talk_pipe_base_worker1" } }, true)
                        
                        TriggerClientEvent("Notify", source, "sucesso", "Cortando o cabelo feminino...", 3)
                        TriggerClientEvent("Notify", nplayer, "importante", "Alguém está cortando seu cabelo!", 3)
                        
                        SetTimeout(5000, function()
                            rEVOLTc._stopAnim(source, false)
                            rEVOLTc._stopAnim(nplayer, false)
                            
                            TriggerClientEvent("tesoura:aplicarCabeloFeminino", nplayer)
                            
                            TriggerClientEvent("Notify", source, "sucesso", "Novo corte feminino aplicado!", 5)
                            TriggerClientEvent("Notify", nplayer, "sucesso", "Você ganhou um novo corte de cabelo!", 5)
                        end)
                        
                        return cb(true)
                    else
                        TriggerClientEvent("Notify", source, "negado", "Você não possui esta tesoura.", 5)
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "Jogador inválido.", 5)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Nenhum jogador próximo.", 5)
            end
            return cb(false)
        end
    },

    ["tesoura_fem2"] = {
        index = "tesoura_fem2",
        name = "Tesoura Feminina Estilo 2",
        png = "tesoura",
        weight = 0.5,
        type = "use",
        keep_item = true,

        func = function(user_id, source, item, slot, cb)
            local nplayer = rEVOLTc.getNearestPlayer(source, 3)
            if nplayer then
                local nuser_id = rEVOLT.getUserId(nplayer)
                if nuser_id then
                    if rEVOLT.tryGetInventoryItem(user_id, "tesoura_fem2", 1, true, slot) then
                        rEVOLTc._playAnim(source, false, { { "amb@world_human_clipboard@male@idle_a", "idle_c" } }, true)
                        rEVOLTc._playAnim(nplayer, false, { { "missheistdockssetup1ig_10@base", "talk_pipe_base_worker1" } }, true)
                        
                        TriggerClientEvent("Notify", source, "sucesso", "Cortando o cabelo feminino...", 3)
                        TriggerClientEvent("Notify", nplayer, "importante", "Alguém está cortando seu cabelo!", 3)
                        
                        SetTimeout(5000, function()
                            rEVOLTc._stopAnim(source, false)
                            rEVOLTc._stopAnim(nplayer, false)
                            
                            TriggerClientEvent("tesoura:aplicarCabeloFeminino", nplayer)
                            
                            TriggerClientEvent("Notify", source, "sucesso", "Novo corte feminino aplicado!", 5)
                            TriggerClientEvent("Notify", nplayer, "sucesso", "Você ganhou um novo corte de cabelo!", 5)
                        end)
                        
                        return cb(true)
                    else
                        TriggerClientEvent("Notify", source, "negado", "Você não possui esta tesoura.", 5)
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "Jogador inválido.", 5)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Nenhum jogador próximo.", 5)
            end
            return cb(false)
        end
    },

    ["tesoura_fem3"] = {
        index = "tesoura_fem3",
        name = "Tesoura Feminina Estilo 3",
        png = "tesoura",
        weight = 0.5,
        type = "use",
        keep_item = true,

        func = function(user_id, source, item, slot, cb)
            local nplayer = rEVOLTc.getNearestPlayer(source, 3)
            if nplayer then
                local nuser_id = rEVOLT.getUserId(nplayer)
                if nuser_id then
                    if rEVOLT.tryGetInventoryItem(user_id, "tesoura_fem3", 1, true, slot) then
                        rEVOLTc._playAnim(source, false, { { "amb@world_human_clipboard@male@idle_a", "idle_c" } }, true)
                        rEVOLTc._playAnim(nplayer, false, { { "missheistdockssetup1ig_10@base", "talk_pipe_base_worker1" } }, true)
                        
                        TriggerClientEvent("Notify", source, "sucesso", "Cortando o cabelo feminino...", 3)
                        TriggerClientEvent("Notify", nplayer, "importante", "Alguém está cortando seu cabelo!", 3)
                        
                        SetTimeout(5000, function()
                            rEVOLTc._stopAnim(source, false)
                            rEVOLTc._stopAnim(nplayer, false)
                            
                            TriggerClientEvent("tesoura:aplicarCabeloFeminino", nplayer)
                            
                            TriggerClientEvent("Notify", source, "sucesso", "Novo corte feminino aplicado!", 5)
                            TriggerClientEvent("Notify", nplayer, "sucesso", "Você ganhou um novo corte de cabelo!", 5)
                        end)
                        
                        return cb(true)
                    else
                        TriggerClientEvent("Notify", source, "negado", "Você não possui esta tesoura.", 5)
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "Jogador inválido.", 5)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Nenhum jogador próximo.", 5)
            end
            return cb(false)
        end
    },
}

if IsDuplicityVersion() then
    RegisterCommand('rscuba', function(source, args)
        local user_id = rEVOLT.getUserId(source)
        if user_id then
            local ok = rEVOLT.request(source, "Você deseja retirar a sua scuba?", 30)
            if ok and (GetEntityHealth(GetPlayerPed(source)) > 105) then
                if Remote.checkScuba(source) then
                    Remote._setScuba(source, false)
                    TriggerClientEvent('cancelando', source, false)
                    TriggerClientEvent("Notify", source, "negado",
                        "Você retirou sua scuba, não conseguimos recuperar ela houve um vazamento.", 5)
                else
                    TriggerClientEvent("Notify", source, "negado", "Você não possui scuba equipada.", 5)
                end
            end
        end
    end)
end





local function resolveItemKey(item)
    if type(item) ~= "string" then return item end
    local base = item:match("^[^-]+") or item
    local candidates = { item, base, string.lower(item), string.lower(base), string.upper(base) }
    for _, key in ipairs(candidates) do
        if Items[key] then return key end
    end
    return nil
end

function itemBodyList(item)
    local key = resolveItemKey(item)
    if key then
        return Items[key]
    end
end

function itemIndexList(item)
    local key = resolveItemKey(item)
    if key then
        return Items[key].index
    end
end

exports("itemIndexList",itemIndexList)


function itemNameList(item)
    local key = resolveItemKey(item)
    if key then
        return Items[key].name
    end
end


function itemImageList(item)
    local key = resolveItemKey(item)
    if key then
        if Items[key].png then
            return Items[key].png
        end
        return Items[key].index
    end
end

function itemList(item)
    local key = resolveItemKey(item)
    if key then
        return Items[key].name
    end
    return "Deleted"
end

function itemTypeList(item)
    local key = resolveItemKey(item)
    if key then
        return Items[key].type
    end
end

function itemAmmoList(item)
    local key = resolveItemKey(item)
    if key then
        return Items[key].ammo
    end
end

function itemWeightList(item)
    local key = resolveItemKey(item)
    if key then
        return Items[key].weight
    end
    return 0
end


function formatNumber(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1-'):reverse())..right
end

function checkNumber(numero)
	local rows = rEVOLT.query("rEVOLT/getNumber", {telefone = numero} ) or nil
	if not rows[1] then
		return true
	end
end

if IsDuplicityVersion() then
    function getNearestPlayerVehicle(source, radius)
        local ped = GetPlayerPed(source)
        local cds = GetEntityCoords(ped)

        local nearestVehicle
        local nearestVehicleDistance

        for _, vehicle in pairs(GetAllVehicles()) do
            local vehicleCds = GetEntityCoords(vehicle)
            local distance = #(cds - vehicleCds)
            if not nearestVehicle or (distance <= radius and distance < nearestVehicleDistance) then
                nearestVehicle = vehicle
                nearestVehicleDistance = distance
            end
        end

        return nearestVehicle
    end
end