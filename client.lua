local robbing = false
local robberyTimer = 0
local targetZone = {}

CreateThread(function()
    Wait(500)

    for k, store in pairs(Config.Stores) do
        -- Spawn NPC
        RequestModel("mp_m_shopkeep_01")
        while not HasModelLoaded("mp_m_shopkeep_01") do Wait(0) end
        local ped = CreatePed(4, "mp_m_shopkeep_01", store.npc.x, store.npc.y, store.npc.z - 1.0, store.npc.w, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        -- Target system
        if Config.UseTarget == "ox_target" then
            exports.ox_target:addBoxZone({
                coords = store.coords,
                size = vec3(1.5, 1.5, 2.0),
                rotation = 0,
                debug = false,
                options = {
                    {
                        name = "rob_" .. k,
                        label = "Rob Store",
                        icon = "fa-solid fa-mask",
                        onSelect = function()
                            if not robbing then
                                TriggerServerEvent("rxt:attemptRobbery", k)
                            end
                        end
                    }
                }
            })
        else
            -- 3D Text Fallback
            CreateThread(function()
                while true do
                    Wait(0)
                    local player = PlayerPedId()
                    local dist = #(GetEntityCoords(player) - store.coords)
                    if dist < 2.0 then
                        DrawText3D(store.coords, "[E] Rob Store")
                        if IsControlJustReleased(0, 38) and not robbing then
                            TriggerServerEvent("rxt:attemptRobbery", k)
                        end
                    end
                end
            end)
        end
    end
end)

RegisterNetEvent("rxt:startRobbery", function(duration)
    robbing = true
    robberyTimer = duration

    -- Timer countdown
    CreateThread(function()
        while robbing and robberyTimer > 0 do
            Wait(1000)
            robberyTimer -= 1
        end

        if robbing and robberyTimer <= 0 then
            TriggerServerEvent("rxt:finishRobbery")
            robbing = false
        end
    end)

    -- Area check
    CreateThread(function()
        local player = PlayerPedId()
        local startPos = GetEntityCoords(player)
        while robbing do
            Wait(1000)
            local pos = GetEntityCoords(player)
            if #(pos - startPos) > 10.0 then
                robbing = false
                TriggerServerEvent("rxt:cancelRobbery")
                break
            end
        end
    end)
end)

RegisterNetEvent("rxt:alertCops", function(coords, label)
    if IsPlayerJobPolice() then
        PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        SetNewWaypoint(coords.x, coords.y)
        lib.notify({
            title = "Robbery in Progress",
            description = label .. " is being robbed!",
            type = "error"
        })

        local blip = AddBlipForCoord(coords)
        SetBlipSprite(blip, 161)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Robbery: " .. label)
        EndTextCommandSetBlipName(blip)
        Wait(30 * 1000)
        RemoveBlip(blip)
    end
end)

-- Job check
function IsPlayerJobPolice()
    local job = "none"

    if GetResourceState('es_extended') == 'started' then
        TriggerEvent('esx:getSharedObject', function(obj)
            job = obj.GetPlayerData().job.name
        end)
    elseif GetResourceState('qb-core') == 'started' then
        local QBCore = exports['qb-core']:GetCoreObject()
        job = QBCore.Functions.GetPlayerData().job.name
    end

    return job == "police"
end

-- 3D Text
function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
