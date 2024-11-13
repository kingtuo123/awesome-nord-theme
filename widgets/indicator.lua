local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi




local indicator = {}



indicator.widget = wibox.widget{
	{
		{
			{
				{
					{
						text	= "F",
						valign = "center",
						halign = "center",
						font    = theme.indicator_font,
						widget	= wibox.widget.textbox,
					},
					id = "mode",
					shape = function(cr, width, height)
						gears.shape.rounded_rect(cr, width, height, theme.indicator_rounded)
					end,
					fg = theme.indicator_fg,
					bg = theme.indicator_bg_inactive,
					forced_width = theme.indicator_width,
					forced_height = theme.indicator_width,
					widget = wibox.container.background,
				},
				top = theme.indicator_margin_top,
				bottom = theme.indicator_margin_bottom,
				left = theme.indicator_margin_left,
				right = theme.indicator_margin_right,
				widget  = wibox.container.margin,
			},
			{
				{
					{
						text	= "T",
						valign = "center",
						halign = "center",
						font    = theme.indicator_font,
						widget	= wibox.widget.textbox,
					},
					id = "mode",
					shape = function(cr, width, height)
						gears.shape.rounded_rect(cr, width, height, theme.indicator_rounded)
					end,
					fg = theme.indicator_fg,
					bg = theme.indicator_bg_inactive,
					forced_width = theme.indicator_width,
					forced_height = theme.indicator_width,
					widget = wibox.container.background,
				},
				top = theme.indicator_margin_top,
				bottom = theme.indicator_margin_bottom,
				left = theme.indicator_margin_left,
				right = theme.indicator_margin_right,
				widget  = wibox.container.margin,
			},
			{
				{
					{
						text	= "S",
						valign = "center",
						halign = "center",
						font    = theme.indicator_font,
						widget	= wibox.widget.textbox,
					},
					id = "mode",
					shape = function(cr, width, height)
						gears.shape.rounded_rect(cr, width, height, theme.indicator_rounded)
					end,
					fg = theme.indicator_fg,
					bg = theme.indicator_bg_inactive,
					forced_width = theme.indicator_width,
					forced_height = theme.indicator_width,
					widget = wibox.container.background,
				},
				top = theme.indicator_margin_top,
				bottom = theme.indicator_margin_bottom,
				left = theme.indicator_margin_left,
				right = theme.indicator_margin_right,
				widget  = wibox.container.margin,
			},
			{
				{
					{
						text	= "M",
						valign = "center",
						halign = "center",
						font    = theme.indicator_font,
						widget	= wibox.widget.textbox,
					},
					id = "mode",
					shape = function(cr, width, height)
						gears.shape.rounded_rect(cr, width, height, theme.indicator_rounded)
					end,
					fg = theme.indicator_fg,
					bg = theme.indicator_bg_inactive,
					forced_width = theme.indicator_width,
					forced_height = theme.indicator_width,
					widget = wibox.container.background,
				},
				top = theme.indicator_margin_top,
				bottom = theme.indicator_margin_bottom,
				left = theme.indicator_margin_left,
				right = theme.indicator_margin_right,
				widget  = wibox.container.margin,
			},
			layout = wibox.layout.fixed.horizontal,
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



function indicator:clear()
	local m = self.widget:get_children_by_id("mode")
	m[1].bg = theme.indicator_bg_inactive
	m[2].bg = theme.indicator_bg_inactive
	m[3].bg = theme.indicator_bg_inactive
	m[4].bg = theme.indicator_bg_inactive
end



function indicator:update()
	local c = client.focus
	local m = self.widget:get_children_by_id("mode")
	if c.floating then
		m[1].bg = theme.indicator_bg
	else
		m[1].bg = theme.indicator_bg_inactive
	end
	if c.ontop then
		m[2].bg = theme.indicator_bg
	else
		m[2].bg = theme.indicator_bg_inactive
	end
	if c.sticky then
		m[3].bg = theme.indicator_bg
	else
		m[3].bg = theme.indicator_bg_inactive
	end
	if c.maximized then
		m[4].bg = theme.indicator_bg
	else
		m[4].bg = theme.indicator_bg_inactive
	end
end




function indicator:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	self.widget:connect_signal('mouse::enter',function() 
		self.widget.bg = theme.widget_bg_hover
	end)
	self.widget:connect_signal('mouse::leave',function() 
		self.widget.bg = theme.widget_bg
	end)

	local m = self.widget:get_children_by_id("mode")

	m[1]:buttons(awful.util.table.join(
		awful.button({}, 1, nil, function() 
			local c = client.focus
			if c == nil then return end
			c.floating = not c.floating
			self:update()
		end)
	))
	m[2]:buttons(awful.util.table.join(
		awful.button({}, 1, nil, function() 
			local c = client.focus
			if c == nil then return end
			c.ontop = not c.ontop
			self:update()
		end)
	))
	m[3]:buttons(awful.util.table.join(
		awful.button({}, 1, nil, function() 
			local c = client.focus
			if c == nil then return end
			c.sticky = not c.sticky
			self:update()
		end)
	))
	m[4]:buttons(awful.util.table.join(
		awful.button({}, 1, nil, function() 
			local c = client.focus
			if c == nil then return end
			c.maximized = not c.maximized
			self:update()
		end)
	))

	return wibox.widget{
		self.widget,
		left = 0-theme.widget_border_width,
		widget = wibox.container.margin
	}
end


return indicator
