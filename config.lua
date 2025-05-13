Config = {}

-- Target Type: "ox_target", "qtarget", or "3dtext"
Config.UseTarget = "ox_target"

-- Time required to rob in seconds
Config.RobberyTime = 60

-- Cooldown for a store in seconds
Config.CooldownTime = 300

-- Minimum number of police required
Config.MinCops = 2

-- Rewards (item name or money)
Config.Reward = {
    type = "money", -- "item" or "money"
    min = 200,
    max = 500
}

-- Store Locations
Config.Stores = {
    {
        name = "24/7 Supermarket",
        coords = vector3(372.58, 326.39, 103.56),
        npc = vector4(372.58, 326.39, 103.56, 250.0)
    },
    {
        name = "Liquor Store",
        coords = vector3(-1221.91, -908.29, 12.33),
        npc = vector4(-1221.91, -908.29, 12.33, 35.0)
    },
    {
        name = "Sandy 24/7",
        coords = vector3(1960.13, 3741.43, 32.34),
        npc = vector4(1960.13, 3741.43, 32.34, 300.0)
    },
    -- Add more stores here
}
