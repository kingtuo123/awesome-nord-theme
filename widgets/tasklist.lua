local awful   = require("awful")
local wibox   = require("wibox")
local gears   = require("gears")
local theme   = require("theme")
local menubar = require("menubar")
local dpi	  = require("beautiful.xresources").apply_dpi


local tasklist = {}


tasklist.buttons = gears.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal( "request::activate", "tasklist", {raise = true})
		end
	end),
	awful.button({ }, 2, function(c)
		c:kill() 
	end),
	awful.button({ }, 3, function()
		--awful.menu.client_list()
	end),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
	end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
	end)
)


tasklist.setup = function(s)
	tasklist.widget = awful.widget.tasklist {
		screen   = s,
		filter   = awful.widget.tasklist.filter.currenttags,
		buttons  = tasklist.buttons,
		style   = {
			shape_border_width = dpi(0),
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, dpi(0))
			end,
		},
		widget_template = {
			{
				{
					{
						{
							id     = 'my_icon_role',
							forced_width  = theme.tasklist_icon_size,
							forced_height  = theme.tasklist_icon_size,
							widget = wibox.widget.imagebox,
						},
						halign = 'center',
						valign = 'center',
						widget = wibox.container.place,
					},
					margins = dpi(0),
					widget  = wibox.container.margin,
				},
				{
					text          = "",
					forced_width  = theme.tasklist_width,
					widget        = wibox.widget.textbox,
				},
				layout = wibox.layout.stack,
			},
			id = 'background_role',
			widget = wibox.container.background,

			create_callback = function(self,c)
				local my_icon_role = self:get_children_by_id('my_icon_role')[1]
				local lookup       = menubar.utils.lookup_icon
			 -- local icon         = lookup(c.class) or lookup(c.class:lower())
				 if c.instance == nil then
					icon = menubar.utils.lookup_icon("application-default-icon")
				else
					icon = lookup(c.instance) or lookup(c.class)
				end
				if icon ~= nil then
					my_icon_role.image = icon
				else
					my_icon_role.image = menubar.utils.lookup_icon("application-default-icon")
				end
				local background_role = self:get_children_by_id('background_role')[1]
				self:connect_signal("mouse::enter", function()
					background_role.bg = theme.tasklist_bg_hover
				end)
				local leave = function()
					if c.minimized then
						background_role.bg = theme.tasklist_bg_minimize
					elseif c == client.focus then
						background_role.bg = theme.tasklist_bg_focus
					else
						background_role.bg = theme.tasklist_bg_normal
					end
				end
				self:connect_signal("mouse::leave", leave)
				c:connect_signal("untagged", function()
					self:disconnect_signal("mouse::leave", leave)
				end)
				c:connect_signal("unfocus", function()
				end)
				c:connect_signal("focus", function()
				end)
			end
		}
	}
	return tasklist.widget
end








return tasklist
