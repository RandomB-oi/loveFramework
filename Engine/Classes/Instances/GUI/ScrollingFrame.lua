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
	self:CreateProperty("ScrollbarColor", "Color", Color.White)
	self:CreateProperty("CanvasColor", "Color", Color.White)
	self:CreateProperty("ScrollbarThickness", "number", 12, "Int")
	self:CreateProperty("ScrollbarPadding", "ScrollbarPadding", Enum.ScrollbarPadding.Never)
	self:CreateProperty("HorizontalScrollbarSide", "LateralDirection", Enum.LateralDirection.Right)
	self:CreateProperty("VerticalScrollbarSide", "VerticalDirection", Enum.VerticalDirection.Bottom)
	
	self.RenderCanvasSize = Vector.zero

	local InputService = Engine:GetService("InputService")
	self.Maid:Add(InputService.Scrolled:Connect(function(dir)
		if not (self:MouseHovering() and self:IsEnabled()) then return end
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

function module:GetPadding()
	local add, sub = module.Base.GetPadding(self)

	if self.ScrollbarPadding == Enum.ScrollbarPadding.Scrollbar and self.RenderSize.Y ~= self.RenderCanvasSize.Y or self.ScrollbarPadding == Enum.ScrollbarPadding.Always then
		if self.HorizontalScrollbarSide == Enum.LateralDirection.Left then
			add = add + Vector.new(self.ScrollbarThickness, 0)
		else
			sub = sub + Vector.new(self.ScrollbarThickness, 0)
		end
	end

	if self.ScrollbarPadding == Enum.ScrollbarPadding.Scrollbar and self.RenderSize.X ~= self.RenderCanvasSize.X or self.ScrollbarPadding == Enum.ScrollbarPadding.Always then
		if self.VerticalScrollbarSide == Enum.LateralDirection.Top then
			add = add + Vector.new(0, self.ScrollbarThickness)
		else
			sub = sub + Vector.new(0, self.ScrollbarThickness)
		end
	end

	return add, sub
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
	if not self.Enabled then return end
	self:DrawFrame()

	if not self.Canvas then return end

	local prevCanvas = love.graphics.getCanvas()

	love.graphics.setCanvas(self.Canvas)
	love.graphics.clear()
	love.graphics.push()
	local renderPosition = self.RenderPosition - self:GetScene().RenderPosition
	love.graphics.translate(-renderPosition.X, -renderPosition.Y)

	module.Base.Draw(self)
	
	love.graphics.pop()
	self.CanvasColor:Apply()
	love.graphics.setCanvas(prevCanvas)
	love.graphics.cleanDrawImage(self.Canvas, renderPosition, self.RenderSize)

	self.ScrollbarColor:Apply()
	if self.RenderSize.Y ~= self.RenderCanvasSize.Y then
		local scrollPercent = self.CanvasPosition.Y/(self.RenderCanvasSize.Y-self.RenderSize.Y)
		local scrollbarHeight = self.RenderSize.Y * (self.RenderSize.Y/self.RenderCanvasSize.Y)
		local scrollbarPosition = self.HorizontalScrollbarSide == Enum.LateralDirection.Left and 0 or self.RenderSize.X - self.ScrollbarThickness

		love.graphics.rectangle("fill",
			renderPosition.X + scrollbarPosition,
			renderPosition.Y + (self.RenderSize.Y - scrollbarHeight) * scrollPercent,
			self.ScrollbarThickness,
			scrollbarHeight
		)
	end
	if self.RenderSize.X ~= self.RenderCanvasSize.X then
		local scrollPercent = self.CanvasPosition.X/(self.RenderCanvasSize.X-self.RenderSize.X)
		local scrollbarHeight = self.RenderSize.X * (self.RenderSize.X/self.RenderCanvasSize.X)
		local scrollbarPosition = self.VerticalScrollbarSide == Enum.VerticalDirection.Top and 0 or self.RenderSize.Y - self.ScrollbarThickness

		love.graphics.rectangle("fill",
		renderPosition.X + (self.RenderSize.X - scrollbarHeight) * scrollPercent,
		renderPosition.Y + scrollbarPosition,
			scrollbarHeight,
			self.ScrollbarThickness
		)
	end
end

return module