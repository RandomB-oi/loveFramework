local module = {}
module.Base = require("Classes.Instances.Frame")
module.__index = module
module.__type = "Button"
setmetatable(module, module.Base)

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	self.Activated = self.Maid:Add(Signal.new())
	self.Maid:GiveTask(GuiInputBegan:Connect(function(input)
		if input == 1 then
			local scene = self:GetScene()

			if self._hovering and scene.Enabled and not scene.IsPaused then
				self.Activated:Fire()
				_GP = true
			end
		end
	end))

	return self
end

function module:Update(dt)
	local mouseX, mouseY = love.mouse.getPosition()
	local hovering = mouseX >= self.RenderPosition.X and mouseX <= self.RenderPosition.X + self.RenderSize.X and mouseY >= self.RenderPosition.Y and mouseY <= self.RenderPosition.Y + self.RenderSize.Y
	if self._hovering ~= hovering then
		self._hovering = hovering
		self._changed = true
	end

	module.Base.Update(self, dt)
end

function module:Draw()
	if self._hovering then
		(self.Color-Color.new(.2,.2,.2,0)):Apply()
	else
		self.Color:Apply()
	end
	love.graphics.rectangle("fill", self.RenderPosition.X, self.RenderPosition.Y, self.RenderSize.X, self.RenderSize.Y)

	module.Base.Draw(self)
end

return module