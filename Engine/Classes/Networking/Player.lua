local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "ConnectedClient"

module.new = function(id)
	local self = setmetatable(module.Base.new(), module)

	return self
end


return module