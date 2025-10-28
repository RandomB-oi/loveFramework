local module = {}
module.Derives = "Button"
module.__index = module
module.__type = "ItemSlot"
Instance.RegisterClass(module)

module.new = function()
	local self = setmetatable(module.Base.new(), module)
    self.Name = self.__type
	self.Size = UDim2.new(0, 50, 0, 50)

	self.SlotFrame = Instance.new("ImageLabel")
	self.SlotFrame.Archivable = false
	self.SlotFrame.Name = "Slot"
	self.SlotFrame.Image = "Game/Assets/GUI/ItemSlot.png"
	self.SlotFrame.Size = UDim2.new(1, 0, 1, 0)
	self.SlotFrame:SetParent(self)
	
	self.RenderFrame = Instance.new("ItemRenderFrame")
	self.RenderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	self.RenderFrame.Archivable = false
	self.RenderFrame.AnchorPoint = Vector.new(0.5, 0.5)
	self.RenderFrame.Color = Color.new(1, 1, 1, 0)
	self.RenderFrame.Name = "RenderFrame"
	self.RenderFrame.ZIndex = 1
	self.RenderFrame.Size = UDim2.new(0.6, 0, 0.6, 0)
	self.RenderFrame:SetParent(self.SlotFrame)

	self.AmountLabel = Instance.new("TextLabel")
	self.AmountLabel.Position = UDim2.new(0.5, 0, 0.9, 0)
	self.AmountLabel.Archivable = false
	self.AmountLabel.AnchorPoint = Vector.new(0.5, 1)
	self.AmountLabel.XAlignment = Enum.TextXAlignment.Right
	self.AmountLabel.YAlignment = Enum.TextYAlignment.Bottom
	self.AmountLabel.Name = "AmountLabel"
	self.AmountLabel.ZIndex = 2
	self.AmountLabel.Size = UDim2.new(0.8, 0, 0, 16)
	self.AmountLabel:SetParent(self.SlotFrame)

	self:SetItem()

	return self
end

function module:SetItem(stack)
	if stack then
		self.AmountLabel.Text = stack.Amount ~= 1 and tostring(stack.Amount) or ""
		self.RenderFrame.ItemID = stack.ID or -1
	else
		self.AmountLabel.Text = ""
		self.RenderFrame.ItemID = -1
	end
end

return module