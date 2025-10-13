local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "Block"
Instance.RegisterClass(module)

module.new = function(world)
	local self = setmetatable(module.Base.new(), module)
    self.Color = Color.new(1, 1, 1, 1)

	return self
end

function module:SetWorld(world)
    self.World = world
    self.Size = UDim2.fromOffset(world.BlockSize, world.BlockSize)
end

return module