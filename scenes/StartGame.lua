-- defalut value
local player = { x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2,
				speed = 50 * setup_table.player_speed, img = nil }
local bulletImg = nil
local bullets = {}
local createbulletTimerMax = 0.5 / setup_table.bullet_density
local createbulletTimer = createbulletTimerMax
local isAlive = true
local scoretimer = 1
local Score = 0
local Score_level = setup_table.bullet_speed * setup_table.bullet_density / (setup_table.player_speed * 10)
local sound = nil
local mouseclickvalidTimer = 0.5
local paused = false

-- Check Collision function
local function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

-- Bullet direction
local function getAngle(x1, y1, x2, y2)
	return math.atan2((y2 - y1), (x2 - x1))
end

function love.load()
	player.img = love.graphics.newImage("resources/images/bullet03.png")
	bulletImg = love.graphics.newImage("resources/images/bullet04.png")
	sound = love.audio.newSource("resources/audio/hit-sound.wav", "static")
end

function love.update(dt)

	-- Caculate score
	scoretimer = scoretimer - dt
	if scoretimer < 0 and not paused then
		scoretimer = 1
		Score = Score + Score_level
	end
	-- mouse click valid
	if mouseclickvalidTimer > 0 then
		mouseclickvalidTimer = mouseclickvalidTimer - dt
	end
	-- time out bullet creation
	createbulletTimer = createbulletTimer - (1 * dt)
	if createbulletTimer < 0 and isAlive and not paused then
		createbulletTimer = createbulletTimerMax
		-- create bullet
		local bulletx = math.random(1, love.graphics.getWidth() - bulletImg:getWidth())
		local bullety = math.random(1, love.graphics.getHeight() - bulletImg:getHeight())
		local a = math.random(0,3)
		if a == 0 then
			bullet = { x = 0, y = bullety, img = bulletImg,
						angle = getAngle(0, bullety, player.x, player.y) }
		elseif a == 1 then
			bullet = { x = bulletx, y = 0, img = bulletImg,
						angle = getAngle(bulletx, 0, player.x, player.y) }
		elseif a == 2 then
			bullet = { x = love.graphics.getWidth(), y = bullety,
						img = bulletImg, angle = getAngle(love.graphics.getWidth(), bullety, player.x, player.y) }
		elseif a == 3 then
			bullet = { x = bulletx, y = love.graphics.getHeight(), img = bulletImg,
						angle = getAngle(bulletx, love.graphics.getHeight(), player.x, player.y) }
		end
		table.insert(bullets, bullet)
	end

	-- bullet movement modified version
	for i, bullet in pairs(bullets) do
		if bullet.x < 0 or bullet.y < 0 or
		   bullet.x > love.graphics.getWidth() or
		   bullet.y > love.graphics.getHeight() then
			table.remove(bullets, i)
		end
		if not paused then
			bullet.y = bullet.y + math.sin(bullet.angle) * dt * 50 * setup_table.bullet_speed
			bullet.x = bullet.x + math.cos(bullet.angle) * dt * 50 * setup_table.bullet_speed
		end
	end

	-- player movement
	if love.keyboard.isDown('right', 'd') and not paused and
	   player.x < (love.graphics.getWidth() - player.img:getWidth()) then
		player.x = player.x + (player.speed * dt)
	end
	if love.keyboard.isDown('left', 'a') and player.x > 0 and not paused then
		player.x = player.x - (player.speed *dt)
	end
	if love.keyboard.isDown('up', 'w') and player.y > 0 and not paused then
		player.y = player.y - (player.speed * dt)
	end
	if love.keyboard.isDown('down', 's') and not paused and
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
	end
end

-- press enter to pause
function love.keypressed(key)
	if key == 'return' then
		paused = not paused
	end
end

function love.draw()
	if isAlive then
		love.graphics.setBackgroundColor(0, 0, 0)
		love.graphics.setColor(55, 55, 55)
		if mouseclickvalidTimer < 0 and love.mouse.isDown(1) then
			love.graphics.draw(player.img, love.mouse.getX(), love.mouse.getY())
			player.x = love.mouse.getX()
			player.y = love.mouse.getY()
		else
			love.graphics.draw(player.img, player.x, player.y)
		end
		for i, bullet in pairs(bullets) do
			love.graphics.draw(bullet.img, bullet.x, bullet.y, bullet.angle + math.pi / 2)
		end
		SetFont(20)
		love.graphics.print("Score: " ..tostring(Score), 1150, 20)
		local FPS=love.timer.getFPS()
		love.graphics.print(FPS, 20, 680)
	end
	if paused then
		drawTitle("vcenter", {
			text = "Paused",
			size = 40,
			color = {1, 1, 1}
		})
	end
end

