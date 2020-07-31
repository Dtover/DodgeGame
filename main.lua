local love = require("love")

local plane = { x = 300, y = 300, speed = 200, img = nil }
local bulletImg = nil
local bullets = {}
local createbulletTimerMax = 0.5
local createbulletTimer = createbulletTimerMax
local isAlive = true
local Score = 0
local lastscore = 0
local Font = nil
local sound = nil
-- Set font
local function SetFont(size)
	if Font then
		love.graphics.setFont(Font, size)
	else
		Font = love.graphics.newFont("sources/font.ttf", size)
		love.graphics.setFont(Font)
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

-- Judge position
local function LeftOrRight(x, y)
	return x > y
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
	if createbulletTimer < 0 then
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

	if love.keyboard.isDown('escape', 'q') then
		love.event.quit()
	end

	-- Plane movement
	if love.keyboard.isDown('right', 'd') and love.keyboard.isDown('up', 'w') then
		if plane.x < (love.graphics.getWidth() - plane.img:getWidth()) and plane.y > 0 then
			plane.x = plane.x + (plane.speed * dt)
			plane.y = plane.y - (plane.speed * dt)
		end
	elseif love.keyboard.isDown('right', 'd') and love.keyboard.isDown('down', 's') then
		if plane.x < (love.graphics.getWidth() - plane.img:getWidth()) and
		   plane.y < (love.graphics.getHeight() - plane.img:getHeight()) then
			plane.x = plane.x + (plane.speed * dt)
			plane.y = plane.y + (plane.speed * dt)
		end
	elseif love.keyboard.isDown('left', 'a') and love.keyboard.isDown('up', 'w') then
		if plane.x > 0 and plane.y > 0 then
			plane.x = plane.x - (plane.speed * dt)
			plane.y = plane.y - (plane.speed * dt)
		end
	elseif love.keyboard.isDown('left', 'a') and love.keyboard.isDown('down', 's') then
		if plane.x > 0 and
		   plane.y < (love.graphics.getHeight() - plane.img:getHeight()) then
			plane.x = plane.x - (plane.speed * dt)
			plane.y = plane.y + (plane.speed * dt)
		end
	elseif love.keyboard.isDown('right', 'd') then
		if plane.x < (love.graphics.getWidth() - plane.img:getWidth()) then
			plane.x = plane.x + (plane.speed * dt)
		end
	elseif love.keyboard.isDown('left', 'a') then
		if plane.x > 0 then
			plane.x = plane.x - (plane.speed *dt)
		end
	elseif love.keyboard.isDown('up', 'w') then
		if plane.y > 0 then
			plane.y = plane.y - (plane.speed * dt)
		end
	elseif love.keyboard.isDown('down', 's') then
		if plane.y < (love.graphics.getHeight() - plane.img:getHeight()) then
			plane.y = plane.y + (plane.speed * dt)
		end
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
		plane.x = 300
		plane.y = 300
		Score = 0
	end
end

function love.draw(dt)
	if isAlive then
		love.graphics.draw(plane.img, plane.x, plane.y)
		for i, bullet in pairs(bullets) do
			love.graphics.draw(bullet.img, bullet.x, bullet.y)
		end
		SetFont(20)
		love.graphics.print("Score: " ..tostring(Score), 680, 20)
	else
		SetFont(30)
		love.graphics.print("Your score is: " ..tostring(lastscore),
						love.graphics.getWidth() / 2 - 80, love.graphics.getHeight() / 2 - 50)
		love.graphics.print("Press 'R' to restart !", love.graphics.getWidth() / 2 - 80, love.graphics.getHeight() / 2 - 20)
	end
end
