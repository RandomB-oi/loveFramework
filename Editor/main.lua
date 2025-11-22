EditorScene = Instance.new("Scene")
EditorScene.Parent = Engine
EditorScene.Replicates = false

autoLoad("Editor", {"Editor.main"})

function EditorScene:Open(scene)
	local newEditor = require("Editor.Prefabs.Editor")()

	local explorer = newEditor:FindFirstChild("Explorer", true)
	-- explorer.RootObject = scene
	
	explorer.RootObject = Engine

	newEditor.Viewport.Paused = true
	newEditor.BannerButtons.Pause.Enabled = false
	newEditor.BannerButtons.Unpause.Enabled = true

	newEditor.BannerButtons.Pause.LeftClicked:Connect(function()
		newEditor.Viewport.Paused = true
		
		newEditor.BannerButtons.Pause.Enabled = false
		newEditor.BannerButtons.Unpause.Enabled = true
	end)

	newEditor.BannerButtons.Unpause.LeftClicked:Connect(function()
		newEditor.Viewport.Paused = false
		
		newEditor.BannerButtons.Pause.Enabled = true
		newEditor.BannerButtons.Unpause.Enabled = false
	end)

	scene.Parent = newEditor.Viewport

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
	dropdown.Parent = EditorScene
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
				Instance.new(className).Parent = object
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
			new.Parent = object.Parent
			return true
		elseif value == "Delete" then
			object:Destroy()
			return true
		end
	end)
end

return EditorScene