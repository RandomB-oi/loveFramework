local module = {}
module.__index = module
module.__type = "Item"
Instance.RegisterClass(module)

module.Items = {}

module.new = function(itemID)
	local self = setmetatable({}, module)
	self.ID = itemID

    module.Items[itemID] = self

	return self
end


function module:GenericDraw(size)
    Color.White:Apply()
    love.graphics.rectangle("fill", 0, 0, size.X, size.Y)
end

-- function module:Render(x, y, chunk, world)
-- 	-- local prevShader = love.graphics.getShader()
-- 	-- love.graphics.setShader(self.NormalShader)

-- 	-- -- make it translate, and call the generic draw
--     -- local blockSize = world.BlockSize

-- 	-- love.graphics.push()
-- 	-- love.graphics.translate(x*blockSize, y*blockSize)
-- 	-- self:GenericDraw(Vector.one * blockSize, x,y,chunk, world)
-- 	-- love.graphics.pop()

-- 	-- love.graphics.setShader(prevShader)
-- end

-- function module:GenericDraw(blockSize, x,y,chunk, world)
--     Color.White:Apply()
--     love.graphics.rectangle("fill", 0, 0, blockSize.X, blockSize.Y)
-- end

function module.Init()
	module.DirtBlock = Instance.new("BlockItem", "dirt_block_item", "dirt_block")
	module.GrassBlock = Instance.new("BlockItem", "grass_block_item", "grass_block")
	module.StoneBlock = Instance.new("BlockItem", "stone_block_item", "stone_block")
	module.BedrockBlock = Instance.new("BlockItem", "bedrock_block_item", "bedrock_block")
end

return module