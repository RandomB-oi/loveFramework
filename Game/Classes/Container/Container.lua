local module = {}
module.__index = module
module.__type = "Container"
Instance.RegisterClass(module)

local ContainerUtility = require("Game.Utility.Container")

module.new = function(slotCount, rowSize)
	local self = setmetatable({}, module)
    self.Maid = Maid.new()

    self.Slots = {}
    self.SlotCount = slotCount
    self.RowSize = rowSize

    for i = 1, self.SlotCount do
        self.Slots[i] = {}
    end
    
	return self
end

-- function module:GetItems()
    
-- end

function module:GetUsedIndices(stack, i)
    local item = stack:GetItem()
    local x,y = ContainerUtility.IndexToGrid(i, self.RowSize)

    local usedIndices = {}

    for ox = 0, item.StackWidth - 1 do
        for oy = 0, item.StackHeight - 1 do
            usedIndices[ContainerUtility.GridToIndex(x+ox, y+oy, self.RowSize)] = true
        end
    end

    return usedIndices
end

function module:SlotUsed(i)
    if self.Slots[i] and self.Slots[i].ID then
        return self.Slots[i]
    end
    
    for slotIndex, slot in ipairs(self.Slots) do
        if slot.ID and self:GetUsedIndices(slot, slotIndex)[i] then
            return true
        end
    end
    return false
end

function module:StackFits(stack, i)
    local usedIndices = self:GetUsedIndices(stack, i)
    
    -- check bounds

    -- check for other slots
    for slotIndex, slot in ipairs(self.Slots) do
        if slot.ID then
            for usedSlot in pairs(self:GetUsedIndices(slot, slotIndex)) do
                if usedIndices[usedSlot] then
                    return false
                end
            end
        end
    end

    return true
end

function module:StackAllowed(stack, index)
    return true
end

function module:AddToExisting(stack)
    for i, item in pairs(self.Slots) do
        if item.ID and item:CanCombine(stack) then
            if self:StackAllowed(stack, i) and item:Combine(stack) then
                return true
            end
        end
    end
end

function module:GiveItem(stack)
    -- if self:AddToExisting(stack) then return end

    for i = 1, self.SlotCount do
        if self:StackAllowed(stack, i) and self:StackFits(stack, i) then
            self.Slots[i] = stack
            return true
        end
    end
end

function module:Destroy()
    self.Maid:Destroy()
end

return module