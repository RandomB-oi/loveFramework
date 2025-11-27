local module = {}
module.Derives = "BaseInstance"
module.__type = "Frame"
module.__index = module

module.FrameRendering = true
module.ClassIcon = "Engine/Assets/InstanceIcons/Frame.png"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
	self.Name = self.__type

	self:CreateProperty("ZIndex", "number", 0)
	self:CreateProperty("Size", "UDim2", UDim2.new(0, 200, 0, 50))
	self:CreateProperty("Position", "UDim2", UDim2.new(0, 0, 0, 0))
	self:CreateProperty("AnchorPoint", "Vector", Vector.new(0, 0))
	self:CreateProperty("Color", "Color", Color.from255(255, 255, 255, 255))
	self:CreateProperty("Rotation", "number", 0)
	self:CreateProperty("LayoutOrder", "number", 0)
	-- self:CreateProperty("Shader", "any", nil)

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
	local prev = love.graphics.getShader()
	local anchorSize = self.RenderSize * self.AnchorPoint
	local scenePosition = self:GetScene().RenderPosition

	love.graphics.push()
	love.graphics.translate(self.RenderPosition.X+anchorSize.X-scenePosition.X, self.RenderPosition.Y+anchorSize.Y-scenePosition.Y)
	love.graphics.rotate(math.rad(self.RenderRotation))
	love.graphics.setShader(self.Shader)

	return anchorSize, prev
end

function module:DrawFrame()
	self.Color:Apply()

	local anchorSize, prev = self:Translate()
	love.graphics.rectangle("fill", -anchorSize.X, -anchorSize.Y, self.RenderSize.X, self.RenderSize.Y)
	love.graphics.pop()
	love.graphics.setShader(prev)
end

function module:Draw()
	if not self.Enabled then return end
	if self.FrameRendering then
		self:DrawFrame()
	end

	module.Base.Draw(self)
end

function module:GetModifiedSize(size)
	local aspectRatio = self:GetConstraint("AspectRatio")
	local ratio = aspectRatio and aspectRatio.AspectRatio

	local sizeConstraint = self:GetConstraint("Size")
	if sizeConstraint then
		size = Vector.new(math.clamp(size.X, sizeConstraint.Min.X, sizeConstraint.Max.X), math.clamp(size.Y, sizeConstraint.Min.Y, sizeConstraint.Max.Y))
	end

	if ratio then
		local targetWidth = size.Y * ratio
		local targetHeight = size.X / ratio

		if targetWidth <= size.X then
			return Vector.new(targetWidth, size.Y)
		end
		return Vector.new(size.X, targetHeight)
	end

	return size
end

function module:GetPadding()
	local topLeft, bottomRight = Vector.zero, Vector.zero
	
	local padding = self:GetConstraint("Padding")
	if padding then
		topLeft = topLeft + padding.TopLeft
		bottomRight = bottomRight + padding.BottomRight
	end

	return topLeft, bottomRight
end

function module:UpdateRender()
	if _G.LaunchParameters.noGraphics then return end
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
			
			if parentPosition and self.Parent and self.Parent._properties.CanvasPosition then
				parentPosition = parentPosition - self.Parent.CanvasPosition
			end
		end

		if self.Parent and self.Parent.GetPadding and parentPosition then
			local paddingTL, paddingBR = self.Parent:GetPadding()
			parentPosition = parentPosition + paddingTL
			parentSize = parentSize - (paddingBR + paddingTL)
		end

		local listLayout = self.Parent and self.Parent:GetConstraint("List")

		if (parentSize and parentPosition) then
			if listLayout then
				local size, pos, rot = listLayout:Resolve(self, parentSize, parentPosition, parentRotation)
				self.RenderSize = size
				self.RenderPosition = pos
				self.RenderRotation = rot
			else
				self.RenderSize = self:GetModifiedSize(self.Size:Calculate(parentSize))
				self.RenderPosition = parentPosition + self.Position:Calculate(parentSize) - self.RenderSize * self.AnchorPoint
				self.RenderRotation = parentRotation + self.Rotation
			end

			local scale = self:GetConstraint("Scale")
			if scale then
				self.RenderPosition = self.RenderPosition - (self.RenderSize * self.AnchorPoint) * (scale.Scale-1)
				self.RenderSize = self.RenderSize * scale.Scale
			end

			return self.RenderSize, self.RenderPosition, self.RenderRotation
		end
	end
	-- return Vector.new(love.graphics.getDimensions()), Vector.zero, 0
end

return Instance.RegisterClass(module)