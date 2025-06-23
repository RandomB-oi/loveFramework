local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "Scene"
Instance.RegisterClass(module)

local LoadedServices = {}
module.ClassIcon = "Engine/Assets/InstanceIcons/Workspace.png"

module.new = function(size)
	local self = setmetatable(module.Base.new(), module)
	self.Parent = nil

	self.Name = "Scene"
	self:CreateProperty("IsPaused", "boolean", false)
	self:CreateProperty("Enabled", "boolean", true)

	self:CreateProperty("Size", "Vector", size or Vector.one)
	self.Canvas = love.graphics.newCanvas(self.Size.X, self.Size.Y)

	self.Updated = self.Maid:Add(Signal.new())
	self.Drawn = self.Maid:Add(Signal.new())

	self.Maid:GiveTask(function()
		self.Canvas:release()
	end)

	-- self.Camera = Instance.new("camera", self)
	-- self.Maid:GiveTask(self.camera)

	return self
end

function module:GetService(name)
	if not LoadedServices[name] then
		local serviceClass = Instance.GetClass(name)
		if rawget(serviceClass, "Derives") ~= "BaseService" then
			return
		end

		local newService = Instance.new(name)
		newService.Parent = Game
		LoadedServices[name] = newService
	end
	return LoadedServices[name]
end

function module:Update(dt)
	self:CheckProperties()

	if not (self.Enabled and not self.IsPaused) then return end

	self.Updated:Fire(dt)
	for _, child in ipairs(self:GetChildren()) do
		child:Update(dt)
	end
end

function module:Draw()
	if not (self.Enabled) then return end

	self.Drawn:Fire()

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

return module