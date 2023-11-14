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
		widget_template = {
			{
				{
					{
						{
							id     = 'my_icon_role',
							widget = wibox.widget.imagebox,
						},
						halign = 'center',
						valign = 'center',
						widget = wibox.container.place,
					},
					margins = dpi(2),
					widget  = wibox.container.margin,
				},
				{
					{
						{
							id            = "line",
							text          = "",
							forced_width  = theme.tasklist_line_width,
							forced_height = dpi(2),
							widget = wibox.widget.textbox,
						},
						id     = "linebg",
						bg     = theme.tasklist_bg_line,
						widget = wibox.container.background,
					},
					halign = 'center',
					valign = 'top',
					widget = wibox.container.place,
				},
				{
					text          = "",
					forced_width  = theme.tasklist_line_width,
					widget        = wibox.widget.textbox,
				},
				layout = wibox.layout.stack,
			},
			id = 'background_role',
			widget = wibox.container.background,

			create_callback = function(self,c)
				local my_icon_role = self:get_children_by_id('my_icon_role')[1]
				local line         = self:get_children_by_id('line')[1]
				local linebg       = self:get_children_by_id('linebg')[1]
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
					if c == client.focus then
						background_role.bg = theme.tasklist_bg_hover
						linebg.opacity     = 1
					elseif c.minimized then
						background_role.bg = theme.tasklist_bg_focus
						linebg.opacity     = 0
					else
						background_role.bg = theme.tasklist_bg_focus
					end
					line.forced_width = theme.tasklist_line_width
				end)
				local leave = function()
					if c.minimized then
						background_role.bg = theme.tasklist_bg_minimize
						linebg.opacity     = 0
					elseif c == client.focus then
						background_role.bg = theme.tasklist_bg_focus
						line.forced_width  = theme.tasklist_line_width
						linebg.opacity     = 1
					else
						line.forced_width  = theme.tasklist_line_width - dpi(10)
						background_role.bg = theme.tasklist_bg_normal
					end
				end
				self:connect_signal("mouse::leave", leave)
				c:connect_signal("untagged", function()
					self:disconnect_signal("mouse::leave", leave)
				end)
				c:connect_signal("unfocus", function()
					if c.minimized then
						linebg.opacity = 0
					else
						line.forced_width = theme.tasklist_line_width - dpi(10)
					end
				end)
				c:connect_signal("focus", function()
					line.forced_width = theme.tasklist_line_width
					linebg.opacity    = 1
				end)
			end
		}
	}
	return tasklist.widget
end








return tasklist
