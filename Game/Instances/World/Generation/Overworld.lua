local module = {}
module.Derives = "WorldGeneratorScript"
module.__index = module
module.__type = "Overworld"
Instance.RegisterClass(module)

local Run = Engine:GetService("RunService")
local Input = Engine:GetService("InputService")

module.new = function()
	local self = setmetatable(module.Base.new(), module)
    self:CreateProperty("MaxWorldHeight", "number", -100, "Int")
    self:CreateProperty("MaxWorldDepth", "number", 40, "Int")

	return self
end

function module:GetGrassColor(x, y)
    -- return Color.new(math.cos(y/5)/2+0.5,math.sin((x)/5)/2+0.5,0,1)
    return Color.new(0, 1, 0, 1)
end

function module:GenerateChunk(chunk)
    local surfaceLevel = 3
    local seed = self.Seed
    local freq, amp = 0.049, 25

	for x = 0, self.ChunkSize-1 do
        local wx = chunk:GetWorldCoordinates(x)

        local noise = love.math.noise(wx*freq, seed*freq) * amp
        local height = math.round(surfaceLevel+noise)

		for y = 0, self.ChunkSize-1 do
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

            if wy == self.MaxWorldDepth then
                block = "bedrock_block"
            end
            if wy < self.MaxWorldHeight or wy > self.MaxWorldDepth then
                block = nil
            end

            -- block = "grass_block"


            chunk:WriteBlock(x,y, block)
		end
	end
end

return module