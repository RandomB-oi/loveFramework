local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "Script"
Instance.RegisterClass(module)

module.ClassIcon = "Engine/Assets/InstanceIcons/Script.png"

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	self._waitingThreads = {}
	self.Name = "Script"

	if Engine:GetService("RunService"):IsRunning() then
		task.spawn(function()
			if not self.Parent then
				self:GetPropertyChangedSignal("Parent"):Wait()
			end
			self:ScriptInit()
			self._scriptInitDone = true
			repeat
				local key, thread = next(self._waitingThreads)
				if key and thread then
					self._waitingThreads[key] = nil
					pcall(coroutine.resume, thread)

					-- local status = coroutine.status(thread)
					-- if status == "normal" or status == "suspended" then
					-- 	coroutine.resume(thread)
					-- end
				end
			until not key
		end)
	end

	return self
end

function module:Await(callback)
	if callback then
		task.spawn(function()
			self:Await()
		end)
		
		if callback then
			callback()
		end
		return
	end

	if not self._scriptInitDone then
		local thread = coroutine.running()
		table.insert(self._waitingThreads, thread)
		coroutine.yield()
	end
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