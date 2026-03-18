-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------

local Tunnel = module('revolt','lib/Tunnel')
local Proxy  = module('revolt','lib/Proxy')
local rEVOLT = Proxy.getInterface('rEVOLT')

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("garages",Creative)
vSERVER = Tunnel.getInterface("garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DECOR
-----------------------------------------------------------------------------------------------------------------------------------------
DecorRegister("PlayerVehicle",3)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Opened = "1"
local Searched = nil
local Hotwired = false
local Cooldown = GetGameTimer()
local Anim = "machinic_loop_mechandplayer"
local Dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Garages = {
	["1"] = { x=55.59,y=-874.78,z=30.43,h=340.16,
		["1"] = { 60.44,-866.47,30.23,340.16 },
		["2"] = { 57.26,-865.35,30.25,340.16 },
		["3"] = { 54.03,-864.21,30.25,340.16 },
		["4"] = { 50.73,-863.01,30.26,340.16 },
		["5"] = { 60.52,-866.53,30.14,340.16 },
		["6"] = { 50.73,-873.28,30.11,158.75 },
		["7"] = { 47.36,-872.07,30.13,158.75 },
		["8"] = { 44.15,-870.9,30.13,158.75 }
	},
	["2"] = { x = 599.04, y = 2745.33, z = 42.04, h = 175.75,
		["1"] = { 604.82,2738.27,41.64,187.09 },
		["2"] = { 601.75,2738.08,41.65,184.26 },
		["3"] = { 598.63,2737.85,41.69,184.26 },
		["4"] = { 595.59,2737.55,41.7,184.26 }
	},
	["3"] = { x = -136.8, y = 6356.84, z = 31.49, h = 130.4,
		["1"] = { -133.72,6349.01,31.16,42.52 },
		["2"] = { -136.1,6346.53,31.16,42.52 }
	},
	["4"] = { x=276.53,y=-346.33,z=44.92,h=249.45,
		["1"] = { 266.06,-332.07,44.58,252.29 },
		["2"] = { 267.18,-328.9,44.58,252.29 },
		["3"] = { 268.32,-325.67,44.58,252.29 },
		["4"] = { 269.53,-322.4,44.58,252.29 },
		["5"] = { 270.77,-319.14,44.58,252.29 }
	},
	["5"] = { x=595.01,y=90.69,z=93.13,h=68.04,
		["1"] = { 599.82,102.03,92.57,249.45 },
		["2"] = { 598.69,98.42,92.57,249.45 }
	},
	["6"] = { x=-339.12,y=266.15,z=85.68,h=280.63,
		["1"] = { -349.47,272.54,84.77,272.13 },
		["2"] = { -349.5,275.91,84.69,272.13 },
		["3"] = { -349.56,279.3,84.62,272.13 },
		["4"] = { -349.67,282.6,84.59,274.97 },
		["5"] = { -349.74,286.16,84.59,272.13 },
		["6"] = { -349.8,289.76,84.6,272.13 },
		["7"] = { -349.85,293.28,84.6,272.13 },
		["8"] = { -349.87,296.72,84.6,272.13 }
	},
	["7"] = { x=-2030.57,y=-467.39,z=11.39,h=133.23,
		["1"] = { -2037.4,-461.02,11.07,138.9 },
		["2"] = { -2039.78,-459.07,11.07,138.9 },
		["3"] = { -2042.12,-457.1,11.07,138.9 },
		["4"] = { -2044.47,-455.11,11.07,138.9 },
		["5"] = { -2046.85,-453.09,11.07,138.9 },
		["6"] = { -2049.12,-451.17,11.07,138.9 },
		["7"] = { -2051.51,-449.23,11.07,138.9 }
	},
	["8"] = { x=-1185.99,y=-1509.08,z=4.38,h=34.02,
		["1"] = { -1183.29,-1495.81,4.04,121.89 },
		["2"] = { -1185.23,-1493.28,4.04,121.89 },
		["3"] = { -1186.87,-1490.71,4.04,121.89 },
		["4"] = { -1188.69,-1488.27,4.04,121.89 }
	},
	["9"] = { x=101.08,y=-1075.02,z=29.2,h=158.75,
		["1"] = { 104.05,-1079.14,29.18,334.49 },
		["2"] = { 107.78,-1080.35,29.18,337.33 },
		["3"] = { 111.21,-1081.19,29.18,331.66 }
	},
	["10"] = { x=215.46,y=-808.54,z=30.75,h=249.45,
		["1"] = { 221.93,-804.11,30.35,249.45 },
		["2"] = { 222.9,-801.61,30.33,249.45 },
		["3"] = { 223.92,-799.2,30.33,249.45 },
		["4"] = { 224.85,-796.69,30.33,249.45 }
	},
	["11"] = { x=-347.51,y=-873.69,z=31.12,h=266.46,
		["1"] = { -343.62,-875.51,30.75,167.25 },
		["2"] = { -339.98,-876.27,30.75,167.25 },
		["3"] = { -336.35,-876.98,30.75,167.25 },
		["4"] = { -332.72,-877.71,30.75,167.25 }
	},
	["12"] = { x=66.3,y=12.37,z=69.02,h=68.04,
		["1"] = { 63.87,16.5,68.87,340.16 },
		["2"] = { 60.78,17.6,68.92,340.16 },
		["3"] = { 57.76,18.76,69.03,340.16 },
		["4"] = { 54.8,19.92,69.25,340.16 }
	},
	["13"] = { x=363.18,y=296.99,z=103.51,h=249.45,
		["1"] = { 371.06,284.68,102.94,340.16 },
		["2"] = { 374.8,283.39,102.85,340.16 },
		["3"] = { 378.62,282.06,102.78,340.16 }
	},
	["14"] = { x=1034.66,y=-765.01,z=58.0,h=136.07,
		["1"] = { 1046.56,-774.55,57.69,90.71 },
		["2"] = { 1046.56,-778.24,57.68,90.71 },
		["3"] = { 1046.55,-782.0,57.68,90.71 },
		["4"] = { 1046.54,-785.65,57.66,90.71 }
	},
	["15"] = { x = -796.69, y = -2022.85, z = 9.17, h = 240.95,
		["1"] = { -779.77,-2040.03,8.56,314.65 },
		["2"] = { -777.36,-2042.58,8.56,314.65 },
		["3"] = { -774.92,-2044.9,8.56,314.65 }
	},
	["16"] = { x=453.83,y=-1148.24,z=29.28,h=175.75,
		["1"] = { 467.33,-1151.89,28.96,85.04 },
		["2"] = { 467.16,-1154.75,28.96,85.04 },
		["3"] = { 467.1,-1157.73,28.96,87.88 }
	},
	["17"] = { x=529.03,y=-144.83,z=58.44,h=357.17,
		["1"] = { 540.99,-136.2,59.13,178.59 },
		["2"] = { 544.84,-136.25,59.01,178.59 },
		["3"] = { 548.83,-136.31,59.01,181.42 },
		["4"] = { 552.81,-136.41,58.99,178.59 }
	},
	["18"] = { x=-1157.84,y=-740.92,z=19.75,h=215.44,
		["1"] = { -1144.95,-745.49,19.34,104.89 },
		["2"] = { -1142.76,-748.44,19.19,107.72 },
		["3"] = { -1140.18,-751.41,19.06,107.72 },
		["4"] = { -1137.99,-754.36,18.91,107.72 },
		["5"] = { -1135.43,-757.3,18.75,107.72 },
		["6"] = { -1133.12,-760.4,18.59,107.72 },
		["7"] = { -1130.59,-763.27,18.43,107.72 }
	},
	["19"] = { x = -791.48, y = 336.48, z = 85.7,
		["1"] = { -791.64,331.67,85.38,181.42 }
	},
	["20"] = { x = -800.45, y = 336.61, z = 85.7,
		["1"] = { -800.38,331.9,85.38,181.42 }
	},
	["21"] = { x = 935.95, y = 0.36, z = 78.76,
		["1"] = { 933.29,-3.74,78.44,147.41 }
	},
	["22"] = { x=1724.39,y=4714.59,z=42.16,h=198.43,
		["1"] = { 1722.82,4700.38,42.28,87.88 }
	},
	["23"] = { x=1621.35,y=3563.64,z=35.28,h=297.64,
		["1"] = { 1633.27,3563.91,34.91,303.31 }
	},
	["24"] = { x=1140.6,y=2667.86,z=38.16,h=51.03,
		["1"] = { 1137.41,2674.26,37.83,0.0 }
	},
	["25"] = { x=-74.84,y=-2005.26,z=18.01,h=82.21,
		["1"] = { -59.61,-1990.85,17.69,155.91 },
		["2"] = { -63.69,-1989.71,17.69,167.25 },
		["3"] = { -67.6,-1989.01,17.69,170.08 },
		["4"] = { -71.34,-1988.57,17.69,172.92 },
		["5"] = { -74.96,-1988.07,17.69,170.08 },
		["6"] = { -78.64,-1987.63,17.69,170.08 },
		["7"] = { -82.27,-1987.19,17.69,170.08 }
	},
	["26"] = { x=-365.85,y=-251.56,z=32.94,h=331.66,
		["1"] = { -359.11,-247.05,32.94,286.3 },
	},
	["27"] = { x=-313.41,y=-1399.72,z=31.29,h=328.82,
		["1"] = {-301.84,-1402.72,31.29,87.88},
		["2"] = {-301.71,-1398.61,31.29,87.88},
	},
	["28"] = { x=-1039.27,y=-2730.72,z=20.2,h=243.78,
		["1"] = {-1045.14,-2723.6,20.07,243.78},
		["2"] = {-1037.55,-2728.6,20.05,240.95},
		["3"] = {-1029.91,-2732.09,20.08,238.12},
	},

	-- Paramedic
	["41"] = { x=297.96,y=-600.92,z=43.3,h=153.08,
		["1"] = { 296.66,-604.9,43.3,68.04 }
	},
	["42"] = { x=337.85,y=-587.02,z=74.16,h=280.63,
		["1"] = { 351.61,-588.36,74.16,345.83 }
	},


	-- Police
	["61"] = { x=-330.9,y=-265.56,z=28.07,h=141.74,
	 	["1"] = { -320.5,-273.24,28.07,45.36 },
		["2"] = { -336.22,-272.18,28.07,42.52 },
	},
	["62"] = { x=-316.98,y=-279.62,z=43.24,h=48.19,
		["1"] = { -326.13,-271.3,43.24,238.12 }
	},

	-- Ilegal
	["91"] = { x = 84.47, y = -1972.8, z = 20.84,
		["1"] = { 88.7,-1967.4,20.51,323.15 }
	},
	["92"] = { x = -25.01, y = -1433.2, z = 30.65,
		["1"] = { -25.01,-1437.79,30.41,178.59 }
	},
	["93"] = { x = 337.43, y = -2036.08, z = 21.35,
		["1"] = { 332.6,-2031.48,20.98,138.9 }
	},
	["94"] = { x = 504.18, y = -1798.77, z = 28.49,
		["1"] = { 498.32,-1803.21,28.22,51.03 }
	},
	["95"] = { x = 232.26, y = -1757.15, z = 29.0,
		["1"] = { 238.84,-1760.94,28.78,320.32 }
	},
	["96"] = { x = -816.25, y = -726.19, z = 23.78,
		["1"] = { -816.3,-731.23,23.54,181.42 }
	},
	["97"] = { x = 496.3, y = -103.58, z = 61.33,
		["1"] = { 500.42,-105.01,61.81,252.29 }
	},

	-- Boats
	["121"] = { x = -1728.06, y = -1050.69, z = 1.7, h = 325.99,
		["1"] = { -1734.05,-1057.01,0.94,133.23 }
	},
	["122"] = { x = 1966.55, y = 3976.15, z = 31.49, h = 167.25,
		["1"] = { 1971.66,3985.42,30.13,331.66 }
	},
	["123"] = { x = -776.63, y = -1494.93, z = 2.29, h = 286.3,
		["1"] = { -786.5,-1498.89,-0.57,110.56 }
	},
	["124"] = { x = -895.04, y = 5687.46, z = 3.03, h = 269.3,
		["1"] = { -907.5,5684.52,0.76,102.05 }
	},
	["125"] = { x = 1509.64, y = 3788.7, z = 33.51, h = 257.96,
		["1"] = { 1493.4,3797.23,29.89,50.19 }
	},
	["126"] = { x = 4971.79, y = -5170.93, z = 2.27, h =249.45,
		["1"] = { 4952.76,-5163.61,-0.39,65.2 }
	},
	
	-- Works
	["141"] = { x = 2434.96, y = 5012.06, z = 46.84,
		["1"] = { 2441.6,5010.56,45.76,277.8 }
	},
	["142"] = { x=1082.88,y=-1949.65,z=31.0,h=65.2,
		["1"] = { 1074.91,-1949.53,31.0,141.74 }
	},
	["143"] = { x=392.02,y=-1637.4,z=29.28,h=243.78,
		["1"] = { 408.33,-1646.13,29.28,229.61 }
	},
	["144"] = { x=-233.69,y=-851.03,z=30.68,h=187.09,
		["1"] = { -242.13,-859.7,30.58,252.29 },
		["2"] = { -234.93,-862.03,30.33,252.29 }
	},
	["145"] = { x = 905.6, y = -165.08, z = 74.11, h = 221.11,
		["1"] = { 916.21,-170.61,74.04,99.22 },
		["2"] = { 918.35,-167.18,74.22,99.22 },
		["3"] = { 920.64,-163.54,74.43,99.22 }
	},
	["146"] = { x=-345.87,y=-1556.21,z=25.22,h=184.26,
		["1"] = { -334.21,-1564.82,25.22,56.7 },
	},
	["147"] = { x=284.25,y=2849.4,z=43.64,h=127.56,
		["1"] = { 277.34,2840.0,43.29,28.35 } 
	},
	["148"] = { x=-428.18,y=6161.91,z=31.48,h=39.69,
		["1"] = { -422.42,6172.82,31.48,311.82 }
	},
	["149"] = { x = 1695.55, y = 4787.69, z = 42.01,
		["1"] = { 1691.56,4782.3,41.52,87.88 },
		["2"] = { 1691.54,4778.38,41.53,87.88 },
		["3"] = { 1691.56,4774.37,41.53,87.88 },
		["4"] = { 1691.57,4770.32,41.53,87.88 },
		["5"] = { 1691.5,4766.35,41.53,87.88 },
		["6"] = { 1691.52,4762.46,41.52,87.88 }
	},
	["150"] = { x = 1241.65, y = -3262.85, z = 5.53,
		["1"] = { 1271.56,-3287.96,6.10,91.00 },
		["2"] = { 1271.82,-3282.63,6.10,91.00 },
		["3"] = { 1271.95,-3271.04,6.10,91.00 },
		["4"] = { 1272.11,-3266.03,6.10,91.00 }
	},
	["151"] = { x = 453.74, y = -600.6, z = 28.59, h = 263.63,
		["1"] = { 462.81,-606.03,28.49,212.6 },
		["2"] = { 461.54,-612.34,28.49,215.44 },
		["3"] = { 460.98,-619.81,28.49,215.44 }
	},
	["152"] = { x=-215.7,y=6219.25,z=31.49,h=235.28,
		["1"] = { -211.68,6198.4,31.49,121.89 }
	},
	["153"] = { x=115.8,y=102.06,z=81.01,h=164.41,
		["1"] = { 115.39,93.75,80.93,62.37 }
	},
	["154"] = { x=2307.24,y=4881.57,z=41.8,h=48.19,
		["1"] = { 2294.66,4891.75,41.25,317.49 }
	},
	["155"] = { x=2258.17,y=5166.06,z=59.11,h=232.45,
		["1"] = { 2263.14,5156.83,58.03,240.95 },
		["2"] = { 2257.75,5159.93,58.11,150.24 },
	},
	["156"] = { x=2145.79,y=4781.95,z=40.98,h=102.05,
		["1"] = { 2132.83,4784.6,40.96,22.68 },
	},
	["157"] = { x=-1273.09,y=-301.95,z=36.82,h=99.22,
		["1"] = { -1280.54,-301.18,36.82,212.6 },
	},
	["158"] = { x=866.85,y=-2136.09,z=30.55,h=357.17,
		["1"] = { 862.34,-2142.64,30.48,357.17 },
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function VehicleMods(Vehicle,Customize)
	if not Customize then return end
	Customize = ensureTable(Customize)

	SetVehicleModKit(Vehicle,0)

	if Customize["wheeltype"] ~= nil then
		SetVehicleWheelType(Vehicle, Customize["wheeltype"])
	end

	local mods = ensureTable(Customize["mods"])
	for i = 0,16 do
		local v = mods[tostring(i)]
		if v ~= nil then SetVehicleMod(Vehicle,i,v) end
	end

	for i = 17,22 do
		local v = mods[tostring(i)]
		if v ~= nil then ToggleVehicleMod(Vehicle,i,v) end
	end

	for i = 23,24 do
		local v = mods[tostring(i)]
		if v ~= nil then
			Customize["var"] = ensureTable(Customize["var"])
			Customize["var"][tostring(i)] = Customize["var"][tostring(i)] or 0
			SetVehicleMod(Vehicle,i,v,Customize["var"][tostring(i)])
		end
	end

	for i = 25,48 do
		local v = mods[tostring(i)]
		if v ~= nil then SetVehicleMod(Vehicle,i,v) end
	end

	local neon = ensureTable(Customize["neon"])
	if next(neon) then
		for i = 0,3 do
			SetVehicleNeonLightEnabled(Vehicle,i, neon[tostring(i)] == true)
		end
	end

	local extras = ensureTable(Customize["extras"])
	if next(extras) then
		for i = 1,12 do
			local onoff = tonumber(extras[i])
			if onoff == 1 then SetVehicleExtra(Vehicle,i,0) else SetVehicleExtra(Vehicle,i,1) end
		end
	end

	if Customize["liverys"] ~= nil and Customize["liverys"] ~= 24 then
		SetVehicleLivery(Vehicle,Customize["liverys"])
	end

	if Customize["plateIndex"] ~= nil and Customize["plateIndex"] ~= 4 then
		SetVehicleNumberPlateTextIndex(Vehicle,Customize["plateIndex"])
	end

	-- Defaults seguros
	local xenon = tonumber(Customize["xenonColor"]) or 0
	SetVehicleXenonLightsColour(Vehicle, xenon)

	local colors = ensureTable(Customize["colors"])
	SetVehicleColours(Vehicle, tonumber(colors[1]) or 0, tonumber(colors[2]) or 0)

	local extracolors = ensureTable(Customize["extracolors"])
	SetVehicleExtraColours(Vehicle, tonumber(extracolors[1]) or 0, tonumber(extracolors[2]) or 0)

	local lights = ensureTable(Customize["lights"])
	SetVehicleNeonLightsColour(Vehicle, tonumber(lights[1]) or 255, tonumber(lights[2]) or 255, tonumber(lights[3]) or 255)

	local smokecolor = ensureTable(Customize["smokecolor"])
	SetVehicleTyreSmokeColor(Vehicle, tonumber(smokecolor[1]) or 255, tonumber(smokecolor[2]) or 255, tonumber(smokecolor[3]) or 255)

	if Customize["tint"] ~= nil then
		SetVehicleWindowTint(Vehicle,Customize["tint"])
	end

	if Customize["dashColour"] ~= nil then
		SetVehicleInteriorColour(Vehicle,Customize["dashColour"])
	end

	if Customize["interColour"] ~= nil then
		SetVehicleDashboardColour(Vehicle,Customize["interColour"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SpawnPosition(Select)
	local Slot = "0"
	local Checks = 0
	local Selected = {}
	local Position = nil

	repeat
		Checks = Checks + 1
		Slot = tostring(Checks)
		if Garages[Select][Slot] ~= nil then
			local _,Groundz = GetGroundZAndNormalFor_3dCoord(Garages[Select][Slot][1],Garages[Select][Slot][2],Garages[Select][Slot][3])
			Selected = { Garages[Select][Slot][1],Garages[Select][Slot][2],Groundz,Garages[Select][Slot][4] }
			Position = GetClosestVehicle(Selected[1],Selected[2],Selected[3],2.501,0,71)
		end
	until not DoesEntityExist(Position) or not Garages[Select][Slot]

	if not Garages[Select][tostring(Checks)] then
		TriggerEvent("Notify","amarelo","Vagas estão ocupadas.",5000)
		return false
	end

	return Selected
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAFE JSON (evita decode em boolean/nil)
-----------------------------------------------------------------------------------------------------------------------------------------
local function safeJsonDecode(data)
	if data == nil then return nil end
	local t = type(data)
	if t == "table" then return data end
	if t == "string" and data ~= "" then
		local ok, decoded = pcall(json.decode, data)
		if ok then return decoded end
	end
	-- boolean/number/qualquer outra coisa -> não tenta decodificar
	return nil
end

local function ensureTable(t)
	return type(t) == "table" and t or {}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEVEHICLE (safe)
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CreateVehicle(Model,Network,Engine,Health,Customize,Windows,Tyres,Notebook)
	if not Network or not NetworkDoesNetworkIdExist(Network) then
		SendNUIMessage({ action = "Visible", data = false })
		SetNuiFocus(false,false)
		return
	end

	local Vehicle = NetToEnt(Network)
	if not DoesEntityExist(Vehicle) then
		SendNUIMessage({ action = "Visible", data = false })
		SetNuiFocus(false,false)
		return
	end

	-- Customize pode vir string JSON, table, nil ou FALSE -> aqui não quebra
	local Mods = safeJsonDecode(Customize)
	if Mods then
		VehicleMods(Vehicle, Mods)
	end

	-- Health/Engine safe
	if Engine ~= nil then SetVehicleEngineHealth(Vehicle, (tonumber(Engine) or 0.0) + 0.0) end
	if Health ~= nil then SetEntityHealth(Vehicle, tonumber(Health) or GetEntityHealth(Vehicle)) end

	-- Windows (safe)
	local Win = safeJsonDecode(Windows)
	if Win then
		for k,v in pairs(Win) do
			-- quando vier false => janela quebrada
			if v == false then
				RemoveVehicleWindow(Vehicle, tonumber(k) or 0)
			end
		end
	end

	-- Tyres (safe)
	local Tyr = safeJsonDecode(Tyres)
	if Tyr then
		for k,burst in pairs(Tyr) do
			if burst == true then
				SetVehicleTyreBurst(Vehicle, tonumber(k) or 0, true, 1000.0)
			end
		end
	end

	-- Notebook (safe)
	local Note = safeJsonDecode(Notebook)
	if Note then
		local boost     = tonumber(Note["boost"])     or 0.0
		local trafront  = tonumber(Note["trafront"])  or 0.0
		local curve     = tonumber(Note["curve"])     or 0.0
		local lowspeed  = tonumber(Note["lowspeed"])  or 0.0
		local clutchup  = tonumber(Note["clutchup"])  or 0.0
		local clutchdown= tonumber(Note["clutchdown"])or 0.0

		SetVehicleHandlingFloat(Vehicle,"CHandlingData","fInitialDriveForce", boost * 1.0)
		SetVehicleHandlingFloat(Vehicle,"CHandlingData","fTractionBiasFront", trafront * 1.0)
		SetVehicleHandlingFloat(Vehicle,"CHandlingData","fTractionCurveLateral", curve * 1.0)
		SetVehicleHandlingFloat(Vehicle,"CHandlingData","fLowSpeedTractionLossMult", lowspeed * 1.0)
		SetVehicleHandlingFloat(Vehicle,"CHandlingData","fClutchChangeRateScaleUpShift", clutchup * 1.0)
		SetVehicleHandlingFloat(Vehicle,"CHandlingData","fClutchChangeRateScaleDownShift", clutchdown * 1.0)
	end

	-- Decor safe
	if not DecorExistOn(Vehicle,"PlayerVehicle") then
		DecorSetInt(Vehicle,"PlayerVehicle",-1)
	end

	SetModelAsNoLongerNeeded(Model)

	SendNUIMessage({ action = "Visible", data = false })
	SetNuiFocus(false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Delete")
AddEventHandler("garages:Delete",function(Vehicle)
	if not Vehicle or Vehicle == "" then
		Vehicle = rEVOLT.ClosestVehicle(15)
	end

	if IsEntityAVehicle(Vehicle) then
		local Tyres = {}
		local Doors = {}
		local Windows = {}

		for i = 0,5 do
			Doors[i] = IsVehicleDoorDamaged(Vehicle,i)
		end

		for i = 0,5 do
			Windows[i] = IsVehicleWindowIntact(Vehicle,i)
		end

		for i = 0,7 do
			local Status = false

			if GetTyreHealth(Vehicle,i) ~= 1000.0 then
				Status = true
			end

			Tyres[i] = Status
		end

		if DecorExistOn(Vehicle,"PlayerVehicle") then
			DecorRemove(Vehicle,"PlayerVehicle")
		end

		vSERVER.Delete(VehToNet(Vehicle),GetEntityHealth(Vehicle),GetVehicleEngineHealth(Vehicle),GetVehicleBodyHealth(Vehicle),GetVehicleFuelLevel(Vehicle),Doors,Windows,Tyres,GetVehicleNumberPlateText(Vehicle))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SearchBlip(Coords)
	if DoesBlipExist(Searched) then
		RemoveBlip(Searched)
		Searched = nil
	end

	Searched = AddBlipForCoord(Coords["x"],Coords["y"],Coords["z"])
	SetBlipSprite(Searched,225)
	SetBlipColour(Searched,2)
	SetBlipScale(Searched,0.6)
	SetBlipAsShortRange(Searched,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Veículo")
	EndTextCommandSetBlipName(Searched)

	SetTimeout(30000,function()
		RemoveBlip(Searched)
		Searched = nil
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StartHotwired()
	Hotwired = true
	if LoadAnim(Dict) then
		TaskPlayAnim(PlayerPedId(),Dict,Anim,8.0,8.0,-1,49,5.0,0,0,0)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StopHotwired(Vehicle)
	Hotwired = false
	if LoadAnim(Dict) then
		StopAnimTask(PlayerPedId(),Dict,Anim,8.0)
	end
	if Vehicle then
		SetEntityAsMissionEntity(Vehicle,true,false)
		SetVehicleHasBeenOwnedByPlayer(Vehicle,true)
		SetVehicleNeedsToBeHotwired(Vehicle,false)
		if not DecorExistOn(Vehicle,"PlayerVehicle") then
			DecorSetInt(Vehicle,"PlayerVehicle",-1)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UpdateHotwired(Status)
	Hotwired = Status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOPHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] == 0 then
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) then
				local Vehicle = GetVehiclePedIsUsing(Ped)
				local Plate = GetVehicleNumberPlateText(Vehicle)
				--[[ and not Entity(Vehicle)["state"]["Lockpick"] ]]
				if not GlobalState["Plates"][Plate] and GetPedInVehicleSeat(Vehicle,-1) == Ped and "AUTOESCO" ~= Plate then
					SetVehicleEngineOn(Vehicle,false,true,true)
					DisablePlayerFiring(Ped,true)
					TimeDistance = 1
				end
				if Hotwired and Vehicle then
					DisableControlAction(1,75,true)
					DisableControlAction(1,20,true)
					TimeDistance = 1
				end
			end
		end
		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Impound")
AddEventHandler("garages:Impound",function()
	local Impound = vSERVER.Impound()
	if parseInt(#Impound) > 0 then
		for k,v in pairs(Impound) do
			if v["Price"] then
				exports["dynamic"]:AddButton(v["name"],"A liberação tem o custo: <b>$"..parseFormat(v["Price"] * 0.15).."</b> dólares.","garages:Impound",v["Model"],false,true)
			else
				exports["dynamic"]:AddButton(v["name"],"A liberação tem o custo: <b>$"..parseFormat(v["Gemstone"] * 0.15).."</b> Gemas.","garages:Impound",v["Model"],false,true)
			end
		end
		exports["dynamic"]:openMenu()
	else
		TriggerEvent("Notify","amarelo","Não possui veículos apreendidos.",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
local Nearest = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Garages = exports["propertys"]:Garages()
	while true do
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)
			for Key,Value in pairs(Garages) do
				if 20 >= #(Coords - vec3(Value["x"],Value["y"],Value["z"])) then
					if not Nearest[Key] then
						Nearest[Key] = Value
					end
				else
					if Nearest[Key] ~= nil then
						Nearest[Key] = nil
					end
				end
			end
		end
        Wait(1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) and arrayLength(Nearest) > 0 then
			local Coords = GetEntityCoords(Ped)
			for Number,v in pairs(Nearest) do
				local Distance = #(Coords - vec3(v["x"],v["y"],v["z"]))
				if Distance <= 2.5 then
					TimeDistance = 1
					if IsControlJustPressed(1,38) then
						local garagem = vSERVER.Vehicles("Home:"..Number)
						if garagem then
							local Endpoint = GetCurrentServerEndpoint():gsub(":(%d+)$","").."/revolt_base"
							for key,value in pairs(garagem) do
								value["image"] = "http://"..Endpoint.."/garages/"..value.model..".png"
							end
							Opened = "Home:"..Number
							SetNuiFocus(true,true)
							SendNUIMessage({ action = "Visible", data = true })
							SendNUIMessage({ action = "OpenGarage", data = garagem })
						end	
					end
				end
			end
		end
        Wait(TimeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function arrayLength(array)
	local len = 0
    if array ~= nil then
        for key,value in pairs(array) do 
            if array[key] then
                len = len+1
            end
	    end
    end
	return len
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Garages) do
        exports["creative"]:AddPed({
			Distance = 25,
			Coords = { v["x"],v["y"],v["z"],v["h"] or 0.0 },
			Model = tonumber(Number) <= 26 and "s_m_m_security_01" or "ig_trafficwarden",
			anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
		})
		exports["target"]:AddCircleZone("Garage:"..Number,vec3(v["x"],v["y"],v["z"]),0.5,{
            name = "Garage:"..Number,
            heading = 3374176
        },{
            Distance = 1.75,
            options = {
				{
					event = "Garage",
					label = "Abrir",
					tunnel = "client"
				}
            }
        })
    end
	local Tables = {}
	for Number,v in pairs(exports["propertys"]:Garages()) do
		Garages["Home:"..Number] = {
			["x"] = v["x"],
			["y"] = v["y"],
			["z"] = v["z"],
			["1"] = v["1"]
		}
		Tables[#Tables + 1] = { v["x"],v["y"],v["z"],2.5,"E","Garagem","Pressione para abrir" }
    end
	TriggerEvent("hoverfy:Insert",Tables)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGE:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Garage",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)
			for Number,v in pairs(Garages) do
				local Distance = #(Coords - vec3(v["x"],v["y"],v["z"]))
				if Distance <= 1.25 then
					local garagem = vSERVER.Vehicles(Number)
					if garagem then
						local Endpoint = GetCurrentServerEndpoint():gsub(":(%d+)$","").."/revolt_base"
						for key,value in pairs(garagem) do
							value["image"] = "http://"..Endpoint.."/garages/"..value.model..".png"
						end
						Opened = Number
						SetNuiFocus(true,true)
						SendNUIMessage({ action = "Visible", data = true })
						SendNUIMessage({ action = "OpenGarage", data = garagem })
					end	
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:LockVehicle")
AddEventHandler("garages:LockVehicle",function(Vehicle)
	if NetworkDoesNetworkIdExist(Vehicle) then
		local Network = NetToEnt(Vehicle)
		if DoesEntityExist(Network) then
			SetVehicleLights(Network,2)
			Wait(200)
			SetVehicleLights(Network,0)
			Wait(200)
			SetVehicleLights(Network,2)
			Wait(200)
			SetVehicleLights(Network,0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SendNUIMessage({ action = "Visible", data = false })
	SetNuiFocus(false,false)
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("takeVehicle",function(Data,Callback)
	if GetGameTimer() >= Cooldown then
		Cooldown = GetGameTimer() + 5000
		vSERVER.Spawn(Data["model"],Opened)
	end
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("storeVehicle",function(Data,Callback)
	if GetGameTimer() >= Cooldown then
		Cooldown = GetGameTimer() + 5000
		TriggerEvent("garages:Delete")
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELLVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("sellVehicle",function(Data,Callback)
	SendNUIMessage({ action = "Visible", data = false })
	SetNuiFocus(false,false)

	vSERVER.Sell(Data["model"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("transferVehicle",function(Data,Callback)
	SendNUIMessage({ action = "Visible", data = false })
	SetNuiFocus(false,false)

	vSERVER.Transfer(Data["model"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("taxVehicle",function(Data,Callback)
	SendNUIMessage({ action = "Visible", data = false })
	SetNuiFocus(false,false)

	vSERVER.Tax(Data["model"])

	Callback("Ok")
end)
