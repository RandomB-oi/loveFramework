local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "Constants"
Instance.RegisterClass(module)

module.new = function()
	local self = setmetatable(module.Base.new(), module)
    self.Name = self.__type

    self:CreateProperty("Health", "number", 0, "Int")
    self:CreateProperty("WorldSeed", "number", 0, "Int")

	return self
end


return module