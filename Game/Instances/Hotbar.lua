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

    local panel = require("Game.Prefabs.Hotbar")(self)
    Instance.BulkSetProperties(panel, {Archivable = false})

    local slotPrefab = require("Game.Prefabs.ItemSlot")
    for i = 1, 5 do
        Instance.BulkSetProperties(slotPrefab(panel), {Archivable = false})
    end


	return self
end


return module