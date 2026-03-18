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
Tunnel.bindInterface("target",Creative)

local ParamedicosParaDesabilitarMaca = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckIn() --Tratamento na maca
	local source = source
	local Passport = rEVOLT.Passport(source)
	local Service, Amount = rEVOLT.NumPermission("Paramedic")
	
	if Amount >= ParamedicosParaDesabilitarMaca then
		TriggerClientEvent("Notify",source,"vermelho","Há paramédicos em serviço, procure-os",5000)
		return false
	end

	if Passport then
		if rEVOLT.GetHealth(source) <= 100 then
			if rEVOLT.PaymentFull(Passport,975) then
				rEVOLT.UpgradeHunger(Passport,20)
				rEVOLT.UpgradeThirst(Passport,20)
				TriggerEvent("Reposed",source,Passport,120)

				return true
			else
				TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
			end
		else
			if rEVOLT.Request(source,"Prosseguir o tratamento por <b>$800</b> dólares?","Sim, iniciar tratamento","Não, volto mais tarde") then
				if rEVOLT.PaymentFull(Passport,800) then
					rEVOLT.UpgradeHunger(Passport,20)
					rEVOLT.UpgradeThirst(Passport,20)
					TriggerEvent("Reposed",source,Passport,120)

					return true
				else
					TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:CALLWORKS
-----------------------------------------------------------------------------------------------------------------------------------------
local Calls = {}
RegisterServerEvent("target:CallWorks")
AddEventHandler("target:CallWorks",function(Perm)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if not Calls[Perm] then
			Calls[Perm] = os.time()
		end

		if os.time() >= Calls[Perm] then
			if Perm == "Paramedic" then
				TriggerClientEvent("Notify",-1,"amarelo","<b>Pillbox Medical:</b> Estamos em busca de doadores de sangue, seja solidário e ajude o próximo, procure um de nossos profissionais.",15000)
			else
				TriggerClientEvent("Notify",-1,"amarelo","<b>"..Perm..":</b> Estamos em busca de trabalhadores, compareça ao estabelecimento, procure um de nossos funcionários e consulte nosso serviço de entregas.",15000)
			end

			Calls[Perm] = os.time() + 600
		else
			local Cooldown = parseInt(Calls[Perm] - os.time())
			TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..Cooldown.."</b> segundos.",5000)
		end
	end
end)