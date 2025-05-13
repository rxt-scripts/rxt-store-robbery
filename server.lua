local activeRobberies = {}
local storeCooldowns = {}

RegisterServerEvent("rxt:attemptRobbery")
AddEventHandler("rxt:attemptRobbery", function(storeIndex)
    local src = source
    local store = Config.Stores[storeIndex]

    if storeCooldowns[storeIndex] and os.time() < storeCooldowns[storeIndex] then
        Utils.Notify(src, "This store was recently robbed. Try later.", "error")
        return
    end

    if Utils.GetCops() < Config.MinCops then
        Utils.Notify(src, "Not enough police on duty.", "error")
        return
    end

    activeRobberies[src] = {
        store = storeIndex,
        started = os.time()
    }

    -- Notify police
    TriggerClientEvent("rxt:alertCops", -1, store.coords, store.name)

    -- Start robbery on client
    TriggerClientEvent("rxt:startRobbery", src, Config.RobberyTime)

    Utils.Notify(src, "You started robbing " .. store.name .. "!", "success")
end)

RegisterServerEvent("rxt:finishRobbery")
AddEventHandler("rxt:finishRobbery", function()
    local src = source
    local data = activeRobberies[src]
    if not data then return end

    -- Set cooldown
    storeCooldowns[data.store] = os.time() + Config.CooldownTime

    -- Give reward
    local reward = math.random(Config.Reward.min, Config.Reward.max)

    if Config.Reward.type == "money" then
        if Utils.framework == 'esx' then
            local xPlayer = Utils.ESX.GetPlayerFromId(src)
            xPlayer.addAccountMoney("black_money", reward)
        elseif Utils.framework == 'qb' then
            local Player = Utils.QBCore.Functions.GetPlayer(src)
            Player.Functions.AddMoney("cash", reward)
        end
    end

    Utils.Notify(src, "You got away with $" .. reward, "success")
    activeRobberies[src] = nil
end)

RegisterServerEvent("rxt:cancelRobbery")
AddEventHandler("rxt:cancelRobbery", function()
    local src = source
    activeRobberies[src] = nil
    Utils.Notify(src, "You left the robbery zone!", "error")
end)
