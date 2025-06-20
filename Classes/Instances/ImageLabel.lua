local module = {}
module.Base = require("Classes.Instances.Frame")
module.__index = module
module.__type = "ImageLabel"
setmetatable(module, module.Base)

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	self.Image = ""

	return self
end

function module:Update(dt)
	if self._image ~= self.Image then
		self._image = self.Image

		if self._imageObject then
			self._imageObject:release()
			self._imageObject = nil
		end

		if self._image and self._image ~= "" then
			self._imageObject = love.graphics.newImage(self._image)
		end

		self._changed = true
	end

	module.Base.Update(self, dt)
end

function module:Draw()
	self.Color:Apply()
	love.graphics.cleanDrawImage(self._imageObject, self.RenderPosition, self.RenderSize)

	module.Base.Draw(self)
end

return Instance.RegisterClass(module)