local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "ScrollingFrame"
Instance.RegisterClass(module)

module.FrameRendering = false
module.ClassIcon = "Engine/Assets/InstanceIcons/ScrollingFrame.png"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	self.Canvas = nil
	self:CreateProperty("CanvasPosition", "Vector", Vector.zero)
	self:CreateProperty("CanvasSize", "UDim2", UDim2.new(0,0, 0,0))

	self.RenderCanvasSize = Vector.zero

	local InputService = Engine:GetService("InputService")
	self.Maid:Add(InputService.Scrolled:Connect(function(dir)
		if not (self:MouseHovering() and self:IsVisible()) then return end
		local horizontal = InputService:IsKeyPressed(Enum.KeyCode.LeftShift) or InputService:IsKeyPressed(Enum.KeyCode.RightShift)
		local scrollAxis = horizontal and Vector.xAxis or Vector.yAxis
		task.spawn(function()
			for i = 1, 3 do
				self.CanvasPosition = self.CanvasPosition - scrollAxis*(dir*10)
				task.wait()
			end
		end)
	end))

	return self
end

function module:Update(dt)
	local canvasX, canvasY
	if self.Canvas then
		canvasX, canvasY = self.Canvas:getPixelDimensions()
		canvasX = math.round(canvasX)
		canvasY = math.round(canvasY)
	end
	
	local solvedCanvasSize = self.CanvasSize:Calculate(self.RenderSize)
	self.RenderCanvasSize = Vector.new(math.max(self.RenderSize.X, solvedCanvasSize.X), math.max(self.RenderSize.Y, solvedCanvasSize.Y))
	self.CanvasPosition = Vector.new(
		math.clamp(self.CanvasPosition.X, 0, self.RenderCanvasSize.X-self.RenderSize.X),
		math.clamp(self.CanvasPosition.Y, 0, self.RenderCanvasSize.Y-self.RenderSize.Y)
	)
	
	if math.round(self.RenderSize.X) ~= canvasX or math.round(self.RenderSize.Y) ~= canvasY then
		if self.Canvas then
			self.Canvas:release()
			self.Canvas = nil
		end

		if self.RenderSize:Length() > 0.1 and self.RenderSize.X > 0 and self.RenderSize.Y > 0 then
			self.Canvas = love.graphics.newCanvas(self.RenderSize.X, self.RenderSize.Y)
		end
	end

	module.Base.Update(self, dt)
end

function module:Draw()
	if not self.Visible then return end
	self.Color:Apply()

	if not self.Canvas then return end

	local prevCanvas = love.graphics.getCanvas()

	love.graphics.setCanvas(self.Canvas)
	love.graphics.clear()
	love.graphics.push()
	love.graphics.translate(-self.RenderPosition.X, -self.RenderPosition.Y)

	module.Base.Draw(self)
	
	love.graphics.pop()
	Color.White:Apply()
	love.graphics.setCanvas(prevCanvas)
	love.graphics.cleanDrawImage(self.Canvas, self.RenderPosition, self.RenderSize)

	local scrollbarThickness = 12
	if self.RenderSize.Y ~= self.RenderCanvasSize.Y then
		local scrollPercent = self.CanvasPosition.Y/(self.RenderCanvasSize.Y-self.RenderSize.Y)
		local scrollbarHeight = self.RenderSize.Y * (self.RenderSize.Y/self.RenderCanvasSize.Y)

		love.graphics.rectangle("fill",
			self.RenderPosition.X + self.RenderSize.X - scrollbarThickness,
			self.RenderPosition.Y +  (self.RenderSize.Y - scrollbarHeight) * scrollPercent,
			scrollbarThickness,
			scrollbarHeight
		)
	end
	if self.RenderSize.X ~= self.RenderCanvasSize.X then
		local scrollPercent = self.CanvasPosition.X/(self.RenderCanvasSize.X-self.RenderSize.X)
		local scrollbarHeight = self.RenderSize.X * (self.RenderSize.X/self.RenderCanvasSize.X)

		love.graphics.rectangle("fill",
		self.RenderPosition.X +  (self.RenderSize.X - scrollbarHeight) * scrollPercent,
		self.RenderPosition.Y + self.RenderSize.Y - scrollbarThickness,
			scrollbarHeight,
			scrollbarThickness
		)
	end
end

return module