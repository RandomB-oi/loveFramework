local module = {}
module.Derives = "BaseService"

module.__type = "CollectionService"

module.new = function ()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type

	self.Tagged = {}

	self.AddedSignals = {}
	self.RemovedSignals = {}

	return self
end

function module:GetInstanceAddedSignal(tag)
	if not self.AddedSignals[tag] then
		self.AddedSignals[tag] = self.Maid:Add(Signal.new())
	end
	return self.AddedSignals[tag]
end
function module:GetInstanceRemovedSignal(tag)
	if not self.RemovedSignals[tag] then
		self.RemovedSignals[tag] = self.Maid:Add(Signal.new())
	end
	return self.RemovedSignals[tag]
end

function module:AddTag(object, tag)
	if not self.Tagged[tag] then
		self.Tagged[tag] = {}
	end

	local index = table.find(self.Tagged[tag], object)
	if index then
		return
	end

	table.insert(self.Tagged[tag], object)
	local signal = self.AddedSignals[tag]
	if signal then
		signal:Fire(object)
	end
end

function module:RemoveTag(object, tag)
	if not self.Tagged[tag] then return end
	local index = table.find(self.Tagged[tag], object)

	if index then
		table.remove(self.Tagged[tag], index)
		
		local signal = self.RemovedSignals[tag]
		if signal then
			signal:Fire(object)
		end
	end

	if not next(self.Tagged[tag]) then
		self.Tagged[tag] = nil
	end
end

function module:GetTagged(tag)
	return self.Tagged[tag] and table.shallowCopy(self.Tagged[tag]) or {}
end

function module:GetTags(object)
	local tags = {}
	for tag, list in pairs(self.Tagged) do
		if table.find(list, object) then
			table.insert(tags, tag)
		end
	end
	return tags
end

return Instance.RegisterClass(module)