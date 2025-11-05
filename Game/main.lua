local mainScene = Instance.new("Scene")
mainScene.Name = "Test Game"
mainScene:SetParent(Engine)
Shaders = require("Game.Utility.Shaders")
Engine.Updated:Connect(function(dt)
    Shaders:Update(dt)
end)
-- local newBin = Binary.WriteBits(0, 0, 4, 15)
-- for i = 0, Binary.GetSize(newBin)-1 do
--     print(Binary.ReadBits(newBin, i, 1))
-- end
-- print(Binary.ReadBits(newBin, 0, 4), tostring(newBin))

autoLoad("Game/Classes")
autoLoad("Game/Instances")
Instance.GetClass("Block").Init()
Instance.GetClass("Item").Init()

love.window.setMode(800, 600, {resizable = true})

Instance.new("Constants"):SetParent(mainScene)

local mainMenuScene = Instance.new("Scene", Vector.new(800, 600))
mainMenuScene.Name = "MainMenu"
mainMenuScene:SetParent(mainScene)

local worldGenScript = Instance.new("Overworld")
worldGenScript.Seed = 67
worldGenScript:SetParent(mainMenuScene)


local guiScript = Instance.new("GUICode")
guiScript:SetParent(mainMenuScene)
guiScript.World = worldGenScript

local localPlayer = Instance.new("Player")
worldGenScript:SetLocalPlayer(localPlayer)


return mainScene