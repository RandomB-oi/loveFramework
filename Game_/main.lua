require("Game.Shared.main")
if Engine:GetService("RunService"):IsClient() then
    require("Game.Client.main")
else
    require("Game.Server.main")
end