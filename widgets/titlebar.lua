local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


awful.titlebar.enable_tooltip = false
local titlebar = {}


titlebar.setup = function(c)
	titlebar.widget = awful.titlebar(c, {
		size = theme.titlebar_height,
	})

	titlebar.buttons = gears.table.join(
		awful.button({ }, 1, function()
			c:emit_signal("request::activate", "titlebar", {raise = true})
			awful.mouse.client.move(c)
		end),
		awful.button({ }, 2, function()
			--c.maximized = not c.maximized
			c:emit_signal("request::activate", "titlebar", {raise = true})
			--awful.mouse.client.move(c)
			awful.titlebar.toggle(c)
		end),
		awful.button({ }, 3, function()
			c:emit_signal("request::activate", "titlebar", {raise = true})
			if (mouse.screen.selected_tag.layout.name == "floating" or c.floating) and not c.maximized then
				awful.mouse.client.resize(c)
			end
		end)
	)

	titlebar.widget:setup{
		{ -- Left
			{
				awful.titlebar.widget.floatingbutton (c),
				wibox.container.margin(_,dpi(7)),
				awful.titlebar.widget.ontopbutton    (c),
				wibox.container.margin(_,dpi(7)),
				awful.titlebar.widget.stickybutton   (c),
				layout = wibox.layout.fixed.horizontal(),
			},
			margins = dpi(7),
			widget = wibox.container.margin,
		},

		{ -- Middle
			{
				align  = 'center',
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = titlebar.buttons,
			layout  = wibox.layout.flex.horizontal
		},

		{ -- Right
			{
				awful.titlebar.widget.minimizebutton (c),
				wibox.container.margin(_, _, dpi(7)),
				awful.titlebar.widget.maximizedbutton(c),
				wibox.container.margin(_, _, dpi(7)),
				awful.titlebar.widget.closebutton    (c),
				layout = wibox.layout.fixed.horizontal(),
			},
			margins = dpi(7),
			widget = wibox.container.margin,
		},
		layout = wibox.layout.align.horizontal
	}
	return titlebar.widget
end





return titlebar
