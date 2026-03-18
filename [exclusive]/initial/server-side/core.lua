-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLTC = Tunnel.getInterface("rEVOLT")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("initial",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Save(vehName)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
        local Identity = rEVOLT.Identities(Passport)
        local vehicle = rEVOLT.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
        if vehicle[1] then
            TriggerClientEvent("Notify",source,"amarelo","Já possui um <b>"..vehName.."</b>.",3000)
            return
        else
            exports.oxmysql:query_async("INSERT IGNORE INTO vehicles(Passport,vehicle,plate,work,rental,tax) VALUES(@Passport,@vehicle,@plate,@work,@rental,UNIX_TIMESTAMP() + 604800)",{ Passport = Passport, vehicle = vehName, plate = rEVOLT.GeneratePlate(), rental = os.time() + 604800, work = "false" })
            if NotifyConfig then
                TriggerClientEvent("Notify", source, "azul","Nossa equipe da administração está muito feliz em ter você conosco, trabalhamos incansavelmente para desenvolver o melhor ambiente para sua diversão, conte conosco e saiba que o nosso discord está aberto para dúvidas, sugestões e afins. <br><br>Tenha uma ótima estadia e um bom jogo.<br>Divirta-se! Bem-vindo(a) " .. Identity["name"] .. " " ..Identity["name2"], 10000)
                TriggerClientEvent("Notify",source,"verde","Veiculo "..vehName.." adicionado em sua garagem, Lembrando que a duração do mesmo é de 7 dias!!!",10000)
            end
        end
	end
end