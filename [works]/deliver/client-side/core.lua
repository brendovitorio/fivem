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
Tunnel.bindInterface("deliver",Creative)
vSERVER = Tunnel.getInterface("deliver")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Blip = nil
local Started = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	["BurgerShot"] = { -1198.31,-905.14,13.83,218.27,1.0,"Iniciar Entregas",1,85},
	["CluckinBell"] = { -510.13,-696.63,33.16,45.36,1.0,"Iniciar Entregas",1,85},
	["Milkman"] = { 2313.76,4888.19,41.8,53.86,1.0,"Iniciar Entregas",1,85},
	["Lumberman"] = { 2433.45,5013.46,46.99,0.5,1.0,"Iniciar Entregas",2,80},
	["Transporter"] = { -228.22,-843.52,30.68,161.58,1.5,"Iniciar Entregas",3,80},
	["Postalman"] = { 78.93,112.45,81.16,158.75,1.5,"Iniciar Entregas",1,80}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Cds = {
	[1] = {
		{ -30.67,-346.94,46.52 },
		{ -197.36,-831.38,30.75 },
		{ -284.41,-600.6,33.55 },
		{ -287.26,-1060.19,27.2 },
		{ -170.71,-1449.71,31.64 },
		{ 87.57,-1670.53,29.18 },
		{ 218.1,-1838.83,27.33 },
		{ 379.52,-1781.49,29.47 },
		{ 561.39,-1751.82,29.28 },
		{ 431.69,-2035.13,23.32 },
		{ -421.75,-2171.55,11.34 },
		{ -621.03,-1639.95,26.35 },
		{ -697.59,-1182.27,10.72 },
		{ -1031.3,-902.98,3.69 },
		{ -1499.69,-933.09,10.18 },
		{ -1918.69,-542.63,11.83 },
		{ -1681.23,-290.87,51.88 },
		{ -1649.77,151.1,62.16 },
		{ -1094.99,427.28,75.87 },
		{ -667.14,471.47,114.14 }
	},
	[2] = {
		{ -513.92,-1019.31,23.47 },
		{ -1604.18,-832.26,10.08 },
		{ -536.48,-45.61,42.57 },
		{ -53.01,79.35,71.62 },
		{ 581.16,139.13,99.48 },
		{ 814.39,-93.48,80.6 },
		{ 1106.93,-355.03,67.01 },
		{ 1070.71,-780.46,58.36 },
		{ 1142.82,-986.58,45.91 },
		{ 1200.55,-1276.6,35.23 },
		{ 967.81,-1829.29,31.24 },
		{ 809.16,-2222.61,29.65 },
		{ 684.61,-2741.62,6.02 },
		{ 263.47,-2506.62,6.45 },
		{ 94.66,-2676.38,6.01 },
		{ -43.87,-2519.91,7.4 },
		{ 182.93,-2027.68,18.28 },
		{ -306.86,-2191.84,10.84 },
		{ -570.95,-1775.95,23.19 },
		{ -128.36,-1394.12,29.57 },
		{ 67.84,-1399.02,29.37 },
		{ 343.13,-1297.91,32.51 },
		{ 485.92,-1477.41,29.29 },
		{ 139.81,-1337.41,29.21 },
		{ 263.82,-1346.16,31.93 },
		{ -723.33,-1112.41,10.66 },
		{ -842.54,-1128.21,7.02 },
		{ 488.46,-898.56,25.94 }
	},
	[3] = {
		{ 285.47,143.37,104.17 },
		{ 527.36,-160.7,57.09 },
		{ 1153.64,-326.75,69.2 },
		{ 1167.01,-456.07,66.79 },
		{ 1138.25,-468.9,66.73 },
		{ 1077.71,-776.5,58.23 },
		{ 315.09,-593.65,43.29 },
		{ 296.46,-894.25,29.23 },
		{ 295.76,-896.14,29.22 },
		{ 147.58,-1035.79,29.34 },
		{ 145.93,-1035.19,29.34 },
		{ 289.1,-1256.87,29.44 },
		{ 288.82,-1282.36,29.64 },
		{ 126.85,-1296.59,29.27 },
		{ 127.84,-1296.03,29.27 },
		{ 33.55,-1345.01,29.49 },
		{ 24.48,-945.95,29.35 },
		{ 5.24,-919.83,29.55 },
		{ 112.58,-819.4,31.34 },
		{ 114.44,-776.41,31.41 },
		{ 111.25,-775.25,31.44 },
		{ -27.99,-724.54,44.23 },
		{ -30.19,-723.71,44.23 },
		{ -203.8,-861.37,30.26 },
		{ -301.7,-830.01,32.42 },
		{ -303.24,-829.74,32.42 },
		{ -258.87,-723.38,33.48 },
		{ -256.2,-715.99,33.53 },
		{ -254.41,-692.49,33.6 },
		{ -537.85,-854.49,29.28 },
		{ -660.73,-854.07,24.48 },
		{ -710.01,-818.9,23.72 },
		{ -712.89,-818.92,23.72 },
		{ -717.7,-915.65,19.21 },
		{ -821.63,-1081.88,11.12 },
		{ -1315.71,-834.75,16.95 },
		{ -1314.75,-836.03,16.95 },
		{ -1305.41,-706.37,25.33 },
		{ -1570.14,-546.72,34.95 },
		{ -1571.06,-547.39,34.95 },
		{ -1415.94,-212.04,46.51 },
		{ -1430.18,-211.06,46.51 },
		{ -1409.76,-100.47,52.39 },
		{ -1410.32,-98.75,52.42 },
		{ -1282.52,-210.92,42.44 },
		{ -1286.28,-213.44,42.44 },
		{ -1285.54,-224.32,42.44 },
		{ -1289.31,-226.78,42.44 },
		{ -1205.02,-326.3,37.83 },
		{ -1205.78,-324.8,37.86 },
		{ -866.69,-187.74,37.84 },
		{ -867.63,-186.07,37.84 },
		{ -846.31,-341.26,38.67 },
		{ -846.81,-340.2,38.67 },
		{ -721.06,-415.58,34.98 },
		{ -57.66,-92.65,57.78 },
		{ 89.73,2.46,68.29 },
		{ -165.17,232.77,94.91 },
		{ -165.16,234.8,94.91 },
		{ 158.6,234.23,106.63 },
		{ 228.18,338.38,105.56 },
		{ 381.86,326.44,103.56 },
		{ 357.01,173.54,103.07 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNMODELS
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnModels = {
	"ig_abigail","a_m_m_afriamer_01","ig_mp_agent14","csb_agent","ig_amandatownley","s_m_y_ammucity_01","u_m_y_antonb","g_m_m_armboss_01",
	"g_m_m_armgoon_01","g_m_m_armlieut_01","ig_ashley","s_m_m_autoshop_01","ig_money","g_m_y_ballaeast_01","g_f_y_ballas_01","g_m_y_ballasout_01",
	"s_m_y_barman_01","u_m_y_baygor","a_m_o_beach_01","ig_bestmen","a_f_y_bevhills_01","a_m_m_bevhills_02","u_m_m_bikehire_01","u_f_y_bikerchic",
	"mp_f_boatstaff_01","s_m_m_bouncer_01","ig_brad","ig_bride","u_m_y_burgerdrug_01","a_m_m_business_01","a_m_y_business_02","s_m_o_busker_01",
	"ig_car3guy2","cs_carbuyer","g_m_m_chiboss_01","g_m_m_chigoon_01","g_m_m_chigoon_02","u_f_y_comjane","ig_dale","ig_davenorton","s_m_y_dealer_01",
	"ig_denise","ig_devin","a_m_y_dhill_01","ig_dom","a_m_y_downtown_01","ig_dreyfuss"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Name,v in pairs(List) do
		exports["target"]:AddCircleZone("Deliver:"..Name,vec3(v[1],v[2],v[3]),v[4],{
			name = "Deliver:"..Name,
			heading = 3374176
		},{
			shop = Name,
			Distance = v[5],
			options = {
				{
					event = "deliver:Started",
					tunnel = "client",
					label = v[6],
				}
			}
		})
	end
	for Deliver,Coords in pairs(Cds) do
		if Deliver ~= 3 then
			for Number,v in pairs(Coords) do
				exports["creative"]:AddPed({
					Distance = 25,
					Coords = { v[1],v[2],v[3],v[4] or 0.0 },
					Model = (Deliver == 2 and ((Number%2~=0) and "s_m_y_construct_01" or "s_m_y_construct_02")) or spawnModels[math.random(#spawnModels)], 
					anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
				})
			end
		end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELIVER:STARTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("deliver:Started",function(Init)
	local Route = List[Init][7]
	if Cds[Route] and vSERVER.Permission(Init) then
		if Started then
			Started = false
			TriggerEvent("Notify","verde","Trabalho finalizado.",3000)
			exports["skinshop"]:Apply(LocalPlayer["state"]["Skinshop"])
			exports["target"]:LabelText("Deliver:"..Init,"Iniciar Entregas")
			exports["target"]:RemCircleZone("Deliver")
			if DoesBlipExist(Blip) then
				RemoveBlip(Blip)
				Blip = nil
			end
		else
			if checkVehicle(Init) and applyPreset(Init) then
				Started = Init
				exports["target"]:LabelText("Deliver:"..Init,"Finalizar")
				TriggerEvent("Notify","verde","Trabalho iniciado.",3000)
				
				if Init == "Milkman" then
					TriggerEvent("Notify","amarelo","1° Retire os Leite das Vacas.<br>2° Siga os pontos no gps.<br>3° Entregue os pedidos.",10000,"<b>Guia de Trabalho</b>")
				elseif Init == "Lumberman" then
					TriggerEvent("Notify","amarelo","1° Corte Madeira das Árvores.<br>2° Siga os pontos no gps.<br>3° Entregue os pedidos.",10000,"<b>Guia de Trabalho</b>")
				elseif Init == "Transporter" then
					TriggerEvent("Notify","amarelo","1° Busque os Malotes dos Cofres.<br>2° Siga os pontos no gps.<br>3° Entregue os pedidos.",10000,"<b>Guia de Trabalho</b>")
				elseif Init == "Postalman" then
					TriggerEvent("Notify","amarelo", "1° Colete as <b>Caixas Postal Azul</b> pela avenida.<br>2° Siga os pontos no gps.<br>3° Entregue os pedidos.",10000,"<b>Guia de Trabalho</b>")
				end

				local Selected = math.random(#Cds[Route])
				blipMarker(Cds[Route][Selected][1],Cds[Route][Selected][2],Cds[Route][Selected][3])
				--[[ print(Cds[Route][Selected][1],Cds[Route][Selected][2],Cds[Route][Selected][3]) ]]

				exports["target"]:AddCircleZone("Deliver",vec3(Cds[Route][Selected][1],Cds[Route][Selected][2],Cds[Route][Selected][3]),5.0,{
					name = "Deliver",
					heading = 3374176
				},{
					shop = Route,
					Distance = 1.0,
					options = {
						{
							event = "deliver:Finished",
							tunnel = "shop",
							label = "Entregar",
							service = Selected
						}
					}
				})
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELIVER:FINISHED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("deliver:Finished",function(Route,Selected)
	if Cds[Route][Selected] and checkVehicle(Started) then
		if Started and vSERVER.Deliver(Started,List[Started][8]) then
			
			local Random = math.random(#Cds[Route])
			repeat
				Random = math.random(#Cds[Route])
			until Selected ~= Random

			blipMarker(Cds[Route][Random][1],Cds[Route][Random][2],Cds[Route][Random][3])

			--[[ print(Cds[Route][Random][1],Cds[Route][Random][2],Cds[Route][Random][3]) ]]

			exports["target"]:AddCircleZone("Deliver",vec3(Cds[Route][Random][1],Cds[Route][Random][2],Cds[Route][Random][3]),5.0,{
				name = "Deliver",
				heading = 3374176
			},{
				shop = Route,
				Distance = 1.0,
				options = {
					{
						event = "deliver:Finished",
						tunnel = "shop",
						label = "Entregar",
						service = Random
					}
				}
			})
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK VEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function checkVehicle(Init)
	local Vehicle = GetLastDrivenVehicle()
	if Init == "Milkman" and "youga2" ~= GetEntityArchetypeName(Vehicle) then
		TriggerEvent("Notify","amarelo","Precisa utilizar o veículo do <b>Leiteiro</b>.",3000)
		return
	end
	if Init == "Lumberman" and "ratloader" ~= GetEntityArchetypeName(Vehicle) then
		TriggerEvent("Notify","amarelo","Precisa utilizar o veículo do <b>Lenhador</b>.",3000)
		return
	end
	if Init == "Transporter" and "stockade" ~= GetEntityArchetypeName(Vehicle) then
		TriggerEvent("Notify","amarelo","Precisa utilizar o veículo do <b>Transportador</b>.",3000) 
		return
	end
	if Init == "Postalman" and "boxville2" ~= GetEntityArchetypeName(Vehicle) then
		TriggerEvent("Notify","amarelo","Precisa utilizar o veículo do <b>Correio</b>.",3000) 
		return
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
local preset = {
	["1"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 126, texture = 0 },
			["pants"] = { item = 87, texture = 0 },
			["vest"] = { item = 73, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 76, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = 216, texture = 0 },
			["torso"] = { item = 319, texture = 1 },
			["accessory"] = { item = 170, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 11, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 100, texture = 0 },
			["vest"] = { item = 6, texture = 1 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 80, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = 159, texture = 0 },
			["torso"] = { item = 23, texture = 0 },
			["accessory"] = { item = 145, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 14, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["2"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 144, texture = 0 },
			["pants"] = { item = 87, texture = 0 },
			["vest"] = { item = 6, texture = 1 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 71, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = 216, texture = 0 },
			["torso"] = { item = 317, texture = 1 },
			["accessory"] = { item = 170, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 4, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 100, texture = 0 },
			["vest"] = { item = 6, texture = 1 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 85, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = 159, texture = 0 },
			["torso"] = { item = 23, texture = 0 },
			["accessory"] = { item = 145, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 14, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},

	["3"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 176, texture = 0 },
			["pants"] = { item = 87, texture = 7 },
			["vest"] = { item = -1, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 136, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = -1, texture = 0 },
			["torso"] = { item = 319, texture = 5 },
			["accessory"] = { item = -1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 11, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 175, texture = 0 },
			["pants"] = { item = 100, texture = 5 },
			["vest"] = { item = -1, texture = 1 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 146, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = -1, texture = 0 },
			["torso"] = { item = 23, texture = 0 },
			["accessory"] = { item = -1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 14, texture = 0 },
			["glass"] = { item = -1, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["4"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 176, texture = 0 },
			["pants"] = { item = 87, texture = 7 },
			["vest"] = { item = -1, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 136, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = -1, texture = 0 },
			["torso"] = { item = 317, texture = 5 },
			["accessory"] = { item = -1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 4, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 175, texture = 0 },
			["pants"] = { item = 100, texture = 5 },
			["vest"] = { item = -1, texture = 1 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 146, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = -1, texture = 0 },
			["torso"] = { item = 23, texture = 0 },
			["accessory"] = { item = -1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 14, texture = 0 },
			["glass"] = { item = -1, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function applyPreset(Init)
	local Ped = PlayerPedId()
	local Model = GetEntityArchetypeName(Ped)
	if Init == "Transporter" then
		local Number = (math.random(0, 1) == 0) and "1" or "2"
		if preset[Number][Model] then
			if Model == "mp_m_freemode_01" then
				preset[Number][Model]["hat"] = { item = (math.random(0, 1) == 0) and 126 or 144, texture = 0 }
				if Number == "1" then
					preset[Number][Model]["torso"] = { item = (math.random(0, 1) == 0) and 319 or 318, texture = 1 }
				else
					preset[Number][Model]["torso"] = { item = (math.random(0, 1) == 0) and 316 or 317, texture = 1 }
				end
			else
				preset[Number][Model]["hat"] = { item = (math.random(0, 1) == 0) and 125 or 143, texture = 0 }
				if Number == "1" then
					preset[Number][Model]["torso"] = { item = (math.random(0, 1) == 0) and 328 or 327, texture = 1 }
				else
					preset[Number][Model]["torso"] = { item = (math.random(0, 1) == 0) and 329 or 330, texture = 1 }
				end
			end
			exports["skinshop"]:Apply(preset[Number][Model])
		end
	elseif Init == "Postalman" then
		local Number = (math.random(0, 1) == 0) and "3" or "4"
		if preset[Number][Model] then
			if Model == "mp_m_freemode_01" then
				if Number == "3" then
					preset[Number][Model]["torso"] = { item = (math.random(0, 1) == 0) and 319 or 318, texture = 5 }
				else
					preset[Number][Model]["torso"] = { item = (math.random(0, 1) == 0) and 316 or 317, texture = 5 }
				end
			else
				if Number == "3" then
					preset[Number][Model]["torso"] = { item = (math.random(0, 1) == 0) and 328 or 327, texture = 5 }
				else
					preset[Number][Model]["torso"] = { item = (math.random(0, 1) == 0) and 329 or 330, texture = 5 }
				end
			end
			exports["skinshop"]:Apply(preset[Number][Model])
		end
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function blipMarker(x,y,z)
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
		Blip = nil
	end
	Blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(Blip,1)
	SetBlipColour(Blip,2)
	SetBlipScale(Blip,0.5)
	SetBlipRoute(Blip,true)
	SetBlipAsShortRange(Blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega do "..Started)
	EndTextCommandSetBlipName(Blip)
end