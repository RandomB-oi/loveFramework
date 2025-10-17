local module = {}
module.Derives = "Script"
module.__index = module
module.__type = "WorldGeneratorScript"
Instance.RegisterClass(module)

local Run = Engine:GetService("RunService")
local Input = Engine:GetService("InputService")

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	self:CreateProperty("Seed", "number", 0)
	self:CreateProperty("ChunkSize", "number", 8, "Int")
	self:CreateProperty("BlockSize", "number", 20, "Int")
	self:CreateProperty("Gravity", "Vector", Vector.new(0, 50))
	self:CreateProperty("LocalPlayer", "Instance", nil)

    
	self:CreateProperty("Sat_Value", "Vector", Vector.new(50, 50))

	return self
end

function module:ScriptInit()
	print("run it boiii")
	self.Scene = self.Maid:Add(Instance.new("Scene"))
    self.Scene.Name = "WorldScene"
	self.Scene:SetParent(self:GetScene())
    self.ZIndex = 100
    self.WorldFrame = self.Maid:Add(Instance.new("Frame"))
    self.WorldFrame.Position = UDim2.fromScale(0.5, 0.5)
    self.WorldFrame.Size = UDim2.new(0, 0, 0, 0)
    self.WorldFrame.Color = Color.new(0, 0, 0, 0)
    self.WorldFrame:SetParent(self.Scene)

    self.Entities = {}
    self.Chunks = {}
    self._raycasts = {}
    
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

    if self.LocalPlayer then
        self.LocalPlayer:SetWorld(self)
    end
end


function module:PushGraphics()
	local p = self.WorldFrame.RenderPosition - self:GetScene().RenderPosition
	love.graphics.push()
	love.graphics.translate(p.X, p.Y)
end

function module:GetChunkLoaderPositions()
    return {
        Vector.zero,
        self.LocalPlayer and self.LocalPlayer:GetPosition()
    }
end

function module:UpdateLoadedChunks()
    local toLoad = {}

    for _, position in pairs(self:GetChunkLoaderPositions()) do
        local chunkX, chunkY = self:GetChunkCoordinates(position.X, position.Y)
        local renderDistance = 2
        for x = chunkX-renderDistance, chunkX+renderDistance do
            toLoad[x] = toLoad[x] or {}
            for y = chunkY-renderDistance, chunkY+renderDistance do
                toLoad[x][y] = true
            end
        end
    end

    for x, row in pairs(self.Chunks) do
        for y, chunk in pairs(row) do
            if not (toLoad[x] and toLoad[x][y]) then
                self:RemoveChunk(x,y)
            end
        end
    end
    for x, row in pairs(toLoad) do
        for y in pairs(row) do
            self:CreateChunk(x, y)
        end
    end
end

function module:SetLocalPlayer(player)
    self.LocalPlayer = player
    if self.LocalPlayer then
        if self._scriptInitDone then
            self.LocalPlayer:SetWorld(self)
        else
            self.LocalPlayer:SetParent(self)
        end
    end
end

function module:ScriptUpdate(dt)
    local moveSpeed = 500
    -- if Input:IsKeyPressed(Enum.KeyCode.W) then
    --     self.WorldFrame.Position = self.WorldFrame.Position + UDim2.fromOffset(0, dt*moveSpeed)
    -- end
    -- if Input:IsKeyPressed(Enum.KeyCode.S) then
    --     self.WorldFrame.Position = self.WorldFrame.Position - UDim2.fromOffset(0, dt*moveSpeed)
    -- end
    
    -- if Input:IsKeyPressed(Enum.KeyCode.A) then
    --     self.WorldFrame.Position = self.WorldFrame.Position + UDim2.fromOffset(dt*moveSpeed, 0)
    -- end
    
    -- if Input:IsKeyPressed(Enum.KeyCode.D) then
    --     self.WorldFrame.Position = self.WorldFrame.Position - UDim2.fromOffset(dt*moveSpeed, 0)
    -- end

    if self.LocalPlayer then
        self.WorldFrame.Position = -self.LocalPlayer.Position + UDim2.fromScale(0.5, 0.5)
    end

    self:UpdateLoadedChunks()
end

function module:GetChunk(x,y)
	return self.Chunks[x] and self.Chunks[x][y]
end

function module:RemoveChunk(x,y)
    local chunk = self:GetChunk(x,y)
    if not chunk then return end
    chunk:Destroy()

    self.Chunks[x][y] = nil
    if not next(self.Chunks[x]) then
        self.Chunks[x] = nil
    end
end

function module:CreateChunk(x,y)
	if self:GetChunk(x,y) then return end
    if not self.Chunks[x] then
        self.Chunks[x] = {}
    end
    self.Chunks[x][y] = -1
    local newChunk = Instance.new("WorldChunk", self, x,y)
    self.Chunks[x][y] = newChunk

    return newChunk
end

function module:GetChunkCoordinates(x, y)
    return math.floor(x/(self.ChunkSize)), math.floor(y/(self.ChunkSize))
end

function module:WriteBlock(x,y, name)
    
end

function module:ReadBlock(x,y)
    local cx, cy = self:GetChunkCoordinates(x,y)
    local chunk = self:GetChunk(cx, cy)

    if not chunk or chunk == -1 then
        return -1
    end

    return chunk:ReadBlock(chunk:GetChunkCoordinates(x,y))
end

function module:GetGrassColor(x, y)
    return Color.new(0,0,0,1)
end

function module:GenerateChunk(chunk)
	for x = 0, self.ChunkSize-1 do
		for y = 0, self.ChunkSize-1 do
            chunk:WriteBlock(x,y, "dirt_block")
		end
	end
end

function module:RaycastBlocks(origin, direction)
	local length = direction:Length()
	if length == 0 then return nil end

	local dir = direction / length -- normalized

	local stepX = (dir.X > 0) and 1 or (dir.X < 0 and -1 or 0)
	local stepY = (dir.Y > 0) and 1 or (dir.Y < 0 and -1 or 0)

	local bx = math.floor(origin.X)
	local by = math.floor(origin.Y)

	local tMaxX, tMaxY, tDeltaX, tDeltaY

	if dir.X ~= 0 then
		local borderX = (stepX > 0) and (bx + 1) or bx
		tMaxX = (borderX - origin.X) / dir.X
		tDeltaX = 1 / math.abs(dir.X)
	else
		tMaxX = math.huge
		tDeltaX = math.huge
	end

	if dir.Y ~= 0 then
		local borderY = (stepY > 0) and (by + 1) or by
		tMaxY = (borderY - origin.Y) / dir.Y
		tDeltaY = 1 / math.abs(dir.Y)
	else
		tMaxY = math.huge
		tDeltaY = math.huge
	end

	local totalT = 0
	local lastNormal = Vector.yAxis
	local maxT = length + 1e-6

	while totalT <= maxT do
		local block = self:ReadBlock(bx, by)
		if block and block ~= -1 then
			return {
                Origin = origin,
                Direction = direction * length,

				X = bx,
				Y = by,
				Block = block,

				HitPos = origin + dir * math.min(totalT, length),
				Normal = lastNormal,

				Distance = totalT
			}
		end

		-- step to next cell
		if tMaxX < tMaxY then
			totalT = tMaxX
			tMaxX = tMaxX + tDeltaX
			bx = bx + stepX
			lastNormal = Vector.new(-stepX, 0)
		else
			totalT = tMaxY
			tMaxY = tMaxY + tDeltaY
			by = by + stepY
			lastNormal = Vector.new(0, -stepY)
		end
	end

	return nil
end

function module:GetMouseInBlockSpace()
    local lmx, lmy = love.mouse.getPosition()
	local parentPos = self.WorldFrame.RenderPosition
	return Vector.new(lmx - parentPos.X, lmy - parentPos.Y) / self.BlockSize
end

return module