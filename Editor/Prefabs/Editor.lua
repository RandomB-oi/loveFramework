return function()
	local newScene = Instance.new("Scene")
	newScene.Name = "EditorScene"
	newScene:SetParent(EditorScene)
	newScene.ZIndex = 10

	local bannerSize = 100
	local banner = Instance.new("Frame")
	banner.Position = UDim2.new(0, 0, 0, 0)
	banner.AnchorPoint = Vector.zero
	banner.Size = UDim2.new(1, 0, 0, bannerSize)
	banner.Color = Color.from255(46, 46, 46, 255)
	banner:SetParent(newScene)

	local list = Instance.new("UIListLayout")
	list.Padding = UDim2.new(0, 6, 0, 6)
	list.ListAxis = Vector.new(1, 0)
	list.SortMode = Enum.SortMode.Name
	list:SetParent(banner)

	newScene.BannerButtons = {}

	local function newTopButton(image)
		local runButton = Instance.new("Button")
		runButton.Size = UDim2.new(0, bannerSize, 0, bannerSize)
		runButton.Color = Color.new(0, 0, 0, 0)
		runButton:SetParent(banner)

		local buttonBackdrop = Instance.new("Frame")
		buttonBackdrop.Size = UDim2.new(1,-12,1,-12)
		buttonBackdrop.AnchorPoint = Vector.one/2
		buttonBackdrop.Position = UDim2.new(0.5, 0, 0.5, 0)
		buttonBackdrop.Color = Color.new(0, 0, 0, .25)
		buttonBackdrop:SetParent(runButton)

		local runIcon = Instance.new("ImageLabel")
		runIcon.Image = image
		runIcon.Size = UDim2.fromScale(1, 1)
		runIcon:SetParent(buttonBackdrop)

		return runButton
	end

	do
		newScene.BannerButtons.Run = newTopButton("Editor/Assets/Collapsed.png")
		newScene.BannerButtons.Stop = newTopButton("Editor/Assets/Expanded.png")
		newScene.BannerButtons.Stop.Enabled = false
	end


	local area = Instance.new("Frame")
	area.Position = UDim2.new(0, 0, 1, 0)
	area.AnchorPoint = Vector.new(0, 1)
	area.Size = UDim2.new(1, 0, 1, -bannerSize)
	area:SetParent(newScene)

	local viewportWidget = Instance.new("Widget")
	viewportWidget.Position = UDim2.new(.5, 0, .5, 0)
	viewportWidget.AnchorPoint = Vector.new(.5, .5)
	viewportWidget.Size = UDim2.new(.5, 0, 1, 0)
	viewportWidget:SetParent(area)
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
	viewport:SetParent(viewportHolder)

	local explorer = Instance.new("Explorer")
	explorer.Position = UDim2.new(0, 0, 0, 0)
	explorer.AnchorPoint = Vector.zero
	explorer.Size = UDim2.new(.25, 0, 1, 0)
	explorer:SetParent(area)

	local properties = Instance.new("Properties")
	properties.Position = UDim2.new(1, 0, 0, 0)
	properties.AnchorPoint = Vector.new(1, 0)
	properties.Size = UDim2.new(.25, 0, 1, 0)
	properties:SetParent(area)

	return newScene
end