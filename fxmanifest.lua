fx_version 'cerulean'
games { 'gta5' }

author 'ChatGPT'
description 'PvP pack - spawn GUNFIGHT ped, E to join arena (dome/yacht), give weapon, HUD kills/deaths, respawn in zone'
version '1.0.0'

client_script 'client.lua'
server_script 'server.lua'
shared_script 'config.lua'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/style.css',
    'html/script.js'
}
