local module = {}
module.__type = "BaseInstance"
module.__index = module
module.All = {}

module.InstanceCreated = Signal.new()

module._newindex = function(self, index, value)
	local properties = rawget(self, "_properties")
	if properties and properties[index] then
		self:SetProperty(index, value)
		return true
	end
end

module._index = function(self, index)
	if module[index] then return end
	
    local properties = rawget(self, "_properties")
	local info = properties[index]
    if info then
		if info.Value ~= nil then
        	return info.Value
		end
		return info.DefaultValue
    end

	local foundChild = self:FindFirstChild(index)
	if foundChild then return foundChild end
end

local function PropertyTypeMatches(value, desiredType)
	if desiredType == "any" then return true end
	if desiredType then
		if desiredType == "Instance" then
			if type(value) == "table" and value.IsA or value == nil then
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

math.randomseed(os.time())
local function GenerateID()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    local guid = template:gsub("[xy]", function(c)
        local r = math.random(0, 15)
        local v = (c == 'x') and r or (r % 4 + 8) -- For 'y', ensure it's 8, 9, A, or B
        return string.format("%x", v)
    end)
    return guid
end

module.ClassIcon = "Engine/Assets/InstanceIcons/Unknown.png"

module.new = function(id)
	local self = setmetatable(module.All[id] or {}, module._metatable)
	self.Maid = Maid.new()
	self.ID = id or GenerateID()

	self._children = {}
	self._properties = {}

	self.Attributes = {}
	self.AttributeSignals = {}

	self:CreateProperty("Name", "string", self.__type)
	self:CreateProperty("Enabled", "boolean", true)
	self:CreateProperty("Parent", "Instance", nil)
	self:CreateProperty("Replicates", "boolean", true)
	self:CreateProperty("Archivable", "boolean", true)

	-- self.AncestryChanged = self.Maid:Add(Signal.new())
	self.ChildAdded = self.Maid:Add(Signal.new())
	self.ChildRemoved = self.Maid:Add(Signal.new())
	self.DescendantAdded = self.Maid:Add(Signal.new())
	self.DescendantRemoved = self.Maid:Add(Signal.new())

	self.Changed = self.Maid:Add(Signal.new())

	module.All[self.ID] = self
	self.Maid:GiveTask(function()
		module.All[self.ID] = nil
		if self.Parent then
			self.Parent = nil
		end
	end)

	self.InstanceCreated:Fire(self.ID, self)

	-- self:GetPropertyChangedSignal("Parent"):Connect(function(newParent)
	-- 	self.Parent = newParent
	-- end)

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
	-- self[name] = defaultValue

	if not self._properties[name] then
		self._properties[name] = {
			Value = defaultValue,
			PropType = propType,
			DefaultValue = defaultValue,
			TypeCleaner = cleaner,
		}
	end
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

function module:SetProperty(propName, newValue)
	local info = self._properties[propName]

	if info.PropType == "Instance" and type(newValue) == "string" then
		newValue = module.All[newValue]
	end

	if info.TypeCleaner and TypeCleaners[info.TypeCleaner] then
		newValue = TypeCleaners[info.TypeCleaner](newValue)
	end
	local oldValue = info.Value
	if newValue ~= oldValue then
		if PropertyTypeMatches(newValue, info.PropType) then
			info.Value = newValue

			if propName == "Parent" then
				self.Maid.RemoveParent = nil
				if newValue then
					newValue._children[self.ID] = self
					newValue.ChildAdded:Fire(self)
					
					self.Maid.RemoveParent = function()
						newValue._children[self.ID] = nil
						newValue.ChildRemoved:Fire(self)
					end
				end
			end

			if info.Changed then
				info.Changed:Fire(newValue)
			end

			self.Changed:Fire(propName, oldValue)

			-- if propName == "Parent" then
			-- 	self.AncestryChanged:Fire()
			-- 	for i,v in ipairs(self:GetChildren(true)) do
			-- 		v.AncestryChanged:Fire()
			-- 	end
			-- end
		else
			print("Invalid value type for "..propName..". Expected ["..info.PropType.."] got ["..typeof(newValue).."]")
			print(debug.traceback())
			return false
		end
	end
	return true
end

function module:BindProperty(name, callback)
	callback(self[name])
	return self:GetPropertyChangedSignal(name):Connect(callback)
end

function module:GetPropertyChangedSignal(name)
	local info = self._properties[name]
	if not info then return end

	if not info.Changed then
		local newSignal = GCSignal.new(function()
			info.Changed = nil
		end)
		info.Changed = newSignal
		self.Maid["Changed"..name] = newSignal
	end

	return info.Changed
end

function module:GetAttributeChangedSignal(name)
	if not self.AttributeSignals[name] then
		local newSignal = GCSignal.new(function()
			self.AttributeSignals[name] = nil
			self.Maid["AttChanged"..name] = nil
		end)
		self.AttributeSignals[name] = newSignal
		self.Maid["AttChanged"..name] = newSignal
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

function module:CanReplicate()
	if self.Parent == Engine or self:IsA("DataModel") then return self.Replicates end
	if not self.Replicates then return false end

	if self.Parent then
		return self.Parent:CanReplicate()
	end

	return false
end

function module:Replicate(prop, specificClient)
	local Run = Engine:GetService("RunService")
	local ServerService = Engine:GetService("ServerService")

	if not Run:IsServer() then return end

	local didReplicate = self._replicated
	local can = self:CanReplicate()
	self._replicated = can

	local message, data
	if not can then
		if didReplicate then
			message, data = "RemoveInstance", {ID = self.ID}
		end
	else
		if not prop or (not didReplicate and can) then
			message, data = "CreateInstance", self:SerializeData()
		else
			message, data = "UpdateProperty", {
				ID = self.ID,
				Prop = prop,
				Value = Serializer.Encode(self[prop]),
			}
		end
	end

	if message and data then
		if specificClient then
			ServerService:SendMessage(specificClient, message, data)
		else
			ServerService:SendMessageAll(message, data)
		end
	end
end

-- function module.ReplicateInstances(clientID)
-- 	for id, instance in pairs(module.All) do
-- 		instance:Replicate(nil, clientID)
-- 	end
-- end

function module:SerializeData()
	if not self.Replicates then return end
	
	local data = {}
	data.ClassName = self.__type
	data.ID = self.ID
	data.Properties = {}
	data.Attributes = {}
	data.Tags = {}
	data.Children = {}

	for prop, value in pairs(self._properties) do
		if value.Value ~= value.DefaultValue then
			local can = true
			
			if value.PropType == "Instance" and value.Value and not value.Value:CanReplicate() then
				can = false
			end
			
			if can then
				data.Properties[prop] = value.Value
			end
		end
	end

	for att, value in pairs(self:GetAttributes()) do
		data.Attributes[att] = value
	end

	for _, tag in pairs(self:GetTags()) do
		table.insert(data.Tags, tag)
	end

	for _, child in ipairs(self:GetChildren()) do
		local serializedData = child:SerializeData()
		if serializedData then
			table.insert(data.Children, serializedData)
		end
	end

	if not next(data.Properties) then data.Properties = nil end
	if not next(data.Attributes) then data.Attributes = nil end
	if not next(data.Tags) then data.Tags = nil end
	if not next(data.Children) then data.Children = nil end
	if not next(data) then data = nil end

	return Serializer.Encode(data)
end

function module:DeserializeData(data)
	if not data then return end
	if data.Children then
		local clientService = Engine:GetService("ClientService")
		for _, child in ipairs(data.Children) do
			local object = clientService:GetInstance(child.ID, child.ClassName)
			object:DeserializeData(child)
		end
	end
	local parent
	if data.Properties then
		for prop, value in pairs(data.Properties) do
			if prop == "Parent" then
				parent = value
			else
				self[prop] = value
			end
		end
	end
	
	if data.Attributes then
		for att, value in pairs(data.Attributes) do
			self:SetAttribute(att, value)
		end
	end

	if data.Tags then
		for _, tag in pairs(data.Tags) do
			self:AddTag(tag)
		end
	end
	self.Parent = parent
end

function module:Serialize()
	return self.ID
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
end

function module:Update(dt)
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

function module:IsEnabled()
	if not self.Enabled then return false end

	if self.Parent and not self.Parent:IsEnabled() then
		return false
	end
	
	return true
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
	for attribute, value in pairs(self:GetAttributes()) do
		new:SetAttribute(attribute, value)
	end

	for _, child in pairs(self:GetChildren()) do
		child:Clone(ignoreArchivable, _instanceMap, _toSet)
	end

	if first then
		_toSet[new].Parent = nil
		for object, props in pairs(_toSet) do
			for name, value in pairs(props) do
				local chosenValue = value[1] and _instanceMap[value[1]] or value[1]

				object[name] = chosenValue
			end
		end
	end

	return new
end

function module:GetConstraint(constraintType)
	local constraintChildren = rawget(self, "_constraintChildren")
	if not constraintChildren then return end
	return constraintChildren[constraintType]
end

function module:ClearAllChildren()
	repeat
		local key, child = next(self._children)
		if child then
			self._children[key] = nil
			child:Destroy()
		end
	until not key
end

function module:Destroy()
	self.Parent = nil
	self:Replicate()
	self.Maid:Destroy()

	self:ClearAllChildren()
end

function module:__tostring()
	return typeof(self).."_"..self.Name.."-"..self.ID
end

function module.UpdateOrphanedInstances(dt)
	for _, instance in pairs(module.All) do
		if not instance._properties.Parent.Value and instance ~= Engine then
			instance:Update(dt)
		end
	end
end

return Instance.RegisterClass(module)