fx_version 'cerulean'
game 'gta5'

lua54 'yes'
author 'tropicgalxy'
description 'a very simple script to buy multiple business'
version '1.1'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@ox_lib/init.lua',
    'server.lua'
}

dependencies {
    'es_extended',
    'ox_target', -- comment out if using qb target
    -- 'qb-target'  -- comment out if using ox target
}
