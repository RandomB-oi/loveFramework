local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "ConnectedClient"

local ENet = require("enet")

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	self.ConnectedClients = {}

	return self
end

function module:AddClient(ip, port)
	-- local uniqueID = 
end

return module