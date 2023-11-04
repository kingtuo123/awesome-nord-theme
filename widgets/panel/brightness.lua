local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi
local battery = require("widgets.battery")


local panel_brightness = {}


panel_brightness.widget = wibox.widget{
	{
		{
			{
				id		= "icon",
				resize	= true,
				image	= theme.brightness_icon,
				forced_height = dpi(25),
				forced_width = dpi(25),
				widget	= wibox.widget.imagebox,
			},
			{
				id					= "bar",
				margins				= { top = dpi(5), bottom = dpi(5),  left = dpi(7),right = dpi(12) },
				max_value			= 100,
				value				= 0,
				bar_border_width	= 0,
				forced_width  		= dpi(235),
				--forced_height  		= dpi(20),
				color				= theme.panel_fg_progressbar,
				background_color	= theme.panel_bg_progressbar,
				shape				= function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, dpi(0))
				end,
				widget				= wibox.widget.progressbar,
			},
			{
				id		= "value",
				text	= "100%  ",
				font	= theme.font,
				--forced_width = dpi(35),
				halign = "center",
				--visible	= false,
				widget	= wibox.widget.textbox,
			},
			layout = wibox.layout.fixed.horizontal,
		},
		top    = dpi(11),
		left   = dpi(11),
		right  = dpi(0),
		bottom = dpi(11),
		id     = "margin",
		widget = wibox.container.margin
	},
	--shape = function(cr, width, height)
	--	gears.shape.rounded_rect(cr, width, height, theme.panel_rounded)
	--end,
	forced_height = dpi(40),
	forced_width  		= dpi(300),
	bg = theme.panel_bg_normal,
	--shape_border_width = theme.panel_border_width,
	shape_border_color = "",
	widget = wibox.container.background,

	set_value = function(self,val)
		self:get_children_by_id("value")[1].text = val
		self:get_children_by_id("bar")[1].value = tonumber(val)
	end,
	buttons = awful.util.table.join (
	awful.button({}, 4, function() 
		battery.brightness_up()
		panel_brightness.update()
	end),
	awful.button({}, 5, function() 
		battery.brightness_down()
		panel_brightness.update()
	end))
}


panel_brightness.widget:connect_signal('mouse::enter',function(self) 
	self.bg = theme.panel_bg_hover
end)
panel_brightness.widget:connect_signal('mouse::leave',function(self) 
	self.bg = theme.panel_bg_normal
end)
panel_brightness.widget:connect_signal('button::press',function(self) 
	self.bg = theme.panel_bg_normal
end)
panel_brightness.widget:connect_signal('button::release',function(self)
	self.bg = theme.panel_bg_hover
end)


panel_brightness.update = function()
	panel_brightness.widget.value = battery.widget.brightness
end













return panel_brightness
