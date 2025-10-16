local module = {}
module.__index = module
module.__type = "Block"
Instance.RegisterClass(module)

module.Blocks = {}

module.new = function(blockId)
	local self = setmetatable({}, module)

    module.Blocks[blockId] = self

	return self
end

function module:Render(x, y, world)
    local blockSize = world.BlockSize
    Color.White:Apply()
    love.graphics.rectangle("fill", x*blockSize, y*blockSize, blockSize, blockSize)
end

function module.Init()
	module.DirtBlock = Instance.new("DirtBlock", "dirt_block")
	module.GrassBlock = Instance.new("GrassBlock", "grass_block")
	module.StoneBlock = Instance.new("StoneBlock", "stone_block")
	module.BedrockBlock = Instance.new("BedrockBlock", "bedrock_block")
end

return module