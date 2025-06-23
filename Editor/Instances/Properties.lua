local module = {}
module.Derives = "Widget"
module.__index = module
module.__type = "Properties"
Instance.RegisterClass(module)

local Selection = Game:GetService("Selection")

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self:SetTitle("Properties")

	self.Name = "Properties"
	self.List = self.Maid:Add(Instance.new("ScrollingFrame"))
	self.List.Size = UDim2.new(1, 0, 1, 0)
	self.List.Color = Color.new(0,0,0,0)
	self.List.Name = "List"
	self:AttachGui(self.List)
	self.PropertyFrames = {}

	self.Layout = self.Maid:Add(Instance.new("UIListLayout"))
	self.Layout.Padding = UDim2.fromOffset(0, 0)
	self.Layout.Parent = self.List

	self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function(size)
		self.List.CanvasSize = UDim2.fromOffset(size.X or 0, size.Y or 0)
	end)

	local Selection = Game:GetService("Selection")
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


	local propsToShow = {}
	for _, object in ipairs(Selection:Get()) do
		for propName, info in pairs(object._properties) do
			propsToShow[propName] = {
				PropType = info.PropType,
				Value = object[propName],
			}
		end
	end


	for propName, info in pairs(propsToShow) do
		local newFrame = Instance.new("PropertyFrame", propName, info.PropType)
		newFrame.Parent = self.List
		newFrame:SetValue(info.Value)
		self.PropertyFrames[propName] = newFrame

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