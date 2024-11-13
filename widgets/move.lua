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




local function anchor_get(c, direct)
	local a = {}
	local s = awful.screen.focused()



	local ml = theme.useless_gap*2
	local mt = theme.useless_gap*2
	if s.topbar.visible then
		mt = theme.topbar_height + theme.topbar_border_width + theme.useless_gap * 2
	end

	local dx = (c.x - ml) - (s.geometry.width  - (c.x + c.width ) - theme.useless_gap*2)
	local dy = (c.y - mt) - (s.geometry.height - (c.y + c.height) - theme.useless_gap*2)

	if c.x < theme.useless_gap * 2 then
		a.x = 0
	elseif c.x + c.width > s.geometry.width - theme.useless_gap*2 then
		a.x = 4
	elseif dx < (c.width - s.geometry.width) / 3 then
		a.x = 1
	elseif dx > (s.geometry.width - c.width) / 3 then
		a.x = 3
	else
		a.x = 2
	end
	if c.y < mt then
		a.y = 0
	elseif c.y + c.height > s.geometry.height - theme.useless_gap*2 then
		a.y = 4
	elseif dy < (c.height - s.geometry.height + mt) / 3 then
		a.y = 1
	elseif dy > (s.geometry.height - c.height - mt) / 3 then
		a.y = 3
	else
		a.y = 2
	end
	if direct == "left" then
		a.x = a.x - 1
	elseif direct == "right" then
		a.x = a.x + 1
	elseif direct == "up" then
		a.y = a.y - 1
	elseif direct == "down" then
		a.y = a.y + 1
	end
	if a.x < 1 then a.x = 1 end
	if a.x > 3 then a.x = 3 end
	if a.y < 1 then a.y = 1 end
	if a.y > 3 then a.y = 3 end
	return a
end




local function smart_move(c, direct)
	if c.fullscreen or c.maximized then return end
	local s = awful.screen.focused()
	local l = awful.layout.get(s)
	if c.floating or l == awful.layout.suit.floating then
		local a = anchor_get(c, direct)
		if s.topbar.visible then
			anchor_set[a.x][a.y](c, theme.topbar_height + theme.useless_gap * 2)
		else
			anchor_set[a.x][a.y](c, theme.useless_gap*2)
		end
	else
		awful.client.swap.bydirection(direct)
	end
end



return smart_move
