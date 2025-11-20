local module = {}
module.Derives = "ValueBase"

module.__type = "IntValue"

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type

	self:CreateProperty("Value", "number", 0, "Int")

	return self
end

return Instance.RegisterClass(module)