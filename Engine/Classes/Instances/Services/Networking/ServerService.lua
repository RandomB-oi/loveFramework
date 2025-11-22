local module = {}
module.Derives = "BaseService"
module.__index = module
module.__type = "ServerService"

local enet = require("enet")
local ConnectedClient = require("Engine.Classes.Instances.Services.Networking.ConnectedClient")

local function encode(tbl)
    return json.encode(tbl)
end

local function decode(str)
    return json.decode(str)
end

module.new = function ()
	local self = setmetatable(module.Base.new(), module._metatable)
	self.Name = self.__type

    self.Clients = {}
    self.Host = nil

    self.ClientConnected = self.Maid:Add(Signal.new())
    self.ClientDisconnected = self.Maid:Add(Signal.new())
    self.MessageRecieved = self.Maid:Add(Signal.new())

    self:CreateProperty("PlayerClass", "string", "Folder")

    self.MessageRecieved:Connect(print)

	return self
end

function module:GetClientIDFromPeer(peer)
    for id, p in pairs(self.Clients) do
        if p.Peer == peer then
            return id
        end
    end
end

function module:StartServer(port)
    self.Host = enet.host_create("*:" .. tostring(port))
    print("Server hosted on port", port)

    local BaseInstance = Instance.GetClass("BaseInstance")
    BaseInstance.ReplicateInstances()

    local function newInstance(id, object)
        object.Changed:Connect(function(prop)
            if not object.Replicates then return end

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

    client.Peer:send(encode({
        type = name,
        value = value
    }))
end

function module:SendMessageAll(name, value)
    for clientID in pairs(self.Clients) do
        self:SendMessage(clientID, name, value)
    end
end

function module:DisconnectClient(clientID, code)
    local client = self.Clients[clientID]
    client.DisconnectCode = code
    client:Destroy()
end

function module:AddClient(peer)
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
    Instance.GetClass("BaseInstance").ReplicateInstances(clientID)

    self.ClientConnected:Fire(clientID)
end

function module:Update()
    if not Engine:GetService("RunService"):IsServer() then return end
    if not self.Enabled then return end
    if not self.Host then return end

    local event = self.Host:service(0)
    while event do
        if event.type == "connect" then
            self:AddClient(event.peer)
        elseif event.type == "receive" then
            local data = decode(event.data)
            if data and data.type == "message" then
                -- find which client this is
                local clientID = self:GetClientIDFromPeer(event.peer)
                if clientID then    
                    self.MessageRecieved:Fire(clientID, data.name, data.value)
                end
            end

        elseif event.type == "disconnect" then
            local clientID = self:GetClientIDFromPeer(event.peer)
            if clientID then
                self:DisconnectClient(clientID)
            end
        end

        event = self.Host:service(0)
    end
end

function module:Replicate(object, info)
    --[[
    info - {
        [1] = mode [1: instance new, 2: instance changed]
        [2] = mode1: {className, id}, mode2: serializedProperties
    }
    ]]
end

return Instance.RegisterClass(module)