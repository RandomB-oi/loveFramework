local newScene = Instance.new("Scene", Vector.new(800, 600))
newScene.Name = "MainMenu"
newScene:SetParent(GameScene)

Instance.new("Hotbar"):SetParent(newScene)
local worldGenScript = Instance.new("Overworld")
worldGenScript.Seed = 67
worldGenScript:SetParent(newScene)



    local localPlayer = Instance.new("Player")
    worldGenScript:SetLocalPlayer(localPlayer)

return newScene