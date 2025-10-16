local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "Entity"
Instance.RegisterClass(module)

module.FrameRendering = true

module.EntitySizeInBlocks = Vector.new(.75,1.8)

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.AnchorPoint = Vector.new(0.5, 1)
	self.Name = "Entity"
	self.ZIndex = 1
	self:CreateProperty("Velocity", "Vector", Vector.new(0,0))


local emitter = Instance.new("ParticleEmitter")
	emitter:SetParent(self)


	emitter.Rate = 1
    -- self.ParticleSize = NumberSequence.new({{0,0}, {0.1,25}, {0.25, 20}, {.5,15}, {1,0}})
	
    emitter.ParticleSize = NumberSequence.new({{0,0}, {0.1,1}, {0.25, .8}, {.5,.5}, {1,0}})
    emitter.Color = ColorSequence.new({
        {0, Color.new(1, 0, 0, 1)},
        {1, Color.new(1, 1, .4, 1)},
        
        -- {0, Color.new(0, 1, 1, 1)},
        -- {1, Color.new(0, 0, .6, 1)},
    })

	emitter.EmitterObject = Instance.new("ImageLabel")
	emitter.EmitterObject.Image = "Game/Assets/bob.png"
	emitter.EmitterObject.AnchorPoint = Vector.one/2
	emitter.EmitterObject.Size = UDim2.fromOffset(50, 50)

    emitter.LifeTime = NumberRange.new(1, 3)
    emitter.Speed = NumberRange.new(20, 50)
    emitter.EmissionAngleRange = NumberRange.new(0, 0)

	return self
end

function module:SetWorld(world)
	self.World = world
	self.Size = UDim2.fromOffset(self.World.BlockSize * self.EntitySizeInBlocks.X, self.World.BlockSize * self.EntitySizeInBlocks.Y)
	self:SetParent(world.WorldFrame)
end

function module:GetPosition(int)
	local x, y = self.Position.X.Offset / self.World.BlockSize, self.Position.Y.Offset / self.World.BlockSize
	if int then
		x, y = math.ceil(x), math.ceil(y)
	end
	return x, y
end

function module:Update(dt)
	if not self.Enabled then return end
	module.Base.Update(self, dt)

	if not Engine:GetService("RunService"):IsRunning() then return end

	if not self.World then return end

	local addVelocity = self.Velocity * dt
	self.Position = self.Position + UDim2.fromOffset(addVelocity.X, addVelocity.Y)

	-- self.Velocity = self.Velocity + self.World.Gravity * self.World.BlockSize * dt

	-- local lmx, lmy = love.mouse.getPosition()
	-- local parentPos = self.Parent.RenderPosition
	-- self.Position = UDim2.fromOffset(lmx - parentPos.X, lmy - parentPos.Y)
end

return module