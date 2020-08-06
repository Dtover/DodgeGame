player_speed_slider = {
	text = "Player Speed",
	text_size = 25,
	x = 320,
	y = 200,
	length = 250,
	level = 4,
	thickness = 3,
	min_value = 1,
	max_value = 5,
	cur_value = setup_table.player_speed
}

bullet_speed_slider = {
	text = "Bullet Speed",
	text_size = 25,
	x = 320,
	y = 300,
	length = 250,
	level = 4,
	thickness = 3,
	min_value = 1,
	max_value = 5,
	cur_value = setup_table.bullet_speed
}
bullet_density_slider = {
	text = "Bullet Density",
	text_size = 25,
	x = 320,
	y = 400,
	length = 250,
	level = 4,
	thickness = 3,
	min_value = 1,
	max_value = 5,
	cur_value = setup_table.bullet_density
}

function love.load()
	player_speed_value = setup_table.player_speed
	bullet_speed_value = setup_table.bullet_speed
	bullet_density_value = setup_table.bullet_density
end

function love.update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(0, 0, 0)
	player_speed_value = drawSlider(player_speed_slider)
	bullet_speed_value = drawSlider(bullet_speed_slider)
	bullet_density_value = drawSlider(bullet_density_slider)
end

function love.keypressed(key)
	if key == 'escape' then
		setup_table.player_speed = player_speed_value
		setup_table.bullet_speed = bullet_speed_value
		setup_table.bullet_density = bullet_density_value
		writeStorage(setup_table, "setup.dat")
		SwitchScene("Menu")
	end
end
