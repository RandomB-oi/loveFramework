local module = {}
module.__index = module
module.type = "UDim"

module.new = function(scale, offset)
	return setmetatable({
		Scale = scale or 0, 
		Offset = offset or 0
	}, module)
end


function module:__add(other)
	return module.new(
		self.Scale + other.Scale,
		self.Offset + other.Offset
	)
end
function module:__sub(other)
	return module.new(
		self.Scale - other.Scale,
		self.Offset - other.Offset
	)
end

function module:__mul(other)
	if type(other) == "number" then
		return module.new(
			self.Scale * other,
			self.Offset * other
		)
	end
	return module.new(
		self.Scale * other.Scale,
		self.Offset * other.Offset
	)
end

function module:ToLua()
	return "UDim.new("..tostring(self.Scale)..", "..tostring(self.Offset)..")"
end

return module