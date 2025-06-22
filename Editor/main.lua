load("Editor", {
	Classes = {},
	Instances = {
		"Widget", "Explorer", "ExplorerObject"
	},
	Scenes = {},
})

require("Editor.Scenes.MainMenu"):Enable():Unpause()