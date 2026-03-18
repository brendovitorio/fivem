-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("bank",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local yield = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Wanted()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and rEVOLT.GetHealth(source) > 100 and not exports["hud"]:Reposed(Passport) and not exports["hud"]:Wanted(Passport,source) then
		return true
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	local next_time = GetGameTimer()
-- 	while true do
-- 		if os.time() >= next_time then
-- 			next_time = os.time() + 3600
-- 			rEVOLT.Query("investments/Actives")
-- 		end
-- 		Wait(1000)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Home()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		Active[Passport] = nil
		local check = rEVOLT.Query("investments/Check", {Passport = Passport})
		if check[1] then
			yield = check[1].Monthly
		end
		local cardnumber = "7822 1352 4522 " .. 1000 + Passport
		local balance = rEVOLT.Identities(Passport).bank
		local transactions = Transactions(Passport)
		local dependents = Dependents(Passport)	
		return {
			Passport = Passport,
			yield = yield,
			cardnumber = cardnumber,
			balance = balance,
			transactions = transactions,
			dependents = dependents,
			cardlimit = rEVOLT.Identities(Passport)["cardlimit"],
			spending = rEVOLT.Identities(Passport)["spending"]
		}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Bank:CreditCard")
AddEventHandler("Bank:CreditCard", function()
    local source = source
    local Passport = rEVOLT.Passport(source)
    if Passport then
		local Identity = rEVOLT.Identities(Passport)
		if Identity["cardlimit"] == 0 and Identity["spending"] == 0 then
			if rEVOLT.Request(source,"Banco","Você tem interesse em solicitar um Cartão de Crédito?") then
				rEVOLT.UpgradeCardlimit(Passport,2000)
				rEVOLT.GiveItem(Passport,"creditcard-" .. Passport,1,true)
			end
		else
			if rEVOLT.Request(source,"Banco","Você gostaria de solicitar uma segunda via do seu Cartão de Crédito? Isso terá um custo de <b>$"..parseFormat(500).."</b>.") then
				if rEVOLT.PaymentFull(Passport, 500, "Banco") then
					rEVOLT.GiveItem(Passport,"creditcard-" .. Passport,1,true)
				end
			end
		end
        return
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Bank:DebitCard")
AddEventHandler("Bank:DebitCard", function()
    local source = source
    local Passport = rEVOLT.Passport(source)
	if Passport then
		local Identity = rEVOLT.Identities(Passport)
		if Identity["cardpassword"] == 0 then
			if rEVOLT.Request(source,"Banco","Você tem interesse em solicitar um Cartão de Débito?") then
				local Keyboard = vKEYBOARD.Password(source,"Senha: (4 Dígitos)")
				if Keyboard then
					if rEVOLT.SetCardPassword(Passport, Keyboard[1]) then
						rEVOLT.GiveItem(Passport,"debitcard-" .. Passport,1,true)
					end
				end
			end
		else
			if rEVOLT.Request(source,"Banco","Você gostaria de alterar a senha do seu Cartão de Débito?") then
				local Keyboard = vKEYBOARD.Password(source,"Senha: (4 Dígitos)")
				if Keyboard then
					if rEVOLT.SetCardPassword(Passport, Keyboard[1]) then
						TriggerClientEvent("Notify",source,"verde"," Sua senha foi alterada com sucesso!",5000) 
					end
				end
			else
				if rEVOLT.Request(source,"Banco","Você gostaria de solicitar uma segunda via do seu Cartão de Débito? Isso terá um custo de <b>$"..parseFormat(500).."</b>.") then
					if rEVOLT.PaymentFull(Passport, 500, "Banco") then
						rEVOLT.GiveItem(Passport,"debitcard-" .. Passport,1,true)
					end
				end
			end
		end
        return
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD DEPENDENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AddDependents(Dependent)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and not Active[Passport] and Dependent ~= Passport then
		Active[Passport] = true
		local Consulta = rEVOLT.Query('dependents/Check',{ Passport = Passport, Dependent = Dependent })
		if not Consulta[1] then
			local ClosestPed = rEVOLT.Source(Dependent)
			if ClosestPed then
				if rEVOLT.Request(ClosestPed,"Banco","<b>" ..rEVOLT.Identities(Passport).name .. " deseja convida-lo para sua lista de dependentes bancário, você aceita esse convite?","Sim, aceito","Não, obrigado") then
					local Name = rEVOLT.Identities(Dependent).name .. " " .. rEVOLT.Identities(Dependent).name2
					rEVOLT.Query('dependents/Add',{ Passport = Passport, Dependent = Dependent, Name = Name })
					Active[Passport] = nil
					return Name
				end
			end
		end
		Active[Passport] = nil
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE DEPENDENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RemoveDependents(Dependent)
	local source = source
	local Passport = rEVOLT.Passport(source)
	TriggerClientEvent('Notify', source, 'vermelho',  Dependent , 5000)
	if Passport and not Active[Passport] then
		Active[Passport] = true
		local Consulta = rEVOLT.Query('dependents/Check',{ Passport = Passport, Dependent = Dependent })
		if Consulta[1] then
			TriggerClientEvent('Notify', source, 'vermelho',  Consulta[1] , 5000)
			rEVOLT.Query('dependents/Remove',{ Passport = Passport, Dependent = Dependent})
			Active[Passport] = nil
			return true
		end
		Active[Passport] = nil
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.TransactionHistory()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		return Transactions(Passport, 50)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANKDEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Deposit(amount)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and Active[Passport] == nil and parseInt(amount) > 0 then
		Active[Passport] = true
		if rEVOLT.PaymentMoney(Passport,amount) then
			rEVOLT.GiveBank(Passport, amount)
		end
		Active[Passport] = nil
		local balance = rEVOLT.Identities(Passport).bank
		local transactions = Transactions(Passport)
		return {balance = balance, transactions = transactions}
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANWITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Withdraw(amount)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and Active[Passport] == nil and parseInt(amount) > 0 then
		Active[Passport] = true
		rEVOLT.WithdrawCash(Passport, amount)
		Active[Passport] = nil
		local balance = rEVOLT.Identities(Passport).bank
		local transactions = Transactions(Passport)
		return {balance = balance, transactions = transactions}
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Transfer(ClosestPed,amount)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and Active[Passport] == nil and parseInt(amount) > 0 then
		Active[Passport] = true
		if rEVOLT.Identities(ClosestPed) and rEVOLT.PaymentBank(Passport, amount, true) then
			rEVOLT.GiveBank(ClosestPed, amount)
		end
		Active[Passport] = nil
		local balance = rEVOLT.Identities(Passport).bank
		local transactions = Transactions(Passport)
		return {balance = balance, transactions = transactions}
	end
	return false
end
----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTION
-----------------------------------------------------------------------------------------------------------------------------------------
function Transactions(Passport, Limit)
	local Passport = Passport
	local transactions = {}
	if not Limit then
		Limit = 4
	end
	local result = rEVOLT.Query('transactions/List',{ Passport = Passport, Limit = Limit })
	if result[1] then
		for i, transaction in pairs(result) do
			local type = transaction.Type
			local date = transaction.Date
			local value = transaction.Value
			local balance = transaction.Balance
			transactions[#transactions + 1] = {
				type = type,
				date = date,
				value = value,
				balance = balance
			}
		end
	end
	return transactions
end
----------------------------------------------------------------------------------------------------------------------------------------
-- DEPENDENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Dependents(Passport)
	local Passport = Passport
	local dependencies = {}
	local result = rEVOLT.Query('dependents/List',{ Passport = Passport })
	if result[1] then
		for i, record in pairs(result) do
			dependencies[#dependencies + 1] = {
				name = record.Name,
				dependent = record.Dependent
			}
		end
	end
	return dependencies
end
----------------------------------------------------------------------------------------------------------------------------------------
-- FINES
-----------------------------------------------------------------------------------------------------------------------------------------
function Fines(Passport)
	local Passport = Passport
	local fines = {}
	local result = rEVOLT.Query('fines/List',{ Passport = Passport })
	if result[1] then
		for i, row in pairs(result) do
			if row.Value > 0 then
				fines[i] = {
					id = row.id,
					name = row.Name,
					value = row.Value,
					date = row.Date,
					hour = row.Hour,
					message = row.Message
				}
			else
				rEVOLT.Query("fines/Remove",{ Passport = row.Passport ,id = row.id})
			end
		end
	end
	return fines
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.FineList()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		return Fines(Passport)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.FinePayment(id)
	local source = source
	local Passport = rEVOLT.Passport(source)
	local id = id
	if Passport and Active[Passport] == nil then
		Active[Passport] = true
		local result = rEVOLT.Query('fines/Check',{ Passport = Passport, id = id })
		if result[1] then
			if rEVOLT.PaymentBank(Passport, result[1].Value) then
				rEVOLT.Query("fines/Remove",{ Passport = Passport ,id = id})
				Active[Passport] = nil
				return true
			end
		end
		Active[Passport] = nil
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RemoveInFines()
	local source = source
	local Passport = rEVOLT.Passport(source)
	local result = rEVOLT.Query('fines/CheckList',{ Passport = Passport})
	local results = rEVOLT.Query('fines/CheckLists',{ Passport = Passport})
		if #result > 0 then
		if result[1]["Value"] == 0 then
			rEVOLT.Query("fines/Removes",{ id = result[1]["id"],Passport = result[1]["Passport"]}) 
		end 
	else
		return
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.FinePaymentAll()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and Active[Passport] == nil then
		Active[Passport] = true
		local result = rEVOLT.Query('fines/List',{ Passport = Passport})
		
		if result[1] then
			for i, row in pairs(result) do
				local id = row.id
				if rEVOLT.PaymentBank(Passport, result[1].Value) then
					rEVOLT.Query("fines/Remove",{ Passport = Passport, id = id })
					Active[Passport] = nil
					return true
				end
			end
		end
		Active[Passport] = nil
	end
	return Fines(Passport)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Taxs(Passport)
	local Passport = Passport
	local taxs = {}
	local result = rEVOLT.Query('taxs/List',{ Passport = Passport })
	if result[1] then
		for i, tax in pairs(result) do
			taxs[i] = {
				id = tax.id,
				name = tax.Name,
				value = tax.Value,
				date = tax.Date,
				hour = tax.Hour,
				message = tax.Message
			}
		end
	end
	return taxs
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.TaxList()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		return Taxs(Passport)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.TaxPayment(id)
	local source = source
	local Passport = rEVOLT.Passport(source)
	local id = id
	if Passport and Active[Passport] == nil then
		Active[Passport] = true
		local result = rEVOLT.Query('taxs/Check',{ Passport = Passport, id = id })
		if result[1] then
			if rEVOLT.PaymentBank(Passport, result[1].Value) then
				rEVOLT.Query("taxs/Remove",{ Passport = Passport, id = id })
				Active[Passport] = nil
				return true
			end
		end
		Active[Passport] = nil
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Invoices(Passport)
	local Passport = Passport
	local invoices = {}
	local result = rEVOLT.Query('invoices/List',{ Passport = Passport })
	if result[1] then
		for i, invoice in pairs(result) do
			if not invoices[invoice.Type] then
				invoices[invoice.Type] = {}
			end
			local id = invoice.id
			local reason = invoice.Reason
			local holder = invoice.Holder
			invoices[invoice.Type][#invoices[invoice.Type] + 1] = {id = id, reason = reason, holder = holder, value = invoice.Value}
		end
	end
	return invoices
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.InvoiceList()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		return Invoices(Passport)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.InvoicePayment(id)
	local source = source
	local Passport = rEVOLT.Passport(source)
	local id = id
	if Passport and Active[Passport] == nil then
		Active[Passport] = true
		local result = rEVOLT.Query('invoices/Check',{ Passport = Passport, id = id })
		if result[1] then
			local Amount = result[1].Value
			if result[1]["Reason"] == "Cartão de Crédito" then
				if rEVOLT.PaymentBank(Passport, Amount) then
					rEVOLT.Query("invoices/Remove",{ Passport = Passport, id = id })
					rEVOLT.DowngradeSpending(Passport, Amount)
					if rEVOLT.Identities(Passport).spending == 0 and math.random(100) <= 50 then
						rEVOLT.UpgradeCardlimit(Passport, parseInt(rEVOLT.Identities(Passport).cardlimit/4))
					else
						rEVOLT.UpgradeCardlimit(Passport, Amount)
					end
					Active[Passport] = nil
					return true
				end
			else
				if rEVOLT.PaymentBank(Passport, Amount) then
					rEVOLT.Query("invoices/Remove",{ Passport = Passport, id = id })
					rEVOLT.GiveBank(result[1]['Received'], Amount)
					Active[Passport] = nil
					return true
				end
			end
		end
		Active[Passport] = nil
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD DEPENDENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MakeInvoice(OtherPassport, value, reason)
	local source = source
	local Passport = rEVOLT.Passport(source)
	local OtherPassport = OtherPassport
	if Passport and not Active[Passport]  and parseInt(value) > 0 then
		Active[Passport] = true
		local ClosestPed = rEVOLT.Source(OtherPassport)
		if ClosestPed then
			if rEVOLT.Request(ClosestPed,"Banco","<b>" .. rEVOLT.Identities(Passport).name .. "	" .. rEVOLT.Identities(Passport).name2 .. "</b> lhe enviou uma fatura de <b>$" .. parseFormat(value) .. "</b>, deseja aceita-la?","Sim, aceito","Não, obrigado") then
				rEVOLT.Query('invoices/Add',{ 
					Passport = OtherPassport, 
					Received = Passport, 
					Type = "received", 
					Reason = reason, 
					Holder = rEVOLT.Identities(Passport).name .. " " .. rEVOLT.Identities(Passport).name2,
					Value = value
				})
				rEVOLT.Query('invoices/Add',{ 
					Passport = Passport, 
					Received = Passport, 
					Type = "sent", 
					Reason = reason, 
					Holder = rEVOLT.Identities(OtherPassport).name .. " " .. rEVOLT.Identities(OtherPassport).name2,
					Value = value
				})
				return Invoices(Passport)
			end
		end
		Active[Passport] = nil
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
--  INVESTMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Investments()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local investment = rEVOLT.Query('investments/Check',{ Passport = Passport })
		if investment[1] then
			local deposit = investment[1].Deposit
			local liquid = investment[1].Liquid
			local brute = deposit
			local total = deposit + liquid
			return {
				["deposit"] = deposit,
				["liquid"] = liquid,
				["brute"] = brute,
				["total"] = total
			}
		end
		return {
			["deposit"] = 0,
			["liquid"] = 0,
			["brute"] = 0,
			["total"] = 0
		}
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD INVESTMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Invest(amount)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and not Active[Passport] and parseInt(amount) > 0 then
		Active[Passport] = true
		if rEVOLT.PaymentBank(Passport, amount, true) then
			local investment = rEVOLT.Query('investments/Check',{ Passport = Passport })
			if  investment[1] then
				local Value = amount
				rEVOLT.Query("investments/Invest",{ Passport = Passport, Value = Value })
			else
				local Deposit = amount
				rEVOLT.Query("investments/Add",{ Passport = Passport, Deposit = Deposit })
			end
			Active[Passport] = nil
			return true
		end
		Active[Passport] = nil
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM INVESTMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.InvestRescue()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true
		local investment = rEVOLT.Query('investments/Check',{ Passport = Passport })
		if  investment[1] then
			rEVOLT.Query("investments/Remove", {Passport = Passport})
			rEVOLT.GiveBank(Passport, investment[1].Deposit + investment[1].Liquid)
		end
		Active[Passport] = nil
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTRANSACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddTransactions", function(Passport, Type, amount)
	if rEVOLT.Identities(Passport) then
		local Passport = Passport
		local Type = Type
		local Date = os.date("%d/%m/%Y")
		local Value = amount
		local Balance = rEVOLT.Identities(Passport).bank
		rEVOLT.Query("transactions/Add", {Passport = Passport,Type = Type,Date = Date,Value = Value,Balance = Balance})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTAXS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddTaxs", function(Passport, Name, Value, Message)
	if rEVOLT.Identities(Passport) then
		local Passport = Passport
		local Name = Name
		local Date = os.date("%d/%m/%Y")
		local Hour = os.date("%H:%M")
		local Value = Value
		local Message = Message
		rEVOLT.Query("taxs/Add", {Passport = Passport,Name = Name,Date = Date,Hour = Hour,Value = Value,Message = Message}) 
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTAXS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddFines", function(Passport, OtherPassport, Value, Message)
	if rEVOLT.Identities(Passport) then
		local Passport = Passport
		local Name = rEVOLT.Identities(OtherPassport).name .. " " .. rEVOLT.Identities(OtherPassport).name2
		local Date = os.date("%d/%m/%Y")
		local Hour = os.date("%H:%M")
		local Value = Value
		local Message = Message
		rEVOLT.Query("fines/Add", {Passport = Passport,Name = Name,Date = Date,Hour = Hour,Value = Value,Message = Message}) 
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)
exports("Taxs", Taxs)
exports("Fines", Fines)
exports("Invoices", Invoices)
exports("Dependents", Dependents)
exports("Transactions", Transactions)
