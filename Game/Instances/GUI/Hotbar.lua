local module = {}
module.Derives = "Frame"

module.__type = "Hotbar"

-- local items = {
--     {ID = "grass_block_item", Amount = 64},
--     {ID = "bedrock_block_item", Amount = 64},
--     {ID = "dirt_block_item", Amount = 64},
--     {ID = "stone_block_item", Amount = 64},
-- }

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)
    self.Name = self.__type
    self.Color = Color.new(0,0,0,0)
    self.Size = UDim2.new(1, 0, 1, 0)

    local panel = require("Game.Prefabs.Hotbar")(self)
    Instance.BulkSetProperties(panel, {Archivable = false})

    for i = 1, 5 do
        local new = Instance.new("ItemSlot")
        new.LayoutOrder = i
        new.Archivable = false
        new:SetParent(panel)
    end


	return self
end


return Instance.RegisterClass(module)