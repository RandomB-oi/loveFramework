local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "ValueBase"
Instance.RegisterClass(module)

module.ClassIcon = "Engine/Assets/InstanceIcons/IntValue.png"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	return self
end

return module