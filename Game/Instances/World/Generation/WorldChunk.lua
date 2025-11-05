local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "WorldChunk"
Instance.RegisterClass(module)

module.FrameRendering = false

module.new = function(world, chunkX, chunkY)
    local bigChunkSize = world.ChunkSize * world.BlockSize

	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type
    self.Canvas = love.graphics.newCanvas(bigChunkSize, bigChunkSize)
	self.ZIndex = -1
    self.Archivable = false
    self.Blocks = {}


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

function module:RenderCanvas()
    local blockClass = Instance.GetClass("Block")
    local prevCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self.Canvas)
    for x, row in pairs(self.Blocks) do
        for y, block in pairs(row) do
            if block and blockClass.Blocks[block] then
                blockClass.Blocks[block]:Render(x,y, self, self.World)
            end
        end
    end
    love.graphics.setCanvas(prevCanvas)
end

function module:Draw()
	if not self.Enabled then return end

    self.Color:Apply()
    local translated = self.RenderPosition - self:GetScene().RenderPosition
    love.graphics.cleanDrawImage(self.Canvas, translated, self.RenderSize)

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

function module:WriteBlock(x,y, block, bulk)
    if not self.Blocks[x] then
        self.Blocks[x] = {}
    end
    self.Blocks[x][y] = block

    if not bulk then
        self:RenderCanvas()
    end
end


return module