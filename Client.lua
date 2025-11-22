local ogPrint = print
print = function(...)
	ogPrint("[CLIENT]", ...)
end

local RunService = Engine:GetService("RunService")

love.graphics.setDefaultFilter("nearest", "nearest")

require("Game.Shared.main")
require("Game.Client.main")

if RunService:IsEditor() then
	Editor = require("Editor.main"):Open(GameScene)
else
	GameScene.Parent = Engine
end

local function Update(dt)
	RunService.ElapsedTime = RunService.ElapsedTime + dt
	local title = GameScene.Name.." - "..tostring(math.round(1/(dt)))
	-- local title = GameScene.Name.." - "..tostring(#GameScene:GetChildren(true).. " instances")
	Engine:Unpause():Enable()
	Engine.Name = title
	love.window.setTitle(title)
	
	task.update(dt)
	
	Engine.UpdateOrphanedInstances(dt)
	Engine:Update(dt)
end

love.update = Update

function love.draw()
	Engine:Draw()
	-- for _, v in pairs(Instance.GetClass("BaseInstance").All) do
	-- 	if v:IsA("Scene") then
	-- 		love.graphics.drawOutline(v.RenderPosition, v.RenderSize)
	-- 	end
	-- end
end


function love.quit()
    Engine:GetService("ClientService"):DisconnectFromServer()
end