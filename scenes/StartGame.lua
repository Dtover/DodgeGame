local love = require("love")

-- defalut value
local player = { x = 400, y = 400, speed = 200, img = nil }
local bulletImg = nil
local bullets = {}
local createbulletTimerMax = 0.5
local createbulletTimer = createbulletTimerMax
local isAlive = true
local Score = 0
--local lastscore = 0
local sound = nil

-- Check Collision function
local function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

-- Bullet change position
local function ChangePos(x1, y1, x2, y2, x)
	return (y2 - y1) * (x - x1) / (x2 - x1) + y1
end

function love.load()
	player.img = love.graphics.newImage("images/bullet02.png")
	bulletImg = love.graphics.newImage("images/bullet.png")
	sound = love.audio.newSource("sources/gun-sound.wav", "static")
end

function love.update(dt)
	-- time out bullet creation
	createbulletTimer = createbulletTimer - (1 * dt)
	if createbulletTimer < 0 and isAlive then
		createbulletTimer = createbulletTimerMax
		-- create bullet
		local bulletx = math.random(1, love.graphics.getWidth() - bulletImg:getWidth())
		local bullety = math.random(1, love.graphics.getHeight() - bulletImg:getHeight())
		local a = math.random(0,3)
		if a == 0 then
			bullet = { x = 0, y = bullety, playerx = player.x, playery = player.y, img = bulletImg, pos = true }
		elseif a == 1 then
			bullet = { x = bulletx, y = 0, playerx = player.x, playery = player.y,
						img = bulletImg, pos = player.x > bulletx }
		elseif a == 2 then
			bullet = { x = love.graphics.getWidth() , y = bullety, playerx = player.x, playery = player.y,
						img = bulletImg, pos = false}
		elseif a == 3 then
			bullet = { x = bulletx, y = love.graphics.getHeight(), playerx = player.x, playery = player.y,
						img = bulletImg, pos = player.x > bulletx }
		end
		if math.abs(bullet.x - bullet.playerx) > 50 then
			table.insert(bullets, bullet)
		end
		Score = Score + 1
	end

	-- bullet movement
	for i, bullet in pairs(bullets) do
		if bullet.x < 0 or bullet.y < 0 or
		   bullet.x > love.graphics.getWidth() or
		   bullet.y > love.graphics.getHeight() then
			table.remove(bullets, i)
		end
		if bullet.pos then
			bullet.y = ChangePos(bullet.x, bullet.y,
					   bullet.playerx, bullet.playery,
					   bullet.x + dt * 100)
			bullet.x = bullet.x + dt * 100
		else
			bullet.y = ChangePos(bullet.x, bullet.y,
					   bullet.playerx, bullet.playery,
					   bullet.x - dt * 100)
			bullet.x = bullet.x - dt * 100
		end
	end

	-- player movement
	if love.keyboard.isDown('right', 'd') and
	   player.x < (love.graphics.getWidth() - player.img:getWidth()) then
		player.x = player.x + (player.speed * dt)
	end
	if love.keyboard.isDown('left', 'a') and player.x > 0 then
		player.x = player.x - (player.speed *dt)
	end
	if love.keyboard.isDown('up', 'w') and player.y > 0 then
		player.y = player.y - (player.speed * dt)
	end
	if love.keyboard.isDown('down', 's') and
	   player.y < (love.graphics.getHeight() - player.img:getHeight()) then
		player.y = player.y + (player.speed * dt)
	end

	-- Check if Collision
	for i, bullet in pairs(bullets) do
		if CheckCollision(player.x, player.y, player.img:getWidth(), player.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) and
		   isAlive then
		    sound:play()
			table.remove(bullets, i)
			lastscore = Score
			isAlive = false
		end
	end

	if not isAlive then
		SwitchScene("GameOver")
		--if love.keyboard.isDown('r') then
			--bullets = {}
			--isAlive = true
			--player.x = 400
			--player.y = 400
			--Score = 0
		--elseif love.keyboard.isDown('q') or love.keyboard.isDown('escape') then
			--SwitchScene("Menu")
		--end
	end
end


function love.draw()
	if isAlive then
		love.graphics.setBackgroundColor(0, 0, 0)
		love.graphics.setColor(55, 55, 55)
		if love.mouse.isDown(1) then
			love.graphics.draw(player.img, love.mouse.getX(), love.mouse.getY())
			player.x = love.mouse.getX()
			player.y = love.mouse.getY()
		else
			love.graphics.draw(player.img, player.x, player.y)
		end
		for i, bullet in pairs(bullets) do
			love.graphics.draw(bullet.img, bullet.x, bullet.y)
		end
		SetFont(20)
		love.graphics.print("Score: " ..tostring(Score), 1150, 20)
		local FPS=love.timer.getFPS()
		love.graphics.print(FPS, 20, 680)
	else
		SwitchScene("GameOver")
		--SetFont(28)
		--love.graphics.print("Your score is: " ..tostring(lastscore),
							--love.graphics.getWidth() / 2 - 120, love.graphics.getHeight() / 2 - 50)
		--love.graphics.print("Press 'R' to restart !",
							--love.graphics.getWidth() / 2 - 120, love.graphics.getHeight() / 2 - 20)
		--love.graphics.print("Press 'Q' or 'ESC' to back to Menu !" ,
							--love.graphics.getWidth() / 2 - 120, love.graphics.getHeight() / 2 + 10)
	end
end
