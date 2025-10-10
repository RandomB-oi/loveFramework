local module = {}
module.Derives = "EditorInstance"
module.__index = module
module.__type = "Dropdown"
Instance.RegisterClass(module)

local Selection = Engine:GetService("Selection")
local InputService = Engine:GetService("InputService")

module.new = function(list)
	local self = setmetatable(module.Base.new(), module)

	self.ZIndex = 100
	self.Color = Color.new(0.5, 0.5, 0.5, 1)

	self.List = self.Maid:Add(Instance.new("ScrollingFrame"))
	self.List.Size = UDim2.fromScale(1,1)
	self.List.Color = Color.new(0, 0, 0, 0)
	self.List:SetParent(self)

	self.Layout = self.Maid:Add(Instance.new("UIListLayout"))
	self.Layout.SortMode = Enum.SortMode.Name
	self.Layout.Padding = UDim2.fromOffset(1, 1)
	self.Layout:SetParent(self.List)

	self.ValueSelected = self.Maid:Add(Signal.new())

	self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function(size)
		self.Size = UDim2.new(0, 112, 0, math.min(size.Y, 200))
		self.List.CanvasSize = UDim2.new(0, 0, 0, size.Y)
	end)

	self.Maid:GiveTask(Engine:GetService("InputService").InputBegan:Connect(function(input)
		if input.MouseButton == Enum.MouseButton.MouseButton1 then
			if not self:MouseHovering() then
				self:Destroy()
			end
		end
	end))

	for index, name in pairs(list) do
		local newButton = Instance.new("Button")
		newButton.Color = Color.new(0.3, 0.3, 0.3, 1)
		newButton.Size = UDim2.new(1, -12, 0, 20)
		newButton.LayoutOrder = index
		newButton.Name = name
		newButton:SetParent(self.List)

		local textLabel = Instance.new("TextLabel")
		textLabel.Color = Color.new(1, 1, 1, 1)
		textLabel.Size = UDim2.fromScale(1, 1)
		textLabel.Text = name
		textLabel.XAlignment = Enum.TextXAlignment.Left
		textLabel:SetParent(newButton)

		newButton.LeftClicked:Connect(function()
			self.ValueSelected:Fire(name)
		end)
	end

	return self
end


return module