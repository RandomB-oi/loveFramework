local module = {}
module.Normal = love.graphics.newShader("Game/Shaders/TestShader/Pixel.glsl", "Game/Shaders/TestShader/Vertex.glsl")

local t = 0
function module:Update(dt)
    t = t + dt
    module.Normal:send("time", t)
end

return module