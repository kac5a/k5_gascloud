ESX = nil

local safeZoneCoords2d = vector2(Config.SafeZone.center[1], Config.SafeZone.center[2])
local isInRing = false
local distance = 0
local hasMask = false
local maskCapacity = 0
local currentMask = nil
local cloudStrength = 0.0
local originalMask = {}
local safeZoneSize = Config.SafeZone.size * 2 * 0.9905

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

-- Blip creation
Citizen.CreateThread(function()
    local blip = AddBlipForRadius(Config.SafeZone.center, Config.SafeZone.size)
	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, Config.SafeZone.blipColor)
	SetBlipAlpha (blip, 255)
    SetRadiusBlipEdge(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Locale.safeZoneBlipName)
    EndTextCommandSetBlipName(blip)
end)

-- Determinate if the player is in the area
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local playerCoords2d = vector2(playerCoords[1], playerCoords[2])
        distance = #(playerCoords2d - safeZoneCoords2d)

        if distance > Config.SafeZone.size and GetEntityHealth(PlayerPedId()) > 0 then
            isInRing = true
        else
            isInRing = false
        end

        Citizen.Wait(1000)
    end
end)

-- Remove player health or mask capacity periodically
Citizen.CreateThread(function()
    while true do
        if GetEntityHealth(PlayerPedId()) > 0 and isInRing then
            if hasMask and maskCapacity > 0 then
                maskCapacity = maskCapacity - 1
                SendNUIMessage({
                    action = "refresh",
                    data = GetCapacityPercent()
                })
            else
                SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) - Config.Gas.damage)
            end
        end
        Citizen.Wait(Config.Gas.tick)
    end
end)

-- Cloud effect fade
Citizen.CreateThread(function()
    SetTimecycleModifierStrength(cloudStrength)
    while true do
        local sleep = 1000

        if cloudStrength > 0 then
            SetTimecycleModifier(Config.Gas.effect)
        else
            SetTimecycleModifier("")
        end

        if isInRing and cloudStrength < 1.0 then 
            sleep = 1
            cloudStrength = cloudStrength + 0.003
            SetTimecycleModifierStrength(cloudStrength)
        elseif not isInRing and cloudStrength > 0 then
            sleep = 1
            cloudStrength = cloudStrength - 0.003
            SetTimecycleModifierStrength(cloudStrength)
        else
            sleep = 1000
        end

        Citizen.Wait(sleep)
    end
end)

-- Mask remove keypress check
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if hasMask then
            sleep = 1
            if IsControlJustReleased(0, 244) then
                RemoveMask()
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- Gas marker
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if Config.AlwaysShowCloud then
            sleep = 1
            DrawMarker(1, Config.SafeZone.center, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, safeZoneSize, safeZoneSize, 600.0, Config.SafeZone.markerColor['r'], Config.SafeZone.markerColor['g'], Config.SafeZone.markerColor['b'], Config.SafeZone.markerColor['a'], false, true, 2, false, nil, nil, false)
        else
            if (Config.SafeZone.size - distance) < Config.ShowCloudDistance then
                sleep = 1
                DrawMarker(1, Config.SafeZone.center, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, safeZoneSize, safeZoneSize, 600.0, Config.SafeZone.markerColor['r'], Config.SafeZone.markerColor['g'], Config.SafeZone.markerColor['b'], Config.SafeZone.markerColor['a'], false, true, 2, false, nil, nil, false)
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("k5_gasring:useMask")
AddEventHandler("k5_gasring:useMask", function(mask)
    if not hasMask then
        ESX.Streaming.RequestAnimDict("mp_masks@standard_car@ds@", function()
			TaskPlayAnim(PlayerPedId(), "mp_masks@standard_car@ds@", "put_on_mask", 5.0, -5.0, 800, 51, 0, false, false, false)
		end)
        Citizen.Wait(800)

        hasMask = true
        currentMask = mask
        maskCapacity = Config.Masks[currentMask].capacity
        originalMask = {
            drawable = GetPedDrawableVariation(PlayerPedId(), 1),
            texture = GetPedTextureVariation(PlayerPedId(), 1),
        }

        SendNUIMessage({
            action = "open",
            data = {
                percent = GetCapacityPercent(),
                text = Locale.removeHelperText
            }
        })

        local model = GetEntityModel(PlayerPedId())
        local maskId = ""

        if model == `mp_m_freemode_01` then
            maskId = Config.Masks[currentMask].componentId_male
        else
            maskId = Config.Masks[currentMask].componentId_female
        end
        TriggerServerEvent('k5_gasring:removeMask', currentMask)
        SetPedComponentVariation(PlayerPedId(), 1, maskId, 0, 0)
    else
        ESX.ShowNotification(Locale.alreadyWearMask)
    end
end)

function RemoveMask()
    Citizen.CreateThread(function() 
        ESX.Streaming.RequestAnimDict("mp_masks@standard_car@ds@", function()
            TaskPlayAnim(PlayerPedId(), "mp_masks@standard_car@ds@", "put_on_mask", 5.0, -5.0, 800, 51, 0, false, false, false)
        end)
        Citizen.Wait(800)
        SendNUIMessage({
            action = "close"
        })
        ESX.ShowNotification(Locale.removeMaskNotification)
        hasMask = false
        maskCapacity = 0
        SetPedComponentVariation(PlayerPedId(), 1, originalMask.drawable, originalMask.texture, 0)
    end)
end

function GetCapacityPercent()
    return (maskCapacity / Config.Masks[currentMask].capacity) * 100
end