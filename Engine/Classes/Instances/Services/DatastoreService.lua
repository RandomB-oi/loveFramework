local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "DatastoreService"

local function CleanPath(path)
	path = string.gsub(path,"%.","/")
	return path
end

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
	self.Name = self.__type

	self.Datastores = {}

	self:CreateProperty("MockEnabled", "boolean", false)

	return self
end

-- only one datastore of a specific path can exist
function module:GetDatastore(path)
	path = CleanPath(path)

	if self.Datastores[path] then
		return self.Datastores[path]
	end

	local datastore = Instance.new("Datastore", path)
	self.Datastores[path] = datastore
	
	return datastore
end

return Instance.RegisterClass(module)