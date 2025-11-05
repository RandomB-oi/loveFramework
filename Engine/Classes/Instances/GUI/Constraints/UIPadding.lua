local module = {}
module.Derives = "ConstraintBase"
module.__index = module
module.__type = "UILayoutBase"
Instance.RegisterClass(module)

module.ConstraintCategory = "Padding"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type
	
	self:CreateProperty("PaddingLeft", "UDim", UDim.new(0,0))
	self:CreateProperty("PaddingRight", "UDim", UDim.new(0,0))
	self:CreateProperty("PaddingTop", "UDim", UDim.new(0,0))
	self:CreateProperty("PaddingBottom", "UDim", UDim.new(0,0))

	self:GetPropertyChangedSignal("PaddingLeft"):Connect(function()
		
	end)

	return self
end

function module:UpdateUDim2s()
	self.PosOffset = 
end

return module