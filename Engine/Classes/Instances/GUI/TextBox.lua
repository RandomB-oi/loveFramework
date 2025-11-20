local module = {}
module.Derives = "TextLabel"

module.__type = "TextBox"

module.FrameRendering = false
module.ClassIcon = "Engine/Assets/InstanceIcons/TextBox.png"

local UpperReplace = {
    ["1"] = "!",
    ["2"] = "@",
    ["3"] = "#",
    ["4"] = "$",
    ["5"] = "%",
    ["6"] = "^",
    ["7"] = "&",
    ["8"] = "*",
    ["9"] = "(",
    ["0"] = ")",
    ["["] = "{",
    ["]"] = "}",
    [";"] = ":",
    ["'"] = '"',
    [","] = "<",
    ["."] = ">",
    ["/"] = "?",
    ["-"] = "_",
    ["="] = "+",
    ["`"] = "~",
}

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type

	local InputService = Engine:GetService("InputService")

	self:CreateProperty("PlaceholderText", "string", "")
	self:CreateProperty("CursorPosition", "number", -1)

	self.Focused = false
	self.FocusLost = self.Maid:Add(Signal.new())

	self.Maid:GiveTask(InputService.InputBegan:Connect(function(input)
		if input.MouseButton == Enum.MouseButton.MouseButton1 then
			if self:MouseHovering() then
				self.CursorPosition = self.Text:len()+1
				self.Focused = true
			else
				self:ReleaseFocus()
			end
		end
		
		if not self.Focused then return end
		if not input.KeyCode then return end
		
		if input.KeyCode == Enum.KeyCode.Return then
			self:ReleaseFocus()
		elseif input.KeyCode == Enum.KeyCode.Left then
			self:MoveCursor(-1)
		elseif input.KeyCode == Enum.KeyCode.Right then
			self:MoveCursor(1)
		elseif input.KeyCode == Enum.KeyCode.End then
			self:SetCursor(self.Text:len()+1)
		elseif input.KeyCode == Enum.KeyCode.Home then
			self:SetCursor(0)
		elseif input.KeyCode == Enum.KeyCode.Backspace then
			self:SubChar(1)
		elseif input.KeyCode == Enum.KeyCode.Space then
			self.Text = self.Text.." "
		else
			local keyText = input.KeyCode.ScanCode
			
			if InputService:IsKeyPressed(Enum.KeyCode.LeftShift) or InputService:IsKeyPressed(Enum.KeyCode.RightShift) then
				keyText = UpperReplace[keyText] or keyText:upper()
			end
			if keyText:len() > 1 then return end

			self:AddChar(keyText)
		end
	end))

	self:GetPropertyChangedSignal("PlaceholderText"):Connect(function()
		self:UpdateText()
	end)
	self:GetPropertyChangedSignal("CursorPosition"):Connect(function()
		self:UpdateText()
	end)

	return self
end

function module:SetCursor(value)
	self.CursorPosition = math.clamp(value, 1, self.Text:len()+1)
end

function module:MoveCursor(amount)
	self:SetCursor(self.CursorPosition + amount)
end

function module:SubChar(amount)
	local splitText = string.toArray(self.Text)
	for i = self.CursorPosition-1, (self.CursorPosition - amount), -1 do
		if splitText[i] then
			table.remove(splitText, i)
		end
	end
	self.Text = table.concat(splitText, "")
	self:MoveCursor(-amount)
end

function module:AddChar(char)
	local splitText = string.toArray(self.Text)
	table.insert(splitText, self.CursorPosition, char)
	self.Text = table.concat(splitText, "")
	self:MoveCursor(char:len())
end

function module:ReleaseFocus()
	if self.Focused then
		self.Focused = false
		self.CursorPosition = -1
		self.FocusLost:Fire()
	end
end

function module:GetDesiredText()
	if self.Focused and self.CursorPosition ~= -1 then
		local splitText = string.toArray(self.Text)
		table.insert(splitText, self.CursorPosition, "|")
		return table.concat(splitText, "")
	end
	if self.Text == "" then
		return self.PlaceholderText
	end
	return self.Text
end

function module:Draw()
	if not self.Enabled then return end

	if self.Focused then
		love.graphics.drawOutline(self.RenderPosition - self:GetScene().RenderPosition, self.RenderSize)
	end

	module.Base.Draw(self)
end


return Instance.RegisterClass(module)