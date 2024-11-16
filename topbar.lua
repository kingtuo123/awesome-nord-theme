local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi




local taglist   = require("widgets.taglist")
local tasklist  = require("widgets.tasklist")
local clock     = require("widgets.clock")
local promptbox = require("widgets.promptbox")
local music     = require("widgets.music")
local v2ray     = require("widgets.v2ray")
local weather   = require("widgets.weather")
local netspeed  = require("widgets.netspeed")
local mem		= require("widgets.mem")
local cpu		= require("widgets.cpu")
local disk      = require("widgets.disk")
local wifi      = require("widgets.wifi")
local volume    = require("widgets.volume")
local layoutbox = require("widgets.layoutbox")
local caps = require("widgets.caps")
local indicator = require("widgets.indicator")
local close = require("widgets.close")
local fcitx = require("widgets.fcitx")




local topbar = {}




function topbar:setup(s)
	promptbox:setup(s)
	s.topbar = awful.wibar({
		screen   = s,
		position = "top",
		ontop    = false,
		type     = "dock",
		height   = theme.topbar_height + theme.topbar_border_width,
		fg       = theme.topbar_fg, 
		bg       = theme.topbar_bg
	})
	s.topbar:setup {
		-- Left widgets
		layout = wibox.layout.align.vertical,
		nil,
		{















			{
				{
					{
						wifi:setup(11.5,13,13,11.5),
						left = theme.widget_border_width,
						widget = wibox.container.margin,
					},
					netspeed:setup(7.5,12,0,7.5),
					mem:setup(4,8,10,4),
					cpu:setup(4,8,9,4),
					layout = wibox.layout.fixed.horizontal,
				},
				nil,
				{
					caps:setup(0,10,10,0),
					fcitx:setup(0,10,10,0),
					indicator:setup(0,8,8,0),
					{
						layoutbox:setup(s,10,11,11,10),
						right = 0 - theme.widget_border_width,
						widget = wibox.container.margin,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				forced_width = dpi(835),
				layout = wibox.layout.align.horizontal,
			},
			taglist:setup(s),
			{ 
				{
					clock:setup(0,12,12,0),
					weather:setup(0,12,12,0),
					volume:setup(9,10,10,9),
					layout = wibox.layout.fixed.horizontal,
				},
				nil,
				{
					tasklist:setup(s),
					music:setup(0,10,10,0),
					disk:setup(8,10,10,8),
					v2ray:setup(9,10,10,9),
					close:setup(9,13,13,9),
					layout = wibox.layout.fixed.horizontal,
				},
				forced_width = dpi(835),
				layout = wibox.layout.align.horizontal,
			},
			layout = wibox.layout.align.horizontal,











		},

		{
			{
				{
					forced_height = theme.topbar_border_width,
					widget = wibox.container.margin,
				},
				bg = theme.topbar_border_color,
				widget = wibox.container.background,
			},
			layout = wibox.layout.align.vertical,

		},
	}
end




return topbar
