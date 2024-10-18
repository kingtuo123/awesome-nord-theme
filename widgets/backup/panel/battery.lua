local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local battery = require("widgets.battery")

local panel_battery = {}

panel_battery.widget = wibox.widget{
	{
		{
			{
				id = "mytb1",
				text   = "100%  ",
				font   = theme.font,
				valign = "top",
				widget = wibox.widget.textbox
			},
			{
				id     = "myib",
				image  = theme.bat_100_icon,
				resize = true,
				forced_height = dpi(30),
				forced_width  = dpi(30),
				widget = wibox.widget.imagebox
			},
			{
				id = "mytb2",
				text   = "",
				font   = theme.font,
				valign = "center",
				visible = false,
				widget = wibox.widget.textbox
			},
			layout = wibox.layout.fixed.horizontal,
		},
		top    = dpi(0),
		left   = dpi(0),
		right  = dpi(0),
		bottom = dpi(0),
		id     = "margin",
		widget = wibox.container.margin
	},
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.panel_rounded)
	end,

	forced_height = dpi(30),
	--forced_width = dpi(100),
	--bg = theme.panel_bg_normal,
	bg = "",
	shape_border_width = theme.panel_border_width,
	shape_border_color = "",
	widget = wibox.container.background,

	set_value = function(self,val)
		self:get_children_by_id("mytb1")[1].text = val .. "%  "
	end,
	set_icon = function(self,img)
		self:get_children_by_id("myib")[1].image  = img
	end,
	set_status = function(self,val)
		self:get_children_by_id("mytb2")[1].text = " • " .. val
	end,
	set_width = function(self,w)
		self:get_children_by_id("myib")[1].forced_width  = w
	end,
	set_height = function(self,h)
		self.forced_height = h
	end
}



panel_battery.update = function()
	panel_battery.widget.icon   = battery.widget.icon
	panel_battery.widget.value  = battery.widget.capacity
	panel_battery.widget.status = battery.widget.status
end












return panel_battery
