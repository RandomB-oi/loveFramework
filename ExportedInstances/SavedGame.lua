return function()
	local Frame9 = Instance.new("Frame")
	local Frame7 = Instance.new("Frame")
	local Frame10 = Instance.new("Frame")
	local Frame2 = Instance.new("Frame")
	local TextLabel1 = Instance.new("TextLabel")
	local Frame1 = Instance.new("Frame")
	local IntValue1 = Instance.new("IntValue")
	local Frame4 = Instance.new("Frame")
	local Scene1 = Instance.new("Scene")
	local Scene2 = Instance.new("Scene")
	local IntValue2 = Instance.new("IntValue")
	local TextLabel2 = Instance.new("TextLabel")
	local Frame3 = Instance.new("Frame")
	local TextLabel3 = Instance.new("TextLabel")
	local Frame5 = Instance.new("Frame")
	local Frame8 = Instance.new("Frame")
	local Frame6 = Instance.new("Frame")
	IntValue1.Name = "MaxHealth"
	IntValue1.Value = 100
	IntValue1:SetParent(Scene1)
	IntValue2.Name = "Health"
	IntValue2.Value = 100
	IntValue2:SetParent(Scene1)
	Frame3.Name = "HealthBar"
	Frame3.Size = UDim2.new(1, 0, 1, 0)
	Frame3.Color = Color.new(1, 1, 0, 1)
	Frame3.Position = UDim2.new(0, 0, 0, 0)
	Frame3:SetParent(Frame2)
	Frame2.Name = "HealthBarBackdrop"
	Frame2.Size = UDim2.new(1, -200, 1, 0)
	Frame2.Color = Color.new(1, 0, 0, 1)
	Frame2.Position = UDim2.new(0, 50, 0, 0)
	Frame2:SetParent(Frame1)
	TextLabel1.Name = "HealthLabel"
	TextLabel1.AnchorPoint = Vector.new(1, 0)
	TextLabel1.Text = "100/100"
	TextLabel1.Size = UDim2.new(0, 150, 1, 0)
	TextLabel1.Color = Color.new(1, 1, 1, 1)
	TextLabel1.Position = UDim2.new(1, 0, 0, 0)
	TextLabel1:SetParent(Frame1)
	TextLabel2.Name = "HPLabel"
	TextLabel2.Text = "HP"
	TextLabel2.Size = UDim2.new(0, 50, 1, 0)
	TextLabel2.Color = Color.new(1, 1, 1, 1)
	TextLabel2.Position = UDim2.new(0, 0, 0, 0)
	TextLabel2:SetParent(Frame1)
	Frame1.Name = "HealthBarPanel"
	Frame1.AnchorPoint = Vector.new(0.5, 1)
	Frame1.Size = UDim2.new(0, 340, 0, 50)
	Frame1.Color = Color.new(1, 1, 1, 0)
	Frame1.Position = UDim2.new(0.5, 0, 1, 0)
	Frame1:SetParent(Scene2)
	TextLabel3.Name = "TextLabel"
	TextLabel3.AnchorPoint = Vector.new(0.5, 0.5)
	TextLabel3.Rotation = 35
	TextLabel3.Text = "NewText "
	TextLabel3.Size = UDim2.new(1, 0, 1, 0)
	TextLabel3.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextLabel3:SetParent(Frame4)
	Frame4.Name = "Frame"
	Frame4.AnchorPoint = Vector.new(0.5, 0)
	Frame4.Size = UDim2.new(0, 300, 0, 200)
	Frame4.Color = Color.new(1, 1, 1, 0.3921568627451)
	Frame4.Position = UDim2.new(0.5, 0, 0, 0)
	Frame4:SetParent(Scene2)
	Frame7.Name = "Frame"
	Frame7.AnchorPoint = Vector.new(0.5, 0.5)
	Frame7.Size = UDim2.new(0, 2, 1, 0)
	Frame7.Color = Color.new(0, 0, 0, 0)
	Frame7.Position = UDim2.new(1, 0, 0.5, 0)
	Frame7:SetAttribute("AxisLock", Vector.new(1, 0))
	Frame7:AddTag("BattleGrounded")
	Frame7:SetParent(Frame6)
	Frame8.Name = "Frame"
	Frame8.AnchorPoint = Vector.new(0.5, 0.5)
	Frame8.Size = UDim2.new(0, 2, 1, 0)
	Frame8.Color = Color.new(0, 0, 0, 0)
	Frame8.Position = UDim2.new(0, 0, 0.5, 0)
	Frame8:SetAttribute("AxisLock", Vector.new(-1, 0))
	Frame8:AddTag("BattleGrounded")
	Frame8:SetParent(Frame6)
	Frame9.Name = "Frame"
	Frame9.AnchorPoint = Vector.new(0.5, 0.5)
	Frame9.Size = UDim2.new(1, 0, 0, 2)
	Frame9.Color = Color.new(0, 0, 0, 0)
	Frame9.Position = UDim2.new(0.5, 0, 1, 0)
	Frame9:SetAttribute("AxisLock", Vector.new(0, 1))
	Frame9:AddTag("BattleGrounded")
	Frame9:SetParent(Frame6)
	Frame10.Name = "Frame"
	Frame10.AnchorPoint = Vector.new(0.5, 0.5)
	Frame10.Size = UDim2.new(1, 0, 0, 2)
	Frame10.Color = Color.new(0, 0, 0, 0)
	Frame10.Position = UDim2.new(0.5, 0, 0, 0)
	Frame10:SetAttribute("AxisLock", Vector.new(0, -1))
	Frame10:AddTag("BattleGrounded")
	Frame10:SetParent(Frame6)
	Frame6.Name = "Frame"
	Frame6.AnchorPoint = Vector.new(0.5, 0.5)
	Frame6.Size = UDim2.new(1, -24, 1, -24)
	Frame6.Color = Color.new(0, 0, 0, 1)
	Frame6.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame6:SetParent(Frame5)
	Frame5.Name = "Frame"
	Frame5.ZIndex = -1
	Frame5.AnchorPoint = Vector.new(0.5, 0.5)
	Frame5.Size = UDim2.new(0, 324, 0, 324)
	Frame5.Color = Color.new(0, 1, 0, 1)
	Frame5.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame5:SetParent(Scene2)
	Scene2.Name = "BattleScene"
	Scene2.Size = UDim2.new(1, 0, 1, 0)
	Scene2:SetParent(Scene1)
	Scene1.Name = "Game"
	Scene1.Size = UDim2.new(1, 0, 1, 0)
	return Scene1
end