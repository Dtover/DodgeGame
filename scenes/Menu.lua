local love = require("love")

gameTitle = {
	text = "DODGE",
	size = 120,
	x = (love.graphics.getWidth() - 400) / 2,
	y = love.graphics.getHeight() / 2 - 250,
}

-- Button config
startButton = {
	x = (love.graphics.getWidth() - 200) / 2,
	y = gameTitle.y + 200,
	w = 200,
	h = 80,
	text = "START GAME",
	flag = true
}
rankButton = {
	x = (love.graphics.getWidth() - 200) / 2,
	y = gameTitle.y + 300,
	w = 200,
	h = 80,
	text = "RANKING",
	flag = true
}
setupButton = {
	x = (love.graphics.getWidth() - 200) / 2,
	y = gameTitle.y + 400,
	w = 200,
	h = 80,
	text = "SET UP",
	flag = true
}

function love.load()
end

function love.update()
end

function love.draw()
	love.graphics.setColor(1, 1, 1)
	SetFont(gameTitle.size)
	love.graphics.print(gameTitle.text, gameTitle.x, gameTitle.y)
	love.graphics.rectangle( "fill", startButton.x, startButton.y, startButton.w, startButton.h )
	love.graphics.rectangle( "fill", rankButton.x, rankButton.y, rankButton.w, rankButton.h )
	love.graphics.rectangle( "fill", setupButton.x, setupButton.y, setupButton.w, setupButton.h )
	love.graphics.setColor(0, 0, 0)
	SetFont(25)
	love.graphics.print(startButton.text, startButton.x + 25, startButton.y + 20)
	love.graphics.print(rankButton.text, rankButton.x + 45, rankButton.y + 20)
	love.graphics.print(setupButton.text, setupButton.x + 60, setupButton.y + 20)
end

function love.mousepressed(x, y, button)
	if button == 1 then
		if isclick(startButton, x, y) then
			SwitchScene("StartGame")
		elseif isclick(rankButton, x, y) then
		elseif isclick(setupButton, x, y) then
		end
	end
end
