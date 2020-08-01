local love = require("love")

local plane = { x = 400, y = 400, speed = 200, img = nil }
local bulletImg = nil
local bullets = {}
local createbulletTimerMax = 0.5
local createbulletTimer = createbulletTimerMax
local isAlive = false
local Score = 0
local lastscore = 0
local font = love.graphics.newFont("sources/font.ttf", 20)
local currentFontSize = 20
local sound = nil

local isWelcomepage = true
startButton = { x = (love.graphics.getWidth() - 200) / 2, y = love.graphics.getHeight() / 2 - 150,
				w = 200, h = 80, text = "START GAME", flag = true }
rankButton = { x = (love.graphics.getWidth() - 200) / 2, y = love.graphics.getHeight() / 2 - 50,
				w = 200, h = 80, text = "RANKING", flag = true}
setupButton = { x = (love.graphics.getWidth() -200) / 2, y = love.graphics.getHeight() / 2 + 50,
				w = 200, h = 80, text = "SET UP", flag = true}

-- Set font
local function SetFont(size)
	if size ~= currentFontSize then
		font = love.graphics.newFont("sources/font.ttf", size)
		love.graphics.setFont(font)
		currentFontSize = size
	end
end

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

-- Button click
local function isclick(button, mx, my)
	if mx > button.x and mx < button.x + button.w and
	   my > button.y and my < button.y + button.h and
	   button.flag then
		return true
	else
		return false
	end
end


function love.load()
	--plane.img = love.graphics.newImage("images/aircraft.png")
	plane.img = love.graphics.newImage("images/bullet02.png")
	bulletImg = love.graphics.newImage("images/bullet.png")
	sound = love.audio.newSource("sources/gun-sound.wav", "static")
	--Font = love.graphics.newFont("sources/font.ttf", 30)
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
			bullet = { x = 0, y = bullety, planex = plane.x, planey = plane.y, img = bulletImg, pos = true }
		elseif a == 1 then
			bullet = { x = bulletx, y = 0, planex = plane.x, planey = plane.y,
						img = bulletImg, pos = plane.x > bulletx }
		elseif a == 2 then
			bullet = { x = love.graphics.getWidth() , y = bullety, planex = plane.x, planey = plane.y,
						img = bulletImg, pos = false}
		elseif a == 3 then
			bullet = { x = bulletx, y = love.graphics.getHeight(), planex = plane.x, planey = plane.y,
						img = bulletImg, pos = plane.x > bulletx }
		end
		if math.abs(bullet.x - bullet.planex) > 50 then
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
					   bullet.planex, bullet.planey,
					   bullet.x + dt * 100)
			bullet.x = bullet.x + dt * 100
		else
			bullet.y = ChangePos(bullet.x, bullet.y,
					   bullet.planex, bullet.planey,
					   bullet.x - dt * 100)
			bullet.x = bullet.x - dt * 100
		end
	end

	-- Plane movement
	if love.keyboard.isDown('right', 'd') and
	   plane.x < (love.graphics.getWidth() - plane.img:getWidth()) then
		plane.x = plane.x + (plane.speed * dt)
	end
	if love.keyboard.isDown('left', 'a') and plane.x > 0 then
		plane.x = plane.x - (plane.speed *dt)
	end
	if love.keyboard.isDown('up', 'w') and plane.y > 0 then
		plane.y = plane.y - (plane.speed * dt)
	end
	if love.keyboard.isDown('down', 's') and
	   plane.y < (love.graphics.getHeight() - plane.img:getHeight()) then
		plane.y = plane.y + (plane.speed * dt)
	end

	-- Check if Collision
	for i, bullet in pairs(bullets) do
		if CheckCollision(plane.x, plane.y, plane.img:getWidth(), plane.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) and
		   isAlive then
		    sound:play()
			table.remove(bullets, i)
			lastscore = Score
			isAlive = false
		end
	end

	if not isAlive and love.keyboard.isDown('r') then
		bullets = {}
		isAlive = true
		plane.x = 400
		plane.y = 400
		Score = 0
	end
end

function love.keypressed(key)
	if key == 'escape' or key == 'q' then
		if isWelcomepage then
			love.event.quit()
		else
			startButton.flag = true
			rankButton.flag = true
			setupButton.flag = true
			bullets = {}
			plane.x = 400
			plane.y = 400
			Score = 0
			isWelcomepage = true
			isAlive = false
		end
	end
end


function love.mousepressed(x, y, button)
	if button == 1 and isWelcomepage then
		if isclick(startButton, x, y) then
			rankButton.flag = false
			setupButton.flag = false
			isWelcomepage = false
			isAlive = true
		elseif isclick(rankButton, x, y) then
			startButton.flag = false
			setupButton.flag = false
			rankButton.w = 300
		elseif isclick(setupButton, x, y) then
			startButton.flag = false
			rankButton.flag = false
			setupButton.w = 300
		end
	end
end

function love.draw(dt)
	if isWelcomepage then
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle( "fill", startButton.x, startButton.y, startButton.w, startButton.h )
		love.graphics.rectangle( "fill", rankButton.x, rankButton.y, rankButton.w, rankButton.h )
		love.graphics.rectangle( "fill", setupButton.x, setupButton.y, setupButton.w, setupButton.h )
		love.graphics.setColor(0, 0, 0)
		SetFont(25)
		love.graphics.print(startButton.text, startButton.x + 25, startButton.y + 20)
		love.graphics.print(rankButton.text, rankButton.x + 45, rankButton.y + 20)
		love.graphics.print(setupButton.text, setupButton.x + 60, setupButton.y + 20)
	else
		if isAlive then
			love.graphics.setBackgroundColor(0, 0, 0)
			love.graphics.setColor(55, 55, 55)
			if love.mouse.isDown(1) then
				love.graphics.draw(plane.img, love.mouse.getX(), love.mouse.getY())
				plane.x = love.mouse.getX()
				plane.y = love.mouse.getY()
			else
				love.graphics.draw(plane.img, plane.x, plane.y)
			end
			for i, bullet in pairs(bullets) do
				love.graphics.draw(bullet.img, bullet.x, bullet.y)
			end
			SetFont(20)
			love.graphics.print("Score: " ..tostring(Score), 1150, 20)
			local FPS=love.timer.getFPS()
			love.graphics.print(FPS, 20, 680)
		else
			SetFont(28)
			love.graphics.print("Your score is: " ..tostring(lastscore),
							love.graphics.getWidth() / 2 - 120, love.graphics.getHeight() / 2 - 50)
			love.graphics.print("Press 'R' to restart !", love.graphics.getWidth() / 2 - 120, love.graphics.getHeight() / 2 - 20)
		end

	end
end
