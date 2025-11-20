local module = {}
module.Derives = "Frame"

module.__type = "Fog"

-- local Run = Engine:GetService("RunService")

module.new = function(...)
	local self = setmetatable(module.Base.new(...), module)

    self.Name = "FogFrame"
    self.ZIndex = 1
    self.Size = UDim2.new(1, 0, 1, 0)
    self.Color = Color.new(1,1,1,1)
    self.Shader = Instance.GetClass("Shader").Fog.Shader

    self:CreateProperty("FogStart", "number", 0)
    self:CreateProperty("FogEnd", "number", 1)
    self:CreateProperty("Roundness", "number", 0.5)
    self:CreateProperty("Scale", "number", 1)

	return self
end

function module:Update(...)
    module.Base.Update(self, ...)
    if not self.Enabled then return end

    local size = self.Scale
    self.Shader:send("fog_start", self.FogStart * size)
    self.Shader:send("fog_end", self.FogEnd * size)
    self.Shader:send("circle_percent", self.Roundness)
    -- self.Shader:send("time", Run.ElapsedTime)
end

return Instance.RegisterClass(module)