GameScene = Instance.new("DataModel")
GameScene.Name = "Test Game"
GameScene.Parent = Engine

autoLoad("Game/Shared/Classes")
autoLoad("Game/Shared/Instances")
Instance.GetClass("Block").Init()
Instance.GetClass("Item").Init()