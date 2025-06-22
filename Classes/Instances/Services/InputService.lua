local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "InputService"
Instance.RegisterClass(module)

module.new = function ()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type
	self.InputBegan = self.Maid:Add(Signal.new())
	self.InputEnded = self.Maid:Add(Signal.new())
	self.Scrolled = self.Maid:Add(Signal.new())

	self.PressedKeyboardButtons = {}
	self.PressedMouseButtons = {}

	function love.mousepressed(_, _, button)
		self.PressedMouseButtons[button] = true
		self.InputBegan:Fire({
			MouseButton = button,
			Key = nil,
		})
	end
	function love.mousereleased(_, _, button)
		self.PressedMouseButtons[button] = false
		self.InputEnded:Fire({
			MouseButton = button,
			Key = nil,
		})
	end

	function love.keypressed(button)
		self.PressedKeyboardButtons[button] = true
		self.InputBegan:Fire({
			MouseButton = nil,
			Key = button,
		})
	end
	function love.keyreleased(button)
		self.PressedKeyboardButtons[button] = false
		self.InputEnded:Fire({
			MouseButton = nil,
			Key = button,
		})
	end

	function love.wheelmoved(x, y)
		self.Scrolled:Fire(y)
	end

	return self
end

function module:GetMouseLocation()
	return Vector.new(love.mouse.getPosition())
end

function module:IsKeyPressed(key)
	return not not self.PressedKeyboardButtons[key]
end

function module:IsMouseButtonPressed(key)
	return not not self.PressedMouseButtons[key]
end

return module