local ConnectedScene = Instance.new("Scene")
ConnectedScene.Name = "ConnectedScene"
ConnectedScene.Enabled = false

local ClientService = Engine:GetService("ClientService")

local stopServerButton = Instance.new("Button")
stopServerButton.Position = UDim2.fromScale(0.5, 1)
stopServerButton.AnchorPoint = Vector.new(0.5, 1)
stopServerButton.Parent = ConnectedScene

local stopText = Instance.new("TextLabel")
stopText.Text = "Disconnect from server"
stopText.Color = Color.new(0,0,0,1)
stopText.Size = UDim2.fromScale(1,1)
stopText.Parent = stopServerButton

stopServerButton.LeftClicked:Connect(function()
	ClientService:DisconnectFromServer()
end)

return ConnectedScene