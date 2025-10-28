local module = {}
module.Derives = "Block"
module.__index = module
module.__type = "GrassBlock"
Instance.RegisterClass(module)

local DirtImage = love.graphics.newImage("Game/Assets/Blocks/DirtBlock.png")
local GrassImage = love.graphics.newImage("Game/Assets/Blocks/GrassTop.png")

local DefaultGrass = Color.new(0, 1, 0, 1)

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module)

	return self
end

function module:GenericDraw(blockSize, x,y,chunk, world)
    Color.White:Apply()
    love.graphics.cleanDrawImage(DirtImage, Vector.zero, blockSize)

    if world then
        world:GetGrassColor(chunk:GetWorldCoordinates(x,y)):Apply()
    else
        DefaultGrass:Apply()
    end
    love.graphics.cleanDrawImage(GrassImage, Vector.zero, blockSize)
end

return module