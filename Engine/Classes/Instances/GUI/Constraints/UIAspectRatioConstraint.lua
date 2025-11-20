local module = {}
module.Derives = "ConstraintBase"

module.__type = "UIAspectRatioConstraint"

module.ClassIcon = "Engine/Assets/InstanceIcons/UIAspectRatioConstraint.png"
module.ConstraintCategory = "AspectRatio"

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type

    self:CreateProperty("AspectRatio", "number", 1)

	return self
end

return Instance.RegisterClass(module)