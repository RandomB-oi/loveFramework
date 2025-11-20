local module = {}

local Classes = {}

module.Classes = Classes
module.new = function(className, ...)
	local new = assert(Classes[className] and Classes[className].new, tostring(className).." is an invalid instance type")
	local object = new(...)
	if object.IsA then
		object.Base = Classes[className]
	end
	return object
end

module.GetClass = function(className)
	return Classes[className]
end

local function GetOrphanedClasses()
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

local function CreateInstanceMetatable(class)
    return {
        __index = function(self, index)
            local current = class
            while current do
                if current._index then
                    local value = current._index(self, index)
                    if value ~= nil then return value end
                end
                current = current.Base
            end

            local selfHas = rawget(self, index)
            if selfHas ~= nil then return selfHas end
            return rawget(class, index)
        end,

        __newindex = function(self, index, value)
            local current = class
            while current do
                if current._newindex then
                    local handled = current._newindex(self, index, value)
                    if handled then return end
                end
                current = current.Base
            end
            rawset(self, index, value)
        end,
    }
end

local function GetVarName(object, counts)
	local objectType = object.__type
	counts[objectType] = (counts[objectType] or 0) + 1

	return objectType..tostring(counts[objectType]), objectType
end

local function CreateVariableNames(object)
	local names, counts = {}, {}
	names[object] = GetVarName(object, counts)
	for _, child in pairs(object:GetChildren(true)) do
		names[child] = GetVarName(child, counts)
	end

	return names
end

local function ToLua(value)
	if type(value) == "table" and value.ToLua then
		return value:ToLua()
	elseif type(value) == "string" then
		return "[["..value.."]]"
	elseif type(value) == "boolean" or type(value) == "number" then
		return tostring(value)
	else
		print(value, typeof(value), "has no conversion")
	end
end

function module.CreatePrefab(object, directory, env, parentVar)
	-- if not object.Archivable then return end

	local env = env or {Lines = {}, VariableNames = CreateVariableNames(object)}

	if not parentVar then
		table.insert(env.Lines, "return function(parent)")
	end
	if not env.CreatedInstances then
		env.CreatedInstances = true
		for inst, varName in pairs(env.VariableNames) do
			table.insert(env.Lines, "local "..varName.." = Instance.new(\""..inst.__type.."\")")
		end
	end

	local variableName = env.VariableNames[object]


	if next(object._children) then
		for _, child in pairs(object:GetChildren()) do
			module.CreatePrefab(child, nil, env, variableName)
		end
	end
	for propName, propInfo in pairs(object._properties) do
		local propValue = object[propName]
		if propName ~= "Parent" and propValue ~= propInfo.DefaultValue then
			local strValue
			if propInfo.PropType == "Instance" then
				strValue = tostring(env.VariableNames[propValue or 1])
			else
				strValue = ToLua(propValue)
			end

			if strValue then
				table.insert(env.Lines, variableName.."."..propName.." = "..strValue)
			end
		end
	end
	
	for attributeName, attribute in pairs(object:GetAttributes()) do
		local value = ToLua(attribute)
		table.insert(env.Lines, variableName..":SetAttribute(\""..attributeName.."\", " ..value..")")
	end
	for _, tagName in pairs(object:GetTags()) do
		table.insert(env.Lines, variableName..":AddTag(\""..tagName.."\")")
	end

	if parentVar then
		table.insert(env.Lines, variableName..":SetParent("..parentVar..")")
	end

	if not parentVar then
		table.insert(env.Lines, "if parent then "..variableName..":SetParent(parent) end")
		table.insert(env.Lines, "return "..variableName)
		table.insert(env.Lines, "end")

		local totalLines = #env.Lines
		for i = 1, totalLines do
			if i ~= 1 and i ~= totalLines then
				env.Lines[i] = "\t"..env.Lines[i]
			end
		end
		local scriptCode = table.concat(env.Lines, "\n")
		if directory then
			local file = io.open(directory, "w")
			if file then
				file:write("", scriptCode)
				file:close()
			end
		end
		return scriptCode
	end
end

function module.BulkSetProperties(instance, properties)
    for propName, value in pairs(properties) do
        if propName == "Parent" then
            instance:SetParent(value)
        else
            instance[propName] = value
        end
    end

    for _, child in pairs(instance:GetChildren()) do
        module.BulkSetProperties(child, properties)
    end
end

local function UpdateBases()
	for className, class in pairs(module.Classes) do
		local derives = rawget(class, "Derives")
		local baseClass = derives and Classes[derives]
		if not rawget(class, "_metatable") then
			rawset(class, "_metatable", CreateInstanceMetatable(class))
		end
		if baseClass and not rawget(class,"Base") then
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