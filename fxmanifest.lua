fx_version 'adamant'
game 'gta5'
lua54 'yes'

description 'Sim Cards System For NPWD'
author 'requestrip'
version '1.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'server/main.lua',
}

client_scripts {
	'client/main.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}