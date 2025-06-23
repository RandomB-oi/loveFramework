local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "Folder"
Instance.RegisterClass(module)

module.new = function(size)
	local self = setmetatable(module.Base.new(), module)
	self.Name = "Folder"

	return self
end

return module