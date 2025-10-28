local module = {}
module.Derives = "Block"
module.__index = module
module.__type = "DirtBlock"
Instance.RegisterClass(module)

local DirtImage = love.graphics.newImage("Game/Assets/Blocks/DirtBlock.png")

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module)

	return self
end

function module:GenericDraw(blockSize, x,y,chunk, world)
    Color.White:Apply()
    love.graphics.cleanDrawImage(DirtImage, Vector.zero, blockSize)
end

return module