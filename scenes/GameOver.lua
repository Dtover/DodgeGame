--local score = 0
local file = nil

function love.load()
	--score = lastscore
	--success, error = love.filesystem.append("ranking.dat", lastscore.."\n")
	insertRanklist_encrypted("ranking.dat", lastscore,os.date('%H:%M:%S %Y/%m/%d'))
	if success == false then
		love.event.quit()
	end
end

function love.keypressed(key)
	if key == 'r' then
		SwitchScene("StartGame")
	elseif key == 'q' or key == 'escape' then
		SwitchScene("Menu")
	end
end

function love.draw()
	SetFont(30)
	love.graphics.print("Your score is: " ..tostring(lastscore),
						love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 - 50)
	SetFont(25)
	love.graphics.print("Press 'R' to restart !",
						love.graphics.getWidth() / 2 - 200, love.graphics.getHeight() / 2 - 10)
	love.graphics.print("Press 'Q' or 'ESC' to back to Menu !" ,
						love.graphics.getWidth() / 2 - 200, love.graphics.getHeight() / 2 + 20)
end
