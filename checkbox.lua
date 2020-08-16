Checkbox = {
	x = 200,
	y = 200,
	w = 30,
	text = "Type",
	ischecked = false
}

function Checkbox:new(x, y, text, ischecked, w)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.x = x or 200
	o.y = y or 200
	o.text = text or "Type"
	o.w = w or 30
	o.ischecked = ischecked or false;
	return o
end

function Checkbox:click(mx, my)
	if mx > self.x and mx < self.x + self.w and
	   my > self.y and my < self.y + self.w then
		return true
	end
end

function Checkbox:draw()
	SetFont(self.w - 5)
	love.graphics.print(self.text, self.x + self.w * 1.5, self.y - 4)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("line",self.x,self.y,self.w,self.w)
	if self.ischecked then
		love.graphics.rectangle("fill",self.x + 8,self.y + 8,self.w - 16,self.w - 16)
	end
end
return Checkbox
