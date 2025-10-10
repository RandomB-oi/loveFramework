local EngineScene = require("Engine.main")

local RunService = EngineScene:GetService("RunService")

do
	RunService._editor = true
	RunService._running = false
	RunService.TimeScale = 1/10
end

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	local ID = tostring(os.time())
	local fileName = "ExportedInstances/AutoSave"..ID..".lua"
	
	-- local GameScene = require("ExportedInstances.SavedGame")()
	local GameScene = require("Game.main")

	if RunService:IsEditor() then
		Editor = require("Editor.main"):Open(GameScene)

		task.spawn(function()
			print("do auto save loop")
			while task.wait(30) do
				if not RunService:IsRunning() then
					print("autoSave")
					Instance.CreatePrefab(GameScene, fileName)
				end
			end
		end)
	else
		GameScene:SetParent(EngineScene)
	end

	function love.update(dt)
		dt = math.clamp(dt, 0, 1/15)
		dt = dt * RunService.TimeScale
		RunService.ElapsedTime = RunService.ElapsedTime + dt
		-- local title = "Game" .. tostring(math.round(1/(dt)))
		local title = GameScene.Name.." - "..tostring(#GameScene:GetChildren(true).. " instances")
		EngineScene:Unpause():Enable()
		EngineScene.Name = title
		love.window.setTitle(title)
		
		task.update(dt)
		
		EngineScene.UpdateOrphanedInstances(dt)
		EngineScene:Update(dt)
	end

	function love.draw()
		EngineScene:Draw()
	end
end

return EngineScene