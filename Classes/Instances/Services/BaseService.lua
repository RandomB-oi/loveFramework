local module = {}
module.Base = require("Classes.Instances.BaseInstance")
module.__index = module
module.__type = "Service"
setmetatable(module, module.Base)

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	return self
end

return Instance.RegisterClass(module)