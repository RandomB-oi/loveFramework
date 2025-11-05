local module = {}
module.Derives = "ValueBase"
module.__index = module
module.__type = "NumberValue"
Instance.RegisterClass(module)

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	self:CreateProperty("Value", "number", 0)

	return self
end

return module