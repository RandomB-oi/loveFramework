local module = {}
module.__type = "Vector"

local function isNumber(x)
	return type(x) == "number"
end

function module:__index(index)
	if index == "Magnitude" then
		return math.sqrt(self.__x^2 + self.__y^2)
	elseif index == "Unit" then
		return self/self.Magnitude
	elseif index == "X" then
		return self.__x
	elseif index == "Y" then
		return self.__y
	end

	local selfHas = rawget(self, index)
	if selfHas ~= nil then
		return selfHas
	end

	return rawget(module, index)
end
function module:__newindex(i,v)
	if i == "X" or i == "Y" then
		return
	end

	rawset(self, i, v)
end

module.new = function(x, y)
	if x and not isNumber(x) or not x then
		x = 0
	end
	if y and not isNumber(y) or not y then
		y = 0
	end
	local self = setmetatable({__x = x, __y = y}, module)
	return self
end

module.FromAngle = function(angle) -- in radians
	return module.new(math.sin(angle), -math.cos(angle))
end

function module:GetAngle()
	return math.atan2(-self.Y, self.X)
end

function module:__add(other)
	if type(self) == "number" then
		return other + self
	end
	return module.new(self.X + other.X, self.Y + other.Y)
end

function module:__sub(other)
	if type(self) == "number" then
		return other - self
	end
	return module.new(self.X - other.X, self.Y - other.Y)
end

function module:__unm()
	return module.new(-self.X, -self.Y)
end

function module:__mul(other)
	if isNumber(self) then
		return other * self
	end
	if isNumber(other) then
		return module.new(self.X * other, self.Y * other)
	end
	return module.new(self.X * other.X, self.Y * other.Y)
end

function module:__div(other)
	if isNumber(self) then
		return other / self
	end
	
	if isNumber(other) then
		return module.new(self.X / other, self.Y / other)
	end
	return module.new(self.X / other.X, self.Y / other.Y)
end

function module:__lt(other)
	return self.X < other.X and self.Y < other.Y
end

function module:__le(other)
	return self.X <= other.X and self.Y <= other.Y
end

function module:__eq(other)
	return self.X == other.X and self.Y == other.Y
end

function module:__tostring()
	return tostring(self.X)..", "..tostring(self.Y)
end

module.zero = module.new(0,0)
module.xAxis = module.new(1,0)
module.yAxis = module.new(0,1)
module.one = module.new(1,1)

return module