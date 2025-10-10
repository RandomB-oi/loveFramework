return function(parent)
	local Frame1 = Instance.new("Frame")
	local Frame6 = Instance.new("Frame")
	local Frame5 = Instance.new("Frame")
	local Frame2 = Instance.new("Frame")
	local Frame4 = Instance.new("Frame")
	local Frame3 = Instance.new("Frame")
	Frame3.Size = UDim2.new(1, 0, 0, 2)
	Frame3.Color = Color.new(0, 0, 0, 0)
	Frame3.AnchorPoint = Vector.new(0.5, 0.5)
	Frame3.Name = [[BottomMarker]]
	Frame3.Position = UDim2.new(0.5, 0, 1, 0)
	Frame3:SetAttribute("AxisLock", Vector.new(0, 1))
	Frame3:AddTag("BattleGrounded")
	Frame3:SetParent(Frame2)
	Frame4.Size = UDim2.new(0, 2, 1, 0)
	Frame4.Color = Color.new(0, 0, 0, 0)
	Frame4.AnchorPoint = Vector.new(0.5, 0.5)
	Frame4.Name = [[RightMarker]]
	Frame4.Position = UDim2.new(1, 0, 0.5, 0)
	Frame4:SetAttribute("AxisLock", Vector.new(1, 0))
	Frame4:AddTag("BattleGrounded")
	Frame4:SetParent(Frame2)
	Frame5.Size = UDim2.new(1, 0, 0, 2)
	Frame5.Color = Color.new(0, 0, 0, 0)
	Frame5.AnchorPoint = Vector.new(0.5, 0.5)
	Frame5.Name = [[TopMarker]]
	Frame5.Position = UDim2.new(0.5, 0, 0, 0)
	Frame5:SetAttribute("AxisLock", Vector.new(0, -1))
	Frame5:AddTag("BattleGrounded")
	Frame5:SetParent(Frame2)
	Frame6.Size = UDim2.new(0, 2, 1, 0)
	Frame6.Color = Color.new(0, 0, 0, 0)
	Frame6.AnchorPoint = Vector.new(0.5, 0.5)
	Frame6.Name = [[LeftMarker]]
	Frame6.Position = UDim2.new(0, 0, 0.5, 0)
	Frame6:SetAttribute("AxisLock", Vector.new(-1, 0))
	Frame6:AddTag("BattleGrounded")
	Frame6:SetParent(Frame2)
	Frame2.Size = UDim2.new(1, -24, 1, -24)
	Frame2.Color = Color.new(0, 0, 0, 1)
	Frame2.AnchorPoint = Vector.new(0.5, 0.5)
	Frame2.Name = [[BattleArea]]
	Frame2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame2:SetParent(Frame1)
	Frame1.ZIndex = -1
	Frame1.Size = UDim2.new(0, -24, 0, -24)
	Frame1.Color = Color.new(0, 1, 0, 1)
	Frame1.AnchorPoint = Vector.new(0.5, 0.5)
	Frame1.Name = [[BattleBox]]
	Frame1.Position = UDim2.new(0.5, 0, 0.5, 0)
	if parent then Frame1:SetParent(parent) end
	return Frame1
end