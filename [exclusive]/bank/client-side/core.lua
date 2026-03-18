-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("bank")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
local BankPeds = {}

local function CreateBankPed(coords, model)
    local mHash = GetHashKey(model)
    RequestModel(mHash)
    while not HasModelLoaded(mHash) do
        Wait(10)
    end

    local ped = CreatePed(
        4,
        mHash,
        coords[1], coords[2], coords[3] - 1.0,
        coords[4] or 0.0,
        false,
        true
    )

    SetEntityAsMissionEntity(ped, true, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedCombatAttributes(ped, 46, true)
    SetPedCanRagdoll(ped, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    -- animação (igual a sua)
    RequestAnimDict("anim@heists@heist_corona@single_team")
    while not HasAnimDictLoaded("anim@heists@heist_corona@single_team") do
        Wait(10)
    end
    TaskPlayAnim(ped, "anim@heists@heist_corona@single_team", "single_team_loop_boss", 8.0, 0.0, -1, 1, 0, false, false, false)

    SetModelAsNoLongerNeeded(mHash)
    return ped
end

CreateThread(function()
    for Number, v in pairs(Locations) do
        local coords = { v[1], v[2], v[3], v[4] }

        local model
        if (math.random(2) % 2 ~= 0) then
            model = ("a_m_y_business_0%s"):format(math.random(4))
        else
            model = ("a_f_y_business_0%s"):format(math.random(3))
        end

        -- cria ped localmente (sem exports)
        BankPeds[Number] = CreateBankPed(coords, model)

        -- target igual ao seu
        exports["target"]:AddCircleZone("Bank:"..Number, vec3(v[1], v[2], v[3]), 0.5, {
            name = "Bank:"..Number,
            heading = 3374176
        }, {
            Distance = 1.75,
            options = {
                { event = "Bank",            label = "Abrir",            tunnel = "client" },
                { event = "Bank:DebitCard",  label = "Cartão De Débito",  tunnel = "server" },
                { event = "Bank:CreditCard", label = "Cartão De Credito", tunnel = "server" }
            }
        })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Bank",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		if MumbleIsConnected() then
			LocalPlayer['state']['Cancel'] = false
			LocalPlayer['state']['Commands'] = false
			FreezeEntityPosition(Ped, false)
		else
			LocalPlayer['state']['Cancel'] = true
			LocalPlayer['state']['Commands'] = true
			FreezeEntityPosition(Ped, true)
		end
		SetNuiFocus(true,true)
		SendNUIMessage({ Action = "Open", name = LocalPlayer["state"]["Name"] })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SetNuiFocus(false,false)
	SendNUIMessage({ Action = "Hide" })
	Callback(true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Home",function(Data,Callback)
	Callback(vSERVER.Home())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Deposit",function(Data,Callback)
	Callback(vSERVER.Deposit(Data["value"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Withdraw",function(Data,Callback)
	Callback(vSERVER.Withdraw(Data["value"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Transfer",function(Data,Callback)
	if Data["targetId"] and Data["value"] then
		Callback(vSERVER.Transfer(Data["targetId"],Data["value"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDDEPENDENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("AddDependents",function(Data,Callback)
	if Data["passport"] then
		Callback(vSERVER.AddDependents(Data["passport"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEDEPENDENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RemoveDependents",function(Data,Callback)
	Callback(vSERVER.RemoveDependents(Data["passport"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Investments",function(Data,Callback)
	Callback(vSERVER.Investments())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Invest",function(Data,Callback)
	if Data["value"] then
		Callback(vSERVER.Invest(Data["value"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTRESCUE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("InvestRescue",function(Data,Callback)
	vSERVER.InvestRescue()
	Callback(true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTIONHISTORY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("TransactionHistory",function(Data,Callback)
	Callback(vSERVER.TransactionHistory())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEINVOICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("MakeInvoice",function(Data,Callback)
	if Data["passport"] and Data["value"] and Data["reason"] then
		Callback(vSERVER.MakeInvoice(Data["passport"],Data["value"],Data["reason"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICEPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("InvoicePayment",function(Data,Callback)
	Callback(vSERVER.InvoicePayment(Data["id"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICELIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("InvoiceList",function(Data,Callback)
	Callback(vSERVER.InvoiceList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINELIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("FineList",function(Data,Callback)
	Callback(vSERVER.FineList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINEPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("FinePayment",function(Data,Callback)
	Callback(vSERVER.FinePayment(Data["id"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINEPAYMENTALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("FinePaymentAll",function(Data,Callback)
	Callback(vSERVER.FinePaymentAll())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Taxes",function(Data,Callback)
	Callback(vSERVER.TaxList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("TaxPayment",function(Data,Callback)
	Callback(vSERVER.TaxPayment(Data["id"]))
end)