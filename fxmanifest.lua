fx_version 'bodacious'
game 'gta5'

author 'kac5a'
description 'Deadly Gas Area'
version '1.0'

client_scripts {
    'config.lua',
	'client/main.lua'
}

server_scripts {
    'config.lua',
	'server/main.lua'
}

ui_page "html/index.html"

files({
    'html/**'
})