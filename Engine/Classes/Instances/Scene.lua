local module = {}
module.Derives = "Frame"
module.__index = module
module.__type = "Scene"
Instance.RegisterClass(module)

local LoadedServices = {}
module.ClassIcon = "Engine/Assets/InstanceIcons/Workspace.png"
module.FrameRendering = false

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self:SetParent(nil)

	self.Name = "Scene"
	self:CreateProperty("Paused", "boolean", false)

	self.Size = UDim2.fromScale(1,1)

	self.Updated = self.Maid:Add(Signal.new())
	self.Drawn = self.Maid:Add(Signal.new())

	self.Maid:GiveTask(function()
		if self.Canvas then
			self.Canvas:release()
			self.Canvas = nil
		end
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
		newService:SetParent(Engine)
		LoadedServices[name] = newService
	end
	return LoadedServices[name]
end

function module:Update(dt)
	self:CheckProperties()
	if not (self.Visible and not self.Paused) then return end

	self.Updated:Fire(dt)
	for _, child in ipairs(self:GetChildren()) do
		child:Update(dt)
	end
end

function module:Draw()
	if not (self.Visible) then return end
	self:UpdateRender()

	-- local desiredSize = self.RenderSize
	-- local renderPosition = self.RenderPosition or Vector.zero
	
	-- if not desiredSize then
	-- 	desiredSize = Vector.new(love.graphics.getDimensions())
	-- end

	-- local canvasX, canvasY
	-- if self.Canvas then
	-- 	canvasX, canvasY = self.Canvas:getDimensions()
	-- end

	-- if desiredSize.X ~= canvasX or desiredSize.Y ~= canvasY then
	-- 	if self.Canvas then
	-- 		self.Canvas:release()
	-- 		self.Canvas = nil
	-- 	end

	-- 	if desiredSize.X >= 1 and desiredSize.Y >= 1 then
	-- 		self.Canvas = love.graphics.newCanvas(desiredSize.X, desiredSize.Y)
	-- 	end
	-- end

	-- if not self.Canvas then return end
	self.Drawn:Fire()

	-- local parentPos = self.Parent and self.Parent.RenderPosition or Vector.zero

	-- love.graphics.push()
	-- love.graphics.setCanvas(self.Canvas)
	-- love.graphics.translate(-self.RenderPosition.X, -self.RenderPosition.Y)
	-- love.graphics.clear()
	self:DrawChildren()
	-- love.graphics.setCanvas()
	-- love.graphics.pop()

	-- Color.White:Apply()
	-- love.graphics.push()
	-- love.graphics.translate(self.RenderPosition.X, self.RenderPosition.Y)
	-- love.graphics.draw(self.Canvas, 0,0)
	-- love.graphics.pop()
end

function module:Pause()
	self.Paused = true
	return self
end
function module:Unpause()
	self.Paused = false
	return self
end
function module:Enable()
	self.Visible = true
	return self
end
function module:Disable()
	self.Visible = false
	return self
end

return module