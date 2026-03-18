-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIFTENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function driftEnable()
	if not IsPauseMenuActive() then
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) and not IsPedInAnyHeli(Ped) and not IsPedInAnyBoat(Ped) and not IsPedInAnyPlane(Ped) then
			local Vehicle = GetVehiclePedIsIn(Ped)
			if GetPedInVehicleSeat(Vehicle,-1) == Ped then
				local speed = GetEntitySpeed(Vehicle) * 3.6
				if speed <= 100.0 and speed >= 5.0 then
					SetVehicleReduceGrip(Vehicle,true)

					if not GetDriftTyresEnabled(Vehicle) then
						SetDriftTyresEnabled(Vehicle,true)
						SetReduceDriftVehicleSuspension(Vehicle,true)
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIFTDISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function driftDisable()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local Vehicle = GetLastDrivenVehicle()

		if GetDriftTyresEnabled(Vehicle) then
			SetVehicleReduceGrip(Vehicle,false)
			SetDriftTyresEnabled(Vehicle,false)
			SetReduceDriftVehicleSuspension(Vehicle,false)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEDRIFT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("+activeDrift",driftEnable)
RegisterCommand("-activeDrift",driftDisable)
RegisterKeyMapping("+activeDrift","Ativação do drift.","keyboard","LSHIFT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local Blips = {

	{ 265.05,-1262.65,29.3,361,62,"Posto de Gasolina",0.4 },
	{ 819.02,-1027.96,26.41,361,62,"Posto de Gasolina",0.4 },
	{ 1208.61,-1402.43,35.23,361,62,"Posto de Gasolina",0.4 },
	{ 1181.48,-330.26,69.32,361,62,"Posto de Gasolina",0.4 },
	{ 621.01,268.68,103.09,361,62,"Posto de Gasolina",0.4 },
	{ 2581.09,361.79,108.47,361,62,"Posto de Gasolina",0.4 },
	{ 175.08,-1562.12,29.27,361,62,"Posto de Gasolina",0.4 },
	{ -319.76,-1471.63,30.55,361,62,"Posto de Gasolina",0.4 },
	{ 49.42,2778.8,58.05,361,62,"Posto de Gasolina",0.4 },
	{ 264.09,2606.56,44.99,361,62,"Posto de Gasolina",0.4 },
	{ 1039.38,2671.28,39.56,361,62,"Posto de Gasolina",0.4 },
	{ 1207.4,2659.93,37.9,361,62,"Posto de Gasolina",0.4 },
	{ 2539.19,2594.47,37.95,361,62,"Posto de Gasolina",0.4 },
	{ 2679.95,3264.18,55.25,361,62,"Posto de Gasolina",0.4 },
	{ 2005.03,3774.43,32.41,361,62,"Posto de Gasolina",0.4 },
	{ 1687.07,4929.53,42.08,361,62,"Posto de Gasolina",0.4 },
	{ 1701.53,6415.99,32.77,361,62,"Posto de Gasolina",0.4 },
	{ 180.1,6602.88,31.87,361,62,"Posto de Gasolina",0.4 },
	{ -94.46,6419.59,31.48,361,62,"Posto de Gasolina",0.4 },
	{ -2555.17,2334.23,33.08,361,62,"Posto de Gasolina",0.4 },
	{ -1800.09,803.54,138.72,361,62,"Posto de Gasolina",0.4 },
	{ -1437.0,-276.8,46.21,361,62,"Posto de Gasolina",0.4 },
	{ -2096.3,-320.17,13.17,361,62,"Posto de Gasolina",0.4 },
	{ -724.56,-935.97,19.22,361,62,"Posto de Gasolina",0.4 },
	{ -525.26,-1211.19,18.19,361,62,"Posto de Gasolina",0.4 },
	{ -70.96,-1762.21,29.54,361,62,"Posto de Gasolina",0.4 },
	{ 1776.7,3330.56,41.32,361,62,"Posto de Gasolina",0.4 },
	{ -1112.4,-2884.08,13.93,361,62,"Posto de Gasolina",0.4 },

	{ 2680.0,1418.17,24.57,67,29,"Caminhoneiro",0.5 },

	{ -314.78,-883.09,31.07,357,1,"Garagem",0.6 },
	{ -767.34,5583.49,33.6,357,1,"Garagem",0.6 },
	{ 598.04,2741.27,42.07,357,65,"Garagem",0.6 },
	{ -136.36,6357.03,31.49,357,65,"Garagem",0.6 },
	{ 317.7,2623.52,44.47,357,1,"Garagem",0.6 },
	{ -340.76,265.97,85.67,357,65,"Garagem",0.6 },
	{ -2030.01,-465.97,11.60,357,65,"Garagem",0.6 },
	{ -1184.92,-1510.00,4.64,357,65,"Garagem",0.6 },
	{ 361.90,297.81,103.88,357,65,"Garagem",0.6 },
	{ 1035.89,-763.89,57.99,357,65,"Garagem",0.6 },
	{ -796.63,-2022.77,9.16,357,65,"Garagem",0.6 },
	{ 528.66,-146.3,58.38,357,65,"Garagem",0.6 },
	{ -1159.48,-739.32,19.89,357,65,"Garagem",0.6 },
	{ 1695.33,4763.57,41.99,357,65,"Garagem",0.6 },
	{ 1624.05,3566.14,35.15,357,1,"Garagem",0.6 },
	{ -73.35,-2004.6,18.27,357,65,"Garagem",0.6 },
	{ 2655.01,1693.36,24.48,357,65,"Garagem",0.6 },

	{ -673.02,317.89,83.09,80,38,"Hospital",0.5 },
	{ 1839.43,3672.86,34.27,80,38,"Hospital",0.5 },
	{ -247.42,6331.39,32.42,80,38,"Hospital",0.5 },
	{ 1155.72,-1528.86,34.85,80,38,"Hospital",0.5 },

	
	{ 81.14,274.11,110.21,383,46,"MCdonalds",0.7 },


	{ 227.17,-1755.58,25.24,353,1,"Families",0.5 }, --Families
	{ 106.24,-1995.65,14.88,353,1,"Ballas",0.5 }, --Ballas
	{ 427.68,-2051.18,18.74,353,1,"Vagos",0.5 }, --Vagos
	{ 1521.53,-171.92,199.08,378,0,"FAVELA DA GROTA",0.6 }, --grota
	{ 2248.62,49.97,251.42,433,1,"Favela2",0.5 }, --Favela2
	{ 1687.32,390.24,245.48,433,1,"Favela3",0.5 }, --Favela3
	{ 2993.58,3034.58,105.73,433,1,"Favela4",0.5 }, --Favela4

	{ -1275.59,-314.67,36.85,402,2,"Auto Sport Performace",0.7 }, 
	{ 1506.74,1703.62,110.42,100,2,"Ferro Velho",0.7 }, 
	
	{ 29.2,-1351.89,29.34,52,36,"Loja de Departamento",0.5 },
	{ 2561.74,385.22,108.61,52,36,"Loja de Departamento",0.5 },
	{ 1160.21,-329.4,69.03,52,36,"Loja de Departamento",0.5 },
	{ -711.99,-919.96,19.01,52,36,"Loja de Departamento",0.5 },
	{ -54.56,-1758.56,29.05,52,36,"Loja de Departamento",0.5 },
	{ 375.87,320.04,103.42,52,36,"Loja de Departamento",0.5 },
	{ -3237.48,1004.72,12.45,52,36,"Loja de Departamento",0.5 },
	{ 1730.64,6409.67,35.0,52,36,"Loja de Departamento",0.5 },
	{ 543.51,2676.85,42.14,52,36,"Loja de Departamento",0.5 },
	{ 1966.53,3737.95,32.18,52,36,"Loja de Departamento",0.5 },
	{ 2684.73,3281.2,55.23,52,36,"Loja de Departamento",0.5 },
	{ 1696.12,4931.56,42.07,52,36,"Loja de Departamento",0.5 },
	{ -1820.18,785.69,137.98,52,36,"Loja de Departamento",0.5 },
	{ 1395.35,3596.6,34.86,52,36,"Loja de Departamento",0.5 },
	{ -2977.14,391.22,15.03,52,36,"Loja de Departamento",0.5 },
	{ -3034.99,590.77,7.8,52,36,"Loja de Departamento",0.5 },
	{ 1144.46,-980.74,46.19,52,36,"Loja de Departamento",0.5 },
	{ 1166.06,2698.17,37.95,52,36,"Loja de Departamento",0.5 },
	{ -1493.12,-385.55,39.87,52,36,"Loja de Departamento",0.5 },
	{ -1228.6,-899.7,12.27,52,36,"Loja de Departamento",0.5 },
	{ 157.82,6631.8,31.68,52,36,"Loja de Departamento",0.5 },
	{ 1702.78,3748.82,34.05,76,6,"Loja de Armas",0.4 },
	{ 240.06,-43.74,69.71,76,6,"Loja de Armas",0.4 },
	{ 843.95,-1020.43,27.53,76,6,"Loja de Armas",0.4 },
	{ -322.19,6072.86,31.27,76,6,"Loja de Armas",0.4 },
	{ -664.03,-949.22,21.53,76,6,"Loja de Armas",0.4 },
	{ -1318.83,-389.19,36.43,76,6,"Loja de Armas",0.4 },
	{ -1110.11,2687.5,18.62,76,6,"Loja de Armas",0.4 },
	{ 2569.23,309.46,108.46,76,6,"Loja de Armas",0.4 },
	{ -3159.91,1080.64,20.69,76,6,"Loja de Armas",0.4 },
	{ 15.42,-1120.47,28.81,76,6,"Loja de Armas",0.4 },
	{ 811.81,-2145.58,29.34,76,6,"Loja de Armas",0.4 },
	{ -815.12,-184.15,37.57,71,62,"Barbearia",0.5 },
	{ 138.13,-1706.46,29.3,71,62,"Barbearia",0.5 },
	{ -1280.92,-1117.07,7.0,71,62,"Barbearia",0.5 },
	{ 1930.54,3732.06,32.85,71,62,"Barbearia",0.5 },
	{ 1214.2,-473.18,66.21,71,62,"Barbearia",0.5 },
	{ -33.61,-154.52,57.08,71,62,"Barbearia",0.5 },
	{ -276.65,6226.76,31.7,71,62,"Barbearia",0.5 },
	{ -1117.26,-1438.74,5.11,366,62,"Loja de Roupas",0.5 },
	{ 86.06,-1391.64,29.23,366,62,"Loja de Roupas",0.5 },
	{ -719.94,-158.18,37.0,366,62,"Loja de Roupas",0.5 },
	{ -152.79,-306.79,38.67,366,62,"Loja de Roupas",0.5 },
	{ -816.39,-1081.22,11.12,366,62,"Loja de Roupas",0.5 },
	{ -1206.51,-781.5,17.12,366,62,"Loja de Roupas",0.5 },
	{ -1458.26,-229.79,49.2,366,62,"Loja de Roupas",0.5 },
	{ -2.41,6518.29,31.48,366,62,"Loja de Roupas",0.5 },
	{ 1682.59,4819.98,42.04,366,62,"Loja de Roupas",0.5 },
	{ 129.46,-205.18,54.51,366,62,"Loja de Roupas",0.5 },
	{ 618.49,2745.54,42.01,366,62,"Loja de Roupas",0.5 },
	{ 1197.93,2698.21,37.96,366,62,"Loja de Roupas",0.5 },
	{ -3165.74,1061.29,20.84,366,62,"Loja de Roupas",0.5 },
	{ -1093.76,2703.99,19.04,366,62,"Loja de Roupas",0.5 },
	{ 414.86,-807.57,29.34,366,62,"Loja de Roupas",0.5 },
	{ -1082.22,-247.54,37.77,439,73,"Life Invader",0.6 },
	{ -776.72,-1495.02,2.29,266,62,"Embarcações",0.5 },
	{ -1604.83,5256.85,2.07,266,62,"Embarcações",0.5 },
	{ 4971.95,-5171.1,2.29,266,62,"Embarcações",0.5 },
	{ 46.66,-1749.79,29.64,78,11,"Mercado Central",0.5 },
	{ 2747.28,3473.04,55.67,78,11,"Mercado Central",0.5 },
	{ -56.8,6523.9,31.49,78,11,"Mercado Central",0.5 },
	{ -56.99,6522.8,31.49,78,11,"Mercado Central",0.5 },


	{ 85.3,6524.18,43.88,60,0,"4BPM BAEP",0.6 },
	--{ 85.3,6524.18,43.88,161,0,"",0.6 },

	--{ 1538.52,819.82,86.12,161,0,"",0.6 },
	{ -1176.06,-2246.7,14.93,60,0,"Batalhão ROTA",0.6 },
	--{ -1176.06,-2246.7,14.93,161,0,"",0.6 },
	{ 1807.23,3587.4,36.38,60,0,"89. Policia Civil",0.6 },
	--{ 375.87,-754.69,30.8,161,0,"",0.6 },
	{ 1366.19,-733.72,65.85,60,0,"16BPM Força Tatica",0.6 },
	--{ 1366.19,-733.72,65.85,161,0,"",0.6 },
	

	{ 2129.32,3863.57,33.94,60,0,"Policia Federal",0.6 },
	{ 2613.41,5311.46,45.46,60,0,"Policia Rodoviaria",0.6 },

	{ -919.09,-2056.21,9.4,60,0,"PMESP",0.6 },

	
	
	

	
	{ -361.52,-1564.52,25.02,318,62,"Lixeiro",0.6 },
	--{ 946.2,-991.64,39.14,402,26,"Autocare",0.7 },

	{ 762.99,-814.57,26.34,76,3,"AutoCenter",0.6 },
	{ 2953.93,2787.49,41.5,617,62,"Pedreira",0.6 },
	{ 1322.93,-1652.29,52.27,75,13,"Loja de Tatuagem",0.5 },
	{ -1154.42,-1425.9,4.95,75,13,"Loja de Tatuagem",0.5 },
	{ 322.84,180.16,103.58,75,13,"Loja de Tatuagem",0.5 },
	{ -3169.62,1075.8,20.83,75,13,"Loja de Tatuagem",0.5 },
	{ 1864.07,3747.9,33.03,75,13,"Loja de Tatuagem",0.5 },
	{ -293.57,6199.85,31.48,75,13,"Loja de Tatuagem",0.5 },
	{ 1525.07,3784.92,34.49,317,62,"Pescador",0.5 },
	--{ 2057.89,5109.83,46.34,267,62,"Pomar",0.4 },
	{ 368.87,6475.52,29.81,76,62,"Agricultura",0.4 },
	-- { -1178.2,-880.6,13.92,106,1,"BurgerShot",0.4 },
	{ -1038.31,-1469.01,5.05,385,1,"Japonese Martial Restaurant",0.5 },
	
	{ -1600.6,-831.0,10.04,198,62,"Taxista",0.5 },
	{ 1696.19,4785.25,42.02,198,62,"Taxista",0.5 },
	{ -680.9,5832.41,17.32,89,11,"Central de Agropecuária",0.5 },
	{ -535.04,-221.34,37.64,267,5,"Prefeitura",0.4 },
	{ 1141.02,-474.58,66.51,459,8,"DigitalDen",0.6 },
	{ 1087.67,6509.36,21.06,210,2,"Hortifruit",0.5 },
	{ -69.92,6262.28,31.09,154,0,"Açougueiro",0.4 },
	{ 124.98,-1086.26,29.2,106,0,"Bicicletário",0.4 },
	{ 1544.29,3786.03,34.22,106,0,"Bicicletário",0.4 },
	{ 152.72,6452.93,31.27,106,0,"Bicicletário",0.4 },
	{ -1031.1,-2729.02,13.75,106,0,"Bicicletário",0.4 },
	{ 2832.82,2795.1,57.47,78,66,"Minerador",0.5 },
	-- { 374.23,-1267.59,32.5,469,69,"Blazeit",0.8 },
	{ -595.06,5066.48,136.1,141,21,"Área de caça (10km²)",1.0},
	{177.95,-1321.41,29.5,431,69,"PawnShop",0.7},
	{-58.54,-801.63,44.23,407,5,"Informações",0.4},
	{1590.7,3592.57,38.77,407,5,"Informações",0.4},
	{ 408.56,-1624.93,29.15,357,9,"Impound",0.6 },
	{ -614.08,-1608.6,26.86,365,1,"Compra e venda Scrap",0.6 },
	{ 2409.91,5043.58,46.0,285,0,"Lenhador",0.4 },
	-- { 1691.53,2566.09,45.57,12,2,"Serviço",0.4 },
	-- { 1178.18,2650.95,37.79,402,0,"68 LS Auto Repair",0.8 },
	-- { -175.49,-1288.72,31.64,478,52,"Self Storage",0.6 },
	-- { -60.09,-1215.82,28.59,478,52,"Self Storage",0.6 },
	-- { 915.37,3570.61,33.78,478,52,"Self Storage",0.6 },
	{ 108.36,-158.16,54.83,89,50,"Concessionaria",0.4 },
	{ -9.17,-657.0,33.45,67,62,"Transportador de valores",0.5 }


}
-----------------------------------------------------------------------------------------------------------------------------------------

-- Flag global usada para bloquear densidade em áreas especiais
inNoPedArea = inNoPedArea or false

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS (OTIMIZADO)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Models/Peds suprimidos: isso não precisa rodar em loop.
CreateThread(function()
	SetVehicleModelIsSuppressed(GetHashKey("jet"),true)
	SetVehicleModelIsSuppressed(GetHashKey("besra"),true)
	SetVehicleModelIsSuppressed(GetHashKey("luxor"),true)
	SetVehicleModelIsSuppressed(GetHashKey("blimp"),true)
	SetVehicleModelIsSuppressed(GetHashKey("polmav"),true)
	SetVehicleModelIsSuppressed(GetHashKey("buzzard2"),true)
	SetVehicleModelIsSuppressed(GetHashKey("mammatus"),true)
	SetPedModelIsSuppressed(GetHashKey("s_m_y_prismuscl_01"),true)
	SetPedModelIsSuppressed(GetHashKey("u_m_y_prisoner_01"),true)
	SetPedModelIsSuppressed(GetHashKey("s_m_y_prisoner_01"),true)
end)

-- Rotinas gerais: 1x por segundo é mais do que suficiente.
CreateThread(function()
	while true do
		InvalidateIdleCam()
		InvalidateVehicleIdleCam()

		SetCreateRandomCops(false)
		CancelCurrentPoliceReport()
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)

		SetPedInfiniteAmmoClip(PlayerPedId(),false)
		Wait(1000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD/CONTROLES/DANOS (FRAME-BASED)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Tudo que usa "*ThisFrame" precisa rodar por frame.
-- O que NÃO é por frame foi separado em outras threads abaixo.
local __lastWeather, __lastHour, __lastMinute = nil, nil, nil

CreateThread(function()
	while true do
		local ped = PlayerPedId()

		-- Dano por frame
		SetWeaponDamageModifierThisFrame("WEAPON_BAT",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_KATANA",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_HAMMER",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_WRENCH",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_UNARMED",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_HATCHET",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_CROWBAR",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_MACHETE",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_POOLCUE",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_KNUCKLE",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_KARAMBIT",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_GOLFCLUB",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_BATTLEAXE",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_FLASHLIGHT",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_NIGHTSTICK",0.35)
		SetWeaponDamageModifierThisFrame("WEAPON_STONE_HATCHET",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_SMOKEGRENADE",0.0)

		-- HUD por frame
		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(2)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(5)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(10)
		HideHudComponentThisFrame(11)
		HideHudComponentThisFrame(12)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(15)
		HideHudComponentThisFrame(17)
		HideHudComponentThisFrame(18)
		HideHudComponentThisFrame(19)
		HideHudComponentThisFrame(20)
		HideHudComponentThisFrame(21)
		HideHudComponentThisFrame(22)

		-- Controles por frame
		DisableControlAction(1,37,true)
		DisableControlAction(1,204,true)
		DisableControlAction(1,211,true)
		DisableControlAction(1,349,true)
		DisableControlAction(1,192,true)
		DisableControlAction(1,157,true)
		DisableControlAction(1,158,true)
		DisableControlAction(1,159,true)
		DisableControlAction(1,160,true)
		DisableControlAction(1,161,true)
		DisableControlAction(1,162,true)
		DisableControlAction(1,163,true)
		DisableControlAction(1,164,true)
		DisableControlAction(1,165,true)

		-- Evita soco/coronhada quando armado
		if IsPedArmed(ped,6) then
			DisableControlAction(1,140,true)
			DisableControlAction(1,141,true)
			DisableControlAction(1,142,true)
		end

		-- Densidade (centralizado): rota OU área no-ped bloqueia tudo.
		-- Se não estiver bloqueado, mantém o padrão do seu script.
		local blockDensity = (LocalPlayer["state"]["Route"] > 0) or inNoPedArea

		if blockDensity then
			SetVehicleDensityMultiplierThisFrame(0.0)
			SetRandomVehicleDensityMultiplierThisFrame(0.0)
			SetParkedVehicleDensityMultiplierThisFrame(0.0)
			SetAmbientVehicleRangeMultiplierThisFrame(0.0)
			SetScenarioPedDensityMultiplierThisFrame(0.0,0.0)
			SetPedDensityMultiplierThisFrame(0.0)
		else
			SetVehicleDensityMultiplierThisFrame(0.50)
			SetRandomVehicleDensityMultiplierThisFrame(0.50)
			SetParkedVehicleDensityMultiplierThisFrame(1.0)
			SetAmbientVehicleRangeMultiplierThisFrame(1.0)
			SetScenarioPedDensityMultiplierThisFrame(1.0,1.0)
			SetPedDensityMultiplierThisFrame(1.0)
		end

		Wait(0)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PICKUPS (PESADO) - NÃO RODA POR FRAME
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		RemoveAllPickupsOfType("PICKUP_WEAPON_KNIFE")
		RemoveAllPickupsOfType("PICKUP_WEAPON_PISTOL")
		RemoveAllPickupsOfType("PICKUP_WEAPON_MINISMG")
		RemoveAllPickupsOfType("PICKUP_WEAPON_MICROSMG")
		RemoveAllPickupsOfType("PICKUP_WEAPON_PUMPSHOTGUN")
		RemoveAllPickupsOfType("PICKUP_WEAPON_CARBINERIFLE")
		RemoveAllPickupsOfType("PICKUP_WEAPON_SAWNOFFSHOTGUN")
		Wait(10000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED/REWARDS (NÃO PRECISA SER POR FRAME)
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local pid = PlayerId()
		if GetPlayerWantedLevel(pid) ~= 0 then
			ClearPlayerWantedLevel(pid)
		end
		DisablePlayerVehicleRewards(pid)
		Wait(1000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CLIMA/HORA (CACHE)
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local weather = GlobalState["Weather"]
		if weather and weather ~= __lastWeather then
			__lastWeather = weather
			SetWeatherTypeNow(weather)
			SetWeatherTypePersist(weather)
			SetWeatherTypeNowPersist(weather)
		end

		local h = GlobalState["Hours"]
		local m = GlobalState["Minutes"]
		if h and m and (h ~= __lastHour or m ~= __lastMinute) then
			__lastHour, __lastMinute = h, m
			NetworkOverrideClockTime(h,m,0)
		end

		Wait(2000)
	end
end)

-- LIMPAR ÁREA PEDS
-----------------------------------------------------------------------------------------------------------------------------------------
inNoPedArea = false
local actArea = 0
local noPedsAreas = {
	{vector3(2352.2,950.91,109.54), 150},
	{vector3(1990.92,3048.93,50.5), 50},
	{vector3(-559.26,285.12,82.18), 50},
	{vector3(-2243.85,3240.57,34.49), 150},
	{vector3(-1911.45,3127.4,36.21), 150},
	{vector3(-1809.19,2981.03,37.81), 150},
	{vector3(-1769.9,3108.19,34.71), 150},
	{vector3(-1944.5,2822.91,39.11), 150},
	
	
}

local noPedsThread = {
	inArea = function()
		local playerPed = PlayerPedId()
		local pedCds = GetEntityCoords(playerPed)
		local tWait = 500
		if Vdist(pedCds, actArea[1]) > actArea[2] then
			inNoPedArea = false
			actArea = 0
			tWait = 1000
			goto back
		end
		::back::
		return tWait
	end,
	outArea = function()
		local playerPed = PlayerPedId()
		local pedCds = GetEntityCoords(playerPed)
		local tWait = 1000
		for k,v in pairs(noPedsAreas) do
			if Vdist(pedCds, v[1]) > v[2] then
				goto continue
			end
			inNoPedArea = true
			actArea = v
			tWait = 0
			goto back
			::continue::
		end
		::back::
		return tWait
	end
}

CreateThread(function()
	while true do
		if not inNoPedArea then
			Wait(noPedsThread.outArea())
		else
			Wait(noPedsThread.inArea())
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local Teleport = {
	{ 330.19,-601.21,43.29,343.65,-581.77,28.8 },
	{ 343.65,-581.77,28.8,330.19,-601.21,43.29 },

	{ 327.16,-603.53,43.29,338.97,-583.85,74.16 },
	{ 338.97,-583.85,74.16,327.16,-603.53,43.29 },

	{ -741.07,5593.13,41.66,446.19,5568.79,781.19 },
	{ 446.19,5568.79,781.19,-741.07,5593.13,41.66 },

	{ -1194.46,-1189.31,7.69,1173.55,-3196.68,-39.00 },
	{ 1173.55,-3196.68,-39.00,-1194.46,-1189.31,7.69 },

	{ -79.75,-836.72,40.56,-75.0,-824.54,321.29 },
	{ -75.0,-824.54,321.29,-79.75,-836.72,40.56 },

	{ 240.89,-1004.87,-99.01,183.02,-1062.76,74.37 },      -------- LUGAR BRANCO  
	{ 183.02,-1062.76,74.37,240.89,-1004.87,-99.01 },

	
	{ 0.94,-703.18,16.13,10.36,-668.13,33.45 },      -------- transporte  
	{ 10.36,-668.13,33.45,0.94,-703.18,16.13 },


	
	
	{ 236.23,229.27,97.11,234.24,229.94,97.11 },
	{ 234.24,229.94,97.11,236.23,229.27,97.11 },
	{575.68,-423.15,-69.66, -322.08,-894.81,31.07},
	{402.68,-1004.0,-99.01, -322.08,-894.81,31.07}

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number = 1,#Blips do
		local Blip = AddBlipForCoord(Blips[Number][1],Blips[Number][2],Blips[Number][3])
		SetBlipSprite(Blip,Blips[Number][4])
		SetBlipDisplay(Blip,4)
		SetBlipAsShortRange(Blip,true)
		SetBlipColour(Blip,Blips[Number][5])
		SetBlipScale(Blip,Blips[Number][7])
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Blips[Number][6])
		EndTextCommandSetBlipName(Blip)
	end

	local Tables = {}

	for Number = 1,#Teleport do
		Tables[#Tables + 1] = { Teleport[Number][1],Teleport[Number][2],Teleport[Number][3],2.5,"E","Porta de Acesso","Pressione para acessar" }
	end

	TriggerEvent("hoverfy:Insert",Tables)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)

				for Number = 1,#Teleport do
					local v = Teleport[Number]
					local Distance = #(Coords - vec3(v[1],v[2],v[3]))
					if Distance <= 1 then
						TimeDistance = 1

						if IsControlJustPressed(1,38) then
							SetEntityCoords(Ped,v[4],v[5],v[6],false,false,false,false)

							if Number == 11 or Number == 12 then
								local Finishing = false
								local Handle,Object = FindFirstObject()
		
								repeat
									local Coords2 = GetEntityCoords(Object)
									local distObj = #(Coords2 - Coords)
		
									if distObj < 3.0 and GetEntityModel(Object) == 961976194 then
										FreezeEntityPosition(Object,true)
									end
		
									Finishing,Object = FindNextObject(Handle)
								until not Finishing
		
								EndFindObject(Handle)
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
local fov_max = 80.0
local fov_min = 10.0
local speed_ud = 3.0
local zoomspeed = 2.0
local vehCamera = false
local fov = (fov_max + fov_min) * 0.5
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local waitPacket = 500
		local Ped = PlayerPedId()
		if IsPedInAnyHeli(Ped) then
			waitPacket = 4

			local veh = GetVehiclePedIsUsing(Ped)
			SetVehicleRadioEnabled(veh,false)

			if IsControlJustPressed(1,51) then
				-- TriggerEvent("hud:Active",false)
				vehCamera = true
			end

			if IsControlJustPressed(1,154) then
				if GetPedInVehicleSeat(veh,1) == Ped or GetPedInVehicleSeat(veh,2) == Ped then
					TaskRappelFromHeli(Ped,1)
				end
			end

			if vehCamera then
				SetTimecycleModifierStrength(0.3)
				SetTimecycleModifier("heliGunCam")

				local scaleform = RequestScaleformMovie("HELI_CAM")
				while not HasScaleformMovieLoaded(scaleform) do
					Wait(1)
				end

				local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA",true)
				AttachCamToEntity(cam,veh,0.0,0.0,-1.5,true)
				SetCamRot(cam,0.0,0.0,GetEntityHeading(veh))
				SetCamFov(cam,fov)
				RenderScriptCams(true,false,0,1,0)
				PushScaleformMovieFunction(scaleform,"SET_CAM_LOGO")
				PushScaleformMovieFunctionParameterInt(0)
				PopScaleformMovieFunctionVoid()

				while vehCamera do
					if IsControlJustPressed(1,51) then
						TriggerEvent("hud:Active",true)
						vehCamera = false
					end

					local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
					CheckInputRotation(cam,zoomvalue)
					HandleZoom(cam)
					HideHudAndRadarThisFrame()
					HideHudComponentThisFrame(19)
					PushScaleformMovieFunction(scaleform,"SET_ALT_FOV_HEADING")
					PushScaleformMovieFunctionParameterFloat(GetEntityCoords(veh).z)
					PushScaleformMovieFunctionParameterFloat(zoomvalue)
					PushScaleformMovieFunctionParameterFloat(GetCamRot(cam,2).z)
					PopScaleformMovieFunctionVoid()
					DrawScaleformMovieFullscreen(scaleform,255,255,255,255)

					Wait(1)
				end

				ClearTimecycleModifier()
				fov = (fov_max + fov_min) * 0.5
				RenderScriptCams(false,false,0,1,0)
				SetScaleformMovieAsNoLongerNeeded(scaleform)
				DestroyCam(cam,false)
				SetNightvision(false)
				SetSeethrough(false)
			end
		end

		Wait(waitPacket)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINPUTROTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckInputRotation(cam,zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0,220)
	local rightAxisY = GetDisabledControlNormal(0,221)
	local rotation = GetCamRot(cam,2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
		new_x = math.max(math.min(20.0,rotation.x + rightAxisY * -1.0 * (3.0) * (zoomvalue + 0.1)),-89.5)
		SetCamRot(cam,new_x,0.0,new_z,2)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLEZOOM
-----------------------------------------------------------------------------------------------------------------------------------------
function HandleZoom(cam)
	if IsControlJustPressed(1,241) then
		fov = math.max(fov - zoomspeed,fov_min)
	end

	if IsControlJustPressed(1,242) then
		fov = math.min(fov + zoomspeed,fov_max)
	end

	local current_fov = GetCamFov(cam)
	if math.abs(fov - current_fov) < 0.1 then
		fov = current_fov
	end

	SetCamFov(cam,current_fov + (fov - current_fov) * 0.05)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISLAND
-----------------------------------------------------------------------------------------------------------------------------------------
local Island = {
	"h4_islandairstrip",
	"h4_islandairstrip_props",
	"h4_islandx_mansion",
	"h4_islandx_mansion_props",
	"h4_islandx_props",
	"h4_islandxdock",
	"h4_islandxdock_props",
	"h4_islandxdock_props_2",
	"h4_islandxtower",
	"h4_islandx_maindock",
	"h4_islandx_maindock_props",
	"h4_islandx_maindock_props_2",
	"h4_IslandX_Mansion_Vault",
	"h4_islandairstrip_propsb",
	"h4_beach",
	"h4_beach_props",
	"h4_beach_bar_props",
	"h4_islandx_barrack_props",
	"h4_islandx_checkpoint",
	"h4_islandx_checkpoint_props",
	"h4_islandx_Mansion_Office",
	"h4_islandx_Mansion_LockUp_01",
	"h4_islandx_Mansion_LockUp_02",
	"h4_islandx_Mansion_LockUp_03",
	"h4_islandairstrip_hangar_props",
	"h4_IslandX_Mansion_B",
	"h4_islandairstrip_doorsclosed",
	"h4_Underwater_Gate_Closed",
	"h4_mansion_gate_closed",
	"h4_aa_guns",
	"h4_IslandX_Mansion_GuardFence",
	"h4_IslandX_Mansion_Entrance_Fence",
	"h4_IslandX_Mansion_B_Side_Fence",
	"h4_IslandX_Mansion_Lights",
	"h4_islandxcanal_props",
	"h4_beach_props_party",
	"h4_islandX_Terrain_props_06_a",
	"h4_islandX_Terrain_props_06_b",
	"h4_islandX_Terrain_props_06_c",
	"h4_islandX_Terrain_props_05_a",
	"h4_islandX_Terrain_props_05_b",
	"h4_islandX_Terrain_props_05_c",
	"h4_islandX_Terrain_props_05_d",
	"h4_islandX_Terrain_props_05_e",
	"h4_islandX_Terrain_props_05_f",
	"h4_islandx_terrain_01",
	"h4_islandx_terrain_02",
	"h4_islandx_terrain_03",
	"h4_islandx_terrain_04",
	"h4_islandx_terrain_05",
	"h4_islandx_terrain_06",
	"h4_ne_ipl_00",
	"h4_ne_ipl_01",
	"h4_ne_ipl_02",
	"h4_ne_ipl_03",
	"h4_ne_ipl_04",
	"h4_ne_ipl_05",
	"h4_ne_ipl_06",
	"h4_ne_ipl_07",
	"h4_ne_ipl_08",
	"h4_ne_ipl_09",
	"h4_nw_ipl_00",
	"h4_nw_ipl_01",
	"h4_nw_ipl_02",
	"h4_nw_ipl_03",
	"h4_nw_ipl_04",
	"h4_nw_ipl_05",
	"h4_nw_ipl_06",
	"h4_nw_ipl_07",
	"h4_nw_ipl_08",
	"h4_nw_ipl_09",
	"h4_se_ipl_00",
	"h4_se_ipl_01",
	"h4_se_ipl_02",
	"h4_se_ipl_03",
	"h4_se_ipl_04",
	"h4_se_ipl_05",
	"h4_se_ipl_06",
	"h4_se_ipl_07",
	"h4_se_ipl_08",
	"h4_se_ipl_09",
	"h4_sw_ipl_00",
	"h4_sw_ipl_01",
	"h4_sw_ipl_02",
	"h4_sw_ipl_03",
	"h4_sw_ipl_04",
	"h4_sw_ipl_05",
	"h4_sw_ipl_06",
	"h4_sw_ipl_07",
	"h4_sw_ipl_08",
	"h4_sw_ipl_09",
	"h4_islandx_mansion",
	"h4_islandxtower_veg",
	"h4_islandx_sea_mines",
	"h4_islandx",
	"h4_islandx_barrack_hatch",
	"h4_islandxdock_water_hatch",
	"h4_beach_party"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCAYO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local CayoPerico = false

	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		if #(Coords - vec3(4840.57,-5174.42,2.0)) <= 2000 then
			if not CayoPerico then
				for _,v in pairs(Island) do
					RequestIpl(v)
				end

				SetIslandHopperEnabled("HeistIsland",true)
				SetAiGlobalPathNodesType(1)
				SetDeepOceanScaler(0.0)
				LoadGlobalWaterType(1)
				CayoPerico = true
			end
		else
			if CayoPerico then
				for _,v in pairs(Island) do
					RemoveIpl(v)
				end

				SetIslandHopperEnabled("HeistIsland",false)
				SetAiGlobalPathNodesType(0)
				SetDeepOceanScaler(1.0)
				LoadGlobalWaterType(0)
				CayoPerico = false
			end
		end

		Wait(TimeDistance)
	end
end)