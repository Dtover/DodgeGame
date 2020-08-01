local score = 0

function love.load()
	score = lastscore
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
	love.graphics.print("Your score is: " ..tostring(score),
						love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 - 50)
	SetFont(25)
	love.graphics.print("Press 'R' to restart !",
						love.graphics.getWidth() / 2 - 200, love.graphics.getHeight() / 2 - 10)
	love.graphics.print("Press 'Q' or 'ESC' to back to Menu !" ,
						love.graphics.getWidth() / 2 - 200, love.graphics.getHeight() / 2 + 20)
end
