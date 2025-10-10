local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "EditorInstance"
Instance.RegisterClass(module)



module.new = function()
	local self = setmetatable(module.Base.new(), module)

	return self
end

return module