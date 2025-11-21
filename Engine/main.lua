typeof = function(value)
	local t = type(value)
	if t == "table" then
		return value.__type or t
	end
	return t
end
local oldPrint = print
warn = function(...)
	oldPrint(...)
end

Enum = require("Engine.Classes.DataTypes.Enum")
math = require("Engine.Utilities.Math")
table = require("Engine.Utilities.Table")
string = require("Engine.Utilities.String")
task = require("Engine.Utilities.Task")
require("Engine.Utilities.Graphics")

do -- DataTypes
	Binary = require("Engine.Classes.DataTypes.Binary")
	Vector = require("Engine.Classes.DataTypes.Vector")

	Color = require("Engine.Classes.DataTypes.Color")
	ColorSequence = require("Engine.Classes.DataTypes.ColorSequence")

	NumberRange = require("Engine.Classes.DataTypes.NumberRange")
	NumberSequence = require("Engine.Classes.DataTypes.NumberSequence")

	UDim = require("Engine.Classes.DataTypes.UDim")
	UDim2 = require("Engine.Classes.DataTypes.UDim2")

	Maid = require("Engine.Classes.DataTypes.Maid")
	Signal = require("Engine.Classes.DataTypes.Signal")
	GCSignal = require("Engine.Classes.DataTypes.GCSignal")

	TweenInfo = require("Engine.Classes.DataTypes.TweenInfo")
end

Instance = require("Engine.Classes.Instance")

function CreateScript(name, directory)
	local new = Instance.new("Script")
	new.Name = name

	local file = io.open(directory, "r")
	if file then
   		local t = file:read("*all")
	    file:close()

		new.Source = t
	else
		new.Source = ""
	end

	return new
end

do -- load all instances
	function load(path, list)
		for index, value in pairs(list) do
			if type(index) == "string" then
				load(path.."."..index, value)
			else
				require(path.."."..value)
			end
		end
	end

	local function fixPath(path)
		return select(1, string.gsub(path, "/", "."))
	end

	-- fixes a yellow warn line
	love.filesystem.isDirectory = love.filesystem.isDirectory
	
	function autoLoad(path, ignoreList)
		local tbl = {}

		local directories = {}
		
		for i, fileName in pairs(love.filesystem.getDirectoryItems(path)) do
			local isDirectory do
				if love.filesystem.getInfo then
					isDirectory = love.filesystem.getInfo(path.."/"..fileName).type == "directory"
				else
					isDirectory = love.filesystem.isDirectory(path.."/"..fileName)
				end
			end

			if isDirectory then
				table.insert(directories, {name = fileName, path = path.."/"..fileName})
			elseif fileName:find(".lua") then
				local objectName = string.split(fileName, ".")[1]
				local fileDir = fixPath(path.."."..objectName)
				if ignoreList and not table.find(ignoreList, fileDir) or not ignoreList then
					local s, value = xpcall(require, print, fileDir)
					if s then
						tbl[objectName] = value
					end
				end
			end
		end

		for _ , info in ipairs(directories) do
			tbl[info.name] = autoLoad(info.path)
		end
		
		return tbl
	end

	autoLoad("Engine/Classes/Instances", {"Engine.main"})
end

Engine = Instance.new("Scene")
Engine.Name = "Engine"

Engine:GetService("RunService")

for className, info in pairs(Instance.Classes) do
	if info:IsA("BaseService") then
		Engine:GetService(className)
	end
end


return Engine