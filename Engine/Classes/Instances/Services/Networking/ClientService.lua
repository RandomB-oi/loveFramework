local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "ClientService"

local enet = require("enet")

local function encode(tbl)
    return json.encode(tbl)
end

local function decode(str)
    return json.decode(str)
end

module.new = function ()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type

    self.Disconnected = Signal.new()
    self.MessageRecieved = Signal.new()

    self:CreateProperty("ServerIP", "string", "")
    self:CreateProperty("ServerPort", "string", "")
    self:CreateProperty("LocalID", "string", "")

    self.Host = enet.host_create()
    self.ServerPeer = nil
    self.LocalServer = nil

    self.MessageRecieved:Connect(function(message, data)
        if message == "CreateInstance" then
            local object = Instance.GetClass("BaseInstance").All[data.ID] or Instance.new(data.ClassName, data.ID)
            if object then
                object:DeserializeData(data.Data)
            end
        elseif message == "UpdateProperty" then
            local object = Instance.GetClass("BaseInstance").All[data.ID]
            if object then
                object[data.Prop] = Serializer.Decode(data.Value)
            end
            
        elseif message == "connect" then
            self.LocalID = data.id
            self:SendMessage("connected")
        end
    end)

    --[[
	if not prop then
		ServerService:SendMessageAll("CreateInstance", {
			ClassName = self.ClassName,
			ID = self.ID,
			Data = self:SerializeData(),
		})
	else
		ServerService:SendMessageAll("UpdateProperty", {
			ID = self.ID,
			Prop = prop,
			Value = self[prop]
		})
	end    
    ]]

	return self
end

function module:ConnectedToServer()
    return not not (self.ServerPeer or self._connected)
end

function module:ConnectToServer(ip, port)
    if self:ConnectedToServer() then return end

    self.ServerIP = tostring(ip)
    self.ServerPort = tostring(port)

    self.ServerPeer = self.Host:connect(ip .. ":" .. port)
    return not not self.ServerPeer
end

function module:HostLocalServer()
    if self:ConnectedToServer() then return end
    local thread = love.thread.newThread("Server.lua")
    thread:start()
    
    local success = self:ConnectToServer("localhost", 6767)
    if success then
        self.LocalServer = thread
        return true
    end
    
    love.thread.getChannel("server_events"):push("shutdown")
    return false
end

function module:DisconnectFromServer()
    self._connected = false
    if self.ServerPeer then
        self.ServerPeer:disconnect()
        self.ServerPeer = nil
        self.Disconnected:Fire()
        print("Disconnect from server")
    end
    if self.LocalServer then
        love.thread.getChannel("server_events"):push("shutdown")
        self.LocalServer = nil
        print("Clean server thread")
    end
end

function module:SendMessage(name, value)
    if not self.ServerPeer then print("no server peer") return end
    
    task.spawn(function()
        if not (self.LocalID and self._connected) then repeat until (self.ServerPeer and self._connected) end
        self.ServerPeer:send(encode({
            type = "message",
            name = name,
            value = value
        }))
    end)
end

function module:Update()
    if not Engine:GetService("RunService"):IsClient() then return end
    if not self.ServerPeer then return end
    local event = self.Host:service(0)
    while event do
        if event.type == "receive" then
            local data = decode(event.data)

            self.MessageRecieved:Fire(data.type, data.value)
        elseif event.type == "connect" then
            self._connected = true

        elseif event.type == "disconnect" then
            self:DisconnectFromServer()
        end

        event = self.Host:service(0)
    end
end

return Instance.RegisterClass(module)