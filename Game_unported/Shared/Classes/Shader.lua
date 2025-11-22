local module = {}
module.__index = module
module.__type = "Shader"

module.Shaders = {}

module.new = function(shader, shaderID)
	local self = setmetatable({}, module._metatable)
	self.ID = shaderID
	self.Shader = shader

    module.Shaders[shaderID] = self

	return self
end

function module:send(...)
	self.Shader:send(...)
end

Instance.RegisterClass(module)

local Run = Engine:GetService("RunService")

if Run:IsClient() then
	module.Normal = Instance.new("Shader", love.graphics.newShader("Game/Client/Shaders/Normal/Pixel.glsl", "Game/Client/Shaders/GenericVertex.glsl"), 1)
	module.TestShader = Instance.new("Shader", love.graphics.newShader("Game/Client/Shaders/TestShader/Pixel.glsl", "Game/Client/Shaders/GenericVertex.glsl"), 2)
	module.Sky = Instance.new("Shader", love.graphics.newShader("Game/Client/Shaders/Sky/Pixel.glsl", "Game/Client/Shaders/GenericVertex.glsl"), 3)
	module.Fog = Instance.new("Shader", love.graphics.newShader("Game/Client/Shaders/Fog/Pixel.glsl", "Game/Client/Shaders/GenericVertex.glsl"), 3)

	function module.Update(dt)
		module.TestShader:send("time", Run.ElapsedTime)
	end
end

return module