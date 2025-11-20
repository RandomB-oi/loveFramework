local module = {}
module.Derives = "Item"

module.__type = "BlockItem"

module.Items = {}

module.new = function(itemID, blockID)
	local self = setmetatable(module.Base.new(itemID), module)
    self.BlockID = blockID

	return self
end

function module:GenericDraw(size)
    local blockClass = Instance.GetClass("Block").Blocks[self.BlockID]

    blockClass:GenericDraw(size)
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


return Instance.RegisterClass(module)