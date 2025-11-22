local module = {}
module.Derives = "Scene"
module.__type = "DataModel"
module.__index = module
module.ClassIcon = "Engine/Assets/InstanceIcons/Workspace.png"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
	self.Name = self.__type

	self.Server = Instance.new("Scene", "ServerScene")
	self.Server.Name = "Server"
	-- self.Server.Replicates = false
	self.Server.Visible = false
	self.Server.Parent = self

	self.Shared = Instance.new("Scene", "SharedScene")
	self.Shared.Name = "Shared"
	self.Shared.Replicates = true
	self.Shared.Visible = false
	self.Shared.Parent = self

	self.Client = Instance.new("Scene", "ClientScene")
	self.Client.Name = "Client"
	self.Client.Replicates = true
	self.Client.Visible = true
	self.Client.Parent = self

	return self
end


return Instance.RegisterClass(module)