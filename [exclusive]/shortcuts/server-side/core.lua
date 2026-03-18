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
Tunnel.bindInterface("shortcuts",Creative)

local Shortcuts = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHORTCUTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Shortcuts()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Inventory = rEVOLT.Inventory(Passport)
		if Inventory then
			for i = 1,5 do
				local Slot = tostring(i)
				if Inventory[Slot] then
					Shortcuts[Slot] = "nui://revolt/config/inventory/"..itemIndex(Inventory[Slot]["item"])..".png"
				else
					Shortcuts[Slot] = ""
				end
			end

			return Shortcuts
		end
	end

	return false
end