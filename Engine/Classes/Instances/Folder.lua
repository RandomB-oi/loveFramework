local module = {}
module.Derives = "BaseInstance"

module.__type = "Folder"

module.ClassIcon = "Engine/Assets/InstanceIcons/Folder.png"

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type

	return self
end

function module:Update(dt)
	if not self.Parent then return end
	self.RenderSize = self.Parent.RenderSize
	self.RenderPosition = self.Parent.RenderPosition
	self.RenderRotation = self.Parent.RenderRotation
	module.Base.Update(self, dt)
end

return Instance.RegisterClass(module)