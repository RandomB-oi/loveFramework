local module = {}
module.Derives = "ConstraintBase"
module.__index = module
module.__type = "UIAspectRatioConstraint"
Instance.RegisterClass(module)

module.ClassIcon = "Engine/Assets/InstanceIcons/UIAspectRatioConstraint.png"
module.ConstraintCategory = "AspectRatio"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

    self:CreateProperty("AspectRatio", "number", 1)

	return self
end

return module