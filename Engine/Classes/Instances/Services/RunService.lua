local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "RunService"
Instance.RegisterClass(module)


module.new = function ()
	local self = setmetatable(module.Base.new(), module)
	self.Name = self.__type

	self:CreateProperty("ElapsedTime", "number", 0)
	self:CreateProperty("TimeScale", "number", 1)
	self._running = false
	self._editor = false
	self._currentRunningGame = nil

	self:SetAttribute("test attribute", 10)

	return self
end

function module:IsRunning()
	return self._running
end

function module:IsEditor()
	return self._editor
end

function module:Run()
	local RunService = Engine:GetService("RunService")
	if RunService:IsRunning() then return self._currentRunningGame end

	
	if RunService:IsEditor() then
		GameScene:Disable()
		
		RunService._running = true
		self._currentRunningGame = GameScene:Clone()
		self._currentRunningGame.Name = self._currentRunningGame.Name .. " Runtime"
		self._currentRunningGame:SetParent(GameScene.Parent)
		self._currentRunningGame:Enable()
	else
		self._currentRunningGame = GameScene
		RunService._running = true
		GameScene:Enable():Unpause()
	end


	return self._currentRunningGame
end

function module:Stop()
	local RunService = Engine:GetService("RunService")
	if not RunService:IsRunning() then return GameScene end

	RunService._running = false
	
	if RunService:IsEditor() then
		self._currentRunningGame:Destroy()
		self._currentRunningGame = nil
		GameScene:Enable()
	else
		self._currentRunningGame = nil
		GameScene:Disable()
	end


	return GameScene
end

return module