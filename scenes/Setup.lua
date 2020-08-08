player_speed_slider = {
	--text = "Player Speed",
	text = lglist[lang].ps_slider,
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
	--text = "Bullet Speed",
	text = lglist[lang].bs_slider,
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
	text = lglist[lang].bd_slider,
	--text = "Bullet Density",
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
	lang = setup_table.lang or "English"
	bullet_color1 = Checkbox:new(800, 250, lglist[lang].st_purple , bullet_style_value[1] == "1")
	bullet_color2 = Checkbox:new(950, 250, lglist[lang].st_orange, bullet_style_value[1] == "2")
	bullet_color3 = Checkbox:new(1100, 250, lglist[lang].st_blue, bullet_style_value[1] == "3")
	bullet_shape1 = Checkbox:new(800, 350, lglist[lang].st_circle, bullet_style_value[2] == "1")
	bullet_shape2 = Checkbox:new(950, 350, lglist[lang].st_cone, bullet_style_value[2] == "2")
end

function love.update(dt)
	player_speed_slider.text = lglist[lang].ps_slider
	bullet_speed_slider.text = lglist[lang].bs_slider
	bullet_density_slider.text = lglist[lang].bd_slider
	bullet_color1.text = lglist[lang].st_purple
	bullet_color2.text = lglist[lang].st_orange
	bullet_color3.text = lglist[lang].st_blue
	bullet_shape1.text = lglist[lang].st_cone
	bullet_shape2.text = lglist[lang].st_purple
	lang_en = Checkbox:new(250, 500, lglist[lang].lg_en, lang == "English")
	lang_zh = Checkbox:new(450, 500, lglist[lang].lg_zh, lang == "Chinese")
end

function love.draw()
	love.graphics.setBackgroundColor(0, 0, 0)
	player_speed_value = drawSlider(player_speed_slider)
	bullet_speed_value = drawSlider(bullet_speed_slider)
	bullet_density_value = drawSlider(bullet_density_slider)
	SetFont(28)
	love.graphics.print(lglist[lang].bs_style, 680, 178)
	love.graphics.print(lglist[lang].st_color, 680, 245)
	love.graphics.print(lglist[lang].st_shape, 680, 345)
	love.graphics.print(lglist[lang].st_lang, 70, 495)
	bullet_color1:draw()
	bullet_color2:draw()
	bullet_color3:draw()
	bullet_shape1:draw()
	bullet_shape2:draw()
	lang_en:draw()
	lang_zh:draw()
end

function love.keypressed(key)
	if key == 'escape' then
		setup_table.player_speed = player_speed_value
		setup_table.bullet_speed = bullet_speed_value
		setup_table.bullet_density = bullet_density_value
		setup_table.bullet_style = bullet_style_value[1]..bullet_style_value[2]
		setup_table.lang = lang
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

		if lang_zh:click(mx, my) then
			lang_zh.ischecked = true
			lang_en.ischecked = false
			lang = "Chinese"
		elseif lang_en:click(mx, my) then
			lang_en.ischecked = true
			lang_zh.ischecked = false
			lang = "English"
		end
	end
end
