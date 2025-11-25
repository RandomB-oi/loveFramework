local module = {}
module.Derives = "Scene"
module.__type = "DataModel"
module.__index = module
module.ClassIcon = "Engine/Assets/InstanceIcons/Workspace.png"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
	self.Name = self.__type

	local server = Instance.new("Scene", "ServerScene")
	server.Name = "Server"
	server.Replicates = false
	server.Visible = false
	server.Parent = self

	local shared = Instance.new("Scene", "SharedScene")
	shared.Name = "Shared"
	shared.Replicates = true
	shared.Visible = false
	shared.Parent = self

	local client = Instance.new("Scene", "ClientScene")
	client.Name = "Client"
	client.Replicates = true
	client.Visible = true
	client.Parent = self

	return self
end


return Instance.RegisterClass(module)