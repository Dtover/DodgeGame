function love.load()
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
		drawTitle("center",{
			x = 50,
			y = 50,
			size = 40,
			text = "Ranking List",
			color = {1, 1, 1}
		})
		love.graphics.setColor(1, 1, 1)
		SetFont(26)
		for i, score in pairs(ranklist) do
			s = string.split(score, " ")
			if i <= 10 then
				love.graphics.print(string.format("%02d.  %.3f    %s", i, tonumber(s[1]), s[2]..s[3]),
									440, 120 + i * 45)
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
