local module = {}
module.__index = module
module.__type = "signal"
	
module.new = function()
	return setmetatable({_connections = {}}, module)
end

function module:Connect(callback, order)
	local connection = {
		Order = order or 10,
		_callback = callback,
		Disconnect = function(connection)
			for i,v in ipairs(self._connections) do
				if v == connection then
					table.remove(self._connections, i)
					break
				end
			end
		end,
	}
	table.insert(self._connections, connection)
	return connection
end

function module:Once(callback)
	local connection connection = self:Connect(function(...)
		connection:Disconnect()
			
		coroutine.wrap(callback)(...)
	end)
end

function module:Wait()
	local thread = coroutine.running()
	self:Once(function(...)
		coroutine.resume(thread, ...)
	end)
	return coroutine.yield()
end

function module:Fire(...)
	local args = {...}

	for _, connection in pairs(table.shallowCopy(self._connections)) do
		if type(connection) == "table" then
			xpcall(coroutine.wrap(connection._callback), function(err)
				warn(err, debug.traceback())
			end, unpack(args))
		end
	end
end

function module:ToLua()
	return "Signal.new()"
end

function module:Destroy()
	self._connections = {}
end

return module