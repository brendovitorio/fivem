-- local Chests = {}
local isChestsLoaded = false
local sourcesLoadedChests = {}

---@class ChestUtils
ChestUtils = {
    chests = {
        --[[
            "chest_name":
                actived: boolean
                alias?: string | nil
        ]]
    },
    users  = {},
}

---@param src number
---@param chest string
---@param status boolean
---@param alias? string | nil
---@param max_weight? number | nil
---@param type? string | nil
function ChestUtils:SetStatus(src, chest, status, alias, max_weight, type)
    if not src then
        self.chests[chest] = false
        return
    end
    if not status then
        if not self.chests[chest] then
            return
        end
        SaveChest(chest, self.chests[chest])
        self.chests[chest] = nil
        self.users[src] = nil
        return
    end
    self.chests[chest] = {
        user = src,
        actived = status,
        alias = alias,
        type = type,
        max_weight = max_weight
    }
    self.users[src] = ((status) and chest or nil)
end

---@param chest string
---@return boolean
function ChestUtils:IsOpened(chest)
    return (self.chests[chest] and self.chests[chest].actived)
end

---@param chest string
---@return int
function ChestUtils:SourceOpened(chest)
    return (self.chests[chest] and self.chests[chest].user)
end

---@param name string
---@param toggle boolean
---@return boolean
function ChestUtils:ClearChestActive(name, toggle)
    if not self.chests[name] then
        return false
    end

    self.chests[name].actived = toggle
    return true
end

---@return table
function ChestUtils:AllChestsActive()
    local chestsActive = {}

    for k, v in pairs(self.chests) do
        if v.actived then
            chestsActive[k] = v
        end
    end

    return chestsActive
end

---@param src number | string
---@return string | nil
function ChestUtils:GetChestById(src)
    return (self.users[src])
end

---@param chest string | nil
---@return number | nil
function ChestUtils:GetWeight(chest)
    return ((self.chests[chest]) and self.chests[chest].max_weight or nil)
end

---@param chest string
---@return string | nil
function ChestUtils:GetType(chest)
    return ((self.chests[chest]) and self.chests[chest].type or nil)
end

---@param chest string
---@return string | nil
function ChestUtils:GetAlias(chest)
    return ((self.chests[chest]) and self.chests[chest].alias or nil)
end

---@param chest string
---@return number | nil
function ChestUtils:GetOwner(chest)
    return ((self.chests[chest]) and self.chests[chest].user or nil)
end

AddEventHandler("playerDropped", function(reason)
    if ChestUtils.users[source] then
        if reason:find("Server shutting down") then
            return
        end
        ChestUtils:SetStatus(source, ChestUtils.users[source], false)
    end
end)

local CACHED_HASHS = {}
local ITEMS_CACHE <const> = {}
local USERS_BYPASS_VEHICLE = {}

function setBypassVehicle(user_id, vehicle)
    if not USERS_BYPASS_VEHICLE[vehicle] then
        USERS_BYPASS_VEHICLE[vehicle] = {}
    end
    USERS_BYPASS_VEHICLE[vehicle][user_id] = true
end

function isBypassVehicle(user_id, vehicle)
    return USERS_BYPASS_VEHICLE[vehicle] and USERS_BYPASS_VEHICLE[vehicle][user_id]
end

CreateThread(function()
    while GetResourceState("nova_garage") ~= "started" do Wait(0) end
    local listCar = exports["nova_garage"]:getListVehicles()
    for hash, data in pairs(listCar) do
        CACHED_HASHS[hash] = { spawn = data.model:lower(), name = data.name, trunk = data.trunk }
    end
    print("^2[INFO]^7 Carros carregados com sucesso!")
end)
rEVOLT.prepare("updateBau","REPLACE INTO entitydata (dkey, dvalue) VALUES (@dkey, @bau)") 

---@param chest string
---@param data table
function SaveChest(chest, data)
    local identifier = chest
    if chest:find("HOME") then
        local houseId = tostring(chest:gsub('HOME_', ''))
        if not houseId:find(':') then
            rEVOLT._execute("updateBau", { dkey = "HOME_BAU:" .. tostring(houseId), bau = json.encode(ITEMS_CACHE[chest]) })
        else
            local newHouseId, ownerId = tonumber(houseId:split(':')[1]), tonumber(houseId:split(':')[2])
            DBExecute('chest/UpdateHomeBauByOwner', { bau = json.encode(ITEMS_CACHE[chest]), dkey = 'HOME_BAU:' .. tostring(newHouseId) .. ':' .. tostring(ownerId) })
        end
    elseif chest:find("WAREHOUSES:") then
        rEVOLT.setSData(chest, json.encode(ITEMS_CACHE[chest]))
    else
        if data.type == "GROUP" then
            rEVOLT.setSData(chest, json.encode(ITEMS_CACHE[chest]))
        else
            identifier = data.alias
            rEVOLT.setSData(data.alias, json.encode(ITEMS_CACHE[identifier]))
        end
    end
    ITEMS_CACHE[identifier] = nil
end

local incomingRequests = {}

RegisterCommand('abrirpm', function(source, args)
    local user_id = rEVOLT.getUserId(source)
    if not user_id then return end

    local perms = {
		{ permType = 'perm', perm = 'developer.permissao' },
		{ permType = 'perm', perm = 'perm.resplog' },
		{ permType = 'group', perm = 'respilegallotusgroup@445' },
        { permType = 'group', perm = 'gestaolotusgroup@445' },
		{ permType = 'group', perm = 'resppolicialotusgroup@445' },
		{ permType = 'group', perm = 'resploglotusgroup@445' },
        { permType = 'group', perm = 'supervisorlotusgroup@445' },
	}

	local hasPermission = false
	for _, perm in ipairs(perms) do
		if perm.permType == 'perm' then
			if rEVOLT.hasPermission(user_id, perm.perm) then
				hasPermission = true
				break
			end
		elseif perm.permType == 'group' then
			if rEVOLT.hasGroup(user_id, perm.perm) then
				hasPermission = true
				break
			end
		end
	end

	if not hasPermission then 
		return
	end

    local TARGET_ID = rEVOLT.prompt(source, "Digite o ID do cidadão: ", "")
    if not TARGET_ID or TARGET_ID == "" then
        return
    end
    TARGET_ID = parseInt(TARGET_ID)
    local TARGET_IDENTITY = rEVOLT.getUserIdentity(TARGET_ID)

    if not TARGET_IDENTITY then
        TriggerClientEvent("Notify", source, "negado", "Id não encontrado.")
        return
    end

    local query = DBQuery('chest/GetVehicleChestKeys', { dkey = 'chest:u'..TARGET_ID..'veh_%' })
    if #query == 0 then
        TriggerClientEvent("Notify", source, "negado", "Porta malas não encontrado.")
        return
    end

    local vehicleList = ""
    for i = 1, #query do
        vehicleList = vehicleList.. query[i].dkey:gsub("chest:u"..TARGET_ID.."veh_", "")..", "
    end

    local promptCar = rEVOLT.prompt(source, "Escolha o veiculo do cidadão: ", vehicleList)
    if not promptCar or promptCar == "" then
        return
    end

    for i = 1, #query do
        if query[i].dkey == "chest:u"..TARGET_ID.."veh_"..promptCar then
            TriggerEvent('onSpawnVehicle', {
                name = promptCar,
                src = source
            })
            --staffRequests[source] = { user_id = TARGET_ID, vehicle = promptCar, entity = vehicle }
            rEVOLT.sendLog("abrirpm","STAFF ID "..user_id..' utilizou /abrirpm '..promptCar)
            TriggerClientEvent("openChestVehicle", source, {promptCar, TARGET_IDENTITY.registro:gsub(" ", "")})
            break
        end
    end

    return
end)


---@param type "VEHICLE" | "GROUP" | "HOUSE"
---@param network_id number | nil
---@param chest_name string | nil
---@return table<string, table | number> | false
function API.requireChest(type, network_id, chest_name)
    local source = source
    local user_id = rEVOLT.getUserId(source)
    if incomingRequests[user_id] then
        Notify(source, "negado", "Voce ja tem uma abertura pendente, aguarde alguns instantes para tentar novamente!")
        return
    end


    if user_id then
        if type == "VEHICLE" then
            local entity = NetworkGetEntityFromNetworkId(network_id)
            local vehname, plate

            if entity > 0 then
                plate = GetVehicleNumberPlateText(entity)
                vehname = GetEntityModel(entity)
            else
                local platetext, model, netid, carname = rEVOLTc.ModelName(source, 5.0)
                if netid then
                    entity = NetworkGetEntityFromNetworkId(network_id)
                    if entity > 0 then
                        plate = GetVehicleNumberPlateText(entity)
                        vehname = GetEntityModel(entity)
                    else
                        plate = platetext:gsub(" ", "")
                        vehname = GetHashKey(model)
                        entity = netid
                    end
                end
              
            end

            local vehicle_owner = rEVOLT.getUserByRegistration(plate)
            if not vehicle_owner then
                Notify(source, "negado", "Veículo de americano.")
                return false
            end

            local hasPermission = false

            local perms = {
                { permType = 'perm', perm = 'developer.permissao' },
                { permType = 'perm', perm = 'perm.respilegal' },
                { permType = 'perm', perm = 'perm.resplog' },
                { permType = 'group', perm = 'supervisorlotusgroup@445' },
            }
            
            for _, perm in ipairs(perms) do
                if perm.permType == 'perm' then
                    if rEVOLT.hasPermission(user_id, perm.perm) then
                        hasPermission = true
                        break
                    end
                elseif perm.permType == 'group' then
                    if rEVOLT.hasGroup(user_id, perm.perm) then
                        hasPermission = true
                        break
                    end
                end
            end

            if rEVOLT.hasPermission(user_id, 'perm.openchest') then
                local amount = rEVOLT.getInventoryItemAmount(user_id, 'weapon_crowbar')
                if amount > 0 then
                    hasPermission = true
                end
            end

            if (not hasPermission) then
                if not ((vehicle_owner == user_id) or rEVOLT.hasPermission(user_id, "policia.permissao") or isBypassVehicle(user_id, network_id)) then
                    local vehicle_owner_source = rEVOLT.getUserSource(vehicle_owner)
                    if not vehicle_owner_source then
                        Notify(source, "negado", "Não foi possível encontrar o dono do veiculo!")
                        return false
                    end
                    local identity = rEVOLT.getUserIdentity(user_id)
                    incomingRequests[user_id] = true
                    SetTimeout(15 * 1000, function()
                        incomingRequests[user_id] = nil
                    end)
                    Notify(source, "aviso", "Pedido de abertura enviada ao dono do veiculo!")
                    local request_owner = rEVOLT.request(vehicle_owner_source,
                        string.format("%s [%s] deseja abrir seu porta malas, aceita?",
                            identity.nome .. " " .. identity.sobrenome, user_id), 15)
                    if request_owner then
                        incomingRequests[user_id] = nil
                    else
                        Notify(source, "negado", "O dono do veiculo recusou a abertura!")
                        return false
                    end
                end
            end

            local vehicle_data = CACHED_HASHS[vehname]
            if not vehicle_data then
                Notify(source, "negado", "Veículo não cadastrado.")
                return false
            end

            local max_weight = vehicle_data.trunk
            chest_name = "chest:u" .. vehicle_owner .. "veh_" .. string.lower(vehicle_data.spawn)
            if ChestUtils:IsOpened("VEHICLE_" .. entity) then
                Notify(source, "negado", "Baú em uso no momento.")
                return false
            end

            if not DoesEntityExist(entity) then
                Notify(source, "negado", "Veículo não encontrado.")
                return false
            end

            ---@diagnostic disable-next-line: param-type-mismatch
            ChestUtils:SetStatus(source, "VEHICLE_" .. entity, true, chest_name, max_weight, type)

            local chestItems = json.decode(rEVOLT.getSData(chest_name)) or {}
            ITEMS_CACHE[chest_name] = chestItems
            local formatedItems = {}
            local itemCount = 0
            if chestItems then
                for k, v in pairs(chestItems) do
                    itemCount += 1
                    formatedItems[tostring(itemCount)] = { amount = v["amount"], item = k }
                end
            end


            return {
                inventory = formatedItems,
                weight = rEVOLT.computeChestWeight(chestItems),
                max_weight = max_weight,
            }
        elseif type == "GROUP" then
            local chest_config = Chests[chest_name]

            if not chest_config then
                error("invalid chest name " .. chest_name)
                return false
            end

            if chest_config.permission and not rEVOLT.hasPermission(user_id, chest_config.permission) and not rEVOLT.hasPermission(user_id, "developer.permissao") then
                Notify(source, "negado", "Você não tem permissão para acessar o baú " .. chest_name)
                return false
            end

            if ChestUtils:IsOpened("orgChest:" .. chest_name) then
                local plySource = ChestUtils:SourceOpened("orgChest:" .. chest_name)
                local plyPed = GetPlayerPed(plySource)

                if plyPed and #(GetEntityCoords(plyPed) - GetEntityCoords(GetPlayerPed(source))) <= 5 then
                    Notify(source, "negado", "Baú em uso no momento.")
                    return false
                end

                if plyPed > 0 then
                    Remote._sendNuiEvent(plySource, {
                        route = "CLOSE_INVENTORY",
                        ignoreRight = false
                    })
                end

                Wait(1000)
            end

            ---@diagnostic disable-next-line: param-type-mismatch
            ChestUtils:SetStatus(source, "orgChest:" .. chest_name, true, chest_name, chest_config.max_weight, type)
            local chestItems = json.decode(rEVOLT.getSData("orgChest:" .. chest_name)) or {}
            local formatedItems = {}
            local itemCount = 0
            if chestItems then
                for k, v in pairs(chestItems) do
                    itemCount += 1
                    formatedItems[tostring(itemCount)] = { amount = v["amount"], item = k }
                end
            end
            ITEMS_CACHE["orgChest:" .. chest_name] = chestItems


            return ({
                title = chest_name,
                inventory = formatedItems,
                weight = rEVOLT.computeChestWeight(chestItems),
                max_weight = chest_config.max_weight,
            })
        elseif type == "HOUSE" then
            local max_weight = network_id
            local houseId = tostring(chest_name)
            if ChestUtils:IsOpened("HOME_" .. houseId) then
                Notify(source, "negado", "Baú em uso no momento.")
                return false
            end
            ---@diagnostic disable-next-line: param-type-mismatch
            ChestUtils:SetStatus(source, "HOME_" .. houseId, true, nil, max_weight, type)
            local chestItems = {}
            if not houseId:find(':') then
                local rows = DBQuery('chest/GetHomeBau', { dkey = 'HOME_BAU:' .. tostring(houseId) })
                chestItems = json.decode(rows and rows[1] and rows[1].bau or '[]') or {}
            else
                local newHouseId, ownerId = houseId:split(':')[1], houseId:split(':')[2]
                local rows = DBQuery('chest/GetHomeBauByOwner', { dkey = 'HOME_BAU:' .. tostring(newHouseId) .. ':' .. tostring(ownerId) })
                chestItems = json.decode(rows and rows[1] and rows[1].bau or '[]') or {}
            end
            ITEMS_CACHE[chest_name] = chestItems
            local formatedItems = {}
            local itemCount = 0
            if chestItems then
                for k, v in pairs(chestItems) do
                    itemCount += 1
                    formatedItems[tostring(itemCount)] = { amount = v["amount"], item = k }
                end
            end
            ITEMS_CACHE["HOME_" .. houseId] = chestItems
            return ({
                inventory = formatedItems,
                weight = rEVOLT.computeChestWeight(chestItems),
                max_weight = max_weight,
            })
        elseif type == "WAREHOUSES" then
            local max_weight = network_id
            if ChestUtils:IsOpened("WAREHOUSES:" .. chest_name) then
                Notify(source, "negado", "Baú em uso no momento.")
                return false
            end
            ---@diagnostic disable-next-line: param-type-mismatch
            ChestUtils:SetStatus(source, "WAREHOUSES:" .. chest_name, true, nil, max_weight, type)
            local chestItems = json.decode(rEVOLT.getSData("WAREHOUSES:" .. chest_name)) or {}
            ITEMS_CACHE["WAREHOUSES:" .. chest_name] = chestItems
            local formatedItems = {}
            local itemCount = 0
            if chestItems then
                for k, v in pairs(chestItems) do
                    itemCount += 1
                    formatedItems[tostring(itemCount)] = { amount = v["amount"], item = k }
                end
            end
            ITEMS_CACHE["WAREHOUSES:" .. chest_name] = chestItems
            return ({
                inventory = formatedItems,
                weight = rEVOLT.computeChestWeight(chestItems),
                max_weight = max_weight,
            })
        else
            error("invalid type " .. type)
            return false
        end
    end
    return false
end

---@param slot string
---@param amount number
---@return boolean | table
function API.storeChestItem(slot, amount)
    local source = source
    local user_id = rEVOLT.getUserId(source)

    if user_id then
        local slot_data = rEVOLT.getSlotItem(user_id, slot)
        if not slot_data then
            return {
                error = "Re-abra o baú."
            }
        end

        if slot_data.item == "money" then
            return {
                error = "Voce nao pode guardar isto aqui!"
            }
        end
        if amount <= 0 then
            return {
                error = "Atividade suspeita!"
            }
        end
        amount = ((amount > slot_data.amount) and slot_data.amount or amount)

        local identity = rEVOLT.getUserIdentity(user_id)
        local chest_name = ChestUtils:GetChestById(source)
        local weight = ChestUtils:GetWeight(chest_name)
        local chest_type = ChestUtils:GetType(chest_name)
        if chest_name and chest_type ~= "GROUP" and ChestUtils:GetAlias(chest_name) then
            chest_name = ChestUtils:GetAlias(chest_name)
        end
        if chest_name then
            local chestItems = ITEMS_CACHE[chest_name]
            if not chestItems then
                print("ERRO GRAVE_INVENTARIO ", chest_name, chest_type)
            end
            if (tonumber(rEVOLT.computeChestWeight(chestItems)) + tonumber(((ResolveItemData(slot_data.item) and ResolveItemData(slot_data.item).weight or 0) * amount))) > tonumber(weight) then
                return {
                    error = "Baú cheio."
                }
            else
                if not rEVOLT.tryGetInventoryItem(user_id, slot_data.item, amount, slot) then
                    return {
                        error = "Item não disponível!"
                    }
                end
            end
            chestItems[slot_data.item] = chestItems[slot_data.item] or { amount = 0 }
            chestItems[slot_data.item].amount = chestItems[slot_data.item].amount + amount
            ITEMS_CACHE[chest_name] = chestItems

            if (chest_name):find "orgChest:" then 
                
                Webhook({ main = "chests", sub = string.gsub(chest_name, "orgChest:","") }, {}, "blue", "#"..user_id.." "..identity.nome.." "..identity.sobrenome, "Guardou "..amount.."x "..slot_data.item.." no baú.")
            end

            if (chest_name):find('veh_') then 
                exports["admin"]:generateLog({
                    category = "inventario",
                    room = "bau-carros",
                    user_id = user_id,
                    message = ( [[O USER_ID %s VEICULO %s ACOES %s]] ):format(user_id, chest_name,  "Guardou "..amount.."x "..slot_data.item)
                })
            end

            if (chest_name):find('HOME_') then 
                exports["admin"]:generateLog({
                    category = "inventario",
                    room = "bau-casas",
                    user_id = user_id,
                    message = ( [[O USER_ID %s CASA %s ACOES %s]] ):format(user_id, chest_name,  "Guardou "..amount.."x "..slot_data.item)
                })
            end

            if (chest_name):find('orgChest:') then 
                exports["admin"]:generateLog({
                    category = "inventario",
                    room = "bau",
                    user_id = user_id,
                    message = ( [[O USER_ID %s BAU %s ACOES %s]] ):format(user_id, chest_name,  "Guardou "..amount.."x "..slot_data.item)
                })
            end

            return true
        end
    end
    return false
end


---@param item string
---@param amount number
---@return boolean | table
function API.takeChestItem(item, amount, slot)
    local source = source
    local user_id = rEVOLT.getUserId(source)
    if user_id then
        if amount <= 0 then
            return {
                error = "Atividade suspeita!"
            }
        end
        local chest_name = ChestUtils:GetChestById(source)
        local chest_type = ChestUtils:GetType(chest_name)
        if chest_type == "VEHICLE" then
            local entity_str = chest_name:gsub("VEHICLE_", "")
            local entity = tonumber(entity_str)
            local ped = GetPlayerPed(source)
            if not IsEntityVisible(ped) then
                return false
            end
            if entity and entity > 0 and DoesEntityExist(entity) then
                local player_cds = GetEntityCoords(ped)
                local entity_cds = GetEntityCoords(entity)
                if #(player_cds - entity_cds) > 10.0 then
                    return false
                end
            end
        end
        if chest_name and chest_type ~= "GROUP" and ChestUtils:GetAlias(chest_name) then
            chest_name = ChestUtils:GetAlias(chest_name)
        end
        if chest_name then
            local identity = rEVOLT.getUserIdentity(user_id)


            if rEVOLT.computeInvWeight(user_id) + ((ResolveItemData(item) and ResolveItemData(item).weight or 0) * amount) > rEVOLT.getInventoryMaxWeight(user_id) then
                return {
                    error = "Espaço insuficiente na mochila."
                }
            end
            local chestItems = ITEMS_CACHE[chest_name]
            if not chestItems[item] then
                return false
            end
            amount = ((amount > chestItems[item].amount) and chestItems[item].amount or amount)
            if amount == chestItems[item].amount then
                chestItems[item] = nil
            else
                chestItems[item].amount -= amount
            end
            ITEMS_CACHE[chest_name] = chestItems
            rEVOLT.giveInventoryItem(user_id, item, amount, slot)

            if (chest_name):find "orgChest:" then 
                Webhook({main = "chests", sub = string.gsub(chest_name, "orgChest:","") }, {},"blue", "#"..user_id.." "..identity.nome.." "..identity.sobrenome, "Retirou "..amount.."x "..item.." do baú.")  
            end

            if (chest_name):find('veh_') then 
                exports["admin"]:generateLog({
                    category = "inventario",
                    room = "bau-carros",
                    user_id = user_id,
                    message = ( [[O USER_ID %s VEICULO %s ACOES %s]] ):format(user_id, chest_name,  "Retirou "..amount.."x "..item)
                })
            end

            if (chest_name):find('HOME_') then 
                exports["admin"]:generateLog({
                    category = "inventario",
                    room = "bau-casas",
                    user_id = user_id,
                    message = ( [[O USER_ID %s CASA %s ACOES %s]] ):format(user_id, chest_name,  "Retirou "..amount.."x "..item)
                })
            end

            if (chest_name):find('orgChest:') then 
                exports["admin"]:generateLog({
                    category = "inventario",
                    room = "bau",
                    user_id = user_id,
                    message = ( [[O USER_ID %s BAU %s ACOES %s]] ):format(user_id, chest_name,  "Retirou "..amount.."x "..item)
                })
            end

            return true
        else
            return {
                error = "Baú não encontrado!"
            }
        end
    end
    return {
        error = "Erro desconhecido"
    }
end

AddCloseListener(function(src, user_id)
    local chest_name = ChestUtils:GetChestById(src)
    if chest_name then
        ChestUtils:SetStatus(src, chest_name, false)
        TriggerClientEvent("clearAnims", src)
    end
end)

AddEventHandler("entityRemoved", function(entity)
    if ChestUtils:IsOpened("VEHICLE_" .. entity) then
        local user = ChestUtils:GetOwner("VEHICLE_" .. entity)
        ChestUtils:SetStatus(user, "VEHICLE_" .. entity, false)
        TriggerClientEvent("clearAnims", user)
        Remote._sendNuiEvent(user, {
            route = "CLOSE_INVENTORY",
            ignoreRight = true
        })
    end
end)

RegisterCommand('baufacadm', function(source,args)
	local user_id = rEVOLT.getUserId(source)
	if not user_id then return end
    if rEVOLT.hasPermission(user_id, "developer.permissao") or rEVOLT.hasPermission(user_id,"perm.resplog") or rEVOLT.hasGroup(user_id,'respilegallotusgroup@445') or rEVOLT.hasGroup(user_id,'gestaolotusgroup@445') then
        local t = ""
        for i in pairs(Chests) do
            t = t.. i..", "
        end
    
        local promptOrg = rEVOLT.prompt(source, "Escolha a Fac: ", t)
        if not promptOrg or promptOrg == "" then
            return
        end
    
        for i in pairs(Chests) do
            if i == promptOrg then
                staffRequests[source] = { user_id = user_id, org = promptOrg }
                TriggerClientEvent('openChestGroup', source, promptOrg)
                rEVOLT.sendLog("baufacadm","STAFF ID "..user_id..' utilizou /baufacadm '..promptOrg)
                return
            end
        end
    
        TriggerClientEvent( "Notify", source, "negado", "Bau de facção não encontrado...", 5 )
        return	
    end
end)

function addChest(chestName, chestData)
    Chests[chestName] = chestData
    Remote.addChest(-1, chestName, chestData)
end

function removeChest(chestName)
    Chests[chestName] = nil
    Remote.removeChest(-1, chestName)
end

function syncChestsWithPlayer(source)
    for chestName, chestData in pairs(Chests) do
        if chestName and chestData then
            Remote.addChest(source, chestName, chestData)
        else
            local userId = rEVOLT.getUserId(source)
            local mensagem = string.format(
                "**[Cidade Alta] Erro na Sincronização de Baú**\n🆔 **User ID:** %d\n📦 **Baú:** %s\n⚠️ **Status:** Não configurado corretamente!\n\n<@694665184815349821>",
                (userId and userId or source), chestName and chestName or "Não identificado"
            )
            print("[Cidade Alta] [ERRO] Baú não configurado:", chestName and chestName or "Não identificado")
            rEVOLT.sendLog('https://discord.com/api/webhooks/1339636779170664539/32JQr2ZzMSKVGUUqKAyYvN5FG0nswin2Fw7Ql7u-0QifHSX_wyPbRKB6YnMRdZtwDtsv', mensagem)
        end
    end
end

exports('getChests', function()
    local chests = {}
    for k, v in pairs(Chests) do
        table.insert(chests, {
            name = k,
            weight = v.max_weight,
            permission = v.permission,
            coords = v.coords
        })
    end

    local function getRolePriority(name)
        if name:match("^Lider%-") then
            return 1
        elseif name:match("^Gerente%-") then
            return 2
        else
            return 3
        end
    end

    table.sort(chests, function(a, b)
        local priorityA = getRolePriority(a.name)
        local priorityB = getRolePriority(b.name)

        if priorityA == priorityB then
            return a.name < b.name
        else
            return priorityA < priorityB
        end
    end)

    return chests
end)


exports('addChest', function(name, weight, permission, coords)
    if Chests[name] then
        return false, 'Baú já existe'
    end

    Chests[name] = {
        max_weight = weight,
        permission = permission,
        coords = coords
    }

    addChest(name, {
        coords = coords,
        permission = permission,
        max_weight = weight
    }) 

    DBExecute('chest/UpsertLotusChest', { name = name, weight = weight, permission = permission, coords = json.encode(coords) })
    return true, 'Baú adicionado com sucesso'
end)

exports('removeChest', function(name)
    if not Chests[name] then
        return false, 'Baú não existe'
    end

    Chests[name] = nil
    removeChest(name)
    DBExecute('chest/DeleteLotusChest', { name = name })
    return true, 'Baú removido com sucesso'
end)

exports('updateChest', function(name, weight, coords)
    if not Chests[name] then
        return false, 'Baú não existe'
    end

    Chests[name].max_weight = weight
    Chests[name].coords = coords

    addChest(name, Chests[name])
    DBExecute('chest/UpdateLotusChest', { weight = weight, coords = json.encode(coords), name = name })
    return true, 'Baú atualizado com sucesso'
end)

exports('updateChestCoords', function(name, coords)
    if not Chests[name] then
        return false, 'Baú não existe'
    end

    Chests[name].coords = coords
    addChest(name, Chests[name])
    DBExecute('chest/UpdateLotusChestCoords', { coords = json.encode(coords), name = name })
    return true, 'Coordenadas do baú atualizadas com sucesso'
end)

exports('updateChestWeight', function(name, weight)
    if not Chests[name] then
        return false, 'Baú não existe'
    end

    Chests[name].max_weight = weight
    addChest(name, Chests[name])
    DBExecute('chest/UpdateLotusChestWeight', { weight = weight, name = name })
    return true, 'Peso do baú atualizado com sucesso'
end)

AddEventHandler('rEVOLT:playerSpawn', function(userId, source)
    while not isChestsLoaded do
        Wait(1000)
    end
    sourcesLoadedChests[source] = true
    syncChestsWithPlayer(source)
end)

CreateThread(function()
    DBExecute('chest/CreateLotusChests', {})
    Wait(250)

    local query = DBQuery('chest/GetLotusChests', {})
    if query and #query > 0 then
        for _, chest in ipairs(query) do
            if not Chests[chest.name] then
                local coords = json.decode(chest.coords)
                addChest(chest.name, {
                    coords = vec3(coords.x, coords.y, coords.z),
                    permission = chest.permission,
                    max_weight = chest.weight
                }) 
            end
            Wait(100)
        end
    end

    isChestsLoaded = true
    print("^2[INFO]^7 Báus carregados com sucesso!")

    -- for name, data in pairs(Chests) do
    --     exports.oxmysql:execute('INSERT IGNORE INTO lotus_chests (name, weight, permission, coords) VALUES (?, ?, ?, ?)', { name, data.max_weight, data.permission, json.encode(data.coords) })
    -- end
end)

local debugBauCooldown = {}

RegisterCommand('debugbau', function(source, args)
    if debugBauCooldown[source] and debugBauCooldown[source] > os.time() then
        TriggerClientEvent('Notify', source, 'aviso', 'Aguarde '..(debugBauCooldown[source] - os.time())..' segundos para utilizar esse comando novamente.', 5000)
        return
    end

    debugBauCooldown[source] = os.time() + 30

    while not isChestsLoaded do
        Wait(1000)
    end

    TriggerClientEvent('Notify', source, 'aviso', 'Aguarde, os báus estão sendo recarregados...', 5000)
    syncChestsWithPlayer(source)
    TriggerClientEvent('Notify', source, 'sucesso', 'Aguarde, Baus adicionados com sucesso!', 5000)
end)

function API.debugBau()
    local source = source
    local userId = rEVOLT.getUserId(source)
    while not isChestsLoaded do
        Wait(1000)
    end

    if not sourcesLoadedChests[source] then
        rEVOLT.sendLog('https://discord.com/api/webhooks/1339636779170664539/32JQr2ZzMSKVGUUqKAyYvN5FG0nswin2Fw7Ql7u-0QifHSX_wyPbRKB6YnMRdZtwDtsv', 
            'JOGADOR '..userId..' NÃO CARREGOU OS BAUS PELO EVENTO rEVOLT:playerSpawn'
        )
    else
        rEVOLT.sendLog('https://discord.com/api/webhooks/1339636779170664539/32JQr2ZzMSKVGUUqKAyYvN5FG0nswin2Fw7Ql7u-0QifHSX_wyPbRKB6YnMRdZtwDtsv', 
            'JOGADOR '..userId..' CARREGOU OS BAUS PELO EVENTO rEVOLT:playerSpawn MAS FOI NECESSARIO RECARREGAR'
        )
    end

    syncChestsWithPlayer(source)
end