-- default config
currentFontSize = 20
font = love.graphics.newFont("sources/font.ttf", currentFontSizesize)
-- pass the score value from 'StartGame' scene to 'GameOver' scene
lastscore = 0

-- Switch Scene
function SwitchScene(scene)
	love.load = nil
	love.update = nil
	love.draw = nil
	love.keypressed = nil
	love.filesystem.load("scenes/"..scene..".lua")()
	love.load()
end

-- Set font
function SetFont(size)
	if size ~= currentFontSize then
		font = love.graphics.newFont("sources/font.ttf", size)
		love.graphics.setFont(font)
		currentFontSize = size
	end
end

-- Button click
function isclick(button, mx, my)
	if mx > button.x and mx < button.x + button.w and
	   my > button.y and my < button.y + button.h and
	   button.flag then
		return true
	else
		return false
	end
end

SwitchScene("Menu")
