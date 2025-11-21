local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "ContainerGui"

local Run = Engine:GetService("RunService")
local Input = Engine:GetService("InputService")
local ContainerUtility = require("Game.Utility.Container")

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
    self.Name = self.__type
    self.Size = UDim2.fromScale(1,1)
    self.Color = Color.new(0,0,0,0)
	self:CreateProperty("Container", "Container", nil)
    -- self.Hidden = true
    
    self.AspectRatio = Instance.new("UIAspectRatioConstraint")
    self.AspectRatio.Archivable = false
    self.AspectRatio:SetParent(self)

    self.SizeConstraint = Instance.new("UISizeConstraint")
    self.SizeConstraint.Archivable = false
    self.SizeConstraint:SetParent(self)

    self.Frames = {}

    self:GetPropertyChangedSignal("Container"):Connect(function()
        self:RenderFrames()
    end)

	return self
end
function module:RenderFrames()
    for i,v in pairs(self.Frames) do
        v:Destroy()
    end
    self.Frames = {}

    local container = self.Container
    if not container then return end
    
    local rowAmount = ContainerUtility.GetRowCount(container.SlotCount, container.RowSize)
    self.AspectRatio.AspectRatio = container.RowSize/rowAmount
    self.SizeConstraint.Max = Vector.new(math.huge, 50*rowAmount)

    local xSize = 1/container.RowSize
    local ySize = 1/rowAmount
    for i = 1, container.SlotCount do
        local slot = container:SlotUsed(i)
        if slot ~= true then
            local x,y = ContainerUtility.IndexToGrid(i, container.RowSize)
            local item = slot and slot:GetItem()
            local width, height = item and item.StackWidth or 1,item and item.StackHeight or 1

            local newFrame = Instance.new("ItemSlot")
            newFrame.Position = UDim2.fromScale((x-1)*xSize, (y-1)*ySize)
            newFrame.Size = UDim2.fromScale(width*xSize, height*ySize)
            newFrame:SetItem(slot)
            newFrame:SetParent(self)
            self.Frames[i] = newFrame
        end
    end
end

function module:ScriptUpdate(dt)

end


function module:Draw()
    if not self.Enabled then return end

    module.Base.Draw(self)
end

return Instance.RegisterClass(module)