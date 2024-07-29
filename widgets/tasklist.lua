local awful   = require("awful")
local wibox   = require("wibox")
local gears   = require("gears")
local theme   = require("theme")
local menubar = require("menubar")
local dpi	  = require("beautiful.xresources").apply_dpi


local tasklist = {}


tasklist.buttons = gears.table.join(
	awful.button({ }, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal( "request::activate", "tasklist", {raise = true})
		end
	end),
	awful.button({ }, 2, function(c) c:kill() end),
	awful.button({ }, 4, function( ) awful.client.focus.byidx(1) end),
	awful.button({ }, 5, function( ) awful.client.focus.byidx(-1) end)
)


tasklist.setup = function(s)
	tasklist.widget = awful.widget.tasklist {
		screen   = s,
		filter   = awful.widget.tasklist.filter.currenttags,
		buttons  = tasklist.buttons,
		widget_template = {
			{
				{
					{
						id = 'my_icon_role',
						forced_width  = theme.tasklist_icon_size,
						forced_height = theme.tasklist_icon_size,
						widget = wibox.widget.imagebox,
					},
					halign = 'center',
					valign = 'center',
					forced_width = theme.tasklist_width,
					widget = wibox.container.place,
				},
				id = 'background_role',
				widget = wibox.container.background,
			},
			widget = wibox.container.background,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
			end,
			shape_border_width = theme.widget_border_width,
			shape_border_color = theme.widget_border_color,

			create_callback = function(self, c)
				local my_icon_role = self:get_children_by_id('my_icon_role')[1]
				local lookup       = menubar.utils.lookup_icon
				 if c.instance == nil then
					my_icon_role.image = lookup("application-default-icon") or lookup("setting")
				else
					my_icon_role.image = lookup(c.instance) or lookup(c.class) or lookup(c.class:lower()) or lookup("application-default-icon") or lookup("setting")
				end
			end
		}
	}
	return tasklist.widget
end


return tasklist
