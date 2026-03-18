-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("revolt", "lib/Tunnel")
Proxy = module("revolt", "lib/Proxy")
Tools = module("revolt","lib/Tools")
rEVOLT = Proxy.getInterface("rEVOLT")
rEVOLTclient = Tunnel.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface(GetCurrentResourceName(), Creative)
vTunnel = Tunnel.getInterface(GetCurrentResourceName())
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
Creative.checkPermission = function(perm)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if exports["hud"]:Wanted(Passport,source) then
			return false
		end
		if rEVOLT.HasGroup(Passport,perm,1 or 2 or 3) and rEVOLT.HasService(Passport,perm) or rEVOLT.HasGroup(Passport,perm,1 or 2 or 3) and rEVOLT.HasService(Passport,perm) then
			return true
		else
			TriggerClientEvent("Notify",source,"vermelho","Você Não Tem Permissão",5000)
			return false
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
Creative.saveRemap = function(Remap,Plate)
	if rEVOLT.PassportPlate(Plate) then
		rEVOLT.Query("entitydata/SetData",{ dkey = "Remap:"..Plate, dvalue = json.encode(Remap) })
	end
end