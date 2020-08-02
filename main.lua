-- default value
currentFontSize = 20
font = love.graphics.newFont("sources/font.ttf", currentFontSizesize)
setup_table = {
	player_speed = 2,
	bullet_speed = 2,
	bullet_density = 2,
}
ranklist = {}

-- pass the score value from 'StartGame' to 'GameOver'
lastscore = 0

-- write data to storage
function writeStorage(table, filename)
	local raw_data = ""
	for k, v in pairs(table) do
		raw_data = raw_data .. k .. "," .. v .. "\n"
	end
	love.filesystem.write(filename, raw_data)
end

-- read data from storage
function readStorage(filename)
	local stable = {}
	if love.filesystem.getInfo(filename) then
		for line in love.filesystem.lines(filename) do
			k_v = string.split(line, ",")
			stable[k_v[1]] = k_v[2]
		end
	else
		writeStorage(setup_table, filename)
	end
	return stable
end

-- insert score into ranklist
function insertRanklist(filename, score, date)
	if love.filesystem.getInfo(filename) then
		local raw = ""
		local ranklist_temp = {}
		for line in love.filesystem.lines(filename) do
			table.insert(ranklist_temp, line)
		end
		if score then
			table.insert(ranklist_temp, score.."s   "..date)
		end
		table.sort(ranklist_temp, function(a, b)
			x = string.split(a, " ")
			y = string.split(b, " ")
			return tostring(x[1]) > tostring(y[1])
		end)
		ranklist = ranklist_temp
		for i, score in pairs(ranklist_temp) do
			raw = raw .. score .. "\n"
		end
		love.filesystem.write(filename, raw)
	else
		file = love.filesystem.newFile(filename)
		file:open('w')
		if score then
			file:write(score.."s "..date)
		end
		file:close()
	end
end


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
	setup_table = readStorage("setup.dat")
	insertRanklist("ranking.dat", nil, nil)
	SwitchScene("Menu")
end
