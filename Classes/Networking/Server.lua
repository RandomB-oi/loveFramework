local module = {}
module.Base = require("Classes.Instances.Instance")
module.__index = module
module.__type = "ConnectedClient"
setmetatable(module, module.Base)

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