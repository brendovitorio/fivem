-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("characters/GetCharacters","SELECT * FROM characters WHERE id = @id")
rEVOLT._Prepare("characters/GetCard","SELECT * FROM characters WHERE id = @id AND card = @card")
rEVOLT._Prepare("characters/InsertCard","INSERT INTO characters(id,card) VALUES(@id,@card)")
rEVOLT._Prepare("characters/Person","SELECT * FROM characters WHERE id = @id")
rEVOLT._Prepare("characters/getPhone","SELECT id FROM characters WHERE phone = @phone")
rEVOLT._Prepare("characters/updatePhone","UPDATE characters SET phone = @phone WHERE id = @id")
rEVOLT._Prepare("characters/removeCharacter","UPDATE characters SET deleted = 1 WHERE id = @id")
rEVOLT._Prepare("accounts/updateWhitelist","UPDATE accounts SET whitelist = @whitelist WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("rEVOLT/GetRelac","SELECT * FROM casados WHERE  id = @id")
rEVOLT._Prepare("rEVOLT/SetRelac", "UPDATE casados SET casados = @casados WHERE id = @id")
rEVOLT._Prepare("rEVOLT/Divorcio","DELETE FROM casados WHERE id = @id")
rEVOLT._Prepare("rEVOLT/InsertRelac","INSERT INTO casados(id,membro1,membro2,casados) VALUES(@id,@membro1,@membro2,@casados)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("characters/addBank","UPDATE characters SET bank = bank + @amount WHERE id = @Passport")
rEVOLT._Prepare("characters/remBank","UPDATE characters SET bank = bank - @amount WHERE id = @Passport")
rEVOLT._Prepare("characters/UserLicense","SELECT * FROM characters WHERE id = @id and license = @license")
rEVOLT._Prepare("characters/Characters","SELECT * FROM characters WHERE license = @license and deleted = 0")
rEVOLT._Prepare("characters/updateName","UPDATE characters SET name = @name, name2 = @name2 WHERE id = @Passport")
rEVOLT._Prepare("characters/Tracking","UPDATE characters SET tracking = tracking + @tracking WHERE id = @Passport")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREDITCARD
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("characters/UpgradeSpending","UPDATE characters SET spending = spending + @spending WHERE id = @Passport")
rEVOLT._Prepare("characters/DowngradeSpending","UPDATE characters SET spending = spending - @spending WHERE id = @Passport")
rEVOLT._Prepare("characters/UpgradeCardlimit","UPDATE characters SET cardlimit = cardlimit + @cardlimit WHERE id = @Passport")
rEVOLT._Prepare("characters/DowngradeCardlimit","UPDATE characters SET cardlimit = cardlimit - @cardlimit WHERE id = @Passport")
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("characters/lastCharacters","SELECT id FROM characters WHERE license = @license ORDER BY id DESC LIMIT 1")
rEVOLT._Prepare("characters/countPersons","SELECT COUNT(license) as qtd FROM characters WHERE license = @license and deleted = 0")
rEVOLT._Prepare("characters/newCharacter","INSERT INTO characters(license,name,name2,sex,phone,blood,created, time) VALUES(@license,@name,@name2,@sex,@phone,@blood,UNIX_TIMESTAMP() + 259200, @time)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNTS
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("accounts/Account","SELECT * FROM accounts WHERE license = @license")
rEVOLT._Prepare("accounts/newAccount","INSERT INTO accounts(license) VALUES(@license)")
rEVOLT._Prepare("accounts/AddGems","UPDATE accounts SET gems = gems + @gems WHERE license = @license")
rEVOLT._Prepare("accounts/addPriority","UPDATE accounts SET priority = priority + @priority WHERE license = @license")
rEVOLT._Prepare("accounts/remPriority","UPDATE accounts SET priority = priority - @priority WHERE license = @license")
rEVOLT._Prepare("accounts/RemoveGems","UPDATE accounts SET gems = gems - @gems WHERE license = @license")
rEVOLT._Prepare("accounts/infosUpdatechars","UPDATE accounts SET chars = chars + 1 WHERE license = @license")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("playerdata/GetData","SELECT * FROM playerdata WHERE Passport = @Passport AND dkey = @dkey")
rEVOLT._Prepare("playerdata/SetData","REPLACE INTO playerdata(Passport,dkey,dvalue) VALUES(@Passport,@dkey,@dvalue)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITYDATA
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("entitydata/SetDatas","REPLACE INTO entitydata(dkey,dvalue) VALUES(@dkey,@dvalue)")
rEVOLT._Prepare("entitydata/GetDatas","SELECT * FROM entitydata WHERE dkey = @dkey")
rEVOLT._Prepare("entitydata/GetData","SELECT * FROM entitydata WHERE dkey = @dkey")
rEVOLT._Prepare("entitydata/RemoveData","DELETE FROM entitydata WHERE dkey = @dkey")
rEVOLT._Prepare("entitydata/SetData","REPLACE INTO entitydata(dkey,dvalue) VALUES(@dkey,@dvalue)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAINEL
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("chests/DowngradeChests","UPDATE chests SET weight = weight / 2 WHERE name = @Name")
rEVOLT._Prepare("chests/UpgradeChests2","UPDATE chests SET weight = weight + weight WHERE name = @Name")
rEVOLT._Prepare("painel/GetInformations","SELECT * FROM organizations WHERE name = @Name")
rEVOLT._Prepare("painel/UpdateBuff","UPDATE organizations SET buff = @Buff WHERE name = @Name")
rEVOLT._Prepare("painel/DowngradeBank","UPDATE organizations SET bank = bank - @Value WHERE name = @Name")
rEVOLT._Prepare("painel/UpgradeBank","UPDATE organizations SET bank = bank + @Value WHERE name = @Name")
rEVOLT._Prepare("painel/GetTransactions","SELECT * FROM org_transactions WHERE name = @Name ORDER BY id DESC LIMIT 12")
rEVOLT._Prepare("painel/InsertTransaction","INSERT INTO org_transactions (`name`, `Type`, `Value`) VALUES (@Name, @Type, @Value)")
rEVOLT._Prepare("painel/UpdateBuff","UPDATE organizations SET buff = @Buff WHERE name = @Name")
rEVOLT._Prepare("painel/SetPremium","UPDATE organizations SET premium = @Seconds WHERE name = @Name")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("vehicles/plateVehicles","SELECT * FROM vehicles WHERE plate = @plate")
rEVOLT._Prepare("vehicles/UserVehicles","SELECT * FROM vehicles WHERE Passport = @Passport")
rEVOLT._Prepare("vehicles/removeVehicles","DELETE FROM vehicles WHERE Passport = @Passport AND vehicle = @vehicle")
rEVOLT._Prepare("vehicles/selectVehicles","SELECT * FROM vehicles WHERE Passport = @Passport AND vehicle = @vehicle")
rEVOLT._Prepare("vehicles/paymentArrest","UPDATE vehicles SET arrest = 0 WHERE Passport = @Passport AND vehicle = @vehicle")
rEVOLT._Prepare("vehicles/moveVehicles","UPDATE vehicles SET Passport = @OtherPassport WHERE Passport = @Passport AND vehicle = @vehicle")
rEVOLT._Prepare("vehicles/plateVehiclesUpdate","UPDATE vehicles SET plate = @plate WHERE Passport = @Passport AND vehicle = @vehicle")
rEVOLT._Prepare("vehicles/rentalVehiclesDays","UPDATE vehicles SET rental = rental + 2592000 WHERE Passport = @Passport AND vehicle = @vehicle")
rEVOLT._Prepare("vehicles/arrestVehicles","UPDATE vehicles SET arrest = UNIX_TIMESTAMP() + 2592000 WHERE Passport = @Passport AND vehicle = @vehicle")
rEVOLT._Prepare("vehicles/updateVehiclesTax","UPDATE vehicles SET tax = UNIX_TIMESTAMP() + 2592000 WHERE Passport = @Passport AND vehicle = @vehicle")
rEVOLT._Prepare("vehicles/rentalVehiclesUpdate","UPDATE vehicles SET rental = UNIX_TIMESTAMP() + 2592000 WHERE Passport = @Passport AND vehicle = @vehicle")
rEVOLT._Prepare("vehicles/addVehicles","INSERT IGNORE INTO vehicles(Passport,vehicle,plate,work,tax) VALUES(@Passport,@vehicle,@plate,@work,UNIX_TIMESTAMP() + 604800)")
rEVOLT._Prepare("vehicles/rentalVehicles","INSERT IGNORE INTO vehicles(Passport,vehicle,plate,work,rental,tax) VALUES(@Passport,@vehicle,@plate,@work,UNIX_TIMESTAMP() + 2592000,UNIX_TIMESTAMP() + 604800)")
rEVOLT._Prepare("vehicles/updateVehicles","UPDATE vehicles SET engine = @engine, body = @body, health = @health, fuel = @fuel, doors = @doors, windows = @windows, tyres = @tyres, nitro = @nitro WHERE Passport = @Passport AND vehicle = @vehicle")
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANNEDS
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("banneds/GetBanned","SELECT * FROM banneds WHERE license = @license")
rEVOLT._Prepare("banneds/RemoveBanned","DELETE FROM banneds WHERE license = @license")
rEVOLT._Prepare("banneds/InsertBanned","INSERT INTO banneds(license,time) VALUES(@license,UNIX_TIMESTAMP() + 86400 * @time)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTS
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("chests/GetChests","SELECT * FROM chests WHERE Name = @Name")
rEVOLT._Prepare("chests/AddChests","INSERT IGNORE INTO chests(Name,Permission) VALUES(@Name,@Name)")
rEVOLT._Prepare("chests/UpdateWeight","UPDATE chests SET Weight = Weight + (10 * @Multiplier), Slots = Slots + (5 * @Multiplier) WHERE Name = @Name")
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("races/Result","SELECT * FROM races WHERE Race = @Race AND Passport = @Passport")
rEVOLT._Prepare("races/Ranking","SELECT * FROM races WHERE Race = @Race ORDER BY Points ASC LIMIT 5")
rEVOLT._Prepare("races/TopFive","SELECT * FROM races WHERE Race = @Race ORDER BY Points ASC LIMIT 1 OFFSET 4")
rEVOLT._Prepare("races/Records","UPDATE races SET Points = @Points, Vehicle = @Vehicle WHERE Race = @Race AND Passport = @Passport")
rEVOLT._Prepare("races/Insert","INSERT INTO races(Race,Passport,Name,Vehicle,Points) VALUES(@Race,@Passport,@Name,@Vehicle,@Points)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINDENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("fidentity/Result","SELECT * FROM fidentity WHERE id = @id")
rEVOLT._Prepare("fidentity/GetIdentity","SELECT id FROM fidentity ORDER BY id DESC LIMIT 1")
rEVOLT._Prepare("fidentity/NewIdentity","INSERT INTO fidentity(name,name2,blood) VALUES(@name,@name2,@blood)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARTABLES
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("summerz/Playerdata","DELETE FROM playerdata WHERE dvalue = '[]' OR dvalue = '{}'")
rEVOLT._Prepare("summerz/Entitydata","DELETE FROM entitydata WHERE dvalue = '[]' OR dvalue = '{}'")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WAREHOUSE
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("warehouse/All","SELECT * FROM warehouse")
rEVOLT._Prepare("warehouse/Sell","DELETE FROM warehouse WHERE Number = @Number")
rEVOLT._Prepare("warehouse/Informations","SELECT * FROM warehouse WHERE Number = @Number")
rEVOLT._Prepare("warehouse/Password","UPDATE warehouse SET Password = @Password WHERE Number = @Number")
rEVOLT._Prepare("warehouse/Transfer","UPDATE warehouse SET Passport = @Passport WHERE Number = @Number")
rEVOLT._Prepare("warehouse/Acess","SELECT * FROM warehouse WHERE Number = @Number AND Password = @Password")
rEVOLT._Prepare("warehouse/Tax","UPDATE warehouse SET Tax = UNIX_TIMESTAMP() + 2592000 WHERE Number = @Number")
rEVOLT._Prepare("warehouse/Upgrade","UPDATE warehouse SET Weight = Weight + (10 * @Multiplier) WHERE Number = @Number")
rEVOLT._Prepare("warehouse/Buy","INSERT INTO warehouse(Number,Password,Passport,Tax) VALUES(@Number,@Password,@Passport,UNIX_TIMESTAMP() + 2592000)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("propertys/All","SELECT * FROM propertys")
rEVOLT._Prepare("propertys/Sell","DELETE FROM propertys WHERE Number = @Number")
rEVOLT._Prepare("propertys/Exist","SELECT * FROM propertys WHERE Number = @Number")
rEVOLT._Prepare("propertys/Key","SELECT * FROM propertys WHERE Keychain = @Key")
rEVOLT._Prepare("propertys/AllUser","SELECT * FROM propertys WHERE Passport = @Passport")
rEVOLT._Prepare("propertys/Interior","UPDATE propertys SET Interior = @Interior WHERE Number = @Number")
rEVOLT._Prepare("propertys/Credentials","UPDATE propertys SET Keychain = @Key WHERE Number = @Number")
rEVOLT._Prepare("propertys/Transfer","UPDATE propertys SET Passport = @Passport WHERE Number = @Number")
rEVOLT._Prepare("propertys/Check","SELECT * FROM propertys WHERE Number = @Number AND Passport = @Passport")
rEVOLT._Prepare("propertys/Tax","UPDATE propertys SET Tax = UNIX_TIMESTAMP() + 2592000 WHERE Number = @Number")
rEVOLT._Prepare("propertys/Buy","INSERT INTO propertys(Number,Passport,Interior,Keychain,Tax) VALUES(@Number,@Passport,@Interior,@Key,@Tax)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINES
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("fines/List","SELECT * FROM fines WHERE Passport = @Passport")
rEVOLT._Prepare("fines/Remove","DELETE FROM fines WHERE Passport = @Passport AND id = @id")
rEVOLT._Prepare("fines/Check","SELECT * FROM fines WHERE Passport = @Passport AND id = @id")
rEVOLT._Prepare("fines/Add","INSERT INTO fines(Passport,Name,Date,Hour,Value,Message) VALUES(@Passport,@Name,@Date,@Hour,@Value,@Message)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXS
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("taxs/List","SELECT * FROM taxs WHERE Passport = @Passport")
rEVOLT._Prepare("taxs/Remove","DELETE FROM taxs WHERE Passport = @Passport AND id = @id")
rEVOLT._Prepare("taxs/Check","SELECT * FROM taxs WHERE Passport = @Passport AND id = @id")
rEVOLT._Prepare("taxs/Add","INSERT INTO taxs(Passport,Name,Date,Hour,Value,Message) VALUES(@Passport,@Name,@Date,@Hour,@Value,@Message)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("transactions/List","SELECT * FROM transactions WHERE Passport = @Passport ORDER BY id DESC LIMIT @Limit")
rEVOLT._Prepare("transactions/Add","INSERT INTO transactions(Passport,Type,Date,Value,Balance) VALUES(@Passport,@Type,@Date,@Value,@Balance)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPENDENTS
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("dependents/List","SELECT * FROM dependents WHERE Passport = @Passport")
rEVOLT._Prepare("dependents/Remove","DELETE FROM dependents WHERE Passport = @Passport AND Dependent = @Dependent")
rEVOLT._Prepare("dependents/Check","SELECT * FROM dependents WHERE Passport = @Passport AND Dependent = @Dependent")
rEVOLT._Prepare("dependents/Add","INSERT INTO dependents(Passport,Dependent,Name) VALUES(@Passport,@Dependent,@Name)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICES
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("invoices/Remove","DELETE FROM invoices WHERE id = @id")
rEVOLT._Prepare("invoices/Check","SELECT * FROM invoices WHERE id = @id")
rEVOLT._Prepare("invoices/List","SELECT * FROM invoices WHERE Passport = @Passport")
rEVOLT._Prepare("invoices/Add","INSERT INTO invoices(Passport,Received,Type,Reason,Holder,Value) VALUES(@Passport,@Received,@Type,@Reason,@Holder,@Value)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("investments/Remove","DELETE FROM investments WHERE Passport = @Passport")
rEVOLT._Prepare("investments/Check","SELECT * FROM investments WHERE Passport = @Passport")
rEVOLT._Prepare("investments/Add","INSERT INTO investments(Passport,Deposit,Last) VALUES(@Passport,@Deposit,UNIX_TIMESTAMP() + 86400)")
rEVOLT._Prepare("investments/Invest","UPDATE investments SET Deposit = Deposit + @Value, Last = UNIX_TIMESTAMP() + 86400 WHERE Passport = @Passport")
rEVOLT._Prepare("investments/Actives","UPDATE investments SET Monthly = Monthly + FLOOR((Deposit + Liquid) * 0.10), Liquid = Liquid + FLOOR((Deposit + Liquid) * 0.025), Last = UNIX_TIMESTAMP() + 86400 WHERE Last < UNIX_TIMESTAMP()")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINES
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("fines/CheckList","SELECT * FROM fines ")
rEVOLT._Prepare("fines/CheckLists","SELECT * FROM fines WHERE Passport = @Passport")
rEVOLT._Prepare("fines/RemoveList","DELETE FROM fines WHERE Passport = @Passport AND id = @id")
rEVOLT._Prepare("fines/Removes","DELETE FROM fines WHERE id = @id AND Passport = @Passport")
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------- Modifiers ----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("rEVOLT/set_userdata","REPLACE INTO playerdata(Passport,dkey,dvalue) VALUES(@Passport,@key,@value)")
rEVOLT._Prepare("rEVOLT/get_userdata","SELECT dvalue FROM playerdata WHERE Passport = @Passport AND dkey = @key")
-----------------------------------------------------------------------------------------------------------------------------------------
-- Prepare rEVOLT_SRV_DATA
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("rEVOLT/set_srvdata","REPLACE INTO entitydata(dkey,dvalue) VALUES(@key,@value)")
rEVOLT._Prepare("rEVOLT/get_srvdata","SELECT dvalue FROM entitydata WHERE dkey = @key")

-----------------------------------------------------------------------------------------------------------------------------------------
-- Prepare INVENTARIO
-----------------------------------------------------------------------------------------------------------------------------------------
rEVOLT._Prepare("rEVOLT/inv_deltmpchest", "DELETE FROM entitydata WHERE dkey LIKE 'tmpChest:%'")