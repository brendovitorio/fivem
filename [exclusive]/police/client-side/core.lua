-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
rEVOLTS = Tunnel.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("police",cRP)
vSERVER = Tunnel.getInterface("police")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function(data,cb)
	SendNUIMessage({ action = "closeSystem" })
	SetNuiFocus(false,false)
	rEVOLT.removeObjects()
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("initPrison",function(data,cb)
	vSERVER._initPrison(data["passaporte"],data["servicos"],data["multas"],data["texto"],data["associacao"],data["material"],data["url"],data["militares"])
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITFINE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("initFine",function(data,cb)
	vSERVER._initFine(data["passaporte"],data["multas"],data["texto"],data["cnh"])
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHUSER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("searchUser",function(data,cb)
	local r = vSERVER.searchUser(parseInt(data["passaporte"]))
	cb({ result = r })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXCLUIR PROCURADO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("deleteWarrant",function(data,cb)
	vSERVER._deleteWarrant(data["excluirpro"])
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERIR PORTE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("givePort",function(data,cb)
	vSERVER._givePort(parseInt(data["passaporte"]),data["serial"],data["status"],data["exame"])
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EDITAR PORTE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("editPort",function(data,cb)
	vSERVER._editPort(parseInt(data["id"]), parseInt(data["passaporte"]), data["serial"], data["status"], data["exame"])
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXCLUIR PORTE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("deletePort",function(data,cb)
	vSERVER._deletePort(data["excluirporte"])
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETORNAR DADOS PARA FORMULÁRIO DE EDITAR PORTE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getPortById",function(data,cb)
	cb({ result = vSERVER.getPortById(data["idedporte"]) })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LISTA DE PORTES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback('searchPort', function(data, cb)
    if data.type == "consultar" then
		cb({ result = vSERVER.searchPort() })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERIR PROCURADO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("setWarrant",function(data,cb)
	vSERVER._setWarrant(parseInt(data["passaporte"]),data["texto"])
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PESQUISAR PROCURADO POR ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("checkWarrantId",function(data,cb)
	local r = vSERVER.checkWarrantId(data["idprocurado"])
	cb({ result = r })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LISTA DE PROCURADOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback('getWarrants', function(data, cb)
    if data.type == "consultar" then
		cb({ result = vSERVER.getWarrants() })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PESQUISAR PRISAO POR ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("checkPrisionId",function(data,cb)
	cb({ result = vSERVER.checkPrisionId(parseInt(data["idprisao"])) })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE NACIONALIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updatePolice",function(data,cb)
	vSERVER._updatePolice(data["passaporte"])
	cb("ok")
end)
RegisterNUICallback("getReports", function(_,cb)
	cb(vSERVER.getReports())
end)
RegisterNUICallback("setReportSolved", function(data,cb)
	vSERVER.setReportSolved(data.id)
	cb('ok')
end)
RegisterNUICallback("setReportRemoved", function(data,cb)
	vSERVER.setReportRemoved(data.id)
	cb('ok')
end)
RegisterNUICallback("addReport", function(data,cb)
	vSERVER.addReport(data)
	cb('ok')
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:Mdt")
AddEventHandler("police:Mdt",function()
	local ped = PlayerPedId()
	if not IsPedSwimming(ped) then
		SendNUIMessage({ action = "openSystem" })
		TriggerEvent("dynamic:closeSystem")
		SetNuiFocus(true,true)
		if not IsPedInAnyVehicle(ped) then
			rEVOLT.removeObjects()
			rEVOLT.createObjects("amb@code_human_in_bus_passenger_idles@female@tablet@base","base","prop_cs_tablet",50,28422)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:INSERTBARRIER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:insertBarrier")
AddEventHandler("police:insertBarrier",function()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) then
		local heading = GetEntityHeading(ped)
		local mHash = GetHashKey("prop_mp_barrier_02b")
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.5,0.0)
		RequestModel(mHash)
		while not HasModelLoaded(mHash) do
			Citizen.Wait(1)
		end
		if HasModelLoaded(mHash) then
			local newObject = CreateObject(mHash,coords["x"],coords["y"],coords["z"],true,true,false)
			local netObjs = ObjToNet(newObject)
			SetNetworkIdCanMigrate(netObjs,true)
			PlaceObjectOnGroundProperly(newObject)
			SetEntityAsMissionEntity(newObject,true,false)
			SetEntityHeading(newObject,heading - 180)
			FreezeEntityPosition(newObject,true)
			SetModelAsNoLongerNeeded(mHash)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:Update")
AddEventHandler("police:Update",function(action,data)
	SendNUIMessage({ action = action, data = data })
end)