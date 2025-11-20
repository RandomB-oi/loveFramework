local module = {}
module.Derives = "Block"

module.__type = "DirtBlock"

local DirtImage = love.graphics.newImage("Game/Assets/Blocks/DirtBlock.png")

-- module.Shader = 2

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module)

	return self
end

function module:GenericDraw(blockSize, x,y,chunk, world)
    Color.White:Apply()
    love.graphics.cleanDrawImage(DirtImage, Vector.zero, blockSize)
end

return Instance.RegisterClass(module)