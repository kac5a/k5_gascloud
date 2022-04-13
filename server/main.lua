ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for k, v in pairs(Config.Masks) do
  ESX.RegisterUsableItem(k, function(source)
    TriggerClientEvent('k5_gasring:useMask', source, k)
  end)
end

RegisterServerEvent('k5_gasring:removeMask')
AddEventHandler('k5_gasring:removeMask', function(mask)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  xPlayer.removeInventoryItem(mask, 1)
end)