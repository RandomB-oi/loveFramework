local shaderClass = require("Game.Shared.Classes.Shader")
Engine.Updated:Connect(function(dt)
    shaderClass.Update(dt)
end)

love.window.setMode(800, 600, {resizable = true})

local mainMenuScene = Instance.new("Scene", Vector.new(800, 600))
mainMenuScene.Name = "MainMenu"
mainMenuScene.Position = UDim2.new(0.5, 0, 0.5, 0)
mainMenuScene.AnchorPoint = Vector.one/2
mainMenuScene.Parent = GameScene.Client
local aspectRatio = Instance.new("UIAspectRatioConstraint")
aspectRatio.AspectRatio = 1.25
aspectRatio.Parent = mainMenuScene

local worldGenScript = Instance.new("Overworld")
worldGenScript.Seed = 67
worldGenScript.Parent = mainMenuScene


-- local guiScript = Instance.new("GUICode")
-- guiScript.Parent = mainMenuScene
-- guiScript.World = worldGenScript

local localPlayer = Instance.new("Player")
worldGenScript:SetLocalPlayer(localPlayer)

-- local store = Engine:GetService("DatastoreService"):GetDatastore("Game/Shared/TestData")
-- store:SetAsync("testKey", {
--     value1 = true,
--     value2 = false,
--     ["value 3"] = localPlayer,
-- })

-- local list = Instance.new("Frame")
-- list.Position = UDim2.new(0.5, 0, 0.5, 0)
-- list.Size = UDim2.new(0.5, 0, 0.5, 0)
-- list.AnchorPoint = Vector.one/2
-- list.Color = Color.new(0,1,0,0.5)
-- list.Parent = mainMenuScene

-- local list = Instance.new("ScrollingFrame")
-- list.Position = UDim2.new(0.5, 0, 0.5, 0)
-- list.Size = UDim2.new(0.5, 0, 0.5, 0)
-- list.AnchorPoint = Vector.one/2
-- list.CanvasSize = UDim2.new(2,0,2,0)
-- list.Color = Color.new(1,1,1,0.5)
-- list.Parent = mainMenuScene

-- local newFrame = Instance.new("Frame")
-- newFrame.Size = UDim2.new(1,0,1,0)
-- newFrame.Color = Color.new(1,0,0,.5)
-- newFrame.Parent = list
