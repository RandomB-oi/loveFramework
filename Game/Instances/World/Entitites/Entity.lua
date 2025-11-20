local module = {}
module.Derives = "Frame"

module.__type = "Entity"

module.FrameRendering = true
module.PhysicsFPS = 60

module.EntitySizeInBlocks = Vector.new(.75,1.8)

local Run = Engine:GetService("RunService")

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type
	self.AnchorPoint = Vector.new(0.5, 1)
	self.ZIndex = 1
	self:CreateProperty("Velocity", "Vector", Vector.new(0,0))
	self:CreateProperty("StepHeight", "number", 1)

	return self
end

function module:SetWorld(world)
	self.World = world
	self:SetParent(world.WorldFrame)
end

function module:GetPosition() -- topleftCorner in block coordinates
	return self:GetFootPosition() - self.EntitySizeInBlocks*self.AnchorPoint
end

function module:GetFootPosition()
	-- return Vector.new(self.Position.X.Offset, self.Position.Y.Offset) / self.World.BlockSize
	return Vector.new(self.Position.X.Scale, self.Position.Y.Scale)
end

function module:SetPosition(position)
	-- local pos = (position + self.EntitySizeInBlocks*self.AnchorPoint) * self.World.BlockSize
	-- self.Position = UDim2.fromOffset(pos.X, pos.Y)
	
	local pos = (position + self.EntitySizeInBlocks*self.AnchorPoint)
	self.Position = UDim2.fromScale(pos.X, pos.Y)
end

function module:CollidingCoordinates(x, y, simPos)
	local block = self.World:ReadBlock(x,y)
	local blockClass = Instance.GetClass("Block").Blocks[block]
	if not blockClass then return false end
	if not blockClass:CanCollide(self) then return false end
	
	local selfSize = self.EntitySizeInBlocks
	local selfPosition = (simPos or self:GetPosition()) + selfSize/2
	
	local blockSize = Vector.one
	local blockPosition = Vector.new(x,y) + blockSize/2

	local bigSize = (blockSize+selfSize)/2

	local diff = selfPosition - blockPosition
	local aDiff = Vector.new(math.abs(diff.X), math.abs(diff.Y))
	
	return aDiff.X <= bigSize.X and aDiff.Y <= bigSize.Y
end

function module:Grounded()
	return self:CollidingWithAnything(self:GetPosition()+Vector.yAxis*0.05)
end

function module:CollidingWithAnything(position)
	local position = position or self:GetPosition()
	local sx, sy = math.round(position.X), math.round(position.Y)

	local checkRange = 3
	for x = sx-checkRange, sx+checkRange do
		for y = sy-checkRange, sy+checkRange do
			local collision = self:CollidingCoordinates(x,y, position)
			if collision then
				return collision
			end
		end
	end
	
	return false
end

function module:SolveVelocity(dt)
	self.Velocity = Vector.new(
		math.clamp(self.Velocity.X, -self.World.TerminalVelocity.X, self.World.TerminalVelocity.X),
		math.clamp(self.Velocity.Y, -self.World.TerminalVelocity.Y, self.World.TerminalVelocity.Y)
	)
		
	local pos = self:GetPosition()
	local scaledVelocity = self.Velocity*dt

	if scaledVelocity.X ~= 0 and self:Grounded() then
		local stepHeight = self.StepHeight+0.001
		local origin = self:GetFootPosition() - (Vector.yAxis * stepHeight) - Vector.xAxis * self.EntitySizeInBlocks.X/2
		local direction = Vector.xAxis * scaledVelocity
		if scaledVelocity.X > 0 then
			origin = origin + Vector.xAxis * self.EntitySizeInBlocks.X
		end
		local rayOut = self.World:RaycastBlocks(origin, direction)
		if not rayOut then
			local rayDown = self.World:RaycastBlocks(origin+direction, Vector.yAxis*stepHeight)
			if rayDown then
				pos.Y = rayDown.Position.Y-self.EntitySizeInBlocks.Y*self.AnchorPoint.Y-0.001
			end
		end
	end

	for _, axis in pairs({Vector.xAxis, Vector.yAxis}) do
		local inverseAxis = Vector.one - axis
		local colliding = self:CollidingWithAnything(pos + scaledVelocity*axis)
		if colliding then
			scaledVelocity = scaledVelocity * inverseAxis
			self.Velocity = self.Velocity * inverseAxis
		else
			pos = pos + scaledVelocity*axis
		end
	end

	-- self:SetPosition(Vector.new(math.round(pos.X*100)/100, math.round(pos.Y*100)/100))
	self:SetPosition(pos)
	
	-- self.position.x = math.round(self.position.x*100)/100
	-- self.position.y = math.round(self.position.y*100)/100
end

function module:Update(dt)
	module.Base.Update(self, dt)

	if not self.Enabled then return end
	if not Run:IsRunning() then return end

	if not self.World then return end
	if self.Flying then return end
	
	-- self.Size = UDim2.fromOffset(self.World.BlockSize * self.EntitySizeInBlocks.X, self.World.BlockSize * self.EntitySizeInBlocks.Y)
	self.Size = UDim2.fromScale(self.EntitySizeInBlocks.X, self.EntitySizeInBlocks.Y)

	local grav = self.World.Gravity * dt
	if self.Velocity.Y < 0 then
		grav = grav / 2
	end
	self.Velocity = self.Velocity + grav

    -- if Input:IsKeyPressed(Enum.KeyCode.A) then
    --     self.entityTest.Velocity = self.entityTest.Velocity*Vector.yAxis + Vector.xAxis * -moveSpeed
    -- elseif Input:IsKeyPressed(Enum.KeyCode.D) then
    --     self.entityTest.Velocity = self.entityTest.Velocity*Vector.yAxis + Vector.xAxis * moveSpeed
    -- else
    --     self.entityTest.Velocity = self.entityTest.Velocity*Vector.yAxis
    -- end

	local stepAmount = math.ceil(dt*self.PhysicsFPS)
	for i = 1, stepAmount do
		self:SolveVelocity(dt/stepAmount)
	end
	-- local lmx, lmy = love.mouse.getPosition()
	-- local parentPos = self.Parent.RenderPosition
	-- self.Position = UDim2.fromOffset(lmx - parentPos.X, lmy - parentPos.Y)
end


return Instance.RegisterClass(module)