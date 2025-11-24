local module = {}
module.Derives = "Block"
module.__index = module
module.__type = "StoneBlock"

local StoneImage = love.graphics.newImage("Game/Client/Assets/Blocks/StoneBlock.png")
-- module.Shader = Instance.GetClass("Shader").TestShader.ID

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)

	return self
end

function module:GenericDraw(blockSize, x,y,chunk, world)
    Color.White:Apply()
    love.graphics.cleanDrawImage(StoneImage, Vector.zero, blockSize)
end

return Instance.RegisterClass(module)