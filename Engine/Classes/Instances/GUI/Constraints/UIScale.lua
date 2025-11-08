local module = {}
module.Derives = "ConstraintBase"
module.__index = module
module.__type = "UIScale"
Instance.RegisterClass(module)

module.ConstraintCategory = "Scale"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type
	
	self:CreateProperty("Scale", "number", 1)

	return self
end

return module