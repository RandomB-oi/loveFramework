local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "Button"

module.FrameRendering = false
module.ClassIcon = "Engine/Assets/InstanceIcons/ImageButton.png"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
	self.Name = self.__type

	self.LeftClicked = self.Maid:Add(Signal.new())
	self.RightClicked = self.Maid:Add(Signal.new())

	self.Maid:GiveTask(Engine:GetService("InputService").InputBegan:Connect(function(input)
		if input.MouseButton == Enum.MouseButton.MouseButton1 or input.MouseButton == Enum.MouseButton.MouseButton2 then
			local scene = self:GetScene()
			if not scene then return end
			
			if self._hovering and scene.Enabled and not scene.Paused and self:IsEnabled() then
				if input.MouseButton == Enum.MouseButton.MouseButton1 then
					self.LeftClicked:Fire()
				elseif input.MouseButton == Enum.MouseButton.MouseButton2 then
					self.RightClicked:Fire()
				end
			end
		end
	end))

	return self
end

function module:Update(dt)
	local hovering = self:MouseHovering()
	if self._hovering ~= hovering then
		self._hovering = hovering
		self._changed = true
	end

	module.Base.Update(self, dt)
end

function module:Draw()
	if not self.Enabled then return end
	if self._hovering then
		(self.Color-Color.new(.2,.2,.2,0)):Apply()
	else
		self.Color:Apply()
	end
	local renderPosition = self.RenderPosition - self:GetScene().RenderPosition
	love.graphics.rectangle("fill", renderPosition.X, renderPosition.Y, self.RenderSize.X, self.RenderSize.Y)

	module.Base.Draw(self)
end

return Instance.RegisterClass(module)