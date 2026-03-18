local function sdbg(tag, data)
    local ok, j = pcall(json.encode, data or {})
    print(('[revolt_orgs][SERVER][%s] %s'):format(tag, ok and j or tostring(data)))
end

local PENDING_INVITES = PENDING_INVITES or {}

local function inviteKey(id)
    local n = tonumber(id)
    if n then return tostring(n) end
    return tostring(id or "")
end

-- Extrai organização do formato "Cargo [ORG]"
local function extractOrgFromGroupName(groupName)
    if type(groupName) ~= "string" then return nil end
    local org = string.match(groupName, "%[(.-)%]")
    if org and org ~= "" then return org end
    return nil
end

-- Fallback quando o cache/contexto não está pronto (ex: onResourceStart)
local function inferCtxFromSource(src)
    local uid = (type(getUserId) == "function") and getUserId(src) or nil
    if not uid then return nil end

    local groups = nil
    if type(getUserMyGroups) == "function" then groups = getUserMyGroups(uid) end
    if type(groups) ~= "table" and type(getUserGroups) == "function" then groups = getUserGroups(uid) end
    groups = type(groups) == "table" and groups or {}

    for gName in pairs(groups) do
        local org = extractOrgFromGroupName(gName) or ((Organizations and Organizations.List) and Organizations.List[gName] or nil)
        if org and org ~= "" then
            return { user_id = uid, org = org, group = gName }
        end
    end
    return { user_id = uid, org = nil, group = nil }
end




local function formatHoursFromSeconds(sec)
    sec = tonumber(sec) or 0
    local h = math.floor(sec / 3600)
    return h, (tostring(h) .. "h")
end

local function notify(src, typ, msg, time)
    local nsrc = tonumber(src)
    if not nsrc then return end
    TriggerClientEvent("Notify", nsrc, typ or "aviso", msg or "", time or 5000)
end

local function getRolePrefix(org, group)
    if Config and Config.Groups and Config.Groups[org] and Config.Groups[org].List and Config.Groups[org].List[group] then
        return Config.Groups[org].List[group].prefix or group
    end
    return group
end

local function pickDefaultGroup(org)
    -- maior tier = novato
    local maxTier, gPick = -1, nil
    if Config and Config.Groups and Config.Groups[org] and Config.Groups[org].List then
        for g, v in pairs(Config.Groups[org].List) do
            local t = tonumber(v.tier) or 10
            if t > maxTier then
                maxTier = t
                gPick = g
            end
        end
    end
    return gPick, (maxTier >= 0 and maxTier or 10)
end

local function addLog(org, actor_id, role, name, description)
    -- schema: organization, user_id, role, name, description, date, expire_at
    local now = os.time()
    dbExecute("INSERT INTO revolt_orgs_logs (organization, user_id, role, name, description, date, expire_at) VALUES (@org, @uid, @role, @name, @desc, @date, @exp)", {
        org = org,
        uid = tonumber(actor_id) or 0,
        role = tostring(role or ""),
        name = tostring(name or ""),
        desc = tostring(description or ""),
        date = os.date('%d/%m/%Y %H:%M:%S', now),
        exp = now + (60 * 60 * 24 * 30)
    })
end

-- fallback comandos (caso o request/modal não apareça)
RegisterCommand("orgaceitar", function(source)
    local user_id = getUserId(source)
    if not user_id then return end
    local inv = PENDING_INVITES[inviteKey(user_id)]
    if not inv then return notify(source, "negado", "Você não tem convite pendente.", 5000) end
    if inv.expires and inv.expires < os.time() then
        PENDING_INVITES[inviteKey(user_id)] = nil
        return notify(source, "negado", "Seu convite expirou.", 5000)
    end
    if RegisterTunnel and RegisterTunnel.acceptInvite then
        RegisterTunnel.acceptInvite(inv)
    end
end)

RegisterCommand("orgrecusar", function(source)
    local user_id = getUserId(source)
    if not user_id then return end
    local inv = PENDING_INVITES[inviteKey(user_id)]
    if not inv then return notify(source, "negado", "Você não tem convite pendente.", 5000) end
    PENDING_INVITES[inviteKey(user_id)] = nil
    notify(source, "sucesso", "Você recusou o convite.", 5000)
    if inv.inviter_src then notify(inv.inviter_src, "negado", "O jogador recusou o convite.", 5000) end
end)

-- =========================
-- TUNNEL: LISTAR MEMBROS
-- =========================
RegisterTunnel.getMembers = function()
    local src = source
    sdbg('getMembers:call', { src = src })

    local ctx = (Organizations and Organizations.getContext) and Organizations:getContext(src) or nil
    if not ctx or not ctx.org then
        ctx = inferCtxFromSource(src)
    end
    if not ctx or not ctx.org then
        sdbg('getMembers:ret', { err = 'no_ctx' })
        return {}
    end

    local org = tostring(ctx.org)
	local rows = dbQuery("SELECT user_id, org, `group`, tier, joindate, lastlogin, timeplayed FROM revolt_orgs_members WHERE org=@org", { org = org, ['@org']=org })
	rows = type(rows) == 'table' and rows or {}

	local out = {}

	-- fallback: se tabela ainda não tem dados, monta a lista dos players online pelo core
	if #rows == 0 and type(getUsers) == 'function' then
	    local users = getUsers()
	    users = type(users) == 'table' and users or {}
	    for uid, src in pairs(users) do
	        uid = tonumber(uid) or uid
	        local plyGroups = nil
	        if type(getUserMyGroups) == 'function' then plyGroups = getUserMyGroups(uid) end
	        if type(plyGroups) ~= 'table' and type(getUserGroups) == 'function' then plyGroups = getUserGroups(uid) end
	        plyGroups = type(plyGroups) == 'table' and plyGroups or {}
	        for gName in pairs(plyGroups) do
	            local mapped = (Organizations and Organizations.List and Organizations.List[gName])
	            local extracted = extractOrgFromGroupName(gName)
	            if (mapped and mapped == org) or (extracted and extracted == org) then
	                rows[#rows+1] = { user_id = uid, org = org, ['group'] = gName, tier = 10, joindate = os.time(), lastlogin = os.time(), timeplayed = 0 }
	                break
	            end
	        end
	    end
	end
    for _, row in ipairs(rows) do
        local uid = tonumber(row.user_id)
        if uid then
            local src2 = getUserSource(uid)
            local idt = getIdentitySafe(uid, src2)
            local g = tostring(row['group'] or row.group or "")
            local tier = tonumber(row.tier) or 10
            local baseName = idt and ((idt.name or '') .. ' ' .. (idt.firstname or '')) or ''
            baseName = baseName:gsub('^%s+',''):gsub('%s+$','')
            local name = (baseName ~= '' and (baseName .. ' #'..tostring(uid))) or ('ID #'..tostring(uid))
            local online = getUserSource(uid) and true or false

            out[#out+1] = {
                id = uid,
                avatar = 'https://cdn.discordapp.com/icons/1220512491793289297/037858079290922918506b8a9714d8ca.webp',
                name = name,
                role = getRolePrefix(org, g),
                role_id = tier,
                -- UI nova espera string para status
                status = online and "online" or "offline",
                timeplayed = tonumber(row.timeplayed) or 0,
                timeActiveSeconds = tonumber(row.timeplayed) or 0,
                timeActiveHours = (select(1, formatHoursFromSeconds(row.timeplayed))),
                timeActive = (select(2, formatHoursFromSeconds(row.timeplayed))),

                -- compat extras (algumas telas usam esses campos)
                activeTime = tonumber(row.timeplayed) or 0,
                productivity = 0,
                joinedAt = os.date('%d/%m/%Y %H:%M:%S', tonumber(row.joindate) or os.time()),
                joinedAtText = os.date('%d/%m/%Y %H:%M:%S', tonumber(row.joindate) or os.time()),
                lastLoginAt = (tonumber(row.lastlogin) or 0),
                lastLogin = ((tonumber(row.lastlogin) or 0) > 0) and os.date('%d/%m/%Y %H:%M:%S', tonumber(row.lastlogin)) or "-",
                lastLoginText = ((tonumber(row.lastlogin) or 0) > 0) and os.date('%d/%m/%Y %H:%M:%S', tonumber(row.lastlogin)) or "-",
                hours = tonumber(row.timeplayed) or 0,
            }
        end
    end

    table.sort(out, function(a,b) return (a.role_id or 10) < (b.role_id or 10) end)
    sdbg('getMembers:ret', { org = org, count = #out })
    return { success = true, org = org, count = #out, members = out, list = out }
end

-- =========================
-- TUNNEL: ENVIAR CONVITE
-- =========================
function RegisterTunnel.inviteMember(payload)
    local src = source
    sdbg('inviteMember:call', { src = src, payload = payload })

    local ctx = Organizations.getContext and Organizations:getContext(src) or nil
    if not ctx or not ctx.user_id or not ctx.org then
        return { ok=false, success=false, message="ctx inválido" }
    end

    local org = tostring(ctx.org)
    local actor_id = tonumber(ctx.user_id)

    -- perm: admin ou invite
    local can = (ctx.isAdmin == true) or false
    if not can then
        local ug = ctx.group
        if Organizations and Organizations.Permissions and Organizations.Permissions[org] and Organizations.Permissions[org][ug] and Organizations.Permissions[org][ug].invite then
            can = true
        end
    end
    if not can then
        return { ok=false, success=false, message="Sem permissão" }
    end

    local input = payload
    if type(input) == 'table' then
        input = input.id or input.user_id or input.target or input.passport or input.source
    end

    local n = tonumber(input)
    if not n then return { ok=false, success=false, message="ID inválido" } end

    -- se passar SOURCE, tenta converter para passport
    local target_passport = n
    local maybe_passport = getUserId(n)
    if maybe_passport then target_passport = tonumber(maybe_passport) or target_passport end

    if not target_passport or target_passport <= 0 then
        return { ok=false, success=false, message="ID inválido" }
    end

    -- já é membro?
    local exists = dbQuery("SELECT user_id FROM revolt_orgs_members WHERE user_id=@uid LIMIT 1", { uid = target_passport, ['@uid']=target_passport })
    if exists and exists[1] then
        return { ok=false, success=false, message="Jogador já pertence a uma organização." }
    end

    -- precisa online p/ modal aceitar/recusar
    local tSrc = getUserSource(target_passport)
    if not tSrc then
        return { ok=false, success=false, message="Este jogador não está online." }
    end
    tSrc = tonumber(tSrc)

    local setGroup, tier = pickDefaultGroup(org)
    if not setGroup then
        return { ok=false, success=false, message="Org sem cargos configurados." }
    end

    local now = os.time()
    local k = inviteKey(target_passport)
    PENDING_INVITES[k] = {
        org = org,
        group = setGroup,
        tier = tier,
        inviter = actor_id,
        inviter_src = src,
        expires = now + 30
    }

    local invName = "#"..tostring(actor_id)
    local idt = getIdentitySafe(actor_id)
    if idt and (idt.name or idt.firstname) then
        invName = (idt.name or "") .. " " .. (idt.firstname or "")
    end

    TriggerClientEvent("revolt_orgs:invite", tSrc, {
        org = org,
        inviter = actor_id,
        inviterName = invName,
        secs = 30
    })

    notify(src, "sucesso", "Convite enviado. Aguarde o jogador aceitar/recusar.", 5000)
    notify(tSrc, "aviso", "Você recebeu um convite para entrar em "..org..".", 5000)

    sdbg('inviteMember:pending', { org = org, target = target_passport, group = setGroup })
    return { ok=true, success=true, message="Convite enviado." }
end

-- =========================
-- TUNNEL: ACEITAR / RECUSAR
-- =========================
function RegisterTunnel.acceptInvite(data)
    local src = source
    local user_id = getUserId(src)
    if not user_id then return { ok=false, success=false } end

    local k = inviteKey(user_id)
    local inv = PENDING_INVITES[k]
    if not inv then
        return { ok=false, success=false, message="Você não tem convite pendente." }
    end

    if inv.expires and inv.expires < os.time() then
        PENDING_INVITES[k] = nil
        return { ok=false, success=false, message="Seu convite expirou." }
    end

    -- grava membro
    local now = os.time()
    dbExecute("INSERT INTO revolt_orgs_members (user_id, org, `group`, tier, joindate, lastlogin, timeplayed) VALUES (@uid, @org, @grp, @tier, @j, @l, 0)", {
        uid = user_id, org = inv.org, grp = inv.group, tier = inv.tier or 10, j = now, l = now
    })

    -- aplica no core (online)
    addUserGroup(user_id, inv.group)
    Organizations.Members = Organizations.Members or {}
    Organizations.Members[user_id] = { groupType = inv.org, group = inv.group }


    -- log
    addLog(inv.org, user_id, getRolePrefix(inv.org, inv.group), tostring(GetPlayerName(src) or ("#"..user_id)), "Entrou na organização")

    notify(src, "sucesso", "Você entrou na organização: "..tostring(inv.org)..".", 5000)
    if inv.inviter_src then notify(inv.inviter_src, "sucesso", "O jogador #"..tostring(user_id).." aceitou o convite.", 5000) end

    PENDING_INVITES[k] = nil
    return { ok=true, success=true, message="Convite aceito." }
end

function RegisterTunnel.declineInvite(data)
    local src = source
    local user_id = getUserId(src)
    if not user_id then return { ok=false, success=false } end

    local k = inviteKey(user_id)
    local inv = PENDING_INVITES[k]
    if not inv then
        return { ok=false, success=false, message="Você não tem convite pendente." }
    end

    notify(src, "sucesso", "Você recusou o convite.", 5000)
    if inv.inviter_src then notify(inv.inviter_src, "negado", "O jogador #"..tostring(user_id).." recusou o convite.", 5000) end

    PENDING_INVITES[k] = nil
    return { ok=true, success=true, message="Convite recusado." }
end

-- =========================
-- PROMOVER / REBAIXAR / DEMITIR
-- =========================
function RegisterTunnel.genMember(data)
    local src = source
    sdbg('genMember:call', { src = src, data = data })

    local ctx = Organizations.getContext and Organizations:getContext(src) or nil
    if not ctx or not ctx.user_id or not ctx.org then return false end

    local org = tostring(ctx.org)
    local actor = tonumber(ctx.user_id)
    local ply_id = tonumber(data and data.memberId)
    if not ply_id then return false end

    local row = dbQuery("SELECT user_id, org, `group`, tier FROM revolt_orgs_members WHERE user_id=@uid AND org=@org LIMIT 1", { uid = ply_id, org = org })
    if not row or not row[1] then return false end

    local curGroup = tostring(row[1]['group'] or row[1].group or "")
    local curTier  = tonumber(row[1].tier) or 10

    local function canDo(perm)
        if ctx.isAdmin == true then return true end
        local g = ctx.group
        return Organizations and Organizations.Permissions and Organizations.Permissions[org] and Organizations.Permissions[org][g] and Organizations.Permissions[org][g][perm] == true
    end

    local act = tostring(data.action or "")

    if act == 'promote' then
        if not canDo('promote') then return false end
        local newTier = curTier - 1; if newTier < 1 then newTier = 1 end
        local newGroup = nil
        for g, v in pairs((Config.Groups[org] and Config.Groups[org].List) or {}) do
            if tonumber(v.tier) == newTier then newGroup = g break end
        end
        if not newGroup then return false end

        dbExecute("UPDATE revolt_orgs_members SET `group`=@g, tier=@t WHERE user_id=@uid", { g = newGroup, t = newTier, uid = ply_id })
        local tSrc = getUserSource(ply_id)
        if tSrc then addUserGroup(ply_id, newGroup) end

        addLog(org, actor, getRolePrefix(org, ctx.group or ''), tostring(GetPlayerName(src) or ("#"..actor)), "Promoveu o membro #"..ply_id)

        return { role = getRolePrefix(org, newGroup), role_id = newTier }
    end

    if act == 'demote' then
        if not canDo('demote') then return false end
        local newTier = curTier + 1
        local maxTier = curTier
        for _, v in pairs((Config.Groups[org] and Config.Groups[org].List) or {}) do
            local t = tonumber(v.tier) or 10
            if t > maxTier then maxTier = t end
        end
        if newTier > maxTier then newTier = maxTier end

        local newGroup = nil
        for g, v in pairs((Config.Groups[org] and Config.Groups[org].List) or {}) do
            if tonumber(v.tier) == newTier then newGroup = g break end
        end
        if not newGroup then return false end

        dbExecute("UPDATE revolt_orgs_members SET `group`=@g, tier=@t WHERE user_id=@uid", { g = newGroup, t = newTier, uid = ply_id })
        local tSrc = getUserSource(ply_id)
        if tSrc then addUserGroup(ply_id, newGroup) end

        addLog(org, actor, getRolePrefix(org, ctx.group or ''), tostring(GetPlayerName(src) or ("#"..actor)), "Rebaixou o membro #"..ply_id)

        return { role = getRolePrefix(org, newGroup), role_id = newTier }
    end

    if act == 'dismiss' or act == 'dimiss' then
        if not canDo('dismiss') then return false end
        if ply_id == actor then return false end

        dbExecute("DELETE FROM revolt_orgs_members WHERE user_id=@uid AND org=@org", { uid = ply_id, org = org })

        local tSrc = getUserSource(ply_id)
        if tSrc then
            -- remove o grupo atual do core
            removeUserGroup(ply_id, curGroup)
        end

        addLog(org, actor, getRolePrefix(org, ctx.group or ''), tostring(GetPlayerName(src) or ("#"..actor)), "Demitou o membro #"..ply_id)

        return true
    end

    return false
end
