GameVariables = require("Game/GameVariables")

load("Game", {
	Classes = {
		"Battle",
	},
	Instances = {
		"Projectile",
		"Soul",
	},
	Scenes = {
		-- "MainMenu",
		-- "BattleScene",
	},
})

-- require("Game.Scenes.MainMenu"):Enable():Unpause()
require("Game.Scenes.BattleScene"):Enable():Unpause()