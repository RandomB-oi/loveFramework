local EnumMetas = {}

local function NewEnum(enumName)
	local meta = EnumMetas[enumName]
	if not meta then
		local enumItemMeta = {}
		enumItemMeta.__index = enumItemMeta
		enumItemMeta.__type = enumName
		enumItemMeta.Serial = 0
		function enumItemMeta:ToLua()
			return "Enum."..enumName.."."..self.Name
		end
		EnumMetas[enumName] = enumItemMeta
		meta = enumItemMeta
	end
	meta.Serial = meta.Serial + 1

	return setmetatable({
		Value = meta.Serial,
	}, meta)
end

local function NewKeyCode(scanCode)
	local enumItem = NewEnum("KeyCode")
	enumItem.ScanCode = scanCode
	return enumItem
end

local function NewMouseButton(scanCode)
	local enumItem = NewEnum("MouseButton")
	enumItem.ScanCode = scanCode
	return enumItem
end

local module = {
	MouseButton = {
		MouseButton1 = NewMouseButton(1),
		MouseButton2 = NewMouseButton(2),
		MouseButton3 = NewMouseButton(3),
		MouseButton4 = NewMouseButton(4),
		MouseButton5 = NewMouseButton(5),
	},

	TextXAlignment = {
		Left = NewEnum("TextXAlignment"),
		Center = NewEnum("TextXAlignment"),
		Right = NewEnum("TextXAlignment"),
	},
	TextYAlignment = {
		Up = NewEnum("TextYAlignment"),
		Center = NewEnum("TextYAlignment"),
		Bottom = NewEnum("TextYAlignment"),
	},

	KeyCode = {
		One = NewKeyCode("1"),
		Two = NewKeyCode("2"),
		Three = NewKeyCode("3"),
		Four = NewKeyCode("4"),
		Five = NewKeyCode("5"),
		Six = NewKeyCode("6"),
		Seven = NewKeyCode("7"),
		Eight = NewKeyCode("8"),
		Nine = NewKeyCode("9"),
		Zero = NewKeyCode("0"),

		F1 = NewKeyCode("1"),
		F2 = NewKeyCode("2"),
		F3 = NewKeyCode("3"),
		F4 = NewKeyCode("4"),
		F5 = NewKeyCode("5"),
		F6 = NewKeyCode("6"),
		F7 = NewKeyCode("7"),
		F8 = NewKeyCode("8"),
		F9 = NewKeyCode("9"),
		F10 = NewKeyCode("10"),
		F11 = NewKeyCode("11"),
		F12 = NewKeyCode("12"),

		A = NewKeyCode("a"),
		B = NewKeyCode("b"),
		C = NewKeyCode("c"),
		D = NewKeyCode("d"),
		E = NewKeyCode("e"),
		F = NewKeyCode("f"),
		G = NewKeyCode("g"),
		H = NewKeyCode("h"),
		I = NewKeyCode("i"),
		J = NewKeyCode("j"),
		K = NewKeyCode("k"),
		L = NewKeyCode("l"),
		M = NewKeyCode("m"),
		N = NewKeyCode("n"),
		O = NewKeyCode("o"),
		P = NewKeyCode("p"),
		Q = NewKeyCode("q"),
		R = NewKeyCode("r"),
		S = NewKeyCode("s"),
		T = NewKeyCode("t"),
		U = NewKeyCode("u"),
		V = NewKeyCode("v"),
		W = NewKeyCode("w"),
		X = NewKeyCode("x"),
		Y = NewKeyCode("y"),
		Z = NewKeyCode("z"),
		Backquote = NewKeyCode("`"),
		Tilde = NewKeyCode("~"),
		Minus = NewKeyCode("-"),
		Underscore = NewKeyCode("_"),
		Equals = NewKeyCode("="),

		Escape = NewKeyCode("escape"),
		
		Tab = NewKeyCode("tab"),

		LeftBracket = NewKeyCode("["),
		RightBracket = NewKeyCode("]"),

		LeftCurly = NewKeyCode("{"),
		RightCurly = NewKeyCode("}"),
		
		Backslash = NewKeyCode("\\"),
		Pipe = NewKeyCode("|"),
		CapsLock = NewKeyCode("capslock"),

		Colon = NewKeyCode(":"),
		SemiColon = NewKeyCode(";"),
		Quote = NewKeyCode("'"),
		QuotedDouble = NewKeyCode("\""),

		Return = NewKeyCode("return"),

		LeftShift = NewKeyCode("lshift"),
		RightShift = NewKeyCode("rshift"),

		LeftControl = NewKeyCode("lctrl"),
		RightControl = NewKeyCode("rctrl"),
		LeftAlt = NewKeyCode("lalt"),
		RightAlt = NewKeyCode("ralt"),

		Menu = NewKeyCode("application"),
		LeftGui = NewKeyCode("lgui"),
		Delete = NewKeyCode("delete"),
		End = NewKeyCode("end"),
		PageDown = NewKeyCode("pagedown"),
		PageUp = NewKeyCode("pageup"),
		Insert = NewKeyCode("insert"),
		Home = NewKeyCode("home"),
		Print = NewKeyCode("printscreen"),
		ScrollLock = NewKeyCode("scrolllock"),

		Backspace = NewKeyCode("backspace"),

		Left = NewKeyCode("left"),
		Right = NewKeyCode("right"),
		Up = NewKeyCode("up"),
		Down = NewKeyCode("down"),
		Space = NewKeyCode("space"),
		
		Period = NewKeyCode("."),
		Comma = NewKeyCode(","),
		LessThan = NewKeyCode("<"),
		GreaterThan = NewKeyCode(">"),
		Question = NewKeyCode("?"),
		Slash = NewKeyCode("/"),
	},
}

for categoryName, list in pairs(module) do
	for name, enumItem in pairs(list) do
		enumItem.Name = name
		enumItem.EnumType = list
	end
end

return module