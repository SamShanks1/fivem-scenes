fx_version "cerulean"
lua54 'yes'
game 'gta5'

author "Sam Shanks"
version      '1.5.0'
repository 'https://github.com/SamShanks1/fivem-scenes'
description 'Fivem Scenes'

shared_scripts { '@ox_lib/init.lua', 'config.lua' }

ui_page 'web/build/index.html'

client_scripts { "client/utils.lua", "client/client.lua", "client/fonts.lua" }
server_scripts { "@oxmysql/lib/MySQL.lua", "server/server.lua" }

files {
	'web/build/index.html',
	'web/build/**/*',
}
