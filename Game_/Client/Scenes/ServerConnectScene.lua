local ServerConnectScene = Instance.new("Scene")

local ClientService = Engine:GetService("ClientService")

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingRight = UDim.new(0, 6)
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingBottom = UDim.new(0, 6)
padding.Parent = ServerConnectScene

local backdrop = Instance.new("ScrollingFrame")
backdrop.Size = UDim2.new(.5, 0, 1, 0)
backdrop.Position = UDim2.new(0, 0, 0, 0)
backdrop.AnchorPoint = Vector.new(0, 0)
backdrop.Color = Color.from255(255,255,255,200)
backdrop.ScrollbarPadding = Enum.ScrollbarPadding.Scrollbar
backdrop.Parent = ServerConnectScene

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingRight = UDim.new(0, 6)
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingBottom = UDim.new(0, 6)
padding.Parent = backdrop

local layout = Instance.new("UIListLayout")
layout.Padding = UDim2.fromOffset(6, 6)
layout.ListAxis = Vector.yAxis
layout.Parent = backdrop

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function(size)
	backdrop.CanvasSize = UDim2.fromOffset(0, size.Y)
end)

local serial = 0
local function NewButton(text)
	serial = serial + 1
	local button = Instance.new("Button")
	button.Size = UDim2.new(1, 0, 0, 75)
	button.Position = UDim2.new(0, 0, 0, 0)
	button.AnchorPoint = Vector.new(0.5, 0)
	button.Color = Color.from255(255,255,255,200)
	button.LayoutOrder = serial
	button.Parent = backdrop

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -6, 1, -6)
	textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	textLabel.AnchorPoint = Vector.new(0.5, 0.5)
	textLabel.Color = Color.from255(0,0,0,255)
	textLabel.Text = text
	textLabel.Parent = button

	return button
end


NewButton("Host").LeftClicked:Connect(function()
	if ClientService:HostLocalServer() then
		ServerConnectScene.Enabled = false
	end
end)



local joinBackdrop = Instance.new("ScrollingFrame")
joinBackdrop.Size = UDim2.new(.5, -6, 1, 0)
joinBackdrop.Position = UDim2.new(1, 0, 0, 0)
joinBackdrop.AnchorPoint = Vector.new(1, 0)
joinBackdrop.Color = Color.from255(255,255,255,200)
joinBackdrop.ScrollbarPadding = Enum.ScrollbarPadding.Scrollbar
joinBackdrop.Parent = ServerConnectScene
joinBackdrop.Enabled = false

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingRight = UDim.new(0, 6)
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingBottom = UDim.new(0, 6)
padding.Parent = joinBackdrop

local layout = Instance.new("UIListLayout")
layout.Padding = UDim2.fromOffset(6, 6)
layout.ListAxis = Vector.yAxis
layout.Parent = joinBackdrop

local serverIP = Instance.new("TextBox")
serverIP.Size = UDim2.new(1, 0, 0, 75)
serverIP.Position = UDim2.new(0, 0, 0, 0)
serverIP.AnchorPoint = Vector.new(0.5, 0)
serverIP.Color = Color.from255(255,255,255,200)
serverIP.PlaceholderText = "Server IP"
serverIP.LayoutOrder = 1
serverIP.Parent = joinBackdrop

local serverPort = Instance.new("TextBox")
serverPort.Size = UDim2.new(1, 0, 0, 75)
serverPort.Position = UDim2.new(0, 0, 0, 0)
serverPort.AnchorPoint = Vector.new(0.5, 0)
serverPort.Color = Color.from255(255,255,255,200)
serverPort.PlaceholderText = "Server Port"
serverPort.LayoutOrder = 2
serverPort.Parent = joinBackdrop
local connectButton = NewButton("Connect")
connectButton.LayoutOrder = 3
connectButton.Parent = joinBackdrop
connectButton.LeftClicked:Connect(function()
	if ClientService:ConnectToServer(serverIP.Text, serverPort.Text) then
		ServerConnectScene.Enabled = false
	end
end)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function(size)
	joinBackdrop.CanvasSize = UDim2.fromOffset(0, size.Y)
end)

NewButton("Join").LeftClicked:Connect(function()
	joinBackdrop.Enabled = not joinBackdrop.Enabled
end)

return ServerConnectScene