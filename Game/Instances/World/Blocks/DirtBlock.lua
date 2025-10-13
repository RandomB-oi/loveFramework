local module = {}
module.Derives = "Block"
module.__index = module
module.__type = "DirtBlock"
Instance.RegisterClass(module)

module.new = function(world)
	local self = setmetatable(module.Base.new(), module)
    self.Color = Color.from255(150, 100, 50, 255)
    
    -- self.InnerBlock = Instance.new("Frame")
    -- self.InnerBlock.Size = UDim2.new(1,-2,1,-2)
    -- self.InnerBlock.Position = UDim2.fromScale(0.5, 0.5)
    -- self.InnerBlock.AnchorPoint = Vector.one/2
    -- self.InnerBlock:SetParent(self)

	return self
end

return module