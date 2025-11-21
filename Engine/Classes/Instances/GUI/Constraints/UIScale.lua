local module = {}
module.Derives = "ConstraintBase"
module.__index = module
module.__type = "UIScale"

module.ConstraintCategory = "Scale"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
	self.Name = self.__type
	
	self:CreateProperty("Scale", "number", 1)

	return self
end

return Instance.RegisterClass(module)