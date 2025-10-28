local module = {}
module.Derives = "Entity"
module.__index = module
module.__type = "Player"
Instance.RegisterClass(module)

module.EntitySizeInBlocks = Vector.new(.75,1.8)

local Run = Engine:GetService("RunService")
local Input = Engine:GetService("InputService")

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	self:CreateProperty("MoveSpeed", "number", 5)
	self:CreateProperty("JumpPower", "number", 13.2)
	
	self:CreateProperty("FlySpeed", "number", 15)
	self:CreateProperty("Flying", "boolean", false)

	if Run:IsRunning() then
		local Constants = GameScene:WaitForChild("Constants", 5)
		self.Maid:GiveTask(Input.InputBegan:Connect(function(input)
			if input.KeyCode == Constants.ToggleFlight then
				self.Flying = not self.Flying
			end

			if input.KeyCode == Constants.Jump then
				if self:Grounded() then
					self.Velocity = Vector.new(self.Velocity.X, -self.JumpPower)
				end
			end
		end))
	end

	return self
end



-- function module:Draw()
--     module.Base.Draw(self)

--     if not Run:IsRunning() then return end
-- 	if not self.World then return end



-- end


function module:Update(dt)
	if not self.Enabled then return end
	if not Run:IsRunning() then return end
	if not self.World then return end

	local Constants = GameScene:WaitForChild("Constants", 5)

	
	-- local origin = self:GetFootPosition()-Vector.yAxis*self.EntitySizeInBlocks.Y
	-- local direction = self.World:GetMouseInBlockSpace() - origin
	-- local intersection = self.World:RaycastBlocks(origin, direction)


	if self.Flying then
		self.Velocity = Vector.zero
		if Input:IsKeyPressed(Constants.MoveLeft) then
			self:SetPosition(self:GetPosition() - Vector.xAxis * self.FlySpeed*dt)
		end
		if Input:IsKeyPressed(Constants.MoveRight) then
			self:SetPosition(self:GetPosition() + Vector.xAxis * self.FlySpeed*dt)
		end
		if Input:IsKeyPressed(Constants.MoveUp) then
			self:SetPosition(self:GetPosition() - Vector.yAxis * self.FlySpeed*dt)
		end
		if Input:IsKeyPressed(Constants.MoveDown) then
			self:SetPosition(self:GetPosition() + Vector.yAxis * self.FlySpeed*dt)
		end
	else
		if Input:IsKeyPressed(Constants.MoveLeft) then
			self.Velocity = self.Velocity*Vector.yAxis - Vector.xAxis * self.MoveSpeed
		elseif Input:IsKeyPressed(Constants.MoveRight) then
			self.Velocity = self.Velocity*Vector.yAxis + Vector.xAxis * self.MoveSpeed
		else
			self.Velocity = self.Velocity*Vector.yAxis
		end
	end
	
	module.Base.Update(self, dt)
end

return module