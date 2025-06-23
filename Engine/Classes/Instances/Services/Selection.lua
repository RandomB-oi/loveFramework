local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "Selection"
Instance.RegisterClass(module)

module.new = function ()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	self.Selection = {}
	self.SelectionChanged = self.Maid:Add(Signal.new())
	
	return self
end

function module:Get()
	return table.shallowCopy(self.Selection)
end

function module:Set(new)
	self.Selection = new or {}
	self.SelectionChanged:Fire(self:Get())
end

function module:IsSelected(object)
	return table.find(self.Selection, object)
end

function module:Add(object)
	if self:IsSelected(object) then return end
	table.insert(self.Selection, object)
	self.SelectionChanged:Fire(self:Get())
end

function module:Remove(object)
	local index = self:IsSelected(object)
	if not index then return end
	table.remove(self.Selection, index)
	self.SelectionChanged:Fire(self:Get())
end

return module