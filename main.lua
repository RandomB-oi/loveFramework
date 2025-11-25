require("Engine.main")
local RunService = Engine:GetService("RunService")

function love.load()
	_G.LaunchParameters = _G.LaunchParameters or {}
	
	if _G.LaunchParameters.editor then
		RunService._editor = true
	end

	if _G.LaunchParameters.server then
		RunService._isServer = true
	end

	if RunService:IsServer() then
		require("Server")
	else
		require("Client")
	end
end