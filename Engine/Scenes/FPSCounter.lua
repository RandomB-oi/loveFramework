local FPSScene = Instance.new("Scene")
FPSScene.ZIndex = 11
FPSScene.Hidden = true
FPSScene.Parent = Engine



local oldUpdate = FPSScene.Update
local oldDraw = FPSScene.Draw

local lastDT = 0
function FPSScene.Update(self, dt)
	oldUpdate(self, dt)
    lastDT = dt
end

local goodFPS = Color.new(0, 1, 0, 1)
local okFPS = Color.new(1, 1, 0, 1)
local stinkyFPS = Color.new(1, 0, 0, 1)

function FPSScene.Draw(...)
	oldDraw(...)

	if not (FPSScene.Enabled and FPSScene.Visible) then return end

	local fps = math.round(1/lastDT)
    if fps < 15 then
        stinkyFPS:Apply()
    elseif fps < 30 then
        okFPS:Apply()
    else
        goodFPS:Apply()
    end
    
	love.graphics.drawCustomText(tostring(fps), FPSScene.RenderSize.X - 12,10,1)
end