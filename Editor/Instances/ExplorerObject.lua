local module = {}
module.Derives = "EditorInstance"
module.__index = module
module.__type = "ExplorerObject"

local Selection = Engine:GetService("Selection")
local InputService = Engine:GetService("InputService")

local DefaultExpanded = false
local CellHeight = 20

module.new = function(object, depth)
	if object:IsA("EditorInstance") or object.Hidden then return end
	local self = setmetatable(module.Base.new(), module._metatable)

	self.Name = object.Name
	self.Object = object
	self.Depth = depth or 0

	self.Size = UDim2.new(1, 0, 0, CellHeight)
	self.Color = Color.new(0.1, 0.1, 0.1, 1)
	
	self.Button = self.Maid:Add(Instance.new("Button"))
	self.Button.Size = UDim2.new(1, -CellHeight, 0, CellHeight)
	self.Button.Color = Color.new(0, 0, 0, 0)
	self.Button.Position = UDim2.new(0, CellHeight, 0, 0)
	self.Button.ZIndex = 0
	self.Button.Parent = self

	self.ToggleButton = self.Maid:Add(Instance.new("Button"))
	self.ToggleButton.Size = UDim2.fromOffset(CellHeight, CellHeight)
	self.ToggleButton.Color = Color.new(0, 0, 0, 0)
	self.ToggleButton.ZIndex = 1
	self.ToggleButton.Parent = self

	self.ToggleButtonImage = self.Maid:Add(Instance.new("ImageLabel"))
	self.ToggleButtonImage.Size = UDim2.fromOffset(16,16)
	self.ToggleButtonImage.Position = UDim2.fromScale(0.5, 0.5)
	self.ToggleButtonImage.AnchorPoint = Vector.new(0.5, 0.5)
	self.ToggleButtonImage.ZIndex = 1
	self.ToggleButtonImage.Parent = self.ToggleButton

	self.Title = self.Maid:Add(Instance.new("TextLabel"))
	self.Title.Size = UDim2.new(1, -CellHeight*2, 0, CellHeight)
	self.Title.Position = UDim2.new(0, CellHeight*2, 0, 0)
	self.Title.Text = object.Name
	self.Title.XAlignment = Enum.XAlignment.Left
	self.Title.ZIndex = 1
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
	self.Icon.ZIndex = 1
	self.Icon.Image = object.ClassIcon

	self.ChildrenList = self.Maid:Add(Instance.new("Frame"))
	self.ChildrenList.Position = UDim2.new(0, CellHeight, 0, CellHeight)
	self.ChildrenList.Color = Color.new(0,0,0,0)
	self.ChildrenList.Parent = self
	self.ChildrenList.Enabled = not not DefaultExpanded

	self.Layout = self.Maid:Add(Instance.new("UIListLayout"))
	self.Layout.SortMode = Enum.SortMode.Name
	self.Layout.Padding = UDim2.new(0, 0, 0, 3)
	self.Layout.Parent = self.ChildrenList

	self.ToggleButton.LeftClicked:Connect(function()
		self.ChildrenList.Enabled = not self.ChildrenList.Enabled
	end)

	self.Maid:GiveTask(self.Object:GetPropertyChangedSignal("Name"):Connect(function()
		self.Title.Text = object.Name
		self.Name = object.Name
	end))

	self.Maid:GiveTask(self.Object.ChildAdded:Connect(function(newChild)
		self:NewChild(newChild)
	end))

	local first = true
	self.Maid:GiveTask(self.Object:GetPropertyChangedSignal("Parent"):Connect(function()
		if first then first = false return end
		self:Destroy()
	end))

	self.ChildrenList:GetPropertyChangedSignal("Enabled"):Connect(function()
		self:UpdateScales()
	end)
	self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self:UpdateScales()
	end)

	self.Button.LeftClicked:Connect(function()
		task.spawn(function()
			if InputService:IsKeyPressed(Enum.KeyCode.LeftControl) then
				if Selection:IsSelected(self.Object) then
					Selection:Remove(self.Object)
				else
					Selection:Add(self.Object)
				end
			else
				if #Selection:Get() == 1 and select(2, next(Selection.Selection)) == self.Object then
					Selection:Set()
				else
					Selection:Set({self.Object})
				end
			end
		end)
	end)

	self.Button.RightClicked:Connect(function()
		EditorScene:CreateContextMenu(self.Object)
	end)
	
	for _, child in ipairs(self.Object:GetChildren()) do
		self:NewChild(child)
	end

	self:UpdateSelected()
	self.Maid:GiveTask(Selection.SelectionChanged:Connect(function()
		self:UpdateSelected()
	end))

	return self
end

function module:UpdateSelected()
	local Selection = Engine:GetService("Selection")
	if Selection:IsSelected(self.Object) then
		self.Button.Color = Color.from255(70, 70, 70, 255)
	else
		self.Button.Color = Color.from255(25, 25, 25, 255)
	end
end

function module:CalculateDeepestDepth()
	local depth = self.Depth

	for _, child in ipairs(self:GetChildren(true)) do
		if child.Depth then
			depth = math.max(child.Depth, depth)
		end
	end

	return depth
end

function module:UpdateScales()
	task.delay(0, function()
		local height = self.Layout.AbsoluteContentSize.Y
		self.ChildrenList.Size = UDim2.new(1, 0, 0, height)
		
		if not self.ChildrenList.Enabled then
			height = 0
		end
		
		local deepestDepth = self:CalculateDeepestDepth()
		self.Size = UDim2.new(1, (deepestDepth - self.Depth) * CellHeight, 0, CellHeight+height)
	end)
end

function module:Update(dt)
	module.Base.Update(self, dt)

	-- self:UpdateScales()

	if next(self.Object._children) then
		self.ToggleButton.Enabled = true
	else
		self.ToggleButton.Enabled = false
		self.ChildrenList.Enabled = false
	end

	if self.ChildrenList.Enabled then
		self.ToggleButtonImage.Image = "Editor/Assets/Expanded.png"
	else
		self.ToggleButtonImage.Image = "Editor/Assets/Collapsed.png"
	end
end

function module:NewChild(child)
	local newFrame = Instance.new("ExplorerObject", child, self.Depth + 1)
	if not newFrame then return end
	newFrame.Parent = self.ChildrenList
end

return Instance.RegisterClass(module)