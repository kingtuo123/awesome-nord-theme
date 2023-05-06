local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local beautiful	 = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi 		 = xresources.apply_dpi




local wifi = {}
local get_signal_cmd = "iw dev wlp2s0 link|grep signal|sed 's/[^0-9]//g'"
local get_essid_cmd = "iw dev wlp2s0 link|grep SSID|sed 's/.*SSID: //'"


wifi.widget = wibox.widget{
	{
		id			= "wifi",
		image		= theme.wifi_signal_0_icon,
		widget		= wibox.widget.imagebox,
	},
	{
		id			= "name",
		text		= " test ",
		font		= theme.font,
		visible		= false,
		widget		= wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal,
	set_signal = function(self,value)
		if value <= 50 then
			self.wifi.image = theme.wifi_signal_3_icon
		elseif value <= 70 then
			self.wifi.image = theme.wifi_signal_2_icon
		elseif value <= 100 then 
			self.wifi.image = theme.wifi_signal_1_icon
		else
			self.wifi.image = theme.wifi_signal_0_icon
		end
	end,
	set_essid = function(self,str)
		self.name.text = "  " .. str
	end,
}


wifi.buttons = awful.util.table.join (
	awful.button({}, 3, function() 
		wifi.widget.name.visible = not wifi.widget.name.visible
	end)
)


wifi.update = function()
	awful.spawn.easy_async_with_shell(get_signal_cmd, function(out)
		wifi.widget.signal = tonumber(out) or 999
	end)
	awful.spawn.easy_async_with_shell(get_essid_cmd, function(out)
		if #out > 1 then
			wifi.widget.essid = out
		else
			wifi.widget.essid = "Disconnect"
		end
	end)
end


wifi.timer = {
    timeout   = 10,
    call_now  = true,
    autostart = true,
    callback  = wifi.update
}







return wifi
