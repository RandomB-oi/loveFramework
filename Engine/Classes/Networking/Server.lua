local module = {}
module.Derives = "BaseInstance"

module.__type = "ConnectedClient"

local ENet = require("enet")

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)

	return self
end

function module:AddClient(ip, port)
end

return module