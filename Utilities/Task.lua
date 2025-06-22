local module = {}

module.spawn = function(func, ...)
	coroutine.wrap(func)(...)
end

local delayedThreads = {}
module.delay = function(delayAmount, func, ...)
	table.insert(delayedThreads, {
		resumeTime = os.clock() + delayAmount,
		callback = func,
		args = {...}
	})
end

module.UpdateDelayedThreads = function()
	for i = #delayedThreads, 1, -1 do
		local thread = delayedThreads[i]

		if thread.resumeTime < os.clock() then
			table.remove(delayedThreads, i)

			module.spawn(thread.callback, table.unpack(thread.args))
		end
	end
end

return module