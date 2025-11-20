local module = {}
module.Derives = "ConstraintBase"

module.__type = "UISizeConstraint"

module.ConstraintCategory = "Size"

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type
	
	self:CreateProperty("Min", "Vector", Vector.new(0,0))
	self:CreateProperty("Max", "Vector", Vector.new(math.huge,math.huge))

	return self
end

return Instance.RegisterClass(module)