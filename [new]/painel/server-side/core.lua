-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local function safeModule(resource,path)
	local ok,result = pcall(module,resource,path)
	if ok then return result end
	return nil
end

local Tunnel = safeModule("revolt","lib/Tunnel") or safeModule("vrp","lib/Tunnel")
local Proxy = safeModule("revolt","lib/Proxy") or safeModule("vrp","lib/Proxy")
if not Tunnel or not Proxy then
	error("[police] Não foi possível carregar Tunnel/Proxy do core (vrp/revolt).")
end

local function getInterfaceWithFallback(provider,names)
	for _,name in ipairs(names) do
		local ok,result = pcall(provider.getInterface,name)
		if ok and result then return result end
	end
	return nil
end

vRPC = getInterfaceWithFallback(Tunnel,{"rEVOLT","revolt","REVOLT","vRP"})
vRP = getInterfaceWithFallback(Proxy,{"rEVOLT","revolt","REVOLT","vRP"})
if not vRP then
	error("[police] Não foi possível obter interface do core (vRP/revolt).")
end

local function HasPoliceGeneral(Passport)
	return vRP.HasGroup(Passport,"Police",1)
end

local function normalizeArticlesPayload(articles)
	local selected = {}
	local totalFine = 0
	local totalServices = 0

	if type(articles) ~= "table" then
		return selected, totalFine, totalServices
	end

	for _,article in pairs(articles) do
		if type(article) == "table" then
			local id = tonumber(article.id) or 0
			local title = tostring(article.title or article.name or "Artigo")
			local fine = tonumber(article.fine) or 0
			local services = tonumber(article.services) or 0

			if id > 0 then
				selected[#selected + 1] = {
					id = id,
					title = title,
					fine = fine,
					services = services
				}

				totalFine = totalFine + fine
				totalServices = totalServices + services
			end
		end
	end

	return selected, totalFine, totalServices
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("police",cRP)
vCLIENT = Tunnel.getInterface("police")
-----------------------------------------------------------------------------------------------------------------------------------------
-- OXMYSQL
-----------------------------------------------------------------------------------------------------------------------------------------
local DB_PREPARES = {}

local function dbPrepare(name,query)
	DB_PREPARES[name] = query
end

local function dbQuery(name,params)
	local query = DB_PREPARES[name] or name
	if type(query) ~= "string" then
		print(("[police] Query inválida em '%s' (tipo: %s)"):format(tostring(name),type(query)))
		return {}
	end

	local ok,result = pcall(function()
		return exports.oxmysql:query_async(query,params or {})
	end)

	if not ok then
		print(("[police] oxmysql falhou em '%s': %s"):format(tostring(name),tostring(result)))
		return {}
	end

	return result or {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
-----------------------------------------------------------------------------------------------------------------------------------------
dbPrepare("prison/cleanRecords","DELETE FROM prison WHERE nuser_id = @nuser_id")
dbPrepare("prison/getRecords","SELECT * FROM prison WHERE nuser_id = @nuser_id ORDER BY id DESC")
dbPrepare("prison/getRecords2","SELECT * FROM prison WHERE id = @id ORDER BY id DESC")
dbPrepare("prison/insertPrison","INSERT INTO prison(police,nuser_id,services,fines,text,date,cops,association,residual,url) VALUES(@police,@nuser_id,@services,@fines,@text,@date,@cops,@association,@residual,@url)")

dbPrepare("prison/insertPort","INSERT INTO port(identity,user_id,portType,serial,nidentity,date,exam) VALUES(@identity,@user_id,@portType,@serial,@nidentity,@date,@exam)")
dbPrepare("prison/getPorts","SELECT * FROM port ORDER BY portId DESC")
dbPrepare("prison/getPorts2","SELECT * FROM port WHERE portId = @portId")
dbPrepare("prison/updatePort","UPDATE port SET identity = @identity,user_id = @user_id,portType = @portType,serial = @serial,nidentity = @nidentity,date = @date,exam = @exam WHERE portId = @portId")
dbPrepare("prison/deletePort","DELETE FROM port WHERE portId = @portId")

dbPrepare("prison/getReports","SELECT * FROM reports ORDER BY id DESC")
dbPrepare("prison/setReportSolved","UPDATE reports SET solved = 1, updated_at = @updated_at WHERE id = @id")
dbPrepare("prison/insertReport","INSERT INTO reports(victim_id, police_name, solved, victim_name, created_at, victim_report, updated_at) VALUES(@victim_id, @police_name, @solved, @victim_name, @created_at, @victim_report, @updated_at)")
dbPrepare("prison/deleteReport","DELETE FROM reports WHERE id = @id")

dbPrepare("prison/getWarrants","SELECT * FROM warrants ORDER BY id DESC")
dbPrepare("prison/getWarrants2","SELECT * FROM warrants WHERE id = @id")
dbPrepare("prison/countWarrants","SELECT COUNT(*) as total FROM warrants WHERE user_id = @user_id AND status = 'Procurado'")
dbPrepare("prison/markWarrantsArrested","UPDATE warrants SET status = @status, timeStamp = @timeStamp WHERE user_id = @user_id AND status = 'Procurado'")
dbPrepare("prison/deleteWarrant","DELETE FROM warrants WHERE id = @id")
dbPrepare("prison/insertWarrant","INSERT INTO warrants(user_id, identity, status, nidentity, timeStamp, reason) VALUES(@user_id, @identity, @status, @nidentity, @timeStamp, @reason)")

dbPrepare("prison/searchVehicles",[[SELECT v.id, v.Passport, v.vehicle, v.plate, v.tax, v.rental, v.arrest, c.name, c.name2, c.phone FROM vehicles v LEFT JOIN characters c ON c.id = v.Passport WHERE v.plate = @plate OR CAST(v.Passport AS CHAR) = @passport OR v.vehicle LIKE @like ORDER BY CASE WHEN v.plate = @plate THEN 0 WHEN CAST(v.Passport AS CHAR) = @passport THEN 1 ELSE 2 END, v.id DESC LIMIT 50]])
dbPrepare("prison/searchCitizens",[[SELECT c.id, c.phone, c.name, c.name2, c.fines, c.prison FROM characters c WHERE c.deleted = 0 AND (CAST(c.id AS CHAR) = @termExact OR c.phone = @termExact OR CONCAT(COALESCE(c.name,''),' ' ,COALESCE(c.name2,'')) LIKE @termLike) ORDER BY CASE WHEN CAST(c.id AS CHAR) = @termExact THEN 0 WHEN c.phone = @termExact THEN 1 ELSE 2 END, c.id ASC LIMIT 25]])
dbPrepare("prison/getPenalArticles","SELECT id,title,description,fine,services FROM penal_articles ORDER BY id ASC")
dbPrepare("prison/createPenalArticle","INSERT INTO penal_articles(title,description,fine,services) VALUES(@title,@description,@fine,@services)")
dbPrepare("prison/updatePenalArticle","UPDATE penal_articles SET title = @title, description = @description, fine = @fine, services = @services WHERE id = @id")
dbPrepare("prison/deletePenalArticle","DELETE FROM penal_articles WHERE id = @id")
dbPrepare("prison/alterPrisonAddArticles","ALTER TABLE prison ADD COLUMN articles LONGTEXT NULL")

dbPrepare("prison/checkArticlesColumn",[[
	SELECT COUNT(*) as total
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = DATABASE()
	  AND TABLE_NAME = 'prison'
	  AND COLUMN_NAME = 'articles'
]])

-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATETABLE
-----------------------------------------------------------------------------------------------------------------------------------------
dbPrepare('prison/createPrison',[[CREATE TABLE IF NOT EXISTS `prison` (
		`id` int(11) NOT NULL AUTO_INCREMENT,
		`police` varchar(255) DEFAULT '0',
		`nuser_id` int(11) NOT NULL DEFAULT '0',
		`services` int(11) NOT NULL DEFAULT '0',
		`fines` int(20) NOT NULL DEFAULT '0',
		`text` longtext,
		`date` text,
		`cops` longtext NOT NULL DEFAULT '0',
		`association` longtext NOT NULL DEFAULT '0',
		`residual` text,
		`url` longtext,
		PRIMARY KEY (`id`),
		KEY `id` (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;
]])

dbPrepare('prison/createPort',[[CREATE TABLE IF NOT EXISTS `port` (
		`portId` int(11) NOT NULL AUTO_INCREMENT,
		`identity` longtext,
		`user_id` text,
		`portType` longtext,
		`serial` longtext,
		`nidentity` longtext,
		`exam` longtext,
		`date` text,
		PRIMARY KEY (`portId`),
		KEY `portId` (`portId`)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;
]])

dbPrepare('prison/createReports',[[CREATE TABLE IF NOT EXISTS `reports` (
		`id` int(11) NOT NULL AUTO_INCREMENT,
		`victim_id` text,
		`police_name` text,
		`solved` text,
		`victim_name` text,
		`created_at` text,
		`victim_report` text,
		`updated_at` text,
		PRIMARY KEY (`id`),
		KEY `portId` (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;
]])

dbPrepare('prison/createWarrants',[[CREATE TABLE IF NOT EXISTS `warrants` (
		`id` int(11) NOT NULL AUTO_INCREMENT,
		`user_id` text,
		`identity` text,
		`status` text,
		`nidentity` text,
		`timeStamp` text,
		`reason` text,
		PRIMARY KEY (`id`),
		KEY `portId` (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;
]])

dbPrepare('prison/createPenalArticles',[[CREATE TABLE IF NOT EXISTS `penal_articles` (
		`id` int(11) NOT NULL AUTO_INCREMENT,
		`title` varchar(100) NOT NULL,
		`description` text,
		`fine` int(11) NOT NULL DEFAULT '0',
		`services` int(11) NOT NULL DEFAULT '0',
		PRIMARY KEY (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;
]])

CreateThread(function()
	dbQuery('prison/createPrison')
	dbQuery('prison/createPort')
	dbQuery('prison/createReports')
	dbQuery('prison/createWarrants')
	dbQuery('prison/createPenalArticles')
	
	local checkColumn = dbQuery("prison/checkArticlesColumn",{})
	if checkColumn and checkColumn[1] and tonumber(checkColumn[1].total) <= 0 then
		dbQuery("prison/alterPrisonAddArticles",{})
	end
end)

local function OpenMdt(source)
	local Passport = vRP.Passport(source)
	if not Passport then
		return
	end

	if vRP.HasGroup and vRP.HasGroup(Passport,"Police") then
		TriggerClientEvent("revolt:Mdt",source)
	else
		TriggerClientEvent("Notify",source,"vermelho","Você não tem permissão para abrir o MDT.",5000)
	end
end

RegisterCommand("mdt",function(source,args,rawCommand)
	OpenMdt(source)
end)

RegisterServerEvent("revolt:tryOpenMdt")
AddEventHandler("revolt:tryOpenMdt",function()
	OpenMdt(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
local prisonMarkers = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local Preset = {
	["mp_m_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 145, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 395, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 83, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 152, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 14, texture = 0 },
		["torso"] = { item = 418, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 86, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:PRISONCLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:prisonClothes")
AddEventHandler("police:prisonClothes",function(entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		local mHash = vRP.ModelPlayer(entity[1])
		if mHash == "mp_m_freemode_01" or mHash == "mp_f_freemode_01" then
			TriggerClientEvent("updateRoupas",entity[1],Preset[mHash])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANREC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cleanrec",function(source,args,rawCommand)
	local Passport = vRP.Passport(source)
	if Passport and args[1] then
		if vRP.HasPermission(Passport,"Police", 1) then
			local nuser_id = parseInt(args[1])
			if nuser_id > 0 then
				dbQuery("prison/cleanRecords",{ nuser_id = nuser_id })
				TriggerClientEvent("Notify",source,"verde","Limpeza efetuada.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.initPrison(nuser_id,services,fines,text,association,residual,url,cops,articles)
	local source = source
	local Passport = vRP.Passport(source)
	local Name = vRP.Identity(nuser_id).name.. " "..vRP.Identity(nuser_id).name2
	local Hour = os.date("%H:%M:%S")
	local Date = os.date("%Y-%m-%d")
	if Passport then
		if actived[Passport] == nil then
			actived[Passport] = true

			local Identity = vRP.Identity(Passport)
			if Identity then
				local otherPlayer = vRP.Source(nuser_id)
				if otherPlayer then
					vCLIENT.syncPrison(otherPlayer,true,false)
					TriggerClientEvent("hud:RadioClean",otherPlayer)
				end

				local selectedArticles = {}
				local articleLabels = {}
				local autoServices = 0
				local autoFines = 0

				if type(articles) == "table" then
					for _,article in pairs(articles) do
						if type(article) == "table" then
							local articleId = tonumber(article.id or 0) or 0
							local articleTitle = tostring(article.title or article.name or "Artigo")
							local articleFine = tonumber(article.fine or 0) or 0
							local articleServices = tonumber(article.services or 0) or 0
							if articleId > 0 then
								selectedArticles[#selectedArticles + 1] = { id = articleId, title = articleTitle, fine = articleFine, services = articleServices }
								articleLabels[#articleLabels + 1] = tostring(articleId).." - "..articleTitle
								autoServices = autoServices + articleServices
								autoFines = autoFines + articleFine
							end
						end
					end
				end

				if #selectedArticles > 0 then
					if parseInt(services) <= 0 then services = autoServices end
					if parseInt(fines) <= 0 then fines = autoFines end
					local articleText = "[ARTIGOS] "..table.concat(articleLabels, ", ")
					text = articleText..(text and text ~= "" and " | "..text or "")
				end

				dbQuery("prison/insertPrison",{ 
					police = Identity["name"].." "..Identity["name2"], 
					nuser_id = parseInt(nuser_id), 
					services = services,
					fines = fines, 
					text = text, 
					date = os.date("%d/%m/%Y").." ás "..os.date("%H:%M"),
					cops = cops,
					association = association,
					residual = residual,
					url = (#selectedArticles > 0 and json.encode(selectedArticles) or url)
				})

				dbQuery("prison/markWarrantsArrested",{
					user_id = tostring(nuser_id),
					status = "Preso",
					timeStamp = os.date("%d/%m/%Y").." ás "..os.date("%H:%M")
				})

				vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
				TriggerClientEvent("Notify",source,"verde","Prisão efetuada.",5000)
				TriggerClientEvent("police:Update",source,"reloadPrison")
				TriggerClientEvent("police:Update",source,"reloadProcurados")
				vRP.InitPrison(nuser_id,services)

				if fines > 0 then
					vRP.GiveFine(nuser_id,Name,fines,text,Hour,Date)
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
function cRP.searchUser(term)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return { found = false, results = {} }
	end

	term = tostring(term or ""):gsub("^%s+",""):gsub("%s+$","")
	if term == "" then
		return { found = false, results = {} }
	end

	local citizens = dbQuery("prison/searchCitizens",{
		termExact = term,
		termLike = "%"..term.."%"
	})

	local results = {}
	for _,row in ipairs(citizens or {}) do
		local citizenPassport = tonumber(row.id) or 0
		local records = dbQuery("prison/getRecords",{ nuser_id = citizenPassport })
		local allPorts = dbQuery("prison/getPorts")
		local ports = {}
		for _,port in ipairs(allPorts or {}) do
			if tonumber(port.user_id) == citizenPassport then
				ports[#ports + 1] = port
			end
		end
		local warrantCount = dbQuery("prison/countWarrants",{ user_id = tostring(citizenPassport) })
		results[#results + 1] = {
			found = true,
			passport = citizenPassport,
			name = ((row.name or "Individuo").." "..(row.name2 or "Indigente")),
			phone = row.phone or "Sem telefone",
			fines = tonumber(row.fines) or 0,
			prison = tonumber(row.prison) or 0,
			records = records or {},
			ports = ports,
			warrants = (warrantCount[1] and tonumber(warrantCount[1].total) or 0)
		}
	end

	return {
		found = #results > 0,
		results = results
	}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPRISIONID
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPrisionId(prisonId)
	local records = dbQuery("prison/getRecords2",{ id = parseInt(prisonId) })

	if records[1] then
		return { 
			true,
			{},
			records[1]
		}
	end

	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITFINE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.initFine(nuser_id,fines,text)
	local source = source
	local Passport = vRP.Passport(source)
	local Name = vRP.Identity(nuser_id).name.. " "..vRP.Identity(nuser_id).name2
	local Hour = os.date("%H:%M:%S")
	local Date = os.date("%Y-%m-%d")
	if Passport and fines > 0 then
		if actived[Passport] == nil then
			actived[Passport] = true

			TriggerEvent("discordLogs","Police","**Por:** "..parseFormat(Passport).."\n**Passaporte:** "..parseFormat(nuser_id).."\n**Multa:** $"..parseFormat(fines).."\n**Horário:** "..os.date("%H:%M:%S").."\n**Motivo:** "..text,2316674)
			TriggerClientEvent("Notify",source,"verde","Multa aplicada.",5000)
			TriggerClientEvent("police:Update",source,"reloadFine")
			vRP.GiveFine(nuser_id,Name,fines,text,Hour,Date)

			actived[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISONSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(prisonMarkers) do
			if prisonMarkers[k][1] > 0 then
				prisonMarkers[k][1] = prisonMarkers[k][1] - 1

				if prisonMarkers[k][1] <= 0 then
					if vRP.Source(prisonMarkers[k][2]) then
						TriggerEvent("blipsystem:serviceExit",k)
					end

					prisonMarkers[k] = nil
				end
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REDUCEPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.reducePrison()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.UpdatePrison(Passport,math.random(2))

		local Identity = vRP.Identity(Passport)
		if parseInt(Identity["prison"]) <= 0 then
			vCLIENT.syncPrison(source,false,true)
		else
			vCLIENT.asyncServices(source)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.searchPort()
	local ports = dbQuery("prison/getPorts")
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
	local Passport = vRP.Passport(source)
	if Passport then
		if actived[Passport] == nil and vRP.HasPermission(Passport,"Police",1) then
			actived[Passport] = true

			local Identity = vRP.Identity(Passport)
			local Identit = vRP.Identity(user_id)
			if Identity and Identit then
				dbQuery("prison/insertPort",{ 
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
	local port = dbQuery("prison/getPorts2",{ portId = parseInt(portId) })

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
	local Passport = vRP.Passport(source)
	if Passport then
		if actived[Passport] == nil and vRP.HasPermission(Passport,"Police",1) then
			actived[Passport] = true

			local Identity = vRP.Identity(Passport)
			local Identit = vRP.Identity(user_id)
			if Identity and Identit then
				dbQuery("prison/updatePort",{ 
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
	local Passport = vRP.Passport(source)
	if Passport then
		if actived[Passport] == nil and vRP.HasPermission(Passport,"Police",1) then
			actived[Passport] = true

			dbQuery("prison/deletePort",{ portId = portId })

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
	local warrant = dbQuery("prison/getWarrants")
	if warrant[1] then
		return {
			true,
			warrant
		}
	end

	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWARRANTID
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkWarrantId(id)
	local warrant = dbQuery("prison/getWarrants2", { id = id })
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
	local Passport = vRP.Passport(source)
	if vRP.HasPermission(Passport, "Police", 1) then
		dbQuery("prison/deleteWarrant", { id = id })
		
		TriggerClientEvent("police:Update",source,"reloadProcurados")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWARRANT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.setWarrant(user_id,reason)
	local source = source
	local Passport = vRP.Passport(source)
	if vRP.HasPermission(Passport, "Police", 1) then
		local Identity = vRP.Identity(Passport)
		local Identit = vRP.Identity(user_id)
		if Identity and Identit then
			dbQuery("prison/insertWarrant", {
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
-- SEARCHVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.searchVehicles(term)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return { vehicles = {} } end

	term = tostring(term or ""):gsub("^%s+",""):gsub("%s+$","")
	if term == "" then return { vehicles = {} } end

	local search = dbQuery("prison/searchVehicles",{
		plate = string.upper(term),
		passport = term,
		like = "%"..term.."%"
	})

	local now = os.time()
	local vehicles = {}
	for _,veh in pairs(search or {}) do
		local arrest = tonumber(veh.arrest or 0) or 0
		local seized = arrest == 1 or arrest > now
		vehicles[#vehicles+1] = {
			id = veh.id,
			plate = veh.plate or "SEM PLACA",
			model = veh.vehicle or "Desconhecido",
			owner = ((veh.name or "Sem").." "..(veh.name2 or "registro")):gsub("%s+"," "),
			ownerPhone = veh.phone or "Sem telefone",
			passport = veh.Passport,
			status = seized and "Apreendido" or "Regular",
			tax = veh.tax or 0,
			rental = veh.rental or 0
		}
	end

	return { vehicles = vehicles }
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETINITIALDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getInitialData()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Identity = vRP.Identity(Passport) or {}
		local reports = dbQuery("prison/getReports")
		local warrants = dbQuery("prison/getWarrants")
		local isSuperior = false
		if vRP.HasPermission then
			local ok,result = pcall(vRP.HasPermission,Passport,"Police",2)
			if ok and result then isSuperior = true end
		end

		local policeHierarchy = { "Chefe","Capitão","Tenente","Sargento","Corporal","Oficial","Cadete" }
		local policeLevel = false
		if vRP.HasPermission then
			local okLevel,resultLevel = pcall(vRP.HasPermission,Passport,"Police")
			if okLevel and resultLevel then policeLevel = tonumber(resultLevel) end
		end
		local rank = Identity.rank or Identity.patent or (policeLevel and policeHierarchy[policeLevel]) or "Oficial"
		local unit = Identity.unit or "Polícia Revolt"
		local officerName = ((Identity.name or "Oficial").." "..(Identity.name2 or "")):gsub("%s+$","")

		return {
			isPoliceGeneral = isSuperior,
			officer = {
				passport = Passport,
				name = officerName ~= "" and officerName or "Oficial",
				badge = tostring(Passport),
				rank = rank,
				unit = unit,
				joinDate = os.date("%d/%m/%Y"),
				status = "10-8",
				isSuperior = isSuperior,
				stats = {
					arrests = 0,
					tickets = 0,
					reports = #reports,
					warrants = #warrants
				}
			},
			reports = reports,
			warrants = warrants
		}
	end

	return {
		isPoliceGeneral = false,
		officer = {
			passport = 0,
			name = "Oficial",
			badge = "0000",
			rank = "Officer",
			unit = "Police Department",
			joinDate = os.date("%d/%m/%Y"),
			status = "10-8",
			isSuperior = false,
			stats = { arrests = 0, tickets = 0, reports = 0, warrants = 0 }
		},
		reports = {},
		warrants = {}
	}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETREPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getReports()
	local report = dbQuery("prison/getReports")
	return report
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDREPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.addReport(data)
	if data.victim_id and data.victim_report and data.victim_name then
		local source = source
		local Passport = vRP.Passport(source)
		if Passport then
			if actived[Passport] == nil then
				actived[Passport] = true

				local Identity = vRP.Identity(Passport)
				if Identity then
					dbQuery("prison/insertReport", {
						victim_id = data.victim_id, 
						police_name = Identity.name.." "..Identity.name2, 
						solved = 0,
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
	dbQuery("prison/setReportSolved", { id = id, updated_at = update })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETREPORTREMOVED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.setReportRemoved(id)
	dbQuery("prison/deleteReport", { id = id })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPENALARTICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getPenalArticles()
	return dbQuery("prison/getPenalArticles") or {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEPENALARTICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.createPenalArticle(data)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or not vRP.HasPermission(Passport,"Police",1) then
		return { success = false, message = "Sem permissão." }
	end

	local title = tostring(data.title or "")
	local description = tostring(data.description or "")
	local fine = tonumber(data.fine) or 0
	local services = tonumber(data.services) or 0

	if title == "" then
		return { success = false, message = "Título inválido." }
	end

	dbQuery("prison/createPenalArticle",{ title = title, description = description, fine = fine, services = services })
	return { success = true }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPENALARTICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updatePenalArticle(data)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or not vRP.HasPermission(Passport,"Police",1) then
		return { success = false, message = "Sem permissão." }
	end

	local id = tonumber(data.id) or 0
	local title = tostring(data.title or "")
	local description = tostring(data.description or "")
	local fine = tonumber(data.fine) or 0
	local services = tonumber(data.services) or 0

	if id <= 0 or title == "" then
		return { success = false, message = "Dados inválidos." }
	end

	dbQuery("prison/updatePenalArticle",{ id = id, title = title, description = description, fine = fine, services = services })
	return { success = true }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEPENALARTICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.deletePenalArticle(id)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or not vRP.HasPermission(Passport,"Police",1) then
		return { success = false, message = "Sem permissão." }
	end

	id = tonumber(id) or 0
	if id <= 0 then
		return { success = false, message = "ID inválido." }
	end

	dbQuery("prison/deletePenalArticle",{ id = id })
	return { success = true }
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
---------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	local Identity = vRP.Identity(Passport)
	if parseInt(Identity["prison"]) > 0 then
		TriggerClientEvent("Notify",source,"azul","Restam <b>"..parseInt(Identity["prison"]).." serviços</b>.",5000)
		vCLIENT.syncPrison(source,true,true)
	end
end)