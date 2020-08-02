-- default value
currentFontSize = 20
font = love.graphics.newFont("sources/font.ttf", currentFontSizesize)
setup_table = {
	player_speed = 2,
	bullet_speed = 2,
	bullet_density = 2,
}
-- write data to storage
function writeStorage(table)
	local raw_data = ""
	for k, v in pairs(table) do
		raw_data = raw_data .. k .. "," .. v .. "\n"
	end
	love.filesystem.write("setup.dat", raw_data)
end

-- read data from storage
function readStorage()
	local stable = {}
	if love.filesystem.getInfo("setup.dat") then
		for line in love.filesystem.lines("setup.dat") do
			k_v = string.split(line, ",")
			stable[k_v[1]] = k_v[2]
		end
	else
		writeStorage(setup_table)
	end
	return stable
end

-- pass the score value from 'StartGame' to 'GameOver'
lastscore = 0

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

function love.load()
	setup_table = readStorage()
	SwitchScene("Menu")
end
