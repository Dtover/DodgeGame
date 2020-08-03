local file = nil

function love.load()
	insertRanklist_encrypted("ranking.dat", lastscore,os.date('%H:%M:%S %Y/%m/%d'))
	restartButton = {
		x = 340,
		y = 500,
		w = 200,
		h = 80,
		text = "RESTART",
		text_size = 30,
		button_color = {1, 1, 1},
		text_color = {0, 0, 0}
	}
	backButton= {
		x = 740,
		y = 500,
		w = 200,
		h = 80,
		text = "BACK",
		text_size = 30,
		button_color = {1, 1, 1},
		text_color = {0, 0, 0}
	}
	scoreTitle = {
		x = 0,
		y = 200,
		text = "Your score: ".. tostring(lastscore),
		size = 80,
		color = {1, 1, 1}
	}
end

function love.keypressed(key)
	if key == 'r' then
		SwitchScene("StartGame")
	elseif key == 'q' or key == 'escape' then
		SwitchScene("Menu")
	end
end

function love.mousepressed(mx, my, button)
	if isclick(restartButton, mx, my) then
		SwitchScene("StartGame")
	elseif isclick(backButton, mx, my) then
		SwitchScene("Menu")
	end
end

function love.draw()
	love.graphics.setBackgroundColor(0, 0, 0)
	drawTitle("center", scoreTitle)
	drawButton(restartButton)
	drawButton(backButton)
	--SetFont(25)
	--love.graphics.print("Press 'R' to restart !",
						--love.graphics.getWidth() / 2 - 200, love.graphics.getHeight() / 2 - 10)
	--love.graphics.print("Press 'Q' or 'ESC' to back to Menu !" ,
						--love.graphics.getWidth() / 2 - 200, love.graphics.getHeight() / 2 + 20)
end
