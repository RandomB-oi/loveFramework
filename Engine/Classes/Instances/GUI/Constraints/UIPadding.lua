local module = {}
module.Derives = "ConstraintBase"
module.__index = module
module.__type = "UIPadding"

module.ConstraintCategory = "Padding"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
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
	self:UpdateOffsets()
end

function module:UpdateOffsets()
	local parentSize = self.Parent and self.Parent.RenderSize or Vector.zero

	self.TopLeft = UDim2.fromUDims(self.PaddingLeft, self.PaddingTop):Calculate(parentSize)
	self.BottomRight = UDim2.fromUDims(self.PaddingRight, self.PaddingBottom):Calculate(parentSize)
end

return Instance.RegisterClass(module)