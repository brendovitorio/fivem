local Proxy = module('revolt','lib/Proxy')
local Tunnel = module('revolt','lib/Tunnel')

FRAMEWORK = FRAMEWORK or {}
FRAMEWORK.server = FRAMEWORK.server or {}
FRAMEWORK.server.name = 'revolt'
FRAMEWORK.server.core = Proxy.getInterface('rEVOLT')

local core = FRAMEWORK.server.core

local SQL_GET_USER_GROUP = "SELECT dvalue FROM playerdata WHERE dkey = 'datatable' AND Passport = ? LIMIT 1"
local SQL_UPDATE_USER_GROUP = "UPDATE playerdata SET dvalue = ? WHERE Passport = ? AND dkey = 'datatable'"

local function normalizeUserId(user_id)
    return tonumber(user_id)
end

function FRAMEWORK.server.getCore()
    return core
end

function FRAMEWORK.server.getUserId(source)
    if core and core.Passport then
        return core.Passport(source)
    end
    return nil
end

function FRAMEWORK.server.getUserSource(user_id)
    user_id = normalizeUserId(user_id)
    if core and core.Source then
        return core.Source(user_id)
    end
    return nil
end

function FRAMEWORK.server.getUsers()
    if core and core.Players then
        return core.Players()
    end
    if core and core.getUsers then
        return core.getUsers()
    end
    return {}
end

function FRAMEWORK.server.getUserIdentity(user_id)
    user_id = normalizeUserId(user_id)
    if not user_id or not core or not core.Passportentity then
        return nil
    end
    local identity = core.Passportentity(user_id)
    if not identity then
        return nil
    end
    if identity.nome then
        identity.name = identity.nome
        identity.firstname = identity.sobrenome
    end
    if identity.name2 then
        identity.firstname = identity.name2
    end
    return identity
end

function FRAMEWORK.server.getUserGroups(user_id)
    user_id = normalizeUserId(user_id)
    if not user_id then
        return nil
    end
    local rows = exports.oxmysql:query_async(SQL_GET_USER_GROUP, { user_id })
    if type(rows) ~= 'table' or not rows[1] or not rows[1].dvalue then
        return nil
    end
    local ok, decoded = pcall(json.decode, rows[1].dvalue)
    local data = ok and decoded or {}
    return type(data) == 'table' and data.groups or nil
end

function FRAMEWORK.server.updateUserGroups(user_id, groups)
    user_id = normalizeUserId(user_id)
    if not user_id then
        return false
    end
    local rows = exports.oxmysql:query_async(SQL_GET_USER_GROUP, { user_id })
    if type(rows) ~= 'table' or not rows[1] or not rows[1].dvalue then
        return false
    end
    local ok, decoded = pcall(json.decode, rows[1].dvalue)
    local data = ok and decoded or {}
    data.groups = groups or {}
    exports.oxmysql:execute_async(SQL_UPDATE_USER_GROUP, { json.encode(data), user_id })
    return true
end

function FRAMEWORK.server.getUserMyGroups(user_id)
    local groups = FRAMEWORK.server.getUserGroups(user_id)
    if groups then
        return groups
    end
    if core and core.getUserGroups then
        return core.getUserGroups(user_id)
    end
    return nil
end

function FRAMEWORK.server.hasGroup(user_id, group)
    user_id = normalizeUserId(user_id)
    group = tostring(group or '')
    if not user_id or group == '' then
        return false
    end
    if core and core.Datatable then
        local dt = core.Datatable(user_id)
        if dt and type(dt.groups) == 'table' then
            return dt.groups[group] == true
        end
    end
    local groups = FRAMEWORK.server.getUserGroups(user_id)
    return type(groups) == 'table' and groups[group] == true or false
end

function FRAMEWORK.server.addUserGroup(user_id, group)
    user_id = normalizeUserId(user_id)
    group = tostring(group or '')
    if not user_id or group == '' then
        return false
    end
    local groups = FRAMEWORK.server.getUserGroups(user_id) or {}
    if Config and Config.Groups then
        for _, orgCfg in pairs(Config.Groups) do
            if orgCfg and orgCfg.List and orgCfg.List[group] then
                for gname in pairs(orgCfg.List) do
                    groups[gname] = nil
                end
                break
            end
        end
    end
    groups[group] = true
    FRAMEWORK.server.updateUserGroups(user_id, groups)
    if core and core.Datatable then
        local dt = core.Datatable(user_id)
        if dt then
            dt.groups = type(dt.groups) == 'table' and dt.groups or {}
            if Config and Config.Groups then
                for _, orgCfg in pairs(Config.Groups) do
                    if orgCfg and orgCfg.List and orgCfg.List[group] then
                        for gname in pairs(orgCfg.List) do
                            dt.groups[gname] = nil
                        end
                        break
                    end
                end
            end
            dt.groups[group] = true
        end
    end
    return true
end

function FRAMEWORK.server.removeUserGroup(user_id, group)
    user_id = normalizeUserId(user_id)
    group = tostring(group or '')
    if not user_id or group == '' then
        return false
    end
    local groups = FRAMEWORK.server.getUserGroups(user_id) or {}
    groups[group] = nil
    FRAMEWORK.server.updateUserGroups(user_id, groups)
    if core and core.Datatable then
        local dt = core.Datatable(user_id)
        if dt and type(dt.groups) == 'table' then
            dt.groups[group] = nil
        end
    end
    return true
end

function FRAMEWORK.server.getBankMoney(user_id)
    user_id = normalizeUserId(user_id)
    if not user_id or not core then
        return 0
    end
    local src = FRAMEWORK.server.getUserSource(user_id)
    if src and core.GetBank then
        return core.GetBank(src) or 0
    end
    if core.getBankMoney then
        return core.getBankMoney(user_id) or 0
    end
    return 0
end

function FRAMEWORK.server.tryFullPayment(user_id, amount)
    if core and core.PaymentBank then
        return core.PaymentBank(user_id, amount)
    end
    if core and core.tryFullPayment then
        return core.tryFullPayment(user_id, amount)
    end
    return false
end

function FRAMEWORK.server.giveBankMoney(user_id, amount)
    if core and core.GiveBank then
        return core.GiveBank(user_id, amount)
    end
    if core and core.giveBankMoney then
        return core.giveBankMoney(user_id, amount)
    end
    return false
end

function FRAMEWORK.server.getItemName(item)
    if core and core.getItemName then
        return core.getItemName(item)
    end
    return item
end

function FRAMEWORK.server.request(source, title, text)
    if core and core.Request then
        local ok, res = pcall(core.Request, source, tostring(title or 'Confirmação'), tostring(text or ''))
        if ok then
            return res
        end
    end
    return false
end

function FRAMEWORK.server.sendLog(channel, message)
    if core and core.sendLog then
        return core.sendLog(channel, message)
    end
    return false
end

function FRAMEWORK.server.isAdmin(user_id)
    return FRAMEWORK.server.hasGroup(user_id, 'Admin')
end

rEVOLT = core
getUserId = FRAMEWORK.server.getUserId
getUserSource = FRAMEWORK.server.getUserSource
getUsers = FRAMEWORK.server.getUsers
getUserIdentity = FRAMEWORK.server.getUserIdentity
getUserGroups = FRAMEWORK.server.getUserGroups
updateUserGroups = FRAMEWORK.server.updateUserGroups
getUserMyGroups = FRAMEWORK.server.getUserMyGroups
hasGroup = FRAMEWORK.server.hasGroup
HasGroup = FRAMEWORK.server.hasGroup
addUserGroup = FRAMEWORK.server.addUserGroup
removeUserGroup = FRAMEWORK.server.removeUserGroup
getBankMoney = FRAMEWORK.server.getBankMoney
tryFullPayment = FRAMEWORK.server.tryFullPayment
giveBankMoney = FRAMEWORK.server.giveBankMoney
getItemName = FRAMEWORK.server.getItemName
request = FRAMEWORK.server.request
sendFrameworkLog = FRAMEWORK.server.sendLog
isFrameworkAdmin = FRAMEWORK.server.isAdmin
