local player_speed_value = setup_table.player_speed
local bullet_speed_value = setup_table.bullet_speed
local bullet_density_value = setup_table.bullet_density
local player_speed_min = 1
local player_speed_max = 5
local bullet_speed_min = 1
local bullet_speed_max = 5
local bullet_density_min = 1
local bullet_density_max = 5

function generateSlider(x, y, length, level, thickness, min_value, max_value, cur_value)
	love.graphics.rectangle("fill", x, y - (thickness / 2), length, thickness)
	for i = 0, level do
		love.graphics.line(x + i * length / level, y - (thickness * 2),
						   x + i * length / level, y + (thickness * 2))
	end
	love.graphics.circle("fill", x + length * (cur_value - min_value)/ (max_value - min_value), y, thickness * 3, 4)
	if love.mouse.isDown(1) then
		mx, my = love.mouse.getPosition()
		if mx > x and mx <= x + length + 10 and
		   my > y - thickness * 2 and my < y + thickness * 2 then
		   cur_value = math.floor((max_value - min_value) * (mx - x) / length + min_value)
	   end
	end
	return cur_value
end

function love.load()
	player_speed_value = setup_table.player_speed
	bullet_speed_value = setup_table.bullet_speed
	bullet_density_value = setup_table.bullet_density
end

function love.update(dt)
end

function love.draw()
	love.graphics.setColor(255, 255, 255)

	love.graphics.print(player_speed_value, 620, 182)
	love.graphics.print("Player Speed : ", 120, 182)
	player_speed_value = generateSlider(320, 200, 250, 4, 3, player_speed_min, player_speed_max, player_speed_value)

	love.graphics.print(bullet_speed_value, 620, 282)
	love.graphics.print("Bullet Speed : ", 120, 282)
	bullet_speed_value = generateSlider(320, 300, 250, 4, 3, bullet_speed_min, bullet_speed_max, bullet_speed_value)

	love.graphics.print(bullet_density_value, 620, 382)
	love.graphics.print("Bullet Density: ", 120, 382)
	bullet_density_value = generateSlider(320, 400, 250, 4, 3, bullet_density_min, bullet_density_max, bullet_density_value)
end

function love.keypressed(key)
	if key == 'escape' then
		setup_table.player_speed = player_speed_value
		setup_table.bullet_speed = bullet_speed_value
		setup_table.bullet_density = bullet_density_value
		writeStorage(setup_table)
		SwitchScene("Menu")
	end
end
