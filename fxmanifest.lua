fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author "Kayne"
description 'Garbage Job created for QBox with ox_lib'
version '1.0.0'

shared_script {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'shared/config.lua'
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

dependencies {
    'ox_lib',
    'qbx_core'
}