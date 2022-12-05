Config = {}

-- Background of the advent calender, 16:9 format (example: 1920x1080, 2560x1440, 1280x720 etc)
Config.BackgroundImage = "https://wallpapersmug.com/download/1920x1080/334b31/snowfall-winter-hut-winter-christmas.jpg"

Config.PlateFirstString = 3
Config.PlateLastString = 3
Config.PlateUseSpace = true

-- NAME      - EXPLENATION
-- command   - Opens the advent calender when the command (Config.Command) is used.
-- keybind   - Opens the advent calender when the keybind (Config.Keybind) is pressed.
-- proximity - Opens the menu when the proximity prompt (zerio-proximityprompt) at Config.Coords is used.
-- target    - Opens the menu when targetting at Config.Coords with the Config.TargetScript
-- floating  - Opens the menu when the floating help text at Config.Coords is used
-- custom    - Opens the advent calender when export["zerio-advent"]:Open() is triggered
Config.OpenType = "target"

	-- Only needed if Config.OpenType is "command"
	Config.Command = "calender"

	-- Only needed if Config.OpenType is "keybind"
	Config.Keybind = "f6"
	Config.KeybindHelp = "Open advent calender"

	-- Only needed if Config.OpenType is "target"
	Config.TargetScript = "ox_target" -- qb-target, ox_target or qtarget
	Config.CustomTargetName = nil -- only needed if you have renamed your target script, otherwise just leave as nil

	Config.TargetSize = {2.0,2.0,2.0}
	Config.TargetRotation = 0
	Config.TargetDebug = false 
	Config.TargetMaxDist = 2.5

	Config.TargetIcon = "fa-solid fa-calendar-days"
	Config.TargetLabel = "Open advent calender"

	-- Only needed if Config.OpenType is "proximity"
	Config.ProximityKey = "E"
	Config.ProximityTime = 750

	Config.ProximityObjectText = "Advent calender"
	Config.ProximityActionText = "Open the calender"

	Config.ProximityDrawDist = 3
	Config.ProximityUsageDist = 1.5

	-- Only needed if Config.OpenType is "floating"
	Config.FloatingMaxDist = 1.5
	Config.FloatingText = "~INPUT_CONTEXT~ - Open advent calender"

	-- Only needed if Config.OpenType is "proximity", "target" or "floating"
	Config.Coords = vector4(239.2868, -877.0123, 30.4921, 5.1933) 
	Config.Blip = {
		Enabled = true,
		Color = 1,
		Sprite = 76,
		Size = 1.0,
		Text = "Advent Calendar"
	}

-- 24 or 25 rewards should be used, to suggest other numbers open a ticket.
-- Reward types:
-- NAME     - EXPLENATION
-- vehicle	- Gives a vehicle with an specific model
-- money		- Give a specific amount of money as the reward
-- item		  - Gives an item as the reward
-- custom 	- Triggers the custom function as an reward
Config.Rewards = {
	{
		type = "vehicle",

		model = "adder",
		label = "Adder"
	},	
	{
		type = "item",

		item = "bread",
		label = "Bread",
		amount = 3
	}, 
	{
		type = "money",

		account = "bank",
		amount = 69420
	},	
	{
		type = "custom",

		handler = function(player, source)

		end
	},	






	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},	
	{
		type = "vehicle",
		model = "adder"
	},
}
