local accessfile = {}
function accessfile.writeStorage(table, filename)
	local raw_data = ""
	for k, v in pairs(table) do
		raw_data = raw_data .. k .. "," .. v .. "\n"
	end
	love.filesystem.write(filename, raw_data)
end

-- read data from storage
function accessfile.readStorage(filename)
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
function accessfile.insertRanklist(filename, score, date)
	if love.filesystem.getInfo(filename) then
		local raw = ""
		local ranklist_temp = {}
		for line in love.filesystem.lines(filename) do
			table.insert(ranklist_temp, line)
		end
		if score then
			table.insert(ranklist_temp, score.."   "..date)
		end
		table.sort(ranklist_temp, function(a, b)
			x = string.split(a, " ")
			y = string.split(b, " ")
			return tonumber(x[1]) > tonumber(y[1])
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
			file:write(score.." "..date)
		end
		file:close()
	end
end

function accessfile.insertRanklist_encrypted(filename, score, date)
	raw = ""
	rtable = {}
	if love.filesystem.getInfo(filename) then
		for line in love.filesystem.lines(filename) do
			raw = raw .. line
		end
		r = love.data.decode("string", "base64", raw)
		rtable = string.split(r, ";")
		if score then
			rtable[#rtable + 1] = score.. " " .. date
		end
		table.sort(rtable, function(a, b)
			x = string.split(a, " ")
			y = string.split(b, " ")
			return tonumber(x[1]) > tonumber(y[1])
		end)
		ranklist = rtable
		nraw = ""
		for i = 1, math.min(#rtable, 10) do
			nraw = nraw .. rtable[i] .. ";"
		end
		love.filesystem.write(filename, love.data.encode("string", "base64", nraw))
	else
		file = love.filesystem.newFile(filename)
		file:open('w')
		if score then
			raw = love.data.encode("data", "base64", score.." "..date..";")
			file:write(raw)
		end
		file:close()
	end
end

return accessfile
