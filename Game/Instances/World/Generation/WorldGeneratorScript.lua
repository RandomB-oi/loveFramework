local module = {}
module.Derives = "Script"
module.__index = module
module.__type = "WorldGeneratorScript"
Instance.RegisterClass(module)

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	self:CreateProperty("Seed", "number", 0)
	self:CreateProperty("ChunkSize", "number", 8, "Int")
	self:CreateProperty("BlockSize", "number", 20, "Int")

	return self
end

function module:ScriptInit()
	print("run it boiii")
	self.Scene = self.Maid:Add(Instance.new("Scene"))
    self.Scene.Name = "WorldScene"
	self.Scene:SetParent(self:GetScene())

    self.WorldFrame = self.Maid:Add(Instance.new("Frame"))
    self.WorldFrame.Size = UDim2.new(0, 0, 0, 0)
    self.WorldFrame.Color = Color.new(0, 0, 0, 0)
    self.WorldFrame:SetParent(self.Scene)

    self.Chunks = {}
    
    self.Maid:GiveTask(function()
        repeat
            local deletedAny
            for x, row in pairs(self.Chunks) do
                for y, chunk in pairs(row) do
                    if chunk then chunk:Destroy() deletedAny = true end
                    row[y] = nil
                end
            end
        until not deletedAny
    end)
    
    self:CreateChunk(0, 0)
    -- self:CreateChunk(1, 0)
    -- self:CreateChunk(0, 1)
    -- self:CreateChunk(1, 1)
end

function module:ScriptUpdate(dt)
end


function module:GetChunk(x,y)
	return self.Chunks[x] and self.Chunks[x][y]
end

function module:CreateChunk(x,y)
	if self:GetChunk(x,y) then return end

	local newChunk = Instance.new("WorldChunk", self, x,y)
    if not self.Chunks[x] then
        self.Chunks[x] = {}
    end
    self.Chunks[x][y] = newChunk

    return newChunk
end

function module:GenerateChunk(chunk)
	for x = 1, self.ChunkSize do
        local wx = chunk:GetWorldCoordinates(x)
        local height = math.sin(wx/20)*5
		for y = 1, self.ChunkSize do
            local _, wy = chunk:GetWorldCoordinates(nil, y)

            if wy >= height then
                chunk:WriteBlock(x,y, Instance.new("DirtBlock"))
            end
		end
	end
end

return module