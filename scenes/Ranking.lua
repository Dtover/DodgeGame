--local rankinglist = ranklist
function love.load()
	--for score in love.filesystem.lines("ranking.dat") do
		--table.insert(rankinglist, score)
	--end
	--table.sort(rankinglist, function(a, b) return tonumber(a) > tonumber(b) end)
	--local raw = ""
	--for i,v in pairs(rankinglist) do
		--raw = raw .. v .. "\n"
	--end
	--love.filesystem.write("ranking.dat", raw)
end

function love.draw()
	love.graphics.setColor(255, 255, 255)
	if #ranklist == 0 then
		love.graphics.print("NO GRADES YET !", 400, 200)
	end
	for i, score in pairs(ranklist) do
		if i > 10 then break end
		love.graphics.print(i..".  "..score, 200, i * 40 )
	end
end

function love.keypressed(key)
	if key == 'escape' then
		SwitchScene("Menu")
	end
end
