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
	self.Name = self.__type
	-- self:SetParent(nil)
	
	self.Canvas = nil
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
	if not (self.Enabled and not self.Paused) then return end



	self:UpdateRender()

	local desiredSize = Vector.new(math.round(self.RenderSize.X), math.round(self.RenderSize.Y))
	local canvasX, canvasY
	if self.Canvas then
		canvasX, canvasY = self.Canvas:getDimensions()
		canvasX = math.round(canvasX)
		canvasY = math.round(canvasY)
	end

	if desiredSize.X ~= canvasX or desiredSize.Y ~= canvasY then
		if self.Canvas then
			self.Canvas:release()
			self.Canvas = nil
		end

		if desiredSize.X >= 1 and desiredSize.Y >= 1 then
			self.Canvas = love.graphics.newCanvas(desiredSize.X, desiredSize.Y)
		end
	end

	self.Updated:Fire(dt)
	for _, child in ipairs(self:GetChildren()) do
		child:Update(dt)
	end
end

function module:Draw()
	if not (self.Enabled) then return end

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

	if not self.Canvas then print("no canvas for ",self.Name) return end
	self.Drawn:Fire()

	-- local parentPos = self.Parent and self.Parent.RenderPosition or Vector.zero

	local prevCanvas = love.graphics.getCanvas()

	love.graphics.setCanvas(self.Canvas)
	love.graphics.clear()
	self:DrawChildren()

	love.graphics.setCanvas(prevCanvas)

	self.Color:Apply()
	
	local scene = self:FindFirstAncestorWhichIsA("Scene")
	local sceneOffset = scene and scene.RenderPosition or Vector.zero
	love.graphics.cleanDrawImage(self.Canvas, self.RenderPosition-sceneOffset, self.RenderSize)
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
	self.Enabled = true
	return self
end
function module:Disable()
	self.Enabled = false
	return self
end

return module