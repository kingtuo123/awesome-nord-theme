local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local taglist   = require("widgets.taglist")
local tasklist  = require("widgets.tasklist")
local clock     = require("widgets.clock")
local promptbox = require("widgets.promptbox")
local netspeed  = require("widgets.netspeed")
local mem		= require("widgets.mem")
local cpu		= require("widgets.cpu")
local gpu       = require("widgets.gpu")
local disk      = require("widgets.disk")
local vpn       = require("widgets.vpn")
local wifi      = require("widgets.wifi")
local volume    = require("widgets.volume")
local battery   = require("widgets.battery")
local panel     = require("widgets.panel")
local layoutbox = require("widgets.layoutbox")


local topbar = {}


topbar.setup = function(s)
	promptbox.setup(s)
	s.topbar = awful.wibar({
		screen   = s,
		position = "top",
		height   = theme.topbar_height,
		fg       = theme.fg, 
		bg       = theme.bg
	})
	s.topbar:setup {
		-- Left widgets
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			forced_width = dpi(900),
			taglist.setup(s),
			wibox.widget.textbox("  "),
			tasklist.setup(s),
			wibox.widget.textbox("  "),
		},

		clock.setup(),

		{ 
			layout = wibox.layout.align.horizontal,
			forced_width = dpi(900),
			nil,
			nil,
			{
				-- Right widgets
				layout = wibox.layout.fixed.horizontal,
				netspeed.setup(6,8,0,6),
				mem.setup(5,6,6,5),
				cpu.setup(5,6,6,5),
				gpu.setup(5,6,6,5),
				disk.setup(10,8,8,10),
				vpn.setup(9,8,8,9),
				{
					panel.setup(),
					{
						wifi.setup(10,10,10,10),
						volume.setup(8,3,5,8),
						battery.setup(9,6,8,9),
						layout = wibox.layout.fixed.horizontal,
					},
					layout	= wibox.layout.stack,
				},
				layoutbox.setup(s,9,8,8,9),
			}
		}
	}
end



return topbar
