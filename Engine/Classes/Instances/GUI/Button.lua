local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "Button"
Instance.RegisterClass(module)

module.FrameRendering = false
module.ClassIcon = "Engine/Assets/InstanceIcons/ImageButton.png"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	self.Activated = self.Maid:Add(Signal.new())

	self.Maid:GiveTask(Game:GetService("InputService").InputBegan:Connect(function(input)
		if input.MouseButton == Enum.MouseButton.MouseButton1 then
			local scene = self:GetScene()
			
			if self._hovering and scene.Enabled and not scene.IsPaused then
				self.Activated:Fire()
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
	if not self.Visible then return end
	if self._hovering then
		(self.Color-Color.new(.2,.2,.2,0)):Apply()
	else
		self.Color:Apply()
	end
	love.graphics.rectangle("fill", self.RenderPosition.X, self.RenderPosition.Y, self.RenderSize.X, self.RenderSize.Y)

	module.Base.Draw(self)
end

return module