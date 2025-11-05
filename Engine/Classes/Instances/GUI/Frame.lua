local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "Frame"
Instance.RegisterClass(module)

module.FrameRendering = true
module.ClassIcon = "Engine/Assets/InstanceIcons/Frame.png"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	self:CreateProperty("ZIndex", "number", 0)
	self:CreateProperty("Size", "UDim2", UDim2.new(0, 200, 0, 50))
	self:CreateProperty("Position", "UDim2", UDim2.new(0, 0, 0, 0))
	self:CreateProperty("AnchorPoint", "Vector", Vector.new(0, 0))
	self:CreateProperty("Color", "Color", Color.from255(255, 255, 255, 255))
	self:CreateProperty("Rotation", "number", 0)
	self:CreateProperty("LayoutOrder", "number", 0)

	self.RenderSize = Vector.zero
	self.RenderPosition = Vector.zero
	self.RenderRotation = 0

	return self
end

function module:MouseHovering()
	return self:IsHovering(Engine:GetService("InputService"):GetMouseLocation())
end

local function mouseInsideFrame(self, position)
	return
		position.X >= self.RenderPosition.X and position.X <= self.RenderPosition.X + self.RenderSize.X and
		position.Y >= self.RenderPosition.Y and position.Y <= self.RenderPosition.Y + self.RenderSize.Y
end

function module:IsHovering(position)
	local scrollingFrame = self:FindFirstAncestorWhichIsA("ScrollingFrame")
	if scrollingFrame and not mouseInsideFrame(scrollingFrame, position) then
		return
	end
	
	return mouseInsideFrame(self, position)
end

function module:Update(dt)
	-- if self._size ~= self.Size or self._position ~= self.Position or self._anchorPoint ~= self.AnchorPoint or self._color ~= self.Color or self._rotation ~= self.Rotation then
	-- 	self._size = self.Size
	-- 	self._position = self.Position
	-- 	self._anchorPoint = self.AnchorPoint
	-- 	self._color = self.Color
	-- 	self._rotation = self.Rotation

	-- 	self._changed = true
	-- end

	-- if self._changed then
		-- self._changed = false
		self:UpdateRender()

		-- local scene = self:GetScene()
		-- if scene then
		-- 	scene._canvasNeedsUpdate = true
		-- end
	-- end
	module.Base.Update(self, dt)
end

function module:Translate()
	love.graphics.push()
	local anchorSize = self.RenderSize * self.AnchorPoint
	local scenePosition = self:GetScene().RenderPosition
	love.graphics.translate(self.RenderPosition.X+anchorSize.X-scenePosition.X, self.RenderPosition.Y+anchorSize.Y-scenePosition.Y)
	love.graphics.rotate(math.rad(self.RenderRotation))

	return anchorSize
end

function module:DrawFrame()
	self.Color:Apply()

	local anchorSize = self:Translate()
	love.graphics.rectangle("fill", -anchorSize.X, -anchorSize.Y, self.RenderSize.X, self.RenderSize.Y)
	love.graphics.pop()
end

function module:Draw()
	if not self.Enabled then return end
	if self.FrameRendering then
		self:DrawFrame()
	end

	module.Base.Draw(self)
end

function module:GetModifiedSize(size)
	local aspectRatio = self._constraintChildren and self._constraintChildren.AspectRatio
	local ratio = aspectRatio and aspectRatio.AspectRatio
	if ratio then
		local scale = math.min(size.X, size.Y)
		if ratio > 1 then
			size = Vector.new(scale, scale/ratio)
		else
			size = Vector.new(scale*ratio, scale)
		end
	end

	return size
end

function module:UpdateRender()
	local isScene = self:IsA("Scene")
	if self.Parent or isScene then
		local parentSize, parentPosition, parentRotation

		if self.Parent and self.Parent:IsA("Frame") or not self.Parent and isScene then
			if self.Parent then
				parentSize, parentPosition, parentRotation = self.Parent:UpdateRender()
			end

			if not (parentSize and parentPosition and parentRotation) and isScene then
				parentSize = Vector.new(love.graphics.getDimensions())
				parentPosition = Vector.zero
				parentRotation = 0
			end

			if parentPosition and self.Parent and self.Parent.CanvasPosition then
				parentPosition = parentPosition - self.Parent.CanvasPosition
			end
		-- elseif self.Parent:IsA("Scene") then
		-- 	parentSize, parentPosition, parentRotation = self.Parent.RenderSize, self.Parent.RenderPosition or Vector.zero, 0
		end

		local listLayout
		if self.Parent and self.Parent._constraintChildren then
			listLayout = self.Parent._constraintChildren.List
			if self.Parent._constraintChildren.Padding then
				
			end
		end

		if (parentSize and parentPosition) then
			if listLayout then
				local size, pos, rot = listLayout:Resolve(self, parentSize, parentPosition, parentRotation)
				self.RenderSize = self:GetModifiedSize(size)
				self.RenderPosition = pos
				self.RenderRotation = rot
			else
				self.RenderSize = self:GetModifiedSize(self.Size:Calculate(parentSize))
				self.RenderPosition = parentPosition + self.Position:Calculate(parentSize) - self.RenderSize * self.AnchorPoint
				self.RenderRotation = parentRotation + self.Rotation
			end

			return self.RenderSize, self.RenderPosition, self.RenderRotation
		end
	end
	-- return Vector.new(love.graphics.getDimensions()), Vector.zero, 0
end

return module