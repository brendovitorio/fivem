---@param permission string
---@return boolean
function API.checkPermission(permission)
    local source = source
    local user_id = rEVOLT.getUserId(source)
    return rEVOLT.hasPermission(user_id, permission)
end

---@param store_index string
---@param item string
---@param amount number
---@param slot string
---@return table<string, string>
function API.shopAction(store_index, item, amount, slot)
    local source = source
    local user_id = rEVOLT.getUserId(source)

    local shopData = Shops[store_index]
    if shopData then
        if shopData.mode == "buy" then
            if not (rEVOLT.computeInvWeight(user_id) + rEVOLT.getItemWeight(item) * amount <= rEVOLT.getInventoryMaxWeight(user_id)) then
                return {
                    error = "Sem espaço suficiente!"
                }
            end

            if shopData.onlyWalletPayment then
                if not rEVOLT.tryPayment(user_id, shopData.items[item] * amount) then return { error =
                    "Você precisa ter dinheiro em mãos para comprar isso." } end
            else
                if not rEVOLT.tryFullPayment(user_id, shopData.items[item] * amount) then return { error =
                    "Dinheiro insuficiente" } end
            end
            rEVOLT.giveInventoryItem(user_id, item, amount, slot)
            return {
                notify = "Compra realizada com sucesso!",
                money = shopData.items[item] * amount
            }
        end
        if shopData.mode == "sell" then
            if rEVOLT.tryGetInventoryItem(user_id, item, amount, true, tostring(slot)) then
                rEVOLT.giveMoney(user_id, shopData.items[item] * amount)
                return {
                    notify = "Você recebeu R$" .. shopData.items[item] * amount,
                    money = shopData.items[item] * amount
                }
            else
                return {
                    error = "Você não tem o item à ser vendido!"
                }
            end
        end
    end
    return {
        error = "Loja indisponível"
    }
end

function addShop(id, coords, blip)
    if not coords.x then
        coords = vec3(tonumber(coords[1]), tonumber(coords[2]), tonumber(coords[3]))
    end

    Shops['Mercado'].coords[tostring(id)] = { coords = vec3(coords.x, coords.y, coords.z), blip = blip }
    Remote.addShop(-1, id, coords, blip)
end

function removeShop(id)
    Shops['Mercado'].coords[tostring(id)] = nil
    Remote.removeShop(-1, id)
end

function syncShopsWithPlayer(source)
    for id, data in pairs(Shops['Mercado'].coords) do
        if data.coords then
            local coords = data.coords
            local blip = data.blip
            Remote.addShop(source, id, coords, blip)
        end
    end
end

AddEventHandler('rEVOLT:playerSpawn', function(userId, source)
    syncShopsWithPlayer(source)
end)

exports('getShops', function()
    local shops = {}
    for id, data in pairs(Shops['Mercado'].coords) do
        if data.coords then
            table.insert(shops, {
                id = tonumber(id),
                coords = data.coords,
                blip = data.blip
            })
        end
    end
    table.sort(shops, function(a, b)
        return a.id < b.id
    end)
    return shops
end)

exports('addShop', function(coords, blip)
    if not coords.x then
        coords = vec3(tonumber(coords[1]), tonumber(coords[2]), tonumber(coords[3]))
    end
    local ok = DBExecute('shops/InsertLotusShop', { coords = json.encode(coords), blip = blip and 1 or 0 })
    if ok ~= false then
        local query = DBQuery('shops/GetLastLotusShop', {})
        if query and query[1] and query[1].id then
            addShop(query[1].id, coords, blip)
            return true, 'Loja adicionada com sucesso'
        end
    end
    return false, 'Falha ao adicionar a loja'
end)

exports('removeShop', function(id)
    local query = DBExecute('shops/DeleteLotusShop', { id = id })
    if query then
        removeShop(id)
        return true, 'Loja removida com sucesso'
    end
    return false, 'Falha ao remover a loja'
end)

CreateThread(function()
    DBExecute('shops/CreateLotusShops', {})
    Wait(250)

    local query = DBQuery('shops/GetLotusShops', {})
    if query and #query > 0 then
        for _, shop in ipairs(query) do
            local coords = json.decode(shop.coords)
            if type(coords) == "table" and coords[1] and coords[2] and coords[3] then
                coords = vec3(tonumber(coords[1]), tonumber(coords[2]), tonumber(coords[3]))
            end
            addShop(shop.id, coords, shop.blip)
            Wait(100)
        end
    elseif query and #query == 0 then
        for i = 1, #Shops['Mercado'].coords do
            local shop = Shops['Mercado'].coords[i]
            DBExecute('shops/InsertLotusShop', { coords = json.encode(vec3(shop.coords[1], shop.coords[2], shop.coords[3])), blip = shop.blip and 1 or 0 })
        end
    end
end)