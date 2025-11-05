local module = {}
module.Derives = "EditorInstance"
module.__index = module
module.__type = "PropertyFrame"
Instance.RegisterClass(module)

local CellHeight = 20
local existingDropdown

local stringRound = function(value)
	if type(value) == "number" then
		return tostring(math.round(value*1000)/1000)
	end
	return tostring(value)
end

local PropConverters = {
	UDim2 = {
		tostring = function(value)
			return stringRound(value.X.Scale)..", "..tostring(math.round(value.X.Offset))..", "..stringRound(value.Y.Scale)..", "..tostring(math.round(value.Y.Offset))
		end,
		tovalue = function(str)
			local split = string.split(str, ",")

			return UDim2.new(
				tonumber(split[1]) or 0,
				tonumber(split[2]) or 0,
				tonumber(split[3]) or 0,
				tonumber(split[4]) or 0
			)
		end
	},

	Color = {
		tostring = function(value)
			return tostring(math.round(value.R*255))..", "..tostring(math.round(value.G*255))..", "..tostring(math.round(value.B*255))..", "..tostring(math.round(value.A*255))
		end,
		tovalue = function(str)
			local split = string.split(str, ",")

			return Color.new(
				(tonumber(split[1]) or 0)/255,
				(tonumber(split[2]) or 0)/255,
				(tonumber(split[3]) or 0)/255,
				(tonumber(split[4]) or 255)/255
			)
		end
	},
	
	Vector = {
		tostring = function(value)
			return stringRound(value.X)..", "..stringRound(value.Y)
		end,
		tovalue = function(str)
			local split = string.split(str, ",")

			return Vector.new(
				tonumber(split[1]) or 0,
				tonumber(split[2]) or 0
			)
		end
	},
	NumberRange = {
		tostring = function(value)
			return stringRound(value.Min)..", "..stringRound(value.Max)
		end,
		tovalue = function(str)
			local split = string.split(str, ",")

			return NumberRange.new(
				tonumber(split[1]) or 0,
				tonumber(split[2]) or 0
			)
		end
	},
	number = {
		tostring = stringRound,
		tovalue = tonumber,
	},
	string = {
		tostring = tostring,
		tovalue = tostring,
	},
}

module.new = function(propertyName, propertyType)
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	self.PropertyName = propertyName
	self.PropertyType = propertyType

	self.PropertyChanged = self.Maid:Add(Signal.new())

	self.Size = UDim2.new(1, 0, 0, CellHeight)
	self.Color = Color.new(0.1, 0.1, 0.1, 1)

	self.Title = self.Maid:Add(Instance.new("TextLabel"))
	self.Title.Size = UDim2.fromScale(0.5, 1)
	self.Title.Text = propertyName
	self.Title.XAlignment = Enum.TextXAlignment.Left
	self.Title.ZIndex = 1
	self.Title:SetParent(self)

	self.Line = self.Maid:Add(Instance.new("Frame"))
	self.Line.Size = UDim2.new(0, 1, 1, 0)
	self.Line.Position = UDim2.fromScale(0.5, 0.5)
	self.Line.Color = Color.new(0.3, 0.3, 0.3, 1)
	self.Line.AnchorPoint = Vector.one/2
	self.Line:SetParent(self)

	self.InteractArea = self.Maid:Add(Instance.new("Frame"))
	self.InteractArea.Size = UDim2.fromScale(0.5, 1)
	self.InteractArea.Position = UDim2.fromScale(1, 0)
	self.InteractArea.Color = Color.new(0, 0, 0, 0)
	self.InteractArea.AnchorPoint = Vector.xAxis
	self.InteractArea:SetParent(self)

	if propertyType == "boolean" then
		local boolFrame = self.Maid:Add(Instance.new("Button"))
		boolFrame.Size = UDim2.fromOffset(CellHeight, CellHeight)
		boolFrame.Color = Color.new(0, 0, 0, 0)
		boolFrame:SetParent(self.InteractArea)

		local icon = self.Maid:Add(Instance.new("ImageLabel"))
		icon.Position = UDim2.fromScale(0.5, 0.5)
		icon.AnchorPoint = Vector.one/2
		icon.Size = UDim2.fromOffset(20, 20)
		icon:SetParent(boolFrame)

		boolFrame.LeftClicked:Connect(function()
			self:SetValue(not self:GetValue())
		end)

		self.PropertyChanged:Connect(function(newValue)
			if newValue then
				icon.Image = "Editor/Assets/Checkmark.png"
			else
				icon.Image = "Editor/Assets/EmptyCheckBox.png"
			end
		end)
	elseif Enum[propertyType] then
		local button = self.Maid:Add(Instance.new("Button"))
		button.Size = UDim2.fromScale(1, 1)
		button.Color = Color.new(.5, .5, .5, 1)
		button:SetParent(self.InteractArea)

		local textLabel = self.Maid:Add(Instance.new("TextLabel"))
		textLabel.Size = UDim2.fromScale(1, 1)
		textLabel.XAlignment = Enum.TextXAlignment.Left
		textLabel:SetParent(button)
		
		self.PropertyChanged:Connect(function(newValue)
			textLabel.Text = newValue.Name
		end)

		button.LeftClicked:Connect(function()
			if existingDropdown then
				existingDropdown:Destroy()
				existingDropdown = nil
			end
			
			local enumAsList = {}
			for name, enumItem in pairs(Enum[propertyType]) do
				enumAsList[enumItem.Value] = name
			end
			local dropdown = Instance.new("Dropdown", enumAsList)
			dropdown.AnchorPoint = Vector.xAxis
			dropdown.Position = UDim2.fromOffset(button.RenderPosition.X, button.RenderPosition.Y)
			dropdown:SetParent(EditorScene)
			dropdown.Enabled = true
			dropdown.ValueSelected:Connect(function(value)
				self:SetValue(Enum[propertyType][value])
			end)
			existingDropdown = dropdown
		end)
	elseif PropConverters[propertyType] then
		local textbox = self.Maid:Add(Instance.new("TextBox"))
		textbox.Size = UDim2.fromScale(1, 1)
		textbox.XAlignment = Enum.TextXAlignment.Left
		textbox:SetParent(self.InteractArea)

		textbox.FocusLost:Connect(function()
			local value = PropConverters[propertyType].tovalue(textbox.Text)
			self:SetValue(value)
		end)

		self.PropertyChanged:Connect(function(newValue)
			textbox.Text = PropConverters[propertyType].tostring(newValue)
		end)
	end

	return self
end

function module:GetValue()
	return self.Value
end

function module:SetValue(newValue)
	self.Value = newValue
	self.PropertyChanged:Fire(newValue)
end

return module