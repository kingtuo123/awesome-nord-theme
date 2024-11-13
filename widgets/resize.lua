local awful = require("awful")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi





local anchor_set = {}
anchor_set[1] = {}
anchor_set[1][1] = function(c,t) awful.placement.top_left(c, {margins = {top = t, left = theme.useless_gap*2}}) end
anchor_set[1][2] = function(c,t) awful.placement.left(c, {margins = {top = t - theme.useless_gap*2, left = theme.useless_gap*2}}) end
anchor_set[1][3] = function(c,t) awful.placement.bottom_left(c, {margins = {bottom = theme.useless_gap*2, left = theme.useless_gap*2}}) end
anchor_set[2] = {}
anchor_set[2][1] = function(c,t) awful.placement.top(c, {margins = {top = t}}) end
anchor_set[2][2] = function(c,t) awful.placement.centered(c, {margins = {top = t - theme.useless_gap*2}}) end
anchor_set[2][3] = function(c,t) awful.placement.bottom(c, {margins = {bottom = theme.useless_gap*2}}) end
anchor_set[3] = {}
anchor_set[3][1] = function(c,t) awful.placement.top_right(c, {margins = {top = t, right = theme.useless_gap*2}}) end
anchor_set[3][2] = function(c,t) awful.placement.right(c, {margins = {top = t - theme.useless_gap*2, right = theme.useless_gap*2}}) end
anchor_set[3][3] = function(c,t) awful.placement.bottom_right(c, {margins = {bottom = theme.useless_gap*2, right = theme.useless_gap*2}}) end




local function client_resize(c, m, t)
	local s = awful.screen.focused() 
	local d = dpi(50)
	if s.topbar.visible then
		margin_top = theme.topbar_height + theme.topbar_border_width + theme.useless_gap * 2
	else
		margin_top = theme.useless_gap*2
	end
	if t == "width" then
		w = d
		h = 0
	elseif t == "height" then
		w = 0
		h = d
	else
		w = d
		h = math.floor(d * (c.height / c.width) + 0.5)
	end
	if m == "dec" then
		w = 0 - w
		h = 0 - h
	end
	if c.width + theme.border_width * 2 >= s.geometry.width - theme.useless_gap*4 then
		ax = 2
	elseif c.x <= theme.useless_gap * 2 then
		ax = 1
	elseif c.x + c.width + theme.border_width*2  >= s.geometry.width - theme.useless_gap * 2 then
		ax = 3
	elseif c.y + c.height + theme.border_width*2  >= s.geometry.height - theme.useless_gap * 2 then 
		ax = 2
	elseif c.y <= margin_top then
		ax = 2
	else
		ax = 0
	end
	if c.height + theme.border_width * 2 >= s.geometry.height - margin_top - theme.useless_gap * 2 then
		ay = 2
	elseif c.y <= margin_top then
		ay = 1
	elseif c.y + c.height + theme.border_width*2 >= s.geometry.height - theme.useless_gap * 2 then 
		ay = 3
	elseif c.x + c.width + theme.border_width*2 >= s.geometry.width - theme.useless_gap * 2 then
		ay = 2
	elseif c.x <= theme.useless_gap * 2 then
		ay = 2
	else
		ay = 0
	end
	c.oldw = c.width
	c.oldh = c.height
	if c.width + w  > s.geometry.width - theme.useless_gap * 4 then
		c.width = s.geometry.width - theme.useless_gap * 4 
	else
		c.width = c.width + w
	end
	if c.height + h  > s.geometry.height - margin_top - theme.useless_gap * 2 then
		c.height = s.geometry.height - margin_top -theme.useless_gap * 2 
	else
		c.height = c.height + h
	end
	w = c.width - c.oldw
	h = c.height - c.oldh
	if ax == 0 or ay == 0 then
		dx = math.floor(c.x - w / 2 + 0.5)
		dy = math.floor(c.y - h / 2 + 0.5)
		if dx <= 0 then
			c.x = 0
		else
			c.x = dx
		end
		if dy <= margin_top then
			c.y = margin_top
		else
			c.y = dy
		end
	else
		anchor_set[ax][ay](c, margin_top)
	end
end

function client_setwfact(c, m, t)
	local s = awful.screen.focused()
	if m == "inc" then
		d = 1
	elseif m == "dec" then
		d = -1
	end
	if t == "height" then
		f = (math.floor(math.floor(100 * c.height / s.tiling_area.height) / 5 + 0.5) + d) * 5
	elseif t == "width" then
		f = (math.floor(math.floor(100 * c.width / s.tiling_area.width) / 5 + 0.5) + d) * 5
	end
	if f < 10 then
		f = 10
	elseif f > 90 then
		f = 90
	end
	awful.client.setwfact(f/100)
end



local function smart_resize(c, mode, type)
	c:emit_signal("request::activate", "mouse_click", {raise = true})
	if c.fullscreen or c.maximized then return end
	local s = awful.screen.focused() 
	local l = awful.layout.get(s)
	if c.floating or l == awful.layout.suit.floating then
		client_resize(c, mode, type)
		return
	end
	if type == "both" then
		return
	end
	local d
	if mode == "inc" then
		d = 0.05	
	else
		d = -0.05	
	end
	if type == "width" then
		if l == awful.layout.suit.tile or l == awful.layout.suit.tile.left then
			if c == awful.client.getmaster() then
				awful.tag.incmwfact(d)
			else
				awful.tag.incmwfact(0-d)
			end
		else
			client_setwfact(c, mode, type)
		end
	elseif type == "height" then
		if l ~= awful.layout.suit.tile and l ~= awful.layout.suit.tile.left then
			if c == awful.client.getmaster() then
				awful.tag.incmwfact(d)
			else
				awful.tag.incmwfact(0-d)
			end
		else
			client_setwfact(c, mode, type)
		end
	end
end



return smart_resize
