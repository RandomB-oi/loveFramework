local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "InputService"

local cachedEnums = {}
local function ScanCodeToKeyCode(scancode)
	if cachedEnums[scancode] then
		return cachedEnums[scancode]
	end

	for keyName, enum in pairs(Enum.KeyCode) do
		if enum.ScanCode == scancode then
			cachedEnums[scancode] = enum
			return enum
		end
	end
end

local function GetMouseButton(number)
	return Enum.MouseButton["MouseButton"..tostring(number)]
end

module.new = function ()
	local self = setmetatable(module.Base.new(module.__type), module._metatable)
	self.Name = self.__type
	self.InputBegan = self.Maid:Add(Signal.new())
	self.InputEnded = self.Maid:Add(Signal.new())
	self.Scrolled = self.Maid:Add(Signal.new())

	self.PressedKeyboardButtons = {}
	self.PressedMouseButtons = {}

	function love.mousepressed(_, _, button)
		local enumItem = GetMouseButton(button)
		if not enumItem then return end

		self.PressedMouseButtons[enumItem] = true
		self.InputBegan:Fire({
			MouseButton = enumItem,
			KeyCode = nil,
		})
	end
	function love.mousereleased(_, _, button)
		local enumItem = GetMouseButton(button)
		if not enumItem then return end

		self.PressedMouseButtons[enumItem] = false
		self.InputEnded:Fire({
			MouseButton = enumItem,
			KeyCode = nil,
		})
	end

	function love.keypressed(button)
		local enumItem = ScanCodeToKeyCode(button)
		if not enumItem then return end

		self.PressedKeyboardButtons[enumItem] = true
		self.InputBegan:Fire({
			MouseButton = nil,
			KeyCode = enumItem,
		})
	end
	function love.keyreleased(button)
		local enumItem = ScanCodeToKeyCode(button)
		if not enumItem then return end

		self.PressedKeyboardButtons[enumItem] = false
		self.InputEnded:Fire({
			MouseButton = nil,
			KeyCode = enumItem,
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

return Instance.RegisterClass(module)