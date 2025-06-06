ESX = exports["es_extended"]:getSharedObject()
local businesses = {}

local function loadBusinesses()
    local file = LoadResourceFile(GetCurrentResourceName(), 'businesses.json')
    if file then
        businesses = json.decode(file) or {}
    else
        businesses = {} 
    end
end

local function saveBusinesses()
    local jsonData = json.encode(businesses)
    SaveResourceFile(GetCurrentResourceName(), 'businesses.json', jsonData, -1)
end

local function initializeBusinesses()
    for index, business in ipairs(Config.Businesses) do
        if not businesses[index] then
            businesses[index] = { owner = nil, job = nil }
        end
    end
    saveBusinesses() 
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        loadBusinesses()
        initializeBusinesses() 
    end
end)

RegisterNetEvent('business:requestBusinesses', function()
    local src = source
    TriggerClientEvent('business:setBusinesses', src, businesses)
end)

RegisterNetEvent('business:buyBusiness', function(index)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local business = Config.Businesses[index]
    local money = xPlayer.getMoney()

    if Config.RequireBusinessLicense then
        local hasLicense = false

        if Config.Inventory == "ox" then
            local item = exports.ox_inventory:GetItem(src, 'business_license')
            hasLicense = item and item.count > 0
        end

        if not hasLicense then
            if Config.Notify == "esx" then
                TriggerClientEvent('esx:showNotification', src, "You need a business license to purchase this")
            elseif Config.Notify == "okok" then
                TriggerClientEvent('okokNotify:Alert', src, 'Error', 'You need a business license to purchase this', 1000, 'error', false)
            end
            return
        end
    end

    if businesses[index] and businesses[index].owner == xPlayer.identifier then
        if Config.Notify == "esx" then
            TriggerClientEvent('esx:showNotification', src, "You already own this business")
        elseif Config.Notify == "okok" then
            TriggerClientEvent('okokNotify:Alert', src, 'Error', 'You already own this business', 1000, 'error', false)
        end
        return
    end

    if money >= business.BusinessPrice then
        if Config.PayOption == "cash" then
            xPlayer.removeMoney(business.BusinessPrice)
            xPlayer.setJob(business.BusinessJob, business.BusinessGrade)
        elseif Config.PayOption == "bank" then
            xPlayer.removeAccountMoney('bank', business.BusinessPrice)
            xPlayer.setJob(business.BusinessJob, business.BusinessGrade)
        else
            print("Incorrect payment option selected")
            return 
        end

        businesses[index] = {
            owner = xPlayer.identifier,
            job = business.BusinessJob
        }

        saveBusinesses() 
        TriggerClientEvent('business:setBusinesses', -1, businesses)

        if Config.Notify == "esx" then
            TriggerClientEvent('esx:showNotification', src, "You have purchased the business and are now the owner of " .. business.BusinessJob)
        elseif Config.Notify == "okok" then
            TriggerClientEvent('okokNotify:Alert', src, 'Success', "You have purchased the business and are now the owner of " .. business.BusinessJob, 1000, 'success', false)
        end
    else
        if Config.Notify == "esx" then
            TriggerClientEvent('esx:showNotification', src, "You don't have enough money")
        elseif Config.Notify == "okok" then
            TriggerClientEvent('okokNotify:Alert', src, 'Error', "You don't have enough money", 1000, 'error', false)
        end
    end
end)

RegisterNetEvent('business:sellBusiness', function(index)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local business = Config.Businesses[index]

    if businesses[index] and businesses[index].owner == xPlayer.identifier then
        local refund = business.BusinessPrice * (business.SellBackPercentage / 100)
        if Config.PayOption == "cash" then
            xPlayer.addMoney(refund)
            xPlayer.setJob('unemployed', 0)
        elseif Config.PayOption == "bank" then
            xPlayer.addAccountMoney('bank', refund)
            xPlayer.setJob('unemployed', 0)
        else
            print("Incorrect payment option selected")
            return 
        end

        businesses[index] = { owner = nil, job = nil }
        saveBusinesses()
        TriggerClientEvent('business:setBusinesses', -1, businesses)

        if Config.Notify == "esx" then
            TriggerClientEvent('esx:showNotification', src, "You have sold the business and received $" .. refund)
        elseif Config.Notify == "okok" then
            TriggerClientEvent('okokNotify:Alert', src, 'Success', "You have sold the business and received $" .. refund, 1000, 'success', false)
        end
    else
        if Config.Notify == "esx" then
            TriggerClientEvent('esx:showNotification', src, "You don't own this business")
        elseif Config.Notify == "okok" then
            TriggerClientEvent('okokNotify:Alert', src, 'Error', "You don't own this business", 1000, 'error', false)
        end
    end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    for index, data in pairs(businesses) do
        if data.owner == xPlayer.identifier then
            xPlayer.setJob(data.job, Config.Businesses[index].BusinessGrade)
        end
    end
end)