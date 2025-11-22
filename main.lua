require("Engine.main")
local RunService = Engine:GetService("RunService")

function love.load(_args)
	-- local launchParameters = {} for _, arg in ipairs(_args) do launchParameters[arg] = true end
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
	print("done")
end