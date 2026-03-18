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
Tunnel.bindInterface("dynamic",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKS
-----------------------------------------------------------------------------------------------------------------------------------------
local Works = {
	["Dismantle"] = "Desmanche",
	["Tows"] = "Reboque",
	["Delivery"] = "Entregador",
	["Transporter"] = "Transportador",
	["Lumberman"] = "Lenhador"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Experience()
	local source = source
	local Passport = rEVOLT.Passport(source)
	local Datatable = rEVOLT.Datatable(Passport)
	if Passport and Datatable then
		local Experiences = {}

		for Index,v in pairs(Works) do
			if Datatable[Index] then
				Experiences[v] = Datatable[Index]
			else
				Experiences[v] = 0
			end
		end

		return Experiences
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISExclusive
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.isExclusive()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local exclusive = rEVOLT.HasGroup(Passport, "Premium")
		if exclusive then
			return true
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXCLUSIVAS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Exclusivas()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Clothes = {}
		local Consult = rEVOLT.GetSrvData("Exclusivas:"..Passport,true)

		for Index,v in pairs(Consult) do
			Clothes[#Clothes + 1] = { ["name"] = Index, ["id"] = v["id"], ["texture"] = v["texture"] or 0, ["type"] = v["type"] }
		end

		return Clothes
	end
end