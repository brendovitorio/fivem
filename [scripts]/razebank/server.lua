-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy  = module("revolt","lib/Proxy")

rEVOLT  = Proxy.getInterface("rEVOLT")
RevoltC = Tunnel.getInterface("Revolt")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("RazeBank", cRP)

local atmTimers = 0	

local oxmysql = exports["oxmysql"]

local PREPARED = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS
-----------------------------------------------------------------------------------------------------------------------------------------
local function ensureTable(t)
    return (type(t) == "table") and t or {}
end

-- Aceita query como:
-- 1) string
-- 2) prepared name (string)
-- 3) objeto: { query="...", values={...} } ou { sql="...", params={...} }
local function normalizeQueryAndParams(q, params)
    -- Caso 1: veio objeto
    if type(q) == "table" then
        local obj = q

        -- padrões comuns
        local query =
            obj.query or obj.sql or obj.statement or obj.text or obj[1]

        local p =
            obj.values or obj.params or obj.parameters or obj.bindings or obj[2] or params

        return query, ensureTable(p)
    end

    -- Caso 2: veio string (prepared name ou SQL direto)
    if type(q) == "string" then
        local resolved = PREPARED[q] or q
        return resolved, ensureTable(params)
    end

    -- Caso 3: inválido
    return nil, ensureTable(params)
end

local function assertQueryString(query, where)
    if type(query) ~= "string" then
        error(("[%s] Query inválida: esperado string, recebido %s"):format(where, type(query)))
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
function DbPrepare(name, query)
    if type(name) ~= "string" or name == "" then
        error("Proxy._Prepare: 'name' inválido (precisa ser string)")
    end
    if type(query) ~= "string" or query == "" then
        error("Proxy._Prepare: 'query' inválida (precisa ser string)")
    end
    PREPARED[name] = query
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERY (SELECT)
-----------------------------------------------------------------------------------------------------------------------------------------
function DbQuery(q, params)
    local query, p = normalizeQueryAndParams(q, params)
    assertQueryString(query, "Proxy.Query")
    return oxmysql:query_async(query, p)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXECUTE (UPDATE/DELETE)
-----------------------------------------------------------------------------------------------------------------------------------------
function DbExecute(q, params)
    local query, p = normalizeQueryAndParams(q, params)
    assertQueryString(query, "Proxy.Execute")
    return oxmysql:update_async(query, p)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERT
-----------------------------------------------------------------------------------------------------------------------------------------
function DbInsert(q, params)
    local query, p = normalizeQueryAndParams(q, params)
    assertQueryString(query, "Proxy.Insert")
    return oxmysql:insert_async(query, p)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SCALAR (1 valor)
-----------------------------------------------------------------------------------------------------------------------------------------
function DbScalar(q, params)
    local query, p = normalizeQueryAndParams(q, params)
    assertQueryString(query, "Proxy.Scalar")
    return oxmysql:scalar_async(query, p)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET INTERFACE
-----------------------------------------------------------------------------------------------------------------------------------------
function Proxy.getInterface(name)
    if type(name) ~= "string" or name == "" then
        return nil
    end

    if exports[name] then
        return exports[name]
    end

    if _G[name] then
        return _G[name]
    end

    return nil
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOKS (NÃO COLOCO OS SEUS AQUI — COLE OS SEUS DE VOLTA)
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookSacar       = "<SEU_WEBHOOK_AQUI>"
local webhookDepositar   = "<SEU_WEBHOOK_AQUI>"
local webhookTransferir  = "<SEU_WEBHOOK_AQUI>"
local webhookPagarMulta  = "<SEU_WEBHOOK_AQUI>"

-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILS
-----------------------------------------------------------------------------------------------------------------------------------------
local function toNumber(v)
    local n = tonumber(v)
    if not n then return nil end
    if n ~= n then return nil end -- NaN guard
    return n
end

local function getInvAmount(user_id, item)
    local data = rEVOLT.InventoryItemAmount(user_id, item)
    if type(data) == "table" and data[1] then
        return tonumber(data[1]) or 0
    end
    return 0
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("Revolt/Get_Transactions",
    "SELECT * FROM RazeBank_transactions WHERE receiver_identifier = @identifier OR sender_identifier = @identifier ORDER BY id DESC"
)

rEVOLT._Prepare("Revolt/Transactions",
    'SELECT *, ' ..
    'DATE(date) = CURDATE() AS "day1", ' ..
    'DATE(date) = CURDATE() - INTERVAL 1 DAY AS "day2", ' ..
    'DATE(date) = CURDATE() - INTERVAL 2 DAY AS "day3", ' ..
    'DATE(date) = CURDATE() - INTERVAL 3 DAY AS "day4", ' ..
    'DATE(date) = CURDATE() - INTERVAL 4 DAY AS "day5", ' ..
    'DATE(date) = CURDATE() - INTERVAL 5 DAY AS "day6", ' ..
    'DATE(date) = CURDATE() - INTERVAL 6 DAY AS "day7" ' ..
    'FROM `RazeBank_transactions` WHERE DATE(date) >= CURDATE() - INTERVAL 7 DAY'
)

rEVOLT._Prepare("insert_tranctions",
    "INSERT INTO RazeBank_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) " ..
    "VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)"
)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.GetPlayerInfo()
    local source = source
    local user_id = rEVOLT.Passport(source)
    if not user_id then return nil end

    local identity = rEVOLT.Identities(user_id)
    if not identity then return nil end

    local ped = GetPlayerPed(source)
    local sexModel = GetEntityModel(ped)

    local sex = "f"
    if tostring(sexModel) == "mp_m_freemode_01" then
        sex = "m"
    end

    local wallet = getInvAmount(user_id, "dollars")

    local data = {
        playerName = (identity.name or "") .. " " .. (identity.name2 or ""),
        playerBankMoney = rEVOLT.GetBank(source),
        walletMoney = wallet,
        sex = sex
    }

    return data
end

function cRP.paymentSystems(amount)
    local n = toNumber(amount)
    if not n or n <= 0 then return end

    local source = source
    local user_id = rEVOLT.Passport(source)
    if user_id then
        rEVOLT.GiveItem(user_id, "dollars", n, true)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTWANTED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestWanted()
    local source = source
    local user_id = rEVOLT.Passport(source)
    if user_id then
        if exports["hud"] and exports["hud"]:Wanted(user_id, source) then
            return false
        end
    end
    return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSYSTEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkSystems()
    local source = source
    local user_id = rEVOLT.Passport(source)
    if not user_id then return false end

    local policeResult = rEVOLT.NumPermission("Police") or {}

    if parseInt(#policeResult) <= 3 or os.time() < atmTimers then
        TriggerClientEvent("Notify", source, "amarelo", "Sistema indisponível no momento.", 5000)
        return false
    end

    local amountC4 = getInvAmount(user_id, "c4")
    if amountC4 <= 0 then
        TriggerClientEvent("Notify", source, "amarelo", "Necessário possuir um <b>Bomba Caseira</b>.", 5000)
        return false
    end

    rEVOLT.UpgradeStress(user_id, 10)

    atmTimers = os.time() + 1200
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    TriggerClientEvent("player:applyGsr", source)

    for _, v in pairs(policeResult) do
        async(function()
            RevoltC.PlaySound(v, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
            TriggerClientEvent("NotifyPush", v, {
                code = 20,
                title = "Caixa Eletrônico",
                x = coords.x,
                y = coords.y,
                z = coords.z,
                criminal = "Alarme de segurança",
                time = "Recebido às " .. os.date("%H:%M"),
                blipColor = 16
            })
        end)
    end

    return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPIN
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("characters/Players", "SELECT * FROM characters WHERE id = @id")

function cRP.GetPIN(source)
    local source = source
    local user_id = rEVOLT.Passport(source)
    if not user_id then return nil end

    local identity = DbQuery("characters/Players", { id = user_id })
    if type(identity) ~= "table" or not identity[1] then
        return nil
    end

    return identity[1]["pincode"]
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSITMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:DepositMoney")
AddEventHandler("RazeBank:DepositMoney", function(amount)
    local source = source
    local user_id = rEVOLT.Passport(source)
    if not user_id then return end

    local n = toNumber(amount)
    if not n or n <= 0 then return end

    local hasMoney = rEVOLT.TakeItem(user_id, "dollars", n)
    if hasMoney then
        rEVOLT.GiveBank(user_id, n, "Private")

        TriggerEvent("RazeBank:AddDepositTransaction", n, source)
        TriggerClientEvent("RazeBank:updateTransactions", source, rEVOLT.GetBank(source), getInvAmount(user_id, "dollars"))
        TriggerClientEvent("Notify", source, "verde", "Você depositou $" .. n, 5000)

        if rEVOLT.SendWebhook then
            rEVOLT.SendWebhook(webhookDepositar, "LOGs Depositar", "**Passaporte: **" .. user_id .. "\n**Depositou: **" .. n)
        end
    else
        TriggerClientEvent("Notify", source, "vermelho", "Dinheiro insuficiente.", 5000)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAWMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:WithdrawMoney")
AddEventHandler("RazeBank:WithdrawMoney", function(amount)
    local source = source
    local user_id = rEVOLT.Passport(source)
    if not user_id then return end

    local n = toNumber(amount)
    if not n or n <= 0 then return end

    if rEVOLT.PaymentBank(user_id, n) then
        rEVOLT.GiveItem(user_id, "dollars", n, true)

        TriggerEvent("RazeBank:AddWithdrawTransaction", n, source)
        TriggerClientEvent("RazeBank:updateTransactions", source, rEVOLT.GetBank(source), getInvAmount(user_id, "dollars"))
        TriggerClientEvent("Notify", source, "verde", "Você sacou $" .. n, 5000)

        if rEVOLT.SendWebhook then
            rEVOLT.SendWebhook(webhookSacar, "LOGs Sacar", "**Passaporte: **" .. user_id .. "\n**Sacou: **" .. n)
        end
    else
        TriggerClientEvent("Notify", source, "vermelho", "Dinheiro insuficiente.", 5000)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:TransferMoney")
AddEventHandler("RazeBank:TransferMoney", function(amount, nuser_id)
    local source = source
    local user_id = rEVOLT.Passport(source)
    if not user_id then return end

    local n = toNumber(amount)
    local target = tonumber(nuser_id)

    if not n or n <= 0 or not target then return end

    local identity = rEVOLT.Identities(user_id)
    if not identity then return end

    if user_id == target then
        TriggerClientEvent("Notify", source, "vermelho", "Você não pode transferir para si mesmo.", 5000)
        return
    end

    if not rEVOLT.PaymentBank(user_id, n) then
        TriggerClientEvent("Notify", source, "vermelho", "Dinheiro insuficiente.", 5000)
        return
    end

    rEVOLT.GiveBank(target, n)

    -- notifica se o alvo está online
    local players = rEVOLT.Players() or {}
    for i = 1, #players do
        local plySrc = players[i]
        local plyId = rEVOLT.Passport(plySrc)
        if plyId == target then
            local identity2 = rEVOLT.Identities(plyId)
            TriggerClientEvent("RazeBank:updateTransactions", plySrc, rEVOLT.GetBank(plySrc), getInvAmount(plyId, "dollars"))

            if identity2 then
                TriggerClientEvent("okokNotify:Alert", plySrc, "BANK",
                    "Você recebeu $" .. n .. " de " .. (identity.name or "") .. " " .. (identity.name2 or ""),
                    5000, "success"
                )
            end
            break
        end
    end

    TriggerEvent("RazeBank:AddTransferTransaction", n, target, source)
    TriggerClientEvent("RazeBank:updateTransactions", source, rEVOLT.GetBank(source), getInvAmount(user_id, "dollars"))
    TriggerClientEvent("Notify", source, "verde", "Você transferiu $" .. n .. " com sucesso.", 5000)

    if rEVOLT.SendWebhook then
        rEVOLT.SendWebhook(webhookTransferir, "LOGs Transferir", "**Passaporte: **" .. user_id .. "\n**Transferiu: **" .. n)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETOVERVIEWTRANSACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.GetOverviewTransactions()
    local source = source
    local user_id = rEVOLT.Passport(source)
    if not user_id then return {}, nil, {} end

    local playerIdentifier = tostring(user_id)

    local idesntidade = rEVOLT.Identities(user_id)
    
    local playerName = (idesntidade.name or "") .. " " .. (idesntidade.name2 or "")

    local allDays = {} -- ✅ corrigido (não use table.remove em array vazio)
    local income, outcome, totalIncome = 0, 0, 0
    local day1_total, day2_total, day3_total, day4_total, day5_total, day6_total, day7_total = 0, 0, 0, 0, 0, 0, 0

    local result  = rEVOLT.Query("Revolt/Get_Transactions", { identifier = playerName }) or {}
    local result2 = rEVOLT.Query("Revolt/Transactions", {}) or {}

    for _, v in pairs(result2) do
        local t = v.type
        local receiver_identifier = tostring(v.receiver_identifier or "")
        local sender_identifier   = tostring(v.sender_identifier or "")
        local value = tonumber(v.value) or 0

        local function applyTo(dayTotal)
            if t == "deposit" then
                dayTotal = dayTotal + value
                income = income + value
            elseif t == "withdraw" then
                dayTotal = dayTotal - value
                outcome = outcome - value
            elseif t == "transfer" and receiver_identifier == playerIdentifier then
                dayTotal = dayTotal + value
                income = income + value
            elseif t == "transfer" and sender_identifier == playerIdentifier then
                dayTotal = dayTotal - value
                outcome = outcome - value
            end
            return dayTotal
        end

        if v.day1 == 1 then
            day1_total = applyTo(day1_total)
        elseif v.day2 == 1 then
            day2_total = applyTo(day2_total)
        elseif v.day3 == 1 then
            day3_total = applyTo(day3_total)
        elseif v.day4 == 1 then
            day4_total = applyTo(day4_total)
        elseif v.day5 == 1 then
            day5_total = applyTo(day5_total)
        elseif v.day6 == 1 then
            day6_total = applyTo(day6_total)
        elseif v.day7 == 1 then
            day7_total = applyTo(day7_total)
        end
    end

    totalIncome = day1_total + day2_total + day3_total + day4_total + day5_total + day6_total + day7_total

    table.insert(allDays, day1_total)
    table.insert(allDays, day2_total)
    table.insert(allDays, day3_total)
    table.insert(allDays, day4_total)
    table.insert(allDays, day5_total)
    table.insert(allDays, day6_total)
    table.insert(allDays, day7_total)
    table.insert(allDays, income)
    table.insert(allDays, outcome)
    table.insert(allDays, totalIncome)

    return result, playerIdentifier, allDays
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDDEPOSITTRANSACTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:AddDepositTransaction")
AddEventHandler("RazeBank:AddDepositTransaction", function(amount, source_)
    local _source = source_ or source
    local user_id = rEVOLT.Passport(_source)
    if not user_id then return end

    local n = tonumber(amount) or 0
    if n <= 0 then return end

    local identity = rEVOLT.Identities(user_id)
    if not identity then return end

    rEVOLT.Query("insert_tranctions", {
        receiver_identifier = "bank",
        receiver_name = "Bank Account",
        sender_identifier = tostring(user_id),
        sender_name = (identity.name or "") .. " " .. (identity.name2 or ""),
        value = n,
        type = "deposit"
    })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSALARY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:AddSalaryTransaction")
AddEventHandler("RazeBank:AddSalaryTransaction", function(amount, source_)
    local _source = source_ or source
    local user_id = rEVOLT.Passport(_source)
    if not user_id then return end

    local n = tonumber(amount) or 0
    if n <= 0 then return end

    local identity = rEVOLT.Identities(user_id)
    if not identity then return end

    rEVOLT.Query("insert_tranctions", {
        receiver_identifier = "bank",
        receiver_name = "Pagamento",
        sender_identifier = tostring(user_id),
        sender_name = (identity.name or "") .. " " .. (identity.name2 or ""),
        value = n,
        type = "salary"
    })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDWITHDRAWTRANSACTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:AddWithdrawTransaction")
AddEventHandler("RazeBank:AddWithdrawTransaction", function(amount, source_)
    local _source = source_ or source
    local user_id = rEVOLT.Passport(_source)
    if not user_id then return end

    local n = tonumber(amount) or 0
    if n <= 0 then return end

    local identity = rEVOLT.Identities(user_id)
    if not identity then return end

    rEVOLT.Query("insert_tranctions", {
        receiver_identifier = tostring(user_id),
        receiver_name = (identity.name or "") .. " " .. (identity.name2 or ""),
        sender_identifier = "bank",
        sender_name = "Bank Account",
        value = n,
        type = "withdraw"
    })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTRANSFERTRANSACTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:AddTransferTransaction")
AddEventHandler("RazeBank:AddTransferTransaction", function(amount, xTarget, source_, targetName, targetIdentifier)
    local _source = source_ or source
    local user_id = rEVOLT.Passport(_source)
    if not user_id then return end

    local n = tonumber(amount) or 0
    if n <= 0 then return end

    local identity = rEVOLT.Identities(user_id)
    if not identity then return end

    if targetName == nil then
        local identity2 = rEVOLT.Identities(xTarget)
        if not identity2 then return end

        rEVOLT.Query("insert_tranctions", {
            receiver_identifier = tostring(xTarget),
            receiver_name = (identity2.name or "") .. " " .. (identity2.name2 or ""),
            sender_identifier = tostring(user_id),
            sender_name = (identity.name or "") .. " " .. (identity.name2 or ""),
            value = n,
            type = "transfer"
        })
    else
        if not targetIdentifier then return end

        rEVOLT.Query("insert_tranctions", {
            receiver_identifier = tostring(targetIdentifier),
            receiver_name = tostring(targetName),
            sender_identifier = tostring(user_id),
            sender_name = (identity.name or "") .. " " .. (identity.name2 or ""),
            value = n,
            type = "transfer"
        })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPINDB
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("update_pincode", "UPDATE characters SET pincode = @pin WHERE id = @identifier")

RegisterServerEvent("RazeBank:UpdatePINDB")
AddEventHandler("RazeBank:UpdatePINDB", function(pin)
    local source = source
    local user_id = rEVOLT.Passport(source)
    if not user_id then return end

    local pinStr = tostring(pin or "")
    if pinStr == "" then return end

    if rEVOLT.PaymentBank(user_id, 1000) then
        rEVOLT.Query("update_pincode", {
            pin = pinStr,
            identifier = user_id
        })

        TriggerClientEvent("RazeBank:updateIbanPinChange", source)
        TriggerClientEvent("RazeBank:updateMoney", source, rEVOLT.GetBank(source), getInvAmount(user_id, "dollars"))
        TriggerClientEvent("Notify", source, "verde", "PIN trocado com sucesso para " .. pinStr, 5000)
    else
        TriggerClientEvent("Notify", source, "vermelho", "Dinheiro insuficiente.", 5000)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FINESPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.finesPayment(id, price)
    local source = source
    local user_id = rEVOLT.Passport(source)
    if not user_id then return end

    local n = tonumber(price) or 0
    if n <= 0 then return end

    if rEVOLT.PaymentBank(user_id, parseInt(n)) then
        rEVOLT.RemoveFine(user_id, parseInt(n))
        if rEVOLT.SendWebhook then
            rEVOLT.SendWebhook(webhookPagarMulta, "LOGs Pagar Multa", "**Passaporte: **" .. user_id .. "\n**Pagou: **" .. n)
        end
    else
        TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente na sua conta bancária.", 5000)
    end
end