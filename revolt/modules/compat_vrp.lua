
Proxy.addInterface("vRP", rEVOLT)
Tunnel.bindInterface("vRP", trEVOLT)

local defaultFoodValues = {
    agua = { 0, 25 }, water = { 0, 25 }, coffee = { 2, 15 }, energetic = { 0, 20 }, energetico = { 0, 20 }, cola = { 0, 12 },
    apple = { 10, 0 }, bread = { 12, 0 }, sandwich = { 18, 0 }, hamburger = { 22, 0 }, chocolate = { 6, 0 }
}

function rEVOLT.getInventory(Passport)
    return rEVOLT.Inventory(Passport)
end

function rEVOLT.computeInvWeight(Passport)
    return rEVOLT.InventoryWeight(Passport)
end

function rEVOLT.getInventoryMaxWeight(Passport)
    return rEVOLT.GetWeight(Passport)
end

function rEVOLT.getItemWeight(Item)
    return itemWeight(Item)
end

function rEVOLT.getItemName(Item)
    return itemName(Item)
end

function rEVOLT.getItemType(Item)
    local split = SplitOne(Item)
    if string.sub(split,1,5) == "AMMO_" then return "recarregar" end
    local t = itemType(Item)
    if t == "Armamento" then return "equipar" end
    if t == "Usável" then return "usar" end
    return t and string.lower(t) or false
end

function rEVOLT.computeItemsWeight(items)
    local weight = 0.0
    for _,v in pairs(items or {}) do
        if v and v.item and v.amount then
            weight = weight + (itemWeight(v.item) * parseInt(v.amount))
            if itemChest(v.item) and v.data then
                for _,value in pairs(v.data) do
                    weight = weight + (itemWeight(value.item) * parseInt(value.amount))
                end
            end
        end
    end
    return weight
end

function rEVOLT.getItemInSlot(Passport, Item, Slot)
    return Slot
end

function rEVOLT.getMochilaAmount(Passport)
    local data = rEVOLT.UserData(Passport,"Backpack") or {}
    local count = 0
    for _ in pairs(data) do count = count + 1 end
    return count
end

function rEVOLT.addMochila(Passport)
    local data = rEVOLT.UserData(Passport,"Backpack") or {}
    if data.backpackg then return false end
    if data.backpackm then
        data.backpackg = true
        rEVOLT.SetWeight(Passport,5)
    elseif data.backpackp then
        data.backpackm = true
        rEVOLT.SetWeight(Passport,10)
    else
        data.backpackp = true
        rEVOLT.SetWeight(Passport,15)
    end
    rEVOLT.Query("playerdata/SetData",{ Passport = parseInt(Passport), dkey = "Backpack", dvalue = json.encode(data) })
    return true
end

function rEVOLT.getUserByRegistration(Plate)
    local consult = rEVOLT.PassportPlate(Plate)
    return consult and consult.Passport or nil
end

function rEVOLT.getUserGroupByType(Passport, Type)
    return rEVOLT.GetUserType(Passport, Type)
end

function rEVOLT.getVehicleName(Name)
    return VehicleName(Name)
end

function rEVOLT.vehicleChest(Name)
    return VehicleChest(Name)
end

function rEVOLT.HasGroup(Passport, Permission)
    return rEVOLT.HasGroup(Passport, Permission)
end

function rEVOLT.getSData(Key)
    return json.encode(rEVOLT.GetSrvData(Key, true))
end

function rEVOLT.setSData(Key, Value)
    local data = Value
    if type(Value) == "string" then
        local ok, decoded = pcall(json.decode, Value)
        if ok then data = decoded end
    end
    rEVOLT.SetSrvData(Key, data or {}, true)
end

function rEVOLT.giveMoney(Passport, Amount)
    return rEVOLT.GiveItem(Passport, "dollars", parseInt(Amount), true)
end

function rEVOLT.tryPayment(Passport, Amount)
    return rEVOLT.PaymentMoney(Passport, parseInt(Amount)) or rEVOLT.PaymentFull(Passport, parseInt(Amount), "Loja")
end

function rEVOLT.varyFome(Passport, Hunger, Thirst)
    Hunger = tonumber(Hunger) or 0
    Thirst = tonumber(Thirst) or 0
    if Hunger > 0 then rEVOLT.UpgradeHunger(Passport, Hunger) end
    if Hunger < 0 then rEVOLT.DowngradeHunger(Passport, math.abs(Hunger)) end
    if Thirst > 0 then rEVOLT.UpgradeThirst(Passport, Thirst) end
    if Thirst < 0 then rEVOLT.DowngradeThirst(Passport, math.abs(Thirst)) end
end

function rEVOLT.itemFood(Item)
    local key = string.lower(SplitOne(Item) or "")
    return table.unpack(defaultFoodValues[key] or { 10, 10 })
end

function rEVOLT.checkPatrulhamento(Passport)
    return rEVOLT.HasService(Passport, "Police") or rEVOLT.HasService(Passport, "Paramedic") or rEVOLT.HasService(Passport, "Mechanic")
end

function rEVOLT.setBanned(Passport, Status)
    if not Status then return true end
    local Source = rEVOLT.Source(Passport)
    if not Source then return false end
    local License = rEVOLT.Account(Passport)
    if License and License.license then
        rEVOLT.Query("banneds/InsertBanned", { license = License.license, time = 30 })
        return true
    end
    return false
end


-- Compatibilidade extra para scripts legados de inventário/vRP.
function rEVOLT.query(NameOrQuery, Params)
    return rEVOLT.Query(NameOrQuery, Params)
end

function rEVOLT.Execute(NameOrQuery, Params)
    local query = PreparedQueries and PreparedQueries[NameOrQuery] or NameOrQuery
    if type(query) ~= "string" then
        print("^1[rEVOLT.Execute] Query inválida: "..tostring(NameOrQuery).." | tipo recebido: "..type(query).."^0")
        return false
    end

    local ok, result = pcall(function()
        if string.find(string.upper(query), "^%s*SELECT") then
            return exports.oxmysql:query_async(query, Params or {})
        end
        return exports.oxmysql:update_async(query, Params or {})
    end)

    if not ok then
        print("^1[rEVOLT.Execute] oxmysql falhou em: "..tostring(NameOrQuery).." | erro: "..tostring(result).."^0")
        return false
    end

    return result
end

function rEVOLT.execute(NameOrQuery, Params)
    return rEVOLT.Execute(NameOrQuery, Params)
end

function rEVOLT.Passport(source)
    return rEVOLT.Passport(source)
end

function rEVOLT.getUserSource(Passport)
    return rEVOLT.Source(Passport)
end

function rEVOLT.Passportentity(Passport)
    return rEVOLT.Identity(Passport)
end

function rEVOLT.getUserDataTable(Passport)
    return rEVOLT.Datatable(Passport)
end

function rEVOLT.request(source, Title, Message)
    return rEVOLT.Request(source, Title, Message)
end

function rEVOLT.getInventoryItemAmount(Passport, Item)
    local data = rEVOLT.InventoryItemAmount(Passport, Item)
    if type(data) == "table" then
        return parseInt(data[1])
    end
    return parseInt(data or 0)
end

function rEVOLT.giveInventoryItem(Passport, Item, Amount, Notify, Slot)
    return rEVOLT.GiveItem(Passport, Item, Amount, Notify, Slot)
end

function rEVOLT.tryGetInventoryItem(Passport, Item, Amount, Notify, Slot)
    return rEVOLT.TakeItem(Passport, Item, Amount, Notify, Slot)
end

function rEVOLT.removeInventoryItem(Passport, Item, Amount, Notify)
    return rEVOLT.RemoveItem(Passport, Item, Amount, Notify)
end

function rEVOLT.getItemInSlot(Passport, Item, Slot)
    local Inventory = rEVOLT.Inventory(Passport)
    Item = tostring(Item or "")
    for k, v in pairs(Inventory) do
        if v and v.item and splitString(v.item, "-")[1] == splitString(Item, "-")[1] then
            return tonumber(k) or k
        end
    end
    return Slot
end

function rEVOLT.getAllItens()
    return setmetatable({}, {
        __index = function(self, key)
            if not key then return nil end
            local item = tostring(key)
            local info = {
                name = rEVOLT.getItemName(item) or item,
                weight = tonumber(rEVOLT.getItemWeight(item)) or 0.0,
                tipo = itemIndex(item) or item
            }
            rawset(self, key, info)
            return info
        end
    })
end
