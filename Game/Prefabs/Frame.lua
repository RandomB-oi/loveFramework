return function()
	local Frame1 = Instance.new("Frame")
	local TextLabel1 = Instance.new("TextLabel")
	TextLabel1.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextLabel1.AnchorPoint = Vector.new(0.5, 0.5)
	TextLabel1.Name = "TextLabel"
	TextLabel1.Size = UDim2.new(1, 0, 1, 0)
	TextLabel1.Text = "Textbox"
	TextLabel1:SetParent(Frame1)
	Frame1.Position = UDim2.new(0.5, 0, 0, 0)
	Frame1.AnchorPoint = Vector.new(0.5, 0)
	Frame1.Name = "Frame"
	Frame1.Size = UDim2.new(0, 300, 0, 200)
	Frame1.Color = Color.new(1, 1, 1, 0.3921568627451)
	return Frame1
end