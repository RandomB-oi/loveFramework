local module = {}
module.Base = require("Classes.Instances.GUI.Frame")
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
		if self._textObject then
			self._textObject:release()
			self._textObject = nil
		end
		self._textObject = love.graphics.newText(self.Font or DefaultFont, self.Text)

		self._changed = true
	end

	module.Base.Update(self, dt)
end

function module:Draw()
	if not self.Visible then return end
	self.Color:Apply()

	local anchorSize = self:Translate()
	love.graphics.cleanDrawText(self._textObject, -anchorSize, self.RenderSize, self.TextStretch, self.XAlignment, self.YAlignment)
	love.graphics.pop()

	module.Base.Draw(self)
end

return Instance.RegisterClass(module)