local lgwidth = love.graphics.getWidth()
local lgheight = love.graphics.getHeight()
function love.load()
	gameTitle = {
		x = (lgwidth - 400) / 2,
		y = lgheight / 2 - 250,
		text = "DODGE",
		size = 120,
		color = {1, 1, 1},
		version = "Dodge v0.1.0"
	}

	gameversion = {
		x = 20,
		y = lgheight - 40,
		text = "Dodge v0.1.0",
		size = 18,
		color = {1, 1, 1}
	}

	-- Button config
	startButton = {
		x = (lgwidth - 200) / 2,
		y = gameTitle.y + 200,
		w = 200,
		h = 80,
		text = "START GAME",
		text_size = 25,
		button_color = {1, 1, 1},
		text_color = {0, 0, 0}
	}
	rankButton = {
		x = (lgwidth - 200) / 2,
		y = gameTitle.y + 300,
		w = 200,
		h = 80,
		text = "RANKING",
		text_size = 25,
		button_color = {1, 1, 1},
		text_color = {0, 0, 0}
	}
	setupButton = {
		x = (lgwidth - 200) / 2,
		y = gameTitle.y + 400,
		w = 200,
		h = 80,
		text = "SET UP",
		text_size = 25,
		button_color = {1, 1, 1},
		text_color = {0, 0, 0}
	}
	--require("draw")
	--drawTitle = draw.drawTitle
	--drawButton = draw.drawButton
	--drawSlider = draw.drawSlider
end


function love.update()
end

function love.draw()
	draw.drawTitle("center", gameTitle)
	draw.drawButton(startButton)
	draw.drawButton(rankButton)
	draw.drawButton(setupButton)
	draw.drawTitle("right", gameversion)
end

function love.mousepressed(x, y, button)
	if button == 1 then
		if isclick(startButton, x, y) then
			SwitchScene("StartGame")
		elseif isclick(rankButton, x, y) then
			SwitchScene("Ranking")
		elseif isclick(setupButton, x, y) then
			SwitchScene("Setup")
		end
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end
