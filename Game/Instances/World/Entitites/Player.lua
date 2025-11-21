local module = {}
module.Derives = "Entity"
module.__index = module
module.__type = "Player"

module.EntitySizeInBlocks = Vector.new(.75,1.8)

local Run = Engine:GetService("RunService")
local Input = Engine:GetService("InputService")

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
    self.Name = self.__type

	self:CreateProperty("MoveSpeed", "number", 5)
	self:CreateProperty("JumpPower", "number", 13.2)
	
	self:CreateProperty("FlySpeed", "number", 15)
	self:CreateProperty("Flying", "boolean", false)

	self.ContainerGroup = self.Maid:Add(Instance.new("ContainerGroup"))
	self.ContainerGroup:AddContainer("Inventory", Instance.new("Container", 27, 9))
	self.ContainerGroup:GiveItemStack(Instance.new("ItemStack", "dirt_block_item", 24))

	-- self.ContainerGroup:AddContainer("Toolbar", Instance.new("Container", 9, 9))

	if Run:IsRunning() then
		local constants = GameScene:GetService("Constants")
		self.Maid:GiveTask(Input.InputBegan:Connect(function(input)
			if input.KeyCode == constants.ToggleFlight then
				self.Flying = not self.Flying
			end

			if input.KeyCode == constants.Jump then
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

	
	-- local origin = self:GetFootPosition()-Vector.yAxis*self.EntitySizeInBlocks.Y
	-- local direction = self.World:GetMouseInBlockSpace() - origin
	-- local intersection = self.World:RaycastBlocks(origin, direction)

	local constants = GameScene:GetService("Constants")
	self:SetAttribute("Grounded", self:Grounded())

	if self.Flying then
		self.Velocity = Vector.zero
		if Input:IsKeyPressed(constants.MoveLeft) then
			self:SetPosition(self:GetPosition() - Vector.xAxis * self.FlySpeed*dt)
		end
		if Input:IsKeyPressed(constants.MoveRight) then
			self:SetPosition(self:GetPosition() + Vector.xAxis * self.FlySpeed*dt)
		end
		if Input:IsKeyPressed(constants.MoveUp) then
			self:SetPosition(self:GetPosition() - Vector.yAxis * self.FlySpeed*dt)
		end
		if Input:IsKeyPressed(constants.MoveDown) then
			self:SetPosition(self:GetPosition() + Vector.yAxis * self.FlySpeed*dt)
		end
	else
		if Input:IsKeyPressed(constants.MoveLeft) then
			self.Velocity = self.Velocity*Vector.yAxis - Vector.xAxis * self.MoveSpeed
		elseif Input:IsKeyPressed(constants.MoveRight) then
			self.Velocity = self.Velocity*Vector.yAxis + Vector.xAxis * self.MoveSpeed
		else
			self.Velocity = self.Velocity*Vector.yAxis
		end
	end
	
	module.Base.Update(self, dt)
end

return Instance.RegisterClass(module)