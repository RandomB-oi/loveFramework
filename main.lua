typeof = function(value)
	local t = type(value)
	if t == "table" then
		return value.__type or t
	end
	return t
end

math = require("Utilities.Math")
table = require("Utilities.Table")
string = require("Utilities.String")
require("Utilities.Graphics")

Vector = require("Classes.Vector")
Color = require("Classes.Color")

NumberSequence = require("Classes.NumberSequence")
ColorSequence = require("Classes.ColorSequence")
NumberRange = require("Classes.NumberRange")
UDim = require("Classes.UDim")
UDim2 = require("Classes.UDim2")

Maid = require("Classes.Maid")
Signal = require("Classes.Signal")

Instance = require("Classes.Instances.Instance")
Scene = require("Classes.Instances.Scene")
Frame = require("Classes.Instances.Frame")
Button = require("Classes.Instances.Button")

Serializer = require("Utilities.Serializer")

GuiInputBegan = Signal.new()
InputBegan = Signal.new()
GuiInputEnded = Signal.new()
InputEnded = Signal.new()
_GP = false

function love.load()
	Game = require("Game.main")

	function love.mousepressed(_, _, button)
		GuiInputBegan:Fire(button)
		InputBegan:Fire(button, _GP)
		_GP = false
	end
	function love.mousereleased(_, _, button)
		GuiInputEnded:Fire(button)
		InputEnded:Fire(button)
	end


	function love.keypressed(button)
		GuiInputBegan:Fire(button)
		InputBegan:Fire(button, _GP)
		_GP = false
	end
	function love.keyreleased(button)
		GuiInputEnded:Fire(button)
		InputEnded:Fire(button)
	end

	function love.update(dt)
		Instance.UpdateOrphanedInstances(dt)
		Scene.UpdateAll(dt)
	end

	function love.draw()
		Scene.DrawAll()
	end
end