local module = {}
module.Derives = "Widget"

module.__type = "Properties"

local Selection = Engine:GetService("Selection")

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type
	
	self:SetTitle("Properties")

	self.List = self.Maid:Add(Instance.new("ScrollingFrame"))
	self.List.Size = UDim2.new(1, 0, 1, 0)
	self.List.Color = Color.new(0,0,0,0)
	self.List.Name = "List"
	self:AttachGui(self.List)

	do
		local layout = self.Maid:Add(Instance.new("UIListLayout"))
		-- layout.SortMode = Enum.SortMode.Name
		layout.Padding = UDim2.fromOffset(0, 12)
		layout:SetParent(self.List)

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function(size)
			self.List.CanvasSize = UDim2.fromOffset(size.X or 0, size.Y or 0)
		end)
	end

	do
		self.PropertyFrames = {}
		self.PropertiesList = Instance.new("Frame")
		self.PropertiesList.Color = Color.new(0,0,0,0)
		self.PropertiesList.LayoutOrder = 1
		self.PropertiesList:SetParent(self.List)
		
		local layout = self.Maid:Add(Instance.new("UIListLayout"))
		layout.SortMode = Enum.SortMode.Name
		layout.Padding = UDim2.fromOffset(0, 0)
		layout:SetParent(self.PropertiesList)

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function(size)
			self.PropertiesList.Size = UDim2.new(1, 0, 0, size.Y or 0)
		end)
	end

	do
		self.AttributeFrames = {}
		self.AttributesList = Instance.new("Frame")
		self.AttributesList.Color = Color.new(0,0,0,0)
		self.AttributesList.LayoutOrder = 2
		self.AttributesList:SetParent(self.List)
		
		local layout = self.Maid:Add(Instance.new("UIListLayout"))
		layout.SortMode = Enum.SortMode.Name
		layout.Padding = UDim2.fromOffset(0, 0)
		layout:SetParent(self.AttributesList)

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function(size)
			self.AttributesList.Size = UDim2.new(1, 0, 0, size.Y or 0)
		end)
	end

	local Selection = Engine:GetService("Selection")
	self.Maid:GiveTask(Selection.SelectionChanged:Connect(function()
		self:UpdateProperties()
	end))
	self:UpdateProperties()


	return self
end

function module:UpdateProperties()
	for propName, frame in pairs(self.PropertyFrames) do
		frame:Destroy()
		self.PropertyFrames[propName] = nil
	end
	for propName, frame in pairs(self.AttributeFrames) do
		frame:Destroy()
		self.AttributeFrames[propName] = nil
	end

	local object = Selection:Get()[1]
	if not object then return end

	for propName, info in pairs(object._properties) do
		local newFrame = Instance.new("PropertyFrame", propName, info.PropType)
		newFrame.Name = propName
		newFrame:SetParent(self.PropertiesList)
		newFrame:SetValue(object[propName])
		self.PropertyFrames[propName] = newFrame

		newFrame.Maid:GiveTask(object:GetPropertyChangedSignal(propName):Connect(function()
			newFrame:SetValue(object[propName])
		end))

		newFrame.PropertyChanged:Connect(function(newValue)
			for _, object in ipairs(Selection:Get()) do
				if object._properties[propName] then
					object[propName] = newValue
				end
			end
		end)
	end

	for attribute, value in pairs(object:GetAttributes()) do
		local newFrame = Instance.new("PropertyFrame", attribute, typeof(value))
		newFrame.Name = attribute
		newFrame:SetParent(self.AttributesList)
		newFrame:SetValue(value)
		self.AttributeFrames[attribute] = newFrame

		newFrame.Maid:GiveTask(object:GetAttributeChangedSignal(attribute):Connect(function()
			newFrame:SetValue(object:GetAttribute(attribute))
		end))

		newFrame.PropertyChanged:Connect(function(newValue)
			for _, object in ipairs(Selection:Get()) do
				object:SetAttribute(attribute, newValue)
			end
		end)
	end

	
	-- local addAttributeButton = Instance.new("Button")
	-- addAttributeButton:SetParent(self.AttributesList)
	-- addAttributeButton.Name = "!!!!!"
	-- addAttributeButton.Size = UDim2.new(1,0,0, 20)
	-- addAttributeButton.Color = Color.new(.1,.1,.1,1)
	-- self.AttributeFrames[addAttributeButton] = addAttributeButton

	
	-- local textLabel = self.Maid:Add(Instance.new("TextLabel"))
	-- textLabel.Size = UDim2.new(1, 0, 1, 0)
	-- textLabel.Position = UDim2.new(0, 0, 0, 0)
	-- textLabel.Text = "Add Attribute"
	-- textLabel:SetParent(addAttributeButton)
end

return Instance.RegisterClass(module)