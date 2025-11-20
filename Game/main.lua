GameScene = Instance.new("Scene")
GameScene.Name = "Test Game"
GameScene:SetParent(Engine)
-- local newBin = Binary.WriteBits(0, 0, 4, 15)
-- for i = 0, Binary.GetSize(newBin)-1 do
--     print(Binary.ReadBits(newBin, i, 1))
-- end
-- print(Binary.ReadBits(newBin, 0, 4), tostring(newBin))

require("Game.Classes.Shader")
autoLoad("Game/Classes")
autoLoad("Game/Instances")
Instance.GetClass("Block").Init()
Instance.GetClass("Item").Init()
Engine.Updated:Connect(function(dt)
    Instance.GetClass("Shader").Update(dt)
end)

love.window.setMode(800, 600, {resizable = true})

local mainMenuScene = Instance.new("Scene", Vector.new(800, 600))
mainMenuScene.Name = "MainMenu"
mainMenuScene:SetParent(GameScene)

local worldGenScript = Instance.new("Overworld")
worldGenScript.Seed = 67
worldGenScript:SetParent(mainMenuScene)


local guiScript = Instance.new("GUICode")
guiScript:SetParent(mainMenuScene)
guiScript.World = worldGenScript

local localPlayer = Instance.new("Player")
worldGenScript:SetLocalPlayer(localPlayer)

local store = Engine:GetService("DatastoreService"):GetDatastore("Game/TestData")
store:SetAsync("testKey", {
    value1 = true,
    value2 = false,
    ["value 3"] = localPlayer,
})

-- local list = Instance.new("Frame")
-- list.Position = UDim2.new(0.5, 0, 0.5, 0)
-- list.Size = UDim2.new(0.5, 0, 0.5, 0)
-- list.AnchorPoint = Vector.one/2
-- list.Color = Color.new(0,1,0,0.5)
-- list:SetParent(mainMenuScene)

-- local list = Instance.new("ScrollingFrame")
-- list.Position = UDim2.new(0.5, 0, 0.5, 0)
-- list.Size = UDim2.new(0.5, 0, 0.5, 0)
-- list.AnchorPoint = Vector.one/2
-- list.CanvasSize = UDim2.new(2,0,2,0)
-- list.Color = Color.new(1,1,1,0.5)
-- list:SetParent(mainMenuScene)

-- local newFrame = Instance.new("Frame")
-- newFrame.Size = UDim2.new(1,0,1,0)
-- newFrame.Color = Color.new(1,0,0,.5)
-- newFrame:SetParent(list)

return GameScene