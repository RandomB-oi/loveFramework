local module = {}
module.__index = module
module.__type = "UDim2"

module.new = function(xscale, xoffset, yscale, yoffset)
	return setmetatable({
		X = UDim.new(xscale, xoffset),
		Y = UDim.new(yscale, yoffset),
	}, module)
end

module.fromScale = function(x,y)
	return module.new(x, 0, y, 0)
end
module.fromOffset = function(x,y)
	return module.new(0, x, 0, y)
end

function module:__add(other)
	return module.new(
		self.X.Scale + other.X.Scale,
		self.X.Offset + other.X.Offset,

		self.Y.Scale + other.Y.Scale,
		self.Y.Offset + other.Y.Offset
	)
end
function module:__sub(other)
	return module.new(
		self.X.Scale - other.X.Scale,
		self.X.Offset - other.X.Offset,

		self.Y.Scale - other.Y.Scale,
		self.Y.Offset - other.Y.Offset
	)
end

function module:__mul(other)
	if type(other) == "number" then
		return module.new(
			self.X.Scale * other,
			self.X.Offset * other,
			
			self.Y.Scale * other,
			self.Y.Offset * other
		)
	end
	return module.new(
		self.X.Scale * other.X.Scale,
		self.X.Offset * other.X.Offset,

		self.Y.Scale * other.Y.Scale,
		self.Y.Offset * other.Y.Offset
	)
end

function module:Calculate(size)
	return Vector.new(
		size.X * self.X.Scale + self.X.Offset,
		size.Y * self.Y.Scale + self.Y.Offset
	)
end

function module:ToLua()
	return "UDim2.new("..tostring(self.X.Scale)..", "..tostring(self.X.Offset)..", ".. tostring(self.Y.Scale)..", "..tostring(self.Y.Offset)..")"
end

return module