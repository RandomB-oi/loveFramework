local module = {}
module.Base = require("Classes.Instances.Frame")
module.__index = module
module.__type = "TextLabel"
setmetatable(module, module.Base)

local DefaultFont = love.graphics.newFont(64,"normal")

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	self.Text = ""
	self.Font = nil -- you can set it as a font if you want
	self.TextStretch = false
	self.XAlignment = "center"
	self.YAlignment = "center"

	return self
end

function module:Update(dt)
	if self._text ~= self.Text or self._font ~= self.Font then
		self._text = self.Text
		self._font = self.Font
		self._textObject = love.graphics.newText(self.Font or DefaultFont, self.Text)

		self._changed = true
	end

	module.Base.Update(self, dt)
end

function module:Draw()
	self.Color:Apply()

	love.graphics.cleanDrawText(self._textObject, self.RenderPosition, self.RenderSize, self.TextStretch, self.XAlignment, self.YAlignment)
	
	-- love.graphics.rectangle("fill", self.RenderPosition.X, self.RenderPosition.Y, self.RenderSize.X, self.RenderSize.Y)

	module.Base.Draw(self)
end

return module