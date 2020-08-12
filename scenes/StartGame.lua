-- defalut value
local lgwidth = love.graphics.getWidth()
local lgheight = love.graphics.getHeight()
local player = {
	x = lgwidth / 2,
	y = lgheight / 2,
	speed = 50 * setup_table.player_speed,
	img = nil
}
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

-- Bullet direction
local function getAngle(x1, y1, x2, y2)
	return math.atan2((y2 - y1), (x2 - x1))
end


-- Collision Detection (circle and rotating rectangular)
function CollisionDetection(rect, circle)
	local closetpoint = {}
	local r_angle = - rect.angle - math.pi / 2
	circle.nx = math.cos(r_angle) * (circle.x) - math.sin(r_angle) * (circle.y)
	circle.ny = math.sin(r_angle) * (circle.x) + math.cos(r_angle) * (circle.y)
	rect.rx = math.cos(r_angle) * (rect.x) - math.sin(r_angle) * (rect.y)
	rect.ry = math.sin(r_angle) * (rect.x) + math.cos(r_angle) * (rect.y)
	if circle.nx < rect.rx then
		closetpoint.x = rect.rx
	elseif circle.nx > rect.rx + rect.w then
		closetpoint.x = rect.rx + rect.w
	else
		closetpoint.x = circle.nx
	end
	if circle.ny < rect.ry then
		closetpoint.y = rect.ry
	elseif circle.ny > rect.ry + rect.h then
		closetpoint.y = rect.ry + rect.h
	else
		closetpoint.y = circle.ny
	end
	local distance = math.sqrt(math.pow(closetpoint.x - circle.nx, 2) + math.pow(closetpoint.y - circle.ny, 2))
	if distance < circle.radius then
		return true
	else
		return false
	end
end


function love.load()
	player.img = love.graphics.newImage("resources/images/player01.png")
	player.cx = (player.x + player.x + player.img:getWidth()) / 2
	player.cy = (player.y + player.y + player.img:getHeight()) / 2
	player.radius = player.img:getWidth() / 2 - 2
	bs = setup_table.bullet_style
	bulletImg = love.graphics.newImage("resources/images/bullet"..bs..".png")
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
		local bulletx = math.random(1, lgwidth - bulletImg:getWidth())
		local bullety = math.random(1, lgheight - bulletImg:getHeight())
		local a = math.random(0,3)
		if a == 0 then
			bullet = {
				x = 0,
				y = bullety,
				w = bulletImg:getWidth(),
				h = bulletImg:getHeight(),
				img = bulletImg,
				angle = getAngle(0, bullety, player.x, player.y),
			}
		elseif a == 1 then
			bullet = {
				x = bulletx,
				y = 0,
				w = bulletImg:getWidth(),
				h = bulletImg:getHeight(),
				img = bulletImg,
				angle = getAngle(bulletx, 0, player.x, player.y),
			}
		elseif a == 2 then
			bullet = {
				x = lgwidth,
				y = bullety,
				w = bulletImg:getWidth(),
				h = bulletImg:getHeight(),
				img = bulletImg,
				angle = getAngle(lgwidth, bullety, player.x, player.y),
			}
		elseif a == 3 then
			bullet = {
				x = bulletx,
				y = lgheight,
				w = bulletImg:getWidth(),
				h = bulletImg:getHeight(),
				img = bulletImg,
				angle = getAngle(bulletx, lgheight, player.x, player.y),
			}
		end
		table.insert(bullets, bullet)
	end

	-- bullet movement modified version
	for i, bullet in pairs(bullets) do
		if bullet.x < 0 or bullet.y < 0 or
		   bullet.x > lgwidth or
		   bullet.y > lgheight then
			table.remove(bullets, i)
		end
		if not paused then
			bullet.y = bullet.y + math.sin(bullet.angle) * dt * 50 * setup_table.bullet_speed
			bullet.x = bullet.x + math.cos(bullet.angle) * dt * 50 * setup_table.bullet_speed
		end
	end

	-- player movement
	if love.keyboard.isDown('right', 'd') and not paused and
	   player.x < (lgwidth - player.img:getWidth()) then
		player.x = player.x + (player.speed * dt)
	end
	if love.keyboard.isDown('left', 'a') and player.x > 0 and not paused then
		player.x = player.x - (player.speed *dt)
	end
	if love.keyboard.isDown('up', 'w') and player.y > 0 and not paused then
		player.y = player.y - (player.speed * dt)
	end
	if love.keyboard.isDown('down', 's') and not paused and
	   player.y < (lgheight - player.img:getHeight()) then
		player.y = player.y + (player.speed * dt)
	end

	-- Check if Collision
	for i, bullet in pairs(bullets) do
		if CollisionDetection(bullet, player) and
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
		love.graphics.print( lglist[lang].st_score ..tostring(Score), 1150, 20)
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

