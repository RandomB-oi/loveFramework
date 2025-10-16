local module = {}
module.Derives = "Block"
module.__index = module
module.__type = "GrassBlock"
Instance.RegisterClass(module)

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module)

	return self
end

function module:Render(x, y, world)
    local blockSize = world.BlockSize
    
    Color.from255(150, 100, 50, 255):Apply()
    love.graphics.rectangle("fill", x*blockSize, y*blockSize, blockSize, blockSize)

    Color.from255(0, 255, 0, 255):Apply()
    love.graphics.rectangle("fill", x*blockSize, y*blockSize, blockSize, blockSize/4)
end

return module