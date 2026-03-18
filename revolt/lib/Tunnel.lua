local Tools = module("lib/Tools")

local TriggerRemoteEvent = nil
local RegisterLocalEvent = nil

if SERVER then
	TriggerRemoteEvent = TriggerClientEvent
	RegisterLocalEvent = RegisterServerEvent
else
	TriggerRemoteEvent = TriggerServerEvent
	RegisterLocalEvent = RegisterNetEvent
end

local Tunnel = {}

local tpack = table.pack
local tunpack = table.unpack
local ssub = string.sub

-- Resolve remote interface function on demand.
local function tunnel_resolve(itable, key)
	local mtable = getmetatable(itable)
	local iname = mtable.name
	local ids = mtable.tunnel_ids
	local callbacks = mtable.tunnel_callbacks
	local identifier = mtable.identifier

	local fname = key
	local no_wait = false
	if ssub(key, 1, 1) == "_" then
		fname = ssub(key, 2)
		no_wait = true
	end

	local fcall = function(...)
		local r = nil

		-- Pack args once (fast + keeps count)
		local packed = tpack(...)

		local dest = nil
		local msg = packed

		if SERVER then
			dest = packed[1]
			-- Shift arguments (2..n) into msg
			local n = packed.n
			if n > 1 then
				local tmp = {}
				for i = 2, n do
					tmp[#tmp + 1] = packed[i]
				end
				msg = tmp
			else
				msg = {}
			end

			if parseInt(dest) >= 0 and (not no_wait) then
				r = async()
			end
		else
			if not no_wait then
				r = async()
			end
		end

		local rid = -1
		if r then
			rid = ids:gen()
			callbacks[rid] = r
		end

		if SERVER then
			TriggerRemoteEvent(iname .. ":tunnel_req", dest, fname, msg, identifier, rid)
		else
			TriggerRemoteEvent(iname .. ":tunnel_req", fname, msg, identifier, rid)
		end

		if r then
			return r:wait()
		end
	end

	itable[key] = fcall
	return fcall
end

function Tunnel.bindInterface(name, interface)
	RegisterLocalEvent(name .. ":tunnel_req")
	AddEventHandler(name .. ":tunnel_req", function(member, Message, identifier, rid)
		local source = source
		local f = interface[member]

		local rets = {}
		if type(f) == "function" then
			-- Message coming from network is a plain array
			rets = tpack(f(tunpack(Message, 1, #Message)))
		end

		if rid and rid >= 0 then
			if SERVER then
				TriggerRemoteEvent(name .. ":" .. identifier .. ":tunnel_res", source, rid, rets)
			else
				TriggerRemoteEvent(name .. ":" .. identifier .. ":tunnel_res", rid, rets)
			end
		end
	end)
end

function Tunnel.getInterface(name, identifier)
	if not identifier then
		identifier = GetCurrentResourceName()
	end

	local callbacks = {}
	local ids = Tools.newIDGenerator()

	local r = setmetatable({}, {
		__index = tunnel_resolve,
		name = name,
		identifier = identifier,
		tunnel_ids = ids,
		tunnel_callbacks = callbacks
	})

	RegisterLocalEvent(name .. ":" .. identifier .. ":tunnel_res")
	AddEventHandler(name .. ":" .. identifier .. ":tunnel_res", function(rid, rets)
		local callback = callbacks[rid]
		if callback then
			ids:free(rid)
			callbacks[rid] = nil

			-- rets may be packed (n) or plain
			if type(rets) == "table" and rets.n then
				callback(tunpack(rets, 1, rets.n))
			else
				callback(tunpack(rets, 1, #rets))
			end
		end
	end)

	return r
end

return Tunnel
