local function sdbg(tag, data)
    local ok, j = pcall(json.encode, data or {})
    print(('[revolt_orgs][SERVER][%s] %s'):format(tag, ok and j or tostring(data)))
end

-- Ensure prepares
CreateThread(function()
    -- mantém compat com a tabela existente (algumas versões não têm id AUTOINCREMENT)
    dbPrepare('revolt_orgs_v2/GetLogs', [[
        SELECT organization, user_id, role, name, description, date
        FROM revolt_orgs_logs
        WHERE organization = @organization
        ORDER BY (expire_at IS NULL), expire_at DESC
        LIMIT 200
    ]])
end)

local function parseDateToMs(dateStr)
    -- aceita "dd/mm/yyyy hh:mm:ss" (fallback: agora)
    if type(dateStr) ~= 'string' then return os.time() * 1000 end
    local d,m,y,h,mi,s = dateStr:match('^(%d%d)/(%d%d)/(%d%d%d%d)%s+(%d%d):(%d%d):(%d%d)$')
    if not d then
        d,m,y = dateStr:match('^(%d%d)/(%d%d)/(%d%d%d%d)$')
        h,mi,s = '00','00','00'
    end
    if d then
        local t = os.time({ year=tonumber(y), month=tonumber(m), day=tonumber(d), hour=tonumber(h), min=tonumber(mi), sec=tonumber(s) })
        return (t or os.time()) * 1000
    end
    return os.time() * 1000
end

-- API usada por outras rotas
function Organizations:PushLog(org, user_id, description, role, name)
    org = tostring(org or '')
    if org == '' then return end
    user_id = tonumber(user_id) or 0
    description = tostring(description or '')
    if description == '' then return end

    -- grava direto (sem depender de id)
    dbExecute("INSERT INTO revolt_orgs_logs (organization, user_id, role, name, description, date, expire_at) VALUES (@org, @uid, @role, @name, @desc, @date, @exp)", {
        org = org,
        uid = user_id,
        role = tostring(role or ''),
        name = tostring(name or ''),
        desc = description,
        date = os.date('%d/%m/%Y %H:%M:%S'),
        exp = os.time() + (60 * 60 * 24 * 30)
    })
end

-- NUI
function RegisterTunnel.getLogs()
    local source = source
    sdbg('getLogs:call', { src = source })
    local ctx = Organizations.getContext and Organizations:getContext(source) or nil
    if not ctx or not ctx.org then return {} end

    local rows = dbQuery('revolt_orgs_v2/GetLogs', { organization = ctx.org }) or {}

    local list = {}
    for idx, r in ipairs(rows) do
        local uid = tonumber(r.user_id) or 0
        local executorName = tostring(r.name or '')
        local executorRole = tostring(r.role or '-')

        if executorName == '' then
            local ident = getIdentitySafe(uid)
            if ident and ident.name then
                executorName = (ident.name .. ' ' .. (ident.firstname or ''))
            else
                executorName = ('#%s'):format(uid)
            end
        end

        local desc = tostring(r.description or '')
        local action = desc
        local severity = 'low'
        if desc:lower():find('demitiu') or desc:lower():find('rebaix') or desc:lower():find('promoveu') then
            severity = 'medium'
            action = 'Membros'
        elseif desc:lower():find('deposit') or desc:lower():find('saque') or desc:lower():find('transfer') then
            severity = 'medium'
            action = 'Banco'
        elseif desc:lower():find('meta') then
            severity = 'high'
            action = 'Metas'
        end

        list[#list+1] = {
            id = idx,
            action = action,
            executor = executorName,
            executorRole = executorRole ~= '' and executorRole or '-',
            target = ctx.org,
            details = desc,
            severity = severity,
            timestamp = parseDateToMs(r.date)
        }
    end

    sdbg('getLogs:ret', { org = ctx.org, count = #list })
    return { success = true, org = ctx.org, count = #list, logs = list, list = list }
end
