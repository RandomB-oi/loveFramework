local module = {}
module.Derives = "Script"

module.__type = "GUICode"

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)
	self:CreateProperty("World", "Instance", nil)

	return self
end

function module:ScriptInit()
	self.GuiScene = self.Maid:Add(Instance.new("Scene"))
    self.GuiScene.Name = "GuiScene"
    self.GuiScene.ZIndex = 1
	self.GuiScene:SetParent(self:GetScene())
    
    self.InventoryContainer = Instance.new("ContainerGui")
    self.InventoryContainer.AnchorPoint = Vector.new(0.5, 0)
    self.InventoryContainer.Position = UDim2.new(0.5, 0, 0, 0)
    self.InventoryContainer:SetParent(self.GuiScene)

    Instance.new("UIPadding"):SetParent(self.GuiScene)
    
    self.WorldMaid = self.Maid:Add(Maid.new())
    self.ZIndex = 100

    self:SetWorld(self.World)
    self:GetPropertyChangedSignal("World"):Connect(function()
        self:SetWorld(self.World)
    end)
    -- local container = Instance.new("Container", 18, 6)
    -- containerGui.Container = container
end

function module:SetWorld(world)
    self.WorldMaid:Destroy()
    if not world then
        return
    end

    self:SetPlayer(world.LocalPlayer)
    self.WorldMaid:GiveTask(world:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
       self:SetPlayer(world.LocalPlayer)
    end))
end

function module:SetPlayer(player)
    if player then
        self.InventoryContainer.Container = player.ContainerGroup:GetContainer("Inventory")
    else
        self.InventoryContainer.Container = nil
    end
end

function module:ScriptUpdate(dt)

end


function module:Draw()
    if not self.Enabled then return end

    module.Base.Draw(self)
end

return Instance.RegisterClass(module)