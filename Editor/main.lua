load("Editor", {
	Classes = {},
	Instances = {
		"Widget",
		
		"Explorer", "ExplorerObject",
		"Properties", "PropertyFrame",
	},
	Scenes = {},
})

require("Editor.Scenes.MainMenu"):Enable():Unpause()