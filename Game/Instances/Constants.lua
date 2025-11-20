local module = {}
module.Derives = "BaseService"

module.__type = "Constants"

module.new = function()
	local self = setmetatable(module.Base.new(), module._metatable)
    self.Name = self.__type

    -- generic movement
    self:CreateProperty("MoveLeft", "KeyCode", Enum.KeyCode.A)
    self:CreateProperty("MoveRight", "KeyCode", Enum.KeyCode.D)
    self:CreateProperty("Jump", "KeyCode", Enum.KeyCode.Space)
    
    -- flying
    self:CreateProperty("MoveUp", "KeyCode", Enum.KeyCode.W)
    self:CreateProperty("MoveDown", "KeyCode", Enum.KeyCode.S)
    self:CreateProperty("ToggleFlight", "KeyCode", Enum.KeyCode.H)

	return self
end


return Instance.RegisterClass(module)