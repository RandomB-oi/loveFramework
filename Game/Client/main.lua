love.window.setMode(800, 600, {resizable = true})

local ClientService = Engine:GetService("ClientService")

local ServerConnectScene = require("Game.Client.Scenes.ServerConnectScene")
ServerConnectScene.Parent = GameScene.Client

local stopServerButton = Instance.new("Button")
stopServerButton.Parent = GameScene.Client
stopServerButton.Position = UDim2.fromScale(0.5, 0.5)

stopServerButton.LeftClicked:Connect(function()
	ClientService:DisconnectFromServer()
end)

ClientService.Disconnected:Connect(function()
	ServerConnectScene.Enabled = true
end)