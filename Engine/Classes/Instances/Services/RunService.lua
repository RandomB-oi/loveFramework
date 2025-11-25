local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "RunService"


module.new = function ()
	local self = setmetatable(module.Base.new(module.__type), module._metatable)
	self.Name = self.__type

	self:CreateProperty("ElapsedTime", "number", 0)
	self:CreateProperty("TimeScale", "number", 1)
	self._isServer = not not _G.LaunchParameters.server
	self._editor = not not _G.LaunchParameters.editor

	return self
end

function module:IsServer()
	return not not self._isServer
end
function module:IsClient()
	return not self._isServer
end

function module:IsEditor()
	return self._editor
end

return Instance.RegisterClass(module)