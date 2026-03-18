
-- Extrai organização do nome do grupo no formato "Cargo [ORG]"
local function detectOrganizationFromGroups(groups)
    if type(groups) ~= "table" then return nil, nil end
    for gName in pairs(groups) do
        if type(gName) == "string" then
            local org = string.match(gName, "%[(.-)%]")
            if org and org ~= "" then
                return org, gName
            end
        end
    end
    return nil, nil
end

-- Normaliza a org para bater com a chave real em Config.Groups.
-- Ex.: "FRANCA" (grupo) -> "Franca" (config)
local function normalizeOrgKey(org)
    org = tostring(org or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if org == "" then return org end
    if Config and Config.Groups and Config.Groups[org] then return org end

    if Config and Config.Groups then
        local low = string.lower(org)
        for k in pairs(Config.Groups) do
            if type(k) == 'string' and string.lower(k) == low then
                return k
            end
        end
    end

    return org
end

local function normalizeGroupKey(org, group)
    org = normalizeOrgKey(org)
    group = tostring(group or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if group == "" then return nil end
    if not (Config and Config.Groups and org and Config.Groups[org] and Config.Groups[org].List) then
        return group
    end

    local list = Config.Groups[org].List
    if list[group] then return group end

    local clean = group:gsub("%s*%b[]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    if clean ~= "" and list[clean] then return clean end

    local low = string.lower(group)
    local lowClean = string.lower(clean)
    for k in pairs(list) do
        if type(k) == "string" then
            local keyLow = string.lower(k)
            if keyLow == low or keyLow == lowClean then
                return k
            end
        end
    end

    return clean ~= "" and clean or group
end
_G.normalizeGroupKey = normalizeGroupKey

local Tunnel = module('revolt','lib/Tunnel')

RegisterTunnel = RegisterTunnel or {}
Tunnel.bindInterface('revolt_orgs', RegisterTunnel)

local function sdbg(tag, data)
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
-- Exporta helpers para modules
_G.dbPrepare = dbPrepare
_G.dbQuery = dbQuery
_G.dbExecute = dbExecute


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dbPrepare('revolt_orgs/GetOrganizationInfos', 'SELECT * FROM revolt_orgs_info WHERE organization = @organization')
dbPrepare('revolt_orgs/GetOrgsPermissions', 'SELECT organization,permissions FROM revolt_orgs_info')
dbPrepare('revolt_orgs/GetGoalsConfig', 'SELECT organization,config_goals FROM revolt_orgs_info')
dbPrepare('revolt_orgs/GetOrgsSalary', 'SELECT organization,salary FROM revolt_orgs_info')

dbPrepare('revolt_orgs/getAlerts', 'SELECT alerts FROM revolt_orgs_info WHERE organization = @organization')
dbPrepare('revolt_orgs/updateAlerts', 'UPDATE revolt_orgs_info SET alerts = @alerts WHERE organization = @organization')

dbPrepare('revolt_orgs/UpdatePermissions', 'UPDATE revolt_orgs_info SET permissions = @permissions WHERE organization = @organization')
dbPrepare('revolt_orgs/updateFacInfo', 'UPDATE revolt_orgs_info SET discord = @discord, logo = @logo, banner = @banner WHERE organization = @organization')

dbPrepare('revolt_orgs/updateOrgVip', 'UPDATE revolt_orgs_info SET vip_name = @vip_name, vip_expires_at = @vip_expires_at, vip_salary = @vip_salary WHERE organization = @organization')


dbPrepare('revolt_orgs/GetAllUsersInfo', 'SELECT * FROM revolt_orgs_player_infos')
dbPrepare('revolt_orgs/GetAllUserInfo', 'SELECT * FROM revolt_orgs_player_infos WHERE user_id = @user_id')
dbPrepare('revolt_orgs/DeleteUserInfo', 'DELETE FROM revolt_orgs_player_infos WHERE user_id = @user_id')
dbPrepare('revolt_orgs/DeleteUserInfoByGroup', 'DELETE FROM revolt_orgs_player_infos WHERE user_id = @user_id AND organization = @organization')
dbPrepare('revolt_orgs/SetPlayerOrganization', 'INSERT IGNORE INTO revolt_orgs_player_infos(user_id, organization, joindate, lastlogin, timeplayed) VALUES(@user_id, @organization, @joindate, @lastlogin, @timeplayed)')

dbPrepare('revolt_orgs/getInviteReward', 'SELECT * FROM revolt_orgs_invite_rewards WHERE user_id = @user_id')
dbPrepare('revolt_orgs/setInviteReward', 'INSERT IGNORE INTO revolt_orgs_invite_rewards(user_id, organization, invite_userid) VALUES(@user_id, @organization, @invite_userid)')

dbPrepare('revolt_orgs/updateSalary', 'UPDATE revolt_orgs_info SET salary = @salary WHERE organization = @organization')

-- FALTAVAM:
-- ATENÇÃO: ajuste GetUsersGroup conforme seu core / schema.
-- REVOLT: grupos ficam no playerdata (datatable)
-- OBS: essa query também existe no config.lua, mas manter aqui não custa.
dbPrepare('revolt_orgs/GetUsersGroup', "SELECT Passport,dvalue FROM playerdata WHERE dkey = 'datatable'")

dbPrepare('revolt_orgs/bank/getinfo', 'SELECT bank, bank_historic FROM revolt_orgs_info WHERE organization = @organization')
dbPrepare('revolt_orgs/bank/updateBank', 'UPDATE revolt_orgs_info SET bank = @bank, bank_historic = @historic WHERE organization = @organization')

dbPrepare('revolt_orgs/CreateTable1', [[
CREATE TABLE IF NOT EXISTS `revolt_orgs_goals` (
  `user_id` int(11) NOT NULL,
  `organization` varchar(50) NOT NULL,
  `item` varchar(100) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `day` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `step` int(11) DEFAULT 1,
  `reward_step` int(11) DEFAULT 0,
  UNIQUE KEY `user_id_organization_item_day` (`user_id`,`organization`,`item`,`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
]])

-- CORRIGIDO: adiciona salary + padroniza charset
dbPrepare('revolt_orgs/CreateTable2', [[
CREATE TABLE IF NOT EXISTS `revolt_orgs_info` (
  `organization` varchar(50) NOT NULL,
  `alerts` text DEFAULT '{}',
  `logo` text DEFAULT NULL,
  `banner` text DEFAULT NULL,
  `discord` varchar(150) DEFAULT '',
  `bank` int(11) DEFAULT 0,
  `bank_historic` text DEFAULT '{}',
  `permissions` text DEFAULT '{}',
  `config_goals` text DEFAULT '{}',
  `salary` text DEFAULT '{}',
  `vip_name` varchar(50) DEFAULT NULL,
  `vip_expires_at` int(11) DEFAULT NULL,
  `vip_salary` int(11) DEFAULT 0,
  PRIMARY KEY (`organization`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
]])


dbPrepare('revolt_orgs/CreateTable3', [[
CREATE TABLE IF NOT EXISTS `revolt_orgs_logs` (
  `organization` varchar(50) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `expire_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
]])

dbPrepare('revolt_orgs/CreateTable4', [[
CREATE TABLE IF NOT EXISTS `revolt_orgs_player_infos` (
  `user_id` int(11) NOT NULL,
  `organization` varchar(50) DEFAULT NULL,
  `joindate` int(11) DEFAULT 0,
  `lastlogin` int(11) DEFAULT 0,
  `lastlogout` int(11) DEFAULT 0,
  `timeplayed` int(11) DEFAULT 0,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
]])

-- UI NOVA: tabela persistente de membros (para listar offline/online)
dbPrepare('revolt_orgs/CreateTable5', [[
CREATE TABLE IF NOT EXISTS `revolt_orgs_members` (
  `user_id` int(11) NOT NULL,
  `org` varchar(50) NOT NULL,
  `group` varchar(80) DEFAULT NULL,
  `tier` int(11) DEFAULT 10,
  `joindate` int(11) DEFAULT 0,
  `lastlogin` int(11) DEFAULT 0,
  `lastlogout` int(11) DEFAULT 0,
  `timeplayed` int(11) DEFAULT 0,
  PRIMARY KEY (`user_id`),
  KEY `idx_org` (`org`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
]])

-- Identidade do personagem (tenta variações comuns de schema)
dbPrepare('revolt_orgs/GetCharacterIdentity',
 'SELECT * FROM characters WHERE id = @id LIMIT 1'
)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterTunnel = RegisterTunnel or {}
Organizations = Organizations or {
    List = {},
    Permissions = {},
    Members = {},
    MembersList = {},
    timePlayed = {},
    Chat = {},
    hasOppenedOrg = {},
    payDayOrg = {},
    goalsConfig = {}
}

-- Session tracking (login/logout + timeplayed)
Organizations._sessions = Organizations._sessions or {}

-- Garante que uma sessão exista e que lastlogin represente LOGIN real.
-- (playerJoining nem sempre dispara quando o core ainda não tem user_id pronto)
local function ensureSessionStart(user_id)
    user_id = tonumber(user_id)
    if not user_id then return end
    if Organizations._sessions[user_id] and Organizations._sessions[user_id].start then return end
    local now = os.time()
    Organizations._sessions[user_id] = { start = now }
    if exports and exports.oxmysql then
        -- lastlogin só deve mudar no início de sessão
        exports['oxmysql']:execute('UPDATE revolt_orgs_player_infos SET lastlogin=? WHERE user_id=?', { now, user_id })
        exports['oxmysql']:execute('UPDATE revolt_orgs_members SET lastlogin=? WHERE user_id=?', { now, user_id })
    end
end

local function fmtDuration(totalSec)
    totalSec = math.max(0, tonumber(totalSec) or 0)
    local h = math.floor(totalSec / 3600)
    local m = math.floor((totalSec % 3600) / 60)
    local s = math.floor(totalSec % 60)
    return string.format('%02d:%02d:%02d', h, m, s)
end

-- admin view context: quando um admin abre outra org via /paineladmin
Organizations.AdminView = Organizations.AdminView or {}

local function isUserAdmin(user_id)
    if not user_id then return false end
    if type(isFrameworkAdmin) == "function" then
        return isFrameworkAdmin(user_id) and true or false
    end
    if type(HasGroup) == "function" then
        return HasGroup(user_id, "Admin") and true or false
    end
    return false
end

-- Resolve contexto para calls do painel.
-- - membro normal: org = org do jogador
-- - admin: org = org aberta via /paineladmin (se houver), senão cai no org do jogador
function Organizations:getContext(src)
    local user_id = getUserId(src)
    if not user_id then return nil end

    -- garante tracking de sessão (para timeplayed)
    ensureSessionStart(user_id)

    local isAdmin = isUserAdmin(user_id)

    -- Admin pode "visualizar" outra org via comando (AdminView[src] = {org="Franca"})
    local viewOrg = nil
    if Organizations.AdminView then
        local v = Organizations.AdminView[src]
        if type(v) == "table" then viewOrg = v.org else viewOrg = v end
    end

    -- 1) se admin escolheu org, essa é a org do contexto
    local org = (isAdmin and type(viewOrg) == "string" and viewOrg ~= "" and viewOrg) or nil
    local group = nil

    -- 2) tenta pelo cache em memória (quando o player já está carregado)
    local mem = Organizations.Members and Organizations.Members[user_id] or nil
    if not org and mem and mem.groupType then
        org = mem.groupType
        group = normalizeGroupKey(mem.groupType, mem.group)
    end

	-- 2.5) tenta inferir pelo core (grupos do jogador) em tempo real
	if not org then
	    local plyGroups = nil
	    if type(getUserMyGroups) == "function" then plyGroups = getUserMyGroups(user_id) end
	    if type(plyGroups) ~= "table" and type(getUserGroups) == "function" then plyGroups = getUserGroups(user_id) end
	    plyGroups = type(plyGroups) == "table" and plyGroups or {}
	    -- 2.5.1) primeiro tenta pelo mapeamento pré-formatado (Organizations.List)
	    if Organizations and Organizations.List then
	        for gName in pairs(plyGroups) do
	            local og = Organizations.List[gName]
	            if og and og ~= "" then
	                org = og
	                group = gName
	                break
	            end
	        end
	    end
	    -- 2.5.2) fallback: extrai "ORG" de "Cargo [ORG]"
	    if not org then
	        local og, gg = detectOrganizationFromGroups(plyGroups)
	        if og then
	            org = og
	            group = gg
	        end
	    end
	end

	-- 3) fonte da verdade: tabela DB revolt_orgs_members (persistente)
    if not org then
        local rows = dbQuery("SELECT org, `group` FROM revolt_orgs_members WHERE user_id=@uid LIMIT 1", { uid = user_id, ['@uid']=user_id })
        if rows and rows[1] then
            org = tostring(rows[1].org or "")
            group = normalizeGroupKey(org, tostring(rows[1].group or rows[1]["group"] or ""))
            if org == "" then org = nil end
            if group == "" then group = nil end
        end
    end

    -- normaliza org para bater com Config.Groups (evita 0/0 por mismatch de caixa: FRANCA vs Franca)
    if org then org = normalizeOrgKey(org) end

    -- 4) se ainda não tem group, escolhe um "default" pela Config (menor tier = lider)
    if org and (not group or group == "") and Config and Config.Groups and Config.Groups[org] and Config.Groups[org].List then
        local bestTier = 999
        for gName, gCfg in pairs(Config.Groups[org].List) do
            local tier = tonumber(gCfg and gCfg.tier) or 999
            if tier < bestTier then
                bestTier = tier
                group = gName
            end
        end
    end

    group = normalizeGroupKey(org, group)
    if org and group then
        Organizations.Members = Organizations.Members or {}
        Organizations.Members[user_id] = { groupType = org, group = group }
    end

    return { user_id = user_id, org = org, organization = org, organizationName = org, group = group, isAdmin = isAdmin }
end
BANK = BANK or { cooldown = {} }
-- Atualiza cache de membros online sem precisar de ensure
CreateThread(function()
    Wait(2000)
    while true do
        local users = (type(getUsers)=="function" and getUsers()) or {}
        for uid, src in pairs(users) do
            uid = tonumber(uid)
            if uid then
                local rows = dbQuery("SELECT org, `group` FROM revolt_orgs_members WHERE user_id=@uid LIMIT 1", { uid = uid, ['@uid']=uid })
                if rows and rows[1] and rows[1].org then
                    Organizations.Members = Organizations.Members or {}
                    Organizations.Members[uid] = { groupType = normalizeOrgKey(tostring(rows[1].org)), group = tostring(rows[1]["group"] or rows[1].group or "") }
                end
            end
        end
        Wait(30000)
    end
end)


-- garante método que você usa no Payday
function BANK:generateLog(historic, entry)
    historic = type(historic) == "table" and historic or {}
    entry = type(entry) == "table" and entry or {}

    table.insert(historic, 1, entry)

    local MAX = 100
    while #historic > MAX do
        table.remove(historic)
    end

    return historic
end

local WARNS = WARNS or {}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Organizations:AddUserGroup(user_id, v)
    v = type(v) == "table" and v or {}

    -- Compat: às vezes chega só { group = 'Novato [FRANCA]' }
    if (not v.groupType or v.groupType == "") and v.group then
        -- tenta inferir pelo nome do grupo dentro do Config.Groups
        if Config and Config.Groups then
            for org, orgCfg in pairs(Config.Groups) do
                if orgCfg and orgCfg.List and orgCfg.List[v.group] then
                    v.groupType = org
                    break
                end
            end
        end
    end

    if not v.groupType or v.groupType == "" then
        return false
    end

    v.groupType = normalizeOrgKey(tostring(v.groupType))
    v.group = normalizeGroupKey(v.groupType, v.group)
    local prev = self.Members[user_id]
    self.Members[user_id] = v
    -- remove de listas antigas se mudou de org
    if prev and prev.groupType and tostring(prev.groupType) ~= tostring(v.groupType) then
        local p = tostring(prev.groupType)
        if self.MembersList[p] then self.MembersList[p][user_id] = nil end
    end
    self.MembersList[v.groupType] = self.MembersList[v.groupType] or {}
    self.MembersList[v.groupType][user_id] = true

    -- garante tabela de infos para listagem offline
    if exports and exports["oxmysql"] then
        exports["oxmysql"]:execute([[INSERT INTO revolt_orgs_player_infos(user_id, organization, joindate, lastlogin, timeplayed)
            VALUES(?,?,?,?,?)
            ON DUPLICATE KEY UPDATE organization=VALUES(organization)]],
            { user_id, v.groupType, os.time(), os.time(), 0 })
    end
    
    -- calcula tier do cargo, se possível
    local tier = tonumber(v.tier)
    if not tier and v.group and Config and Config.Groups and Config.Groups[v.groupType] and Config.Groups[v.groupType].List and Config.Groups[v.groupType].List[v.group] then
        tier = tonumber(Config.Groups[v.groupType].List[v.group].tier)
    end
    v.tier = tier or v.tier or 10

    -- mantém tabela de membros sincronizada (para UI nova)
    -- IMPORTANT: lastlogin NÃO pode ser atualizado em fluxos de cache/painel.
    -- lastlogin deve representar o login real do jogador (playerJoining / spawn), não "abriu painel".
    if exports and exports["oxmysql"] then
        exports["oxmysql"]:execute([[
            INSERT INTO revolt_orgs_members (user_id, org, `group`, tier, joindate, lastlogin, timeplayed)
            VALUES(?,?,?,?,?,?,?)
            ON DUPLICATE KEY UPDATE
              org=VALUES(org),
              `group`=VALUES(`group`),
              tier=VALUES(tier)
        ]], { user_id, v.groupType, v.group or '', tonumber(v.tier) or 10, os.time(), os.time(), 0 })
    end

    return true
end

-- LASTLOGIN (FIX): atualiza apenas no login real do jogador.
-- Evita que "Último login" vire "última vez que abriu o painel".
AddEventHandler('playerJoining', function()
    local src = source

    CreateThread(function()
        local user_id = nil

        for i = 1, 50 do
            if type(getUserId) == 'function' then
                local ok, result = pcall(getUserId, src)
                if ok and result then
                    user_id = result
                    break
                end
            end
            Wait(200)
        end

        if not user_id then
            print(('[revolt_orgs] playerJoining: Passport não ficou pronto para source %s'):format(src))
            return
        end

        local now = os.time()
        ensureSessionStart(user_id)

        Wait(2500)

        local org, grp
        local mem = Organizations.Members and Organizations.Members[user_id] or nil
        if mem and mem.groupType then
            org = mem.groupType
            grp = mem.group
        end

        if not org and exports and exports.oxmysql then
            local rows = dbQuery('SELECT org, `group` FROM revolt_orgs_members WHERE user_id=? LIMIT 1', { user_id })
            if rows and rows[1] then
                org = rows[1].org
                grp = rows[1]['group']
            end
        end

        org = tostring(org or '')
        if org ~= '' and Organizations.PushLog then
            local name = ('#%s'):format(user_id)

            if type(getUserIdentity) == 'function' then
                local ok, ident = pcall(getUserIdentity, user_id)
                if ok and type(ident) == 'table' and (ident.name or ident.firstname) then
                    name = ((ident.name or '') .. ' ' .. (ident.firstname or ''))
                end
            end

            name = tostring(name):gsub('^%s+', ''):gsub('%s+$', '')
            Organizations:PushLog(
                org,
                user_id,
                ('Logou na cidade (%s)'):format(os.date('%d/%m/%Y %H:%M:%S', now)),
                grp or '',
                name
            )
        end
    end)
end)

-- QUIT: marca lastlogout + soma tempo jogado + loga tempo de sessão
AddEventHandler('playerDropped', function(reason)
    local src = source
    if type(getUserId) ~= 'function' then return end
    local user_id = getUserId(src)
    if not user_id then return end

    local now = os.time()

    -- se por algum motivo não marcou início, assume que começou agora (evita nil + mantém DB consistente)
    ensureSessionStart(user_id)
    local sess = Organizations._sessions[user_id]
    local startedAt = sess and tonumber(sess.start) or nil
    local played = (startedAt and startedAt > 0) and math.max(0, now - startedAt) or 0

    -- remove da memória (evita leak)
    Organizations._sessions[user_id] = nil

    if exports and exports.oxmysql then
        -- marca lastlogout
        exports['oxmysql']:execute('UPDATE revolt_orgs_player_infos SET lastlogout=? WHERE user_id=?', { now, user_id })
        exports['oxmysql']:execute('UPDATE revolt_orgs_members SET lastlogout=? WHERE user_id=?', { now, user_id })

        -- soma tempo jogado (segundos) nas duas tabelas
        if played > 0 then
            exports['oxmysql']:execute('UPDATE revolt_orgs_player_infos SET timeplayed = timeplayed + ? WHERE user_id=?', { played, user_id })
            exports['oxmysql']:execute('UPDATE revolt_orgs_members SET timeplayed = timeplayed + ? WHERE user_id=?', { played, user_id })
        end
    end

    -- loga saída (com tempo logado)
    local org, grp
    local mem = Organizations.Members and Organizations.Members[user_id] or nil
    if mem and mem.groupType then
        org = mem.groupType
        grp = mem.group
    end

    if not org and exports and exports.oxmysql then
        local rows = dbQuery('SELECT org, `group` FROM revolt_orgs_members WHERE user_id=? LIMIT 1', { user_id })
        if rows and rows[1] then
            org = rows[1].org
            grp = rows[1]['group']
        end
    end

    org = tostring(org or '')
    if org ~= '' and Organizations.PushLog then
        local name = ('#%s'):format(user_id)
        if type(getUserIdentity) == 'function' then
            local ident = getUserIdentity(user_id)
            if type(ident) == 'table' and (ident.name or ident.firstname) then
                name = ((ident.name or '') .. ' ' .. (ident.firstname or ''))
            end
        end
        name = tostring(name):gsub('^%s+', ''):gsub('%s+$', '')
        local function normalizeDropReason(r)
            r = tostring(r or '')
            local low = string.lower(r)
            if low == '' then return '' end
            -- crashes comuns
            if string.find(low, 'crash', 1, true) or string.find(low, 'game crashed', 1, true) then
                return 'crash'
            end
            if string.find(low, 'timeout', 1, true) then
                return 'timeout'
            end
            if string.find(low, 'kicked', 1, true) or string.find(low, 'kick', 1, true) then
                return 'kick'
            end
            if string.find(low, 'banned', 1, true) or string.find(low, 'ban', 1, true) then
                return 'ban'
            end
            -- encurta lixo gigante (ex: DLL, memcpy, stack)
            if #r > 64 then
                r = r:sub(1, 64) .. '...'
            end
            return r
        end

        local why = normalizeDropReason(reason)
        local extra = (why ~= '' and (' | motivo: %s'):format(why)) or ''
        Organizations:PushLog(org, user_id,
            ('Desconectou (%s) | tempo logado: %s%s'):format(os.date('%d/%m/%Y %H:%M:%S', now), fmtDuration(played), extra),
            grp or '', name)
    end
end)

function Organizations:RemUserGroup(user_id, group)
    local groupType = self.Members[user_id] and self.Members[user_id].groupType or false
    if groupType and self.MembersList[groupType] then
        self.MembersList[groupType][user_id] = nil
    end

    -- limpa infos offline
    if group then
        dbExecute('revolt_orgs/DeleteUserInfoByGroup', { user_id = user_id, organization = group })
    else
        dbExecute('revolt_orgs/DeleteUserInfo', { user_id = user_id })
    end

    self.Members[user_id] = nil
    return true
end

-- VERIFYPLAYERS: sincroniza cache com o core sem quebrar quando o core não expõe helpers
function Organizations:VerifyPlayers()
    if type(getUsers) ~= "function" then return end
    local users = getUsers()
    if type(users) ~= "table" then return end

    for user_id, src in pairs(users) do
        user_id = tonumber(user_id) or user_id

        -- pega grupos do core (varia por base)
        local plyGroups = nil
        if type(getUserMyGroups) == "function" then plyGroups = getUserMyGroups(user_id) end
        if type(plyGroups) ~= "table" and type(getUserGroups) == "function" then plyGroups = getUserGroups(user_id) end
        plyGroups = type(plyGroups) == "table" and plyGroups or {}

        -- remove do cache se não tem mais o grupo atual
        local mem = self.Members and self.Members[user_id] or nil
        if mem and mem.group and type(hasGroup) == "function" then
            if not hasGroup(user_id, mem.group) then
                self:RemUserGroup(user_id, mem.group)
            end
        end

        -- adiciona grupos válidos no cache
        for group in pairs(plyGroups) do
            if self.List and self.List[group] then
                self:AddUserGroup(user_id, { group = group, groupType = self.List[group] })
            end
        end
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TUNNELS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function getIdentitySafe(user_id, src)
    -- 1) tenta função do core (se existir)
    if type(getUserIdentity) == "function" then
        local ident = getUserIdentity(user_id)
        if type(ident) == "table" then
            return ident
        end
    end

    -- helper: tenta queries sem quebrar caso o schema não tenha certas colunas
    local function tryQuery(sql, params)
        local ok, res = pcall(function()
            return exports.oxmysql:query_async(sql, params or {})
        end)
        if ok and type(res) == "table" and res[1] then return res[1] end
        return nil
    end

    local uid = tonumber(user_id) or user_id

    -- 2) tenta pelo prepare padrão (id)
    local row = nil
    do
        local q = dbQuery('revolt_orgs/GetCharacterIdentity', { id = uid, ['@id'] = uid })
        if type(q) == "table" and q[1] then row = q[1] end
    end

    -- 3) tenta schemas alternativos (sem derrubar)
    if not row then
        row = tryQuery('SELECT * FROM characters WHERE user_id = @id LIMIT 1', { id = uid, ['@id'] = uid })
            or tryQuery('SELECT * FROM characters WHERE Passport = @id LIMIT 1', { id = uid, ['@id'] = uid })
    end

    if row then
        -- pega os campos mais comuns
        local n1 = row.name or row.firstname or row.firstName or row.nome or row.Nome or ""
        local n2 = row.name2 or row.lastname or row.lastName or row.sobrenome or row.Sobrenome or ""
        -- alguns schemas guardam tudo em um campo
        if n1 == "" and (row.fullname or row.full_name) then n1 = row.fullname or row.full_name end
        return { name = tostring(n1 or ""), firstname = tostring(n2 or "") }
    end

    -- 4) último fallback: nome do player (Steam) ou ID
    local pname = (src and GetPlayerName(src)) or ("ID "..tostring(user_id))
    return { name = pname, firstname = "" }
end

-- Expor helpers for other files (server/modules/*.lua)

_G.dbQuery = dbQuery
_G.dbExecute = dbExecute
_G.dbPrepare = dbPrepare
_G.getIdentitySafe = getIdentitySafe


-- getFaction ✅ corrigido (admin pode consultar qualquer org, não quebra com nil, logs úteis)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS: map do formato antigo -> formato esperado pela UI
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function mapUiPermissions(raw, isLeader, roleTier)
    raw = type(raw) == "table" and raw or {}
    local leader = isLeader and true or false
    roleTier = tonumber(roleTier) or 999

    -- Regra do painel:
    -- - Configurações + Logs: apenas tier 1 e tier 2
    -- - Gestão de cargos (admin_roles): apenas tier 1 (leader) ou admin
    local canSettings = (roleTier <= 2)

    return {
        -- Banco
        bank_view     = leader or raw.withdraw or raw.deposit or false,
        bank_deposit  = leader or raw.deposit or false,
        bank_withdraw = leader or raw.withdraw or false,

        -- Membros
        members_view    = true,
        members_invite  = leader or raw.invite or false,
        members_promote = leader or raw.promote or false,
        members_demote  = leader or raw.demote or false,
        members_dismiss = leader or raw.dismiss or false,

        -- Administração / Logs
        admin_roles    = leader,
        admin_settings = (leader or (canSettings and (raw.admin_settings or raw.settings or false))) and true or false,
        logs_view      = (canSettings and (leader or raw.logs_view or raw.alerts or raw.message or false)) and true or false,

        -- Metas
        goals_view = true
    }
end

function RegisterTunnel.getFaction(orgName, isAdmin)
    local src = source
    local user_id = getUserId(src)
    if not user_id then return end

    isAdmin = isAdmin and true or false
    orgName = (orgName ~= nil and tostring(orgName) ~= "" and tostring(orgName)) or nil

    -- se admin abriu uma org específica, guarda pra ações subsequentes
    if isAdmin and orgName then
        Organizations.AdminView[src] = { org = orgName }
    end

    local user = Organizations.Members and Organizations.Members[user_id] or nil

    if nameOrg and nameOrg[src] and tostring(nameOrg[src]) ~= "" then
        user = user or {}
        user.groupType = tostring(nameOrg[src])
    end

    if isAdmin and orgName then
        user = user or {}
        user.groupType = tostring(orgName)
        user.group = user.group or "Admin"
    end

    if not user or not user.groupType or tostring(user.groupType) == "" then
        return
    end

    local groupType = tostring(user.groupType)

    local identity = getIdentitySafe(user_id, src)
    local fullName = ("%s %s"):format(identity.name or "", identity.firstname or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if fullName == "" then
        fullName = GetPlayerName(src) or ("ID "..tostring(user_id))
    end

    local orgCfg = Config and Config.Groups and Config.Groups[groupType]
    if not orgCfg or type(orgCfg.List) ~= "table" then
        return
    end

    local query = dbQuery('revolt_orgs/GetOrganizationInfos', { organization = groupType })
    local dbRow = (type(query) == "table" and query[1]) or nil
    if not dbRow then
        return
    end

    -- UI NOVA espera roles no formato:
    -- { id, name, color, priority, permissions }
    -- (além de manter compat com o formato antigo quando necessário)
    local function colorFromString(str)
        str = tostring(str or "")
        local h = 0
        for i = 1, #str do
            h = (h * 31 + string.byte(str, i)) % 360
        end
        -- HSL -> HEX simples (saturação/brightness fixos)
        local s, l = 0.65, 0.52
        local c = (1 - math.abs(2 * l - 1)) * s
        local x = c * (1 - math.abs((h / 60) % 2 - 1))
        local m = l - c / 2
        local r, g, b = 0, 0, 0
        if h < 60 then r, g, b = c, x, 0
        elseif h < 120 then r, g, b = x, c, 0
        elseif h < 180 then r, g, b = 0, c, x
        elseif h < 240 then r, g, b = 0, x, c
        elseif h < 300 then r, g, b = x, 0, c
        else r, g, b = c, 0, x end
        local function to255(v) return math.floor((v + m) * 255 + 0.5) end
        return string.format("#%02X%02X%02X", to255(r), to255(g), to255(b))
    end

    local leaderGroup, listRoles = "", {}
    for group, v in pairs(orgCfg.List) do
        if type(v) == "table" then
            local tier = tonumber(v.tier) or 999
            if tier == 1 then
                leaderGroup = group
            end

            -- permissões desse cargo (se já estiverem carregadas)
            local perms = {}
            if Organizations.Permissions and Organizations.Permissions[groupType] and Organizations.Permissions[groupType][group] then
                perms = Organizations.Permissions[groupType][group]
            end

            listRoles[#listRoles + 1] = {
                id = group,
                group = group, -- compat antigo
                name = v.prefix or group,
                prefix = v.prefix or group, -- compat antigo
                priority = tier,
                tier = tier,
                color = colorFromString(group),
                permissions = type(perms) == "table" and perms or {}
            }
        end
    end

    -- Se existir ordem salva no DB (Permissions._roleOrder), usa ela para o painel.
    local savedOrder = Organizations.Permissions
        and Organizations.Permissions[groupType]
        and Organizations.Permissions[groupType]._roleOrder

    if type(savedOrder) == "table" then
        local pos = {}
        for i = 1, #savedOrder do
            local rid = tostring(savedOrder[i] or "")
            if rid ~= "" then pos[rid] = i end
        end
        for i = 1, #listRoles do
            local rid = tostring(listRoles[i].id or "")
            if pos[rid] then
                listRoles[i].priority = pos[rid]
            end
        end
    end

    table.sort(listRoles, function(a, b)
        return (tonumber(a.priority) or 999) < (tonumber(b.priority) or 999)
    end)

    local leader = "Ninguem"
    local totalMember, onlineMembers = 0, 0

    -- (bugfix) bind do placeholder varia por wrapper; enviamos org e @org para garantir.
    local _org = tostring(groupType or ""):gsub("^%s+", ""):gsub("%s+$", "")
    -- usa comparação case-insensitive para compat com dados legados (FRANCA vs Franca)
    local rows = dbQuery("SELECT user_id, `group` FROM revolt_orgs_members WHERE LOWER(org)=LOWER(@org)", { org = _org, ['@org'] = _org }) or {}
    for _, r in ipairs(rows) do
        local pid = tonumber(r.user_id)
        if pid then
            totalMember = totalMember + 1
            if getUserSource(pid) then 
                onlineMembers = onlineMembers + 1 
            end
            if leaderGroup ~= "" and tostring(r["group"] or r.group or "") == leaderGroup then
                local ident2 = getIdentitySafe(pid, getUserSource(pid))
                local nm = ((ident2 and ident2.name) or "") .. " " .. ((ident2 and ident2.firstname) or "")
                nm = nm:gsub("^%s+", ""):gsub("%s+$", "")
                if nm ~= "" then 
                    leader = ("%s #%d"):format(nm, pid) 
                end
            end
        end
    end

    Organizations.hasOppenedOrg = Organizations.hasOppenedOrg or {}
    Organizations.hasOppenedOrg[groupType] = Organizations.hasOppenedOrg[groupType] or {}
    Organizations.hasOppenedOrg[groupType][user_id] = src

    local alerts = {}
    if dbRow.alerts and tostring(dbRow.alerts) ~= "" then
        local ok, decoded = pcall(json.decode, dbRow.alerts)
        if ok and type(decoded) == "table" then alerts = decoded end
    end

    local perms = {}
    if Organizations.Permissions and Organizations.Permissions[groupType] and user.group and Organizations.Permissions[groupType][user.group] then
        perms = Organizations.Permissions[groupType][user.group]
    end

    local payday = Organizations.payDayOrg and Organizations.payDayOrg[groupType] or nil
    -- ORG PREMIUM (VIP FAC)
    local vipName = tostring(dbRow.vip_name or dbRow.vipName or "")
    local vipExpires = tonumber(dbRow.vip_expires_at or dbRow.vip_expires or dbRow.vipExpires or 0) or 0
    local vipSalary = tonumber(dbRow.vip_salary or dbRow.vipSalary or 0) or 0
    local now = os.time()
    local vipActive = (vipName ~= "") and (vipExpires > now)
    local vipDaysLeft = vipActive and math.max(0, math.ceil((vipExpires - now) / 86400)) or 0
    local orgPremium = {
        active = vipActive,
        name = vipName,
        expiresAt = vipExpires,
        daysLeft = vipDaysLeft,
        salary = vipSalary
    }


    local goalReward = 1000
    if Organizations.goalsConfig and Organizations.goalsConfig[groupType]
        and Organizations.goalsConfig[groupType].info
        and Organizations.goalsConfig[groupType].info.defaultReward then
        goalReward = Organizations.goalsConfig[groupType].info.defaultReward
    end

    return {
        success = true,
        org = groupType,
        organizationName = groupType,
        organization = { name = groupType },
        user_id = user_id,
        id = user_id, -- alias compat (algumas UIs usam "id")
        logo = dbRow.logo or (Config.Main and Config.Main.serverLogo) or "",
        serverIcon = (Config.Main and Config.Main.serverLogo) or "",
        banner = dbRow.banner or "",
        store = (Config.Main and Config.Main.storeUrl) or "",
        orgName = groupType,
        org = groupType, -- alias compat
        orgBalance = tonumber(dbRow.bank) or 0,
        name = fullName,
        playerBalance = (type(getBankMoney) == "function" and getBankMoney(user_id)) or 0,
        roles = listRoles,
        group = roleLabel,        -- badge do cargo (prefix)
        groupFull = user.group,   -- compat/debug
        salary = (orgPremium.active and (orgPremium.salary > 0 and orgPremium.salary or (payday and payday.amount or 0))) or false,
        nextPayment = (orgPremium.active and payday and (payday.time - os.time())) or false,
        nextPaymentMax = (orgPremium.active and payday and (payday.salaryTime * 60)) or false,
        goalReward = goalReward,
        discord = dbRow.discord or "",
        premium = orgPremium,

        leader = leader,
        members = totalMember,
        membersOnline = onlineMembers,
        warnings = alerts,
        permissions = mapUiPermissions(perms, isLeader, roleTier),
        permissions_raw = perms,
        admin = isAdmin and true or false
    }
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG (UI): SetConfig (banner/logo/discord)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function RegisterTunnel.setConfig(patch)
    local src = source
    local ctx = Organizations.getContext and Organizations:getContext(src) or nil
    if not ctx or not ctx.user_id or not ctx.org then return false end

    patch = type(patch) == "table" and patch or {}
    local org = tostring(ctx.org or "")
    if org == "" then return false end

    -- Permissão: leader ou admin
    local isLeader = false
    if ctx.isAdmin == true then
        isLeader = true
    else
        local user = Organizations.Members and Organizations.Members[ctx.user_id] or { group = ctx.group }
        local tier = 999
        if Config and Config.Groups and Config.Groups[org] and Config.Groups[org].List and user.group and Config.Groups[org].List[user.group] then
            tier = tonumber(Config.Groups[org].List[user.group].tier) or 999
        end
        isLeader = (tier == 1)
    end
    if not isLeader then return false end

    local banner = patch.banner ~= nil and tostring(patch.banner) or nil
    local logo   = patch.logo   ~= nil and tostring(patch.logo)   or nil
    local discord= patch.discord~= nil and tostring(patch.discord)or nil

    -- Sanitiza (evita lixo gigante)
    local function trim(s)
        s = tostring(s or "")
        s = s:gsub("^%s+",""):gsub("%s+$","")
        return s
    end
    if banner ~= nil then banner = trim(banner) end
    if logo   ~= nil then logo   = trim(logo) end
    if discord~= nil then discord= trim(discord) end

    -- Atualiza somente campos enviados
    local sets, params = {}, { organization = org }
    if banner ~= nil then sets[#sets+1] = "banner=@banner"; params.banner = banner end
    if logo   ~= nil then sets[#sets+1] = "logo=@logo"; params.logo = logo end
    if discord~= nil then sets[#sets+1] = "discord=@discord"; params.discord = discord end
    if #sets == 0 then return false end

    local sql = ("UPDATE revolt_orgs_info SET %s WHERE organization=@organization"):format(table.concat(sets, ","))
    dbExecute(sql, params)

    return true
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- BANK (UI compat): GetBankInfo / DepositMoney / WithdrawMoney / TransferMoney
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if type(BANK) ~= "table" then BANK = {} end
BANK.cooldown = BANK.cooldown or {}

if type(BANK.generateLog) ~= "function" then
    function BANK:generateLog(historic, data)
        historic = type(historic) == "table" and historic or {}
        if #historic > 20 then table.remove(historic, 1) end
        historic[#historic + 1] = data
        return historic
    end
end

function RegisterTunnel.getBankInfo()
    local src = source
    local ctx = Organizations.getContext and Organizations:getContext(src) or nil
    if not ctx or not ctx.user_id or not ctx.org then return {} end
    local user_id = ctx.user_id

    local user = Organizations.Members and Organizations.Members[user_id] or { groupType = ctx.org, group = ctx.group }

    local q = dbQuery('revolt_orgs/bank/getinfo', { organization = user.groupType }) or {}
    if not q[1] then return {} end

    local historic = {}
    if q[1].bank_historic and tostring(q[1].bank_historic) ~= "" then
        local ok, decoded = pcall(json.decode, q[1].bank_historic)
        if ok and type(decoded) == "table" then historic = decoded end
    end

    local orgBank = tonumber(q[1].bank) or 0
    local plyBank = (type(getBankMoney)=="function" and getBankMoney(user_id)) or 0

    -- Normaliza histórico para PT-BR (mantém type_code para compat)
    local function typeLabel(code)
        code = tostring(code or "")
        if code == "deposit" then return "Depósito" end
        if code == "withdraw" or code == "withdrawal" then return "Saque" end
        if code == "transfer" then return "Transferência" end
        if code == "transfer_in" then return "Transferência recebida" end
        if code == "goal" or code == "META DIARIA" then return "Meta diária" end
        return (code ~= "" and code) or "Movimentação"
    end

    for i = 1, #historic do
        local e = historic[i]
        if type(e) == "table" then
            local code = e.type_code or e.type
            if e.type_code == nil then
                local t = tostring(e.type or "")
                if t == "Depósito" then code = "deposit" end
                if t == "Saque" then code = "withdrawal" end
                if t == "Transferência" then code = "transfer" end
            end
            e.type_code = tostring(code or "")
            e.type = typeLabel(code)
            e.amount = tonumber(e.amount or e.value) or e.amount or e.value
        end
    end

    
    -- Busca info completa da organização (banner/logo/discord/vip)
    local orgInfo = nil
    local infoRow = dbQuery('revolt_orgs/GetOrganizationInfos', { organization = ctx.org }) or {}
    if infoRow[1] then orgInfo = infoRow[1] end

    -- Contagem de membros (persistente) + online (via getUserSource)
    local totalMembers, onlineMembers = 0, 0
    local rows = dbQuery('SELECT user_id FROM revolt_orgs_members WHERE org = @org', { org = ctx.org }) or {}
    for _, r in ipairs(rows) do
        local pid = tonumber(r.user_id or r["user_id"])
        if pid then
            totalMembers = totalMembers + 1
            if type(getUserSource) == "function" and getUserSource(pid) then
                onlineMembers = onlineMembers + 1
            end
        end
    end

    -- Leader: tenta obter pelo membro com tier 1 (se existir)
    local leaderName = ""
    local leaderRows = dbQuery('SELECT user_id FROM revolt_orgs_members WHERE org = @org AND tier = 1 LIMIT 1', { org = ctx.org }) or {}
    local leaderId = leaderRows[1] and tonumber(leaderRows[1].user_id or leaderRows[1]["user_id"]) or nil
    if leaderId and type(getIdentitySafe) == "function" then
        local ident = getIdentitySafe(leaderId, type(getUserSource)=="function" and getUserSource(leaderId) or nil)
        if ident then
            leaderName = ((ident.name or "") .. " " .. (ident.firstname or "")):gsub("^%s+","")
        end
    end

    return {
        success = true,
        org = ctx.org,
        organizationName = ctx.org,
        organization = {
            name = ctx.org,
            banner = (orgInfo and (orgInfo.banner or orgInfo.Banner)) or "",
            logo = (orgInfo and (orgInfo.logo or orgInfo.Logo)) or "",
            discord = (orgInfo and (orgInfo.discord or orgInfo.Discord)) or "",
            leader = leaderName or "",
            members = totalMembers or 0,
            membersOnline = onlineMembers or 0,
            balance = orgBank, orgBalance = orgBank, bank = orgBank,
            bank_historic = historic,
            premium = {
                name = (orgInfo and (orgInfo.vip_name or orgInfo.name)) or nil,
                expiresAt = tonumber(orgInfo and orgInfo.vip_expires_at) or 0,
                salary = tonumber(orgInfo and orgInfo.vip_salary) or 0
            }
        },
        playerBalance = plyBank,
        bankHistoric = historic
    }

end

function RegisterTunnel._bankTransaction(payload)
    local src = source
    sdbg('bankTransaction:call', { src = src, payload = payload })
    local ctx = Organizations.getContext and Organizations:getContext(src) or nil
    if not ctx or not ctx.user_id or not ctx.org then return false end
    local user_id = ctx.user_id

    local user = Organizations.Members and Organizations.Members[user_id] or { groupType = ctx.org, group = ctx.group }

    payload = type(payload)=="table" and payload or {}

    local ident = getIdentitySafe(user_id, src)
    local fullName = ((ident and ident.name) or "") .. " " .. ((ident and ident.firstname) or "")
    fullName = fullName:gsub("^%s+", ""):gsub("%s+$", "")
    if fullName == "" then fullName = GetPlayerName(src) or ("ID "..tostring(user_id)) end
    local t = tostring(payload.type or "")
    local amount = tonumber(payload.amount) or 0
    if amount <= 0 then return false end

    if BANK.cooldown[user.groupType] and (BANK.cooldown[user.groupType] - os.time()) > 0 then
        return false
    end
    BANK.cooldown[user.groupType] = os.time() + 2

    local rawPerms = (Organizations.Permissions and Organizations.Permissions[user.groupType] and user.group and Organizations.Permissions[user.groupType][user.group]) or {}
    local isLeader = (ctx.isAdmin == true)
    if Config and Config.Groups and Config.Groups[user.groupType] and Config.Groups[user.groupType].List and Config.Groups[user.groupType].List[user.group] then
        isLeader = isLeader or (tonumber(Config.Groups[user.groupType].List[user.group].tier) == 1)
    end


    local roleTier = 999
    if Config and Config.Groups and Config.Groups[user.groupType] and Config.Groups[user.groupType].List and Config.Groups[user.groupType].List[user.group] then
        roleTier = tonumber(Config.Groups[user.groupType].List[user.group].tier) or 999
    end
    local q = dbQuery('revolt_orgs/bank/getinfo', { organization = user.groupType }) or {}
    if not q[1] then return false end

    local orgBank = tonumber(q[1].bank) or 0
    local historic = {}
    if q[1].bank_historic and tostring(q[1].bank_historic) ~= "" then
        local ok, decoded = pcall(json.decode, q[1].bank_historic)
        if ok and type(decoded) == "table" then historic = decoded end
    end

    local function typeLabel(code)
        code = tostring(code or "")
        if code == "deposit" then return "Depósito" end
        if code == "withdraw" or code == "withdrawal" then return "Saque" end
        if code == "transfer" then return "Transferência" end
        if code == "transfer_in" then return "Transferência recebida" end
        return "Movimentação"
    end

    if t == "deposit" then
        if not (isLeader or rawPerms.deposit) then return false end
        if type(tryGetInventoryItem)=="function" then
            -- sem inventário definido aqui; usar banco do player se existir
        end
        -- tira do player bank e coloca na fac
        if type(getBankMoney)=="function" and type(setBankMoney)=="function" then
            local plyBank = getBankMoney(user_id)
            if plyBank < amount then return false end
            setBankMoney(user_id, plyBank - amount)
        elseif type(tryFullPayment)=="function" then
            if not tryFullPayment(user_id, amount) then return false end
        end

        orgBank = orgBank + amount
        historic = BANK:generateLog(historic, { name = fullName or user.groupType, type = typeLabel("deposit"), type_code = "deposit", amount = amount, balanceAfter = orgBank, timestamp = os.time(), date = os.date("%d/%m/%Y %X") })

    elseif t == "withdraw" then
        if not (isLeader or rawPerms.withdraw) then return false end
        if orgBank < amount then return false end
        orgBank = orgBank - amount

        if type(addBankMoney)=="function" then
            addBankMoney(user_id, amount)
        elseif type(giveBankMoney)=="function" then
            giveBankMoney(user_id, amount)
        elseif type(setBankMoney)=="function" and type(getBankMoney)=="function" then
            setBankMoney(user_id, getBankMoney(user_id) + amount)
        end

        historic = BANK:generateLog(historic, { name = fullName or user.groupType, type = typeLabel("withdrawal"), type_code = "withdrawal", amount = amount, balanceAfter = orgBank, timestamp = os.time(), date = os.date("%d/%m/%Y %X") })

    elseif t == "transfer" then
        if not isLeader then return false end
        local toOrg = tostring(payload.toOrg or "")
        if toOrg == "" then return false end
        if orgBank < amount then return false end
        orgBank = orgBank - amount

        historic = BANK:generateLog(historic, { name = toOrg, type = typeLabel("transfer"), type_code = "transfer", amount = amount, balanceAfter = orgBank, timestamp = os.time(), date = os.date("%d/%m/%Y %X") })
        -- credita destino
        local q2 = dbQuery('revolt_orgs/bank/getinfo', { organization = toOrg }) or {}
        if q2[1] then
            local destBank = tonumber(q2[1].bank) or 0
            local destHist = {}
            if q2[1].bank_historic and tostring(q2[1].bank_historic) ~= "" then
                local ok, decoded = pcall(json.decode, q2[1].bank_historic)
                if ok and type(decoded) == "table" then destHist = decoded end
            end
            destBank = destBank + amount
            destHist = BANK:generateLog(destHist, { name = user.groupType, type = typeLabel("transfer_in"), type_code = "transfer_in", amount = amount, balanceAfter = destBank, timestamp = os.time(), date = os.date("%d/%m/%Y %X") })
            dbExecute('revolt_orgs/bank/updateBank', { organization = toOrg, bank = destBank, historic = json.encode(destHist) })
        end
    else
        return false
    end

    -- Auditoria
    if Organizations and Organizations.PushLog then
        local action = (t == 'deposit' and 'Depósito') or ((t == 'withdraw' or t == 'withdrawal') and 'Saque') or 'Transferência'
        local extra = (t == 'transfer' and (' para ' .. tostring(payload.toOrg or ''))) or ''
        Organizations:PushLog(user.groupType, user_id, (action .. extra .. ' - R$ ' .. tostring(amount)), user.group, fullName)
    end

    dbExecute('revolt_orgs/bank/updateBank', { organization = user.groupType, bank = orgBank, historic = json.encode(historic) })
    return true
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- MEMBERS (UI compat): getMembers (lista para NUI + hidratação inicial)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function RegisterTunnel.getMembers()
    local src = source
    local ctx = Organizations.getContext and Organizations:getContext(src) or nil
    if not ctx or not ctx.user_id or not ctx.org then
        return { success = false, members = {}, count = 0 }
    end

    local org = tostring(ctx.org)
    local orgCfg = Config and Config.Groups and Config.Groups[org]
    local rolePrefix = (orgCfg and orgCfg.List) or {}

    -- Busca membros + infos extras em 1 query (evita N queries)
    local rows = dbQuery([[
        SELECT 
            m.user_id as user_id,
            m.`group` as `group`,
            pi.joindate as joindate,
            pi.lastlogin as lastlogin,
            pi.timeplayed as timeplayed
        FROM revolt_orgs_members m
        LEFT JOIN revolt_orgs_player_infos pi
            ON pi.user_id = m.user_id
        WHERE LOWER(m.org) = LOWER(@org)
    ]], { org = org, ['@org'] = org }) or {}

    local members = {}
    for _, r in ipairs(rows) do
        local uid = tonumber(r.user_id)
        if uid then
            local src2 = getUserSource(uid)
            local ident = getIdentitySafe(uid, src2)
            local full = ("%s %s"):format(ident.name or "", ident.firstname or ""):gsub("^%s+", ""):gsub("%s+$", "")
            if full == "" then full = ("ID "..tostring(uid)) end

            local g = tostring(r["group"] or r.group or "")
            local prefix = g
            if type(rolePrefix[g]) == "table" and rolePrefix[g].prefix then
                prefix = rolePrefix[g].prefix
            end

            members[#members+1] = {
                user_id = uid,
                id = uid,
                name = full,
                group = g,
                role = prefix,
                online = src2 ~= nil,
                joindate = tonumber(r.joindate) or 0,
                lastlogin = tonumber(r.lastlogin) or 0,
                timeplayed = tonumber(r.timeplayed) or 0
            }
        end
    end

    -- Ordena: online primeiro, depois nome
    table.sort(members, function(a,b)
        if a.online ~= b.online then return a.online end
        return tostring(a.name) < tostring(b.name)
    end)

    return {
        success = true,
        org = org,
        organizationName = org,
        count = #members,
        members = members
    }
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- WARNS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function WARNS:addWarning(organization, data)
    local query = dbQuery('revolt_orgs/getAlerts', { organization = organization })
    if #query == 0 then return end

    local historic = json.decode(query[1].alerts or "{}") or {}
    if #historic > 10 then table.remove(historic, 1) end
    historic[#historic + 1] = data

    dbExecute('revolt_orgs/updateAlerts', { organization = organization, alerts = json.encode(historic) })
    return historic
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CACHE FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Organizations:FormatConfig()
    local first = {}
    for orgName in pairs(Config.Groups or {}) do
        for Group in pairs(Config.Groups[orgName].List or {}) do
            self.List[Group] = orgName

            if (Config.Main and Config.Main.createAutomaticOrganizations) then
                if not first[orgName] then
                    first[orgName] = true
                    exports["oxmysql"]:execute_async([[INSERT IGNORE INTO revolt_orgs_info(organization) VALUES(?)]], { orgName })
                end
            end
        end
    end

    self:GenerateCache()
end

function Organizations:GenerateCache()
    local time = os.time()

    local query = dbQuery('revolt_orgs/GetUsersGroup', {})
    local FormatUser = {}

    if not MIRTIN_MULTICHAR then
        for i = 1, #query do
            local ply = query[i]
            local uid = tonumber(ply.user_id or ply.Passport or ply.passport or ply.id)
            if uid then
                local plyData = json.decode(ply.dvalue or "{}") or {}
                local rawGroups = plyData.groups or plyData.Groups or plyData.group or {}
                local gmap = {}

                if type(rawGroups) == "table" then
                    for k, v in pairs(rawGroups) do
                        if type(k) == "number" then
                            -- array: {"Grupo A","Grupo B"}
                            if type(v) == "string" and v ~= "" then gmap[v] = true end
                        else
                            -- map: {["Grupo A"]=true} ou {["Grupo A"]="true"}
                            if v == true then gmap[tostring(k)] = true end
                        end
                    end
                end

                FormatUser[uid] = gmap
            end
        end
    else
        -- MultiChar: tenta ler "groups" ou "dvalue" dependendo do schema
        for i = 1, #query do
            local ply = query[i]
            local uid = tonumber(ply.user_id or ply.Passport or ply.passport or ply.id)
            if uid then
                local raw = ply.groups or ply.dvalue or "{}"
                local plyData = json.decode(raw) or {}
                local rawGroups = plyData.groups or plyData or {}
                local gmap = {}

                if type(rawGroups) == "table" then
                    for k, v in pairs(rawGroups) do
                        if type(k) == "number" then
                            if type(v) == "string" and v ~= "" then gmap[v] = true end
                        else
                            if v == true then gmap[tostring(k)] = true end
                        end
                    end
                end

                FormatUser[uid] = gmap
            end
        end
    end

    for user_id, groups in pairs(FormatUser) do
        for groupName in pairs(groups) do
            if self.List[groupName] then
                self:AddUserGroup(user_id, { group = groupName, groupType = self.List[groupName] })
            end
        end
    end


    self:VerifyPlayers()
    self:GenerateCachePermissions()
    self:GenerateCacheGoals()
end

function Organizations:GenerateCacheInfos()
    local query = dbQuery('revolt_orgs/GetAllUsersInfo', {})
    for i = 1, #query do
        local ply = query[i]
        if self.Members[ply.user_id] then
            self.Members[ply.user_id].joindate = ply.joindate
            self.Members[ply.user_id].lastlogin = ply.lastlogin
            self.Members[ply.user_id].timeplayed = ply.timeplayed
        else
            dbExecute('revolt_orgs/DeleteUserInfo', { user_id = ply.user_id })
        end
    end
end

function Organizations:GenerateCachePermissions()
    local query = dbQuery('revolt_orgs/GetOrgsPermissions', {})
    for i = 1, #query do
        local v = query[i]
        if v and Config.Groups[v.organization] then
            if v.permissions == "{}" then
                self.Permissions[v.organization] = self.Permissions[v.organization] or {}
                for Group in pairs(Config.Groups[v.organization].List) do
                    self.Permissions[v.organization][Group] = self.Permissions[v.organization][Group] or {}
                    for permission in pairs(Config.defaultPermissions or {}) do
                        if Config.Groups[v.organization].List[Group].tier == 1 then
                            self.Permissions[v.organization][Group].leader = true
                            self.Permissions[v.organization][Group][permission] = true
                        else
                            self.Permissions[v.organization][Group][permission] = false
                        end
                    end
                end
                dbExecute('revolt_orgs/UpdatePermissions', { organization = v.organization, permissions = json.encode(self.Permissions[v.organization]) })
            else
                self.Permissions[v.organization] = json.decode(v.permissions or "{}") or {}
            end
        end
    end


-- Normaliza permissões (não sobrescreve configs salvas)
for orgName, orgCfg in pairs(Config.Groups or {}) do
    self.Permissions[orgName] = type(self.Permissions[orgName]) == "table" and self.Permissions[orgName] or {}
    local changed = false

    for groupName, gcfg in pairs((orgCfg and orgCfg.List) or {}) do
        self.Permissions[orgName][groupName] = type(self.Permissions[orgName][groupName]) == "table" and self.Permissions[orgName][groupName] or {}
        local p = self.Permissions[orgName][groupName]
        local tier = tonumber(gcfg.tier) or 999

        -- líder sempre tem flag leader=true, mas NÃO força todas permissões como true
        if tier == 1 and p.leader ~= true then
            p.leader = true
            changed = true
        end

        -- logs_view default apenas para tiers <= 3 (se não existir ainda)
        if p.logs_view == nil and tier <= 3 then
            p.logs_view = true
            changed = true
        end
    end

    if changed then
        dbExecute('revolt_orgs/UpdatePermissions', { organization = orgName, permissions = json.encode(self.Permissions[orgName]) })
    end
end
end

function Organizations:GenerateCacheGoals()
    local query = dbQuery('revolt_orgs/GetGoalsConfig', {})
    for i = 1, #query do
        local v = query[i]
        if v and Config.Groups[v.organization] and Config.Groups[v.organization].Config and Config.Groups[v.organization].Config.Goals then
            local data = json.decode(v.config_goals or "{}") or {}
            self.goalsConfig[v.organization] = data
        end
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------



local _openCooldown = {} 
RegisterCommand(Config.Main.cmd or "painelfac", function(source, args) 
    local src = source
    local user_id = getUserId(src)

    if not user_id then return end 
    
    local now = os.time() 
    if _openCooldown[user_id] and _openCooldown[user_id] > now then return end 
    
    _openCooldown[user_id] = now + 2 
    local user = Organizations.Members and Organizations.Members[user_id] 
    if not user or not user.groupType then 
        TriggerClientEvent("Notify", src, "negado", "Você não faz parte de nenhuma organização.", 5000) 
        return 
    end 
    
    TriggerClientEvent("revolt_orgs:requestOpen", src, user.groupType, false)
end) 
    
RegisterCommand(Config.Main.cmdAdm or "paineladmin", function(source, args) 
    local src = source local org = args[1] or "" local user_id = getUserId(src) 
        
    local _hasAdmin = false if type(HasGroup) == "function" then 
        _hasAdmin = HasGroup(user_id, "Admin") 
    end 
        
    if not _hasAdmin then 
        return 
    end 

    -- guarda contexto do admin (para ações do painel mirarem esta org)
    Organizations.AdminView[src] = { org = org }
        
    TriggerClientEvent("revolt_orgs:requestOpen", src, org, true) 
end) 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL: close (evita erro no client ao fechar) 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

function RegisterTunnel.close() 
    local src = source local user_id = getUserId(src) 
    if not user_id then 
        return true 
    end 
    
    local user = Organizations.Members and Organizations.Members[user_id] 
    
    if user and user.groupType and Organizations.hasOppenedOrg and Organizations.hasOppenedOrg[user.groupType] then 
        Organizations.hasOppenedOrg[user.groupType][user_id] = nil 
    end

    -- limpa contexto admin
    if Organizations.AdminView then
        Organizations.AdminView[src] = nil
    end
    return true 
end

-- Refresh helper: notifica todos membros online da org para recarregar dados (sem precisar ensure)
function Organizations:RefreshOrg(org)
    if not org or org == "" then return end
    local rows = dbQuery("SELECT user_id FROM revolt_orgs_members WHERE org=@org", { org = tostring(org) }) or {}
    for _, r in ipairs(rows) do
        local uid = tonumber(r.user_id)
        if uid then
            local src = getUserSource(uid)
            if src then
                TriggerClientEvent("revolt_orgs:refresh", src, { reason = "org_update", org = tostring(org), at = os.time() })
            end
        end
    end
end

local function PainelBootstrap()
    -- 1) garante tabelas (se você quiser que crie automaticamente)
    dbExecute('revolt_orgs/CreateTable1')
    dbExecute('revolt_orgs/CreateTable2')
    -- 1.1) migrações (colunas novas em installs antigos)
    dbExecute([[ALTER TABLE `revolt_orgs_info` ADD COLUMN IF NOT EXISTS `banner` text DEFAULT NULL]])
    dbExecute([[ALTER TABLE `revolt_orgs_info` ADD COLUMN IF NOT EXISTS `vip_name` varchar(50) DEFAULT NULL]])
    dbExecute([[ALTER TABLE `revolt_orgs_info` ADD COLUMN IF NOT EXISTS `vip_expires_at` int(11) DEFAULT NULL]])
    dbExecute([[ALTER TABLE `revolt_orgs_info` ADD COLUMN IF NOT EXISTS `vip_salary` int(11) DEFAULT 0]])
    dbExecute('revolt_orgs/CreateTable3')
    dbExecute('revolt_orgs/CreateTable4')
    dbExecute('revolt_orgs/CreateTable5')

    -- 1.2) migrações para sessão (quit + tempo logado)
    dbExecute([[ALTER TABLE `revolt_orgs_player_infos` ADD COLUMN IF NOT EXISTS `lastlogout` int(11) DEFAULT 0]])
    dbExecute([[ALTER TABLE `revolt_orgs_members` ADD COLUMN IF NOT EXISTS `lastlogout` int(11) DEFAULT 0]])

    -- 2) monta Config → List + cria orgs no DB (se habilitado) + gera cache
    if Organizations and Organizations.FormatConfig then
        Organizations:FormatConfig()
    else
    end
end

AddEventHandler('onResourceStart', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    CreateThread(function()
        Wait(1500) -- dá tempo do oxmysql + revolt subirem
        PainelBootstrap()
    end)
end)


-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- VIP FAC (ORG PREMIUM)
-- /setviporg ORG "VIP GOLD" 30 5000
-- /setviporg ORG none 0 0   (remove)
-------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("setviporg", function(source, args)
    local src = source
    local user_id = getUserId(src)
    if not user_id then return end

    local _hasAdmin = false
    if type(HasGroup) == "function" then
        _hasAdmin = HasGroup(user_id, "Admin")
    end
    if not _hasAdmin then
        TriggerClientEvent("Notify", src, "negado", "Sem permissão.", 5000)
        return
    end

    local org = tostring(args[1] or "")
    if org == "" then
        TriggerClientEvent("Notify", src, "negado", "Uso: /setviporg ORG VIPNAME DIAS SALARIO", 8000)
        return
    end

    local days = tonumber(args[#args-1] or 0) or 0
    local salary = tonumber(args[#args] or 0) or 0

    local nameParts = {}
    for i = 2, (#args - 2) do
        nameParts[#nameParts+1] = tostring(args[i])
    end
    local vip_name = table.concat(nameParts, " ")
    vip_name = vip_name:gsub("^%s+", ""):gsub("%s+$", "")

    -- allow: /setviporg ORG none 0 0
    if vip_name == "" or vip_name:lower() == "none" or days <= 0 then
        vip_name = nil
        days = 0
        salary = 0
    end

    local vip_expires_at = nil
    if vip_name then
        vip_expires_at = os.time() + (days * 86400)
    end

    dbExecute('revolt_orgs/updateOrgVip', {
        organization = org,
        vip_name = vip_name,
        vip_expires_at = vip_expires_at,
        vip_salary = salary
    })

    if Organizations and Organizations.RefreshOrgInfo then
        Organizations:RefreshOrgInfo(org)
    end

    if Organizations and Organizations.PushLog then
        local msg = vip_name and ("Setou VIP da org (%s) por %d dia(s) / salário %d"):format(vip_name, days, salary) or "Removeu VIP da org"
        Organizations:PushLog(org, user_id, msg)
    end

    TriggerClientEvent("Notify", src, "sucesso", "VIP da organização atualizado.", 5000)
end)