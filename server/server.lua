local core = exports['qbx_core']
local keys = exports['qbx_vehiclekeys']
local Config = lib.require('shared.config')

RegisterNetEvent("trash:addmoney")
AddEventHandler("trash:addmoney", function(amount, reason)
	if not source then return end 
   	core:AddMoney(source, Config.Moneytype, amount, reason)
end)

lib.callback.register("trash:takemoney", function(source, amount, reason)
	local money = core:GetMoney(source, Config.Moneytype)
	if money < amount then 
		return false 
	else 
		return core:RemoveMoney(source, Config.Moneytype, amount, reason) 
	end
end)

RegisterNetEvent("trash:givekeys")
AddEventHandler("trash:givekeys", function(vehicle)
	if not vehicle then return end 
	local entity = NetworkGetEntityFromNetworkId(vehicle) 
	if not DoesEntityExist(entity) then return end
	keys:GiveKeys(source, entity, false)
end)
