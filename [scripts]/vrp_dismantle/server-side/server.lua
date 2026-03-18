-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy  = module("revolt","lib/Proxy")

rEVOLT       = Proxy.getInterface("rEVOLT")
Revoltclient = Tunnel.getInterface("Revolt")
RevoltC      = Tunnel.getInterface("Revolt")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
local cnREVOLT = {}
Tunnel.bindInterface("revolt_dismantle", cnREVOLT) -- coloque AQUI o nome do resource (o seu log mostra revolt_dismantle)
vCLIENT = Tunnel.getInterface("revolt_dismantle")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONVERSAO
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT.Passport               = rEVOLT.Passport
rEVOLT.prepare                 = rEVOLT._Prepare
rEVOLT.getInventoryItemAmount  = rEVOLT.InventoryItemAmount
rEVOLT.userPlate               = rEVOLT.PassportPlate
rEVOLT.query                   = rEVOLT.Query
rEVOLT.upgradeStress           = rEVOLT.UpgradeStress
rEVOLT.execute                 = rEVOLT.Query
rEVOLT.giveInventoryItem       = rEVOLT.GiveItem
rEVOLT.HasGroup           = rEVOLT.HasGroup

vehiclePrice = VehiclePrice
vehicleType  = VehicleMode

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT.prepare("desmanche/set","UPDATE vehicles SET dismantle = @dismantle WHERE Passport = @Passport AND vehicle = @vehicle")

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENSLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local itensList = {
  [1] = "plastic",
  [2] = "glass",
  [3] = "copper",
  [4] = "rubber",
  [5] = "aluminum"
}

-- local vehVips = {
-- 	['skyliner34'] = 150000,
-- 	['zx10r'] = 90000,
-- 	['tiger'] = 100000,
-- 	['i8'] = 100000,
-- 	['ferrariitalia'] = 100000,
-- 	['lamborghinihuracan'] = 100000,
-- 	['t20'] = 650000,
-- 	['laferrari15'] = 100000,
-- 	['tyrant'] = 100000,
-- 	['r1250'] = 100000,
-- 	['gtr'] = 100000,
-- 	['brioso'] = 100000,
-- 	['kanjo'] = 100000,
		
-- }

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cnREVOLT.checkItem()
  local source = source
  local user_id = rEVOLT.Passport(source)
  if not user_id then return false end

  local consultItem = rEVOLT.getInventoryItemAmount(user_id,"WEAPON_WRENCH")

  -- Se seu framework retorna número, isso aqui cobre os dois formatos (número ou tabela)
  local amount = consultItem
  if type(consultItem) == "table" then
    amount = consultItem[1] or consultItem.amount or 0
  end

  if (amount or 0) <= 0 then
    TriggerClientEvent("Notify",source,"amarelo","Necessário possuir <b>1x Chave Inglesa</b>.",5000)
    return false
  end

  return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cnREVOLT.checkVehicle()
  local source = source
  local vehicle, vehNet, vehPlate, vehName = RevoltC.VehicleList(source, 11)
  local vehInfos = rEVOLT.userPlate(vehPlate)

  if vehicle and vehInfos then
    local row = rEVOLT.Query("vehicles/selectVehicles",{ Passport = vehInfos["Passport"], vehicle = vehName })[1]
    if row and row["dismantle"] == 0 then
      return true, vehicle, vehName, vehiclePrice(vehName), vehInfos["Passport"], vehNet, vehPlate
    end
  end

  return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function cnREVOLT.paymentMethod(vehicle, vehPrice, vehName, nuser_id, vehNet, vehPlate)
  local source = source
  local user_id = rEVOLT.Passport(source)
  if not user_id then return end

  local price = vehiclePrice(vehName)

  for _, nsource in ipairs(rEVOLT.Players()) do
    async(function()
      TriggerClientEvent("inventory:repairAdmin", nsource, vehNet, vehPlate)
    end)
  end

  rEVOLT.upgradeStress(user_id,10)
  TriggerClientEvent("garages:Delete", source, vehicle)

  rEVOLT.giveInventoryItem(user_id,"dollarz", parseInt(price * 0.1), true)
  rEVOLT.giveInventoryItem(user_id, itensList[math.random(#itensList)], math.random(60,120), true)

  rEVOLT.execute("desmanche/set", { Passport = nuser_id, vehicle = vehName, dismantle = 1 })
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSAO
-----------------------------------------------------------------------------------------------------------------------------------------
function cnREVOLT.HasGroup(Permission)
  local source = source
  local user_id = rEVOLT.Passport(source)
  if not user_id then return false end
  return rEVOLT.HasGroup(user_id, Permission)
end
