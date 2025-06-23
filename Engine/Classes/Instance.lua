local module = {}

local Classes = {}

module.Classes = Classes
module.new = function(className, ...)
	local class = assert(Classes[className], tostring(className).." is an invalid instance type")
	if not class.new then return end

	return class.new(...)
end

module.GetClass = function(className)
	return Classes[className]
end

function module.GetOrphanedClasses()
	local list = {}
	for className, class in pairs(Classes) do
		local derives = rawget(class, "Derives")
		local base = derives and rawget(class, "Base")
		if derives and not base then
			list[className] = class
		end
	end
	return list
end

local function UpdateBases()
	for className, class in pairs(module.GetOrphanedClasses()) do
		local derives = rawget(class, "Derives")
		local baseClass = Classes[derives]
		if baseClass then
			rawset(class, "Base", baseClass)
			setmetatable(class, baseClass)
		end
	end
end

function module.RegisterClass(class)
	local t = rawget(class, "__type")
	if not rawget(class, "Name") then
		rawset(class, "Name", t)
	end
	if Classes[t] then
		print(t, "has registered already")
	end
	Classes[t] = class

	UpdateBases()

	return class
end

return module