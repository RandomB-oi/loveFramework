local module = {}
module.Derives = "Frame"
module.__type = "EditorInstance"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)

	return self
end

return Instance.RegisterClass(module)