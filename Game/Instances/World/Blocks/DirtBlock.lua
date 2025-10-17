local module = {}
module.Derives = "Block"
module.__index = module
module.__type = "DirtBlock"
Instance.RegisterClass(module)

local DirtImage = love.graphics.newImage("Game/Assets/Blocks/DirtBlock.png")
local GrassImage = love.graphics.newImage("Game/Assets/Blocks/GrassTop.png")

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module)

	return self
end

function module:Render(x, y, chunk, world)
    local blockSize = Vector.one * world.BlockSize
    local pos = Vector.new(x, y) * blockSize

    Color.White:Apply()
    love.graphics.cleanDrawImage(DirtImage, pos, blockSize)
end

return module