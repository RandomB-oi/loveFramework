local Run = Engine:GetService("RunService")

local OutputScene = Instance.new("Scene")
OutputScene.ZIndex = 10
OutputScene.Enabled = false
OutputScene.Hidden = true
OutputScene.Parent = Engine

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, -12, 1, -12)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector.new(0.5, 0.5)
frame.Color = Color.from255(0, 0, 0, 100)
frame.Parent = OutputScene

local list = Instance.new("ScrollingFrame")
list.Parent = frame
list.Size = UDim2.new(1, 0, 1, -25)
list.Position = UDim2.fromScale(0.5, 1)
list.AnchorPoint = Vector.new(0.5, 1)
list.Color = Color.from255(0, 0, 0, 0)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim2.fromOffset(1, 1)
layout.ListAxis = Vector.yAxis
layout.Parent = list

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function(size)
	list.CanvasSize = UDim2.fromOffset(0, size.Y)
end)

local clearOutput = Instance.new("Button")
clearOutput.Parent = frame
clearOutput.Size = UDim2.fromOffset(50, 25)
clearOutput.Position = UDim2.fromScale(1, 0)
clearOutput.AnchorPoint = Vector.new(1, 0)
clearOutput.Color = Color.from255(255, 0, 0)

local clearTextLabel = Instance.new("TextLabel")
clearTextLabel.Parent = clearOutput
clearTextLabel.Size = UDim2.new(1, -4, 1, -4)
clearTextLabel.Position = UDim2.fromScale(0.5, 0.5)
clearTextLabel.AnchorPoint = Vector.new(0.5, 0.5)
clearTextLabel.Text = "Clear"

local colors = {
	e = Color.from255(255, 25, 25),
	w = Color.from255(255, 170, 0),
	p = Color.from255(220, 220, 220),
	unknown = Color.from255(100, 100, 100),
}

local outputMessages = {}
local originalFunctions = {print = print, warn = warn, error = error,}

local function cleanArgs(...)
	local args = {...}
	for i, v in pairs(args) do
		if type(v) ~= "string" then
			args[i] = tostring(v)
		end
	end
	return unpack(args)
end

local function resetOutput()
	local a = outputMessages
	outputMessages = {}
	for _,label in ipairs(a) do
		label:Destroy()
	end
end

function SendOutputMessage(color, ...)
	local newStr = table.concat({cleanArgs(...)}, " ")
	if newStr == "" then return end

	local messages = string.split(newStr, "\n")

	if #messages > 1 then
		for i,v in ipairs(messages) do
			SendOutputMessage(color, v)
		end
		return
	end
    
	local newLabel = Instance.new("TextLabel")
	newLabel.Size = UDim2.new(1, 0, 0, 24)
	newLabel.XAlignment = Enum.XAlignment.Left
	newLabel.Text = newStr
	newLabel.LayoutOrder = #outputMessages
	newLabel.Parent = list
	table.insert(outputMessages, newLabel)
end


function print(...)
	SendOutputMessage(colors.p, ...)
	originalFunctions.print(...)
end
function warn(...)
	SendOutputMessage(colors.w, ...)
	originalFunctions.warn(...)
end
function error(...)
	local traceback = debug.traceback()
	SendOutputMessage(colors.e, traceback, ...)
	originalFunctions.error(...)
end

clearOutput.LeftClicked:Connect(resetOutput)
Engine:GetService("InputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F9 or input.KeyCode == Enum.KeyCode.F1 then
		OutputScene.Enabled = not OutputScene.Enabled
	end
end)

-- OutputScene.Maid:GiveTask(OutputMessage:Connect(function(outputType, ...)
-- 	local newStr = table.concat({...}, " ")
-- 	if newStr == "" then return end

-- 	local textColor
-- 	if outputType == "e" then
-- 		textColor = Color.from255(255, 25, 25)
-- 	elseif outputType == "w" then
-- 		textColor = Color.from255(255, 170, 0)
-- 	elseif outputType == "p" then
-- 		textColor = Color.from255(220, 220, 220)
-- 	else
-- 		textColor = Color.from255(100, 100, 100)
-- 	end
-- 	outputSerial = outputSerial + 1
-- 	if outputSerial > maxOutputMessages then
-- 		resetOutput()
-- 		outputSerial = 1
-- 	end
-- 	local messages = string.split(newStr, "\n")

-- 	if #messages > 1 then
-- 		for i,v in ipairs(messages) do
-- 			outputMessage:Fire(outputType, v)
-- 		end
-- 		return
-- 	end
	
-- 	local label = outputMessages[outputSerial]
-- 	label:SetText(newStr)
-- 	label.Color = textColor
-- end))