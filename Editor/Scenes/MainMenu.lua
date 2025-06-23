local newScene = Instance.new("Scene", Vector.new(800, 600))
newScene.Parent = Game
newScene.Name = "Editor"
newScene.ZIndex = 10

local widget = Instance.new("Explorer")
widget.Position = UDim2.new(0, 6, 0, 6)
widget.AnchorPoint = Vector.zero
widget.Size = UDim2.new(.25,-6, 1,-12)
widget.Parent = newScene

local widget = Instance.new("Properties")
widget.Position = UDim2.new(1, -6, 0, 6)
widget.AnchorPoint = Vector.new(1, 0)
widget.Size = UDim2.new(.25,-6, 1,-12)
widget.Parent = newScene

-- local layout = Instance.new("UIListLayout")
-- layout.Parent = newFrame

-- for i = 1, 5 do
-- 	local newOption = Instance.new("Button")
-- 	newOption.Size = UDim2.new(1,0,0,50)
-- 	newOption.Color = Color.new(math.random(), math.random(), math.random(), 1)
-- 	newOption.Parent = newFrame
-- end

return newScene