-- server.lua for pvp_pack
local players = {}
local arenaPlayers = {}

-- helper to get arena data
local function getArena(index)
    return Config.Arenas[index]
end

RegisterNetEvent('pvp:joinArena')
AddEventHandler('pvp:joinArena', function(arenaIndex)
    local src = source
    local a = getArena(arenaIndex)
    if not a then return end
    players[src] = {arena = arenaIndex, kills = 0, deaths = 0}
    arenaPlayers[arenaIndex] = arenaPlayers[arenaIndex] or {}
    arenaPlayers[arenaIndex][src] = true
    -- tell client to teleport and give weapon
    TriggerClientEvent('pvp:forceJoinClient', src, arenaIndex, a)
    print(('Player %s joined PvP arena %s'):format(src, arenaIndex))
end)

RegisterNetEvent('pvp:playerEnteredArena')
AddEventHandler('pvp:playerEnteredArena', function(arenaIndex)
    local src = source
    -- ensure player tracked server-side
    players[src] = players[src] or {arena = arenaIndex, kills = 0, deaths = 0}
end)

RegisterNetEvent('pvp:playerDied')
AddEventHandler('pvp:playerDied', function(killerServerId, arenaIndex)
    local victim = source
    arenaIndex = arenaIndex or players[victim] and players[victim].arena
    if not arenaIndex then return end

    players[victim] = players[victim] or {arena = arenaIndex, kills = 0, deaths = 0}
    players[victim].deaths = players[victim].deaths + 1

    -- if killer is valid and tracked, award kill
    if killerServerId and killerServerId ~= 0 and players[killerServerId] then
        players[killerServerId].kills = players[killerServerId].kills + 1
        -- update killer HUD
        TriggerClientEvent('pvp:updateHud', killerServerId, players[killerServerId].kills, players[killerServerId].deaths)
    end

    -- update victim HUD
    TriggerClientEvent('pvp:updateHud', victim, players[victim].kills, players[victim].deaths)

    -- respawn victim in arena
    local a = getArena(arenaIndex)
    if a then
        TriggerClientEvent('pvp:respawnInArenaClient', victim, arenaIndex, a)
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if players[src] then
        local arena = players[src].arena
        if arena and arenaPlayers[arena] then
            arenaPlayers[arena][src] = nil
        end
        players[src] = nil
    end
end)