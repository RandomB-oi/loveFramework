local ogPrint = print
print = function(...)
	ogPrint("[SERVER]", ...)
end
if not _G.LaunchParameters then
	_G.LaunchParameters = {}
	_G.LaunchParameters.noGraphics = true
	_G.LaunchParameters.sepThread = true
end
_G.LaunchParameters.server = true
require("Engine.main")

local RunService = Engine:GetService("RunService")
local ServerService = Engine:GetService("ServerService")

local socket = require("socket")

RunService._isServer = true

require("Game.Shared.main")
require("Game.Server.main")

if RunService:IsEditor() then
	Editor = require("Editor.main"):Open(GameScene)
else
	GameScene.Parent = Engine
end

ServerService:StartServer(6767)

local lastTick = os.clock()
local tickRate = 1/20

local function Update(dt)
	RunService.ElapsedTime = RunService.ElapsedTime + dt * RunService.TimeScale
	
	task.update(dt)

	Engine.UpdateOrphanedInstances(dt)
	Engine:Update(dt)
end

if _G.LaunchParameters.sepThread then -- running on separate thread
	local channel = love.thread.getChannel("server_events")
	while true do
		dt = os.clock() - lastTick
		lastTick = os.clock()

		Update(dt)
		local msg = channel:pop()
		if msg == "shutdown" then
			break
		end

		if love.timer then
			love.timer.sleep(tickRate)
		else
			socket.sleep(tickRate)
		end
	end

	print("Close server")
else
	love.update = Update
	
	love.draw = function()
		Engine:Draw()
	end
end