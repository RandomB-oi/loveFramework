return function(chosenScene)
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

	do
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
		runIcon.Image = "Editor/Assets/Collapsed.png"
		runIcon.Size = UDim2.fromScale(1, 1)
		runIcon:SetParent(buttonBackdrop)

		newScene.BannerButtons.Run = runButton
	end


	local area = Instance.new("Frame")
	area.Position = UDim2.new(0, 0, 1, 0)
	area.AnchorPoint = Vector.new(0, 1)
	area.Size = UDim2.new(1, 0, 1, -bannerSize)
	area:SetParent(newScene)

	

	local explorer = Instance.new("Explorer", chosenScene)
	explorer.Position = UDim2.new(0, 0, 0, 0)
	explorer.AnchorPoint = Vector.zero
	explorer.Size = UDim2.new(.25, 0, 1, 0)
	explorer:SetParent(area)

	local properties = Instance.new("Properties")
	properties.Position = UDim2.new(1, 0, 0, 0)
	properties.AnchorPoint = Vector.new(1, 0)
	properties.Size = UDim2.new(.25, 0, 1, 0)
	properties:SetParent(area)

	local viewportWidget = Instance.new("Widget")
	viewportWidget.Position = UDim2.new(.5, 0, .5, 0)
	viewportWidget.AnchorPoint = Vector.new(.5, .5)
	viewportWidget.Size = UDim2.new(.5, 0, 1, 0)
	viewportWidget:SetParent(area)
	viewportWidget:SetTitle("Editor")

	local viewport = Instance.new("Frame")
	viewport.Size = UDim2.fromScale(1, 1)
	viewport.Position = UDim2.fromScale(0.5, 0.5)
	viewport.Color = Color.new(0,0,0, 1)
	viewport.AnchorPoint = Vector.one/2
	viewport.Name = "Viewport"
	viewportWidget:AttachGui(viewport)

	return newScene
end