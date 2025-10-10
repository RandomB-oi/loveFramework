GameScene = Instance.new("Scene")
GameScene.Name = "Test Game"
GameScene:SetParent(Engine)


load("Game", {
	Classes = {},
	Instances = {"Constants", "Hotbar"},
	Scenes = {},
})

love.window.setMode(800, 600, {resizable = true})

Instance.new("Constants"):SetParent(GameScene)
require("Game.Scenes.MainMenu"):Enable():Unpause()

return GameScene