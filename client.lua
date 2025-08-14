-- client.lua for pvp_pack
local inArena = false
local currentArena = nil
local gunfightPed = nil
local hud = {kills = 0, deaths = 0}
local isDead = false

Citizen.CreateThread(function()
    -- spawn the gunfight ped at spawn point
    local model = GetHashKey(Config.PedModel)
    RequestModel(model)
    local t = GetGameTimer()
    while not HasModelLoaded(model) and (GetGameTimer()-t) < 5000 do Citizen.Wait(10) end
    gunfightPed = CreatePed(4, model, Config.SpawnPoint.x, Config.SpawnPoint.y, Config.SpawnPoint.z, Config.SpawnHeading, false, true)
    FreezeEntityPosition(gunfightPed, true)
    SetEntityInvincible(gunfightPed, true)
    SetBlockingOfNonTemporaryEvents(gunfightPed, true)
    -- main loop for interaction
    while true do
        Citizen.Wait(0)
        local p = PlayerPedId()
        local pcoords = GetEntityCoords(p)
        local d = #(pcoords - Config.SpawnPoint)
        if d < 50.0 then
            DrawMarker(1, Config.SpawnPoint.x, Config.SpawnPoint.y, Config.SpawnPoint.z - 1.0, 0,0,0, 0,0,0, 1.0,1.0,0.2, 50,200,255, 100, false, true, 2, false, nil, nil, false)
            if d < Config.InteractDistance then
                SetTextComponentFormat('STRING')
                AddTextComponentString('Appuyez sur ~INPUT_CONTEXT~ pour rejoindre une arène PvP')
                DisplayHelpTextFromStringLabel(0,0,1,-1)
                if IsControlJustReleased(0, 38) then
                    -- Ouvrir l'interface moderne
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        type = "openArenaMenu"
                    })
                end
            end
        end

        -- show simple HUD when in arena
        if inArena then
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            SetTextScale(0.4, 0.4)
            SetTextFont(4)
            SetTextProportional(1)
            SetTextColour(255,255,255,255)
            SetTextEntry("STRING")
            AddTextComponentString(("PvP - Kills: %d  Deaths: %d"):format(hud.kills, hud.deaths))
            DrawText(0.02, 0.02)
        end
    end
end)

-- Callbacks NUI
RegisterNUICallback('selectArena', function(data, cb)
    local arenaId = data.arena
    SetNuiFocus(false, false)
    TriggerServerEvent('pvp:joinArena', arenaId)
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNetEvent('pvp:forceJoinClient')
AddEventHandler('pvp:forceJoinClient', function(arenaIndex, arenaData)
    local a = arenaData
    inArena = true
    currentArena = arenaIndex
    hud.kills = 0
    hud.deaths = 0

    DoScreenFadeOut(200)
    Citizen.Wait(250)
    SetEntityCoords(PlayerPedId(), a.coord.x, a.coord.y, a.coord.z, false, false, false, true)
    SetEntityHeading(PlayerPedId(), a.heading or 0.0)
    Citizen.Wait(200)
    DoScreenFadeIn(200)

    -- give weapon
    GiveWeaponToPed(PlayerPedId(), GetHashKey(Config.GunWeapon), 250, false, true)
    SetPedAmmo(PlayerPedId(), GetHashKey(Config.GunWeapon), 250)
    TriggerServerEvent('pvp:playerEnteredArena', arenaIndex)
end)

-- death detection
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        local ped = PlayerPedId()
        if not isDead and IsEntityDead(ped) then
            isDead = true
            -- attempt to get killer player id
            local killer = GetPedSourceOfDeath(ped)
            local killerServerId = nil
            if killer and killer ~= 0 then
                local killerPlayer = NetworkGetPlayerIndexFromPed(killer)
                if killerPlayer and killerPlayer ~= -1 then
                    killerServerId = GetPlayerServerId(killerPlayer)
                end
            end
            TriggerServerEvent('pvp:playerDied', killerServerId, currentArena)
            -- wait until respawn handled by server
        elseif isDead and not IsEntityDead(ped) then
            isDead = false
        end
    end
end)

-- when server tells to respawn in arena
RegisterNetEvent('pvp:respawnInArenaClient')
AddEventHandler('pvp:respawnInArenaClient', function(arenaIndex, arenaData)
    local a = arenaData
    Citizen.Wait(Config.RespawnDelay)
    isDead = false
    SetEntityCoords(PlayerPedId(), a.coord.x + math.random(-5,5), a.coord.y + math.random(-5,5), a.coord.z, false, false, false, true)
    SetEntityHeading(PlayerPedId(), a.heading or 0.0)
    GiveWeaponToPed(PlayerPedId(), GetHashKey(Config.GunWeapon), 250, false, true)
    SetPedAmmo(PlayerPedId(), GetHashKey(Config.GunWeapon), 250)
end)

-- update HUD from server
RegisterNetEvent('pvp:updateHud')
AddEventHandler('pvp:updateHud', function(kills, deaths)
    hud.kills = kills
    hud.deaths = deaths
end)
