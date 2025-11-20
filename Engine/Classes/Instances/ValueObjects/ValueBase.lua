local module = {}
module.Derives = "BaseInstance"

module.__type = "ValueBase"

module.ClassIcon = "Engine/Assets/InstanceIcons/IntValue.png"

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type

	return self
end

return Instance.RegisterClass(module)