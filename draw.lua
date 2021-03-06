draw = {}
local lgheight = love.graphics.getHeight()
local lgwidth = love.graphics.getWidth()
--[[
-- button format
button = {
	x = x,
	y = y,
	w = w,
	h = h,
	text = "Name",
	text_size = 10,
	button_color = {1, 1, 1},
	text_color = {0, 0, 0}
}
-- title format
title = {
	x = x,
	y = y,
	size = size,
	color = {0, 0 ,0}
}
-- slider format
slider = {
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
--]]
--Fontlist = {}
function draw.setFont(size)
	if currentFontSize ~= size then
		if Fontlist[size] then
			love.graphics.setFont(Fontlist[size].font)
		else
			font = love.graphics.newFont("resources/fonts/font.ttf", size)
			love.graphics.setFont(font)
			Fontlist[size] = {
				font = font,
				height = font:getHeight("H")
			}
		end
		currentFontSize = size
	end
end

function draw.drawButton(button)
	SetFont(button.text_size)
	love.graphics.setColor(button.button_color)
	love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
	love.graphics.setColor(button.text_color)
	love.graphics.printf(button.text, button.x, button.y + (button.h - Fontlist[button.text_size].height) / 2, button.w, "center")
end

function draw.drawTitle(pos, title)
	SetFont(title.size)
	love.graphics.setColor(title.color)
	if pos == "vcenter" then
		love.graphics.printf(title.text, 0, (lgheight - font:getHeight(title.text)) / 2, 1280, "center")
	else
		love.graphics.printf(title.text, title.x or 0, title.y or 0, (1290 - title.x * 2), pos)
	end
end

function draw.drawSlider(slider)
	draw.setFont(slider.text_size)
	love.graphics.print(slider.text .. " : ",
				slider.x - slider.length , slider.y - font:getHeight(slider.text) / 2)
				--slider.x - font:getWidth(slider.text) - 50, slider.y - font:getHeight(slider.text) / 2)
	love.graphics.rectangle("fill", slider.x, slider.y - (slider.thickness / 2), slider.length, slider.thickness)
	for i = 0, slider.level do
		love.graphics.line(slider.x + i * slider.length / slider.level, slider.y - (slider.thickness * 2),
						   slider.x + i * slider.length / slider.level, slider.y + (slider.thickness * 2))
	end
	love.graphics.circle("fill",
	slider.x + slider.length * (slider.cur_value - slider.min_value) / (slider.max_value - slider.min_value),
	slider.y, slider.thickness * 3, 4)
	if love.mouse.isDown(1) then
		mx, my = love.mouse.getPosition()
		if mx > slider.x and mx <= slider.x + slider.length + 10 and
		   my > slider.y - slider.thickness * 2 and my < slider.y + slider.thickness * 2 then
		   slider.cur_value = math.floor(
			   (slider.max_value - slider.min_value) * (mx - slider.x) / slider.length + slider.min_value
		   )
	   end
	end
	love.graphics.print(slider.cur_value, slider.x + slider.length + 30, slider.y - font:getHeight() / 2)
	return slider.cur_value
end


return draw
