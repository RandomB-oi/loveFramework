local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "World"
Instance.RegisterClass(module)

module.new = function()
	local self = setmetatable(module.Base.new(), module)
    self.Name = self.__type

    self.Chunks = {}

	return self
end


return module