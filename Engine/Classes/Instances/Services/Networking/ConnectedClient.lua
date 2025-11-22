local module = {}
module.__index = module

local NextClientID = 0

local function GetID()
    NextClientID = NextClientID + 1
	return tostring(-NextClientID)
end

module.new = function(peer)
	local ServerService = Engine:GetService("ServerService")

    local self = setmetatable({}, module)
	self.Maid = Maid.new()
	self.Peer = peer
	self.ID = GetID()
	self.Instance = self.Maid:Add(Instance.new(ServerService.PlayerClass, self.ID))

	return self
end

function module:Destroy()
	self.Maid:Destroy()
end

return module