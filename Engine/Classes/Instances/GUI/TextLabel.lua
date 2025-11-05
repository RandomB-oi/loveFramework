local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "TextLabel"
Instance.RegisterClass(module)

local DefaultFont = love.graphics.newFont("Engine/Assets/Fonts/FiraMonoTypewriter-text-regular.ttf", 64)
-- local DefaultFont = love.graphics.newFont(64, "normal")

module.FrameRendering = false
module.ClassIcon = "Engine/Assets/InstanceIcons/TextLabel.png"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	self:CreateProperty("Text", "string", "Text")
	self:CreateProperty("Font", nil, nil)
	self:CreateProperty("TextStretch", "boolean", false)

	self:CreateProperty("XAlignment", "TextXAlignment", Enum.TextXAlignment.Center)
	self:CreateProperty("YAlignment", "TextYAlignment", Enum.TextYAlignment.Center)

	self:GetPropertyChangedSignal("Text"):Connect(function()
		self:UpdateText()
	end)
	self:GetPropertyChangedSignal("Font"):Connect(function()
		self:UpdateText()
	end)
	self:UpdateText()

	return self
end

function module:GetDesiredText()
	return self.Text
end

function module:UpdateText()
	local text = self:GetDesiredText()
	if (self._currentText == text and self._currentFont == self.Font) then
		return
	end
	self._currentFont = self.Font
	self._currentText = text

	if self._textObject then
		self._textObject:release()
		self._textObject = nil
	end

	self._textObject = love.graphics.newText(self.Font or DefaultFont, text)
end

function module:Draw()
	if not self.Enabled then return end

	if self._textObject then
		self.Color:Apply()

		local anchorSize = self:Translate()
		love.graphics.cleanDrawText(self._textObject, -anchorSize, self.RenderSize, self.TextStretch, self.XAlignment, self.YAlignment)
		love.graphics.pop()
	end

	module.Base.Draw(self)
end

return module