return function()
	local newScene = Instance.new("Scene")
	newScene.Name = "EditorScene"
	newScene.Parent = EditorScene
	newScene.ZIndex = 10
	newScene.Size = UDim2.new(1, 0, 1, 0)
	newScene.Rotation = 0
	newScene.Position = UDim2.fromScale(0.5, 0.5)
	newScene.AnchorPoint = Vector.one/2

	local bannerSize = 24
	local banner = Instance.new("Frame")
	banner.Position = UDim2.new(0, 0, 0, 0)
	banner.AnchorPoint = Vector.zero
	banner.Size = UDim2.new(1, 0, 0, bannerSize)
	banner.Color = Color.from255(46, 46, 46, 255)
	banner.Parent = newScene

	local bannerList = Instance.new("UIListLayout")
	bannerList.Padding = UDim2.new(0, 0, 0, 0)
	bannerList.ListAxis = Vector.new(1, 0)
	bannerList.SortMode = Enum.SortMode.LayoutOrder
	bannerList.Parent = banner

	newScene.BannerButtons = {}

	local serial = 0
	local function newTopButton(image, text)
		serial = serial + 1
		local runButton = Instance.new("Button")
		runButton.LayoutOrder = serial
		runButton.Size = UDim2.new(0, bannerSize, 0, bannerSize)
		runButton.Color = Color.new(0, 0, 0, 0)
		runButton.Parent = banner

		local buttonBackdrop = Instance.new("Frame")
		buttonBackdrop.Size = UDim2.new(1,-4,1,-4)
		buttonBackdrop.AnchorPoint = Vector.one/2
		buttonBackdrop.Position = UDim2.new(0.5, 0, 0.5, 0)
		buttonBackdrop.Color = Color.new(0, 0, 0, .25)
		buttonBackdrop.Parent = runButton

		local runIcon = Instance.new("ImageLabel")
		runIcon.Image = image
		runIcon.Size = UDim2.fromScale(1, 1)
		Instance.new("UIAspectRatioConstraint").Parent = runIcon
		runIcon.Parent = buttonBackdrop
		runButton.Icon = runIcon

		if text then
			local label = Instance.new("TextLabel")
			label.Text = text
			label.AnchorPoint = Vector.new(0, 0.5)
			label.Size = UDim2.new(1,-bannerSize,1,4)
			label.Position = UDim2.new(0, bannerSize-2, .5, 0)
			label.Parent = buttonBackdrop
			runButton.Size = runButton.Size + UDim2.new(0, bannerSize * (text:len()*.5), 0, 0)
		end

		return runButton
	end

	do
		newScene.BannerButtons.ToggleFullscreen = newTopButton("Editor/Assets/Maximize.png", "Fullscreen")
		newScene.BannerButtons.Pause = newTopButton("Editor/Assets/Pause.png", "Pause")
		newScene.BannerButtons.Unpause = newTopButton("Editor/Assets/Unpause.png", "Unpause")
		newScene.BannerButtons.Unpause.Enabled = false
	end


	local area = Instance.new("Frame")
	area.Position = UDim2.new(0, 0, 1, 0)
	area.AnchorPoint = Vector.new(0, 1)
	area.Size = UDim2.new(1, 0, 1, -bannerSize)
	area.Parent = newScene

	local viewportWidget = Instance.new("Widget")
	viewportWidget.Position = UDim2.new(.5, 0, .5, 0)
	viewportWidget.AnchorPoint = Vector.new(.5, .5)
	viewportWidget.Size = UDim2.new(.5, 0, 1, 0)
	viewportWidget.Parent = area
	viewportWidget:SetTitle("Editor")

	local viewportHolder = Instance.new("Frame")
	viewportHolder.Size = UDim2.fromScale(1, 1)
	viewportHolder.Position = UDim2.fromScale(0.5, 0.5)
	viewportHolder.Color = Color.new(0,0,0, 1)
	viewportHolder.AnchorPoint = Vector.one/2
	viewportHolder.Name = "ViewportHolder"
	viewportWidget:AttachGui(viewportHolder)

	local viewport = Instance.new("Scene")
	-- viewport.Size = UDim2.fromScale(1, 1)
	-- viewport.Position = UDim2.fromScale(0.5, 0.5)
	-- viewport.Color = Color.new(0,0,0, 1)
	-- viewport.AnchorPoint = Vector.one/2
	viewport:Enable():Unpause()
	viewport.Name = "Viewport"
	viewport.Parent = viewportHolder
	newScene.Viewport = viewport

	local explorer = Instance.new("Explorer")
	explorer.Position = UDim2.new(0, 0, 0, 0)
	explorer.AnchorPoint = Vector.zero
	explorer.Size = UDim2.new(.25, 0, 1, 0)
	explorer.Parent = area

	local properties = Instance.new("Properties")
	properties.Position = UDim2.new(1, 0, 0, 0)
	properties.AnchorPoint = Vector.new(1, 0)
	properties.Size = UDim2.new(.25, 0, 1, 0)
	properties.Parent = area

	newScene.BannerButtons.ToggleFullscreen.LeftClicked:Connect(function()
		local fullscreen = explorer.Enabled

		explorer.Enabled = not fullscreen
		properties.Enabled = not fullscreen
		newScene.BannerButtons.ToggleFullscreen.Icon.Image = fullscreen and "Editor/Assets/Minimize.png" or "Editor/Assets/Maximize.png"
		if fullscreen then
			viewportWidget.Size = UDim2.new(1, 0, 1, 0)
		else
			viewportWidget.Size = UDim2.new(.5, 0, 1, 0)
		end
	end)

	return newScene
end