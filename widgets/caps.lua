local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi

local caps = {}

caps.widget = wibox.widget{
	{
		{
			{
				{
					id			= "icon",
					image		= theme.caps_off_icon,
					widget		= wibox.widget.imagebox,
				},
				valign = "center",
				halign = "center",
				forced_width = dpi(15),
				forced_height = dpi(15),
				widget  = wibox.container.place,
			},
			{
				left = dpi(0),
				right = dpi(7),
				widget  = wibox.container.margin,
			},
			{
				id			= "status",
				text		= "Unlock",
				font        = theme.caps_widget_off_font,
				visible		= true,
				widget		= wibox.widget.textbox,
			},
			layout = wibox.layout.fixed.horizontal,
		},
		id      = "margin",
		widget	= wibox.container.margin
	},
	set_icon = function(self, image)
		self:get_children_by_id("icon")[1].image = image
	end,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
	end,
	shape_border_width = theme.widget_border_width,
	shape_border_color = theme.widget_border_color,
	bg = theme.widget_bg,
	widget = wibox.container.background,
}


function caps:update()
	awful.spawn.easy_async_with_shell("xset q | grep Caps | awk -F ':' '{print $3}'", function(out)
		if string.match(out, "off") then
			self.widget:get_children_by_id("status")[1].text = "Unlock"
			self.widget:get_children_by_id("status")[1].font = theme.caps_widget_off_font
			self.widget.bg = theme.widget_bg
			self.widget.fg = theme.widget_fg
			self.widget.icon = theme.caps_off_icon
			--self.widget.shape_border_width = theme.widget_border_width
			caps.lock = false
		else
			self.widget:get_children_by_id("status")[1].text = "Locked"
			self.widget:get_children_by_id("status")[1].font = theme.caps_widget_on_font
			self.widget.bg = theme.caps_on_bg
			self.widget.fg = theme.caps_on_fg
			self.widget.icon = theme.caps_on_icon
			--self.widget.shape_border_width = theme.widget_border_width + dpi(2)
			caps.lock = true
		end
	end)
end


function caps:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	--self.widget:connect_signal('mouse::enter',function() 
	--	if self.lock then
	--		self.widget.bg = theme.caps_on_bg
	--		self.widget.shape_border_width = dpi(5)
	--	else
	--		self.widget.bg = theme.widget_bg_hover
	--		self.widget.shape_border_width = theme.widget_border_width
	--	end
	--end)
	--self.widget:connect_signal('mouse::leave',function() 
	--	if self.lock then
	--		self.widget.bg = theme.caps_on_bg
	--		self.widget.shape_border_width = dpi(5)
	--	else
	--		self.widget.bg = theme.widget_bg
	--		self.widget.shape_border_width = theme.widget_border_width
	--	end
	--end)

	self.widget:buttons(awful.util.table.join(
		awful.button({}, 1, nil, function() 
			self:update()
		end)
	))

	--gears.timer({
	--	timeout   = 10,
	--	call_now  = true,
	--	autostart = true,
	--	single_shot = true,
	--	callback  = function()
	--		self:update()
	--	end
	--})

	return wibox.widget{
		self.widget,
		left = 0-theme.widget_border_width,
		widget = wibox.container.margin
	}
end


return caps
