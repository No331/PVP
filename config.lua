Config = {}

-- spawn point where a PED 'GUNFIGHT' will appear and where players can press E to join
Config.SpawnPoint = vector3(-1034.0, -2738.0, 20.17) -- change as needed
Config.SpawnHeading = 160.0

-- arenas
Config.Arenas = {
    {name = "Dome Dock", coord = vector3(-335.0, -2800.0, 8.0), radius = 80.0, heading = 90.0},
    {name = "Yacht", coord = vector3(-2040.0, -1030.0, 15.0), radius = 60.0, heading = 45.0}
}

Config.GunWeapon = "WEAPON_ASSAULTRIFLE"
Config.RespawnDelay = 1500 -- ms before respawn in arena after death
Config.InteractDistance = 2.0
Config.PedModel = "s_m_m_ammucountry"
Config.PedName = "GUNFIGHT"

