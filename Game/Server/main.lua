local ServerService = Engine:GetService("ServerService")
ServerService.PlayerClass = "Frame"
ServerService.PlayerObjectParent = "Players"

local NonReplicateObject = Instance.new("NumberValue")
NonReplicateObject.Name = "TestNonReplicateObject"
NonReplicateObject.Parent = GameScene.Server

local ReplicateObject = Instance.new("Frame")
ReplicateObject.Name = "TestReplicateObject"
ReplicateObject.Size = UDim2.fromOffset(50,50)
ReplicateObject.AnchorPoint = Vector.one/2
ReplicateObject.Parent = GameScene.Client

local RunService = Engine:GetService("RunService")

local scriptObject = Instance.new("Script")

function scriptObject:ScriptUpdate(dt)
	local et = RunService.ElapsedTime
	local x = math.sin(et)/2+0.5
	local y = math.cos(et)/2+0.5
	ReplicateObject.Position = UDim2.new(1-x,0,y,0)
	
	ReplicateObject.Rotation = (et*90) % 360
end
-- scriptObject.Enabled = false

scriptObject.Parent = GameScene.Server

local newRemote = Instance.new("RemoteEvent")
newRemote.Name = "TestRemote"
newRemote.Parent = GameScene.Shared
newRemote.Event:Connect(print)

ServerService.ClientConnected:Connect(function(clientID)
	newRemote:FireClient(clientID, "you just joined")
end)