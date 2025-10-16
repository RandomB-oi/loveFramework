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
	self:CreateProperty("Gravity", "Vector", Vector.new(0, 4))

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

	self.entityTest = Instance.new("Entity")
	self.entityTest:SetWorld(self)
end

function module:GetChunkLoaderPositions()
    return {
        Vector.new(self.entityTest.Position.X.Offset, self.entityTest.Position.Y.Offset)/self.BlockSize
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

function module:ScriptUpdate(dt)
    local moveSpeed = 500
    if Input:IsKeyPressed(Enum.KeyCode.W) then
        self.WorldFrame.Position = self.WorldFrame.Position + UDim2.fromOffset(0, dt*moveSpeed)
    end
    if Input:IsKeyPressed(Enum.KeyCode.S) then
        self.WorldFrame.Position = self.WorldFrame.Position - UDim2.fromOffset(0, dt*moveSpeed)
    end
    
    if Input:IsKeyPressed(Enum.KeyCode.A) then
        self.WorldFrame.Position = self.WorldFrame.Position + UDim2.fromOffset(dt*moveSpeed, 0)
    end
    
    if Input:IsKeyPressed(Enum.KeyCode.D) then
        self.WorldFrame.Position = self.WorldFrame.Position - UDim2.fromOffset(dt*moveSpeed, 0)
    end

    local lmx, lmy = love.mouse.getPosition()
	local parentPos = self.WorldFrame.RenderPosition
	local mousePosition = UDim2.fromOffset(lmx - parentPos.X, lmy - parentPos.Y)
    self.entityTest.Position = mousePosition

    self:UpdateLoadedChunks()
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
	local lastNormal = nil

    bx = bx + 1
    by = by + 1

	-- extend the max travel distance slightly (tiny epsilon)
	local maxT = length + 1e-6

	while totalT <= maxT do
		local block = self:ReadBlock(bx, by)
		if block and block ~= -1 then
			return {
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



-- function module:Draw()
--     module.Base.Draw(self)

--     if not self._scriptInitDone then return end
--     love.graphics.push()
--     local translated = self.WorldFrame.RenderPosition - self:GetScene().RenderPosition
--     love.graphics.translate(translated.X, translated.Y)


--     local lmx, lmy = love.mouse.getPosition()
-- 	local parentPos = self.WorldFrame.RenderPosition
-- 	local mousePosition = Vector.new(lmx - parentPos.X, lmy - parentPos.Y) / self.BlockSize

--     local origin = Vector.new(8, -4)
--     local direction = mousePosition - origin
--     local intersection = self:RaycastBlocks(origin, direction)

--     local pos = origin * self.BlockSize
--     local dir = direction * self.BlockSize
--     local pos2 = pos + dir

--     Color.White:Apply()
--     love.graphics.circle("fill", pos.X, pos.Y, 4)
--     love.graphics.line(pos.X, pos.Y, pos2.X, pos2.Y)

--     if intersection then
--         local pos = intersection.HitPos * self.BlockSize
--         local pos2 = pos + intersection.Normal * 20
--         love.graphics.circle("fill", pos.X, pos.Y, 4)
--         love.graphics.line(pos.X, pos.Y,pos2.X, pos2.Y)
--     end

--     love.graphics.pop()

-- end


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
    return math.floor((x-1)/(self.ChunkSize)), math.floor((y-1)/(self.ChunkSize))
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

function module:GenerateChunk(chunk)
    local surfaceLevel = 3

    local seed = self.Seed -- 10, 100
    
    local freq, amp = 0.049, 25

	for x = 1, self.ChunkSize do
        local wx = chunk:GetWorldCoordinates(x)

        local noise = love.math.noise(wx*freq, seed*freq) * amp
        local height = math.round(surfaceLevel+noise)

		for y = 1, self.ChunkSize do
            local _, wy = chunk:GetWorldCoordinates(nil, y)

            local block
            if wy >= height then
                if wy == height then
                    block = "grass_block"
                elseif wy < height+5 then
                    block = "dirt_block"
                else
                    block = "stone_block"
                end
            end


            chunk:WriteBlock(x,y, block)
		end
	end
end

return module