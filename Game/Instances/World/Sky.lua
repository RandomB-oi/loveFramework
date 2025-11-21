local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "Sky"

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module._metatable)
    self.Name = self.__type
    
    self.ZIndex = -2
    self.Size = UDim2.new(1, 0, 1, 0)
    self.Shader = Instance.GetClass("Shader").Sky.Shader
    
    self:CreateProperty("SkyTopColor", "Color", Color.from255(150, 150, 255, 255))
    self:CreateProperty("SkyBottomColor", "Color", Color.from255(25, 70, 255, 255))

	return self
end

function module:Update(...)
    module.Base.Update(self, ...)
    if not self.Enabled then return end
    
    local color = self.SkyTopColor
    self.Shader:send("sky_top", {color.R,color.G,color.B, color.A})
    local color = self.SkyBottomColor
    self.Shader:send("sky_bottom", {color.R,color.G,color.B, color.A})
end

return Instance.RegisterClass(module)