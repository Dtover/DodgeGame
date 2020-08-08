local file = nil

function love.load()
	if #tostring(lastscore) == 1 then
		insertRanklist_encrypted("ranking.dat", "0"..lastscore,os.date('%H:%M:%S %Y/%m/%d'))
	else
		insertRanklist_encrypted("ranking.dat", lastscore,os.date('%H:%M:%S %Y/%m/%d'))
	end
	restartButton = {
		x = 340,
		y = 500,
		w = 200,
		h = 80,
		--text = "RESTART",
		text = lglist[lang].rs_button,
		text_size = 30,
		button_color = {1, 1, 1},
		text_color = {0, 0, 0}
	}
	backButton= {
		x = 740,
		y = 500,
		w = 200,
		h = 80,
		--text = "BACK",
		text = lglist[lang].bk_button,
		text_size = 30,
		button_color = {1, 1, 1},
		text_color = {0, 0, 0}
	}
	scoreTitle = {
		x = 0,
		y = 200,
		text = lglist[lang].go_title .. tostring(lastscore),
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
end
