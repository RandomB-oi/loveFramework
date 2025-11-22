local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "ItemRenderFrame"

module.FrameRendering = false

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
    self.Name = self.__type

	self:CreateProperty("ItemID", "string", "")
	local aspectRatio = Instance.new("UIAspectRatioConstraint")
	aspectRatio.Archivable = false
	aspectRatio.Parent = self

	return self
end

function module:Draw()
	if not self.Enabled then return end
	module.Base.Draw(self)
	if self.ItemID == "" then return end
	local objectClass = Instance.GetClass("Item").Items[self.ItemID]
	if not objectClass then print("no class for", self.ItemID) return end

	love.graphics.push()
	local offset = self.RenderPosition - self:GetScene().RenderPosition
	love.graphics.translate(offset.X, offset.Y)
	objectClass:GenericDraw(self.RenderSize)
	love.graphics.pop()
end

return Instance.RegisterClass(module)