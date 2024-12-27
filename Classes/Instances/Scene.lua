local module = {}
module.Base = require("Classes.Instances.Instance")
module.__index = module
module.__type = "Scene"
setmetatable(module, module.Base)

module.new = function(size)
	local self = setmetatable(module.Base.new(), module)

	self.IsPaused = false
	self.Enabled = true

	self.GuiCanvas = love.graphics.newCanvas(size.X, size.Y)
	self.Canvas = love.graphics.newCanvas(size.X, size.Y)
	self.Size = size

	self.UpdateSignal = self.Maid:Add(Signal.new())
	self.DrawSignal = self.Maid:Add(Signal.new())

	self.Maid:GiveTask(function()
		self.GuiCanvas:release()
		self.Canvas:release()
	end)

	-- self.Maid.GuiInputBegan = GuiInputBegan:Connect(function(...)
	-- 	self.GuiInputBegan:Fire(...)
	-- end)
	-- self.Maid.GuiInputEnded = GuiInputEnded:Connect(function(...)
	-- 	self.GuiInputEnded:Fire(...)
	-- end)
	-- self.Maid.InputBegan = InputBegan:Connect(function(...)
	-- 	self.InputBegan:Fire(...)
	-- end)
	-- self.Maid.InputEnded = InputEnded:Connect(function(...)
	-- 	self.InputEnded:Fire(...)
	-- end)

	-- self.Camera = Instance.new("camera", self)
	-- self.Maid:GiveTask(self.camera)

	return self
end

function module:Update(dt)
	module.Base.Update(self, dt)
	self.UpdateSignal:Fire(dt)
end

function module:Draw()
	module.Base.Draw(self)
	self.DrawSignal:Fire()

	for _, child in ipairs(self:GetChildren()) do
		if child:IsA("Frame") then
			love.graphics.setCanvas(self.GuiCanvas)
		else
			love.graphics.setCanvas(self.Canvas)
		end
		child:Draw()
	end
	love.graphics.setCanvas()
end

function module:Pause()
	self.IsPaused = true
	return self
end
function module:Unpause()
	self.IsPaused = false
	return self
end
function module:Enable()
	self.Enabled = true
	return self
end
function module:Disable()
	self.Enabled = false
	return self
end

function module.UpdateAll(dt)
	for name, scene in pairs(module.All) do
		if scene.Enabled and not scene.IsPaused then
			scene:Update(dt)
		end
	end
end

function module.DrawAll()
	for name, scene in pairs(module.All) do
		if scene.Enabled then
			if scene._guiNeedsUpdate then
				scene._guiNeedsUpdate = false
				scene:Draw()
			end
			Color.White:Apply()
			love.graphics.draw(scene.Canvas, 0, 0)
		end
	end

	for name, scene in pairs(module.All) do
		if scene.Enabled then
			Color.White:Apply()
			love.graphics.draw(scene.GuiCanvas, 0, 0)
		end
	end
end

return module