local module = {}
module.Derives = "ValueBase"
module.__index = module
module.__type = "IntValue"
Instance.RegisterClass(module)

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	self:CreateProperty("Value", "number", 0, "Int")

	return self
end

return module