local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local layoutbox = {}


layoutbox.setup = function(s,mt,ml,mr,mb)
	layoutbox.widget = wibox.widget{
		{
			awful.widget.layoutbox(s),
			id      = "margin",
			widget	= wibox.container.margin
		},
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
		end,
		shape_border_width = theme.widget_border_width,
		shape_border_color = theme.widget_border_color,
		widget = wibox.container.background,
	}

	layoutbox.widget.margin.top    = dpi(mt or 0)
	layoutbox.widget.margin.left   = dpi(ml or 0)
	layoutbox.widget.margin.right  = dpi(mr or 0)
	layoutbox.widget.margin.bottom = dpi(mb or 0)

	layoutbox.widget:connect_signal('mouse::enter',function() 
		layoutbox.widget.bg = theme.widget_bg_hover
	end)
	layoutbox.widget:connect_signal('mouse::leave',function() 
		layoutbox.widget.bg = ""
	end)

	layoutbox.widget:buttons(gears.table.join(
		awful.button({ }, 1, function () awful.layout.inc( 1) end),
		awful.button({ }, 2, function () awful.layout.set(awful.layout.suit.floating) end),
		awful.button({ }, 3, function () awful.layout.inc(-1) end),
		awful.button({ }, 4, function () awful.layout.inc( 1) end),
		awful.button({ }, 5, function () awful.layout.inc(-1) end)
	))

	return  layoutbox.widget
end




return layoutbox
