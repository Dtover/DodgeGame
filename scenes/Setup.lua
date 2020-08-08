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
	bullet_style_number = {string.sub(setup_table.bullet_style, 1, 1), string.sub(setup_table.bullet_style, 2, 2)}
	bullet_style_value = bullet_style_number
	bullet_color1 = Checkbox:new(800, 250, "Purple", bullet_style_value[1] == "1")
	bullet_color2 = Checkbox:new(950, 250, "Orange", bullet_style_value[1] == "2")
	bullet_color3 = Checkbox:new(1100, 250, "Blue", bullet_style_value[1] == "3")
	bullet_shape1 = Checkbox:new(800, 350, "Circle", bullet_style_value[2] == "1")
	bullet_shape2 = Checkbox:new(950, 350, "Cone", bullet_style_value[2] == "2")

end

function love.update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(0, 0, 0)
	player_speed_value = drawSlider(player_speed_slider)
	bullet_speed_value = drawSlider(bullet_speed_slider)
	bullet_density_value = drawSlider(bullet_density_slider)
	drawTitle("right", {
		x = 450,
		y = 178,
		text = "Bullet style : ",
		size = 28,
		color = {1, 1, 1}
	})
	SetFont(28)
	love.graphics.print("Color: ", 680, 245)
	love.graphics.print("Shape: ", 680, 345)
	bullet_color1:draw()
	bullet_color2:draw()
	bullet_color3:draw()
	bullet_shape1:draw()
	bullet_shape2:draw()
end

function love.keypressed(key)
	if key == 'escape' then
		setup_table.player_speed = player_speed_value
		setup_table.bullet_speed = bullet_speed_value
		setup_table.bullet_density = bullet_density_value
		setup_table.bullet_style = bullet_style_value[1]..bullet_style_value[2]
		writeStorage(setup_table, "setup.dat")
		SwitchScene("Menu")
	end
end

function love.mousereleased(mx, my, button)
	if button == 1 then
		if bullet_color1:click(mx, my) then
			bullet_color1.ischecked = true
			bullet_color2.ischecked = false
			bullet_color3.ischecked = false
			bullet_style_value[1] = 1
		elseif bullet_color2:click(mx, my) then
			bullet_color2.ischecked = true
			bullet_color1.ischecked = false
			bullet_color3.ischecked = false
			bullet_style_value[1] = 2
		elseif bullet_color3:click(mx, my) then
			bullet_color3.ischecked = true
			bullet_color1.ischecked = false
			bullet_color2.ischecked = false
			bullet_style_value[1] = 3
		end

		if bullet_shape1:click(mx, my) then
			bullet_shape1.ischecked = true
			bullet_shape2.ischecked = false
			bullet_style_value[2] = 1
		elseif bullet_shape2:click(mx, my) then
			bullet_shape2.ischecked = true
			bullet_shape1.ischecked = false
			bullet_style_value[2] = 2
		end
	end
end
