local module = {}
module.Derives = "Block"
module.__index = module
module.__type = "BedrockBlock"
Instance.RegisterClass(module)

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module)

	return self
end

function module:Render(x, y, world)
    local blockSize = world.BlockSize
    Color.from255(25, 25, 25, 255):Apply()
    love.graphics.rectangle("fill", x*blockSize, y*blockSize, blockSize, blockSize)
end

return module