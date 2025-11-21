local module = {}


module.new = function()
    local self = {}

    self.Clients = {}
    self.ClientConnected = self.Maid:Add(Signal.new())
    self.ClientDisconnected = self.Maid:Add(Signal.new())
    self.MessageRecieved = self.Maid:Add(Signal.new())

    self:CreateProperty("PlayerClass", "string", "Folder")
    
    return self
end

function module:SendMessage(clientID, name, value)

end

function module:SendMessageAll(name, value)
    for clientID in pairs(self:GetConnectedClients()) do
        self:SendMessage(clientID, name, value)
    end
end

function module:GetConnectedClients()
    local list = {}
    for clientID, frame in pairs(self.Clients) do
        list[clientID] = frame
    end
    return list
end

function module:DisconnectClient(clientID, code, message)
    
end

function module:Replicate(object, info)
    --[[
    info - {
        [1] = mode [1: instance new, 2: instance changed]
        [2] = mode1: {className, id}, mode2: serializedProperties
    }
    ]]
end