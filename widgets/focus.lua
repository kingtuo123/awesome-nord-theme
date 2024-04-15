local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local focus = {}

focus_width = dpi(6)
focus_length = dpi(30)
focus_normal_color = "#62b6cb"
focus_ontop_color = "#80b918"
focus_maximized_color = "#f3722c"

focus.timer = gears.timer {
	timeout   = 2,
	call_now  = false,
	autostart = false,
	callback  = function(self)
		print("clean focus")
		self:stop()
		focus.top_lv.visible = false
		focus.top_lh.visible = false
		focus.top_rv.visible = false
		focus.top_rh.visible = false
		focus.bottom_lv.visible = false
		focus.bottom_lh.visible = false
		focus.bottom_rv.visible = false
		focus.bottom_rh.visible = false
	end
}


focus.top_lv = wibox{
	width = focus_width,
	height =focus_length,
	bg = focus_normal_color,
	type = "normal",
	visible = false,
	ontop = true,
}

focus.top_lh = wibox{
	width = focus_length,
	height =focus_width,
	bg = focus_normal_color,
	type = "normal",
	visible = false,
	ontop = true,
}

focus.top_rv = wibox{
	width = focus_width,
	height =focus_length,
	bg = focus_normal_color,
	type = "normal",
	visible = false,
	ontop = true,
}

focus.top_rh = wibox{
	width = focus_length,
	height =focus_width,
	bg = focus_normal_color,
	type = "normal",
	visible = false,
	ontop = true,
}

focus.bottom_lv = wibox{
	width = focus_width,
	height =focus_length,
	bg = focus_normal_color,
	type = "normal",
	visible = false,
	ontop = true,
}

focus.bottom_lh = wibox{
	width = focus_length,
	height =focus_width,
	bg = focus_normal_color,
	type = "normal",
	visible = false,
	ontop = true,
}

focus.bottom_rv = wibox{
	width = focus_width,
	height =focus_length,
	bg = focus_normal_color,
	type = "normal",
	visible = false,
	ontop = true,
}

focus.bottom_rh = wibox{
	width = focus_length,
	height =focus_width,
	bg = focus_normal_color,
	type = "normal",
	visible = false,
	ontop = true,
}

focus.invisible = function()
	focus.top_lv.visible = false
	focus.top_lh.visible = false
	focus.top_rv.visible = false
	focus.top_rh.visible = false
	focus.bottom_lv.visible = false
	focus.bottom_lh.visible = false
	focus.bottom_rv.visible = false
	focus.bottom_rh.visible = false
end

focus.setup = function(c)
	s = awful.screen.focused()
	if c.maximized then 
		focus_color = focus_maximized_color
	elseif c.ontop then
		focus_color = focus_ontop_color
	else
		focus_color = focus_normal_color
	end

	focus.top_lv.x = c.x - focus_width
	focus.top_lv.y = c.y - focus_width
	focus.top_lh.x = c.x - focus_width
	focus.top_lh.y = c.y - focus_width

	focus.top_rv.x = c.x + c.width + theme.border_width * 2
	focus.top_rv.y = c.y - focus_width
	focus.top_rh.x = c.x + c.width - focus_length + focus_width + theme.border_width
	focus.top_rh.y = c.y - focus_width

	focus.bottom_lv.x = focus.top_lv.x
	focus.bottom_lv.y = focus.top_lv.y + c.height - focus_length + focus_width * 2 + theme.border_width * 2
	focus.bottom_lh.x = focus.top_lh.x
	focus.bottom_lh.y = focus.top_lh.y + c.height + focus_width + theme.border_width * 2

	focus.bottom_rv.x = focus.top_rv.x
	focus.bottom_rv.y = focus.bottom_lv.y
	focus.bottom_rh.x = focus.top_rh.x
	focus.bottom_rh.y = focus.bottom_lh.y

	if focus.top_lv.x < 0 then
		focus.top_lv.x = 0
		focus.top_lh.x = 0
		focus.bottom_lv.x = 0
		focus.bottom_lh.x = 0
	end

	if focus.top_lv.y < theme.topbar_height then
		focus.top_lv.y = theme.topbar_height
		focus.top_lh.y = theme.topbar_height
		focus.top_rv.y = theme.topbar_height
		focus.top_rh.y = theme.topbar_height
	end


	if focus.top_rv.x + focus_width > s.geometry.width then
		focus.top_rv.x = s.geometry.width - focus_width
		focus.top_rh.x = s.geometry.width - focus_length
		focus.bottom_rv.x = focus.top_rv.x
		focus.bottom_rh.x = focus.top_rh.x
	end

	if focus.bottom_lh.y + focus_width > s.geometry.height then
		focus.bottom_lh.y = s.geometry.height - focus_width
		focus.bottom_lv.y = s.geometry.height - focus_length
		focus.bottom_rh.y = s.geometry.height - focus_width
		focus.bottom_rv.y = s.geometry.height - focus_length
	end

	focus.top_lv.bg = focus_color
	focus.top_lh.bg = focus_color

	focus.top_rv.bg = focus_color
	focus.top_rh.bg = focus_color

	focus.bottom_lv.bg = focus_color
	focus.bottom_lh.bg = focus_color

	focus.bottom_rv.bg = focus_color
	focus.bottom_rh.bg = focus_color

	focus.top_lv.visible = true
	focus.top_lh.visible = true

	focus.top_rv.visible = true
	focus.top_rh.visible = true

	focus.bottom_lv.visible = true
	focus.bottom_lh.visible = true

	focus.bottom_rv.visible = true
	focus.bottom_rh.visible = true

	focus.timer:again()

end


return focus
