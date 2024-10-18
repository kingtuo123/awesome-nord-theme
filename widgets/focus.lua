local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi




local focus = {}




focus_width = dpi(5)
focus_length = dpi(40)
focus_normal_color = "#86e1fc"
focus_floating_color = "#82aaff"
focus_ontop_color = "#c3e88d"
focus_maximized_color = "#ff757f"
focus_sticky_color = "#c099ff"




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




focus.timer = gears.timer {
	timeout   = 2,
	call_now  = false,
	autostart = false,
	callback  = function(self)
		--print("clean focus")
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




function focus:update(c, visible)
	if not visible then
		focus.top_lv.visible = false
		focus.top_lh.visible = false
		focus.top_rv.visible = false
		focus.top_rh.visible = false
		focus.bottom_lv.visible = false
		focus.bottom_lh.visible = false
		focus.bottom_rv.visible = false
		focus.bottom_rh.visible = false
		return
	end
	local s = awful.screen.focused()
	if c.sticky then
		focus_color = focus_sticky_color
	elseif c.maximized then 
		focus_color = focus_maximized_color
	elseif c.ontop then
		focus_color = focus_ontop_color
	elseif c.floating then
		focus_color = focus_floating_color
	else
		focus_color = focus_normal_color
	end

	top_lv_x = c.x - focus_width
	top_lv_y = c.y - focus_width
	top_lh_x = c.x - focus_width
	top_lh_y = c.y - focus_width

	top_rv_x = c.x + c.width + theme.border_width * 2
	top_rv_y = c.y - focus_width
	top_rh_x = c.x + c.width - focus_length + focus_width + theme.border_width
	top_rh_y = c.y - focus_width

	bottom_lv_x = top_lv_x
	bottom_lv_y = top_lv_y + c.height - focus_length + focus_width * 2 + theme.border_width * 2
	bottom_lh_x = top_lh_x
	bottom_lh_y = top_lh_y + c.height + focus_width + theme.border_width * 2

	bottom_rv_x = top_rv_x
	bottom_rv_y = bottom_lv_y
	bottom_rh_x = top_rh_x
	bottom_rh_y = bottom_lh_y

	if top_lv_x < 0 then
		top_lv_x = 0
		top_lh_x = 0
		bottom_lv_x = 0
		bottom_lh_x = 0
	end

	if top_lv_y < 0 or c.fullscreen then
		top_lv_y = 0 
		top_lh_y = 0 
		top_rv_y = 0 
		top_rh_y = 0 
	elseif top_lv_y == theme.topbar_height - focus_width and s.topbar.visible then
		top_lv_y = theme.topbar_height
		top_lh_y = theme.topbar_height
		top_rv_y = theme.topbar_height
		top_rh_y = theme.topbar_height
	end

	if top_rv_x + focus_width > s.geometry.width then
		top_rv_x = s.geometry.width - focus_width
		top_rh_x = s.geometry.width - focus_length
		bottom_rv_x = top_rv_x
		bottom_rh_x = top_rh_x
	end

	if bottom_lh_y + focus_width > s.geometry.height then
		bottom_lh_y = s.geometry.height - focus_width
		bottom_lv_y = s.geometry.height - focus_length
		bottom_rh_y = s.geometry.height - focus_width
		bottom_rv_y = s.geometry.height - focus_length
	end

	focus.top_lv.bg = focus_color
	focus.top_lh.bg = focus_color

	focus.top_rv.bg = focus_color
	focus.top_rh.bg = focus_color

	focus.bottom_lv.bg = focus_color
	focus.bottom_lh.bg = focus_color

	focus.bottom_rv.bg = focus_color
	focus.bottom_rh.bg = focus_color

	focus.top_lv.x = top_lv_x
	focus.top_lv.y = top_lv_y
	focus.top_lh.x = top_lh_x
	focus.top_lh.y = top_lh_y

	focus.top_rv.x = top_rv_x
	focus.top_rv.y = top_rv_y
	focus.top_rh.x = top_rh_x
	focus.top_rh.y = top_rh_y

	focus.bottom_lv.x = bottom_lv_x
	focus.bottom_lv.y = bottom_lv_y
	focus.bottom_lh.x = bottom_lh_x
	focus.bottom_lh.y = bottom_lh_y

	focus.bottom_rv.x = bottom_rv_x
	focus.bottom_rv.y = bottom_rv_y
	focus.bottom_rh.x = bottom_rh_x
	focus.bottom_rh.y = bottom_rh_y


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
