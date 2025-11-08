local module = {}
module.Derives = "ConstraintBase"
module.__index = module
module.__type = "UIPadding"
Instance.RegisterClass(module)

module.ConstraintCategory = "Padding"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type
	
	self:CreateProperty("PaddingLeft", "UDim", UDim.new(0,0))
	self:CreateProperty("PaddingRight", "UDim", UDim.new(0,0))
	self:CreateProperty("PaddingTop", "UDim", UDim.new(0,0))
	self:CreateProperty("PaddingBottom", "UDim", UDim.new(0,0))

	self.TopLeft = Vector.zero
	self.BottomRight = Vector.zero

	self.Changed:Connect(function()
		self:UpdateOffsets()
	end)

	return self
end

function module:BindToParent(parent)
	self.ParentMaid:GiveTask(parent.Changed:Connect(function()
		self:UpdateOffsets()
	end))
end

function module:UpdateOffsets()
	local parentSize = self.Parent.RenderSize

	self.TopLeft = UDim2.fromUDims(self.PaddingLeft, self.PaddingTop):Calculate(parentSize)
	self.BottomRight = UDim2.fromUDims(self.PaddingRight, self.PaddingBottom):Calculate(parentSize)
end

return module