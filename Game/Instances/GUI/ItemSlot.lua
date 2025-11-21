local module = {}
module.Derives = "Button"
module.__index = module
module.__type = "ItemSlot"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
    self.Name = self.__type
	self.Size = UDim2.new(0, 50, 0, 50)
	self.Color = Color.new(0,0,0,0)

	-- self.SlotFrame = Instance.new("ImageLabel")
	-- self.SlotFrame.Archivable = false
	-- self.SlotFrame.Name = "Slot"
	-- self.SlotFrame.Image = "Game/Assets/GUI/ItemSlot.png"
	-- self.SlotFrame.Size = UDim2.new(1, 0, 1, 0)
	-- self.SlotFrame:SetParent(self)

	self.SlotFrame = Instance.new("Frame")
	self.SlotFrame.Archivable = false
	self.SlotFrame.Name = "Slot"
	self.SlotFrame.Size = UDim2.new(1, 0, 1, 0)
	self.SlotFrame.Position = UDim2.fromScale(0.5, 0.5)
	self.SlotFrame.Color = Color.new(0,0,0, 0.4)
	self.SlotFrame.AnchorPoint = Vector.one/2
	self.SlotFrame:SetParent(self)

	local borderThickness = 2
	do
		local light1 = Instance.new("Frame")
		light1.Size = UDim2.new(1, 0, 0, borderThickness)
		light1.Color = Color.new(1, 1, 1, 0.4)
		light1.Position = UDim2.new(0.5, 0, 0, 0)
		light1.AnchorPoint = Vector.new(0.5, 0)
		light1.ZIndex = 3
		light1:SetParent(self.SlotFrame)
		
		local light2 = Instance.new("Frame")
		light2.Size = UDim2.new(0, borderThickness, 1, -borderThickness)
		light2.Color = Color.new(1, 1, 1, 0.4)
		light2.Position = UDim2.new(0, 0, 0.5, borderThickness/2)
		light2.AnchorPoint = Vector.new(0, 0.5)
		light2.ZIndex = 3
		light2:SetParent(self.SlotFrame)
		
		local dark1 = Instance.new("Frame")
		dark1.Size = UDim2.new(0, borderThickness, 1, -borderThickness)
		dark1.Color = Color.new(0, 0, 0, 0.4)
		dark1.Position = UDim2.new(1, 0, 0.5, borderThickness/2)
		dark1.AnchorPoint = Vector.new(1, 0.5)
		dark1.ZIndex = 3
		dark1:SetParent(self.SlotFrame)

		local dark2 = Instance.new("Frame")
		dark2.Size = UDim2.new(1, -borderThickness*2, 0, borderThickness)
		dark2.Color = Color.new(0, 0, 0, 0.4)
		dark2.Position = UDim2.new(0.5, 0, 1, 0)
		dark2.AnchorPoint = Vector.new(0.5, 1)
		dark2.ZIndex = 3
		dark2:SetParent(self.SlotFrame)
	end
	
	self.RenderFrame = Instance.new("ItemRenderFrame")
	self.RenderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	self.RenderFrame.Archivable = false
	self.RenderFrame.AnchorPoint = Vector.new(0.5, 0.5)
	self.RenderFrame.Color = Color.new(1, 1, 1, 0)
	self.RenderFrame.Name = "RenderFrame"
	self.RenderFrame.ZIndex = 1
	self.RenderFrame.Size = UDim2.new(1, -borderThickness*2, 1, -borderThickness*2)
	self.RenderFrame:SetParent(self.SlotFrame)

	self.AmountLabel = Instance.new("TextLabel")
	self.AmountLabel.Position = UDim2.new(0.5, 0, 1, -borderThickness)
	self.AmountLabel.Archivable = false
	self.AmountLabel.AnchorPoint = Vector.new(0.5, 1)
	self.AmountLabel.XAlignment = Enum.XAlignment.Right
	self.AmountLabel.YAlignment = Enum.YAlignment.Bottom
	self.AmountLabel.Name = "AmountLabel"
	self.AmountLabel.ZIndex = 2
	self.AmountLabel.Size = UDim2.new(1, -borderThickness*2, 0, 16)
	self.AmountLabel:SetParent(self.SlotFrame)

	self:SetItem()

	return self
end

function module:SetItem(stack)
	if stack and stack.ID then
		self.AmountLabel.Text = stack.Amount ~= 1 and tostring(stack.Amount) or ""
		self.RenderFrame.ItemID = stack.ID or ""
	else
		self.AmountLabel.Text = ""
		self.RenderFrame.ItemID = ""
	end
end

return Instance.RegisterClass(module)