local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local beautiful	 = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi 		 = xresources.apply_dpi






local battery = {}


local bat_icon = function(value,chg,ac)
	local v = math.floor((tonumber(value) + 5) / 10) * 10
	if chg == "Charging" then
		return theme.icon_dir .. "battery/bat-charging-" .. v .. ".svg"
	elseif tonumber(ac) == 1 then
		return theme.icon_dir .. "battery/bat-charging-100.svg"
	else
		return theme.icon_dir .. "battery/bat-" .. v .. ".svg"
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
		id     = "myib",
		image  = theme.bat_100_icon,
		resize = true,
		widget = wibox.widget.imagebox
	},
	{
		id           = "mytb",
		text         = " 100%",
		visible		 = false,
		font 		 = theme.widget_font,
		widget       = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal,
	charging = "",
	ac = 0,
	backup_brightness = 0,
	set_battery = function(self, val)
		val = tonumber(val)
		self.mytb.text  = "  " .. val .."%"
		self.myib.image  = bat_icon(val,self.charging,self.ac)
	end,
	set_brightness = function(self,val)
		if val > 100 then
			self.backup_brightness = 100
		elseif val < 10 then
			self.backup_brightness = 10
		else
			self.backup_brightness = val
		end
		awful.spawn.with_shell("xbacklight -set " .. val)
	end,
	get_brightness = function(self)
		return self.backup_brightness
	end
}


battery.update = function()
	battery.widget.ac       = get_line("/sys/class/power_supply/AC/online")
	battery.widget.charging = get_line("/sys/class/power_supply/BAT0/status")
	battery.widget.battery  = get_line("/sys/class/power_supply/BAT0/capacity")
	awful.spawn.easy_async_with_shell("xbacklight -get", function(out)
		battery.widget.brightness = tonumber(out)
	end)
end


battery.timer = {
	timeout   = 15,
    call_now  = true,
    autostart = true,
    callback  = battery.update
}


battery.brightness_progressbar = wibox.widget{
	{
		{
			id					= "bar",
			value				= 0.5,
			forced_height		= dpi(50),
			forced_width		= dpi(100),
			color				= "#eceff4",
			background_color	= "#2e3440",
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
				resize = true,
				forced_width = dpi(25),
				forced_height = dpi(25),
				halign = "center",
				valign = "center",
				widget = wibox.widget.imagebox,
			},
			halign = "center",
			valign = "center",
			layout = wibox.container.place
		},
		top = dpi(100),
		bottom = dpi(12),
		widget = wibox.container.margin 
	},
	layout = wibox.layout.stack,
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
	end,
}

battery.popup = awful.popup{
	widget			= battery.brightness_progressbar,
	border_color	= theme.color3,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.color0,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, dpi(10))
	end,
    placement		= function(wdg,args)  
		awful.placement.top_right(wdg, {margins = { top = theme.popup_margin_top ,right = dpi(5)}}) 
	end,
}


battery.auto_clean_popup = true
battery.clean_popup_timer = gears.timer {
	timeout   = 2,
	call_now  = false,
	autostart = false,
	callback  = function(self)
		print("clean popup")
		self:stop()
		battery.popup.visible = false
	end
}
battery.clean_popup = function()
	if battery.popup.visible then
		battery.clean_popup_timer:again()
	end
end


battery.brightness_up = function()
	battery.widget.brightness = battery.widget.brightness + 5
	battery.brightness_progressbar.value = battery.widget.brightness
	battery.popup.visible = true
	battery.clean_popup()
end


battery.brightness_down = function()
	battery.widget.brightness = battery.widget.brightness - 5
	battery.brightness_progressbar.value = battery.widget.brightness
	battery.popup.visible = true
	battery.clean_popup()
end


battery.buttons = awful.util.table.join (
	awful.button({}, 1, function() 
		battery.brightness_progressbar.value = battery.widget.brightness
		battery.popup.visible = true
		battery.clean_popup()
	end),
	awful.button({}, 3, function() 
		battery.widget.mytb.visible = not battery.widget.mytb.visible
	end),
	awful.button({}, 4, function() 
		battery.brightness_up()
	end),
	awful.button({}, 5, function() 
		battery.brightness_down()
	end)
)






return battery
