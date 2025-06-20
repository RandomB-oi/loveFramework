local newScene = Instances.Scene.new(Vector.new(800, 600))

local newFrame = Instances.Frame.new()
newFrame.Size = UDim2.new(1,-12,1,-12)
newFrame.Position = UDim2.FromScale(0.5, 0.5)
newFrame.AnchorPoint = Vector.one/2
newFrame.Parent = newScene

local newFrame2 = Instances.TextLabel.new()
newFrame2.Text = "Haiiii"
newFrame2.Size = UDim2.new(1,-12,.5,-6)
newFrame2.Position = UDim2.new(0.5, 0, 0, 6)
newFrame2.AnchorPoint = Vector.new(0.5, 0)
newFrame2.Color = Color.from255(255,0,0,255)
newFrame2.Parent = newFrame

local ogF = newScene.Update

function newScene:Update(dt)
	newFrame2.Size = UDim2.new(1, -12, 0.5, 0)
	ogF(newScene)
end

return newScene