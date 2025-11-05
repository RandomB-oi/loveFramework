local module = {}
module.__index = module
module.__type = "Block"
Instance.RegisterClass(module)

module.Blocks = {}

-- module.Shader = Shaders.NormalShader

module.new = function(blockId)
	local self = setmetatable({}, module)
	self.ID = blockId

    module.Blocks[blockId] = self

	return self
end

function module:Render(x, y, chunk, world)
	-- local prevShader = love.graphics.getShader()
	-- love.graphics.setShader(self.Shader)

	-- make it translate, and call the generic draw
    local blockSize = world.BlockSize

	love.graphics.push()
	love.graphics.translate(x*blockSize, y*blockSize)
	self:GenericDraw(Vector.one * blockSize, x,y,chunk, world)
	love.graphics.pop()

	-- love.graphics.setShader(prevShader)
end

function module:GenericDraw(blockSize, x,y,chunk, world)
    Color.White:Apply()
    love.graphics.rectangle("fill", 0, 0, blockSize.X, blockSize.Y)
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