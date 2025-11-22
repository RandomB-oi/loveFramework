local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "ImageLabel"

module.FrameRendering = false
module.ClassIcon = "Engine/Assets/InstanceIcons/ImageLabel.png"


module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
	self.Name = self.__type

	self:CreateProperty("Image", "string", "")

	self:GetPropertyChangedSignal("Image"):Connect(function(newImage)
		if _G.LaunchParameters.noGraphics then return end
		if newImage then
			self._imageObject = love.graphics.newImage(newImage)
		end
		self._changed = true
	end)

	return self
end
function module:Draw()
	if not self.Enabled then return end
	self.Color:Apply()
	if self._imageObject then
		local anchorSize, prev = self:Translate()
		love.graphics.cleanDrawImage(self._imageObject, -anchorSize, self.RenderSize)
		love.graphics.pop()
		love.graphics.setShader(prev)
	end

	module.Base.Draw(self)
end

return Instance.RegisterClass(module)