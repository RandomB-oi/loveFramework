-- usage
--[[
local playerData = Datastore:GetDatastore("BobData")

local key = "Bob"
local val = playerData:IncrementAsync(key)

print(val)
]]

function getStr(value, alreadyDoneTables, tabs, oneLine)
	tabs = tabs or 0
	if type(value) == "string" then
		return "\""..value.."\""
	elseif type(value) == "table" then
		if value.IsA then
			-- return "\""..value.__tostring(value).."\""
			return "\""..tostring(value).."\""
		end
		
		if value.ToLua then
			return value:ToLua()
		end

		alreadyDoneTables = alreadyDoneTables or {}
		if alreadyDoneTables[value] then
			return "** cyclic table reference **"
		end
		alreadyDoneTables[value] = true

		return tableToString(value, alreadyDoneTables, tabs+1, oneLine)
	else
		return tostring(value)
	end
end

function tableToString(tbl, alreadyDoneTables, tabs, oneLine)
	local alreadyDoneTables = alreadyDoneTables or {}
	if not next(tbl) then
		return "{}"
	end
	local str = "{\n"
	for index, value in pairs(tbl) do
		local indexString = string.rep("    ", tabs).."["..getStr(index, alreadyDoneTables, nil, oneLine).."]"
		local valueString = getStr(value, alreadyDoneTables, tabs, oneLine)
		
		str = str..indexString.." = "..valueString..",\n"
	end
	str = str..string.rep("    ", tabs-1).."}"
	if oneLine then
str = str:gsub([[

]], "")
		
		str = str:gsub("    ", "")
	end
	return str
end

function getValue(str)
	return loadstring(str)()
end

--- Check if a file or directory exists in this path
local function exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok, err
end

--- Check if a directory exists in this path
local function isdir(path)
   -- "/" works on both Unix and Windows
   return exists(path.."/")
end

local function MockEnabled()
	return Engine:GetService("DatastoreService").MockEnabled
end

local function makeDirectory(path)
	path = path:gsub("/","\\")
	os.execute("mkdir "..path)
end

local module = {}
module.Derives = "BaseInstance"

module.__type = "Datastore"

-- module.ClassIcon = "Engine/Assets/InstanceIcons/Folder.png"

-- do not call Instance.new on this
module.new = function(path)
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = path
	self.Path = path

	self.MockData = {}

	xpcall(function()
		if not isdir(self.Path) then -- i think this only works on windows
			makeDirectory(self.Path)
			love.filesystem.createDirectory(self.Path)
		end
	end, warn)

	return self
end

function module:SetAsync(key, data)
	if MockEnabled() then
		self.MockData[key] = table.copy(data)
		return
	end

	local str = "return "..getStr(data, {})
	local directory = self.Path.."/"..key..".lua"
	local file = io.open(directory, "w")
	if file then
		file:write("", str)
		file:close()
	end
end

function module:GetAsync(key)
	if MockEnabled() then
		return table.copy(self.MockData[key])
	end

	local directory = self.path.."/"..key..".lua"
	local file = io.open(directory, "r")
	if file then
   		local t = file:read("*all")
	    file:close()

		return getValue(t)
	end
end

function module:IncrementAsync(key, amount)
	local amount = amount or 1
	local hasVal = tonumber(self:GetAsync(key)) or 0
	local val = hasVal + amount
	self:SetAsync(key, val)

	return val
end

return Instance.RegisterClass(module)