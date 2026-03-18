------------------------------------------NATION FUNCTION--------------------------------------
vKEYBOARD = Tunnel.getInterface("keyboard")

rEVOLT.getUserSource             = rEVOLT.Source
rEVOLT.Passport                 = rEVOLT.Passport
rEVOLT.prepare                   = rEVOLT._Prepare
rEVOLT.Passportentity           = rEVOLT.Identity
rEVOLT.userInventory             = rEVOLT.Inventory
rEVOLT.getWeight                 = rEVOLT.GetWeight
rEVOLT.setWeight                 = rEVOLT.SetWeight
rEVOLT.userIdentity              = rEVOLT.Identity
rEVOLT.registerDrivers           = rEVOLT.Drivers
rEVOLT.query                     = rEVOLT.Query
rEVOLT.execute                   = rEVOLT.Query
rEVOLT.Execute                   = rEVOLT.Query
rEVOLT.checkBroken               = rEVOLT.CheckDamaged
rEVOLT.userPlate                 = rEVOLT.PassportPlate
rEVOLT.getIdentities             = rEVOLT.Identities
rEVOLT.characterChosen           = rEVOLT.CharacterChosen
rEVOLT.infoAccount               = rEVOLT.Account
rEVOLT.insertReputation          = rEVOLT.PutExperience
rEVOLT.checkReputation           = rEVOLT.GetExperience
rEVOLT.nearVehicle               = rEVOLT.ClosestVehicle
rEVOLT.userPremium               = rEVOLT.UserPremium
rEVOLT.steamPremium              = rEVOLT.LicensePremium
rEVOLT.userList                  = rEVOLT.Players
rEVOLT.tryChest                  = rEVOLT.TakeChest
rEVOLT.removeInventoryItem       = rEVOLT.RemoveItem
rEVOLT.falseIdentity             = rEVOLT.FalseIdentity
rEVOLT.giveInventoryItem         = rEVOLT.GiveItem
rEVOLT.checkMaxItens             = rEVOLT.MaxItens
rEVOLT.tryGetInventoryItem       = rEVOLT.TakeItem
rEVOLT.generatePlate             = rEVOLT.GeneratePlate
rEVOLT.numPermission             = rEVOLT.NumPermission
rEVOLT.getInventoryItemAmount    = rEVOLT.InventoryItemAmount
rEVOLT.getHealth                 = rEVOLT.GetHealth
rEVOLT.paymentFull               = rEVOLT.PaymentFull
rEVOLT.upgradeHunger             = rEVOLT.UpgradeHunger
rEVOLT.upgradeThirst             = rEVOLT.UpgradeThirst
rEVOLT.upgradeStress             = rEVOLT.UpgradeStress
rEVOLT.downgradeThirst           = rEVOLT.DowngradeThirst
rEVOLT.downgradeHunger           = rEVOLT.DowngradeHunger
rEVOLT.downgradeStress           = rEVOLT.DowngradeStress
rEVOLT.modelPlayer               = rEVOLT.ModelPlayer
rEVOLT.addBank                   = rEVOLT.GiveBank
rEVOLT.delBank                   = rEVOLT.RemoveBank
rEVOLT.getBank                   = rEVOLT.GetBank
rEVOLT.UpdateChest               = rEVOLT.Update
rEVOLT.checkBanned               = rEVOLT.Banned
rEVOLT.userData                  = rEVOLT.UserData
rEVOLT.getUData                  = rEVOLT.UserData
rEVOLT.updateHomePosition        = rEVOLT.InsidePropertys
rEVOLT.getDatatable              = rEVOLT.Datatable
rEVOLT.consultItem               = rEVOLT.ConsultItem
rEVOLT.getFines                  = rEVOLT.GetFine
rEVOLT.addFines                  = rEVOLT.GiveFine
rEVOLT.delFines                  = rEVOLT.RemoveFine
rEVOLT.generateStringNumber      = rEVOLT.GenerateString
rEVOLT.UserSource                = rEVOLT.Source
rEVOLT.userSource                = rEVOLT.Source
rEVOLT.getInfos                  = rEVOLT.infoAccount
rEVOLT.getUserDataTable          = rEVOLT.Datatable
rEVOLT.HasGroup             = rEVOLT.HasGroup


------------------------------------------------------------------------------------------------

function rEVOLT.setUData(user_id, key, value)
    rEVOLT.Query("playerdata/SetData",{ Passport = parseInt(user_id), dkey = key, dvalue = value })
end

rEVOLT.playerDropped             = playerDropped

function rEVOLT.format(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

exports("getrEVOLT", function() return rEVOLT end)

------------------------------------------------------------------------------------------------
---NATION SELLDRUGS
rEVOLT.prompt = function (...)
    local r = vKEYBOARD.keyArea(...)
    return r and r[1]
end
------------------------------------------------------------------------------------------------
rEVOLT.prompt =  rEVOLT.Prompt


