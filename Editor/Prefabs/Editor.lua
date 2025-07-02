return function(chosenScene)
	local newScene = Instance.new("Scene")
	newScene.Name = "Widgets"
	newScene:SetParent(EditorScene)

	newScene.ZIndex = 10

	local widget = Instance.new("Explorer", chosenScene)
	widget.Position = UDim2.new(0, 0, 0, 0)
	widget.AnchorPoint = Vector.zero
	widget.Size = UDim2.new(.25, 0, 1, 0)
	widget:SetParent(newScene)

	local widget = Instance.new("Properties")
	widget.Position = UDim2.new(1, 0, 0, 0)
	widget.AnchorPoint = Vector.new(1, 0)
	widget.Size = UDim2.new(.25, 0, 1, 0)
	widget:SetParent(newScene)

	local viewportWidget = Instance.new("Widget")
	viewportWidget.Position = UDim2.new(.5, 0, .5, 0)
	viewportWidget.AnchorPoint = Vector.new(.5, .5)
	viewportWidget.Size = UDim2.new(.5, 0, 1, 0)
	viewportWidget:SetParent(newScene)
	viewportWidget:SetTitle("Editor")

	
	local viewport = Instance.new("Frame")
	viewport.Size = UDim2.fromScale(1, 1)
	viewport.Position = UDim2.fromScale(0.5, 0.5)
	viewport.Color = Color.new(0,0,0, 1)
	viewport.AnchorPoint = Vector.one/2
	viewport.Name = "Viewport"
	-- viewport:Pause()

	viewportWidget:AttachGui(viewport)

	return newScene
end