local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "Debris"
Instance.RegisterClass(module)

module.new = function ()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	self.Objects = {}
	
	self:CreateProperty("MaxItems", "number", 1000)

	Engine:GetService("RunService").RunChanged:Connect(function()
		for object in pairs(self.Objects) do
			self.Objects[object] = -1
		end
	end)
	
	return self
end

function module:Updated(dt)
	module.Base.Updated(self, dt)

	local t = Engine:GetService("RunService").ElapsedTime
	local amount = 0
	
	for object, removeAt in pairs(self.Objects) do
		amount = amount + 1
		
		if removeAt <= t or amount > self.MaxItems then
			object:Destroy()
			self.Objects[object] = nil
		end
	end
end

function module:AddItem(item, lifeTime, dontUpdate)
	if dontUpdate and self.Objects[item] then
		return item
	end
	self.Objects[item] = Engine:GetService("RunService").ElapsedTime + lifeTime
	return item
end

function module:Cancel(item)
	self.Objects[item] = nil
	return item
end

return module