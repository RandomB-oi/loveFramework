local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "Players"

module.new = function ()
	local self = setmetatable(module.Base.new(module.__type), module._metatable)
	self.Name = self.__type
	self.Replicates = true
    self.Hidden = false

	return self
end

return Instance.RegisterClass(module)