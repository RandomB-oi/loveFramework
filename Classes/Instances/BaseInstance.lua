local module = {}
module.__index = module
module.__type = "Instance"

module.All = {}
local idSerial = 0

function module.Get(id)
	return module.All[id]
end

module.new = function()
	local self = setmetatable({}, module)
	self.Maid = Maid.new()
	self.ID = tostring(idSerial)
	idSerial = idSerial + 1

	self.Name = "Instance"
	self._children = {}
	self.Parent = nil
	self.ZIndex = 0

	self.AncestryChanged = self.Maid:Add(Signal.new())
	self.ChildAdded = self.Maid:Add(Signal.new())
	self.ChildRemoved = self.Maid:Add(Signal.new())

	module.All[self.ID] = self
	self.Maid:GiveTask(function()
		module.All[self.ID] = nil
		if self.Parent then
			self:_setParent(nil)
		end
	end)

	return self
end

function module:CheckParent()
	if self.Parent ~= self._parent then
		self:_setParent(self.Parent)
	end
end

function module:DrawChildren()
	local zIndices = {}
	local layers = {}
	for _, child in ipairs(self:GetChildren()) do
		local zIndex = child.ZIndex or 0
		if not layers[zIndex] then
			layers[zIndex] = {}
			table.insert(zIndices, zIndex)
		end
		table.insert(layers[zIndex], child)
	end
	table.sort(zIndices) -- could be costly

	for _, layerNumber in ipairs(zIndices) do
		for _, child in ipairs(layers[layerNumber]) do
			child:Draw()
		end
	end
	-- for _, child in ipairs() do
	-- 	child:Draw()
	-- end
end

function module:Update(dt)
	self:CheckParent()
	for _, child in ipairs(self:GetChildren()) do
		child:Update(dt)
	end
end
function module:Draw()
	self:DrawChildren()
end

function module:GetScene()
	if self:IsA("Scene") then
		return self
	end

	if self.Parent then
		return self.Parent:GetScene()
	end
end

function module:IsA(className)
	local class = self
	while class do
		if class.__type == className then
			return true
		end
		class = class.Base
	end
	return false
end

function module:GetChildren()
	local childrenList, i = {}, 1
	for _, child in pairs(self._children) do
		childrenList[i] = child
		i=i+1
	end
	return childrenList
end

function module:_setParent(newParent)
	if self._parent then

		self._parent._children[self.ID] = nil
		self._parent.ChildRemoved:Fire(self)
		self._parent = nil
	end

	if newParent == self then newParent = nil end

	self.Parent = newParent
	self._parent = newParent
	if newParent then
		newParent._children[self.ID] = self
		newParent.ChildAdded:Fire(self)
		
		local scene = newParent:GetScene()
		if scene then
			scene._canvasNeedsUpdate = true
		end
	end

	self.AncestryChanged:Fire()
end

function module:Destroy()
	self.Maid:Destroy()
end

function module.UpdateOrphanedInstances(dt)
	for _, instance in pairs(module.All) do
		if not instance._parent and instance ~= Game then
			instance:Update(dt)
		end
	end
end

return Instance.RegisterClass(module)