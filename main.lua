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

Enum = require("Engine.Classes.DataTypes.Enum")
math = require("Engine.Utilities.Math")
table = require("Engine.Utilities.Table")
string = require("Engine.Utilities.String")
task = require("Engine.Utilities.Task")
require("Engine.Utilities.Graphics")


do -- DataTypes
	Vector = require("Engine.Classes.DataTypes.Vector")

	Color = require("Engine.Classes.DataTypes.Color")
	ColorSequence = require("Engine.Classes.DataTypes.ColorSequence")

	NumberRange = require("Engine.Classes.DataTypes.NumberRange")
	NumberSequence = require("Engine.Classes.DataTypes.NumberSequence")

	UDim = require("Engine.Classes.DataTypes.UDim")
	UDim2 = require("Engine.Classes.DataTypes.UDim2")

	Maid = require("Engine.Classes.DataTypes.Maid")
	Signal = require("Engine.Classes.DataTypes.Signal")

	TweenInfo = require("Engine.Classes.DataTypes.TweenInfo")
end

Instance = require("Engine.Classes.Instance")

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

	load("Engine.Classes.Instances", {
		GUI = {
			Layouts = {
				"UIListLayout", "UILayoutBase"
			},
			"Frame", "Button", "ImageLabel", "TextLabel", "TextBox", "ScrollingFrame",
		},
		Services = {
			"BaseService", "InputService", "TweenService", "Debris", "CollectionService", "Selection"
		},
		ValueObjects = {
			"ValueBase", "NumberValue", "IntValue",
		},
		"BaseInstance", "Scene", "Folder",
	})
end


Engine = Instance.new("Scene"):Enable():Unpause()
Engine.Name = "Engine"

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	local ID = tostring(os.time())
	local fileName = "ExportedInstances/AutoSave"..ID..".lua"
	
	-- local GameScene = require("ExportedInstances.SavedGame")()
	local GameScene = require("Game.main")
	task.spawn(function()
		while task.wait(30) do
			print("autoSave")
			Instance.CreateScript(GameScene, fileName)
		end
	end)
	
	require("Editor.main"):Open(GameScene)


	function love.update(dt)
		dt = math.clamp(dt, 0, 1/15)
		-- local title = "Game" .. tostring(math.round(1/(dt)))
		local title = GameScene.Name.." - "..tostring(#GameScene:GetChildren(true).. " instances")
		Engine:Unpause():Enable().Visible = true
		Engine.Name = title
		love.window.setTitle(title)
		
		task.update(dt)
		
		Engine.UpdateOrphanedInstances(dt)
		Engine:Update(dt)
	end

	function love.draw()
		Engine:Draw()
	end
end

return Engine