local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "ClientService"

local enet = require("enet")

local ServerInstances = {}

local function ClearInstances()
    local old = ServerInstances
    ServerInstances = {}
    for i,v in pairs(old) do
        v:Destroy()
    end
end

module.new = function ()
	local self = setmetatable(module.Base.new(module.__type), module._metatable)
	self.Name = self.__type

    self.Connected = Signal.new()
    self.Disconnected = Signal.new()
    self.MessageRecieved = Signal.new()

    self:CreateProperty("ServerIP", "string", "")
    self:CreateProperty("ServerPort", "string", "")
    self:CreateProperty("LocalID", "string", "")
    self.Hidden = false

    self.ServerPeer = nil
    self.LocalServer = nil


    self.Disconnected:Connect(ClearInstances)
    self.MessageRecieved:Connect(function(message, data)
        if message == "CreateInstance" then
            local data = Serializer.Decode(data)
            local object = self:GetInstance(data.ID, data.ClassName)
            object:DeserializeData(data)
        elseif message == "UpdateProperty" then
            local object = self:GetInstance(data.ID)
            if object then
                object[data.Prop] = Serializer.Decode(data.Value)
            end
        elseif message == "RemoveInstance" then
            local object = self:GetInstance(data.ID)
            if object then
                object:Destroy()
            end
        elseif message == "RemoteEvent" then
            local remote = Instance.GetClass("BaseInstance").All[data.ID]
            if remote then
                remote:_addEvent(data.Data)
            else
                Instance.GetClass("RemoteEvent")._addEvent(data.ID, data.Data)
            end
        elseif message == "Batch" then
            for _, command in pairs(data) do
                self.MessageRecieved:Fire(command.name, command.data)
            end
        elseif message == "connect" then
            self.LocalID = data.id
            self:SendMessage("connected")
        end
    end)

	return self
end

function module:GetInstance(id, className)
    local existing = Instance.GetClass("BaseInstance").All[id]
    if existing then return existing end

    if className then
        local new = Instance.new(className, id)
        ServerInstances[id] = new
        new.Maid:GiveTask(function()
            ServerInstances[id] = nil
        end)
        return new
    end
end

function module:ConnectedToServer()
    return not not (self.Host and self.ServerPeer or self._connected)
end

function module:ConnectToServer(ip, port)
    if self:ConnectedToServer() then return end
    self:DisconnectFromServer()

    self.ServerIP = tostring(ip)
    self.ServerPort = tostring(port)

    self.Host = enet.host_create()
    self.ServerPeer = self.Host:connect(ip .. ":" .. port)
    if self.ServerPeer then
        self.Connected:Fire()
        return true
    end
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
    if self.Host then
        self.Host:destroy()
        self.Host = nil
        print("clean host")
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
        local encodingService = Engine:GetService("EncodingService")
        local success, data = encodingService:Encode({
            type = "message",
            name = name,
            data = value
        }, encodingService.ReplicationEncodingMethod)

        if success then
            self.ServerPeer:send(data)
        end
    end)
end

function module:Update()
    if not Engine:GetService("RunService"):IsClient() then return end
    if not (self.ServerPeer and self.Host) then return end
    local event = self.Host:service(0)
    local encodingService = Engine:GetService("EncodingService")

    while event do
        if event.type == "receive" then
            local success,  data = encodingService:Decode(event.data, encodingService.ReplicationEncodingMethod)

            if success then
                self.MessageRecieved:Fire(data.name, data.data)
            end
        elseif event.type == "connect" then
            self._connected = true

        elseif event.type == "disconnect" then
            self:DisconnectFromServer()
        end

        event = self.Host:service(0)
    end
end

return Instance.RegisterClass(module)