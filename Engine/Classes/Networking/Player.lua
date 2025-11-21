local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "ConnectedClient"

module.new = function(id)
	local self = setmetatable(module.Base.new(), module._metatable)

	return self
end


return module