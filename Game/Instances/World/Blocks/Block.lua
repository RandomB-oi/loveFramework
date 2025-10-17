local module = {}
module.__index = module
module.__type = "Block"
Instance.RegisterClass(module)

module.Blocks = {}

module.NormalShader = love.graphics.newShader("Game/Shaders/TestShader/Pixel.glsl", "Game/Shaders/TestShader/Vertex.glsl")

module.new = function(blockId)
	local self = setmetatable({}, module)

    module.Blocks[blockId] = self

	return self
end

function module:Render(x, y, chunk, world)
	local prevShader = love.graphics.getShader()
	love.graphics.setShader(self.NormalShader)

	-- make it translate, and call the generic draw
    local blockSize = world.BlockSize

	love.graphics.setShader(prevShader)
end

function module:GenericDraw(blockSize)
    Color.White:Apply()
    love.graphics.rectangle("fill", 0, 0, blockSize, blockSize)
end

function module:CanCollide(entity)
	return true
end

function module.Init()
	module.DirtBlock = Instance.new("DirtBlock", "dirt_block")
	module.GrassBlock = Instance.new("GrassBlock", "grass_block")
	module.StoneBlock = Instance.new("StoneBlock", "stone_block")
	module.BedrockBlock = Instance.new("BedrockBlock", "bedrock_block")
end

return module