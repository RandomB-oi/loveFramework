local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "Widget"
Instance.RegisterClass(module)



module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Size = UDim2.new(1, 0, 1, 0)
	self.Color = Color.from255(46, 46, 46, 255)
	self.Name = "Widget"
	
	self.Title = self.Maid:Add(Instance.new("TextLabel"))
	self.Title.Size = UDim2.new(1, 0, 0, 20)
	self.Title.Text = "Widget Title"
	self.Title.Name = "Title"
	self.Title:SetParent(self)

	self.WidgetHolder = self.Maid:Add(Instance.new("Frame"))
	self.WidgetHolder.Size = UDim2.new(1, 0, 1, -20)
	self.WidgetHolder.Position = UDim2.new(0, 0, 0, 20)
	self.WidgetHolder.Color = Color.new(0, 0, 0, 0)
	self.WidgetHolder.Name = "WidgetHolder"
	self.WidgetHolder:SetParent(self)

	return self
end

function module:AttachGui(gui)
	gui:SetParent(self.WidgetHolder)
	return gui
end

function module:SetTitle(text)
	self.Title.Text = text or ""
	return self
end

return module