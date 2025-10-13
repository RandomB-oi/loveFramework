local newScene = Instance.new("Scene", Vector.new(800, 600))
newScene.Name = "MainMenu"
newScene:SetParent(GameScene)

Instance.new("Hotbar"):SetParent(newScene)
local worldGenScript = Instance.new("WorldGeneratorScript")
worldGenScript.Seed = 67
worldGenScript:SetParent(newScene)

return newScene