local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "ValueBase"
Instance.RegisterClass(module)

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Changed = self.Maid:Add(Signal.new())

	self.Value = nil
	self._value = nil
	self.Name = "Value"

	return self
end

function module:Update(dt)
	if self._value ~= self.Value then
		local prevValue = self._value
		self._value = self.Value
		
		self.Changed:Fire(self.Value, prevValue)
	end

	module.Base.Update(self, dt)
end

return module