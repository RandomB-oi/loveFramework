local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "ExplorerObject"
Instance.RegisterClass(module)

local CellHeight = 20

module.new = function(object, depth)
	if object:IsA("ExplorerObject") then return end

	local self = setmetatable(module.Base.new(), module)

	self.Name = "ExplorerObject"
	self.Object = object
	self.Depth = depth or 0

	self.Size = UDim2.new(1, 0, 0, CellHeight)
	self.Color = Color.from255(30, 30, 30, 255)

	self.ToggleButton = self.Maid:Add(Instance.new("Button"))
	self.ToggleButton.Size = UDim2.fromOffset(CellHeight, CellHeight)
	self.ToggleButton.Color = Color.new(0, 0, 0, 0)
	self.ToggleButton.Parent = self

	self.ToggleButtonImage = self.Maid:Add(Instance.new("ImageLabel"))
	self.ToggleButtonImage.Size = UDim2.fromOffset(16,16)
	self.ToggleButtonImage.Position = UDim2.fromScale(0.5, 0.5)
	self.ToggleButtonImage.AnchorPoint = Vector.new(0.5, 0.5)
	self.ToggleButtonImage.Parent = self.ToggleButton

	self.Title = self.Maid:Add(Instance.new("TextLabel"))
	self.Title.Size = UDim2.new(1, -CellHeight*2, 0, CellHeight)
	self.Title.Position = UDim2.new(0, CellHeight*2, 0, 0)
	self.Title.Text = object.Name
	self.Title.XAlignment = "left"
	self.Title.Parent = self

	self.Line = self.Maid:Add(Instance.new("Frame"))
	self.Line.Size = UDim2.new(0, 1, 1, -CellHeight)
	self.Line.Position = UDim2.new(0, CellHeight/2, 0, CellHeight)
	self.Line.Color = Color.new(.2,.2,.2, 1)
	self.Line.Parent = self

	self.Icon = self.Maid:Add(Instance.new("ImageLabel"))
	self.Icon.Size = UDim2.fromOffset(16, 16)
	self.Icon.AnchorPoint = Vector.one/2
	self.Icon.Position = UDim2.new(0, CellHeight+CellHeight/2, 0, CellHeight/2)
	self.Icon.Text = object.Name
	self.Icon.Parent = self
	self.Icon.Image = object.ClassIcon

	self.ChildrenList = self.Maid:Add(Instance.new("Frame"))
	self.ChildrenList.Position = UDim2.new(0, CellHeight, 0, CellHeight)
	self.ChildrenList.Color = Color.new(0,0,0,0)
	self.ChildrenList.Parent = self
	self.ChildrenList.Visible = false

	self.Layout = self.Maid:Add(Instance.new("UIListLayout"))
	self.Layout.Padding = UDim2.new(0, 0, 0, 3)
	self.Layout.Parent = self.ChildrenList

	self.ToggleButton.Activated:Connect(function()
		self.ChildrenList.Visible = not self.ChildrenList.Visible
	end)

	self.Maid:GiveTask(self.Object:GetPropertyChangedSignal("Name"):Connect(function()
		self.Title.Text = object.Name
	end))

	self.Maid:GiveTask(self.Object.ChildAdded:Connect(function(newChild)
		self:NewChild(newChild)
	end))
	for _, child in ipairs(self.Object:GetChildren()) do
		self:NewChild(child)
	end

	local first
	self.Maid:GiveTask(self.Object.AncestryChanged:Connect(function()
		if not first then
			first = true
			return
		end
		self:Destroy()
	end))

	self.ScaleChanged = self.Maid:Add(Signal.new())
	self.ChildrenList:GetPropertyChangedSignal("Visible"):Connect(function(visible)
		self:UpdateScales()
	end)
	self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function(visible)
		self:UpdateScales()
	end)

	return self
end

function module:CalculateDeepestDepth(depth)
	local depth = self.Depth

	for _, child in ipairs(self:GetChildren(true)) do
		if child.Depth then
			depth = math.max(child.Depth, depth)
		end
	end

	return depth
end

function module:UpdateScales()
	local height = self.Layout.AbsoluteContentSize.Y
	self.ChildrenList.Size = UDim2.new(1, 0, 0, height)

	if not self.ChildrenList.Visible then
		height = 0
	end

	local deepestDepth = self:CalculateDeepestDepth()
	self.Size = UDim2.new(1, (deepestDepth - self.Depth) * CellHeight, 0, CellHeight+height)
end

function module:Update(dt)
	module.Base.Update(self, dt)

	if next(self.Object._children) then
		self.ToggleButton.Visible = true
	else
		self.ToggleButton.Visible = false
		self.ChildrenList.Visible = false
	end

	if self.ChildrenList.Visible then
		self.ToggleButtonImage.Image = "Editor/Assets/Expanded.png"
	else
		self.ToggleButtonImage.Image = "Editor/Assets/Collapsed.png"
	end
end

function module:NewChild(child)
	local newFrame = Instance.new("ExplorerObject", child, self.Depth + 1)
	if not newFrame then return end
	newFrame.Parent = self.ChildrenList
	newFrame.ScaleChanged:Connect(function()
		self:UpdateScales()
	end)
end

return module