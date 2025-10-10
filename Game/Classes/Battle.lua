local module = {}
module.__index = module
module.__type = "Battle"
Instance.RegisterClass(module)

local Debris = Engine:GetService("Debris")
local TweenService = Engine:GetService("TweenService")
local CollectionService = Engine:GetService("CollectionService")

local function ClearProjectiles()
	repeat
		local key, proj = next(CollectionService:GetTagged("Projectile"))
		if proj then
			proj:Destroy()
		end
	until not key
end

local _lastHurt = -math.huge
local immunityFrames = 1/2
local function Hurt(amount)
	if os.clock() - _lastHurt < immunityFrames then
		return
	end
	_lastHurt = os.clock()

	GameVariables.Health.Value = math.clamp(GameVariables.Health.Value - amount, 0, GameVariables.MaxHealth.Value)
end


module.new = function(soulMode, turnLength)
	local self = setmetatable({}, module)
	self.Maid = Maid.new()
	self.Done = Signal.new()

	self.Scene = GameScene:WaitForChild("BattleScene")

	self.BattleBox = require("Game.Prefabs.BattleBox")()
	self.BattleBox:SetParent(self.Scene)

	self.BattleArea = self.BattleBox:FindFirstChild("BattleArea", true)
	
	self.HealthBarPanel = require("Game.Prefabs.HealthBarPanel")()
	self.HealthBarPanel:SetParent(self.Scene)

	self.HPLabel = self.HealthBarPanel:FindFirstChild("HPLabel", true)
	self.HealthLabel = self.HealthBarPanel:FindFirstChild("HealthLabel", true)
	self.HealthBarBackdrop = self.HealthBarPanel:FindFirstChild("HealthBarBackdrop", true)
	self.HealthBar = self.HealthBarPanel:FindFirstChild("HealthBar", true)


	self:ScaleHealth()
	
	self.Maid:GiveTask(task.delay(turnLength, self.Destroy, self))
	self.Maid:GiveTask(function()
		ClearProjectiles()
		task.wait(1/2)
		self.HealthBarPanel:Destroy()
		task.wait(1/2)
		self:ScaleBox(0.5, Vector.one*-24, 90)
		self.BattleBox:Destroy()
		
		self.Done:Fire()
	end)

	self.Heart = self.Maid:Add(Instance.new("Soul"))
	self.Heart.Position = UDim2.fromScale(0.5, 0.5)
	if soulMode then
		self.Heart.SoulMode = soulMode
	end
	self.Heart:SetParent(self.BattleArea)

	self.Maid:GiveTask(self.Scene.Updated:Connect(function(dt)
		-- self:NewProjectile()
		self:ScaleHealth()
		
		local touching, tpAmount = self.Heart:TouchingProjectile()
		if touching then
			touching:Destroy()
			Hurt(1)
		end
	end))

	return self
end



function module:ScaleHealth()
	self.HealthLabel.Text = tostring(GameVariables.Health.Value).."/"..tostring(GameVariables.MaxHealth.Value)
	self.HealthBar.Size = UDim2.fromScale(GameVariables.Health.Value/GameVariables.MaxHealth.Value, 1)
	self.HealthBarPanel.Size = UDim2.fromOffset(240+(GameVariables.MaxHealth.Value), 50)
end



function module:NewProjectile()
	if os.clock() - (self._lastProjectile or 0) < 1/10 then
		return
	end
	self._lastProjectile = os.clock()

	local angle = math.rad(math.random(1, 360))
	local dir = Vector.FromAngle(angle) * -2000
	
    local diff = (self.Heart.RenderPosition + self.Heart.RenderSize * self.Heart.AnchorPoint-self.Heart:GetScene().RenderPosition) - dir
	
	local projectile = Instance.new("Projectile"):AddTag("Projectile")
	projectile.Speed = 100
	projectile.Position = UDim2.fromOffset(dir.X, dir.Y)
    projectile.Rotation = math.deg(math.atan2(diff.Y, diff.X)+math.pi/2)
	projectile:SetParent(self.Scene)
	

	Debris:AddItem(projectile, 5)
end



function module:ScaleBox(length, size, rotation, opacity)
	local tweenMaid = Maid.new()

	local info = TweenInfo.new(length, "Quad", "In")

	tweenMaid:Add(TweenService:Create(self.BattleBox, info, {
		Size = UDim2.fromOffset(size.X + 24, size.Y + 24),
		Rotation = rotation,
		Color = Color.new(self.BattleBox.Color.R, self.BattleBox.Color.G, self.BattleBox.Color.B, opacity)
	})):Play()
	tweenMaid:Add(TweenService:Create(self.BattleArea, info, {
		Color = Color.new(self.BattleArea.Color.R, self.BattleArea.Color.G, self.BattleArea.Color.B, opacity)
	})):Play().Completed:Wait()

	tweenMaid:Destroy()
end

function module:Destroy()
	self.Maid:Destroy()
end

return module