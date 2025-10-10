local InputService = Engine:GetService("InputService")
local Debris = Engine:GetService("Debris")
local TweenService = Engine:GetService("TweenService")
local CollectionService = Engine:GetService("CollectionService")

local Collision = require("Game.Utility.Collision")

local Scene = Instance.new("Scene")
Scene.Name = "BattleScene"
Scene:SetParent(GameScene)
-- Scene:Pause()

-- require("Game.Prefabs.Frame")():SetParent(Scene)
-- local backdrop = Instance.new("Frame")
-- backdrop.Size = UDim2.fromScale(1,1)
-- backdrop.Color = Color.new(1,1,1,.25)
-- backdrop.ZIndex = -10
-- backdrop:SetParent(Scene)

function Scene:BeginBattle(soulMode, turnLength, battleBoxSize)
	local battle = Instance.new("Battle", soulMode, turnLength)
	battle:ScaleBox(1, battleBoxSize or Vector.one*300, 0)
	battle.Done:Wait()
end

task.spawn(function()
	while true do
		print("new battle")
		Scene:BeginBattle(Enum.SoulMode.Determination, 60)

		task.wait(1)
	end
end)

return Scene