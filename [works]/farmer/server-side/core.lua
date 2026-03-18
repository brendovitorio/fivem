-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLTC = Tunnel.getInterface("rEVOLT")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Objects = {
	["1"] = { ["Coords"] = vec3(2119.2,5084.76,44.84), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["2"] = { ["Coords"] = vec3(2109.66,5068.44,42.82), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman",["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["3"] = { ["Coords"] = vec3(2093.25,5061.21,42.26), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["4"] = { ["Coords"] = vec3(2070.85,5045.16,41.59), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["5"] = { ["Coords"] = vec3(2059.65,5057.95,41.67), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["6"] = { ["Coords"] = vec3(2074.84,5073.35,42.92), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["7"] = { ["Coords"] = vec3(2090.34,5086.86,44.2), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["8"] = { ["Coords"] = vec3(2098.11,5104.5,45.54), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["9"] = { ["Coords"] = vec3(2101.43,5084.17,44.31), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["10"] = { ["Coords"] = vec3(2077.39,5057.99,42.07), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["11"] = { ["Coords"] = vec3(2059.51,5074.25,42.09), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["12"] = { ["Coords"] = vec3(2071.15,5089.27,43.42), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["13"] = { ["Coords"] = vec3(2081.41,5104.78,44.85), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["14"] = { ["Coords"] = vec3(2077.64,5122.9,46.39), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["15"] = { ["Coords"] = vec3(2058.41,5104.29,45.43), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["16"] = { ["Coords"] = vec3(2040.45,5083.23,42.66), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["17"] = { ["Coords"] = vec3(2041.4,5103.3,44.50), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["18"] = { ["Coords"] = vec3(2060.3,5121.8,45.38), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["19"] = { ["Coords"] = vec3(2062.81,5143.47,47.74), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["20"] = { ["Coords"] = vec3(2040.35,5128.36,46.19), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["21"] = { ["Coords"] = vec3(2020.92,5107.65,44.06), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["22"] = { ["Coords"] = vec3(2017.53,5125.19,45.26), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["23"] = { ["Coords"] = vec3(2043.34,5146.59,47.38), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["24"] = { ["Coords"] = vec3(2036.87,5160.81,48.8), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["25"] = { ["Coords"] = vec3(2022.78,5149.14,47.52), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["26"] = { ["Coords"] = vec3(1999.98,5134.99,45.17), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["27"] = { ["Coords"] = vec3(2026.46,5137.55,46.57), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["28"] = { ["Coords"] = vec3(2024.05,5089.22,42.75), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["29"] = { ["Coords"] = vec3(2045.23,5064.06,41.45), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["30"] = { ["Coords"] = vec3(2115.17,5104.75,46.17), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["31"] = { ["Coords"] = vec3(2099.65,5128.21,48.7), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["32"] = { ["Coords"] = vec3(2081.11,5143.14,50.2), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },
	["33"] = { ["Coords"] = vec3(2063.54,5166.11,51.43), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Coletar", ["Time"] = 0, ["Distance"] = 1.5 },

	["58"] = { ["Coords"] = vec3(2386.34,5099.58,47.55), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["59"] = { ["Coords"] = vec3(2397.96,5087.04,47.31), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["60"] = { ["Coords"] = vec3(2401.23,5099.75,46.4), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_s_01", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["61"] = { ["Coords"] = vec3(2391.37,5110.17,46.39), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["62"] = { ["Coords"] = vec3(2410.42,5089.48,46.51), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["63"] = { ["Coords"] = vec3(2420.39,5070.15,46.62), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["64"] = { ["Coords"] = vec3(2424.72,5082.12,46.71), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_s_01", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["65"] = { ["Coords"] = vec3(2434.98,5062.41,46.34), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["66"] = { ["Coords"] = vec3(2411.24,5079.37,46.88), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["67"] = { ["Coords"] = vec3(2433.39,5074.77,46.32), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["68"] = { ["Coords"] = vec3(2410.41,5127.09,47.25), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["69"] = { ["Coords"] = vec3(2416.61,5116.57,46.88), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["70"] = { ["Coords"] = vec3(2426.6,5122.74,46.98), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_s_01", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["71"] = { ["Coords"] = vec3(2434.38,5111.16,47.08), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["72"] = { ["Coords"] = vec3(2436.03,5098.54,46.45), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["73"] = { ["Coords"] = vec3(2444.76,5087.11,46.34), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["74"] = { ["Coords"] = vec3(2452.11,5073.92,46.32), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_s_01", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["75"] = { ["Coords"] = vec3(2459.98,5082.81,46.94), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["76"] = { ["Coords"] = vec3(2475.47,5086.5,46.13), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["77"] = { ["Coords"] = vec3(2463.86,5101.53,46.45), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["78"] = { ["Coords"] = vec3(2450.84,5107.65,46.89), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_s_01", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["79"] = { ["Coords"] = vec3(2461.8,5063.75,46.78), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["80"] = { ["Coords"] = vec3(2473.81,5048.59,46.44), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["81"] = { ["Coords"] = vec3(2487.0,5035.03,46.79), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["82"] = { ["Coords"] = vec3(2487.67,5053.43,49.29), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_s_01", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["83"] = { ["Coords"] = vec3(2504.84,5049.0,51.44), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["84"] = { ["Coords"] = vec3(2502.22,5069.15,46.51), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FRUITMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Fruitman")
AddEventHandler("farmer:Fruitman",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = rEVOLT.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true
				local Ped = GetPlayerPed(source)
				local Amount = math.random(3,5)
				local Items = { "acerola","banana","guarana","tomato","passion","grape","tange","orange","apple","strawberry","coffee2" }
				local Select = math.random(#Items)
				if (rEVOLT.InventoryWeight(Passport) + itemWeight(Items[Select]) * Amount) <= rEVOLT.GetWeight(Passport) then
					rEVOLTC.playAnim(source,false,{"amb@prop_human_movie_bulb@base","base"},true)
					TriggerClientEvent("Progress",source,11000)
					Objects[Number]["Time"] = GlobalState["Work"] + 25
					Player(source)["state"]["Buttons"] = true
					Player(source)["state"]["Cancel"] = true

					local timeProgress = 10

					repeat
						if timeProgress ~= 10 then
							Wait(400)
						end

						Wait(700)
						timeProgress = timeProgress - 1
					until timeProgress <= 0

					Wait(400)
					
					rEVOLT.GenerateItem(Passport,Items[Select],Amount,true)
					Player(source)["state"]["Buttons"] = false
					Player(source)["state"]["Cancel"] = false
					rEVOLT.UpgradeStress(Passport,1)
					rEVOLTC.removeObjects(source)
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
				end
				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LUMBERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Lumberman")
AddEventHandler("farmer:Lumberman",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = rEVOLT.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local Ped = GetPlayerPed(source)
				if GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_HATCHET") then
					local Amount = math.random(3,5)
					if (rEVOLT.InventoryWeight(Passport) + itemWeight("woodlog") * Amount) <= rEVOLT.GetWeight(Passport) then
						rEVOLTC.playAnim(source,false,{"lumberjackaxe@idle","idle"},true)
						TriggerClientEvent("Progress",source,11000)
						Objects[Number]["Time"] = GlobalState["Work"] + 15
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							if timeProgress ~= 10 then
								Wait(400)
							end

							Wait(700)
							TriggerClientEvent("sounds:Private",source,"lumberman",0.1)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(400)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						rEVOLT.GenerateItem(Passport,"woodlog",Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						rEVOLT.UpgradeStress(Passport,1)
						rEVOLTC.removeObjects(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","É necessário ter um <b>Machado</b> em mãos.",5000)
				end
				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("farmer:Table",source,Objects)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)