return function(parent)
	local Frame1 = Instance.new("Frame")
	local Button1 = Instance.new("Button")
	local TextLabel1 = Instance.new("TextLabel")
	local ImageLabel1 = Instance.new("ImageLabel")
	Frame1.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame1.Archivable = false
	Frame1.AnchorPoint = Vector.new(0.5, 0.5)
	Frame1.Color = Color.new(1, 1, 1, 0)
	Frame1.Name = [[RenderFrame]]
	Frame1.ZIndex = 1
	Frame1.Size = UDim2.new(0.7, 0, 0.7, 0)
	Frame1:SetParent(ImageLabel1)
	TextLabel1.Position = UDim2.new(0.5, 0, 0.9, 0)
	TextLabel1.Archivable = false
	TextLabel1.AnchorPoint = Vector.new(0.5, 1)
	TextLabel1.XAlignment = Enum.TextXAlignment.Right
	TextLabel1.YAlignment = Enum.TextYAlignment.Bottom
	TextLabel1.Name = [[AmountLabel]]
	TextLabel1.Text = [[Amount]]
	TextLabel1.ZIndex = 2
	TextLabel1.Size = UDim2.new(0.8, 0, 0, 16)
	TextLabel1:SetParent(ImageLabel1)
	ImageLabel1.Archivable = false
	ImageLabel1.Name = [[Slot]]
	ImageLabel1.Image = [[Game/Assets/GUI/ItemSlot.png]]
	ImageLabel1.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel1:SetParent(Button1)
	Button1.Archivable = false
	Button1.Name = [[Button]]
	Button1.Size = UDim2.new(0, 50, 0, 50)
	if parent then Button1:SetParent(parent) end
	return Button1
end