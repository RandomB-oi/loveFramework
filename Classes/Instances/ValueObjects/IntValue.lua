local module = {}
module.Derives = "ValueBase"
module.__index = module
module.__type = "IntValue"
Instance.RegisterClass(module)

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	self.Value = 0
	self._value = 0

	return self
end

function module:Update(dt)
	if type(self.Value) ~= "number" then
		self.Value = 0
	end
	self.Value = math.floor(self.Value)

	module.Base.Update(self, dt)
end

return module