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

	self.BattleBox = Instance.new("Frame")
	self.BattleBox.Size = UDim2.new(0, -24, 0, -24)
	self.BattleBox.Position = UDim2.fromScale(0.5, 0.5)
	self.BattleBox.AnchorPoint = Vector.one/2
	self.BattleBox.Color = Color.from255(0, 255, 0, 255)
	self.BattleBox.ZIndex = -1
	self.BattleBox:SetParent(self.Scene)

	self.BattleArea = Instance.new("Frame")
	self.BattleArea.Size = UDim2.new(1, -24, 1, -24)
	self.BattleArea.Position = UDim2.fromScale(0.5, 0.5)
	self.BattleArea.AnchorPoint = Vector.one/2
	self.BattleArea.Color = Color.from255(0, 0, 0, 255)
	self.BattleArea:SetParent(self.BattleBox)

	self.BottomMarker = self.Maid:Add(Instance.new("Frame")):AddTag("BattleGrounded"):SetAttribute("AxisLock", Vector.new(0, 1))
	self.BottomMarker.Size = UDim2.new(1, 0, 0, 2)
	self.BottomMarker.Position = UDim2.new(0.5, 0, 1, 0)
	self.BottomMarker.AnchorPoint = Vector.new(0.5, 0.5)
	self.BottomMarker.Color = Color.from255(0, 0, 0, 0)
	self.BottomMarker:SetParent(self.BattleArea)

	self.TopMarker = self.Maid:Add(Instance.new("Frame")):AddTag("BattleGrounded"):SetAttribute("AxisLock", Vector.new(0, -1))
	self.TopMarker.Size = UDim2.new(1, 0, 0, 2)
	self.TopMarker.Position = UDim2.new(0.5, 0, 0, 0)
	self.TopMarker.AnchorPoint = Vector.new(0.5, 0.5)
	self.TopMarker.Color = Color.from255(0, 0, 0, 0)
	self.TopMarker:SetParent(self.BattleArea)

	self.LeftMarker = self.Maid:Add(Instance.new("Frame")):AddTag("BattleGrounded"):SetAttribute("AxisLock", Vector.new(-1, 0))
	self.LeftMarker.Size = UDim2.new(0, 2, 1, 0)
	self.LeftMarker.Position = UDim2.new(0, 0, 0.5, 0)
	self.LeftMarker.AnchorPoint = Vector.new(0.5, 0.5)
	self.LeftMarker.Color = Color.from255(0, 0, 0, 0)
	self.LeftMarker:SetParent(self.BattleArea)

	self.RightMarker = self.Maid:Add(Instance.new("Frame")):AddTag("BattleGrounded"):SetAttribute("AxisLock", Vector.new(1, 0))
	self.RightMarker.Size = UDim2.new(0, 2, 1, 0)
	self.RightMarker.Position = UDim2.new(1, 0, 0.5, 0)
	self.RightMarker.AnchorPoint = Vector.new(0.5, 0.5)
	self.RightMarker.Color = Color.from255(0, 0, 0, 0)
	self.RightMarker:SetParent(self.BattleArea)
	
	self.HealthBarPanel = require("Game.Prefabs.HealthBarPanel")()
	self.HealthBarPanel:SetParent(self.Scene)

	self.HPLabel = self.HealthBarPanel:FindFirstChild("HPLabel", true)
	self.HealthLabel = self.HealthBarPanel:FindFirstChild("HealthLabel", true)
	self.HealthBarBackdrop = self.HealthBarPanel:FindFirstChild("HealthBarBackdrop", true)
	self.HealthBar = self.HealthBarPanel:FindFirstChild("HealthBar", true)

	-- self.HealthBarPanel = Instance.new("Frame")
	-- self.HealthBarPanel.Size = UDim2.fromOffset(250, 50)
	-- self.HealthBarPanel.Position = UDim2.fromScale(0.5, 1)
	-- self.HealthBarPanel.AnchorPoint = Vector.new(0.5, 1)
	-- self.HealthBarPanel.Color = Color.from255(255, 255, 255, 0)
	-- self.HealthBarPanel.Name = "HealthBarPanel"
	-- self.HealthBarPanel:SetParent(self.Scene


	-- self.HPLabel = Instance.new("TextLabel")
	-- self.HPLabel.Size = UDim2.new(0, 50, 1, 0)
	-- self.HPLabel.Position = UDim2.fromScale(0, 0)
	-- self.HPLabel.AnchorPoint = Vector.new(0, 0)
	-- self.HPLabel.Color = Color.from255(255, 255, 255, 255)
	-- self.HPLabel.XAlignment = Enum.TextXAlignment.Center
	-- self.HPLabel.YAlignment = Enum.TextYAlignment.Center
	-- self.HPLabel.Text = "HP"
	-- self.HPLabel.Name = "HPLabel"
	-- self.HPLabel:SetParent(self.HealthBarPanel

	-- self.HealthLabel = Instance.new("TextLabel")
	-- self.HealthLabel.Size = UDim2.new(0, 150, 1, 0)
	-- self.HealthLabel.Position = UDim2.fromScale(1, 0)
	-- self.HealthLabel.AnchorPoint = Vector.new(1, 0)
	-- self.HealthLabel.Color = Color.from255(255, 255, 255, 255)
	-- self.HealthLabel.XAlignment = Enum.TextXAlignment.Center
	-- self.HealthLabel.YAlignment = Enum.TextYAlignment.Center
	-- self.HealthLabel.Text = ""
	-- self.HealthLabel.Name = "HealthLabel"
	-- self.HealthLabel:SetParent(self.HealthBarPanel


	-- self.HealthBarBackdrop = Instance.new("Frame")
	-- self.HealthBarBackdrop.Size = UDim2.new(1, -200, 1, 0)
	-- self.HealthBarBackdrop.Position = UDim2.new(0, 50, 0, 0)
	-- self.HealthBarBackdrop.AnchorPoint = Vector.new(0, 0)
	-- self.HealthBarBackdrop.Color = Color.from255(255, 0, 0, 255)
	-- self.HealthBarBackdrop.Name = "HealthBarBackdrop"
	-- self.HealthBarBackdrop:SetParent(self.HealthBarPanel

	-- self.HealthBar = Instance.new("Frame")
	-- self.HealthBar.Size = UDim2.fromScale(0.25, 1)
	-- self.HealthBar.Position = UDim2.fromScale(0, 0)
	-- self.HealthBar.AnchorPoint = Vector.new(0, 0)
	-- self.HealthBar.Color = Color.from255(255, 255, 0, 255)
	-- self.HealthBar.Name = "HealthBar"
	-- self.HealthBar:SetParent(self.HealthBarBackdrop

	-- task.delay(1, function()
	-- 	Instance.CreateScript(self.HealthBarPanel, "Game/HealthBarPanel.lua")
	-- 	Instance.CreateScript(self.BattleBox, "Game/BattleBox.lua")
	-- end)

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

	self.Heart = self.Maid:Add(Instance.new("Soul", self.BattleArea, soulMode))
	self.Heart:SetParent(self.Scene)

	self.Maid:GiveTask(self.Scene.Updated:Connect(function(dt)
		-- NewProjectile()
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



local _lastProjectile = 0
local function NewProjectile()
	if os.clock() - _lastProjectile < 1/10 then
		return
	end
	_lastProjectile = os.clock()

	
	local angle = math.rad(math.random(1, 360))
	local dir = Vector.FromAngle(angle) * -2000
	local projectile = Instance.new("Projectile", dir, Scene.Heart):AddTag("Projectile")
	projectile.Speed = 1500
	projectile:SetParent(Scene)

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