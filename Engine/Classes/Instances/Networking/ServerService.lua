local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "ServerService"

local enet = require("enet")
local ConnectedClient = require("Engine.Classes.Instances.Networking.ConnectedClient")

local MessageRate = 1/20
local lastMessageSend = -math.huge


local function GetClientIDFromPeer(self, peer)
    for id, p in pairs(self.Clients) do
        if p.Peer == peer then
            return id
        end
    end
end

local function AddClient(self, peer)
    local newClient = ConnectedClient.new(peer)
    local clientID = newClient.ID
    self.Clients[clientID] = newClient

    newClient.Maid:GiveTask(function()
        self.Clients[clientID] = nil
        local exitCode = newClient.DisconnectCode or 0

        newClient.Peer:disconnect_later(exitCode)
        self.ClientDisconnected:Fire(clientID, exitCode)
    end)

    self:SendMessage(clientID, "connect", {
        id = clientID,
    })

    self.ClientConnected:Fire(clientID)
end

module.new = function ()
	local self = setmetatable(module.Base.new(module.__type), module._metatable)
	self.Name = self.__type
    self.Replicates = true
    self.Hidden = false
    self.Clients = {}
    self.Host = nil

    self.ClientConnected = self.Maid:Add(Signal.new())
    self.ClientDisconnected = self.Maid:Add(Signal.new())
    self.MessageRecieved = self.Maid:Add(Signal.new())

    self:CreateProperty("PlayerClass", "string", "Folder")
    self:CreateProperty("PlayerObjectParent", "Instance", nil)
    -- self:CreateProperty("ServerTime", "number", 0)

    -- Engine:GetService("RunService"):GetPropertyChangedSignal("ElapsedTime"):Connect(function(value)
    --     self.ServerTime = value
    -- end)

    -- self.ClientConnected:Connect(Instance.GetClass("BaseInstance").ReplicateInstances)
    self.ClientConnected:Connect(function(clientID)
        GameScene:Replicate(nil, clientID)
        for _, service in ipairs(Engine:GetServices()) do
            service:Replicate(nil, clientID)
        end
    end)

    -- self.MessageRecieved:Connect(print)
    self.MessageRecieved:Connect(function(clientID, message, data)
        if message == "Batch" then
            for _, command in pairs(data) do
                self.MessageRecieved:Fire(clientID, command.name, command.data)
            end
        elseif message == "RemoteEvent" then
            local remote = Instance.GetClass("BaseInstance").All[data.ID]
            if remote then
                remote:_addEvent({clientID, unpack(data.Data)})
            end
        end
    end)

	return self
end

function module:StartServer(port)
    self.Host = enet.host_create("*:" .. tostring(port))
    print("Server hosted on port", port)

    local BaseInstance = Instance.GetClass("BaseInstance")
    -- BaseInstance.ReplicateInstances()

    local function newInstance(id, object)
        object.Changed:Connect(function(prop)
            object:Replicate(prop)
        end)
    end

    BaseInstance.InstanceCreated:Connect(newInstance)
    for id, instance in pairs(BaseInstance.All) do
        newInstance(id, instance)
    end
end

function module:SendMessage(clientID, name, value)
    local client = self.Clients[clientID]
    if not client then return end

    client:SendMessage(name, value)
end

function module:SendMessageAll(name, value)
    for clientID in pairs(self.Clients) do
        self:SendMessage(clientID, name, value)
    end
end

function module:GetPlayerObject(clientID)
    local client = self.Clients[clientID]
    return client and client.Instance
end

function module:DisconnectClient(clientID, code)
    local client = self.Clients[clientID]
    client.DisconnectCode = code
    client:Destroy()
end

function module:Update()
    if not Engine:GetService("RunService"):IsServer() then return end
    if not self.Enabled then return end
    if not self.Host then return end

    local encodingService = Engine:GetService("EncodingService")

    if os.clock() - lastMessageSend > MessageRate then
        lastMessageSend = os.clock()
        for _, client in pairs(self.Clients) do
            client:BatchSend()
        end
    end

    local event = self.Host:service(0)
    while event do
        if event.type == "connect" then
            AddClient(self, event.peer)
        elseif event.type == "receive" then
            local success, data = encodingService:Decode(event.data, encodingService.ReplicationEncodingMethod)
            if success and data then
                local clientID = GetClientIDFromPeer(self, event.peer)
                if clientID then    
                    self.MessageRecieved:Fire(clientID, data.name, data.data)
                end
            end

        elseif event.type == "disconnect" then
            local clientID = GetClientIDFromPeer(self, event.peer)
            if clientID then
                self:DisconnectClient(clientID)
            end
        end

        event = self.Host:service(0)
    end
end

return Instance.RegisterClass(module)