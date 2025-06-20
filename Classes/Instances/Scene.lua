local module = {}
module.Base = require("Classes.Instances.BaseInstance")
module.__index = module
module.__type = "Scene"
setmetatable(module, module.Base)

local Services = {}
for _, service in pairs({
	require("Classes.Instances.Services.InputService"),
}) do
	Services[service.__type] = service
end

module.new = function(size)
	local size = size or Vector.new(1, 1)
	local self = setmetatable(module.Base.new(), module)
	self.Parent = nil

	self.IsPaused = false
	self.Enabled = true

	self.Canvas = love.graphics.newCanvas(size.X, size.Y)
	self.Size = size

	self.UpdateSignal = self.Maid:Add(Signal.new())
	self.DrawSignal = self.Maid:Add(Signal.new())

	self.Maid:GiveTask(function()
		self.Canvas:release()
	end)

	-- self.Camera = Instance.new("camera", self)
	-- self.Maid:GiveTask(self.camera)

	return self
end

function module:GetService(name)
	return Services[name]
end

function module:Update(dt)
	self:CheckParent()

	if not (self.Enabled and not self.IsPaused) then return end

	self.UpdateSignal:Fire(dt)
	for _, child in ipairs(self:GetChildren()) do
		child:Update(dt)
	end
end

function module:Draw()
	if not (self.Enabled) then return end

	self.DrawSignal:Fire()

	-- if self._canvasNeedsUpdate then
	-- 	self._canvasNeedsUpdate = false

	-- 	local scene = self.Parent and self.Parent:GetScene()
	-- 	if scene then
	-- 		scene._canvasNeedsUpdate = true
	-- 	end

		love.graphics.setCanvas(self.Canvas)
		love.graphics.clear()
		self:DrawChildren()
		love.graphics.setCanvas()
	-- end

	Color.White:Apply()
	love.graphics.draw(self.Canvas, 0, 0)
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

return Instance.RegisterClass(module)