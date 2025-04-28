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
    --placement		= function(d,args)
	--	awful.placement.top_right(d, {margins = { top = theme.popup_margin_top ,right = theme.popup_margin_right}}) 
	--	--awful.placement.top(d, {
	--	--	margins = {top = theme.popup_margin_top}, 
	--	--	parent  = awful.screen.focused()
	--	--}) 
	--end,
}




clock.widget = wibox.widget {
	{
		{
			--{
			--	{
			--		id			= "icon",
			--		image		= theme.clock_icon,
			--		forced_width = dpi(15),
			--		forced_height = dpi(15),
			--		widget		= wibox.widget.imagebox,
			--	},
			--	valign = "center",
			--	halign = "center",
			--	widget	= wibox.container.place,
			--},
			--{
			--	right = dpi(6),
			--	widget  = wibox.container.margin
			--},
			{
				{
					id		= "date",
					text	= "--",
					font	= theme.clock_font,
					widget	= wibox.widget.textbox,
				},
				valign = "center",
				halign = "center",
				widget	= wibox.container.place,
			},
			layout = wibox.layout.fixed.horizontal,
		},
		id      = "margin",
		widget	= wibox.container.margin
	},
	fg = theme.widget_fg,
	bg = theme.widget_bg,
	widget = wibox.container.background,
	shape_border_width = theme.widget_border_width,
	shape_border_color = theme.widget_border_color,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
	end,
	set_date = function(self, str)
		self:get_children_by_id("date")[1].text = str
	end
}




function clock:update()
	--awful.spawn.easy_async_with_shell("date +'%H:%M  %A  %-02m/%-02d'", function(out)
	--	self.widget.date = out
	--	self.widget.date = string.gsub(out, "\n", "")
	--end)

	--awful.spawn.easy_async_with_shell("date +'%H:%M  %a  %-02m/%-02d'", function(out)
	--	self.widget.date = out
	--	self.widget.date = string.gsub(out, "\n", "")
	--end)

	--awful.spawn.easy_async_with_shell("date +'%-m/%-d  %a  %H:%M'", function(out)
	--	self.widget.date = out
	--	self.widget.date = string.gsub(out, "\n", "")
	--end)

	--weeks = {"日","一","二","三","四","五","六"}
	--awful.spawn.easy_async_with_shell("date +'%H:%M  %-m月%-d日  周%w'", function(out)
	--	self.widget.date = string.gsub(out, "(%d)\n", weeks[tonumber(string.match(out, "(%d)\n")) + 1])
	--end)

	weeks = {"日","一","二","三","四","五","六"}
	awful.spawn.easy_async_with_shell("date +'%H:%M    周%w    %-1m月%-1d日'", function(out)
		out = string.gsub(out, "\n", "")
		self.widget.date = string.gsub(out, "周(%d)", "周" .. weeks[tonumber(string.match(out, "周(%d)")) + 1])
	end)

	--weeks = {"日","一","二","三","四","五","六"}
	--awful.spawn.easy_async_with_shell("date +'%H:%M    周%w    %-02m/%-02d'", function(out)
	--	out = string.gsub(out, "\n", "")
	--	self.widget.date = string.gsub(out, "周(%d)", "周" .. weeks[tonumber(string.match(out, "周(%d)")) + 1])
	--end)

	--weeks = {"日","一","二","三","四","五","六"}
	--awful.spawn.easy_async_with_shell("date +'%-m月%-d日   周%w   %H:%M'", function(out)
	--	out = string.gsub(out, "\n", "")
	--	self.widget.date = string.gsub(out, "周(%d)", "周" .. weeks[tonumber(string.match(out, "周(%d)")) + 1])
	--end)
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
	end)

	self.widget:connect_signal('mouse::leave',function() 
		if self.popup.visible then
			self.widget.bg = theme.widget_bg_press
			self.widget.fg = theme.widget_fg_press
		else
			self.widget.bg = theme.widget_bg
			self.widget.fg = theme.topbar_fg
		end
	end)

	--self.popup:buttons(gears.table.join(
	--	awful.button({ }, 3, function ()
	--		self.popup.visible = false
	--		self.widget.fg = theme.topbar_fg
	--		self.widget.bg = theme.widget_bg
	--	end)
	--))

	--self.widget:buttons(gears.table.join(
	--	awful.button({ }, 1, function ()
	--		self.popup.visible = not self.popup.visible
	--		if self.popup.visible then
	--			self.popup:set_widget(calendar.widget)
	--			self.widget.bg = theme.widget_bg_press
	--			self.widget.fg = theme.widget_fg_press
	--		else
	--			self.widget.bg = theme.widget_bg_hover
	--			self.widget.fg = theme.topbar_fg
	--		end
	--	end)
	--))

	local function popup_move()	
		local m = mouse.coords()
		self.popup.x = m.x - self.popup_offset.x
		self.popup.y = m.y - self.popup_offset.y
		mousegrabber.stop()
	end

	self.popup:buttons(gears.table.join(
		awful.button({ }, 1, function()
			self.popup:connect_signal('mouse::move',popup_move)
			local m = mouse.coords()
			self.popup_offset = {
				x = m.x - self.popup.x,
				y = m.y - self.popup.y
			}
			self.popup:emit_signal('mouse::move', popup_move)
		end,function()
			self.popup:disconnect_signal ('mouse::move',popup_move)
		end),
		awful.button({ }, 3, function ()
			self.popup:disconnect_signal ('mouse::move',popup_move)
			self.popup.visible = false
			self.widget.bg = theme.widget_bg
		end)
	))

	self.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			if not self.popup.visible then
				self.popup.x = -999
				self.popup.y = -999
				self:update()
			end
			self.popup.visible = not self.popup.visible 
		end,function()
			if self.popup.visible then
				local s = awful.screen.focused()
				local x =  mouse.coords().x - math.ceil(self.popup.width / 2)
				if x + self.popup.width > s.geometry.width - (theme.useless_gap + theme.border_width)*dpi(1) then
					x = s.geometry.width - self.popup.width - (theme.useless_gap + theme.border_width)*dpi(1)
				end
				if x < theme.useless_gap*dpi(1) then
					x = theme.useless_gap*dpi(1)
				end
				self.popup.x = x
				self.popup.y = theme.popup_margin_top
			end
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

	return wibox.widget{
		self.widget,
		left = dpi(0-theme.widget_border_width/2),
		widget = wibox.container.margin
	}
end




return clock
