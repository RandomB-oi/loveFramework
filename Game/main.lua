GameScene = Instance.new("Scene")
GameScene.Name = "Test Game"
GameScene:SetParent(Engine)

local newBin = Binary.WriteBits(0, 0, 4, 15)
for i = 0, Binary.GetSize(newBin)-1 do
    print(Binary.ReadBits(newBin, i, 1))
end
print(Binary.ReadBits(newBin, 0, 4), tostring(newBin))

autoLoad("Game/Classes")
autoLoad("Game/Instances")
Instance.GetClass("Block").Init()
Instance.GetClass("Item").Init()

love.window.setMode(800, 600, {resizable = true})

Instance.new("Constants"):SetParent(GameScene)
require("Game.Scenes.MainMenu"):Enable():Unpause()

return GameScene