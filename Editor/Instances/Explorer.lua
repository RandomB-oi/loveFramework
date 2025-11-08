local module = {}
module.Derives = "Widget"
module.__index = module
module.__type = "Explorer"
Instance.RegisterClass(module)

module.new = function(directory)
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type
	self:SetTitle("Explorer")

	self.ExplorerList = self.Maid:Add(Instance.new("ScrollingFrame"))
	self.ExplorerList.Size = UDim2.new(1, 0, 1, 0)
	self.ExplorerList.Color = Color.new(0,0,0,0)
	self.ExplorerList.ScrollbarPadding = Enum.ScrollbarPadding.Scrollbar
	self.ExplorerList.ScrollbarThickness = 8
	self.ExplorerList.Name = "ExplorerList"
	self:CreateProperty("RootObject", "Instance", nil)
	self:AttachGui(self.ExplorerList)

	self.Layout = self.Maid:Add(Instance.new("UIListLayout"))
	self.Layout.SortMode = Enum.SortMode.Name
	self.Layout:SetParent(self.ExplorerList)

	self:GetPropertyChangedSignal("RootObject"):Connect(function()
		self.Maid.GameFrame = nil
		if not self.RootObject then return end
		self.Maid.GameFrame = Instance.new("ExplorerObject", self.RootObject)
		self.Maid.GameFrame:SetParent(self.ExplorerList)
	end)
	

	self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function(size)
		self.ExplorerList.CanvasSize = UDim2.fromOffset(size.X, size.Y)
	end)

	return self
end

return module