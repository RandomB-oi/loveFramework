local module = {}
module.Derives = "UILayoutBase"
module.__index = module
module.__type = "UIListLayout"
Instance.RegisterClass(module)

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	self:CreateProperty("Padding", "UDim2", UDim2.new(0, 6, 0, 6))
	self:CreateProperty("ListAxis", "Vector", Vector.yAxis)
	
	self:CreateProperty("AbsoluteContentSize", "Vector", Vector.zero)

	return self
end

function module:Update(dt)
	module.Base.Update(self, dt)

	local contentSize = Vector.zero
	local paddingSize = self.Padding:Calculate(self.Parent.RenderSize)
	for _, child in ipairs(self.Parent:GetChildren()) do
		if child:IsA("Frame") then
			if contentSize ~= Vector.zero then
				contentSize = contentSize + paddingSize
			end
			contentSize = contentSize + child.RenderSize * self.ListAxis
		end
	end
	self.AbsoluteContentSize = contentSize
end

function module:Resolve(specificChild, parentSize, parentPosition, parentRotation)
	-- ts kinda buns
	local currentPosition = UDim2.new(0, 0, 0, 0)
	for _, child in ipairs(self.Parent:GetChildren()) do
		if child:IsA("Frame") then
			if child == specificChild then
				return specificChild.Size:Calculate(parentSize), parentPosition + (currentPosition:Calculate(parentSize) * self.ListAxis), parentRotation
			end
			
			currentPosition = currentPosition + child.Size + self.Padding
		end
	end

	return Vector.zero, Vector.zero, 0
end

return module