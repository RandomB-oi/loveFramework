GameVariables = require("Game/GameVariables")

load("Game/Instances", {
		"Projectile",
	})

-- require("Game.Menus.MainMenu"):Disable()
require("Game.Menus.BattleScene"):Enable():Unpause()