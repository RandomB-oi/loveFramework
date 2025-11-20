local EngineScene = require("Engine.main")

local RunService = EngineScene:GetService("RunService")
print(RunService.TimeScale, rawget(RunService, "__newindex"))
do
	RunService._editor = true
	RunService._running = false
	RunService.TimeScale = 1
end

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	local ID = tostring(os.time())
	local fileName = "ExportedInstances/AutoSave"..ID..".lua"
	
	-- local loadedScene = require("ExportedInstances.SavedGame")()
	if not RunService:IsEditor() then
		RunService._running = true
	end

	local loadedScene = require("Game.main")
	GameScene = loadedScene

	if RunService:IsEditor() then
		Editor = require("Editor.main"):Open(loadedScene)

		task.spawn(function()
			while task.wait(30) do
				if not RunService:IsRunning() then
					print("autoSave")
					Instance.CreatePrefab(loadedScene, fileName)
				end
			end
		end)
	else
		loadedScene:SetParent(EngineScene)
	end

	function love.update(dt)
		dt = math.clamp(dt, 0, 1/15)
		dt = dt * RunService.TimeScale
		RunService.ElapsedTime = RunService.ElapsedTime + dt
		local title = loadedScene.Name.." - "..tostring(math.round(1/(dt)))
		-- local title = loadedScene.Name.." - "..tostring(#loadedScene:GetChildren(true).. " instances")
		EngineScene:Unpause():Enable()
		EngineScene.Name = title
		love.window.setTitle(title)
		
		task.update(dt)
		
		EngineScene.UpdateOrphanedInstances(dt)
		EngineScene:Update(dt)
	end

	function love.draw()
		EngineScene:Draw()
		-- for _, v in pairs(Instance.GetClass("BaseInstance").All) do
			-- if v:IsA("Scene") then
			-- 	love.graphics.drawOutline(v.RenderPosition, v.RenderSize)
			-- end
		-- end
	end
end

return EngineScene