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
Tunnel.bindInterface("postit",Creative)
vCLIENT = Tunnel.getInterface("postit")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Postit"] = {}
local webhookpostit = "https://discord.com/api/webhooks/1156482160862175322/eiyabqD1TvPbTg_JvAW2fyjNCWSxdvrF31IjnmSp86jIlF3I7I694Zub8RakNQmdWmkP"
local webhookpostitrem = "https://discord.com/api/webhooks/1156482262955724840/2vF-UR97eLoJ69dsqUiuqjW0a4zTfAUg-VZuHBO0v58wkrDqsWL1_VpezLJURQ4B7784"
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWPOSTITS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.newPostIts(Coords)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Keyboard = vKEYBOARD.keyDouble(source,"Mensagem:","Distância: (3 a 15)")
		if Keyboard then
			if parseInt(Keyboard[2]) >= 3 and parseInt(Keyboard[2]) <= 15 then
				if rEVOLT.TakeItem(Passport,"postit",1,true) then
					local Postit = GlobalState["Postit"]
					Postit[#Postit + 1] = { mathLength(Coords["x"]),mathLength(Coords["y"]),mathLength(Coords["z"]),string.sub(Keyboard[1],1,100),parseInt(Keyboard[2]),Passport,os.time() + 60 }
					GlobalState:set("Postit",Postit,true)
					rEVOLT.SendWebhook(webhookpostit, "LOGs postit", "**Passaporte: **"..Passport.."\n**Adesivou: **"..Keyboard[1].."\n**Distância: **"..Keyboard[2].."\n**Localização: **"..Coords["x"]..", "..Coords["y"]..", "..Coords["z"], 10357504)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEPOSTITS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.deletePostIts(id)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Postit = GlobalState["Postit"]

		if Passport then
			TriggerClientEvent("Notify",source,"verde","Post-It do passaporte removido.",10000)
			rEVOLT.SendWebhook(webhookpostitrem, "LOGs postitrem", "**Passaporte: **"..Passport.."\n**Removeu o adesivo do passaporte:**"..Postit[id][6], 10357504)

			Postit[id] = nil
			GlobalState:set("Postit",Postit,true)
			TriggerClientEvent("postit:deletePostIts",-1,id)
		else
			if Postit[id] then
				if Postit[id][6] == Passport then
					if os.time() <= Postit[id][7] then
						rEVOLT.GenerateItem(Passport,"postit",1,true)
					end

					Postit[id] = nil
					GlobalState:set("Postit",Postit,true)
					TriggerClientEvent("postit:deletePostIts",-1,id)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATETXT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Archive(Coords)
	rEVOLT.Archive("Coords.txt",Coords)
end