fx_version "cerulean"
game "gta5"

shared_scripts {
  "config.lua"
}

server_scripts {
  "server/functions.lua",
  "server/main.lua"
}

client_scripts {
  "client/functions.lua",
  "client/main.lua"
}


files {
  "html/index.html",
  "html/*.css"
}

ui_page "http://localhost:8080"
