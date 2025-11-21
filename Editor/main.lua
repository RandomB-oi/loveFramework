EditorScene = Instance.new("Scene")
EditorScene:SetParent(Engine)

autoLoad("Editor", {"Editor.main"})

function EditorScene:Open(scene)
	local newEditor = require("Editor.Prefabs.Editor")()

	local explorer = newEditor:FindFirstChild("Explorer", true)
	explorer.RootObject = scene

	newEditor.BannerButtons.Run.LeftClicked:Connect(function()
		explorer.RootObject = Engine:GetService("RunService"):Run()
		
		newEditor.BannerButtons.Stop.Enabled = true
		newEditor.BannerButtons.Run.Enabled = false
	end)

	newEditor.BannerButtons.Stop.LeftClicked:Connect(function()
		explorer.RootObject = Engine:GetService("RunService"):Stop()
		
		newEditor.BannerButtons.Stop.Enabled = false
		newEditor.BannerButtons.Run.Enabled = true
	end)

	scene:SetParent(newEditor.Viewport)

	return newEditor
end

local existingDropdown
local function CreateDropdown(options, selected)
	if existingDropdown then
		existingDropdown:Destroy()
		existingDropdown = nil
	end

	local dropdown = Instance.new("Dropdown", options)
	local mousePos = Engine:GetService("InputService"):GetMouseLocation()
	dropdown.Position = UDim2.fromOffset(mousePos.X, mousePos.Y)
	dropdown.AnchorPoint = Vector.zero
	dropdown:SetParent(EditorScene)
	existingDropdown = dropdown
	
	dropdown.ValueSelected:Connect(function(...)
		if selected(...) then
			dropdown:Destroy()
		end
	end)

	return dropdown
end

function EditorScene:CreateContextMenu(object)
	local dropdown = CreateDropdown({"Insert", "Export", "Duplicate", "Delete"}, function(value)
		if value == "Insert" then
			local classList = {}
			for className in pairs(Instance.Classes) do
				table.insert(classList, className)
			end

			CreateDropdown(classList, function(className)
				Instance.new(className):SetParent(object)
				return true
			end)
			return true
		elseif value == "Export" then
			local pathName = object:GetFullName():gsub("%.", "_")
			Instance.CreatePrefab(object, "ExportedInstances/"..pathName..".lua")
			return true
		elseif value == "Duplicate" then
			local new = object:Clone(true)
			new.Name = new.Name
			new:SetParent(object.Parent)
			return true
		elseif value == "Delete" then
			object:Destroy()
			return true
		end
	end)
end

return EditorScene