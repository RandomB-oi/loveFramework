local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "BaseService"

module.ClassIcon = "Engine/Assets/InstanceIcons/Unknown.png"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
	self.Name = self.__type
	self.ZIndex = 99999999
	return self
end

return Instance.RegisterClass(module)