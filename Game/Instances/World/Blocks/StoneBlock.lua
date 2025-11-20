local module = {}
module.Derives = "Block"

module.__type = "StoneBlock"

local StoneImage = love.graphics.newImage("Game/Assets/Blocks/StoneBlock.png")

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module)

	return self
end

function module:GenericDraw(blockSize, x,y,chunk, world)
    Color.White:Apply()
    love.graphics.cleanDrawImage(StoneImage, Vector.zero, blockSize)
end

return Instance.RegisterClass(module)