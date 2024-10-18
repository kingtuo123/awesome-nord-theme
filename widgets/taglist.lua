local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi




local taglist = {}




taglist.buttons = gears.table.join(
	awful.button({ "Mod4" }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end t:view_only() end),
	awful.button({}, 1, function(t) t:view_only() end),
	awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end),
	awful.button({}, 9, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({}, 8, function(t) awful.tag.viewprev(t.screen) end)
)




function taglist:setup(s)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }, s, awful.layout.layouts[1])
	self.widget = awful.widget.taglist({
		screen  = s,
		buttons = self.buttons,
		filter  = awful.widget.taglist.filter.all,
		widget_template = {
			{
				{
					{
						id     = 'text_role',
						font   = theme.taglist_font,
						widget = wibox.widget.textbox,
					},
					valign = 'center',
					halign = 'center',
					forced_width = theme.taglist_width,
					widget = wibox.container.place,
				},
				id     = "background_role",
				widget = wibox.container.background,
			},
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
			end,
			shape_border_width = theme.widget_border_width,
			shape_border_color = theme.widget_border_color,
			widget = wibox.container.background,
		}
	})
	return self.widget
end




return taglist
