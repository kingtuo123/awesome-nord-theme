local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local taglist = {}


local tag_clicked = false
taglist.buttons = gears.table.join(
	awful.button({        }, 1, function(t)
		t:view_only() 
		tag_clicked = true 
	end),
	awful.button({ "Mod4" }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
		t:view_only() 
		tag_clicked = true 
	end),
	awful.button({        }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({        }, 5, function(t) awful.tag.viewprev(t.screen) end),
	awful.button({        }, 9, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({        }, 8, function(t) awful.tag.viewprev(t.screen) end)
)


taglist.setup = function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
	taglist.widget = awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.all,
		style   = {
			shape_border_width = theme.taglist_border_width,
			--shape_border_color = theme.taglist_border_color,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
			end,
		},
		widget_template = {
			{
				{
					{
						{
							id     = 'text_role',
							widget = wibox.widget.textbox,
						},
						valign = 'center',
						halign = 'center',
						widget = wibox.container.place,
					},
					{
						{
							{
								id = "line",
								text = "",
								forced_width = theme.taglist_width,
								widget = wibox.widget.textbox,
							},
							id = "linebg",
							bg = "#00000000",
							widget = wibox.container.background,
						},
						halign = 'center',
						valign = 'top',
						widget = wibox.container.place,
					},
					{
                        id     = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
					layout = wibox.layout.stack,
				},
				id     = "background_role",
				widget = wibox.container.background,
			},
			top	   = dpi(0),
			bottom = dpi(0),
			left   = dpi(0),
			right  = dpi(0),
			widget = wibox.container.margin,
			create_callback = function(self, c3, index, objects)
				self:connect_signal("mouse::enter", function()
					tag_clicked = false
					if self.background_role.bg ~= theme.taglist_bg_hover  then
						self.backup     = self.background_role.bg
						self.has_backup = true
					end
					self.background_role.bg = theme.taglist_bg_hover 
				end)
				self:connect_signal("mouse::leave", function()
					if self.has_backup then 
						if tag_clicked == false then
							self.background_role.bg = self.backup 
						else
							tag_clicked = false
							self.background_role.bg = theme.taglist_bg_focus
						end
					end
				end)
			end,
		},
		buttons = taglist.buttons
	}

	return taglist.widget
end





return taglist
