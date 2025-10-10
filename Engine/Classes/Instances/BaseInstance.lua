local module = {}
module.__index = module
module.__type = "BaseInstance"
Instance.RegisterClass(module)

module.All = {}
local idSerial = 0

function module.Get(id)
	return module.All[id]
end

local function propertyTypeMatches(value, desiredType)
	if desiredType then
		if desiredType == "Instance" then
			if type(value) == "table" and value.IsA then
				return true
			end
			return false
		end

		local t = typeof(value)

		return t == desiredType
	end
	return true
end

local TypeCleaners = {
	Int = function(value)
		return math.round(value)
	end,
}

module.ClassIcon = "Engine/Assets/InstanceIcons/Unknown.png"

module.new = function()
	local self = setmetatable({}, module)
	self.Maid = Maid.new()
	self.ID = tostring(idSerial)
	idSerial = idSerial + 1

	self._children = {}
	self._properties = {}

	self.Attributes = {}
	self.AttributeSignals = {}

	self:CreateProperty("Name", "string", "Instance"..self.ID)
	self:CreateProperty("Enabled", "boolean", true)
	self:CreateProperty("Parent", "Instance", nil)
	self:CreateProperty("Archivable", "boolean", true)

	self.AncestryChanged = self.Maid:Add(Signal.new())
	self.ChildAdded = self.Maid:Add(Signal.new())
	self.ChildRemoved = self.Maid:Add(Signal.new())
	self.DescendantAdded = self.Maid:Add(Signal.new())
	self.DescendantRemoved = self.Maid:Add(Signal.new())

	self.Changed = self.Maid:Add(Signal.new())

	module.All[self.ID] = self
	self.Maid:GiveTask(function()
		module.All[self.ID] = nil
		if self.Parent then
			self:SetParent(nil)
		end
	end)

	self:GetPropertyChangedSignal("Parent"):Connect(function(newParent)
		self:SetParent(newParent)
	end)

	return self
end

function module:GetProperties()
	local list = {}
	for name in pairs(self._properties) do
		list[name] = self[name]
	end
	return list
end

function module:CreateProperty(name, propType, defaultValue, cleaner)
	self[name] = defaultValue

	if not self._properties[name] then
		self._properties[name] = {
			-- Changed = Signal.new(),
			CurrentValue = defaultValue,
			PropType = propType,
			DefaultValue = defaultValue,
			TypeCleaner = cleaner,
		}
	end
end

function module:CheckProperties()
	for propName, info in pairs(self._properties) do
		local newValue = self[propName]
		if info.TypeCleaner and TypeCleaners[info.TypeCleaner] then
			newValue = TypeCleaners[info.TypeCleaner](newValue)
		end
		if newValue ~= info.CurrentValue then
			if propertyTypeMatches(newValue, info.PropType) then
				info.CurrentValue = newValue

				if info.Changed then
					info.Changed:Fire(newValue)
				end

				self.Changed:Fire(propName, newValue)
			else
				self[propName] = info.CurrentValue
			end
		end
	end
end

function module:GetPropertyChangedSignal(name)
	local info = self._properties[name]
	if not info then return end

	if not info.Changed then
		info.Changed = self.Maid:Add(Signal.new())
	end

	return info.Changed
end

function module:GetAttributeChangedSignal(name)
	if not self.AttributeSignals[name] then
		self.AttributeSignals[name] = self.Maid:Add(Signal.new())
	end
	return self.AttributeSignals[name]
end

function module:SetAttribute(name, value)
	if self.Attributes[name] ~= value then
		self.Attributes[name] = value

		local signal = self.AttributeSignals[name]
		if signal then
			signal:Fire(value)
		end
	end
	return self
end

function module:GetAttribute(name)
	return self.Attributes[name]
end

function module:GetAttributes()
	return table.shallowCopy(self.Attributes)
end

function module:AddTag(tag)
	Engine:GetService("CollectionService"):AddTag(self, tag)
	return self
end

function module:RemoveTag(tag)
	Engine:GetService("CollectionService"):RemoveTag(self, tag)
	return self
end

function module:GetTags()
	return Engine:GetService("CollectionService"):GetTags(self)
end

function module:DrawChildren()
	if not self.Enabled then return end
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
	self:CheckProperties()
	for _, child in ipairs(self:GetChildren()) do
		child:Update(dt)
	end
end
function module:Draw()
	if not self.Enabled then return end
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

function module:GetChildren(recursive, childrenList)
	local childrenList = childrenList or {}
	for _, child in pairs(self._children) do
		table.insert(childrenList, child)

		if recursive then
			child:GetChildren(recursive, childrenList)
		end
	end
	return childrenList
end

local function SearchChildren(self, predicate, recursive)
	local children = self:GetChildren()
	for _, child in ipairs(children) do
		if predicate(child) then
			return child
		end
	end
	if recursive then
		for _, child in ipairs(children) do
			local found = SearchChildren(child, predicate, recursive)
			if found then
				return found
			end
		end
	end
end

function module:FindFirstChild(name, recursive)
	return SearchChildren(self, function(child)
		return child.Name == name
	end, recursive)
end

function module:FindFirstChildWhichIsA(name, recursive)
	return SearchChildren(self, function(child)
		return child:IsA(name)
	end, recursive)
end

local function SearchAncestors(self, predicate)
	if not self or predicate(self) then
		return self
	end

	return SearchAncestors(self.Parent, predicate)
end

function module:FindFirstAncestor(name)
	return SearchAncestors(self.Parent, function(ancestor)
		return ancestor.Name == name
	end)
end
function module:FindFirstAncestorWhichIsA(className)
	return SearchAncestors(self.Parent, function(ancestor)
		return ancestor:IsA(className)
	end)
end

function module:WaitForChild(name, timeout, recursive)
	local run = Engine:GetService("RunService")
	local begin = run.ElapsedTime

	repeat
		local child = self:FindFirstChild(name, recursive)
		if child then return child end
		task.wait()
	until (run.ElapsedTime - begin) > (timeout or math.huge)
end

function module:SearchPath(path)
	local root = self
	for _, dir in pairs(path:split(".")) do
		root = root:FindFirstChild(dir)
		if not root then return nil end
	end
	return root
end

function module:GetFullName()
	local path = {}
	local object = self
	while object do
		table.insert(path, object.Name)
		object = object.Parent
	end
	return table.concat(table.reverse(path),".")
end

function module:SetParent(newParent)
	if not newParent then newParent = nil end
	if self.Parent == newParent then return end

	self.Maid.RemoveParent = nil
	if newParent == self then newParent = nil return end
	self.Parent = newParent

	if newParent then
		newParent._children[self.ID] = self
		newParent.ChildAdded:Fire(self)
		
		self.Maid.RemoveParent = function()
			newParent._children[self.ID] = nil
			newParent.ChildRemoved:Fire(self)
		end

		local scene = newParent:GetScene()
		if scene then
			scene._canvasNeedsUpdate = true
		end
	end

	self.AncestryChanged:Fire(newParent)
end

function module:IsEnabled()
	if self.Parent and not self.Parent:IsEnabled() then
		return false
	end
	return self.Enabled
end

function module:Clone(ignoreArchivable, _instanceMap, _toSet)
	if not ignoreArchivable and not self.Archivable then return end

	local first = not _instanceMap
	local _instanceMap = _instanceMap or {}
	local _toSet = _toSet or {}

	local new = Instance.new(self.__type)

	_instanceMap[self] = new
	for prop, propInfo in pairs(self._properties) do
		if propInfo.PropType == "Instance" then
			_toSet[new] = _toSet[new] or {}
			_toSet[new][prop] = {self[prop]} -- to get nil values
		else
			new[prop] = self[prop]
		end
	end

	for _, child in pairs(self:GetChildren()) do
		child:Clone(ignoreArchivable, _instanceMap, _toSet)
	end

	if first then
		_toSet[new].Parent = nil
		for object, props in pairs(_toSet) do
			for name, value in pairs(props) do
				local chosenValue = value[1] and _instanceMap[value[1]] or value[1]

				if name == "Parent" then
					object:SetParent(chosenValue)
				else
					object[name] = chosenValue
				end
			end
		end
	end

	return new
end

function module:Destroy()
	self:SetParent(nil)

	self.Maid:Destroy()

	repeat
		local key, child = next(self._children)
		if child then
			self._children[key] = nil
			child:Destroy()
		end
	until not key
end

function module.UpdateOrphanedInstances(dt)
	for _, instance in pairs(module.All) do
		if not instance._properties.Parent.CurrentValue and instance ~= Engine then
			instance:Update(dt)
		end
	end
end

return module