local module = {}
module.Derives = "ImageLabel"
module.__index = module
module.__type = "Soul"

local Collision = require("Game.Utility.Collision")
module.ClassIcon = "Game/Assets/Souls/Determination.png"

Enum:AddEnum("SoulMode", {
	Determination = Enum.NewEnum("SoulMode"),
	Integrity = Enum.NewEnum("SoulMode"),
	Justice = Enum.NewEnum("SoulMode"),
	
	Kindness = Enum.NewEnum("SoulMode"),
	Perseverance = Enum.NewEnum("SoulMode"),
	Patience = Enum.NewEnum("SoulMode"),
	Bravery = Enum.NewEnum("SoulMode"),
})

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
	
	self.Name = self.__type
	self.Size = UDim2.fromOffset(34, 34)
	self.Position = UDim2.fromScale(0, 0)
	self.AnchorPoint = Vector.one/2
	self.Color = Color.from255(255, 255, 255, 255)
	self.ZIndex = 2

	self.MaxGravity = 400
	self.GravitySpeed = self.MaxGravity
	self.JumpVelocity = 350
	self.HeldJump = false

	self:CreateProperty("SoulMode", "SoulMode", Enum.SoulMode.Determination)

	-- self.Position = UDim2.fromOffset(
	-- 	self.BattleArea.RenderPosition.X + self.BattleArea.RenderSize.X/2,
	-- 	self.BattleArea.RenderPosition.Y + self.BattleArea.RenderSize.Y/2
	-- )

	return self
end
function module:IsGrounded()
	local gravityAxis = Vector.FromAngle(math.rad(self.Rotation%360))
	for _, object in ipairs(Engine:GetService("CollectionService"):GetTagged("BattleGrounded")) do
		if gravityAxis:Dot(object:GetAttribute("AxisLock")) < -0.75 and Collision.AABB(self, object) then
			return true
		end
	end
end

function module:TouchingProjectile()
	local heartCenter = self.RenderPosition + self.RenderSize/2
	local heartBox = Collision.getRotatedCorners(heartCenter, self.RenderSize, self.Rotation)

	local tpBox = Collision.getRotatedCorners(heartCenter, Vector.new(50,50), self.Rotation)

	local hasTP = 0

	for _, projectile in ipairs(Engine:GetService("CollectionService"):GetTagged("Projectile")) do
		local projectileBox = Collision.getRotatedCorners(projectile.RenderPosition + projectile.RenderSize/2, projectile.RenderSize, projectile.Rotation)

		if Collision.areRectsColliding(heartBox, projectileBox) then
			return projectile, 0
		end
		
		if Collision.areRectsColliding(tpBox, projectileBox) then
			hasTP = hasTP + 1
		end
	end
	return false, hasTP
end

function module:Update(dt)
	module.Base.Update(self, dt)

	if not self.Parent then return end
	
	self.Image = "Game/Assets/Souls/"..self.SoulMode.Name..".png"

	if not Engine:GetService("RunService"):IsRunning() then return end
	local InputService = Engine:GetService("InputService")

	local xDir = (InputService:IsKeyPressed(Enum.KeyCode.D) and 1 or 0) - (InputService:IsKeyPressed(Enum.KeyCode.A) and 1 or 0)
	local yDir = (InputService:IsKeyPressed(Enum.KeyCode.S) and 1 or 0) - (InputService:IsKeyPressed(Enum.KeyCode.W) and 1 or 0)

	local scene = self:GetScene()
	if not scene then return end

	local parentScale = self.Parent.RenderSize/scene.RenderSize
	local heartScale = self.RenderSize/self.Parent.RenderSize

	local moveSpeed = (Vector.one*200)/self.Parent.RenderSize * dt --200 * dt


	local minPos = heartScale/2
	local maxPos = Vector.one-minPos

	local positionAdd


	if self.SoulMode == Enum.SoulMode.Integrity then
		local moveAxis = Vector.FromAngle(math.rad((self.Rotation+90)%360))
		moveAxis = Vector.new(math.abs(moveAxis.X), math.abs(moveAxis.Y))

		local gravityAxis = Vector.FromAngle(math.rad(self.Rotation%360))
		local inputAxis = Vector.new(xDir, yDir)

		if InputService:IsKeyPressed(Enum.KeyCode.Left) then
			self.Rotation = 90
		elseif InputService:IsKeyPressed(Enum.KeyCode.Right) then
			self.Rotation = 270
		elseif InputService:IsKeyPressed(Enum.KeyCode.Up) then
			self.Rotation = 180
		elseif InputService:IsKeyPressed(Enum.KeyCode.Down) then
			self.Rotation = 0
		end

		local holdJump = inputAxis:Normalized():Dot(gravityAxis)
		if holdJump > 0.3 then
			if self.GravitySpeed == self.MaxGravity and self:IsGrounded() and not heldJump then
				heldJump = true
				self.GravitySpeed = -self.JumpVelocity
			end
		else
			heldJump = false
			if self.GravitySpeed < 0 then
				self.GravitySpeed = 0
			end
		end
		local gravMul = 1
		if self.GravitySpeed > 0 then
			gravMul = 2
		end
		if holdJump < -0.3 then
			gravMul = gravMul * 2
		end
		self.GravitySpeed = math.min(self.GravitySpeed + self.MaxGravity*gravMul*dt, self.MaxGravity)

		positionAdd = (inputAxis * moveAxis * moveSpeed) - (gravityAxis * self.GravitySpeed * dt)/self.Parent.RenderSize
	else
		if self.SoulMode == Enum.SoulMode.Justice then
			self.Rotation = 180
		else
			self.Rotation = 0
		end
		positionAdd = Vector.new(xDir, yDir) * moveSpeed
	end

	self.Position = UDim2.fromScale(
		math.clamp(self.Position.X.Scale + positionAdd.X, minPos.X, maxPos.X),
		math.clamp(self.Position.Y.Scale + positionAdd.Y, minPos.Y, maxPos.Y)
	)
end

return Instance.RegisterClass(module)