

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dbPrepare('revolt_orgs/bank/getinfo', 'SELECT bank,bank_historic FROM revolt_orgs_info WHERE organization = @organization')
dbPrepare('revolt_orgs/bank/updateBank', 'UPDATE revolt_orgs_info SET bank = @bank, bank_historic = @historic WHERE organization = @organization')
dbPrepare('revolt_orgs/updateConfigGoals', 'UPDATE revolt_orgs_info SET config_goals = @config_goals WHERE organization = @organization')
dbPrepare('revolt_orgs/myGoals', ' SELECT * FROM revolt_orgs_goals WHERE user_id = @user_id and organization = @organization and day = @day and month = @month ')
dbPrepare('revolt_orgs/updateFarm', 'UPDATE revolt_orgs_goals SET step = @step, reward_step = @reward_step WHERE user_id = @user_id AND organization = @organization AND month = @month AND day = @day')
dbPrepare('revolt_orgs/getDailyFarms', 'SELECT * FROM revolt_orgs_goals WHERE organization = @organization and day = @day and month = @month ORDER BY amount DESC')
dbPrepare('revolt_orgs/addPlayerFarm', 'INSERT IGNORE INTO revolt_orgs_goals(organization, user_id, item, amount, day, month) VALUES(@organization, @user_id, @item, @amount, @day, @month) ON DUPLICATE KEY UPDATE amount = amount + @amount;')

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local GOALS = {
    cooldown = {}
}

local function safeDecode(data)
    if data == nil then return nil end
    if type(data) == 'table' then return data end
    if type(data) == 'string' and data ~= '' then
        local ok, decoded = pcall(json.decode, data)
        if ok then return decoded end
    end
    return nil
end

-- Compat: lê config de metas em formatos diferentes (info.itens | itens | items)
local function getGoalsInfo(groupType)
    local cfg = Organizations.goalsConfig and Organizations.goalsConfig[groupType] or nil
    if not cfg then return nil, {} end

    local info = cfg.info or cfg
    local itens = (type(info.itens) == 'table' and info.itens)
        or (type(info.items) == 'table' and info.items)
        or {}

    return info, itens
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TUNNELS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function RegisterTunnel.getFarms()
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    if not Organizations.goalsConfig[user.groupType] then return end

    local query = dbQuery('revolt_orgs/getDailyFarms', { organization = user.groupType, day = os.date('%d'), month = os.date('%m') })
    local t = {}
    for i = 1, #query do
        local ply = query[i]
        local ply_identity = getUserIdentity(ply.user_id)
        if not ply_identity then goto next_player end

        local nuser = Organizations.Members[ply.user_id]
        if not nuser then goto next_player end

        t[#t + 1] = {
            name = ('%s %s'):format(ply_identity.name, ply_identity.firstname),
            id = ply.user_id,
            role = Config.Groups[nuser.groupType] and Config.Groups[nuser.groupType].List[nuser.group].prefix or "Desconhecido",
            item = getItemName(ply.item) or ply.item,
            amount = ply.amount,
            status = ply.step > 1,
        }

        :: next_player ::
    end

    return t
end

function RegisterTunnel.getGoals()
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    if not Organizations.goalsConfig[user.groupType] then return end

    local myGoals = dbQuery('revolt_orgs/myGoals', { user_id = user_id, organization = user.groupType, day = os.date('%d'), month = os.date('%m') }) or {}
    local myItems, concluded_items = {}, 0
    for i = 1, #myGoals do
        local goal = myGoals[i]
        
        local _, valid_goal = getGoalsInfo(user.groupType)
        if valid_goal[goal.item] then
            local maxItem = valid_goal[goal.item]

            myItems[goal.item] = {
                amount = goal.amount,
                step = goal.step
            }

            if myItems[goal.item].amount >= (maxItem * myItems[goal.item].step) then
                concluded_items = (concluded_items + 1)
            end
        end
    end

    local goalsItens,totalItems = {}, 0
    local _, cfgItens = getGoalsInfo(user.groupType)
    for item, maxItem in pairs(cfgItens) do
        totalItems = (totalItems + 1)

        goalsItens[#goalsItens + 1] = {
            name = getItemName(item),
            item = item,
            quantity = myItems[item] and myItems[item].amount or 0,
            total = myItems[item] and maxItem * myItems[item].step or maxItem
        }
    end

    return {
        goalsReedemed = (concluded_items >= totalItems),
        items = goalsItens
    }
end

function RegisterTunnel.rewardGoal()
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local identity = getUserIdentity(user_id)
    if not identity then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    if not Organizations.goalsConfig[user.groupType] then return end

    if GOALS.cooldown[user_id] and (GOALS.cooldown[user_id] - os.time()) > 0 then
        return Config.Langs['waitCooldown'](source)
    end
    GOALS.cooldown[user_id] = (os.time() + 5)

    local myGoals = dbQuery('revolt_orgs/myGoals', { user_id = user_id, organization = user.groupType, day = os.date('%d'), month = os.date('%m') }) or {}
    if #myGoals <= 0 or not myGoals[1] then
        return
    end

    local concluded_items = 0
    for i = 1, #myGoals do
        local goal = myGoals[i]
        
        local _, valid_goal = getGoalsInfo(user.groupType)
        if valid_goal[goal.item] then
            local maxItem = valid_goal[goal.item]

            if goal.amount >= (maxItem * goal.step) then
                concluded_items = (concluded_items + 1)
            end
        end
    end

    local totalItems = 0
    local _, cfgItens = getGoalsInfo(user.groupType)
    for item, maxItem in pairs(cfgItens) do
        totalItems = (totalItems + 1)
    end

    if concluded_items < totalItems then
        return
    end

    local reward_step = myGoals[1].reward_step
    if myGoals[1].step >= 1 then
        reward_step = (reward_step + 1)
    end
    dbExecute('revolt_orgs/updateFarm', { user_id = user_id, organization = user.groupType, day = os.date('%d'), month = os.date('%m'), reward_step = reward_step, step = (myGoals[1].step + 1) })

    -- PAGAR META
    local query = dbQuery('revolt_orgs/bank/getinfo', { organization = user.groupType })
    if #query == 0 then return end

    local info, _ = getGoalsInfo(user.groupType)
    local amount = (info and info.defaultReward) or 0
    if not amount or not query[1].bank then
        return
    end
    if amount > query[1].bank then
        return Config.Langs['bankNotMoney'](source)
    end

    local bank_value = (query[1].bank - amount)
    local historic = safeDecode(query[1].bank_historic) or {}
    local generate_log = BANK:generateLog(historic, {
        name = ('%s %s'):format(identity.name, identity.firstname),
        type = "META RESGATADA",
		type_code = "goal",
        value = amount,
        amount = amount,
		balanceAfter = bank_value,
		timestamp = os.time(),
        date = os.date('%d/%m/%Y %X'),
    })

    dbExecute('revolt_orgs/bank/updateBank', { organization = user.groupType, bank = bank_value, historic = json.encode(generate_log) })
    giveBankMoney(user_id, amount)

    if Organizations and Organizations.PushLog then
        Organizations:PushLog(user.groupType, user_id, ("Resgatou meta diária (+R$%d)"):format(amount), user.group, ('%s %s'):format(identity.name, identity.firstname))
    end

    Config.Langs['rewardedGoal'](source, amount)
    return true
end

-- Adiciona uma nova meta (tier 1/2) sem sobrescrever tudo.
-- Espera payload: { item: "Farm", amount: 10 } (compat: { name/title, target })
function RegisterTunnel.newGoal(data)
	local source = source
	local user_id = getUserId(source)
	if not user_id then return false end

	local user = Organizations and Organizations.Members and Organizations.Members[user_id] or nil
	if not user or not user.groupType then return false end

	-- Permissão: tier 1 e 2 (Líder/Sub) ou admin
	local tier = tonumber(user.groupTier or user.tier) or 999
	local isAdmin = (Organizations.isAdmin and Organizations:isAdmin(user_id)) or false
	if (not isAdmin) and tier > 2 then return false end

	data = type(data) == "table" and data or {}
	local item = tostring(data.item or data.name or data.title or "")
	item = item:gsub("^%s+", ""):gsub("%s+$", "")
	local amount = tonumber(data.amount or data.target or data.value) or 0
	if item == "" or amount <= 0 then return false end

	-- Puxa config atual do cache (preferível) ou do banco
	local cfg = Organizations.goalsConfig and Organizations.goalsConfig[user.groupType] or nil
	local info = (cfg and cfg.info) or {}
	local itens = (cfg and (cfg.itens or cfg.items)) or (info.itens or info.items) or {}

	-- Normaliza e adiciona
	itens[item] = amount
	info.itens = itens
	info.items = itens

	local row = dbQuery('revolt_orgs/getInfo', { organization = user.groupType })
	if not row or #row == 0 then return false end

	local config_goals = safeDecode(row[1].config_goals) or {}
	config_goals.defaultReward = config_goals.defaultReward or info.defaultReward or 0
	config_goals.itens = itens
	config_goals.items = itens

	dbExecute('revolt_orgs/updateGoalsInfo', {
		organization = user.groupType,
		goals = json.encode(config_goals)
	})

	-- Atualiza cache em memória
	Organizations.goalsConfig = Organizations.goalsConfig or {}
	Organizations.goalsConfig[user.groupType] = { info = config_goals, itens = itens, items = itens }

	if Organizations and Organizations.PushLog then
		Organizations:PushLog(user.groupType, user_id, ("Criou meta: %s (%d)"):format(item, amount), user.group, tostring(user_id))
	end

	return true
end

function RegisterTunnel.getListGoals()
    local source = source
    local user_id = getUserId(source)
    if not user_id then return {} end

    local user = Organizations.Members[user_id]
    if not user then return {} end

    local cfg = Organizations.goalsConfig and Organizations.goalsConfig[user.groupType] or nil
    if not cfg then return {} end

    -- Compat: alguns formatos salvam em .info.itens, outros direto em .itens/.items
    local info = cfg.info or cfg
    local itens = (type(info.itens) == "table" and info.itens)
        or (type(info.items) == "table" and info.items)
        or {}

    local t = {}
    for item, amount in pairs(itens) do
        t[#t + 1] = {
            item = item,
            name = (type(getItemName) == "function" and getItemName(item)) or item,
            amount = tonumber(amount) or 0
        }
    end

    return { success = true, org = user.groupType, count = #t, goals = t, list = t }
end

function RegisterTunnel.saveGoals(data)
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    -- Somente Líder (tier 1) e Sub-líder (tier 2) podem definir as metas.
    local ctx = Organizations.getContext and Organizations:getContext(source) or nil
    local isAdmin = ctx and ctx.isAdmin == true

    local tier = 999
    if Config and Config.Groups and Config.Groups[user.groupType] and Config.Groups[user.groupType].List and Config.Groups[user.groupType].List[user.group] then
        tier = tonumber(Config.Groups[user.groupType].List[user.group].tier) or 999
    end

    if (not isAdmin) and (tier > 2) then
        return false
    end

    local HasGroup = Organizations.Permissions[user.groupType] and Organizations.Permissions[user.groupType][user.group].leader or false
    if not HasGroup then
        return
    end

    local t = {}
    for index in pairs(data.goals) do
        if not t.info then 
            t.info = {
                defaultReward = data.reward,
                itens = {}
            }
        end

        t.info.itens[data.goals[index].item] = data.goals[index].amount
    end

    if Organizations.goalsConfig[user.groupType] then
        Organizations.goalsConfig[user.groupType] = t
    end

    dbExecute('revolt_orgs/updateConfigGoals', { organization = user.groupType, config_goals = json.encode(t) })

    if Organizations and Organizations.PushLog then
        Organizations:PushLog(user.groupType, user_id, "Atualizou as metas da organização", user.group, (GetPlayerName(source) or ('#'..user_id)))
    end
end

exports('addGoal', function(user_id, item, amount)
    user_id = parseInt(user_id)
    local source = getUserSource(user_id)
    if not source then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    if not Organizations.goalsConfig[user.groupType] then return end
    local _, vItens = getGoalsInfo(user.groupType)
    if not vItens[item] then return end

    dbExecute('revolt_orgs/addPlayerFarm', { organization = user.groupType, user_id = user_id, item = item, amount = amount, day = os.date('%d'), month = os.date('%m') })
end)