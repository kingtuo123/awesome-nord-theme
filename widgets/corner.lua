local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi

local corner = {}

local corner_bg = "#00000000"

function corner:setup(s)

	self.top_l = awful.popup{
		screen = s,
		x = dpi(0),
		y = theme.topbar_height + theme.topbar_border_width,
		bg = corner_bg,
		type = "desktop",
		widget = wibox.widget{
			{
				id			  = "icon",
				image		  = theme.corner_icon,
				widget		  = wibox.widget.imagebox,
			},
			forced_width  = theme.corner_size,
			forced_height = theme.corner_size,
			direction = "north",
			widget = wibox.container.rotate
		}
	}

	self.top_r = awful.popup{
		screen = s,
		x = s.geometry.width - theme.corner_size,
		y = theme.topbar_height + theme.topbar_border_width,
		bg = corner_bg,
		type = "desktop",
		widget = wibox.widget{
			{
				id			  = "icon",
				image		  = theme.corner_icon,
				widget		  = wibox.widget.imagebox,
			},
			forced_width  = theme.corner_size,
			forced_height = theme.corner_size,
			direction = "west",
			widget = wibox.container.rotate
		}
	}

	self.bot_l = awful.popup{
		screen = s,
		x = 0,
		y = s.geometry.height - theme.corner_size,
		bg = corner_bg,
		type = "desktop",
		widget = wibox.widget{
			{
				id			  = "icon",
				image		  = theme.corner_icon,
				widget		  = wibox.widget.imagebox,
			},
			forced_width  = theme.corner_size,
			forced_height = theme.corner_size,
			direction = "east",
			widget = wibox.container.rotate
		}
	}

	self.bot_l = awful.popup{
		screen = s,
		x = s.geometry.width - theme.corner_size,
		y = s.geometry.height - theme.corner_size,
		bg = corner_bg,
		type = "desktop",
		widget = wibox.widget{
			{
				id			  = "icon",
				image		  = theme.corner_icon,
				widget		  = wibox.widget.imagebox,
			},
			forced_width  = theme.corner_size,
			forced_height = theme.corner_size,
			direction = "south",
			widget = wibox.container.rotate
		}
	}

	return self
end


return corner
