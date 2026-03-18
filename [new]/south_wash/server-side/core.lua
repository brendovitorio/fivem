-----------------------------------------------------------------------------------------------------------------------------------------
-- CONECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("revolt","lib/Tunnel")
Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")

vServer = {}
Tunnel.bindInterface(GetCurrentResourceName(), vServer)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local permissionOne = ""
local permissionTwo = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENS NECESSARY
-----------------------------------------------------------------------------------------------------------------------------------------
local itemNecessaryOne = "pendrive2"
local itemNecessaryTwo = "notebook"
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENS
-----------------------------------------------------------------------------------------------------------------------------------------
local moneyName = "dollars"
local moneyIlegalName = "dollarz"
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENS NECESSARY
-----------------------------------------------------------------------------------------------------------------------------------------
local porcentagemWash = 0.3
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("TerminalTablePerm")
RegisterServerEvent("TerminalTablePerm",function()
    local source = source
    local Passport = rEVOLT.Passport(source)

    if Passport then
		if rEVOLT.HasGroup(Passport,permissionOne) or rEVOLT.HasGroup(Passport,permissionTwo) then
		    TriggerClientEvent("TerminalTableOpen",source)
        else
           TriggerClientEvent("Notify",source,"vermelho","Você não conseguiu desbloquear o computador.",5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
function vServer.checkMoney(money)
    local source = source
    local Passport = rEVOLT.Passport(source)

    if Passport then
        if rEVOLT.ItemAmount(Passport,itemNecessaryOne) >= 1 or rEVOLT.ItemAmount(Passport,itemNecessaryTwo) >= 1 then
            if rEVOLT.ItemAmount(Passport,moneyIlegalName) >= tonumber(money) then
                if rEVOLT.TakeItem(Passport,itemNecessaryOne,1,true) or rEVOLT.TakeItem(Passport,itemNecessaryTwo,1,true) then
                    if rEVOLT.TakeItem(Passport,moneyIlegalName,tonumber(money),true) then
                        local moneyDisccount = money - (money * porcentagemWash)
                        local porcentagemInteira = math.floor(porcentagemWash * 100)
                        rEVOLT.GenerateItem(Passport,moneyName,math.floor(moneyDisccount),true)
                        TriggerClientEvent("Notify",source,"azul","O custo da atividade foi dê "..porcentagemInteira.."% do valor total.",5000)
                    else
                        TriggerClientEvent("Notify",source,"vermelho","<b>Dinheiro</b> insuficiente.",5000)
                    end
                end
            else
                TriggerClientEvent("Notify",source,"vermelho","Você não tem o dinheiro.",5000)
            end
        else
            TriggerClientEvent("Notify",source,"vermelho","Você não inseriu o pendrive.",5000)
        end
    end
end