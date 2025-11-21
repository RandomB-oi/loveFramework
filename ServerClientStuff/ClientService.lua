local module = {}

module.new = function()
    local self = {}

    self.Disconnected = Signal.new()
    self.MessageRecieved = Signal.new()

    self:CreateProperty("ServerIP", "string", "")
    self:CreateProperty("ServerPort", "string", "")
    
    return self
end

function module:GetServer()
    
end

function module:ConnectToServer(ip, port)
    
end

function module:DisconnectFromServer()

end

function module:SendMessage(name, value)

end