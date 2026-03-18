Tunnel  = module("revolt","lib/Tunnel")
local RESOURCE_NAME <const> = GetCurrentResourceName()
local Proxy <const>         = module("revolt","lib/Proxy")
local Tools  <const>        = module("revolt","lib/Tools")

---@alias vector3 table

IdGen = Tools.newIDGenerator()
rEVOLT = Proxy.getInterface("rEVOLT")
local CoreClientTunnel = Tunnel.getInterface("rEVOLT")
rEVOLTc = setmetatable({}, { __index = CoreClientTunnel or {} })
local CloseListeners = {}

if IsDuplicityVersion() and not _G["API"] then 
    _G["API"] = {}
    Tunnel.bindInterface(RESOURCE_NAME,API)
    function API.emitCloseListeners()
        local source    = source
        local user_id   = rEVOLT.Passport(source)
        for i = 1,#CloseListeners do 
            CloseListeners[i](source, user_id)
        end
    end
end

Remote = Tunnel.getInterface(RESOURCE_NAME)


---@param source number | string
---@param notifyType "negado" | "sucesso" | "importante" | "veiculo" | "carro"
---@param message string
---@return any
_G["Notify"] = function(source, notifyType, message)
    return TriggerClientEvent("Notify", source, notifyType, message)
end

---@param players table
---@param member string
---@vararg ... unknown
_G["TriggerNearEvent"] = function(players, member, ...)
    for i = 1, #players do 
        Remote["_"..member](players[i], ...)
    end
end

_G["AddCloseListener"] = function(cb)
    table.insert(CloseListeners, cb)
end


local function _jsondecode(value, fallback)
    if type(value) == "table" then return value end
    if type(value) == "string" and value ~= "" then
        local ok, data = pcall(json.decode, value)
        if ok and data ~= nil then return data end
    end
    return fallback
end

if not rEVOLT.prepare and rEVOLT._Prepare then rEVOLT.prepare = rEVOLT._Prepare end
if not rEVOLT._execute then
    function rEVOLT._execute(nameOrQuery, params)
        if rEVOLT.Execute then return rEVOLT.Execute(nameOrQuery, params) end
        return rEVOLT.Query(nameOrQuery, params)
    end
end
if not rEVOLT.getSlotItem then
    function rEVOLT.getSlotItem(user_id, slot)
        local inv = (rEVOLT.getInventory and rEVOLT.getInventory(user_id)) or (rEVOLT.Inventory and rEVOLT.Inventory(user_id)) or {}
        return inv[tostring(slot)]
    end
end
if not rEVOLT.hasGroup then
    function rEVOLT.hasGroup(user_id, group)
        if rEVOLT.HasGroup then return rEVOLT.HasGroup(user_id, group) end
        if rEVOLT.hasPermission then return rEVOLT.hasPermission(user_id, group) end
        return false
    end
end
if not rEVOLT.computeChestWeight then
    function rEVOLT.computeChestWeight(items)
        if rEVOLT.computeItemsWeight then return rEVOLT.computeItemsWeight(items) end
        local weight = 0.0
        for _, v in pairs(items or {}) do
            if v and v.item and v.amount then
                local itemWeightValue = 0
                if rEVOLT.getItemWeight then itemWeightValue = tonumber(rEVOLT.getItemWeight(v.item)) or 0 end
                weight = weight + (itemWeightValue * (tonumber(v.amount) or 0))
            end
        end
        return weight
    end
end
if not rEVOLT.tryFullPayment then
    function rEVOLT.tryFullPayment(user_id, amount)
        if rEVOLT.PaymentFull then return rEVOLT.PaymentFull(user_id, amount, "Loja") end
        if rEVOLT.tryPayment then return rEVOLT.tryPayment(user_id, amount) end
        return false
    end
end
if not rEVOLT.getMakapoints then
    function rEVOLT.getMakapoints(user_id)
        local data = rEVOLT.UserData and rEVOLT.UserData(user_id, "Makapoints") or {}
        if type(data) == "number" then return data end
        if type(data) == "table" then return tonumber(data.amount or data.value or data.points or 0) or 0 end
        return tonumber(data) or 0
    end
end
if not rEVOLT.getUserGroupOrg then
    function rEVOLT.getUserGroupOrg(user_id)
        local data = rEVOLT.UserData and rEVOLT.UserData(user_id, "GroupOrg") or {}
        if type(data) == "table" then
            return data.name or data.org or data.group or false
        end
        return data or false
    end
end
if not rEVOLT.sendLog then
    function rEVOLT.sendLog(target, message)
        if type(target) == "string" and target:match("^https?://") then
            PerformHttpRequest(target, function() end, 'POST', json.encode({ content = tostring(message or '') }), { ['Content-Type'] = 'application/json' })
            return true
        end
        print(("[inventory][%s] %s"):format(tostring(target or 'log'), tostring(message or '')))
        return true
    end
end
rEVOLT._sendLog = rEVOLT._sendLog or rEVOLT.sendLog

function rEVOLT.getWeapons(user_id)
    local data = rEVOLT.UserData and rEVOLT.UserData(user_id, "Weapons") or {}
    return _jsondecode(data, {}) or {}
end

function rEVOLT.setWeapons(user_id, weapons)
    local payload = weapons or {}
    if rEVOLT.Query then
        rEVOLT.Query("playerdata/SetData", { Passport = parseInt(user_id), dkey = "Weapons", dvalue = json.encode(payload) })
    end
    return true
end

function rEVOLT.clearWeapons(user_id)
    local weapons = rEVOLT.getWeapons(user_id) or {}
    rEVOLT.setWeapons(user_id, {})
    local src = rEVOLT.getUserSource and rEVOLT.getUserSource(user_id)
    if src then
        Remote.giveWeapons(src, {}, true)
    end
    return weapons
end

function rEVOLT.swapSlot(user_id, from_slot, to_slot)
    local inv = (rEVOLT.getInventory and rEVOLT.getInventory(user_id)) or (rEVOLT.Inventory and rEVOLT.Inventory(user_id))
    if not inv then return false end
    from_slot = tostring(from_slot)
    to_slot = tostring(to_slot)
    inv[from_slot], inv[to_slot] = inv[to_slot], inv[from_slot]
    return true
end


local _inventoryCooldowns = {}

local function _cooldownKey(user_id, key)
    return tostring(user_id) .. ':' .. tostring(key)
end

function rEVOLT.getCooldown(user_id, key)
    local now = os.time()
    local expires = _inventoryCooldowns[_cooldownKey(user_id, key)] or 0
    local remaining = expires - now
    if remaining > 0 then
        return false, remaining
    end
    return true, 0
end

function rEVOLT.setCooldown(user_id, key, seconds)
    seconds = tonumber(seconds) or 0
    if seconds <= 0 then
        _inventoryCooldowns[_cooldownKey(user_id, key)] = nil
        return true
    end
    _inventoryCooldowns[_cooldownKey(user_id, key)] = os.time() + math.ceil(seconds)
    return true
end

function rEVOLT.setBlockCommand(user_id, seconds)
    return rEVOLT.setCooldown(user_id, 'blockcommand', seconds)
end

function rEVOLT.alertPolice(data)
    TriggerEvent('inventory:alertPolice', data)
    return true
end

function rEVOLTc.getNearestPlayer(source, radius)
    return Remote.getNearestPlayer(source, radius)
end
function rEVOLTc.isHandcuffed(source)
    return Remote.isHandcuffed(source)
end
function rEVOLTc.checkAnim(source)
    return Remote.checkAnim(source)
end
function rEVOLTc._playAnim(source, upper, seq, loop, ...)
    return Remote.playAnim(source, upper, seq, loop, ...)
end
function rEVOLTc.playAnim(source, upper, seq, loop, ...)
    return Remote.playAnim(source, upper, seq, loop, ...)
end
function rEVOLTc._stopAnim(source, upper)
    return Remote._stopAnim(source, upper)
end
function rEVOLTc._playSound(source, dict, name)
    return Remote._playSound(source, dict, name)
end
function rEVOLTc.giveWeapons(source, weapons, clearBefore)
    return Remote.giveWeapons(source, weapons, clearBefore)
end
function rEVOLTc.getWeapons(source)
    return Remote.getWeapons(source)
end

function rEVOLTc.getNearestVehicle(source, radius)
    if CoreClientTunnel and CoreClientTunnel.ClosestVehicle then
        return CoreClientTunnel.ClosestVehicle(source, radius)
    end
    return Remote.getNearestVehicle(source, radius)
end
function rEVOLTc.isInVehicle(source)
    return Remote.isInVehicle(source)
end
function rEVOLTc.getArmour(source)
    return Remote.getArmour(source)
end
function rEVOLTc.setArmour(source, amount)
    if CoreClientTunnel and CoreClientTunnel.setArmour then
        return CoreClientTunnel.setArmour(source, amount)
    end
    return Remote.setArmour(source, amount)
end
function rEVOLTc._setHealth(source, amount)
    if CoreClientTunnel and CoreClientTunnel.SetHealth then
        return CoreClientTunnel.SetHealth(source, amount)
    end
    return Remote._setHealth(source, amount)
end
function rEVOLTc.taskBar(source, time)
    return Remote.taskBar(source, time)
end
function rEVOLTc._CarregarObjeto(source, dict, anim, prop, flag, hand, ...)
    return Remote._CarregarObjeto(source, dict, anim, prop, flag, hand, ...)
end
function rEVOLTc._DeletarObjeto(source, mode)
    return Remote._DeletarObjeto(source, mode)
end
function rEVOLTc._playScreenEffect(source, name, duration)
    return Remote._playScreenEffect(source, name, duration)
end
function rEVOLTc._toggleHandcuff(source)
    return Remote._toggleHandcuff(source)
end
function rEVOLTc._setHandcuffed(source, status)
    return Remote._setHandcuffed(source, status)
end
function rEVOLTc.isCapuz(source)
    return Remote.isCapuz(source)
end
function rEVOLTc._setCapuz(source, status)
    return Remote._setCapuz(source, status)
end
function rEVOLTc.ModelName(source, radius)
    return Remote.ModelName(source, radius)
end




local function _normalizeItemKey(item)
    if type(item) ~= "string" then return item end
    local base = item:match("^[^-]+") or item
    if Items then
        return base
            or item
    end
    return base
end

function ResolveItemKey(item)
    if type(item) ~= "string" then return item end
    local base = item:match("^[^-]+") or item
    local candidates = { item, base, string.lower(item), string.lower(base), string.upper(base) }
    if not Items then return string.lower(base) end
    for _, key in ipairs(candidates) do
        if Items[key] then return key end
    end
    return string.lower(base)
end

function ResolveItemData(item)
    local key = ResolveItemKey(item)
    return key and Items and Items[key] or nil, key
end
local function _db_prepare(name, query)
    if not rEVOLT.prepare and rEVOLT._Prepare then rEVOLT.prepare = rEVOLT._Prepare end
    if rEVOLT.prepare then rEVOLT.prepare(name, query) end
end

function DBQuery(nameOrQuery, params)
    if rEVOLT.Query then return rEVOLT.Query(nameOrQuery, params or {}) end
    return {}
end

function DBExecute(nameOrQuery, params)
    if rEVOLT.Execute then return rEVOLT.Execute(nameOrQuery, params or {}) end
    if rEVOLT._execute then return rEVOLT._execute(nameOrQuery, params or {}) end
    return false
end

_db_prepare("inventory/GetInstagramAvatar", "SELECT avatarURL FROM smartphone_instagram WHERE user_id = @user_id LIMIT 1")
_db_prepare("inventory/GetInstagramAvatarByPassport", "SELECT avatarURL FROM smartphone_instagram WHERE user_id = @Passport LIMIT 1")
_db_prepare("chest/GetVehicleChestKeys", "SELECT dkey, dvalue FROM playerdata WHERE dkey LIKE @dkey")
_db_prepare("chest/GetHomeBau", "SELECT dvalue AS bau FROM entitydata WHERE dkey = @dkey LIMIT 1")
_db_prepare("chest/GetHomeBauByOwner", "SELECT dvalue AS bau FROM entitydata WHERE dkey = @dkey LIMIT 1")
_db_prepare("chest/UpdateHomeBauByOwner", "REPLACE INTO entitydata (dkey, dvalue) VALUES (@dkey, @bau)")
_db_prepare("chest/CreateLotusChests", [[CREATE TABLE IF NOT EXISTS lotus_chests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    weight INT NOT NULL,
    coords LONGTEXT NOT NULL,
    permission VARCHAR(255) NOT NULL
)]])
_db_prepare("chest/UpsertLotusChest", "INSERT INTO lotus_chests (name, weight, permission, coords) VALUES (@name, @weight, @permission, @coords) ON DUPLICATE KEY UPDATE weight = VALUES(weight), permission = VALUES(permission), coords = VALUES(coords)")
_db_prepare("chest/DeleteLotusChest", "DELETE FROM lotus_chests WHERE name = @name")
_db_prepare("chest/UpdateLotusChest", "UPDATE lotus_chests SET weight = @weight, coords = @coords WHERE name = @name")
_db_prepare("chest/UpdateLotusChestCoords", "UPDATE lotus_chests SET coords = @coords WHERE name = @name")
_db_prepare("chest/UpdateLotusChestWeight", "UPDATE lotus_chests SET weight = @weight WHERE name = @name")
_db_prepare("chest/GetLotusChests", "SELECT * FROM lotus_chests")
_db_prepare("shops/CreateLotusShops", [[CREATE TABLE IF NOT EXISTS lotus_shops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    coords LONGTEXT NOT NULL,
    blip BOOLEAN NOT NULL DEFAULT FALSE
)]])
_db_prepare("shops/InsertLotusShop", "INSERT INTO lotus_shops (coords, blip) VALUES (@coords, @blip)")
_db_prepare("shops/DeleteLotusShop", "DELETE FROM lotus_shops WHERE id = @id")
_db_prepare("shops/GetLotusShops", "SELECT * FROM lotus_shops")
_db_prepare("shops/GetLastLotusShop", "SELECT * FROM lotus_shops ORDER BY id DESC LIMIT 1")
_db_prepare("vehicles/GetByPlate", "SELECT * FROM vehicles WHERE plate = @placa LIMIT 1")
_db_prepare("vehicles/UpdatePlateByPlate", "UPDATE vehicles SET plate = @new_plate WHERE plate = @old_plate")
