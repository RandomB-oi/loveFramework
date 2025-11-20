local module = {}
module.Derives = "BaseService"

module.__type = "RunService"


module.new = function ()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type

	self:CreateProperty("ElapsedTime", "number", 0)
	self:CreateProperty("TimeScale", "number", 1)
	self._running = false
	self._editor = false
	self._currentRunningGame = nil

	self.RunChanged = self.Maid:Add(Signal.new())

	return self
end

function module:IsRunning()
	return self._running
end

function module:IsEditor()
	return self._editor
end

function module:Run()
	if self:IsRunning() then return self._currentRunningGame end

	self.RunChanged:Fire(true)
	
	if self:IsEditor() then
		GameScene:Disable()
		
		self._running = true
		self._currentRunningGame = GameScene:Clone()
		self._currentRunningGame.Name = self._currentRunningGame.Name .. " Runtime"
		self._currentRunningGame:SetParent(GameScene.Parent)
		self._currentRunningGame:Enable()
	else
		self._currentRunningGame = GameScene
		self._running = true
		GameScene:Enable():Unpause()
	end


	return self._currentRunningGame
end

function module:Stop()
	if not self:IsRunning() then return GameScene end

	self.RunChanged:Fire(false)

	self._running = false
	
	if self:IsEditor() then
		self._currentRunningGame:Destroy()
		self._currentRunningGame = nil
		GameScene:Enable()
	else
		self._currentRunningGame = nil
		GameScene:Disable()
	end


	return GameScene
end

return Instance.RegisterClass(module)