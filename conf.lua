GameVersion = "Dodge v0.1.0"
local love = require("love")
-- Configure
function love.conf(t)
	t.title = "EscapeGame"
	t.version = "11.3"
	t.author = "Dreamlocker"
	t.window.width = "1280"
	t.window.height = "720"
	t.window.minwidth = "640"
	t.window.minwidth = "360"
	t.console = true
end
