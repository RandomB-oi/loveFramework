local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "Projectile"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)

	self.AnchorPoint = Vector.one/2
	self.Size = UDim2.fromOffset(25,50)
	self.Color = Color.new(1,1,1,1)
	self.ZIndex = 10
	self.Speed = 200

	return self
end

function module:Update(dt)
	module.Base.Update(self, dt)

    local dir = Vector.FromAngle(math.rad(self.Rotation)) * self.Speed * dt
	self.Position = self.Position + UDim2.fromOffset(dir.X, dir.Y)
end

return Instance.RegisterClass(module)