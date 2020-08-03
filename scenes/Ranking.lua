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
	if #ranklist == 0 then
		--love.graphics.print("NO GRADES YET !", 400, 200)
		drawTitle("center", {
			y = 300,
			size = 40,
			text = "NO GRADES YET !",
			color = {1, 1, 1}
		})
	else
		love.graphics.setBackgroundColor(0, 0, 0)
		drawTitle("left",{
			x = 50,
			y = 50,
			size = 40,
			text = "Ranking List :",
			color = {1, 1, 1}
		})
		love.graphics.setColor(1, 1, 1)
		SetFont(26)
		for i, score in pairs(ranklist) do
			if i < 10 then
				love.graphics.print("0"..i..".  \t"..score, 350, 50 + i * 45 )
			elseif i == 10 then
				love.graphics.print(i..".  \t"..score, 350, 50 + i * 45 )
			else
				break
			end

		end
	end
end

function love.keypressed(key)
	if key == 'escape' then
		SwitchScene("Menu")
	end
end
