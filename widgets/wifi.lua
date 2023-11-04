local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local wifi = {}
local get_signal_cmd = "iw dev wlp2s0 link|grep signal|sed 's/[^0-9]//g'"
local get_ssid_cmd = "iw dev wlp2s0 link|grep SSID|sed 's/.*SSID: //'"


wifi.widget = wibox.widget{
	{
		{
			{
				id			= "icon",
				image		= theme.wifi_signal_0_icon,
				widget		= wibox.widget.imagebox,
			},
			{
				id			= "ssid",
				text		= "",
				font		= theme.font,
				visible		= false,
				widget		= wibox.widget.textbox,
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

	set_signal = function(self,value)
		local icon = self:get_children_by_id("icon")[1]
		if value <= 50 then
			icon.image = theme.wifi_signal_3_icon
		elseif value <= 70 then
			icon.image = theme.wifi_signal_2_icon
		elseif value <= 100 then 
			icon.image = theme.wifi_signal_1_icon
		else
			icon.image = theme.wifi_signal_0_icon
		end
	end,
	set_ssid = function(self,str)
		self:get_children_by_id("ssid")[1].text = "  " .. str
	end,
}


wifi.update = function()
	awful.spawn.easy_async_with_shell(get_signal_cmd, function(out)
		wifi.widget.signal = tonumber(out) or 999
	end)
	awful.spawn.easy_async_with_shell(get_ssid_cmd, function(out)
		if #out > 1 then
			wifi.widget.ssid = out
		else
			wifi.widget.ssid = "Disconnect"
		end
	end)
end


wifi.setup = function(mt,ml,mr,mb)
	wifi.widget.margin.top    = dpi(mt or 0)
	wifi.widget.margin.left   = dpi(ml or 0)
	wifi.widget.margin.right  = dpi(mr or 0)
	wifi.widget.margin.bottom = dpi(mb or 0)

	wifi.widget:buttons(awful.util.table.join(awful.button({}, 3, function() 
		local wdg = wifi.widget:get_children_by_id("ssid")[1]
		wdg.visible = not wdg.visible
	end)))

	gears.timer({
		timeout   = 10,
		call_now  = true,
		autostart = true,
		callback  = wifi.update
	})

	return wifi.widget
end





return wifi
