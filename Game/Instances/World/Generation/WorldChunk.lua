local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "WorldChunk"
Instance.RegisterClass(module)

module.FrameRendering = false

module.new = function(world, chunkX, chunkY)
	local self = setmetatable(module.Base.new(), module)
	self.Name = "Chunk"
	self.ZIndex = -1
    self.Archivable = false
    self.Blocks = {}

    local bigChunkSize = world.ChunkSize * world.BlockSize

    self.Entities = {}
    self.Size = UDim2.fromOffset(bigChunkSize, bigChunkSize)
    self.Position = UDim2.fromOffset(chunkX * bigChunkSize, chunkY * bigChunkSize)
    self.World = world
    self.X = chunkX
    self.Y = chunkY

    self.World:GenerateChunk(self)
    self:SetParent(self.World.WorldFrame)

	return self
end

function module:Draw()
	if not self.Enabled then return end
    local blockClass = Instance.GetClass("Block")
    love.graphics.push()
    local translated = self.RenderPosition - self:GetScene().RenderPosition
    love.graphics.translate(translated.X, translated.Y)
    for x, row in pairs(self.Blocks) do
        for y, block in pairs(row) do
            if block and blockClass.Blocks[block] then
                blockClass.Blocks[block]:Render(x-1,y-1, self.World)
            end
        end
    end
    love.graphics.pop()

	module.Base.Draw(self)
end

function module:GetWorldCoordinates(x,y)
    return x and x + self.X * self.World.ChunkSize, y and y + self.Y * self.World.ChunkSize
end

function module:GetChunkCoordinates(wx,wy)
    return wx and wx - self.X * self.World.ChunkSize, wy and wy - self.Y * self.World.ChunkSize
end

function module:ReadBlock(x,y)
    return self.Blocks[x] and self.Blocks[x][y]
end

function module:WriteBlock(x,y, block)
    if not self.Blocks[x] then
        self.Blocks[x] = {}
    end
    self.Blocks[x][y] = block
end


return module