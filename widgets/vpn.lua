local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local beautiful	 = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi 		 = xresources.apply_dpi




local vpn = {}


vpn.widget = wibox.widget{
	{
		id		= "vpn",
		image	= theme.vpn_off_icon,
		widget	= wibox.widget.imagebox,
	},
	{
		id		= "sw",
		text 	= "  OFF",
		visible = false,
		font	= theme.font,
		widget	= wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal,
	backup_status = "off",
	set_status = function(self,value)
		if value == "on" then
			vpn.widget.vpn.image = theme.vpn_on_icon
			vpn.widget.sw.text = "  ON"
			self.backup_status = "on"
		else
			vpn.widget.vpn.image = theme.vpn_off_icon
			vpn.widget.sw.text = "  OFF"
			self.backup_status = "off"
		end
	end,
	get_status = function(self)
		return self.backup_status
	end,
}


vpn.buttons = awful.util.table.join (
	awful.button({}, 2, function() 
		if vpn.widget.status == "off" then
			vpn.widget.status = "on"
			awful.spawn.with_shell("v2raya --lite > /dev/null&")
		else
			awful.spawn.with_shell("killall v2raya; killall v2ray")
			vpn.widget.status = "off"
		end
		--awful.spawn.easy_async_with_shell("pgrep v2raya", function(out)
		--	if #out > 1 then
		--		vpn.widget.status = "on"
		--	else
		--		vpn.widget.status = "off"
		--	end
		--end)
	end),
	awful.button({}, 3, function() 
		vpn.widget.sw.visible = not vpn.widget.sw.visible
	end)
)


vpn.update = function()
	awful.spawn.easy_async_with_shell("pgrep v2raya", function(out)
		if #out > 1 then
			vpn.widget.status = "on"
		else
			vpn.widget.status = "off"
		end
	end)
end


vpn.timer = {
    timeout   = 10,
    call_now  = true,
    autostart = true,
    callback  = vpn.update
}



return vpn
