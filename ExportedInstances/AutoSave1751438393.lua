return function()
	local Frame1 = Instance.new("Frame")
	local TextLabel3 = Instance.new("TextLabel")
	local TextLabel1 = Instance.new("TextLabel")
	local Scene1 = Instance.new("Scene")
	local Soul1 = Instance.new("Soul")
	local Frame9 = Instance.new("Frame")
	local Scene2 = Instance.new("Scene")
	local TextLabel2 = Instance.new("TextLabel")
	local Frame5 = Instance.new("Frame")
	local Frame7 = Instance.new("Frame")
	local IntValue1 = Instance.new("IntValue")
	local Frame2 = Instance.new("Frame")
	local Frame6 = Instance.new("Frame")
	local IntValue2 = Instance.new("IntValue")
	local Frame10 = Instance.new("Frame")
	local Frame4 = Instance.new("Frame")
	local Frame3 = Instance.new("Frame")
	local Frame8 = Instance.new("Frame")
	IntValue1.Name = "MaxHealth"
	IntValue1.Value = 100
	IntValue1:SetParent(Scene1)
	IntValue2.Name = "Health"
	IntValue2.Value = 100
	IntValue2:SetParent(Scene1)
	Frame3.Name = "Frame"
	Frame3.Position = UDim2.new(1, 0, 0.5, 0)
	Frame3.AnchorPoint = Vector.new(0.5, 0.5)
	Frame3.Color = Color.new(0, 0, 0, 0)
	Frame3.Size = UDim2.new(0, 2, 1, 0)
	Frame3:SetAttribute("AxisLock", Vector.new(1, 0))
	Frame3:AddTag("BattleGrounded")
	Frame3:SetParent(Frame2)
	Frame4.Name = "Frame"
	Frame4.Position = UDim2.new(0.5, 0, 1, 0)
	Frame4.AnchorPoint = Vector.new(0.5, 0.5)
	Frame4.Color = Color.new(0, 0, 0, 0)
	Frame4.Size = UDim2.new(1, 0, 0, 2)
	Frame4:SetAttribute("AxisLock", Vector.new(0, 1))
	Frame4:AddTag("BattleGrounded")
	Frame4:SetParent(Frame2)
	Frame5.Name = "Frame"
	Frame5.Position = UDim2.new(0.5, 0, 0, 0)
	Frame5.AnchorPoint = Vector.new(0.5, 0.5)
	Frame5.Color = Color.new(0, 0, 0, 0)
	Frame5.Size = UDim2.new(1, 0, 0, 2)
	Frame5:SetAttribute("AxisLock", Vector.new(0, -1))
	Frame5:AddTag("BattleGrounded")
	Frame5:SetParent(Frame2)
	Frame6.Name = "Frame"
	Frame6.Position = UDim2.new(0, 0, 0.5, 0)
	Frame6.AnchorPoint = Vector.new(0.5, 0.5)
	Frame6.Color = Color.new(0, 0, 0, 0)
	Frame6.Size = UDim2.new(0, 2, 1, 0)
	Frame6:SetAttribute("AxisLock", Vector.new(-1, 0))
	Frame6:AddTag("BattleGrounded")
	Frame6:SetParent(Frame2)
	Frame2.Name = "Frame"
	Frame2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame2.AnchorPoint = Vector.new(0.5, 0.5)
	Frame2.Color = Color.new(0, 0, 0, 1)
	Frame2.Size = UDim2.new(1, -24, 1, -24)
	Frame2:SetParent(Frame1)
	Frame1.Name = "Frame"
	Frame1.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame1.AnchorPoint = Vector.new(0.5, 0.5)
	Frame1.ZIndex = -1
	Frame1.Color = Color.new(0, 1, 0, 1)
	Frame1.Size = UDim2.new(0, 324, 0, 324)
	Frame1:SetParent(Scene2)
	Soul1.Name = "Soul"
	Soul1.Image = "Game/Assets/Souls/Determination.png"
	Soul1.Position = UDim2.new(0, 198.68047122867, 0, 288.68047122867)
	Soul1.AnchorPoint = Vector.new(0.5, 0.5)
	Soul1.ZIndex = 2
	Soul1.Color = Color.new(1, 1, 1, 1)
	Soul1.Size = UDim2.new(0, 34, 0, 34)
	Soul1:SetParent(Scene2)
	TextLabel1.Name = "TextLabel"
	TextLabel1.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextLabel1.AnchorPoint = Vector.new(0.5, 0.5)
	TextLabel1.Size = UDim2.new(1, 0, 1, 0)
	TextLabel1.Text = "Textbox"
	TextLabel1:SetParent(Frame7)
	Frame7.Name = "Frame"
	Frame7.Position = UDim2.new(0.5, 0, 0, 0)
	Frame7.AnchorPoint = Vector.new(0.5, 0)
	Frame7.Color = Color.new(1, 1, 1, 0.3921568627451)
	Frame7.Size = UDim2.new(0, 300, 0, 200)
	Frame7:SetParent(Scene2)
	TextLabel2.Name = "HPLabel"
	TextLabel2.Position = UDim2.new(0, 0, 0, 0)
	TextLabel2.Color = Color.new(1, 1, 1, 1)
	TextLabel2.Size = UDim2.new(0, 50, 1, 0)
	TextLabel2.Text = "HP"
	TextLabel2:SetParent(Frame8)
	TextLabel3.Name = "HealthLabel"
	TextLabel3.Position = UDim2.new(1, 0, 0, 0)
	TextLabel3.AnchorPoint = Vector.new(1, 0)
	TextLabel3.Color = Color.new(1, 1, 1, 1)
	TextLabel3.Size = UDim2.new(0, 150, 1, 0)
	TextLabel3.Text = "100/100"
	TextLabel3:SetParent(Frame8)
	Frame10.Name = "HealthBar"
	Frame10.Position = UDim2.new(0, 0, 0, 0)
	Frame10.Color = Color.new(1, 1, 0, 1)
	Frame10.Size = UDim2.new(1, 0, 1, 0)
	Frame10:SetParent(Frame9)
	Frame9.Name = "HealthBarBackdrop"
	Frame9.Position = UDim2.new(0, 50, 0, 0)
	Frame9.Color = Color.new(1, 0, 0, 1)
	Frame9.Size = UDim2.new(1, -200, 1, 0)
	Frame9:SetParent(Frame8)
	Frame8.Name = "HealthBarPanel"
	Frame8.Position = UDim2.new(0.5, 0, 1, 0)
	Frame8.AnchorPoint = Vector.new(0.5, 1)
	Frame8.Color = Color.new(1, 1, 1, 0)
	Frame8.Size = UDim2.new(0, 340, 0, 50)
	Frame8:SetParent(Scene2)
	Scene2.Name = "BattleScene"
	Scene2.Size = UDim2.new(1, 0, 1, 0)
	Scene2:SetParent(Scene1)
	Scene1.Name = "Game"
	Scene1.Size = UDim2.new(1, 0, 1, 0)
	return Scene1
end