local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local beautiful	 = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi 		 = xresources.apply_dpi









--calendar
local function rounded_shape(size)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, dpi(size))
	end
end

if theme.style == "dark" then
	normal_fg_color = theme.color4
	focus_bg_color  = theme.color9
	header_fg_color = theme.color6
	weekday_fg_color= theme.color9
	week_06_bg_color= theme.color2
else
	normal_fg_color = theme.color3
	focus_bg_color  = theme.color11
	header_fg_color = theme.color10
	weekday_fg_color= theme.color10
	week_06_bg_color= theme.color4
end

local styles = {}


styles.month   = { 
	padding = dpi(5),
	bg_color = theme.bg,                
}
styles.normal  = { 
	fg_color= normal_fg_color,
	shape	= rounded_shape(2),
	markup	= function(t) return '<b>' .. t .. '</b>' end,
}                                                       
styles.focus   = {
	fg_color = theme.bg,                
	bg_color = focus_bg_color,                
	markup   = function(t) return '<b>' .. t .. '</b>' end,
	shape    = rounded_shape(2)          
}                                                       
styles.header  = {
	fg_color = header_fg_color,                
	bg_color = theme.bg,             
	markup   = function(t) return '<b>' .. t .. '</b>' end,
	shape    = rounded_shape(2)          
}                                                       
styles.weekday = {
	fg_color = weekday_fg_color,                
	markup   = function(t) return '<b>' .. t .. '</b>' end,
	shape    = rounded_shape(2)
}




local function decorate_cell(widget, flag, date)
	if flag == "monthheader" and not styles.monthheader then
		flag = "header"
	end
	local props = styles[flag] or {}
	if props.markup and widget.get_text and widget.set_markup then
		widget:set_markup(props.markup(widget:get_text()))
	end
	-- Change bg color for weekends
	local d			 = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
	local weekday	 = tonumber(os.date("%w", os.time(d)))
	local default_bg = (weekday==0 or weekday==6) and week_06_bg_color or theme.bg
	local ret 		 = wibox.widget {
		{
			{
				widget,
				halign = 'center',
				widget = wibox.container.place
			},
			margins = (props.padding or dpi(3)) + (props.border_width or 0),
			widget  = wibox.container.margin
		},
		shape        = props.shape,
		fg           = props.fg_color or theme.color6,
		bg           = props.bg_color or default_bg,
		widget       = wibox.container.background
	}
	return ret
end

local cal = wibox.widget {
	{
		date			= os.date("*t"),
		fn_embed		= decorate_cell,
		font			= theme.font,
		spacing			= dpi(5),
		long_weekdays	= true,
		widget			= wibox.widget.calendar.month,
	},
	bottom = dpi(-20),
	widget  = wibox.container.margin,
}
--end of calendar










--clock
local clock = {}

clock.widget = wibox.widget {
	format	= '%Y-%m-%d  %H:%M  %a',
	align	= "center",
	font	= theme.font,
	widget	= wibox.widget.textclock,
}

clock.popup = awful.popup{
	widget			= cal,
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.bg,
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

clock.buttons = gears.table.join(
	awful.button({ }, 1, function ()
		clock.popup.visible = not clock.popup.visible
	end)
)
--end of clock









return clock
