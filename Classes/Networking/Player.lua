local module = {}
module.Base = require("Classes.Instances.Instance")
module.__index = module
module.__type = "ConnectedClient"
setmetatable(module, module.Base)

module.new = function(id)
	local self = setmetatable(module.Base.new(), module)

	return self
end


return module