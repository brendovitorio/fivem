
local function sdbg(tag, data)
    local ok, j = pcall(json.encode, data or {})
    print(('[revolt_org][SERVER][%s] %s'):format(tag, ok and j or tostring(data)))
end

local PREPARED = {}

local function dbPrepare(key, query)
    PREPARED[key] = query
end

local function _resolveQuery(keyOrQuery)
    return PREPARED[keyOrQuery] or keyOrQuery
end

local function dbQuery(keyOrQuery, params)
    local q = _resolveQuery(keyOrQuery)
    params = params or {}

    local ok, res = pcall(function()
        return exports.oxmysql:query_async(q, params)
    end)

    if ok and type(res) == "table" then
        return res
    end

    return {}
end

local function dbExecute(keyOrQuery, params)
    local q = _resolveQuery(keyOrQuery)
    params = params or {}

    local ok, res = pcall(function()
        return exports.oxmysql:execute_async(q, params)
    end)

    if ok then
        return res
    end

    return nil
end

-- PREPARES
dbPrepare("revolt_orgs/getChestLogs", "SELECT * FROM revolt_orgs_logs WHERE organization = @organization ORDER BY expire_at DESC LIMIT 150")
dbPrepare("revolt_orgs/addChestLog", "INSERT INTO revolt_orgs_logs (organization, user_id, role, name, description, date, expire_at) VALUES(@organization, @id, @role, @name, @message, @time, @expire_at)")

-- CACHE LOGS
local chestLogCache = {}
local chestLogCacheAdd = {}

-- TUNNELS
function RegisterTunnel.getChestLogs()
    local source = source
    local user_id = getUserId(source)
    local t = {}

    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    local tier = 999
    if Config and Config.Groups and Config.Groups[user.groupType] and Config.Groups[user.groupType].List and Config.Groups[user.groupType].List[user.group] then
        tier = tonumber(Config.Groups[user.groupType].List[user.group].tier) or 999
    end
    local ctx = Organizations.getContext and Organizations:getContext(source) or nil
    local isAdmin = ctx and ctx.isAdmin == true

    if (not isAdmin) and tier > 3 then return {} end

    -- Admin sempre pode ver logs
    if not isAdmin then
        local perms = Organizations.Permissions[user.groupType] and Organizations.Permissions[user.groupType][user.group] or {}
        if not (perms.leader or perms.logs_view) then return {} end
    end

    if chestLogCache[user.groupType] then
        t = chestLogCache[user.groupType]
        return t
    end

    local query = dbQuery('revolt_orgs/getChestLogs', { organization = user.groupType })
    for i = 1, #query do
        t[#t + 1] = {
            id = i,
            executor = query[i].name or ("#" .. tostring(query[i].user_id or "")),
            action = query[i].description or "",
            severity = "info",
            date = query[i].date or "",
            role = query[i].role or "",
            user_id = query[i].user_id
        }
    end

    chestLogCache[user.groupType] = t
    return t
end

-- EXPORTS
exports('addLogChest', function(user_id, action, item, amount)
    user_id = parseInt(user_id)

    local user = Organizations.Members[user_id]
    if not user then return end

    local identity = getUserIdentity(user_id)
    if not identity then return end

    local logEntry = {
        id = user_id,
        name = ('%s %s'):format(identity.name, identity.firstname),
        role = Config.Groups[user.groupType].List[user.group].prefix,
        message = ('%s %dx %s'):format(action == 'withdraw' and 'Retirou' or 'Guardou', amount, item),
        time = os.date('%d/%m/%Y %X'),
        expire_at = os.time() + (Config.Main.clearChestLogs * 86400)
    }


    if not chestLogCache[user.groupType] then
        chestLogCache[user.groupType] = {}
    end

    if not chestLogCacheAdd[user.groupType] then
        chestLogCacheAdd[user.groupType] = {}
    end

    table.insert(chestLogCache[user.groupType], logEntry)
    table.insert(chestLogCacheAdd[user.groupType], logEntry)
end)

-- SYNC DATABASE
local function syncChestLogsWithDatabase()
    for groupType, logs in pairs(chestLogCacheAdd) do
        print(json.encode(logs))
        for _, log in ipairs(logs) do
            log.organization = groupType
            dbExecute('revolt_orgs/addChestLog', log)
        end
        chestLogCacheAdd[groupType] = {}
    end
end

-- -- CREATE CACHE
-- local function createCache()
--     for _, user in pairs(Organizations.Members) do
--         local logs = dbQuery('revolt_orgs/getChestLogs', { organization = user.groupType })
--         if logs then
--             print(json.encode(logs))
--             chestLogCache[user.groupType] = logs
--             print(('^2[%s] ^0Logs puxada com sucesso.'):format(GetCurrentResourceName():upper()))
--         end
--     end
-- end

-- -- MAIN THREAD
-- CreateThread(function()
--     Wait(1000)
--     print(('^2[%s] ^0Puxando logs no banco de dados!'):format(GetCurrentResourceName():upper()))
--     createCache()
-- end)

-- SAVE CACHE ON STOP
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print(('^2[%s] ^0Salvando logs no banco de dados!'):format(GetCurrentResourceName():upper()))
        syncChestLogsWithDatabase()
    end
end)