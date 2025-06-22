local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "UILayoutBase"
Instance.RegisterClass(module)

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = "UILayout"

	return self
end

function module:Resolve(child, parentSize, parentPosition, parentRotation)
	return Vector.zero, Vector.zero, 0
end

return module