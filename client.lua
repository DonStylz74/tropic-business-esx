ESX = exports["es_extended"]:getSharedObject()
local businesses = {}

local function isBusinessOwned(index)
    local Player = ESX.GetPlayerData()
    return businesses[index] and businesses[index].owner == Player.identifier
end

CreateThread(function()
    for i, business in ipairs(Config.Businesses) do
        local pedModel = business.PedModel
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(100)
        end
        local ped = CreatePed(4, pedModel, business.PedCoords.x, business.PedCoords.y, business.PedCoords.z, business.PedCoords.w, false, true)
        SetEntityAsMissionEntity(ped, true, true)
        SetPedFleeAttributes(ped, 0, 0)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)

        local buyLabel = "Buy Business ($" .. business.BusinessPrice .. ")"
        local sellLabel = "Sell Business ($" .. (business.BusinessPrice * (business.SellBackPercentage / 100)) .. ")"

        if Config.Target == "ox" then
            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'business:buy',
                    event = 'business:buy',
                    icon = 'fas fa-shopping-cart',
                    label = buyLabel,
                    args = { index = i },
                    distance = 2.5,
                    onSelect = function()
                        TriggerServerEvent('business:buyBusiness', i)
                    end
                },
                {
                    event = "business:sell",
                    icon = "fas fa-dollar-sign",
                    label = sellLabel,
                    args = { index = i },
                    distance = 2.5,
                    onSelect = function()
                        TriggerServerEvent('business:sellBusiness', i)
                    end
                }
            })      
        else
            print("Invalid target system specified in config.")
        end

        if business.EnableBlip then
            local blip = AddBlipForCoord(business.BlipCoords.x, business.BlipCoords.y, business.BlipCoords.z)
            SetBlipSprite(blip, business.BlipSprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.5)
            SetBlipColour(blip, business.BlipColor)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(business.BlipName)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

RegisterNetEvent('business:setBusinesses', function(data)
    businesses = data
end)

RegisterNetEvent('esx:playerLoaded', function()
    TriggerServerEvent('business:requestBusinesses')
end)