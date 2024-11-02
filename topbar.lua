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
			layout = wibox.layout.align.horizontal,
			{
				layout = wibox.layout.fixed.horizontal,
				--forced_width = dpi(890),
				taglist:setup(s),
				{
					layout = wibox.layout.align.horizontal,
					forced_width = dpi(3)
				},
				tasklist:setup(s),
			},
			nil,
			{ 
				layout = wibox.layout.align.horizontal,
				--forced_width = dpi(890),
				nil,
				nil,
				{
					layout = wibox.layout.fixed.horizontal,
					-- margin_top, margin_left, margin_right, margin_bottom
					music:setup(0,12,8,0),
					v2ray:setup(8,15,15,8),
					weather:setup(0,12,18,0),
					netspeed:setup(6,6,0,6),
					mem:setup(4,2,10,4),
					cpu:setup(4,10,11,4),
					--disk:setup(11.5,15,15,11),
					disk:setup(11,15,15,11),
					wifi:setup(11,10,10,11),
					volume:setup(9,10,10,9),
					layoutbox:setup(s,10,10,10,10),
					clock:setup(0,12,12,0),
				}
			}
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
