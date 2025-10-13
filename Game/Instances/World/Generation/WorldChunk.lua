local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "WorldChunk"
Instance.RegisterClass(module)

module.new = function(world, chunkX, chunkY)
	local self = setmetatable(module.Base.new(), module)
    self.Archivable = false

    local bigChunkSize = world.ChunkSize * world.BlockSize

    self.Color = Color.new(1,1,1, .1)
    self.Size = UDim2.fromOffset(bigChunkSize, bigChunkSize)
    self.Position = UDim2.fromOffset(chunkX * bigChunkSize, chunkY * bigChunkSize)
    self.World = world
    self.X = chunkX
    self.Y = chunkY

    self.World:GenerateChunk(self)
    self:SetParent(self.World.WorldFrame)

	return self
end

function module:GetWorldCoordinates(x,y)
    return x and x + self.X * self.World.ChunkSize, y and y + self.Y * self.World.ChunkSize
end

function module:GetChunkCoordinates(wx,wy)
    return wx and wx - self.X * self.World.ChunkSize, wy and wy - self.Y * self.World.ChunkSize
end

function module:WriteBlock(x,y, block)
    block:SetWorld(self.World)
   block.Position = UDim2.fromOffset((x-1) * self.World.BlockSize, (y-1) * self.World.BlockSize)
   block:SetParent(self)
end

return module