local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "PropertyFrame"
Instance.RegisterClass(module)

local CellHeight = 20

module.new = function(propertyName, propertyType)
	local self = setmetatable(module.Base.new(), module)

	self.Name = "PropertyFrame"
	self.PropertyName = propertyName
	self.PropertyType = propertyType

	self.PropertyChanged = self.Maid:Add(Signal.new())

	self.Size = UDim2.new(1, 0, 0, CellHeight)
	self.Color = Color.new(0.1, 0.1, 0.1, 1)

	self.Title = self.Maid:Add(Instance.new("TextLabel"))
	self.Title.Size = UDim2.fromScale(0.5, 1)
	self.Title.Text = propertyName
	self.Title.XAlignment = "left"
	self.Title.ZIndex = 1
	self.Title.Parent = self

	self.Line = self.Maid:Add(Instance.new("Frame"))
	self.Line.Size = UDim2.new(0, 1, 1, 0)
	self.Line.Position = UDim2.fromScale(0.5, 0.5)
	self.Line.Color = Color.new(0.3, 0.3, 0.3, 1)
	self.Line.AnchorPoint = Vector.one/2
	self.Line.Parent = self

	self.InteractArea = self.Maid:Add(Instance.new("Frame"))
	self.InteractArea.Size = UDim2.fromScale(0.5, 1)
	self.InteractArea.Position = UDim2.fromScale(1, 0)
	self.InteractArea.Color = Color.new(0, 0, 0, 0)
	self.InteractArea.AnchorPoint = Vector.xAxis
	self.InteractArea.Parent = self

	if propertyType == "boolean" then
		local boolFrame = self.Maid:Add(Instance.new("Button"))
		boolFrame.Size = UDim2.fromOffset(CellHeight, CellHeight)
		boolFrame.Color = Color.new(0, 0, 0, 0)
		boolFrame.Parent = self.InteractArea

		local icon = self.Maid:Add(Instance.new("ImageLabel"))
		icon.Position = UDim2.fromScale(0.5, 0.5)
		icon.AnchorPoint = Vector.one/2
		icon.Size = UDim2.fromOffset(20, 20)
		icon.Parent = boolFrame

		boolFrame.Activated:Connect(function()
			self:SetValue(not self:GetValue())
		end)

		self.PropertyChanged:Connect(function(newValue)
			if newValue then
				icon.Image = "Editor/Assets/Checkmark.png"
			else
				icon.Image = "Editor/Assets/EmptyCheckBox.png"
			end
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