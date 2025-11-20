local module = {}
module.Derives = "ValueBase"

module.__type = "NumberValue"

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type

	self:CreateProperty("Value", "number", 0)

	return self
end

return Instance.RegisterClass(module)