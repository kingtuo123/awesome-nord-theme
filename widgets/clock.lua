local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local clock  = {}
local calendar = {}


calendar.month   = { 
	padding  = dpi(15),
	bg_color = theme.popup_bg,                
}
calendar.normal  = { 
	fg_color = theme.cal_fg_normal,
	markup	 = function(t) return t end,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.cal_rounded)
	end,
}                                                       
calendar.focus   = {
	fg_color = theme.cal_fg_focus,                
	bg_color = theme.cal_bg_focus,                
	markup   = function(t) return '<b>' .. t .. '</b>' end,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.cal_rounded)
	end,
}                                                       
calendar.header  = {
	fg_color = theme.cal_header_fg,                
	bg_color = theme.popup_bg,             
	markup   = function(t) return '<b>' .. t .. '</b>' end,
}                                                       
calendar.weekday = {
	fg_color = theme.cal_weekday_fg,                
	bg_color = theme.popup_bg,                
	markup   = function(t) return '<b>' .. t .. '</b>' end,
}


local function decorate_cell(widget, flag, date)
	if flag == "monthheader" and not calendar.monthheader then
		flag = "header"
	end
	local props = calendar[flag] or {}
	if props.markup and widget.get_text and widget.set_markup then
		widget:set_markup(props.markup(widget:get_text()))
	end
	-- Change bg color for weekends
	local d			 = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
	local weekday	 = tonumber(os.date("%w", os.time(d)))
	local default_bg = (weekday==0 or weekday==6) and theme.cal_week_06_bg or theme.popup_bg
	local ret 		 = wibox.widget {
		{
			{
				widget,
				halign = 'center',
				widget = wibox.container.place
			},
			margins = props.padding or theme.cal_default_padding,
			widget  = wibox.container.margin
		},
		shape        = props.shape,
		fg           = props.fg_color,
		bg           = props.bg_color or default_bg,
		widget       = wibox.container.background
	}
	return ret
end


calendar.widget = wibox.widget {
	{
		date			= os.date("*t"),
		fn_embed		= decorate_cell,
		font			= theme.font,
		spacing			= dpi(5),
		long_weekdays	= true,
		widget			= wibox.widget.calendar.month,
	},
	margins = {top = dpi(-5), bottom = dpi(0)},
	widget  = wibox.container.margin,
}


clock.widget = wibox.widget {
	{
		{
			id		= "date",
			text	= "--",
			align   = "center",
			font	= theme.font,
			widget	= wibox.widget.textbox,
		},
		id      = "margin",
		widget	= wibox.container.margin
	},
	fg = theme.topbar_fg,
	bg = theme.topbar_bg,
	widget = wibox.container.background,
	shape_border_width = theme.widget_border_width,
	shape_border_color = "",
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
	end,
	set_date = function(self, str)
		self:get_children_by_id("date")[1].text = str
	end
}


clock.update = function()
	weeks = {"日","一","二","三","四","五","六"}
	awful.spawn.easy_async_with_shell("date +'%H:%M  %-m月%-d日  周%w'", function(out)
		clock.widget.date = string.gsub(out, "(%d)\n", weeks[tonumber(string.match(out, "(%d)\n")) + 1])
	end)
end


clock.popup = awful.popup{
	widget			= calendar.widget,
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.popup_bg,
	fg				= theme.popup_fg,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end,
    placement		= function(d,args)
		awful.placement.top(d, {
			margins = {top = theme.popup_margin_top}, 
			parent  = awful.screen.focused()
		}) 
	end,
}


clock.setup = function(mt,ml,mr,mb)
	clock.widget.margin.top    = dpi(mt or 0)
	clock.widget.margin.left   = dpi(ml or 0)
	clock.widget.margin.right  = dpi(mr or 0)
	clock.widget.margin.bottom = dpi(mb or 0)

	clock.widget:connect_signal('mouse::enter',function() 
		if clock.popup.visible then
			clock.widget.bg = theme.widget_bg_press
			clock.widget.fg = theme.widget_fg_press
		else
			clock.widget.bg = theme.widget_bg_hover
		end
		clock.widget.shape_border_color = theme.widget_border_color
	end)

	clock.widget:connect_signal('mouse::leave',function() 
		if clock.popup.visible then
			clock.widget.bg = theme.widget_bg_press
			clock.widget.fg = theme.widget_fg_press
			clock.widget.shape_border_color = theme.widget_border_color
		else
			clock.widget.bg = theme.topbar_bg
			clock.widget.fg = theme.topbar_fg
			clock.widget.shape_border_color = theme.topbar_bg
		end
	end)

	clock.popup:buttons(gears.table.join(
		awful.button({ }, 3, function ()
			clock.popup.visible = false
			clock.widget.fg = theme.topbar_fg
			clock.widget.bg = theme.topbar_bg
			clock.widget.shape_border_color = theme.topbar_bg
		end)
	))

	clock.widget:buttons(gears.table.join(
		awful.button({ }, 1, function ()
			clock.popup.visible = not clock.popup.visible
			if clock.popup.visible then
				clock.widget.bg = theme.widget_bg_press
				clock.widget.fg = theme.widget_fg_press
			else
				clock.widget.bg = theme.widget_bg_hover
				clock.widget.fg = theme.topbar_fg
			end
			clock.widget.shape_border_color = theme.widget_border_color
		end)
	))
	
	gears.timer({
		timeout   = 60,
		call_now  = true,
		autostart = true,
		callback  = clock.update
	})

	return clock.widget
end


return clock
