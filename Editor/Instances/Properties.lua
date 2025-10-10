local module = {}
module.Derives = "Widget"
module.__index = module
module.__type = "Properties"
Instance.RegisterClass(module)

local Selection = Engine:GetService("Selection")

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self:SetTitle("Properties")

	self.Name = "Properties"
	self.List = self.Maid:Add(Instance.new("ScrollingFrame"))
	self.List.Size = UDim2.new(1, 0, 1, 0)
	self.List.Color = Color.new(0,0,0,0)
	self.List.Name = "List"
	self:AttachGui(self.List)

	do
		self.PropertyFrames = {}
		self.PropertiesList = Instance.new("Frame")
		self.PropertiesList.Color = Color.new(0,0,0,0)
		self.PropertiesList:SetParent(self.List)
		
		local layout = self.Maid:Add(Instance.new("UIListLayout"))
		layout.SortMode = Enum.SortMode.Name
		layout.Padding = UDim2.fromOffset(0, 0)
		layout:SetParent(self.PropertiesFrame)

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function(size)
			self.PropertiesList.Size = UDim2.fromOffset(size.X or 0, size.Y or 0)
		end)


	end

	do
		local layout = self.Maid:Add(Instance.new("UIListLayout"))
		layout.SortMode = Enum.SortMode.Name
		layout.Padding = UDim2.fromOffset(0, 0)
		layout:SetParent(self.List)

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function(size)
			self.List.CanvasSize = UDim2.fromOffset(size.X or 0, size.Y or 0)
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
end

return module