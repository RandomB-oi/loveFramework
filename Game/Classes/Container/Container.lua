local module = {}
module.__index = module
module.__type = "Container"
Instance.RegisterClass(module)

module.new = function(slotCount, rowSize)
	local self = setmetatable({}, module)
    self.Maid = Maid.new()

    self.Slots = {}
    self.SlotCount = slotCount
    self.RowSize = rowSize

	return self
end

function module:AddItem(stack)
    
end

function module:Destroy()
    self.Maid:Destroy()
end

return module