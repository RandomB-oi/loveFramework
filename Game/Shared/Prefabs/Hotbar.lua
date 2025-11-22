return function(parent)
	local UIListLayout1 = Instance.new("UIListLayout")
	local Frame1 = Instance.new("Frame")
	UIListLayout1.Name = [[UIListLayout]]
	UIListLayout1.AbsoluteContentSize = Vector.new(50, 0)
	UIListLayout1.ListAxis = Vector.new(1, 0)
	UIListLayout1.Archivable = false
	UIListLayout1.Parent = Frame1
	Frame1.Name = [[Panel]]
	Frame1.Color = Color.new(1, 1, 1, 0.3921568627451)
	Frame1.Size = UDim2.new(0, 274, 0, 50)
	Frame1.AnchorPoint = Vector.new(0.5, 1)
	Frame1.Archivable = false
	Frame1.Position = UDim2.new(0.5, 0, 1, 0)

	

	if parent then Frame1.Parent = parent end
	return Frame1
end