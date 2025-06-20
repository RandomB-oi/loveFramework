local module = {}

local Classes = {}

module.new = function(className, ...)
	local class = assert(Classes[className], tostring(className).." is an invalid instance type")

	return class.new(...)
end

function module.RegisterClass(class)
	local __type = rawget(class, "__type")
	Classes[__type] = class
	return class
end

return module