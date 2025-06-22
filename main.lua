typeof = function(value)
	local t = type(value)
	if t == "table" then
		return value.__type or t
	end
	return t
end
warn = function(...)
	print(...)
end

math = require("Utilities.Math")
table = require("Utilities.Table")
string = require("Utilities.String")
task = require("Utilities.Task")
require("Utilities.Graphics")


do -- DataTypes
	Vector = require("Classes.DataTypes.Vector")

	Color = require("Classes.DataTypes.Color")
	ColorSequence = require("Classes.DataTypes.ColorSequence")

	NumberRange = require("Classes.DataTypes.NumberRange")
	NumberSequence = require("Classes.DataTypes.NumberSequence")

	UDim = require("Classes.DataTypes.UDim")
	UDim2 = require("Classes.DataTypes.UDim2")

	Maid = require("Classes.DataTypes.Maid")
	Signal = require("Classes.DataTypes.Signal")

	
	TweenInfo = require("Classes.DataTypes.TweenInfo")
end

Instance = require("Classes.Instance")

do -- load all instances
	function load(path, list)
		for index, value in pairs(list) do
			if type(index) == "string" then
				load(path.."/"..index, value)
			else
				require(path.."/"..value)
			end
		end
	end

	load("Classes/Instances", {
		"BaseInstance", "Scene",
		GUI = {
			"Frame", "Button", "ImageLabel", "TextLabel",
		},
		ValueObjects = {
			"ValueBase", "NumberValue", "IntValue",
		},
		Services = {
			"BaseService", "InputService", "TweenService", "Debris",
		},
	})
end


Game = Instance.new("Scene"):Enable():Unpause()

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	require("Game.main")

	function love.update(dt)
		dt = math.clamp(dt, 0, 1/15)
		task.update(dt)

		Game.UpdateOrphanedInstances(dt)
		Game:Update(dt)
	end

	function love.draw()
		Game:Draw()
	end
end