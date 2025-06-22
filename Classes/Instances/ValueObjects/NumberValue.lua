local module = {}
module.Base = require("Classes.Instances.ValueObjects.ValueBase")
module.__index = module
module.__type = "NumberValue"
setmetatable(module, module.Base)

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

	module.Base.Update(self, dt)
end

return Instance.RegisterClass(module)