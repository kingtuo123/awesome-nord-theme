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




setmetatable(calendar, { __index = function(self, key) 
	--print("update calendar")
	if key == "widget" then
		return wibox.widget {
			{
				id              = "calendar",
				date			= os.date("*t"),
				fn_embed		= decorate_cell,
				font			= theme.cal_font,
				spacing			= dpi(5),
				long_weekdays	= true,
				widget			= wibox.widget.calendar.month,
			},
			margins = {top = dpi(-5), bottom = dpi(0)},
			widget  = wibox.container.margin,
		}
	else
		return nil
	end
end })




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
		awful.placement.top_right(d, {margins = { top = theme.popup_margin_top ,right = theme.popup_margin_right}}) 
		--awful.placement.top(d, {
		--	margins = {top = theme.popup_margin_top}, 
		--	parent  = awful.screen.focused()
		--}) 
	end,
}




clock.widget = wibox.widget {
	{
		{
			id		= "date",
			text	= "--",
			align   = "center",
			valign  = "center",
			font	= theme.clock_font,
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




function clock:update()
	--awful.spawn.easy_async_with_shell("date +'%H:%M %-m/%-d %a'", function(out)
	--	self.widget.date = out
	--	self.widget.date = string.gsub(out, "\n", "")
	--end)

	--weeks = {"日","一","二","三","四","五","六"}
	--awful.spawn.easy_async_with_shell("date +'%H:%M  %-m月%-d日  周%w'", function(out)
	--	self.widget.date = string.gsub(out, "(%d)\n", weeks[tonumber(string.match(out, "(%d)\n")) + 1])
	--end)

	weeks = {"日","一","二","三","四","五","六"}
	awful.spawn.easy_async_with_shell("date +'%-m月%-d日   周%w   %H:%M'", function(out)
		out = string.gsub(out, "\n", "")
		self.widget.date = string.gsub(out, "周(%d)", "周" .. weeks[tonumber(string.match(out, "周(%d)")) + 1])
	end)
end




function clock:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	self.widget:connect_signal('mouse::enter',function() 
		if self.popup.visible then
			self.widget.bg = theme.widget_bg_press
			self.widget.fg = theme.widget_fg_press
		else
			self.widget.bg = theme.widget_bg_hover
		end
		self.widget.shape_border_color = theme.widget_border_color
	end)

	self.widget:connect_signal('mouse::leave',function() 
		if self.popup.visible then
			self.widget.bg = theme.widget_bg_press
			self.widget.fg = theme.widget_fg_press
			self.widget.shape_border_color = theme.widget_border_color
		else
			self.widget.bg = theme.topbar_bg
			self.widget.fg = theme.topbar_fg
			self.widget.shape_border_color = theme.topbar_bg
		end
	end)

	self.popup:buttons(gears.table.join(
		awful.button({ }, 3, function ()
			self.popup.visible = false
			self.widget.fg = theme.topbar_fg
			self.widget.bg = theme.topbar_bg
			self.widget.shape_border_color = theme.topbar_bg
		end)
	))

	self.widget:buttons(gears.table.join(
		awful.button({ }, 1, function ()
			self.popup.visible = not self.popup.visible
			if self.popup.visible then
				self.popup:set_widget(calendar.widget)
				self.widget.bg = theme.widget_bg_press
				self.widget.fg = theme.widget_fg_press
			else
				self.widget.bg = theme.widget_bg_hover
				self.widget.fg = theme.topbar_fg
			end
			self.widget.shape_border_color = theme.widget_border_color
		end)
	))
	
	gears.timer({
		timeout   = 60,
		call_now  = true,
		autostart = true,
		callback  = function()
			self:update()
		end
	})

	return self.widget
end




return clock
