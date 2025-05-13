Utils = {}

-- Detect framework
CreateThread(function()
    if GetResourceState('es_extended') == 'started' then
        Utils.framework = 'esx'
        TriggerEvent('esx:getSharedObject', function(obj) Utils.ESX = obj end)
    elseif GetResourceState('qb-core') == 'started' then
        Utils.framework = 'qb'
        Utils.QBCore = exports['qb-core']:GetCoreObject()
    else
        Utils.framework = 'none'
    end
end)

-- Notification
function Utils.Notify(src, msg, type)
    if Config.UseTarget == 'ox_target' then
        TriggerClientEvent('ox_lib:notify', src, { description = msg, type = type or 'inform' })
    else
        TriggerClientEvent('chat:addMessage', src, { args = { "^2[Robbery]", msg } })
    end
end

-- Get cop count
function Utils.GetCops()
    local cops = 0
    for _, playerId in pairs(GetPlayers()) do
        if Utils.framework == 'esx' then
            local xPlayer = Utils.ESX.GetPlayerFromId(tonumber(playerId))
            if xPlayer and xPlayer.job.name == 'police' then
                cops += 1
            end
        elseif Utils.framework == 'qb' then
            local player = Utils.QBCore.Functions.GetPlayer(tonumber(playerId))
            if player and player.PlayerData.job.name == 'police' then
                cops += 1
            end
        end
    end
    return cops
end
