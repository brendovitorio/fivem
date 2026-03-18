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
cRP = {}
Tunnel.bindInterface("police",cRP)
vCLIENT = Tunnel.getInterface("police")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPRARES
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("prison/cleanRecords","DELETE FROM prison WHERE nuser_id = @nuser_id")
rEVOLT._Prepare("prison/cleanRecord","DELETE FROM prison WHERE id = @id AND nuser_id = @nuser_id")
rEVOLT._Prepare("prison/getRecords","SELECT * FROM prison WHERE nuser_id = @nuser_id ORDER BY id DESC")
rEVOLT._Prepare("prison/getRecords2","SELECT * FROM prison WHERE id = @id ORDER BY id DESC")
rEVOLT._Prepare("prison/insertPrison","INSERT INTO prison(police,nuser_id,services,fines,text,date,cops,association,residual,url) VALUES(@police,@nuser_id,@services,@fines,@text,@date,@cops,@association,@residual,@url)")

rEVOLT._Prepare("prison/insertPort","INSERT INTO port(identity,user_id,portType,serial,nidentity,date,exam) VALUES(@identity,@user_id,@portType,@serial,@nidentity,@date,@exam)")
rEVOLT._Prepare("prison/getPorts","SELECT * FROM port ORDER BY portId DESC")
rEVOLT._Prepare("prison/getPorts2","SELECT * FROM port WHERE portId = @portId")
rEVOLT._Prepare("prison/updatePort","UPDATE port SET identity = @identity,user_id = @user_id,portType = @portType,serial = @serial,nidentity = @nidentity,date = @date,exam = @exam WHERE portId = @portId")
rEVOLT._Prepare("prison/deletePort","DELETE FROM port WHERE portId = @portId")

rEVOLT._Prepare("prison/getReports","SELECT * FROM reports ORDER BY id DESC")
rEVOLT._Prepare("prison/setReportSolved","UPDATE reports SET solved = 0, updated_at = @updated_at WHERE id = @id")
rEVOLT._Prepare("prison/insertReport","INSERT INTO reports(victim_id, police_name, solved, victim_name, created_at, victim_report, updated_at) VALUES(@victim_id, @police_name, @solved, @victim_name, @created_at, @victim_report, @updated_at)")
rEVOLT._Prepare("prison/deleteReport","DELETE FROM reports WHERE id = @id")

rEVOLT._Prepare("prison/getWarrants","SELECT * FROM warrants ORDER BY id DESC")
rEVOLT._Prepare("prison/getWarrants2","SELECT * FROM warrants WHERE id = @id")
rEVOLT._Prepare("prison/deleteWarrant","DELETE FROM warrants WHERE id = @id")
rEVOLT._Prepare("prison/insertWarrant","INSERT INTO warrants(user_id, identity, status, nidentity, timeStamp, reason) VALUES(@user_id, @identity, @status, @nidentity, @timeStamp, @reason)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
local Prisoners = {}
local Reduces = {}
local PrisonItens = {
	{ ["Item"] = "cigarette", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "cannedsoup", ["Min"] = 1, ["Max"] = 1 },
	{ ["Item"] = "canofbeans", ["Min"] = 1, ["Max"] = 1 },
	{ ["Item"] = "sulfuric", ["Min"] = 1, ["Max"] = 1 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANREC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cleanrec",function(source,args,rawCommand)
	local Passport = rEVOLT.Passport(source)
	if Passport and args[1] then
		if rEVOLT.HasGroup(Passport,"Police", 1) then
			local nuser_id = parseInt(args[1])
			if nuser_id > 0 then
				rEVOLT.Query("prison/cleanRecords",{ nuser_id = nuser_id })
				TriggerClientEvent("Notify",source,"verde","Limpeza efetuada.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.initPrison(nuser_id,services,fines,text,association,residual,url,cops)
	local source = source
	local Passport = rEVOLT.Passport(source)
	local Name = rEVOLT.Identities(nuser_id).name.. " "..rEVOLT.Identities(nuser_id).name2
	local Hour = os.date("%H:%M:%S")
	local Date = os.date("%Y-%m-%d")
	if Passport and services > 0 then
		if actived[Passport] == nil then
			actived[Passport] = true

			local Identity = rEVOLT.Identities(Passport)
			if Identity then
				local OtherPlayer = rEVOLT.Source(nuser_id)
				if OtherPlayer then
					TriggerClientEvent("hud:RadioClean",OtherPlayer)
					TriggerClientEvent("police:Prisioner",OtherPlayer,true)
					Prisoners[nuser_id] = (Prisoners[nuser_id] and (Prisoners[nuser_id]+services)) or services
					TriggerClientEvent("Notify",OtherPlayer,"azul","Você deve cumprir <b>"..parseInt(services).." Meses</b>.",10000,"Sistema Penitenciário")
				end

				rEVOLT.Query("prison/insertPrison",{ 
					police = Identity["name"].." "..Identity["name2"], 
					nuser_id = parseInt(nuser_id), 
					services = services,
					fines = fines, 
					text = text, 
					date = os.date("%d/%m/%Y").." ás "..os.date("%H:%M"),
					cops = cops,
					association = association,
					residual = residual,
					url = url
				})

				rEVOLTC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
				TriggerClientEvent("Notify",source,"verde","Prisão efetuada.",5000)
				TriggerClientEvent("police:Update",source,"reloadPrison")
	
				if fines > 0 then
					rEVOLT.GiveFine(nuser_id,Name,fines,text,Hour,Date)
				end

				TriggerEvent("discordLogs","Police","**Por:** "..parseFormat(Passport).."\n**Passaporte:** "..parseFormat(nuser_id).."\n**Serviços:** "..parseFormat(services).."\n**Multa:** $"..parseFormat(fines).."\n**Horário:** "..os.date("%H:%M:%S").."\n**Motivo:** "..text,13541152)
			end

			actived[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHUSER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.searchUser(nuser_id)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local nuser_id = parseInt(nuser_id)
		local Identity = rEVOLT.Identities(nuser_id)
		if Identity then
			local fines = 0
			local result = rEVOLT.Query('fines/List',{ Passport = Passport })
			if result[1] then
				for i, row in pairs(result) do
					fines = fines + row.Value
				end
			end
			local ports = rEVOLT.Query("prison/getPorts")
			local records = rEVOLT.Query("prison/getRecords",{ nuser_id = parseInt(nuser_id) })
			return { true,Identity["name"].." "..Identity["name2"],Identity["phone"],fines,records,false,ports,0 }
		end
	end

	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPRISIONID
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPrisionId(prisonId)
	local records = rEVOLT.Query("prison/getRecords2",{ id = parseInt(prisonId) })
	if records[1] then
		return { true,{},records[1]}
	end
	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITFINE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.initFine(nuser_id,fines,text)
	local source = source
	local Passport = rEVOLT.Passport(source)
	local Name = rEVOLT.Identities(nuser_id).name.. " "..rEVOLT.Identities(nuser_id).name2
	local Hour = os.date("%H:%M:%S")
	local Date = os.date("%Y-%m-%d")
	if Passport and fines > 0 then
		if actived[Passport] == nil then
			actived[Passport] = true
			TriggerEvent("discordLogs","Police","**Por:** "..parseFormat(Passport).."\n**Passaporte:** "..parseFormat(nuser_id).."\n**Multa:** $"..parseFormat(fines).."\n**Horário:** "..os.date("%H:%M:%S").."\n**Motivo:** "..text,2316674)
			TriggerClientEvent("Notify",source,"verde","Multa aplicada.",5000)
			TriggerClientEvent("police:Update",source,"reloadFine")
			rEVOLT.Query("fines/Add", {Passport = nuser_id,Name = Name,Date = Date,Hour = Hour,Value = fines,Message = text}) 
			actived[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.searchPort()
	local ports = rEVOLT.Query("prison/getPorts")
	if ports[1] then
		return {
			true,
			ports
		}
	end
	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.givePort(user_id,serial,status,exame)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if actived[Passport] == nil and rEVOLT.HasGroup(Passport,"Police",1) then
			actived[Passport] = true
			local Identity = rEVOLT.Identities(Passport)
			local Identit = rEVOLT.Identities(user_id)
			if Identity and Identit then
				rEVOLT.Query("prison/insertPort",{ 
					identity = Identit["name"].." "..Identit["name2"],
					user_id = user_id,
					portType = status,
					serial = serial,
					exam = exame,
					nidentity = Identity["name"].." "..Identity["name2"], 
					date = os.date("%d/%m/%Y").." ás "..os.date("%H:%M")
				})
			end
			TriggerClientEvent("Notify",source,"verde","Porte adicionado.",5000)
			TriggerClientEvent("police:Update",source,"reloadPortes")
			actived[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPORTBYID
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getPortById(portId)
	local port = rEVOLT.Query("prison/getPorts2",{ portId = parseInt(portId) })
	if port[1] then
		return { 
			true,
			port[1]
		}
	end
	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EDITPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.editPort(portId, user_id, serial, status, exame)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if actived[Passport] == nil and rEVOLT.HasGroup(Passport,"Police",1) then
			actived[Passport] = true

			local Identity = rEVOLT.Identities(Passport)
			local Identit = rEVOLT.Identities(user_id)
			if Identity and Identit then
				rEVOLT.Query("prison/updatePort",{ 
					portId = portId,
					identity = Identit["name"].." "..Identit["name2"],
					user_id = user_id,
					portType = status,
					serial = serial,
					exam = exame,
					nidentity = Identity["name"].." "..Identity["name2"], 
					date = os.date("%d/%m/%Y").." ás "..os.date("%H:%M")
				})
			end

			TriggerClientEvent("Notify",source,"verde","Porte atualiado.",5000)
			TriggerClientEvent("police:Update",source,"reloadPortes")

			actived[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.deletePort(portId)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if actived[Passport] == nil and rEVOLT.HasGroup(Passport,"Police",1) then
			actived[Passport] = true

			rEVOLT.Query("prison/deletePort",{ portId = portId })

			TriggerClientEvent("Notify",source,"verde","Porte deletado.",5000)
			TriggerClientEvent("police:Update",source,"reloadPortes")

			actived[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETWARRANTS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getWarrants()
	local warrant = rEVOLT.Query("prison/getWarrants")
	if warrant[1] then
		return { true, warrant }
	end
	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWARRANTID
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkWarrantId(id)
	local warrant = rEVOLT.Query("prison/getWarrants2", { id = id })
	if warrant[1] then
		return { 
			true,
			warrant[1]["identity"],
			warrant[1]
		}
	end
	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEWARRANT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.deleteWarrant(id)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if rEVOLT.HasGroup(Passport, "Police", 1) then
		rEVOLT.Query("prison/deleteWarrant", { id = id })
		
		TriggerClientEvent("police:Update",source,"reloadProcurados")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWARRANT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.setWarrant(user_id,reason)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if rEVOLT.HasGroup(Passport, "Police", 1) then
		local Identity = rEVOLT.Identities(Passport)
		local Identit = rEVOLT.Identities(user_id)
		if Identity and Identit then
			rEVOLT.Query("prison/insertWarrant", {
				user_id = user_id,
				identity = Identit.name.." "..Identit.name2, 
				status = "Procurado",
				nidentity = Identity.name.." "..Identity.name2, 
				timeStamp = os.date("%d/%m/%Y").." ás "..os.date("%H:%M"),
				reason = reason
			})
			TriggerClientEvent("police:Update",source,"reloadProcurados")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETREPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getReports()
	local report = rEVOLT.Query("prison/getReports")
	return report
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDREPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.addReport(data)
	if data.victim_id and data.victim_report and data.victim_name then
		local source = source
		local Passport = rEVOLT.Passport(source)
		if Passport then
			if actived[Passport] == nil then
				actived[Passport] = true

				local Identity = rEVOLT.Identities(Passport)
				if Identity then
					rEVOLT.Query("prison/insertReport", {
						victim_id = data.victim_id, 
						police_name = Identity.name.." "..Identity.name2, 
						solved = nil,
						victim_name = data.victim_name, 
						created_at = os.date("%d/%m/%Y").." ás "..os.date("%H:%M"), 
						victim_report = data.victim_report, 
						updated_at = os.date("%d/%m/%Y").." ás "..os.date("%H:%M")
					})
				end
				actived[Passport] = nil
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETREPORTSOLVED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.setReportSolved(id)
	local update = os.date("%d/%m/%Y").." ás "..os.date("%H:%M")
	rEVOLT.Query("prison/setReportSolved", { id = id, updated_at = update })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETREPORTREMOVED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.setReportRemoved(id)
	rEVOLT.Query("prison/deleteReport", { id = id })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:REDUCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Reduce")
AddEventHandler("police:Reduce",function(Number)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
        if not Reduces[Number] then
            Reduces[Number] = {}
        end
        if not Reduces[Number][Passport] or (os.time() > Reduces[Number][Passport]) then
            Reduces[Number][Passport] = os.time() + 600
            Player(source)["state"]["Buttons"] = true
            Player(source)["state"]["Cancel"] = true
            rEVOLTC.playAnim(source,false,{"amb@prop_human_bum_bin@base","base"},true)
            TriggerClientEvent("Progress",source,10000)
            SetTimeout(10000,function()
                local Random = math.random(#PrisonItens)
                local Amount = math.random(PrisonItens[Random]["Min"],PrisonItens[Random]["Max"])
                rEVOLT.GenerateItem(Passport,PrisonItens[Random]["Item"],Amount,true)
                Prisoners[Passport] = parseInt(Prisoners[Passport] - math.random(2))
				if Prisoners[Passport] <= 0 then
					TriggerClientEvent("police:Prisioner",rEVOLT.Source(Passport),false)
					TriggerClientEvent("Notify",rEVOLT.Source(Passport),"azul","Sua sentença terminou, esperamos não ve-lo novamente.",5000,"Sistema Penitenciário")
					exports.oxmysql:query_async("UPDATE characters SET prison = @prison WHERE id = @Passport",{ Passport = Passport, prison = parseInt(Prisoners[Passport]) })
					Prisoners[Passport] = nil
				else
					TriggerClientEvent("Notify",source,"azul","Sua pena foi reduzida em <b>"..Prisoners[Passport].." Meses</b>.",5000,"Sistema Penitenciário")
				end

                Player(source)["state"]["Buttons"] = false
                Player(source)["state"]["Cancel"] = false
                rEVOLTC.removeObjects(source)
            end)
        else
            TriggerClientEvent("Notify",source,"azul","Nada encontrado.",5000,"Sistema Penitenciário")
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SRVSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        for Passport in pairs(Prisoners) do
			Prisoners[Passport] = Prisoners[Passport] - 1
            if Prisoners[Passport] <= 0 then
				TriggerClientEvent("police:Prisioner",rEVOLT.Source(Passport),false)
                TriggerClientEvent("Notify",rEVOLT.Source(Passport),"azul","Sua sentença terminou, esperamos não ve-lo novamente.",5000,"Sistema Penitenciário")
                exports.oxmysql:query_async("UPDATE characters SET prison = @prison WHERE id = @Passport",{ Passport = Passport, prison = parseInt(Prisoners[Passport]) })
                Prisoners[Passport] = nil
            else
				TriggerClientEvent("Notify",rEVOLT.Source(Passport), "azul", "Restam <b>" .. parseInt(Prisoners[Passport]) .. " Meses</b>.",5000,"Sistema Penitenciário")
            end
        end
        Citizen.Wait(60000)
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
--------------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	local Identity = rEVOLT.Identities(Passport)
	if parseInt(Identity["prison"]) > 0 then
		Wait(250)
		TriggerClientEvent("police:Prisioner",source,true)
		Prisoners[Passport] = parseInt(Identity["prison"])
        TriggerClientEvent("Notify",source,"azul","Ainda vai passar <b>"..parseInt(Identity["prison"]).." Meses</b> preso.",10000,"Sistema Penitenciário")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport)
    if Prisoners[Passport] ~= nil then
        exports.oxmysql:query_async("UPDATE characters SET prison = @prison WHERE id = @Passport",{ Passport = Passport, prison = parseInt(Prisoners[Passport]) })
        Prisoners[Passport] = nil
    end
end)