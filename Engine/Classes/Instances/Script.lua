local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "Script"
Instance.RegisterClass(module)

module.ClassIcon = "Engine/Assets/InstanceIcons/Script.png"

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	self.Name = "Script"
	self:CreateProperty("Value", "number", 0)

	if Engine:GetService("RunService"):IsRunning() then
		task.spawn(function()
			self:ScriptInit()
			self._scriptInitDone = true
		end)
	end

	return self
end

function module:ScriptInit()
	print("Hello World!")
end

function module:ScriptUpdate(dt)
	self.Value = self.Value + dt
end

function module:Update(...)
	if not Engine:GetService("RunService"):IsRunning() then return end
	if not self._scriptInitDone then return end

	self:ScriptUpdate(...)
end

return module