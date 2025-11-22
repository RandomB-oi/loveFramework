local module = {}
module.__index = module
module.__type = "ItemStack"

module.new = function(itemID, amount)
    local self = setmetatable({}, module._metatable)
    self.ID = itemID
    self.Amount = amount or 1

    return self
end

function module:GetItem()
    return Instance.GetClass("Item").Items[self.ID]
end

function module:Split(amount)
    local amount = math.clamp(math.round(amount), 1, self.Amount)

    local new = Instance.new("ItemStack", self.ID, amount)

    self.Amount = self.Amount-amount

    if self.Amount <= 0 then
        self:Destroy()
    end

    return new
end

-- returns if the stack was fully used
function module:Combine(otherStack, amount)
    if not self:CanCombine(otherStack) then return end
    local amount = amount or otherStack.Amount

    local stackSize = self:GetItem().StackSize

    local newAmount = math.min(self.Amount + math.min(amount, otherStack.Amount), stackSize)
    local addedAmount = newAmount - self.Amount

    self.Amount = newAmount
    otherStack.Amount = otherStack.Amount - addedAmount
    if otherStack.Amount <= 0 then
        otherStack:Destroy()
        return true
    end
end

function module:CanCombine(otherStack)
    if self.ID ~= otherStack.ID then
        return false
    end

    return true
end

function module:Destroy()
    setmetatable(self, nil)

    for index in pairs(self) do
        self[index] = nil
    end
end

return Instance.RegisterClass(module)