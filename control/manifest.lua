{
	files = {
		"src/async.lua",
		"src/dest.lua",
		"src/switcher.lua"
	},
	setups = {
		switcher = {
			exe = {
				"src/switcher.lua"
			},
			files = {
				"src/async.lua",
				"src/switcher.lua"
			}
		},
		pass = {
			files = {
				"src/async.lua",
				"src/dest.lua"
			}
		}
	}
}
