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
Tunnel.bindInterface("tattoos",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWANTED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckWanted()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and not exports["hud"]:Wanted(Passport,source) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATETATTOO
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.updateTattoo(Tattoos)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Tables = json.encode(Tattoos)
		if Tables ~= "[]" then
			rEVOLT.Query("playerdata/SetData",{ Passport = Passport, dkey = "Tatuagens", dvalue = Tables })
		end
	end
end