local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "BaseService"
Instance.RegisterClass(module)

module.ClassIcon = "Engine/Assets/InstanceIcons/Unknown.png"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type
	self.ZIndex = 99999999
	return self
end

return module