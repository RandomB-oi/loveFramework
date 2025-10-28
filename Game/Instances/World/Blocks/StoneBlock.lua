local module = {}
module.Derives = "Block"
module.__index = module
module.__type = "StoneBlock"
Instance.RegisterClass(module)

local StoneImage = love.graphics.newImage("Game/Assets/Blocks/StoneBlock.png")

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module)

	return self
end

function module:GenericDraw(blockSize, x,y,chunk, world)
    Color.White:Apply()
    love.graphics.cleanDrawImage(StoneImage, Vector.zero, blockSize)
end

return module