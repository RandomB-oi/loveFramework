local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "RemoteEvent"

module.ClassIcon = "Engine/Assets/InstanceIcons/RemoteEvent.png"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
	self.Name = self.__type

	self.Event = self.Maid:Add(Signal.new())

	return self
end

function module:_addEvent(data)
	if type(self) == "string" then
		local connection connection = Instance.GetClass("BaseInstance").InstanceCreated:Connect(function(id, object)
			if id == self then
				connection:Disconnect()
				connection = nil

				object:_addEvent(data)
			end
		end)
		return
	end
	if not next(self.Event) then
		task.spawn(function()
			repeat task.wait(1/60) if not self.Parent then return end until next(self.Event)
			self.Event:Fire(unpack(data))
		end)
		return
	end

	self.Event:Fire(unpack(data))
end

function module:FireClient(clientID, ...)
	local runService = Engine:GetService("RunService")
	if not runService:IsServer() then return end
	local serverService = Engine:GetService("ServerService")
	
	serverService:SendMessage(clientID, "RemoteEvent", {
		ID = self.ID,
		Data = {...},
	})
end

function module:FireAllClients(...)
	local runService = Engine:GetService("RunService")
	if not runService:IsServer() then return end
	local serverService = Engine:GetService("ServerService")

	serverService:SendMessageAll("RemoteEvent", {
		ID = self.ID,
		Data = {...},
	})
end

function module:FireServer(...)
	local runService = Engine:GetService("RunService")
	if not runService:IsClient() then return end
	local clientService = Engine:GetService("ClientService")

	clientService:SendMessage("RemoteEvent", {
		ID = self.ID,
		Data = {...},
	})
end


return Instance.RegisterClass(module)