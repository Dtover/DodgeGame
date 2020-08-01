local rankinglist = {}
function love.load()
	for score in love.filesystem.lines("Ranking.txt") do
		table.insert(rankinglist, score)
	end
	table.sort(rankinglist, function(a, b) return tonumber(a) > tonumber(b) end)
end

function love.draw()
	love.graphics.setColor(255, 255, 255)
	for i, score in pairs(rankinglist) do
		if i > 10 then break end
		love.graphics.print(i.." : "..score, 200, i * 40 )
	end
end

function love.keypressed(key)
	if key == 'escape' then
		SwitchScene("Menu")
	end
end
