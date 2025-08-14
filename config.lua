Config = {}

-- spawn point where a PED 'GUNFIGHT' will appear and where players can press E to join
Config.SpawnPoint = vector3(237.13, 784.86, 30.61) -- change as needed
Config.SpawnHeading = 320.89

-- arenas
Config.Arenas = {
    {name = "Dock", coord = vector3(-335.0, -2800.0, 8.0), radius = 80.0, heading = 90.0},
    {name = "Port", coord = vector3(-2040.0, -1030.0, 15.0), radius = 60.0, heading = 45.0},
    {name = "Hangar", coord = vector3(-1100.0, -2900.0, 13.0), radius = 70.0, heading = 180.0},
    {name = "Usine", coord = vector3(700.0, -1000.0, 22.0), radius = 65.0, heading = 270.0}
}

Config.GunWeapon = "WEAPON_ASSAULTRIFLE"
Config.RespawnDelay = 1500 -- ms before respawn in arena after death
Config.InteractDistance = 2.0
Config.PedModel = "s_m_m_ammucountry"
Config.PedName = "GUNFIGHT"

