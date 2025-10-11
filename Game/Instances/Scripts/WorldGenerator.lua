local module = {}
module.Derives = "Script"
module.__index = module
module.__type = "WorldGenerator"
Instance.RegisterClass(module)

module.new = function()
	local self = setmetatable(module.Base.new(), module)

	return self
end

function module:ScriptInit()
end

function module:ScriptUpdate(dt)
end

return module