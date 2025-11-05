local module = {}
module.Derives = "UILayoutBase"
module.__index = module
module.__type = "UIListLayout"
Instance.RegisterClass(module)

module.ClassIcon = "Engine/Assets/InstanceIcons/UIListLayout.png"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	self:CreateProperty("Padding", "UDim2", UDim2.new(0, 6, 0, 6))
	self:CreateProperty("ListAxis", "Vector", Vector.yAxis)
	
	self:CreateProperty("AbsoluteContentSize", "Vector", Vector.zero)
	self:CreateProperty("SortMode", "SortMode", Enum.SortMode.LayoutOrder)

	self.OrderedChildren = {}

	self.Changed:Connect(function()
		self:UpdateOrder()
	end)

	return self
end

local function newChild(self, child)
	if not child:IsA("Frame") then return end

	self:UpdateOrder()

	local connectionMaid = Maid.new()
	self.ParentMaid[child] = connectionMaid
	connectionMaid:GiveTask(child.Changed:Connect(function()
		self:UpdateOrder()
	end))
end

function module:BindToParent(parent)
	self.ParentMaid:GiveTask(parent.Changed:Connect(function(prop)
		self:UpdateOrder()
	end))

	for _, child in ipairs(parent:GetChildren()) do
		newChild(self, child)
	end

	self.ParentMaid:GiveTask(parent.ChildAdded:Connect(function(child)
		newChild(self, child)
	end))
	
	self.ParentMaid:GiveTask(parent.ChildRemoved:Connect(function(child)
		if self.ParentMaid[child] then
			self:UpdateOrder()
			self.ParentMaid[child] = nil
		end
	end))
	self:UpdateOrder()
end

function module:Update(dt)
	module.Base.Update(self, dt)

	-- self:UpdateOrder()
end

function module:UpdateOrder()
	if not self.Parent then
		self.OrderedChildren = {}
		self.AbsoluteContentSize = Vector.zero
		return
	end

	local array = {}
	local lookup = {}
	for _, child in ipairs(self.Parent:GetChildren()) do
		if child:IsA("Frame") and child:IsEnabled() then
			local order = 0
			if self.SortMode == Enum.SortMode.LayoutOrder then
				order = child.LayoutOrder or 9999
			else
				order = string.getOrder(child.Name)
			end
			if not lookup[order] then
				local tbl = {order, {}}
				table.insert(array, tbl)
				lookup[order] = tbl
			end

			table.insert(lookup[order][2], child)
		end
	end

	table.sort(array, function(a, b)
		return a[1] < b[1]
	end)

	local orderedChildren = {}
	local currentPosition = UDim2.new(0, 0, 0, 0)
	local parentSize = self.Parent.RenderSize

	local contentSize = Vector.zero
	local paddingSize = self.Padding:Calculate(parentSize)
	
	for _, list in ipairs(array) do
		for _, child in ipairs(list[2]) do
			orderedChildren[child] = (currentPosition:Calculate(parentSize) * self.ListAxis)
			
			if contentSize ~= Vector.zero then
				contentSize = contentSize + paddingSize
			end
			contentSize = contentSize + child.RenderSize * self.ListAxis

			currentPosition = currentPosition + child.Size + self.Padding
		end
	end

	self.AbsoluteContentSize = contentSize
	self.OrderedChildren = orderedChildren
end

function module:Resolve(child, parentSize, parentPos)
	local pos = self.OrderedChildren[child]
	if pos and parentSize and self.Parent.RenderRotation then
		local size = child.Size:Calculate(parentSize)
		pos = pos + parentPos
		-- pos = pos + self.Parent.RenderPosition

		-- if self.Parent.CanvasPosition then
		-- 	pos = pos - self.Parent.CanvasPosition
		-- end

		return size, pos, self.Parent.RenderRotation
	end

	return Vector.zero, Vector.zero, 0
end

return module