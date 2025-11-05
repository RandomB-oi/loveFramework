mainScene = Instance.new("Scene")
mainScene.Name = "Test Game"
mainScene:SetParent(Engine)

GameVariables = require("Game.GameVariables")

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

love.window.setMode(800, 600, {resizable = true})
-- require("Game.Scenes.MainMenu"):Enable():Unpause()
require("Game.Scenes.BattleScene")

return mainScene