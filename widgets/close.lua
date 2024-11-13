local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi

local quake    = require("widgets.quake")

local close = {}


close.widget = wibox.widget{
	{
		{
			{
				image = theme.close_icon,
				widget = wibox.widget.imagebox,
			},
			valign = "center",
			halign = "center",
			forced_height = dpi(9),
			forced_width = dpi(9),
			widget = wibox.container.place,
		},
		id      = "margin",
		widget	= wibox.container.margin
	},
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
	end,
	shape_border_width = theme.widget_border_width,
	shape_border_color = theme.widget_border_color,
	bg = theme.widget_bg,
	widget = wibox.container.background,
}

close.popup = awful.popup{
	widget          = wibox.widget.textbox(" "),
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.close_mask_bg,
	fg				= theme.popup_fg,
	minimum_width   = dpi(0),
	minimum_height  = dpi(0),
	opacity         = theme.close_mask_opacity,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end
}


function close:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	self.widget:connect_signal('mouse::enter',function() 
		close.hover = true
		self.widget.bg = theme.widget_bg_hover
		local c = client.focus
		if c == nil then return end
		self.popup.x = c.x
		self.popup.y = c.y
		self.popup.minimum_width = c.width
		self.popup.minimum_height = c.height
		self.popup.visible = true
	end)
	self.widget:connect_signal('mouse::leave',function() 
		close.hover = false
		self.widget.bg = theme.widget_bg
		self.popup.visible = false
		self.popup.x = 0
		self.popup.y = 0
		self.popup.minimum_width = 0
		self.popup.minimum_height = 0
	end)

	self.widget:buttons(awful.util.table.join(
		awful.button({}, 2, nil, function() 
			local c = client.focus
			if c == nil then return end
			self.popup.visible = false
			c:kill()
		end),
		awful.button({}, 3, nil, function() 
			local c = client.focus
			if c == nil then return end
			if c.class == "QuakeDD" then
				awful.screen.focused().quake:toggle()
				return
			end
			self.popup.visible = false
			c.minimized = true
		end),
		awful.button({}, 4, nil, function() 
			awful.client.focus.byidx(-1)
		end),
		awful.button({}, 5, nil, function() 
			awful.client.focus.byidx(1)
		end)
	))

	return wibox.widget{
		self.widget,
		left = 0-theme.widget_border_width,
		widget = wibox.container.margin
	}
end


return close
