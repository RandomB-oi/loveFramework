local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "Projectile"
Instance.RegisterClass(module)

module.new = function(origin, heart)
	local self = setmetatable(module.Base.new(), module)

	self.AnchorPoint = Vector.one/2
	self.Size = UDim2.fromOffset(25,50)
	self.Position = UDim2.fromOffset(origin.X, origin.Y)
	self.Color = Color.new(1,1,1,1)
	self.ZIndex = 10
	self.Speed = 200

    local diff = (heart.RenderPosition + heart.RenderSize * heart.AnchorPoint) - origin
    self.Rotation = math.deg(math.atan2(diff.Y, diff.X)+math.pi/2)

	return self
end

function module:Update(dt)
	module.Base.Update(self, dt)

    local dir = Vector.FromAngle(math.rad(self.Rotation)) * self.Speed * dt
	self.Position = self.Position + UDim2.fromOffset(dir.X, dir.Y)
end

return module