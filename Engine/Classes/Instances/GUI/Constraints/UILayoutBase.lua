local module = {}
module.Derives = "ConstraintBase"
module.__index = module
module.__type = "UILayoutBase"
Instance.RegisterClass(module)

module.ConstraintCategory = "List"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type
	
	return self
end

function module:Resolve(child, parentSize, parentPosition, parentRotation)
	return Vector.zero, Vector.zero, 0
end

return module