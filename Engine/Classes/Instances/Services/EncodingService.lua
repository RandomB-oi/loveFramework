local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "EncodingService"

module.ReplicationEncodingMethod = Enum.EncodingMethod.Json

module.new = function ()
	local self = setmetatable(module.Base.new(module.__type), module._metatable)
	self.Name = self.__type

	return self
end

local EncodingMethods = {
	[Enum.EncodingMethod.Json] = {
		Encode = function(tbl)
			return json.encode(tbl)
		end,

		Decode = function(str)
			return json.decode(str)
		end,
	},
}

function module:Encode(data, format)
	if not EncodingMethods[format] then return false end

	return true, EncodingMethods[format].Encode(data)
end

function module:Decode(data, format)
	if not EncodingMethods[format] then return false end
	
	return true, EncodingMethods[format].Decode(data)
end

return Instance.RegisterClass(module)