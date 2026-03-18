-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
RevoltS = Tunnel.getInterface("Revolt")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("dynamic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local menuOpen = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddButton",function(title,description,trigger,par,id,server)
	SendNUIMessage({ addbutton = true, title = title, description = description, trigger = trigger, par = par, id = id, server = server })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("SubMenu",function(title,description,id)
	SendNUIMessage({ addmenu = true, title = title, description = description, menuid = id })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("openMenu",function()
	SendNUIMessage({ show = true })
	SetNuiFocus(true,true)
	menuOpen = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLICKED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("clicked",function(Data,Callback)
	if Data["trigger"] and Data["trigger"] ~= "" then
		if Data["server"] == "true" then
			TriggerServerEvent(Data["trigger"],Data["param"])
		else
			TriggerEvent(Data["trigger"],Data["param"])
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SetNuiFocus(false,false)
	menuOpen = false

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:closeSystem")
AddEventHandler("dynamic:closeSystem",function()
	if menuOpen then
		SendNUIMessage({ close = true })
		SetNuiFocus(false,false)
		menuOpen = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("globalFunctions",function()
	if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not menuOpen and LocalPlayer["state"]["Route"] < 900000 and not IsPauseMenuActive() then
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		if GetEntityHealth(Ped) > 100 then
			-- exports["dynamic"]:AddButton("Chapéu","Colocar/Retirar o chapéu.","player:Outfit","Hat","clothes",true)
			-- exports["dynamic"]:AddButton("Máscara","Colocar/Retirar a máscara.","player:Outfit","Mask","clothes",true)
			-- exports["dynamic"]:AddButton("Óculos","Colocar/Retirar o óculos.","player:Outfit","Glasses","clothes",true)

			exports["dynamic"]:AddButton("Vestir","Vestir-se com as roupas guardadas.","player:Outfit","aplicar","clothes",true)
			exports["dynamic"]:AddButton("Guardar","Salvar suas roupas do corpo.","player:Outfit","salvar","clothes",true)
				
				
			local isExclusive = vSERVER.isExclusive()
			if isExclusive then
				exports["dynamic"]:AddButton("Vestir Roupas Exclusivas","Vestir roupas exclusivas.","player:Outfit","aplicarpremium","clothes",true)
				exports["dynamic"]:AddButton("Guardar Roupas Exclusivas","Guardar roupas exclusivas.","player:Outfit","salvarpremium","clothes",true)
			end

			exports["dynamic"]:AddButton("Propriedades","Marcar/Desmarcar propriedades no mapa.","propertys:Blips","","others",false)
			exports["dynamic"]:AddButton("Ferimentos","Verificar ferimentos no corpo.","paramedic:Injuries","","others",false)
			exports["dynamic"]:AddButton("Desbugar","Recarregar o personagem.","player:Debug","","others",true)

			local Vehicle = rEVOLT.ClosestVehicle(7)
			if IsEntityAVehicle(Vehicle) then
				if not IsPedInAnyVehicle(Ped) then
					exports["dynamic"]:AddButton("Rebocar","Colocar veículo na prancha do reboque.","towdriver:revoltTow","","vehicle",false)

					if rEVOLT.ClosestPed(3) then
						exports["dynamic"]:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","player:cvFunctions","cv","closestpeds",true)
						exports["dynamic"]:AddButton("Remover do Veículo","Remover do veículo mais próximo.","player:cvFunctions","rv","closestpeds",true)

						exports["dynamic"]:SubMenu("Jogador","Pessoa mais próxima de você.","closestpeds")
					end
				else
					exports["dynamic"]:AddButton("Sentar no Motorista","Sentar no banco do motorista.","player:seatPlayer","0","vehicle",false)
					exports["dynamic"]:AddButton("Sentar no Passageiro","Sentar no banco do passageiro.","player:seatPlayer","1","vehicle",false)
					exports["dynamic"]:AddButton("Sentar em Outros","Sentar no banco do passageiro.","player:seatPlayer","2","vehicle",false)
					exports["dynamic"]:AddButton("Levantar Vidros","Levantar os vidros.","player:winsFunctions","1","vehicle",true)
					exports["dynamic"]:AddButton("Abaixar Vidros","Abaixar os vidros.","player:winsFunctions","0","vehicle",true)
				end

				exports["dynamic"]:AddButton("Porta do Motorista","Abrir porta do motorista.","player:Doors","1","doors",true)
				exports["dynamic"]:AddButton("Porta do Passageiro","Abrir porta do passageiro.","player:Doors","2","doors",true)
				exports["dynamic"]:AddButton("Porta Traseira Esquerda","Abrir porta traseira esquerda.","player:Doors","3","doors",true)
				exports["dynamic"]:AddButton("Porta Traseira Direita","Abrir porta traseira direita.","player:Doors","4","doors",true)
				exports["dynamic"]:AddButton("Porta-Malas","Abrir porta-malas.","player:Doors","5","doors",true)
				exports["dynamic"]:AddButton("Capô","Abrir capô.","player:Doors","6","doors",true)

				exports["dynamic"]:SubMenu("Veículo","Funções do veículo.","vehicle")
				exports["dynamic"]:SubMenu("Portas","Portas do veículo.","doors")
			end

			local Exclusivas = vSERVER.Exclusivas()
			if parseInt(#Exclusivas) > 0 then
				for _,v in pairs(Exclusivas) do
					if v["type"] == "backpack" then
						exports["dynamic"]:AddButton(v["name"],"Clique para colocar/remover.","skinshop:toggleBackpack",v["id"].."-"..v["texture"],"Exclusivas",false)
					end
				end

				exports["dynamic"]:SubMenu("Exclusivas","Todas as roupas exclusivas.","Exclusivas")
			end

			local Experience = vSERVER.Experience()
			for Name,Exp in pairs(Experience) do
				exports["dynamic"]:AddButton(Name,"Você possuí <yellow>"..Exp.." pontos</yellow> na classe <yellow>"..ClassCategory(Exp).."</yellow>.","","","Experience",false)
			end

			exports["dynamic"]:SubMenu("Roupas","Colocar/Retirar roupas.","clothes")
			exports["dynamic"]:SubMenu("Experiência","Todas as suas habilidades.","Experience")
			exports["dynamic"]:SubMenu("Outros","Todas as funções do personagem.","others")

			exports["dynamic"]:openMenu()
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENCYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("emergencyFunctions",function()
	if not IsPauseMenuActive() then
		local Options = {}
		if LocalPlayer["state"]["Admin"] or LocalPlayer["state"]["waitAdmin"] then
			Options[#Options+1] = function()
				exports["dynamic"]:AddButton("Entrar/Sair de serviço","Entrar e sair de serviço.","service:Toggle","Admin-1","staff",true)
				exports["dynamic"]:SubMenu("Opções staff","Opções staff.","staff")
			end
		end
		if (LocalPlayer["state"]["Police"] or LocalPlayer["state"]["Paramedic"]) then
			if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not menuOpen and LocalPlayer["state"]["Route"] < 900000 then

				local Ped = PlayerPedId()
				if GetEntityHealth(Ped) > 100 then
					if not IsPedInAnyVehicle(Ped) then
						exports["dynamic"]:AddButton("Carregar","Carregar a pessoa mais próxima.","player:carryPlayer","","player",true)
						exports["dynamic"]:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","player:cvFunctions","cv","player",true)
						exports["dynamic"]:AddButton("Remover do Veículo","Remover do veículo mais próximo.","player:cvFunctions","rv","player",true)

						exports["dynamic"]:SubMenu("Jogador","Pessoa mais próxima de você.","player")
					end

					if LocalPlayer["state"]["Police"] then
						Options[#Options+1] = function()
							exports["dynamic"]:AddButton("Remover Chapéu","Remover da pessoa mais próxima.","skinshop:Remove","Hat","player",true)
							exports["dynamic"]:AddButton("Remover Máscara","Remover da pessoa mais próxima.","skinshop:Remove","Mask","player",true)
							exports["dynamic"]:AddButton("Remover Óculos","Remover da pessoa mais próxima.","skinshop:Remove","Glasses","player",true)
	
							exports["dynamic"]:AddButton("ROTA","Fardamento de oficial.","player:Preset","1","prePolice",true)
							exports["dynamic"]:AddButton("Força Tatica","Fardamento de oficial.","player:Preset","2","prePolice",true)
							exports["dynamic"]:AddButton("BAEP","Fardamento de oficial.","player:Preset","3","prePolice",true)
							exports["dynamic"]:AddButton("ROCAM","Fardamento de oficial.","player:Preset","4","prePolice",true)
							exports["dynamic"]:AddButton("GARRA","Fardamento de oficial.","player:Preset","6","prePolice",true)
							exports["dynamic"]:AddButton("SOLDADO","Fardamento de oficial.","player:Preset","5","prePolice",true)
							exports["dynamic"]:AddButton("CABO","Fardamento de oficial.","player:Preset","7","prePolice",true)
							exports["dynamic"]:AddButton("SARGENTO","Fardamento de oficial.","player:Preset","8","prePolice",true)							
							exports["dynamic"]:AddButton("1ºTENENTE","Fardamento de oficial.","player:Preset","9","prePolice",true)
							exports["dynamic"]:AddButton("CAPITÃO","Fardamento de oficial.","player:Preset","10","prePolice",true)
							exports["dynamic"]:AddButton("MAJOR","Fardamento de oficial.","player:Preset","11","prePolice",true)
							exports["dynamic"]:AddButton("CORONEL","Fardamento de oficial.","player:Preset","12","prePolice",true)
							exports["dynamic"]:AddButton("COMANDO","Fardamento de oficial.","player:Preset","13","prePolice",true)
	
							exports["dynamic"]:SubMenu("Fardamentos","Todos os fardamentos policiais.","prePolice")
							exports["dynamic"]:AddButton("Computador","Computador de bordo policial.","police:Mdt","",false,false)
						end
					elseif LocalPlayer["state"]["Paramedic"] then
						Options[#Options+1] = function()
							exports["dynamic"]:AddButton("Diretor","Permitido apenas para o cargo descrito!","player:Preset","14","preMedic",true)
							exports["dynamic"]:AddButton("Supervisor","Permitido apenas para o cargo descrito!","player:Preset","15","preMedic",true)
							exports["dynamic"]:AddButton("Médico","Permitido apenas para o cargo descrito!","player:Preset","16","preMedic",true)
							exports["dynamic"]:AddButton("Interno","Permitido apenas para o cargo descrito!","player:Preset","17","preMedic",true)
							exports["dynamic"]:AddButton("Paramédico","Permitido apenas para o cargo descrito!","player:Preset","18","preMedic",true)
							exports["dynamic"]:AddButton("Treinee","Permitido apenas para o cargo descrito!","player:Preset","19","preMedic",true)

							exports["dynamic"]:SubMenu("Fardamentos","Todos os fardamentos médicos.","preMedic")
						end
					end

				end
			end
		end
		if #Options >= 1 then
			for Number in pairs(Options) do
				Options[Number]()
			end
			exports["dynamic"]:openMenu()
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("globalFunctions","Abrir menu principal.","keyboard","F9")
RegisterKeyMapping("emergencyFunctions","Abrir menu de emergencial.","keyboard","F10")