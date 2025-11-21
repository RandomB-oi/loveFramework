local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "ParticleEmitter"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
	self.Name = self.__type
	
    -- particle properties 
    ---------------------------------------   
    self.ParticleSize = NumberSequence.new({{0,10}, {1,10}})
    self.Color = ColorSequence.new()
	
	self:CreateProperty("Rate", "number", 20)
	self:CreateProperty("ZIndex", "number", 1, "Int")
	self:CreateProperty("LifeTime", "NumberRange", NumberRange.new(1, 3))
	self:CreateProperty("Speed", "NumberRange", NumberRange.new(20, 100))
	self:CreateProperty("EmissionAngleRange", "NumberRange", NumberRange.new(0, 0))
	self:CreateProperty("EmitterObject", "Instance", nil)
    ---------------------------------------

    self._particles = {}
    self._timer = 0
	
	return self
end

function module:Emit(amount)
	if not self.Parent then return end
	
    local sizeRange = self.Parent.RenderSize
    for i = 1, (amount or 1) do
		local newObject = self.EmitterObject and self.EmitterObject:Clone()
		if newObject then
			newObject.Archivable = false
			newObject.Color = self.Color:GetValue(0)
			newObject.Size = self.EmitterObject.Size * self.ParticleSize:GetValue(0)
			newObject.Enabled = true
			newObject.Hidden = true
			newObject:SetParent(self.Parent)
		end
        local newParticle = {
			BaseObject = self.EmitterObject,
			Object = newObject,
            Position = Vector.new(math.random(0, sizeRange.X), math.random(0, sizeRange.Y)),
            ExpectedLifeTime = self.LifeTime:GetValue(),
            Speed = self.Speed:GetValue(),
            EmissionDirection = Vector.FromAngle(math.rad(self.EmissionAngleRange:GetValue()));
            LifeTime = 0,
        }
        table.insert(self._particles, newParticle)
    end
end

function module:Update(dt)
	if not self.Parent then return end
	if not self.Enabled then return end
	self.RenderSize = self.Parent.RenderSize
	self.RenderPosition = self.Parent.RenderPosition
	self.RenderRotation = self.Parent.RenderRotation
	-- module.Base.Update(self, dt)
	self._timer = self._timer + dt
	local emitAmount = math.floor(self.Rate * self._timer)
    if emitAmount >= 1 then
        self:Emit(emitAmount)
		self._timer = self._timer - (emitAmount/self.Rate)
    end
    for i = #self._particles, 1, -1 do
        local particle = self._particles[i]

        particle.LifeTime = particle.LifeTime + dt
        if particle.LifeTime >= particle.ExpectedLifeTime then
			if particle.Object then
				particle.Object:Destroy()
			end
            table.remove(self._particles, i)
        else
            particle.Position = particle.Position + particle.EmissionDirection*particle.Speed*dt
			if particle.Object then
				particle.Object.Position = UDim2.fromOffset(particle.Position.X, particle.Position.Y)
			end
        end
    end
end

function module:Draw()
	if not self.Enabled then return end
	module.Base.Draw(self)
	
	local scene = self:GetScene()
	local parentPosition = self.Parent.RenderPosition - scene.RenderPosition

    for i, particle in ipairs(self._particles) do
        local lifeTimeAlpha = particle.LifeTime/particle.ExpectedLifeTime

        local size = self.ParticleSize:GetValue(lifeTimeAlpha)
		local color = self.Color:GetValue(lifeTimeAlpha)

		if particle.Object then
			particle.Object.Size = particle.BaseObject.Size * size
			particle.Object.Color = color
		else
			color:Apply()
	
			love.graphics.rectangle("fill", parentPosition.X + particle.Position.X-size/2, parentPosition.Y + particle.Position.Y-size/2, size, size)
		end

    end
end

return Instance.RegisterClass(module)