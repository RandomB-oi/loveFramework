--DEPRECATED

local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "Script"
Instance.RegisterClass(module)

local LoadedServices = {}
module.ClassIcon = "Engine/Assets/InstanceIcons/Script.png"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self:SetParent(nil)

	self.Name = "Script"
	self:CreateProperty("Source", "string", "")
	self.Source = "print(\"Hello World\")"

	self:GetPropertyChangedSignal("Source"):Connect(function()
		self.Maid.ScriptMaid = nil
		self:Run(self.Source)
	end)

	return self
end

function module:Run(code)
	task.spawn(function()
		local callback = loadstring(code)
		if not callback then return end

		local cleanupMaid = Maid.new()
		self.Maid.ScriptMaid = cleanupMaid
		
		local env = getfenv(callback)
		env.ScriptMaid = cleanupMaid
		env.print = function(...)
			warn("in game print", ...)
		end
		setfenv(callback, env)

		callback()
	end)
end

return module