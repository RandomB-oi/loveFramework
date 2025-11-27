love.window.setMode(800, 600, {resizable = true})

local ClientService = Engine:GetService("ClientService")
-- ClientService.MessageRecieved:Connect(print)

local ServerConnectScene = require("Game.Client.Scenes.ServerConnectScene")
ServerConnectScene.Parent = GameScene.Client

local ConnectedScene = require("Game.Client.Scenes.ConnectedScene")
ConnectedScene.Parent = GameScene.Client

ServerConnectScene.Enabled = true
ConnectedScene.Enabled = false

ClientService.Connected:Connect(function()
	ServerConnectScene.Enabled = false
	ConnectedScene.Enabled = true
end)

ClientService.Disconnected:Connect(function()
	ServerConnectScene.Enabled = true
	ConnectedScene.Enabled = false
end)

task.spawn(function()
	local remote = GameScene.Shared:WaitForChild("TestRemote")
	remote.Event:Connect(print)
	remote:FireServer("this is a test")
end)