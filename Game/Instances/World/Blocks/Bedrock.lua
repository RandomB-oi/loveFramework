local module = {}
module.Derives = "Block"
module.__index = module
module.__type = "BedrockBlock"
Instance.RegisterClass(module)

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module)

	return self
end

function module:GenericDraw(blockSize, x,y,chunk, world)
    Color.from255(25, 25, 25, 255):Apply()
    love.graphics.rectangle("fill", 0, 0, blockSize.X, blockSize.Y)
end

return module