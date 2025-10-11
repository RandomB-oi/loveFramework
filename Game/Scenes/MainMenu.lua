local newScene = Instance.new("Scene", Vector.new(800, 600))
newScene.Name = "MainMenu"
newScene:SetParent(GameScene)

Instance.new("Hotbar"):SetParent(newScene)
Instance.new("WorldGenerator"):SetParent(newScene)

return newScene