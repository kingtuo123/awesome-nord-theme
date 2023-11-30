local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local battery = {}


local path_ac             = "/sys/class/power_supply/AC/online"
local path_status         = "/sys/class/power_supply/BAT0/status"
local path_capacity       = "/sys/class/power_supply/BAT0/capacity"
local cmd_get_brightness  = "xbacklight -get"
local cmd_set_brightness  = "xbacklight -set " 
battery.update_timeout    = 15


local bat_icon = function(value,status,ac)
	local level = math.floor((tonumber(value) + 5) / 10) * 10
	if status == "Charging" then
		return theme.icon_dir .. "battery/bat-charging-" .. level .. ".svg"
	elseif tonumber(ac) == 1 then
		return theme.icon_dir .. "battery/bat-charging-100.svg"
	else
		return theme.icon_dir .. "battery/bat-" .. level .. ".svg"
	end
end


local get_line = function(file)
    file = io.open(file,"r")
    line = file:read()
    file:close()
    return line
end


battery.widget = wibox.widget {
	{
		{
			{
				id     = "icon",
				image  = theme.bat_100_icon,
				resize = true,
				widget = wibox.widget.imagebox
			},
			{
				id           = "capacity",
				text         = " 100%",
				visible		 = false,
				font 		 = theme.font,
				widget       = wibox.widget.textbox,
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
	widget = wibox.container.background,

	backup_ac = 0,
	backup_status = "",
	backup_brightness = 0,
	backup_capacity = 0,
	backup_icon = "",

	set_ac = function(self, val)
		self.backup_ac = val
	end,
	set_status = function(self, str)
		self.backup_status = str
	end,
	set_capacity = function(self, val)
		val = tonumber(val)
		self.backup_capacity = val
		self.backup_icon = bat_icon(val, self.status, self.ac)
		self:get_children_by_id("icon")[1].image  = self.backup_icon
		self:get_children_by_id("capacity")[1].text  = "  " .. val .."%"
	end,
	set_brightness = function(self,val)
		if val > 100 then
			self.backup_brightness = 100
		elseif val < 5 then
			self.backup_brightness = 5
		else
			self.backup_brightness = val
		end
		awful.spawn.with_shell(cmd_set_brightness .. self.backup_brightness)
	end,
	get_brightness = function(self)
		return self.backup_brightness
	end,
	get_capacity = function(self)
		return self.backup_capacity
	end,
	get_status = function(self)
		return self.backup_status
	end,
	get_ac = function(self)
		return self.backup_ac
	end,
	get_icon = function(self)
		return self.backup_icon
	end
}


battery.update = function()
	battery.widget.ac       = get_line(path_ac)
	battery.widget.status   = get_line(path_status)
	battery.widget.capacity = get_line(path_capacity)
	awful.spawn.easy_async_with_shell(cmd_get_brightness, function(out)
		battery.widget.brightness = tonumber(out)
	end)
end


battery.brightness_progressbar = wibox.widget{
	{
		top = dpi(10),
		widget = wibox.container.margin 
	},
	{
		{
			id		= "value",
			text	= "100",
			font	= theme.font,
			widget	= wibox.widget.textbox,
		},
		valign = "center",
		halign = "center",
		widget = wibox.container.place,
	},
	{
		{
			id					= "bar",
			value				= 0.5,
			forced_height		= dpi(45),
			forced_width		= dpi(150),
			margins             = {top = dpi(17), left = dpi(15), right = dpi(15), bottom = dpi(17)},
			color				= theme.popup_fg_progressbar,
			background_color	= theme.popup_bg_progressbar,
			widget				= wibox.widget.progressbar,
		},
		direction	= "east",
		widget		= wibox.container.rotate,
	},
	{
		{
			{
				id	   = "icon",
				image  = theme.vol_bar0_icon,
				--resize = true,
				forced_width = dpi(20),
				forced_height = dpi(20),
				halign = "center",
				valign = "center",
				widget = wibox.widget.imagebox,
			},
			halign = "center",
			valign = "center",
			layout = wibox.container.place
		},
		top    = dpi(0),
		left   = dpi(0),
		right  = dpi(0),
		bottom = dpi(10),
		widget = wibox.container.margin 
	},
	layout = wibox.layout.fixed.vertical,
	set_value	= function(self,val)
		local icon = self:get_children_by_id('icon')[1]
		if val <= 30 then
			icon.image = theme.brightness_1_icon
		elseif val <= 60 then
			icon.image = theme.brightness_2_icon
		elseif val <= 90 then
			icon.image = theme.brightness_3_icon
		end
		self:get_children_by_id('bar')[1].value = val / 100
		self:get_children_by_id('value')[1].text = val
	end,
}


battery.popup = awful.popup{
	widget			= battery.brightness_progressbar,
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.bg,
	fg              = theme.fg,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end,
    placement		= function(wdg,args)  
		awful.placement.top_right(wdg, {margins = { top = theme.popup_margin_top ,right = dpi(5)}}) 
	end,
}


battery.popup_close_timer = gears.timer {
	timeout   = 2,
	call_now  = false,
	autostart = false,
	callback  = function(self)
		print("clean popup")
		battery.popup.visible = false
		self:stop()
	end
}


battery.popup_enable = true
battery.popup_close_count_down = function()
	battery.popup.visible = battery.popup_enable
	if battery.popup.visible then
		battery.popup_close_timer:again()
	end
end


battery.brightness_up = function()
	battery.widget.brightness = battery.widget.brightness + 5
	battery.brightness_progressbar.value = battery.widget.brightness
	battery.popup_close_count_down()
end


battery.brightness_down = function()
	battery.widget.brightness = battery.widget.brightness - 5
	battery.brightness_progressbar.value = battery.widget.brightness
	battery.popup_close_count_down()
end




battery.setup = function(mt,ml,mr,mb)
	battery.widget.margin.top    = dpi(mt or 0)
	battery.widget.margin.left   = dpi(ml or 0)
	battery.widget.margin.right  = dpi(mr or 0)
	battery.widget.margin.bottom = dpi(mb or 0)

	battery.widget:buttons(awful.util.table.join(
		awful.button({}, 3, function() 
			local wdg = battery.widget:get_children_by_id("capacity")[1]
			wdg.visible = not wdg.visible
		end),
		awful.button({}, 4, function() 
			battery.brightness_up()
		end),
		awful.button({}, 5, function() 
			battery.brightness_down()
		end)
	))

	gears.timer({
		timeout   = battery.update_timeout,
		call_now  = true,
		autostart = true,
		callback  = battery.update
	})

	return battery.widget
end





return battery
