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

module.Normal = Instance.new("Shader", love.graphics.newShader("Game/Shaders/Normal/Pixel.glsl", "Game/Shaders/GenericVertex.glsl"), 1)
module.TestShader = Instance.new("Shader", love.graphics.newShader("Game/Shaders/TestShader/Pixel.glsl", "Game/Shaders/GenericVertex.glsl"), 2)
module.Sky = Instance.new("Shader", love.graphics.newShader("Game/Shaders/Sky/Pixel.glsl", "Game/Shaders/GenericVertex.glsl"), 3)
module.Fog = Instance.new("Shader", love.graphics.newShader("Game/Shaders/Fog/Pixel.glsl", "Game/Shaders/GenericVertex.glsl"), 3)

function module.Update(dt)
    local run = GameScene:GetService("RunService")
    module.TestShader:send("time", run.ElapsedTime)
end

return module