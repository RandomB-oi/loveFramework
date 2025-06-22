--[[local module = {}

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

return module]]




local task = {
    _tasks = {},
    _time = 0
}

local function newHandle()
    return {
        cancelled = false,
        running = true
    }
end

function task.update(dt)
    task._time = task._time + dt
    for i = #task._tasks, 1, -1 do
        local t = task._tasks[i]
        if not t.handle.cancelled and task._time >= t.runAt then
            table.remove(task._tasks, i)
            local status, result = coroutine.resume(t.co, table.unpack(t.args))

            if status then
                -- print("Coroutine completed successfully. Result:", result)
            else
                print("Coroutine error:", result)
            end
            
        elseif t.handle.cancelled then
            table.remove(task._tasks, i)
        end
    end
end

function task.spawn(func, ...)
    local co = coroutine.create(func)
    local handle = newHandle()
    table.insert(task._tasks, {
        co = co,
		args = {...},
        runAt = task._time,
        handle = handle
    })
    return handle
end

function task.delay(seconds, func, ...)
    local co = coroutine.create(func)
    local handle = newHandle()
    table.insert(task._tasks, {
        co = co,
		args = {...},
        runAt = task._time + seconds,
        handle = handle
    })
    return handle
end

function task.wait(seconds)
    local co = coroutine.running()

	local begin = os.clock()
    local function resumeLater()
        coroutine.resume(co, os.clock() - begin)
    end

    task.delay(seconds, resumeLater)

    return coroutine.yield()
end

function task.cancel(handle)
    if handle then
        handle.cancelled = true
        handle.running = false
    end
end

return task
