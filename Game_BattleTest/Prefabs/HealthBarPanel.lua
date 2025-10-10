return function(parent)
	local TextLabel1 = Instance.new("TextLabel")
	local Frame3 = Instance.new("Frame")
	local TextLabel2 = Instance.new("TextLabel")
	local Frame1 = Instance.new("Frame")
	local Frame2 = Instance.new("Frame")
	TextLabel1.Color = Color.new(1, 1, 1, 1)
	TextLabel1.Name = "HPLabel"
	TextLabel1.Position = UDim2.new(0, 0, 0, 0)
	TextLabel1.Text = "HP"
	TextLabel1.Size = UDim2.new(0, 50, 1, 0)
	TextLabel1:SetParent(Frame1)
	Frame3.Color = Color.new(1, 1, 0, 1)
	Frame3.Name = "HealthBar"
	Frame3.Position = UDim2.new(0, 0, 0, 0)
	Frame3.Size = UDim2.new(1, 0, 1, 0)
	Frame3:SetParent(Frame2)
	Frame2.Color = Color.new(1, 0, 0, 1)
	Frame2.Name = "HealthBarBackdrop"
	Frame2.Position = UDim2.new(0, 50, 0, 0)
	Frame2.Size = UDim2.new(1, -200, 1, 0)
	Frame2:SetParent(Frame1)
	TextLabel2.Color = Color.new(1, 1, 1, 1)
	TextLabel2.Name = "HealthLabel"
	TextLabel2.Position = UDim2.new(1, 0, 0, 0)
	TextLabel2.AnchorPoint = Vector.new(1, 0)
	TextLabel2.Text = "100/100"
	TextLabel2.Size = UDim2.new(0, 150, 1, 0)
	TextLabel2:SetParent(Frame1)
	Frame1.Color = Color.new(1, 1, 1, 0)
	Frame1.Name = "HealthBarPanel"
	Frame1.Position = UDim2.new(0.5, 0, 1, 0)
	Frame1.AnchorPoint = Vector.new(0.5, 1)
	Frame1.Size = UDim2.new(0, 340, 0, 50)
	if parent then Frame1:SetParent(parent) end
	return Frame1
end