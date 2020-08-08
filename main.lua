-- default value
currentFontSize = 20
Fontlist = {}
setup_table = {
	player_speed = 2,
	bullet_speed = 2,
	bullet_density = 2,
	bullet_style = 11,
	lang = "English"
}
ranklist = {}
lang = "Chinese"

-- pass the score value from 'StartGame' to 'GameOver'
lastscore = 0

require("accessfile")
writeStorage = accessfile.writeStorage
readStorage = accessfile.readStorage
insertRanklist = accessfile.insertRanklist
insertRanklist_encrypted = accessfile.insertRanklist_encrypted

require("draw")
drawTitle = draw.drawTitle
drawButton = draw.drawButton
drawSlider = draw.drawSlider

require("checkbox")
lglist = require("languages")

-- Switch Scene
function SwitchScene(scene)
	love.load = nil
	love.update = nil
	love.draw = nil
	love.keypressed = nil
	love.mousepressed = nil
	love.filesystem.load("scenes/"..scene..".lua")()
	love.load()
end

-- split method
function string.split(str,keyword)
	local tab={}
	local index=1
	local from=1
	local to=1
	while true do
		if string.sub(str,index,index)==keyword then
			to=index-1
			if from>to then 
				table.insert(tab, "")
			else
				table.insert(tab, string.sub(str,from,to))
			end
			from=index+1
		end
		index=index+1
		if index>string.len(str) then
			if from<=string.len(str) then
				table.insert(tab, string.sub(str,from,string.len(str)))
			end
			return tab
		end
	end
end

-- Set font
function SetFont(size)
	if currentFontSize ~= size then
		if Fontlist[size] then
			love.graphics.setFont(Fontlist[size].font)
		else
			font = love.graphics.newFont("resources/fonts/font.ttf", size)
			love.graphics.setFont(font)
			Fontlist[size] = {
				font = font,
				height = font:getHeight("H")
			}
		end
		currentFontSize = size
	end
	return Fontlist[size].height
end

-- Button click
function isclick(button, mx, my)
	if mx > button.x and mx < button.x + button.w and
	   my > button.y and my < button.y + button.h then
		return true
	else
		return false
	end
end

function love.load()
	setup_table = readStorage("setup.dat")
	lang = setup_table.lang
	--insertRanklist("ranking.dat", nil, nil)
	insertRanklist_encrypted("ranking.dat", nil, nil)
	SwitchScene("Menu")
end
