local module = {}
module.Derives = "Frame"

module.__type = "WorldChunk"

module.FrameRendering = false

module.new = function(world, chunkX, chunkY)
    
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type
    self.RenderLayers = {}

	self.ZIndex = -1
    self.Archivable = false
    self.Blocks = {}

    self.Entities = {}
    self.Size = UDim2.fromScale(world.ChunkSize, world.ChunkSize)
    self.Position = UDim2.fromScale(chunkX * world.ChunkSize, chunkY * world.ChunkSize)
    self.World = world
    self.X = chunkX
    self.Y = chunkY

    self.World:GenerateChunk(self)
    self:SetParent(self.World.WorldFrame)

	return self
end

function module:ClearLayers()
    local prev = love.graphics.getCanvas()
    for index, layer in pairs(self.RenderLayers) do
        love.graphics.setCanvas(layer.Canvas)
        love.graphics.clear()
    end
    love.graphics.setCanvas(prev)
end

function module:GetLayer(layer)
    local existing = self.RenderLayers[layer]
    if existing then return existing end

    local bigChunkSize = self.World.ChunkSize * self.World.BlockSize
    local new = love.graphics.newCanvas(bigChunkSize, bigChunkSize)

    self.RenderLayers[layer] = {
        Canvas = new,
        Shader = Instance.GetClass("Shader").Shaders[layer],
        ID = layer,
    }
    return self.RenderLayers[layer]
end

function module:RenderCanvas()
    local blockClass = Instance.GetClass("Block")
    local prevCanvas = love.graphics.getCanvas()

    self:ClearLayers()
    local updated = {}

    local prevLayer
    for x, row in pairs(self.Blocks) do
        for y, blockID in pairs(row) do
            local block = blockID and blockClass.Blocks[blockID]
            if block then
                local layerID = block:GetRenderLayer()
                updated[layerID] = true
                if layerID ~= prevLayer then
                    prevLayer = layerID
                    local layer = self:GetLayer(layerID)
                    love.graphics.setCanvas(layer.Canvas)
                end


                block:Render(x,y, self, self.World)
            end
        end
    end
    for id, layer in pairs(self.RenderLayers) do
        if not updated[id] then
            layer.Canvas:release()
            self.RenderLayers[id] = nil
        end
    end
    love.graphics.setCanvas(prevCanvas)
end

function module:Draw()
	if not self.Enabled then return end
    
    self.Color:Apply()
    local translated = self.RenderPosition - self:GetScene().RenderPosition
    local prev = love.graphics.getShader()
    for layerID, layer in pairs(self.RenderLayers) do
        love.graphics.setShader(layer.Shader and layer.Shader.Shader)
        love.graphics.cleanDrawImage(layer.Canvas, translated, self.RenderSize)
    end
    love.graphics.setShader(prev)

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


return Instance.RegisterClass(module)