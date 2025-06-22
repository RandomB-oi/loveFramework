local module = {}
module.Base = require("Classes.Instances.Services.BaseService")
module.__index = module
module.__type = "Debris"
setmetatable(module, module.Base)

local function new()
	local self = setmetatable(module.Base.new(), module)

	self.Objects = {}
	self.MaxItems = 1000

	Game.Updated:Connect(function()
		local t = os.clock()
		local amount = 0
		
		for object, removeAt in pairs(self.Objects) do
			amount = amount + 1
			
			if removeAt <= t or amount > self.MaxItems then
				object:Destroy()
				self.Objects[object] = nil
			end
		end
	end)

	return self
end

function module:AddItem(item, lifeTime, dontUpdate)
	if dontUpdate and self.Objects[item] then
		return item
	end
	self.Objects[item] = os.clock() + lifeTime
	return item
end

function module:Cancel(item)
	self.Objects[item] = nil
	return item
end

return new