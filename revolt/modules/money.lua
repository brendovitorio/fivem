-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.GiveBank(Passport, Amount)
    local Amount = parseInt(Amount)
    local Source = rEVOLT.Source(Passport)

    if Amount > 0 then
        -- Mantém o dialeto interno (entry/exit) no core, mas registra no SQL com tipos compatíveis
        -- (deposit/withdraw/transfer...), e NUNCA envia Balance = nil.
        local function normalizeTxType(t)
            t = tostring(t or ""):lower()
            if t == "entry" then return "deposit" end
            if t == "exit" then return "withdraw" end
            return t
        end

        local function addTransaction(passport, txType, value, balance)
            if type(rEVOLT.Query) ~= "function" then return end
            rEVOLT.Query("transactions/Add", {
                Passport = passport,
                Type = normalizeTxType(txType),
                Date = os.date("%d/%m/%Y"),
                Value = parseInt(value) or 0,
                Balance = tonumber(balance) or 0
            })
        end

        local newBalance = 0
        if Source and Characters[Source] then
            Characters[Source].bank = (Characters[Source].bank or 0) + Amount
            newBalance = Characters[Source].bank
        end

        rEVOLT.Query("characters/addBank", { Passport = Passport, amount = Amount })
        addTransaction(Passport, "entry", Amount, newBalance)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.RemoveBank(Passport, Amount)
    local Amount = parseInt(Amount)
    local Source = rEVOLT.Source(Passport)

    if Amount > 0 then
        local function normalizeTxType(t)
            t = tostring(t or ""):lower()
            if t == "entry" then return "deposit" end
            if t == "exit" then return "withdraw" end
            return t
        end

        local function addTransaction(passport, txType, value, balance)
            if type(rEVOLT.Query) ~= "function" then return end
            rEVOLT.Query("transactions/Add", {
                Passport = passport,
                Type = normalizeTxType(txType),
                Date = os.date("%d/%m/%Y"),
                Value = parseInt(value) or 0,
                Balance = tonumber(balance) or 0
            })
        end

        local newBalance = 0
        if Source and Characters[Source] then
            Characters[Source].bank = (Characters[Source].bank or 0) - Amount
            if Characters[Source].bank < 0 then Characters[Source].bank = 0 end
            newBalance = Characters[Source].bank
        end

        rEVOLT.Query("characters/remBank", { Passport = Passport, amount = Amount })
        addTransaction(Passport, "exit", Amount, newBalance)
    end
end
-- GETBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.GetBank(source)
    if Characters[source] then
        return Characters[source].bank
    end
    return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTGEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.PaymentGems(Passport, Amount)
    local Amount = parseInt(Amount)
    local Source = rEVOLT.Source(Passport)
    if Amount > 0 and Characters[Source] and Amount <= rEVOLT.UserGemstone(Characters[Source].license) then
        rEVOLT.Query("accounts/RemoveGems", { license = Characters[Source].license, gems = Amount })
        TriggerClientEvent("hud:RemoveGems", Source, Amount)
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.PaymentBank(Passport,Amount)
    local Amount = parseInt(Amount)
    local Source = rEVOLT.Source(Passport)
    if Amount > 0 and Characters[Source] and Amount <= Characters[Source]["bank"] then
        rEVOLT.RemoveBank(Passport,Amount,(Source))
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.PaymentMoney(Passport,Amount)
	if parseInt(Amount) > 0 then 
        if Amount <= rEVOLT.ItemAmount(Passport,"dollars") then
            local Inventory = rEVOLT.Inventory(Passport)
            for k,v in pairs(Inventory) do
                if splitString(v["item"], "-")[1] == "dollars" then
                    if Amount <= v["amount"] then
                        Inventory[k]["amount"] = v["amount"] - Amount
                        if Inventory[k]["amount"] <= 0 then
                            Inventory[k] = nil
                        end
                        Amount = Amount - Amount
                    else
                        Amount = Amount - v["amount"]
                        Inventory[k] = nil
                    end
                elseif itemChest(v["item"]) and v["data"] then
                    for Slot,Value in pairs(v["data"]) do
                        if splitString(Value["item"], "-")[1] == "dollars" then
                            if Amount <= Value["amount"] then
                                Inventory[k]["data"][Slot]["amount"] = Value["amount"] - Amount
                                if Inventory[k]["data"][Slot]["amount"] <= 0 then
                                    Inventory[k]["data"][Slot] = nil
                                end
                                Amount = Amount - Amount
                            else
                                Amount = Amount - Value["amount"]
                                Inventory[k]["data"][Slot] = nil
                            end
                        end
                    end
                end
            end
            return Amount <= 0
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTCREDIT
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.PaymentCredit(Passport,Amount,Type)
	if parseInt(Amount) > 0 then
		if rEVOLT.Identity(Passport)["cardlimit"] >= parseInt(Amount) then
            rEVOLT.UpgradeSpending(Passport, Amount)
            rEVOLT.DowngradeCardlimit(Passport, Amount)
            rEVOLT.Query('invoices/Add',{ Passport = Passport, Received = "CreditCard", Type = "received", Reason = "Cartão de Crédito", Holder = "Loja: " ..(Type or "Fisica") , Value = parseInt(Amount) })
			return true
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTFULL
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.PaymentFull(Passport, Amount, Type)
    local Source = rEVOLT.Source(Passport)
    if parseInt(Amount) >= 1 then
        for Key,Value in pairs(rEVOLT.Inventory(Passport)) do
            if SplitOne(Value["item"]) == "debitcard" or SplitOne(Value["item"]) == "creditcard" then
                local Identity = rEVOLT.Identity(parseInt(SplitTwo(Value["item"]))) 
                if Passport == parseInt(SplitTwo(Value["item"])) or SplitOne(Value["item"]) == "creditcard" and rEVOLT.Dependents(Passport,Dependent) then
                    if rEVOLT.Request(Source,"Pagamento","Pagar Com "..itemName(Value["item"]).."<br> em nome de "..Identity["name"].." "..Identity["name2"].."<br><b>$"..parseFormat(Amount).."</b> dólares?") then 
                        if SplitOne(Value["item"]) == "debitcard" then
                            if rEVOLT.PaymentBank(parseInt(SplitTwo(Value["item"])),parseInt(Amount)) then
                                return true
                            else
                                TriggerClientEvent("Notify",Source,"vermelho","<b>Saldo Bancário</b> insuficientes.",5000,"Liso")
                            end
                        else
                            if rEVOLT.PaymentCredit(parseInt(SplitTwo(Value["item"])),parseInt(Amount),Type) then
                                return true
                            else
                                TriggerClientEvent("Notify",Source,"vermelho","<b>Limite Cartão</b> insuficientes.",5000,"Liso")
                            end
                        end
                    end
                end
            end
        end
        if rEVOLT.PaymentMoney(Passport,parseInt(Amount)) then
            return true
        else
            TriggerClientEvent("Notify",Source,"vermelho","<b>Dólares</b> insuficientes.",5000,"Liso")
        end
    end
    return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAWCASH
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.WithdrawCash(Passport, Amount)
    local Amount = parseInt(Amount)
    local Source = rEVOLT.Source(Passport)
    if Amount > 0 and Characters[Source] and Amount <= Characters[Source].bank then
        rEVOLT.GenerateItem(Passport, "dollars", Amount, true)
        rEVOLT.RemoveBank(Passport, Amount,Source)
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPENDENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Dependents(Passport,Dependent)
    if Dependents[Passport] == nil then
        local Consult = rEVOLT.Query('dependents/Check',{ Passport = Passport, Dependent = Dependent })
		if Consult[1] then
			Dependents[Passport] = Consult[1]
		end
	end
    return Dependents[Passport]
end