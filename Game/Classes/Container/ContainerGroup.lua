local module = {}
module.__index = module
module.__type = "ContainerGroup"
Instance.RegisterClass(module)

local ContainerUtility = require("Game.Utility.Container")

module.new = function(slotCount, rowSize)
	local self = setmetatable({}, module)
    self.Maid = Maid.new()
    self.Containers = {}
    
	return self
end

function module:GetContainer(name)
    return self.Containers[name]
end

function module:AddContainer(name, container)
    self.Containers[name] = self.Maid:Add(container)
end

function module:GiveItemStack(stack)
    for name, container in pairs(self.Containers) do
        if container:AddToExisting(stack) then return true end
    end
    
    for name, container in pairs(self.Containers) do
        if container:GiveItem(stack) then return true end
    end
end

function module:Destroy()
    self.Maid:Destroy()
end

return module