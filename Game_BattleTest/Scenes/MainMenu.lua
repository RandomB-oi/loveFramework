local newScene = Instance.new("Scene", Vector.new(800, 600))
newScene:SetParent(GameScene)

local newFrame = Instance.new("Frame")
newFrame.Position = UDim2.new(0, 6, 0, 6)
newFrame.AnchorPoint = Vector.zero
newFrame.Size = UDim2.new(.5,-12, 1,-12)
newFrame.Color = Color.new(1,1,1, 0.5)
newFrame:SetParent(newScene)

local layout = Instance.new("UIListLayout")
layout:SetParent(newFrame)

for i = 1, 5 do
	local newOption = Instance.new("Button")
	newOption.Size = UDim2.new(1,0,0,50)
	newOption.Color = Color.new(math.random(), math.random(), math.random(), 1)
	newOption:SetParent(newFrame)
end

return newScene