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

function module:Render(x, y, chunk, world)
    local blockSize = Vector.one * world.BlockSize
    local pos = Vector.new(x, y) * blockSize

    Color.White:Apply()
    love.graphics.cleanDrawImage(StoneImage, pos, blockSize)
end

return module