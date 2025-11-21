local module = {}
module.Derives = "ConstraintBase"
module.__index = module
module.__type = "UILayoutBase"

module.ConstraintCategory = "List"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
	self.Name = self.__type
	
	return self
end

function module:Resolve(child, parentSize, parentPosition, parentRotation)
	return Vector.zero, Vector.zero, 0
end

return Instance.RegisterClass(module)