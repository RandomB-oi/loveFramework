local module = {}
module.Derives = "BaseService"

module.__type = "Selection"

module.new = function ()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type

	self.Selection = {}
	self.SelectionChanged = self.Maid:Add(Signal.new())

	Engine:GetService("RunService").RunChanged:Connect(function()
		self:Set({})
	end)
	
	return self
end

function module:Draw(...)
	module.Base.Draw(self,...)

	for _, object in pairs(self:Get()) do
		if object.RenderSize and object.RenderPosition then
			love.graphics.drawOutline(object.RenderPosition, object.RenderSize, object.RenderRotation, object.AnchorPoint)
			-- local objectCenter = (object.RenderPosition+object.RenderSize/2)
			-- local offset = Vector.one * 10

			-- local upVec = objectCenter + Vector.FromAngle(math.rad(object.RenderRotation)) * offset
			-- local rightVec = objectCenter + Vector.FromAngle(math.rad(object.RenderRotation+90)) * offset
			-- love.graphics.circle("fill", upVec.X, upVec.Y, 4)
			-- love.graphics.circle("fill", rightVec.X, rightVec.Y, 4)
		end
	end
end

function module:Get()
	return table.shallowCopy(self.Selection)
end

function module:Set(new)
	self.Selection = new or {}
	self.SelectionChanged:Fire(self:Get())
end

function module:IsSelected(object)
	return table.find(self.Selection, object)
end

function module:Add(object)
	if self:IsSelected(object) then return end
	table.insert(self.Selection, object)
	self.SelectionChanged:Fire(self:Get())
end

function module:Remove(object)
	local index = self:IsSelected(object)
	if not index then return end
	table.remove(self.Selection, index)
	self.SelectionChanged:Fire(self:Get())
end

return Instance.RegisterClass(module)