
local TweenService = {}
local TweenClass = {}
do
	local module = TweenClass
	module.Derives = "BaseInstance"
	module.__index = module
	module.__type = "Tween"
	Instance.RegisterClass(module)

	module.new = function(object, tweenInfo, properties)
		local self = setmetatable(module.Base.new(), module)
		self.Name = self.__type
		self.Object = object
		self.TweenInfo = tweenInfo -- {Time = 3, Style, Direction}
		self.Properties = properties

		self.TimePosition = 0
		self.Playing = false
		self.OriginalProperties = {}

		self.Completed = self.Maid:Add(Signal.new())

		self.Parent = self.Object
		
		return self
	end

	function module:Play()
		for prop in pairs(self.Properties) do
			self.OriginalProperties[prop] = self.Object[prop]
		end

		self.TimePosition = 0
		self.Playing = true
		return self
	end

	function module:Pause()
		self.Playing = false
		return self
	end
	
	function module:Resume()
		self.Playing = true
		return self
	end
	
	function module:Cancel()
		self.TimePosition = 0
		self.Playing = false
		return self
	end

	function module:Update(dt)
		module.Base.Update(self, dt)

		if self.Playing then
			self.TimePosition = math.clamp(self.TimePosition + dt, 0, self.TweenInfo.Length)

			local alpha = self.TweenInfo:Solve(math.clamp(self.TimePosition / self.TweenInfo.Length, 0, 1))

			for prop, value in pairs(self.Properties) do
				self.Object[prop] = math.lerp(self.OriginalProperties[prop], value, alpha)
			end

			if alpha >= 1 then
				self.Playing = false
				self.Completed:Fire()
			end
		end
	end

	TweenClass = module
end


local module = TweenService
module.Derives = "BaseService"
module.__index = module
module.__type = "TweenService"
Instance.RegisterClass(module)

module.new = function ()
	local self = setmetatable(module.Base.new(), module)
	
	return self
end

function module:GetValue(alpha, style, direction)
	return TweenInfo._calcEasing(alpha, style, direction)
end

function module:Create(object, tweenInfo, properties)
	return TweenClass.new(object, tweenInfo, properties)
end

return module
