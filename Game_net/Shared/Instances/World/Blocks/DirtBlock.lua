local module = {}
module.Derives = "Block"
module.__index = module
module.__type = "DirtBlock"

local DirtImage = love.graphics.newImage("Game/Client/Assets/Blocks/DirtBlock.png")

-- module.Shader = 2

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)

	return self
end

function module:GenericDraw(blockSize, x,y,chunk, world)
    Color.White:Apply()
    love.graphics.cleanDrawImage(DirtImage, Vector.zero, blockSize)
end

return Instance.RegisterClass(module)