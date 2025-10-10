local module = {}

module.MaxHealth = Instance.new("IntValue")
module.MaxHealth.Value = 100
module.MaxHealth.Name = "MaxHealth"
module.MaxHealth:SetParent(GameScene)

module.Health = Instance.new("IntValue")
module.Health.Value = module.MaxHealth.Value
module.Health.Name = "Health"
module.Health:SetParent(GameScene)

return module