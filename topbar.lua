local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local taglist   = require("widgets.taglist")
local tasklist  = require("widgets.tasklist")
local clock     = require("widgets.clock")
local promptbox = require("widgets.promptbox")
--local netspeed  = require("widgets.netspeed")
local mem		= require("widgets.mem")
--local cpu		= require("widgets.cpu")
--local gpu       = require("widgets.gpu")
local disk      = require("widgets.disk")
local vpn       = require("widgets.vpn")
--local wifi      = require("widgets.wifi")
local volume    = require("widgets.volume")
--local battery   = require("widgets.battery")
--local panel     = require("widgets.panel")
local layoutbox = require("widgets.layoutbox")



local topbar = {}


topbar.setup = function(s)
	promptbox.setup(s)
	s.topbar = awful.wibar({
		screen   = s,
		position = "top",
		ontop    = false,
		type     = "dock",
		height   = theme.topbar_height,
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
				forced_width = dpi(895),
				--forced_width = dpi(820.5),
				taglist.setup(s),
				{
					layout = wibox.layout.align.horizontal,
					forced_width = dpi(3)
				},
				tasklist.setup(s),
			},
			clock.setup(),
			{ 
				layout = wibox.layout.align.horizontal,
				forced_width = dpi(895),
				--forced_width = dpi(820.5),
				nil,
				nil,
				{
					-- Right widgets
					layout = wibox.layout.fixed.horizontal,
					--netspeed.setup(5,6,0,5),
					mem.setup(4,4,4,4),
					--cpu.setup(4,4,4,4),
					--gpu.setup(4,4,4,4),
					disk.setup(10,8,8,10),
					vpn.setup(9.5,9,9,9.5),
					--wifi.setup(10,8,8,10),
					volume.setup(8,5,5,8),
					--battery.setup(9,6,5,9),
					--clock.setup(_,6,6,_),
					layoutbox.setup(s,9,9,9,9),
				}
			}
		},
		{
			{
				{
					forced_height = dpi(1),
					widget = wibox.container.margin,
				},
				bg = theme.border_normal,
				widget = wibox.container.background,
			},
			layout = wibox.layout.align.vertical,

		},
	}
end



return topbar
