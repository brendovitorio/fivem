
local function sdbg(tag, data)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TUNNELS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function RegisterTunnel.getPermissions(role)
    local source = source
    local ctx = Organizations.getContext and Organizations:getContext(source) or nil
    if not ctx or not ctx.user_id or not ctx.org then return end
    local org = ctx.org

    role = tostring(role or "")
    if role == "" then
        local p = Organizations.Permissions[org] or {}
        return { success = true, org = org, permissions = p, list = p }
    end
    local p = (Organizations.Permissions[org] and Organizations.Permissions[org][role]) or {}
    return { success = true, org = org, role = role, permissions = p }
end

function RegisterTunnel.updatePermissions(role_id, perms)
    local source = source
    sdbg('updatePermissions:call', { src = source, role_id = role_id, perms = perms })
    local ctx = Organizations.getContext and Organizations:getContext(source) or nil
    if not ctx or not ctx.user_id or not ctx.org then return end

    local user_id = ctx.user_id
    local org = ctx.org
    local actorGroup = (type(normalizeGroupKey) == "function" and normalizeGroupKey(org, ctx.group)) or tostring(ctx.group or "")
    local user = Organizations.Members[user_id] or { groupType = org, group = actorGroup }
    user.group = (type(normalizeGroupKey) == "function" and normalizeGroupKey(org, user.group)) or tostring(user.group or actorGroup)

    local HasGroup = (ctx.isAdmin == true) or (Organizations.Permissions[org] and Organizations.Permissions[org][user.group] and Organizations.Permissions[org][user.group].leader) or false
    if not HasGroup then return end

-- PREMIUM: líder não edita o próprio cargo e nunca edita tier 1
role_id = (type(normalizeGroupKey) == "function" and normalizeGroupKey(org, role_id)) or tostring(role_id or "")
if role_id == "" then return end
if not ctx.isAdmin then
    if role_id == tostring(user.group or "") then
        return
    end
end

local orgCfg = Config and Config.Groups and Config.Groups[org]
local targetTier = 999
if orgCfg and orgCfg.List and orgCfg.List[role_id] then
    targetTier = tonumber(orgCfg.List[role_id].tier) or 999
end

if (not ctx.isAdmin) and targetTier == 1 then
    return
end

perms = type(perms) == "table" and perms or {}

-- Regra do painel: logs/config apenas tier 1 e tier 2
if (not ctx.isAdmin) and targetTier > 2 then
    perms.logs_view = false
    perms.admin_settings = false
end

    Organizations.Permissions[org] = Organizations.Permissions[org] or {}
    Organizations.Permissions[org][role_id] = perms

    dbExecute('revolt_orgs/UpdatePermissions', { organization = org, permissions = json.encode(Organizations.Permissions[org]) })

    if Organizations and Organizations.PushLog then
        Organizations:PushLog(org, user_id, ('Atualizou permissões do cargo: %s'):format(role_id))
    end

    sdbg('updatePermissions:ok', { organization = org, role_id = role_id })
    return true
end

function RegisterTunnel.updateConfig(data)
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user or not user.groupType then return end

    local HasGroup = Organizations.Permissions[user.groupType] and Organizations.Permissions[user.groupType][user.group] and Organizations.Permissions[user.groupType][user.group].leader or false
    if not HasGroup then
        return
    end

    data = type(data) == "table" and data or {}

    -- preserva valores existentes quando o front manda apenas 1 campo (ex: só logo)
    local current = nil
    local q = dbQuery('revolt_orgs/GetOrganizationInfos', { organization = user.groupType })
    if type(q) == "table" and q[1] then current = q[1] end

    local payload = {
        organization = user.groupType,
        logo = data.logo ~= nil and data.logo or (current and current.logo or nil),
        banner = data.banner ~= nil and data.banner or (current and current.banner or nil),
        discord = data.discord ~= nil and data.discord or (current and current.discord or nil),
    }

    dbExecute('revolt_orgs/updateFacInfo', payload)

    if Organizations and Organizations.PushLog then
        Organizations:PushLog(user.groupType, user_id, 'Atualizou configurações da organização')
    end

    return true
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- HIERARQUIA (UI): salva apenas a ORDEM de exibição dos cargos no painel
-- Armazena em Permissions[org]._roleOrder (dentro do JSON de permissions) para não precisar de coluna extra.
-- Regra: somente tier 1 e tier 2 (ou admin).
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function RegisterTunnel.setRoleOrder(order)
    local source = source
    local ctx = Organizations.getContext and Organizations:getContext(source) or nil
    if not ctx or not ctx.user_id or not ctx.org then return false end

    order = type(order) == "table" and order or {}
    if #order <= 0 then return false end

    local org = ctx.org
    local user_id = ctx.user_id
    local actorGroup = (type(normalizeGroupKey) == "function" and normalizeGroupKey(org, ctx.group)) or tostring(ctx.group or "")
    local user = Organizations.Members and Organizations.Members[user_id] or { groupType = org, group = actorGroup }
    user.group = (type(normalizeGroupKey) == "function" and normalizeGroupKey(org, user.group)) or tostring(user.group or actorGroup)

    local tier = 999
    if Config and Config.Groups and Config.Groups[org] and Config.Groups[org].List and user.group and Config.Groups[org].List[user.group] then
        tier = tonumber(Config.Groups[org].List[user.group].tier) or 999
    end

    if not ctx.isAdmin and tier > 2 then
        return false
    end

    -- Sanitiza: apenas roles válidas na Config (evita salvar lixo)
    local valid = {}
    local seen = {}
    local list = Config and Config.Groups and Config.Groups[org] and Config.Groups[org].List or {}
    for i = 1, #order do
        local rid = tostring(order[i] or "")
        if rid ~= "" and not seen[rid] and list and list[rid] then
            valid[#valid + 1] = rid
            seen[rid] = true
        end
    end
    if #valid <= 0 then return false end

    Organizations.Permissions[org] = type(Organizations.Permissions[org]) == "table" and Organizations.Permissions[org] or {}
    Organizations.Permissions[org]._roleOrder = valid

    dbExecute('revolt_orgs/UpdatePermissions', { organization = org, permissions = json.encode(Organizations.Permissions[org]) })

    if Organizations and Organizations.PushLog then
        Organizations:PushLog(org, user_id, 'Atualizou hierarquia de cargos (ordem do painel)')
    end

    return true
end