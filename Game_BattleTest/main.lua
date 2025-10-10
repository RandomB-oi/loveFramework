GameScene = Instance.new("Scene")
GameScene.Name = "Test Game"
GameScene:SetParent(Engine)

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

return GameScene