-- Helpers (robustez NUI)
-- REVOLT Tunnel/Proxy bootstrap (garante vTunnel/vSERVER)
local Tunnel = module('revolt','lib/Tunnel')

RegisterTunnel = RegisterTunnel or {}

-- Interface do server deste resource
vTunnel = Tunnel.getInterface('revolt_orgs')
-- Alias (alguns trechos chamam vSERVER)
vSERVER = vTunnel

-- Bind do client (se o server chamar alguma função via Tunnel)
Tunnel.bindInterface('revolt_orgs', RegisterTunnel)

local function ensureTable(v)
    return type(v) == "table" and v or {}
end

local function ensureBool(v)
    return v and true or false
end

-- ==========================================================
-- Normalização de dados para a NUI open source.
-- (O server pode mandar formatos diferentes; aqui padroniza.)
-- ==========================================================

local function safeNum(v, d)
    v = tonumber(v)
    if v == nil then return d or 0 end
    return v
end

local function roleColorFromTier(tier)
    tier = safeNum(tier, 10)
    if tier == 1 then return "#f59e0b" end -- ouro
    if tier == 2 then return "#a855f7" end -- roxo
    if tier == 3 then return "#22c55e" end -- verde
    if tier == 4 then return "#3b82f6" end -- azul
    return "#94a3b8" -- cinza
end

local function normalizeMember(m)
    m = type(m) == "table" and m or {}
    local uid = safeNum(m.id or m.user_id, 0)
    local status = tostring(m.status or "")
    local online = (m.online == true) or (status == "online")

    local hours = tonumber(m.hoursActive or m.timeActiveHours)
    if not hours then
        local sec = safeNum(m.timeActiveSeconds or m.timeplayed, 0)
        hours = math.floor(sec / 3600)
    end

    local lastSeen = m.lastSeen or m.lastLoginAt or m.lastLogin or m.lastLoginText or m.lastlogin or m.last_login
    local joinDate = m.joinDate or m.joinedAtText or m.joinedAt or m.joindate

    local roleTier = safeNum(m.role_id or m.tier, 10)
    local role = tostring(m.role or m.group or "")

    local productivity = tonumber(m.productivity)
    if not productivity then
        productivity = math.min(100, math.floor(hours * 8))
    end

    local timeActiveText = tostring(hours) .. "h"

    return {
        id = uid,
        name = tostring(m.name or ("ID #" .. tostring(uid))),
        avatar = tostring(m.avatar or ""),
        role = role,
        roleColor = tostring(m.roleColor or roleColorFromTier(roleTier)),
        joinDate = joinDate,
        lastSeen = lastSeen,
        lastLoginText = tostring(m.lastLoginText or m.lastLogin or m.lastlogin or ""),
        online = online,
        status = online and "online" or "offline",
        hoursActive = hours,
        timeActive = timeActiveText,
        productivity = productivity
    }
end

local function computeWeeklyRevenue(bankHistoric)
    bankHistoric = type(bankHistoric) == "table" and bankHistoric or {}

    -- Client-side Lua in FiveM may not expose `os`. So we avoid OS_* entirely.
    -- Use the newest transaction timestamp as "now" to keep buckets stable.
    local now = 0
    for i=1, #bankHistoric do
        local e = bankHistoric[i]
        if type(e) == "table" then
            local ts = safeNum(e.timestamp, 0)
            if ts > now then now = ts end
        end
    end
    -- If we still don't have a timestamp, fall back to cloud time (if available)
    if now <= 0 and type(GetCloudTimeAsInt) == "function" then
        now = tonumber(GetCloudTimeAsInt()) or 0
    end

    local daySeconds = 86400
    local buckets = {}
    -- Create 7 day buckets keyed by day index
    for d = 6, 0, -1 do
        local ts = now - (d * daySeconds)
        local dayIdx = math.floor(ts / daySeconds)
        buckets[dayIdx] = { day = ("D"..tostring(7 - d)), income = 0, expenses = 0 }
    end

    for i=1, #bankHistoric do
        local e = bankHistoric[i]
        if type(e) == "table" then
            local ts = safeNum(e.timestamp, 0)
            if ts > 0 then
                local dayIdx = math.floor(ts / daySeconds)
                local b = buckets[dayIdx]
                if b then
                    local code = tostring(e.type_code or e.type or "")
                    local amt = safeNum(e.amount or e.value, 0)
                    if code == "deposit" or code == "transfer_in" or code == "goal" then
                        b.income = b.income + amt
                    elseif code == "withdraw" or code == "withdrawal" or code == "transfer" then
                        b.expenses = b.expenses + amt
                    end
                end
            end
        end
    end

    local out = {}
    for d = 6, 0, -1 do
        local ts = now - (d * daySeconds)
        local dayIdx = math.floor(ts / daySeconds)
        out[#out+1] = buckets[dayIdx] or { day = ("D"..tostring(7 - d)), income = 0, expenses = 0 }
    end
    return out
end

local function computeMonthlyTrend(bankHistoric)
    bankHistoric = type(bankHistoric) == "table" and bankHistoric or {}

    -- Avoid OS_*; compute week buckets relative to newest timestamp
    local now = 0
    for i=1, #bankHistoric do
        local e = bankHistoric[i]
        if type(e) == "table" then
            local ts = safeNum(e.timestamp, 0)
            if ts > now then now = ts end
        end
    end
    if now <= 0 and type(GetCloudTimeAsInt) == "function" then
        now = tonumber(GetCloudTimeAsInt()) or 0
    end

    local weekSeconds = 7 * 86400
    local maxWeeks = 5  -- last ~5 weeks trend
    local latestByBucket = {}     -- bucket -> { ts=..., balance=... }

    for i=1, #bankHistoric do
        local e = bankHistoric[i]
        if type(e) == "table" then
            local ts = safeNum(e.timestamp, 0)
            local bal = safeNum(e.balanceAfter or e.balance, 0)
            if ts > 0 and now > 0 then
                local age = now - ts
                if age >= 0 and age <= (60 * 86400) then
                    local bucket = math.floor(age / weekSeconds) -- 0 = current week
                    if bucket >= 0 and bucket < maxWeeks then
                        local cur = latestByBucket[bucket]
                        if not cur or ts > cur.ts then
                            latestByBucket[bucket] = { ts = ts, balance = bal }
                        end
                    end
                end
            end
        end
    end

    local out = {}
    -- Oldest -> newest (S1..)
    for b = maxWeeks-1, 0, -1 do
        local idx = #out + 1
        local item = latestByBucket[b]
        out[idx] = { week = "S"..tostring(idx), balance = item and item.balance or 0 }
    end
    return out
end

local function detectWarnings(bankHistoric)
    bankHistoric = type(bankHistoric) == "table" and bankHistoric or {}
    local total, count = 0, 0
    for i=1, #bankHistoric do
        local e = bankHistoric[i]
        if type(e) == "table" then
            local amt = safeNum(e.amount or e.value, 0)
            if amt > 0 then total = total + amt; count = count + 1 end
        end
    end
    if count <= 0 then return {} end
    local avg = total / count
    local spikes = 0
    for i=1, #bankHistoric do
        local e = bankHistoric[i]
        if type(e) == "table" then
            local amt = safeNum(e.amount or e.value, 0)
            if amt >= (avg * 2.0) then spikes = spikes + 1 end
        end
    end
    if spikes > 0 then
        return { string.format("%d transação acima da média detectada", spikes) }
    end
    return {}
end

-- guarda o último contexto enviado ao abrir o painel (ex: {admin=true, org='Franca'})
local LAST_OPEN_PAYLOAD = {}

PANEL_VISIBLE = false
local function safeTunnelCall(fn, default, ...)
    if type(fn) ~= "function" then return default end
    local ok, res = pcall(fn, ...)
    if ok then return res end
    return default
end

-- Compat: alguns códigos usam RegisterNuiCallback (camelcase)
if type(RegisterNuiCallback) ~= "function" and type(RegisterNUICallback) == "function" then
    RegisterNuiCallback = RegisterNUICallback
end

local function dbg(msg)
end

function safeJson(v)
    local ok, j = pcall(json.encode, v)
    return ok and j or tostring(v)
end

---------------------------------------------------------------------
-- MONTA PAYLOAD ESTRUTURADO PARA O FRONT
---------------------------------------------------------------------
local function buildPayload(data)
    data = ensureTable(data)

    local membersRaw = ensureTable(data.membersList)
    local members, onlineCount = {}, 0
    for i=1, #membersRaw do
        local nm = normalizeMember(membersRaw[i])
        if nm.online then onlineCount = onlineCount + 1 end
        members[#members+1] = nm
    end

    local bankHistoric = ensureTable(data.bank_historic)
    local warnings = ensureTable(data.warnings)
    if #warnings == 0 then warnings = detectWarnings(bankHistoric) end

    local weeklyRevenue = computeWeeklyRevenue(bankHistoric)
    local monthlyTrend = computeMonthlyTrend(bankHistoric)

    local prod = {}
    for i=1, #members do prod[#prod+1] = members[i] end
    table.sort(prod, function(a,b) return (a.productivity or 0) > (b.productivity or 0) end)
    local ranking = {}
    for i=1, math.min(5, #prod) do
        ranking[#ranking+1] = { name = prod[i].name, productivity = prod[i].productivity, avatar = prod[i].avatar }
    end

    return {
        organization = {
            name = data.orgName or data.org or "",
            banner = data.banner or data.serverIcon or "",
            logo = data.logo or data.serverIcon or "",
            balance = safeNum(data.orgBalance or data.balance or data.bank, 0),
            members = safeNum(data.totalMembers, #members),
            membersOnline = safeNum(data.onlineMembers, onlineCount),
            leader = tostring(data.role or data.leader or ""),
            discord = tostring(data.discord or ""),
            bank_historic = bankHistoric,
            warnings = warnings,
            premium = data.premium or data.orgPremium or data.premiumOrg,

        },
        player = {
            user_id = safeNum(data.user_id or data.id, 0),
            id = safeNum(data.user_id or data.id, 0),
            name = tostring(data.playerName or data.name or GetPlayerName(PlayerId()) or "Jogador"),
            balance = safeNum(data.playerBalance or data.playerBank, 0),
            role = tostring(data.role or ""),
            avatar = tostring(data.avatar or ""),
        },
        members = members,
        roles = ensureTable(data.roles),
        goals = ensureTable(data.goals),
        logs = ensureTable(data.logs),
        activities = ensureTable(data.activities),
        permissions = ensureTable(data.permissions),
        dashboardStats = {
            weeklyRevenue = weeklyRevenue,
            monthlyTrend = monthlyTrend,
            productivityRanking = ranking,
            memberGrowth = ensureTable(data.memberGrowth),
            activityTrend = ensureTable(data.activityTrend),
        },
        transactions = ensureTable(data.transactions)
    }
end



---------------------------------------------------------------------
    -- BUILDERS (para App.jsx)
    ---------------------------------------------------------------------
    local function buildDashboardPayload(data)
        data = data or {}
        return {
            organization = {
                name = data.orgName or data.org or "",
                banner = data.banner or data.serverIcon or "",
                logo = data.serverIcon or data.logo or "",
                balance = tonumber(data.orgBalance or 0) or 0,
                members = tonumber(data.members or 0) or 0,
                membersOnline = tonumber(data.membersOnline or 0) or 0,
                logo = data.logo or "",
                discord = data.discord or "",
                leader = data.leader or ""
            },
            player = {
                user_id = tonumber(data.user_id or 0) or 0,
                name = data.name or "",
                balance = tonumber(data.playerBalance or 0) or 0,
                role = data.role or ""
            },
            activities = ensureTable(data.activities),
            dashboardStats = ensureTable(data.dashboardStats),
        }
    end
---------------------------------------------------------------------
-- FUNÇÕES INTERNAS: BUSCAR DADOS DA FACÇÃO COM FALLBACKS
---------------------------------------------------------------------
local function fetchFactionData(orgName, isAdmin)
    -- prioridade: vSERVER.getFaction (server interface)
    if vSERVER and type(vSERVER.getFaction) == "function" then
        -- tenta com args (se o seu server aceitar)
        local res = safeTunnelCall(vSERVER.getFaction, nil, orgName, isAdmin)
        if res ~= nil then return res end

        -- fallback sem args (compat antigo)
        res = safeTunnelCall(vSERVER.getFaction, nil)
        if res ~= nil then return res end
    end

    -- fallback: alguns setups colocam getFaction no vTunnel
    if vTunnel and type(vTunnel.getFaction) == "function" then
        local res = safeTunnelCall(vTunnel.getFaction, nil, orgName, isAdmin)
        if res ~= nil then return res end
        res = safeTunnelCall(vTunnel.getFaction, nil)
        if res ~= nil then return res end
    end

    return nil
end

-- Complementa dados com módulos que dependem de contexto no server.
local function enrichFactionData(data)
    data = ensureTable(data)

    -- membros
    if vTunnel and type(vTunnel.getMembers) == "function" then
        local mr = safeTunnelCall(vTunnel.getMembers, data.membersList or {})
        if type(mr) == "table" then
            data.membersList = mr.members or mr.list or mr.data or mr
        else
            data.membersList = data.membersList or {}
        end
    end

    -- banco + histórico
    if vTunnel and type(vTunnel.getBankInfo) == "function" then
        local bank = safeTunnelCall(vTunnel.getBankInfo, {})
        if type(bank) == "table" then
            if type(bank.organization) == "table" then
                data.orgBalance = bank.organization.balance or bank.organization.bank or data.orgBalance
            end
            data.bank_historic = bank.bankHistoric or bank.bank_historic or data.bank_historic
            data.playerBalance = bank.playerBalance or data.playerBalance
        end
    end

    -- logs
    if vTunnel and type(vTunnel.getLogs) == "function" then
        local lr = safeTunnelCall(vTunnel.getLogs, data.logs or {})
        if type(lr) == "table" then
            data.logs = lr.logs or lr.list or lr.data or lr
        else
            data.logs = data.logs or {}
        end
    end

    -- metas
    if vTunnel and type(vTunnel.getListGoals) == "function" then
        local gr = safeTunnelCall(vTunnel.getListGoals, data.goals or {})
        if type(gr) == "table" then
            data.goals = gr.goals or gr.list or gr.data or gr
        else
            data.goals = data.goals or {}
        end
    end

    return data
end

---------------------------------------------------------------------
-- FECHAR NUI (unificado)
---------------------------------------------------------------------
local function closePanel()
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SetPanelActionLock(false)

    SendNUIMessage({ action = "close" })

    -- tenta fechar por tunnel se existir
    if vTunnel and type(vTunnel._close) == "function" then
        safeTunnelCall(vTunnel._close, nil)
    end

    PANEL_VISIBLE = false
    dbg("Painel fechado")
end

-- Mantém compat com o server chamando essa função via tunnel
function RegisterTunnel.closePainel(data, cb)
    closePanel()
    if cb then cb("ok") end
end

---------------------------------------------------------------------
-- REQUEST OPEN (SERVER CHAMA ESSE EVENTO)
---------------------------------------------------------------------
RegisterNetEvent("revolt_orgs:requestOpen")
AddEventHandler("revolt_orgs:requestOpen", function(orgName, isAdmin)
    orgName = tostring(orgName or "")
    isAdmin = ensureBool(isAdmin)

    LAST_OPEN_PAYLOAD = { org = orgName, admin = isAdmin }
    dbg(("requestOpen recebido org=%s admin=%s"):format(orgName, tostring(isAdmin)))

    -- Busca dados reais
    local data = fetchFactionData(orgName, isAdmin)
    if not data then
        dbg("getFaction retornou nil (não abriu)")
        return
    end

    -- garante contexto de organização (evita header ficar "Organização")
    data.orgName = data.orgName or data.org or orgName
    data.org = data.org or orgName

    data = enrichFactionData(data)

    -- abre o painel via fluxo padronizado
    TriggerEvent("revolt_orgs:open", data)
end)


---------------------------------------------------------------------
-- REFRESH (SERVER DISPARA PARA ATUALIZAR SEM ENSURE)
---------------------------------------------------------------------
RegisterNetEvent("revolt_orgs:refresh")
AddEventHandler("revolt_orgs:refresh", function(info)
    if not PANEL_VISIBLE then
        dbg("refresh recebido mas painel não está visível (ignorando)")
        return
    end

    local orgName = tostring((LAST_OPEN_PAYLOAD and LAST_OPEN_PAYLOAD.org) or "")
    local isAdmin = ensureBool((LAST_OPEN_PAYLOAD and LAST_OPEN_PAYLOAD.admin) or false)

    local data = fetchFactionData(orgName, isAdmin)
    if not data then
        dbg("refresh: getFaction retornou nil")
        return
    end

    data = enrichFactionData(data)

    local payload = buildPayload(data)
    SendNUIMessage({ action = "hydrate", data = payload })
    SendNUIMessage({ action = "update", data = payload }) -- compat extra
    dbg("refresh aplicado (hydrate/update)")
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TUNNELS (mantidos) - ABRIR PAINEL
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function RegisterTunnel.OpenPainel(orgName, isAdmin)
    orgName = tostring(orgName or "")
    isAdmin = ensureBool(isAdmin)

    LAST_OPEN_PAYLOAD = { org = orgName, admin = isAdmin }

    dbg(("Tentando abrir painel org=%s admin=%s"):format(orgName, tostring(isAdmin)))

    local data = fetchFactionData(orgName, isAdmin)
    if not data then
        dbg("Dados da facção NÃO recebidos (nil)")
        return
    end


    -- garante contexto de organização (evita header ficar "Organização")
    data.orgName = data.orgName or data.org or orgName
    data.org = data.org or orgName

    data = enrichFactionData(data)

    -- Dispara evento local que realmente abre a NUI
    TriggerEvent("revolt_orgs:open", data)

    -- Mantém animação/tablet (sem remover)
    CarregarObjeto("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_b", "prop_cs_tablet", 49, 60309)
end

---------------------------------------------------------------------
-- EVENTO: OPEN (abre NUI)
---------------------------------------------------------------------
RegisterNetEvent("revolt_orgs:open")
AddEventHandler("revolt_orgs:open", function(data)
    data = ensureTable(data)
    if not next(data) then
        dbg("open chamado com data vazio (ignorando)")
        return
    end

    local payload = buildPayload(data)

    SetPanelActionLock(true)
    PANEL_VISIBLE = true

    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)

    SendNUIMessage({
        action = "open",
        data = payload
    })

    -- Compat extra: alguns front-ends usam "hydrate" em vez de "open" para popular o estado.
    SendNUIMessage({
        action = "hydrate",
        data = payload
    })

    dbg(("Painel aberto para org=%s"):format(payload.organization.name or ""))
end)

---------------------------------------------------------------------
-- NUI CALLBACKS
---------------------------------------------------------------------
RegisterNuiCallback("GetCDS", function(_, cb)
    local coords = GetEntityCoords(PlayerPedId())
    cb(("%s,%s"):format(coords.x, coords.y)) -- cds em string
end)

RegisterNuiCallback("GetFarms", function(_, cb)
    local logs = {}
    if vTunnel and type(vTunnel.GetStorageLogs) == "function" then
        logs = ensureTable(safeTunnelCall(vTunnel.GetStorageLogs, {}))
    end
    cb(logs)
end)

RegisterNUICallback("requestData", function(_, cb)
    local org = LAST_OPEN_PAYLOAD.org or ""
    local admin = LAST_OPEN_PAYLOAD.admin or false

    local data = fetchFactionData(org, admin)
    if not data then
        cb({})
        return
    end

    -- BLINDAGEM: garante contexto de organização também no fluxo requestData
    -- (muita UI usa requestData para hidratar e pode sobrescrever o estado inicial do "open")
    data.orgName = data.orgName or data.org or org
    data.org = data.org or org

    data = enrichFactionData(data)

    cb(buildPayload(data))
end)











RegisterNUICallback("GetLogList", function(_, cb)
    if not vTunnel or type(vTunnel.getLogs) ~= "function" then
        cb({ logs = {}, count = 0, success = false })
        return
    end

    local raw = safeTunnelCall(vTunnel.getLogs, {})
    raw = ensureTable(raw)
    local list = raw.logs or raw.list or raw.data or raw
    list = ensureTable(list)

    local org = tostring(raw.org or raw.organizationName or raw.organization or LAST_OPEN_PAYLOAD.org or "")
    cb({
        success = raw.success ~= false,
        org = org,
        organizationName = org,
        count = tonumber(raw.count or #list) or #list,
        logs = list
    })
end)

RegisterNUICallback("GetRoleList", function(_, cb)
    -- vSERVER não existe neste resource (Tunnel local é vTunnel). Busca via getFaction com fallback.
    local org = LAST_OPEN_PAYLOAD.org or ""
    local admin = LAST_OPEN_PAYLOAD.admin or false
    local data = fetchFactionData(org, admin)
    local roles = data and data.roles or {}
    cb({ roles = ensureTable(roles) })
end)

RegisterNUICallback("GetGoalsList", function(_, cb)
    if not vTunnel or type(vTunnel.getListGoals) ~= "function" then
        cb({ goals = {}, count = 0, success = false })
        return
    end

    local raw = safeTunnelCall(vTunnel.getListGoals, {})
    raw = ensureTable(raw)
    local list = raw.goals or raw.list or raw.data or raw
    list = ensureTable(list)

    local org = tostring(raw.org or raw.organizationName or raw.organization or LAST_OPEN_PAYLOAD.org or "")
    cb({
        success = raw.success ~= false,
        org = org,
        organizationName = org,
        count = tonumber(raw.count or #list) or #list,
        goals = list
    })
end)

RegisterNUICallback("GetDashboard", function(_, cb)
    -- vSERVER não existe neste resource (Tunnel local é vTunnel). Busca via getFaction com fallback.
    local org = LAST_OPEN_PAYLOAD.org or ""
    local admin = LAST_OPEN_PAYLOAD.admin or false
    local data = fetchFactionData(org, admin)
    if not data then return cb({}) end

    -- BLINDAGEM: garante que o header sempre tenha nome da org também via GetDashboard
    data.orgName = data.orgName or data.org or org
    data.org = data.org or org

    local payload = buildDashboardPayload(data)
    payload.org = data.org
    payload.organizationName = data.org
    payload.organization = payload.organization or {}
    payload.organization.name = payload.organization.name or data.org
    cb(payload)
end)

RegisterNUICallback("GetPermissions", function(_, cb)
    if vTunnel and type(vTunnel.getPermissions) == "function" then
        local raw = safeTunnelCall(vTunnel.getPermissions, nil, "")
        raw = ensureTable(raw)
        local perms = raw.permissions or raw.list or raw
        perms = ensureTable(perms)

        local org = tostring(raw.org or raw.organizationName or raw.organization or LAST_OPEN_PAYLOAD.org or "")
        cb({
            success = raw.success ~= false,
            org = org,
            organizationName = org,
            permissions = perms
        })
        return
    end

    cb({ success = false, permissions = {} })
end)

-- UI nova salva permissões via SetPermissions
RegisterNUICallback("SetPermissions", function(data, cb)
    dbg("SetPermissions:call " .. json.encode(data or {}))
    data = data or {}
    local role_id = data.role_id or data.role or data.group
    local perms = data.permissions or data.perms
    if type(role_id) ~= "string" or role_id == "" then cb(false) return end
    if type(perms) ~= "table" then cb(false) return end
    local ok = safeTunnelCall(vTunnel.updatePermissions, false, role_id, perms)
    dbg("SetPermissions:ret " .. tostring(ok))
    cb(ensureBool(ok))
end)

-- UI nova salva ordem da hierarquia via SetRoleOrder
RegisterNUICallback("SetRoleOrder", function(data, cb)
    data = type(data) == "table" and data or {}
    local order = data.order or data.roles or data.roleOrder
    if type(order) ~= "table" then
        if cb then cb(false) end
        return
    end
    local ok = safeTunnelCall(vTunnel.setRoleOrder, false, order)
    if cb then cb(ok and true or false) end
end)

---------------------------------------------------------------------
-- CONFIG (UI): SetConfig (banner/logo/discord)
---------------------------------------------------------------------
RegisterNUICallback("SetConfig", function(data, cb)
    data = type(data)=="table" and data or {}
    local ok = safeTunnelCall(vTunnel.setConfig, false, data)
    if cb then cb(ok and { ok = true, success = true } or { ok = false, success = false }) end
end)

-- aliases (algumas UIs)
RegisterNUICallback("setConfig", function(data, cb)
    data = type(data)=="table" and data or {}
    local ok = safeTunnelCall(vTunnel.setConfig, false, data)
    if cb then cb(ok and true or false) end
end)


RegisterNuiCallback("GetPainelInfos", function(_, cb)
    local org = LAST_OPEN_PAYLOAD.org or ""
    local admin = LAST_OPEN_PAYLOAD.admin or false

    local res = fetchFactionData(org, admin)
    res = ensureTable(res)

    -- mantém seu formato “legacy” também
    local payload = {
        organization = {
            orgName = res.orgName or res.org or org or "",
            banner = res.serverIcon or res.logo or "",
            logo = res.logo or "",
            discord = res.discord or "",
            leader = res.leader or "",
            balance = tonumber(res.orgBalance or res.balance or 0) or 0,
            members = tonumber(res.members or res.totalMembers or 0) or 0,
            membersOnline = tonumber(res.membersOnline or res.onlineMembers or 0) or 0,
            totalMembers = tonumber(res.members or res.totalMembers or 0) or 0,
            onlineMembers = tonumber(res.membersOnline or res.onlineMembers or 0) or 0,
            salary = tonumber(res.salary or 0) or 0,
            nextPayment = tonumber(res.nextPayment or 0) or 0,
            nextPaymentMax = tonumber(res.nextPaymentMax or 0) or 0,
            store = res.store or "",
            serverIcon = res.serverIcon or "",
            warnings = ensureTable(res.warnings),
        },
        player = {
            user_id = tonumber(res.user_id or 0) or 0,
            name = res.name or "",
            bank = tonumber(res.playerBalance or res.playerBank or 0) or 0,
            role = res.role or "",
            permissions = ensureTable(res.permissions),
            admin = ensureBool(res.admin or admin),
        },
        permissions = ensureTable(res.permissions),
        roles = ensureTable(res.roles),
        members = ensureTable(res.membersList),
        transactions = ensureTable(res.transactions),
        goals = ensureTable(res.goals),
        logs = ensureTable(res.warnings),
        activities = ensureTable(res.activities),
        dashboardStats = ensureTable(res.dashboardStats),
    }

    cb(payload)
end)

RegisterNuiCallback("getLeaders", function(_, cb)
    local res = {}
    if vTunnel and type(vTunnel.getLeaders) == "function" then
        res = ensureTable(safeTunnelCall(vTunnel.getLeaders, {}))
    end
    cb(res)
end)

RegisterNuiCallback("NewWarn", function(data, cb)
    if vTunnel and type(vTunnel.addWarn) == "function" then
        cb(ensureBool(safeTunnelCall(vTunnel.addWarn, false, data)))
        return
    end
    cb(false)
end)

RegisterNuiCallback("DeleteWarning", function(data, cb)
    if vTunnel and type(vTunnel.deleteWarning) == "function" then
        cb(ensureBool(safeTunnelCall(vTunnel.deleteWarning, false, (data.index or 0) + 1)))
        return
    end
    cb(false)
end)

RegisterNuiCallback("GetMessages", function(_, cb)
    local res = {}
    if vTunnel and type(vTunnel.getChatMessages) == "function" then
        res = ensureTable(safeTunnelCall(vTunnel.getChatMessages, {}))
    end
    cb(res)
end)

RegisterNuiCallback("New:Message", function(data, cb)
    if vTunnel and type(vTunnel.sendMessage) == "function" then
        cb(ensureBool(safeTunnelCall(vTunnel.sendMessage, false, data.message)))
        return
    end
    cb(false)
end)

-- close unificado (evita callback duplicado)
RegisterNUICallback("close", function(_, cb)
    dbg("close callback chamado")
    closePanel()
    if cb then cb(true) end
end)



-- Compat UI: ClosePainel (Escape)
RegisterNUICallback('ClosePainel', function(data, cb)
    dbg('ClosePainel callback chamado ' .. json.encode(data or {}))
    -- Evita crash caso _close não exista.
    if vTunnel and type(vTunnel._close) == "function" then
        safeTunnelCall(vTunnel._close, nil)
    end
    closePanel()
    if cb then cb({ ok = true }) end
end)

-- Compat: botão "Sair" do front pode chamar nomes diferentes
RegisterNUICallback('Exit', function(_, cb)
    closePanel(); if cb then cb({ ok = true }) end
end)

RegisterNUICallback('Logout', function(_, cb)
    closePanel(); if cb then cb({ ok = true }) end
end)

RegisterNUICallback('Close', function(_, cb)
    closePanel(); if cb then cb({ ok = true }) end
end)

---------------------------------------------------------------------
-- ALIASES DE ENDPOINTS (compat universal)
-- Alguns front-ends usam nomes diferentes para as mesmas ações.
---------------------------------------------------------------------

local function ok(cb, data) if cb then cb(data) end end

RegisterNUICallback("InviteMember", function(data, cb)
    local id = tonumber((data and (data.id or data.user_id or data.playerId)) or 0) or 0
    if id <= 0 then return ok(cb, false) end
    ok(cb, ensureBool(safeTunnelCall(vTunnel and vTunnel.inviteMember, false, id)))
end)

-- Stubs/ponte para possíveis UIs com gerenciamento de cargos
RegisterNUICallback("CreateRole", function(data, cb)
    ok(cb, vTunnel and type(vTunnel.createRole)=="function" and safeTunnelCall(vTunnel.createRole, { success=false }, data) or { success=false, message="createRole not implemented" })
end)
RegisterNUICallback("UpdateRolePerms", function(data, cb)
    ok(cb, vTunnel and type(vTunnel.updateRolePerms)=="function" and safeTunnelCall(vTunnel.updateRolePerms, { success=false }, data) or { success=false, message="updateRolePerms not implemented" })
end)
RegisterNUICallback("RenameRole", function(data, cb)
    ok(cb, vTunnel and type(vTunnel.renameRole)=="function" and safeTunnelCall(vTunnel.renameRole, { success=false }, data) or { success=false, message="renameRole not implemented" })
end)
RegisterNUICallback("DeleteRole", function(data, cb)
    ok(cb, vTunnel and type(vTunnel.deleteRole)=="function" and safeTunnelCall(vTunnel.deleteRole, { success=false }, data) or { success=false, message="deleteRole not implemented" })
end)
RegisterNUICallback("getRanking", function(_, cb)
    local res = {}
    if vTunnel and type(vTunnel.getRanking) == "function" then
        res = ensureTable(safeTunnelCall(vTunnel.getRanking, {}))
    end
    cb(res)
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("updateChatMessage", function(data)
    SendNUIMessage({ action = "Create:Message", data = data })
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- OTHERS FUNCTIONS (mantidos - animação/tablet)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local object

function CarregarAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end
end

function CarregarObjeto(dict, anim, prop, flag, mao, altura, pos1, pos2, pos3)
    local ped = PlayerPedId()

    RequestModel(GetHashKey(prop))
    while not HasModelLoaded(GetHashKey(prop)) do
        Citizen.Wait(10)
    end

    if altura then
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -5.0)
        object = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z, true, true, true)
        SetEntityCollision(object, false, false)

        AttachEntityToEntity(
            object, ped, GetPedBoneIndex(ped, mao),
            altura, pos1, pos2, pos3,
            260.0, 60.0, true, true, false, true, 1, true
        )
    else
        CarregarAnim(dict)
        TaskPlayAnim(ped, dict, anim, 3.0, 3.0, -1, flag, 0, 0, 0, 0)
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -5.0)
        object = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z, true, true, true)
        SetEntityCollision(object, false, false)
        AttachEntityToEntity(
            object, ped, GetPedBoneIndex(ped, mao),
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            false, false, false, false, 2, true
        )
    end

    SetEntityAsMissionEntity(object, true, true)
end

local PANEL_LOCK = {
    enabled = false,
    thread = nil,
}

-- Controles que SEMPRE deixamos passar
local ALWAYS_ALLOW = {
    [200] = true, -- INPUT_FRONTEND_PAUSE_ALTERNATE (ESC / Pause)
    [199] = true, -- INPUT_FRONTEND_PAUSE (Pause)
}

-- Lista de controles “perigosos” que vamos bloquear.
-- (A ideia é bloquear ações, não teclas específicas. Assim voice/radio não sofre.)
local BLOCK_CONTROLS = {
    -- Mouse/aim/shoot
    1,   -- INPUT_LOOK_LR (camera)
    2,   -- INPUT_LOOK_UD (camera)
    24,  -- INPUT_ATTACK
    25,  -- INPUT_AIM
    257, -- INPUT_ATTACK2
    263, -- INPUT_MELEE_ATTACK1
    264, -- INPUT_MELEE_ATTACK2
    140, -- INPUT_MELEE_ATTACK_LIGHT
    141, -- INPUT_MELEE_ATTACK_HEAVY
    142, -- INPUT_MELEE_ATTACK_ALTERNATE
    143, -- INPUT_MELEE_BLOCK
    44,  -- INPUT_COVER

    -- Armas / wheel / troca
    37,  -- INPUT_SELECT_WEAPON (weapon wheel)
    45,  -- INPUT_RELOAD
    12,  -- INPUT_WEAPON_WHEEL_UP
    13,  -- INPUT_WEAPON_WHEEL_DOWN
    14,  -- INPUT_WEAPON_WHEEL_LEFT
    15,  -- INPUT_WEAPON_WHEEL_RIGHT
    16,  -- INPUT_SELECT_NEXT_WEAPON
    17,  -- INPUT_SELECT_PREV_WEAPON
    99,  -- INPUT_VEH_SELECT_NEXT_WEAPON
    100, -- INPUT_VEH_SELECT_PREV_WEAPON

    -- Movimento
    30,  -- INPUT_MOVE_LR
    31,  -- INPUT_MOVE_UD
    21,  -- INPUT_SPRINT
    22,  -- INPUT_JUMP
    36,  -- INPUT_DUCK
    32,  -- INPUT_MOVE_UP_ONLY
    33,  -- INPUT_MOVE_DOWN_ONLY
    34,  -- INPUT_MOVE_LEFT_ONLY
    35,  -- INPUT_MOVE_RIGHT_ONLY

    -- Veículos / interação que pode causar caos
    23,  -- INPUT_ENTER
    75,  -- INPUT_VEH_EXIT
    58,  -- INPUT_THROW_GRENADE
    47,  -- INPUT_DETONATE
    73,  -- INPUT_VEH_DUCK
}

local function _disableBadStuffThisFrame()
    -- Bloqueia absolutamente tudo enquanto o painel estiver aberto.
    -- O cursor e input da NUI continuam funcionando por causa do SetNuiFocus(true,true).
    DisableAllControlActions(0)
    DisableAllControlActions(1)
    DisableAllControlActions(2)

    -- (opcional) ainda permite ALT+TAB / etc fora do jogo naturalmente.
end

-- Chame com true ao abrir o painel e false ao fechar
function SetPanelActionLock(state)
    state = state and true or false
    if PANEL_LOCK.enabled == state then return end
    PANEL_LOCK.enabled = state

    local ped = PlayerPedId()

    if state then
        -- opcional: “congela” o ped (para de deslizar/andar)
        FreezeEntityPosition(ped, true)
        SetPedCanRagdoll(ped, false)
        SetPlayerControl(PlayerId(), false, 0)

        if PANEL_LOCK.thread then return end
        PANEL_LOCK.thread = CreateThread(function()
            while PANEL_LOCK.enabled do
                Wait(0)
                _disableBadStuffThisFrame()
            end
            PANEL_LOCK.thread = nil
        end)
    else
        FreezeEntityPosition(ped, false)
        SetPedCanRagdoll(ped, true)
        SetPlayerControl(PlayerId(), true, 0)
        -- thread cai sozinha
    end
end

---------------------------------------------------------------------
-- SEGURANÇA AO PARAR RESOURCE
---------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUM UI ENDPOINTS (compat com ui/assets/index-*.js)
-- A UI chama: GetBankInfo, DepositMoney, WithdrawMoney, TransferMoney, GetMembers,
-- PromoteMember, DemoteMember, DimissMember, ContractMember
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function _num(v) return tonumber(v) or 0 end

RegisterNUICallback("GetBankInfo", function(_, cb)
    if not vTunnel or not vTunnel.getBankInfo then
        cb({ success = false, organization = { name = tostring((LAST_OPEN_PAYLOAD and LAST_OPEN_PAYLOAD.org) or "") }, bankHistoric = {} })
        return
    end

    local res = safeTunnelCall(vTunnel.getBankInfo, {})
    res = ensureTable(res)

    -- padroniza: sempre retorna organization.name + bankHistoric normalizado
    local org = tostring(res.org or res.organizationName or res.organization or (LAST_OPEN_PAYLOAD and LAST_OPEN_PAYLOAD.org) or "")
    local orgObj = ensureTable(res.organization)
    orgObj.name = tostring(orgObj.name or org)

    -- alguns servers retornam orgBalance/bank fora do objeto
    if orgObj.balance == nil and (res.orgBalance or res.bank) then
        orgObj.balance = tonumber(res.orgBalance or res.bank or 0) or 0
    end

    local historic = res.bankHistoric or res.bank_historic or (orgObj and orgObj.bank_historic) or {}
    historic = ensureTable(historic)

    -- normaliza campos esperados pela NUI (amount/type_code/timestamp/date/balanceAfter)
    for i=1, #historic do
        local e = historic[i]
        if type(e) == "table" then
            if e.amount == nil and e.value ~= nil then e.amount = tonumber(e.value) or 0 end
            if e.value == nil and e.amount ~= nil then e.value = tonumber(e.amount) or 0 end
            if e.type_code == nil and e.typeCode ~= nil then e.type_code = e.typeCode end
            e.type_code = tostring(e.type_code or e.code or e.type or "")
            e.timestamp = tonumber(e.timestamp or e.time or e.ts or 0) or 0
            e.date = tostring(e.date or e.datetime or "")
            e.balanceAfter = tonumber(e.balanceAfter or e.balance_after or e.balance or orgObj.balance or 0) or 0
        end
    end

    orgObj.bank_historic = historic

    cb({
        success = res.success ~= false,
        org = org,
        organizationName = org,
        organization = orgObj,
        bankHistoric = historic,
        playerBalance = tonumber(res.playerBalance or res.playerBank or 0) or 0
    })
end)


RegisterNUICallback("DepositMoney", function(data, cb)
    local amount = _num(data and data.amount)
    if amount <= 0 then cb(false) return end
    local ok = safeTunnelCall(vTunnel.transactionBank, false, { type = "deposit", amount = amount })
    cb(ensureBool(ok))
end)

RegisterNUICallback("WithdrawMoney", function(data, cb)
    local amount = _num(data and data.amount)
    if amount <= 0 then cb(false) return end
    local ok = safeTunnelCall(vTunnel.transactionBank, false, { type = "withdraw", amount = amount })
    cb(ensureBool(ok))
end)

RegisterNUICallback("TransferMoney", function(data, cb)
    local amount = _num(data and data.amount)
    local to = _num(data and data.to)
    if amount <= 0 or to <= 0 then cb(false) return end
    local ok = safeTunnelCall(vTunnel.transactionBank, false, { type = "transfer", amount = amount, to = to })
    cb(ensureBool(ok))
end)

RegisterNUICallback("GetMembers", function(_, cb)
    if not vTunnel or not vTunnel.getMembers then
        cb({ success = false, members = {}, count = 0 })
        return
    end

    local raw = safeTunnelCall(vTunnel.getMembers, {})
    raw = ensureTable(raw)

    -- server blindado retorna { members=list, org=..., ... }
    local members = raw.members or raw.list or raw.data or raw
    members = ensureTable(members)

    local out = {}
    for i=1, #members do out[#out+1] = normalizeMember(members[i]) end

    local org = tostring(raw.org or raw.organizationName or raw.organization or LAST_OPEN_PAYLOAD.org or "")
    cb({
        success = raw.success ~= false,
        org = org,
        organizationName = org,
        organization = { name = org },
        count = tonumber(raw.count or #out) or #out,
        members = out
    })
end)

local function _memberAction(action, data, cb)
    local id = _num((data and (data.id or data.user_id)) or 0)
    if id <= 0 then cb(false) return end
    local ok = safeTunnelCall(vTunnel.genMember, false, { action = action, memberId = id })
    cb(ensureBool(ok))
end

RegisterNUICallback("PromoteMember", function(data, cb) _memberAction("promote", data, cb) end)
RegisterNUICallback("DemoteMember", function(data, cb) _memberAction("demote", data, cb) end)
RegisterNUICallback("DimissMember", function(data, cb) _memberAction("dimiss", data, cb) end)

RegisterNUICallback("ContractMember", function(data, cb)

    local target = tonumber(data and (data.id or data.user_id or data.target)) or 0
    if target <= 0 then
        local ret = { ok = false, success = false, message = "ID inválido" }
        return cb(ret)
    end

    -- chama o tunnel do server (nome real do seu core: inviteMember)
    local ret = { ok = false, success = false, message = "inviteMember tunnel missing" }
    if vTunnel and vTunnel.inviteMember then
        ret = vTunnel.inviteMember({ id = target, target = target }) or ret
    end

    -- padroniza retorno pro React
    if ret.success == nil and ret.ok ~= nil then ret.success = ret.ok end
    if ret.ok == nil and ret.success ~= nil then ret.ok = ret.success end

    cb(ret)
end)

AddEventHandler("onClientResourceStop", function(res)
    if res == GetCurrentResourceName() then
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
end)

-- Invite modal (themed NUI)
RegisterNetEvent("revolt_orgs:invite")
AddEventHandler("revolt_orgs:invite", function(data)
    data = ensureTable(data)
    dbg("invite recebido -> " .. safeJson(data))

    -- abre apenas o modal (sem abrir painel completo)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)

    SendNUIMessage({ action = "invite", data = data })
end)

-- Close invite modal (called by UI)
RegisterNUICallback("InviteClose", function(_, cb)
    -- só tira foco se o painel não estiver aberto
    if not PANEL_VISIBLE then
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
    cb({ ok = true })
end)

