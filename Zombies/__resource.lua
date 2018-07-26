resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

ui_page "client/index.html"

files {
	"client/index.html",
	"client/groans/zmoan01.ogg",
	"client/groans/zmoan02.ogg",
	"client/groans/zmoan03.ogg",
	"client/groans/zmoan04.ogg",
	"client/groans/groan.ogg",
	"client/groans/groan2.ogg",
	"client/groans/groan3.ogg",
	"client/groans/groan4.ogg",
	"client/groans/groan5.ogg",
	"client/groans/groan6.ogg",
	"client/groans/lowgroan.ogg",
	"client/groans/lowgroan2.ogg",
	"client/groans/alerted.ogg",
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"server/main.lua",
	"server/gui_s.lua",
	"loot/server.lua",
	--"server/notifications_s.lua",
	--"server/itemspawner_server.lua",
}

client_scripts {
	"quests/peds.lua",
	"quests/missions.lua",
	"quests/missionPeds.lua",
	"quests/levelSystem.lua",
	
	"loot/client/consumables.lua",
	"loot/client/crafting.lua",
	"loot/client/newloot.lua",
	"loot/client/lootcoords.lua",
	"loot/client/trading.lua",
	"loot/client/zpills.lua",
	
	"client/warmenu.lua",
	"client/newplayer.lua",
	"client/friendlyAnimals.lua",
	"client/hostileAnimals.lua",
	"client/zombiespawner.lua",
	"client/bikespawner.lua",
	"client/carspawner.lua",
	"client/newzombie.lua",
	"client/looterspawner.lua",
	--"client/NGFSpawner.lua",
	--"client/superzombiespawner.lua",
	--"client/itemspawner.lua",
	"client/hud.lua",
	"client/injury.lua",
	"client/host.lua",
	"client/food.lua",
	"client/gui.lua",
	--"client/notifications.lua",
	--"client/reverse_weapon_hashes.lua",
	--"client/noreticle.lua",
}
