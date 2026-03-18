local Tools = module("lib/Tools")

local Proxy = {}

local tpack = table.pack
local tunpack = table.unpack
local ssub = string.sub

local function proxy_resolve(itable, key)
	local mtable = getmetatable(itable)
	local iname = mtable.name
	local ids = mtable.ids
	local callbacks = mtable.callbacks
	local identifier = mtable.identifier

	local fname = key
	local no_wait = false
	if ssub(key, 1, 1) == "_" then
		fname = ssub(key, 2)
		no_wait = true
	end

	local fcall = function(...)
		local rid
		local r

		if no_wait then
			rid = -1
		else
			r = async()
			rid = ids:gen()
			callbacks[rid] = r
		end

		local Message = tpack(...)

		TriggerEvent(iname .. ":proxy", fname, Message, identifier, rid)

		if not no_wait then
			return r:wait()
		end
	end

	itable[key] = fcall
	return fcall
end

function Proxy.addInterface(name, itable)
	AddEventHandler(name .. ":proxy", function(member, Message, identifier, rid)
		local f = itable[member]
		local rets = {}

		if type(f) == "function" then
			if type(Message) == "table" and Message.n then
				rets = tpack(f(tunpack(Message, 1, Message.n)))
			else
				rets = tpack(f(tunpack(Message, 1, #Message)))
			end
		end

		if rid >= 0 then
			TriggerEvent(name .. ":" .. identifier .. ":proxy_res", rid, rets)
		end
	end)
end

function Proxy.getInterface(name, identifier)
	if not identifier then
		identifier = GetCurrentResourceName()
	end

	local callbacks = {}
	local ids = Tools.newIDGenerator()

	local r = setmetatable({}, {
		__index = proxy_resolve,
		name = name,
		ids = ids,
		callbacks = callbacks,
		identifier = identifier
	})

	AddEventHandler(name .. ":" .. identifier .. ":proxy_res", function(rid, rets)
		local callback = callbacks[rid]
		if callback then
			ids:free(rid)
			callbacks[rid] = nil

			if type(rets) == "table" and rets.n then
				callback(tunpack(rets, 1, rets.n))
			else
				callback(tunpack(rets, 1, #rets))
			end
		end
	end)

	return r
end

return Proxy
