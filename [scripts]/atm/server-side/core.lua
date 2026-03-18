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
Tunnel.bindInterface("atm",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Bank()
	local Source = source
	local Passport = rEVOLT.Passport(Source)
	if Passport then
		for Key,Value in pairs(rEVOLT.Inventory(Passport)) do
            if SplitOne(Value["item"]) == "debitcard" then
                local Identity = rEVOLT.Identities(parseInt(SplitTwo(Value["item"]))) 
                if Passport == parseInt(SplitTwo(Value["item"])) then
                    if rEVOLT.Request(Source,"Pagamento","Você deseja acessar o caixa eletrônico com o cartão que está em nome de <b>"..Identity.name.." "..Identity.name2.."</b>?") then 
						return { Password = Identity.cardpassword, Balance = Identity.bank }
                    end
                end
            end
        end
		TriggerClientEvent("Notify",Source,"amarelo","Precisa de um <b>Cartão de Débito</b>.",5000)
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANKDEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Deposit(amount)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and Active[Passport] == nil then
		if parseInt(amount) > 0 then
			Active[Passport] = true
			if rEVOLT.PaymentMoney(Passport,amount) then
				rEVOLT.GiveBank(Passport, amount)
			end
			Active[Passport] = nil
		end
	end
	return rEVOLT.Identities(Passport).bank
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANWITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Withdraw(amount)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and Active[Passport] == nil  then
		if parseInt(amount) > 0 then
			Active[Passport] = true
			rEVOLT.WithdrawCash(Passport, amount)
			Active[Passport] = nil
		end
	end
	return rEVOLT.Identities(Passport).bank
end