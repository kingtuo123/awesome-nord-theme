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
					widget = wibox.container.place,
				},
				id     = "background_role",
				forced_width = theme.taglist_width - dpi(2),
				forced_height = theme.taglist_width,
				widget = wibox.container.background,
			},
			--shape = function(cr, width, height)
			--	 gears.shape.circle(cr, width, height, dpi(10))
			--end,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
			end,
			widget = wibox.container.background,
		}
	})
	local t = wibox.widget{
		{
			{
				{
					widget = self.widget,
				},
				top = dpi(3),
				bottom = dpi(3),
				left = dpi(3),
				right = dpi(3),
				widget = wibox.container.margin,
			},
			bg = theme.taglist_bg_empty,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
			end,
			widget = wibox.container.background,
		},
		top = dpi(3),
		bottom = dpi(3),
		left = dpi(3),
		right = dpi(3),
		widget = wibox.container.margin,
	}
	return t
end




return taglist
