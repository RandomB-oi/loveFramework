local module = {}

local Classes = {}

module.new = function(className, ...)
	local class = assert(Classes[className], tostring(className).." is an invalid instance type")

	return class.new(...)
end

function module.RegisterClass(class)
	local __type = rawget(class, "__type")
	if Classes[__type] then
		print(__type.." is an already registered class")
	end
	Classes[__type] = class
	return class
end

return module