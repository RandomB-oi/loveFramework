local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "Hotbar"
Instance.RegisterClass(module)

module.new = function()
	local self = setmetatable(module.Base.new(), module)
    self.Name = self.__type
    self.Color = Color.new(0,0,0,0)
    self.Size = UDim2.new(1, 0, 1, 0)

    Instance.BulkSetProperties(require("Game.Prefabs.Hotbar")(self), {Archivable = false})


	return self
end


return module