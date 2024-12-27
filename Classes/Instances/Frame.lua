local module = {}
module.Base = require("Classes.Instances.Instance")
module.__index = module
module.__type = "Frame"
setmetatable(module, module.Base)

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	self.Size = UDim2.new(0, 200, 0, 50)
	self.Position = UDim2.new(0, 0, 0, 0)
	self.AnchorPoint = Vector.new(0, 0)
	self.BackgroundColor = Color.From255(255, 255, 255, 255)

	self.RenderSize = Vector.zero
	self.RenderPosition = Vector.zero

	return self
end

function module:Update(dt)
	if self._size ~= self.Size or self._position ~= self.Position or self._anchorPoint ~= self.AnchorPoint or self._backgroundColor ~= self.BackgroundColor then
		self._size = self.Size
		self._position = self.Position
		self._anchorPoint = self.AnchorPoint
		self._backgroundColor = self.BackgroundColor

		self._changed = true
	end

	if self._changed then
		self._changed = false
		self:UpdateRender()

		local scene = self:GetScene()
		if scene then
			scene._guiNeedsUpdate = true
		end
	end
	module.Base.Update(self, dt)
end

function module:Draw()
	if self.__type == "Frame" then
		self.BackgroundColor:Apply()
		love.graphics.rectangle("fill", self.RenderPosition.X, self.RenderPosition.Y, self.RenderSize.X, self.RenderSize.Y)
	end

	module.Base.Draw(self)
end

function module:UpdateRender()
	if self.Parent then
		local parentSize, parentPosition
		if self.Parent:IsA("Frame") then
			parentSize, parentPosition = self.Parent:UpdateRender()
		elseif self.Parent:IsA("Scene") then
			parentSize, parentPosition = self.Parent.Size, Vector.zero
		end
		if (parentSize and parentPosition) then
			self.RenderSize = self.Size:Calculate(parentSize)
			self.RenderPosition = parentPosition + self.Position:Calculate(parentSize) - self.RenderSize * self.AnchorPoint
			return self.RenderSize, self.RenderPosition
		end
	end
end

return module