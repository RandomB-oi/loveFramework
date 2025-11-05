local module = {}
module.Derives = "BaseInstance"
module.__index = module
module.__type = "ConstraintBase"
Instance.RegisterClass(module)

module.ConstraintCategory = "Unknown"

module.new = function()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	self.ParentMaid = self.Maid:Add(Maid.new())

	self:GetPropertyChangedSignal("Parent"):Connect(function()
		self.ParentMaid:Destroy()
		local parent = self.Parent
		if not parent then
			return
		end

		if not parent._constraintChildren then
			parent._constraintChildren = {}
		end
		parent._constraintChildren[self.ConstraintCategory] = self

		self.ParentMaid:GiveTask(function()
			if parent._constraintChildren and parent._constraintChildren[self.ConstraintCategory] == self then
				parent._constraintChildren[self.ConstraintCategory] = nil
				if not next(parent._constraintChildren) then
					parent._constraintChildren = nil
				end
			end
		end)
		self:BindToParent(parent)
	end)
	
	return self
end

function module:BindToParent(parent)
end

return module