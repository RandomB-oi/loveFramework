local EngineScene = require("Engine.main")

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	local ID = tostring(os.time())
	local fileName = "ExportedInstances/AutoSave"..ID..".lua"
	
	-- local GameScene = require("ExportedInstances.SavedGame")()
	local GameScene = require("Game.main")
	task.spawn(function()
		while task.wait(30) do
			print("autoSave")
			Instance.CreateScript(GameScene, fileName)
		end
	end)
	
	require("Editor.main"):Open(GameScene)


	function love.update(dt)
		dt = math.clamp(dt, 0, 1/15)
		-- local title = "Game" .. tostring(math.round(1/(dt)))
		local title = GameScene.Name.." - "..tostring(#GameScene:GetChildren(true).. " instances")
		Engine:Unpause():Enable().Visible = true
		Engine.Name = title
		love.window.setTitle(title)
		
		task.update(dt)
		
		Engine.UpdateOrphanedInstances(dt)
		Engine:Update(dt)
	end

	function love.draw()
		Engine:Draw()
	end
end

return Engine