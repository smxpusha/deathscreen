fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'finalgottypusha#1972'
description 'Script by SMX Development'
version '1.0.0'

escrow_ignore {
	'config/config.lua'
  }
shared_scripts {
    'config/config.lua',
    '@ox_lib/init.lua'
}
client_scripts {
    'client/*.lua',
    'modules/**/client/*.lua'
}

server_scripts {
    'server/*.lua',
    'modules/**/server/*.lua'
}
ui_page {
    'html/index.html'
}
files {
    'html/index.html',
    'html/Css/Main.css',
    'html/Script/*.js',
    'html/assets/*.png',
}

