local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local vpn = {}


vpn.widget = wibox.widget{
	{
		{
			{
				id		= "icon",
				image	= theme.vpn_off_icon,
				widget	= wibox.widget.imagebox,
			},
			{
				id		= "status",
				text 	= "  OFF",
				visible = false,
				font	= theme.font,
				widget	= wibox.widget.textbox,
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

	backup_status = "off",
	set_status = function(self,value)
		if value == "on" then
			vpn.widget:get_children_by_id("icon")[1].image = theme.vpn_on_icon
			vpn.widget:get_children_by_id("status")[1].text = "  ON"
			self.backup_status = "on"
		else
			vpn.widget:get_children_by_id("icon")[1].image = theme.vpn_off_icon
			vpn.widget:get_children_by_id("status")[1].text = "  OFF"
			self.backup_status = "off"
		end
	end,
	get_status = function(self)
		return self.backup_status
	end,
}


vpn.update = function()
	awful.spawn.easy_async_with_shell("pgrep v2raya", function(out)
		if #out > 1 then
			vpn.widget.status = "on"
		else
			vpn.widget.status = "off"
		end
	end)
end


vpn.setup = function(mt,ml,mr,mb)
	vpn.widget.margin.top    = dpi(mt or 0)
	vpn.widget.margin.left   = dpi(ml or 0)
	vpn.widget.margin.right  = dpi(mr or 0)
	vpn.widget.margin.bottom = dpi(mb or 0)

	vpn.widget:connect_signal('mouse::enter',function() 
		vpn.widget.bg = theme.widget_bg_hover
	end)
	vpn.widget:connect_signal('mouse::leave',function() 
		vpn.widget.bg = ""
	end)

	vpn.widget:buttons(awful.util.table.join(
		awful.button({}, 2, function() 
			if vpn.widget.status == "off" then
				vpn.widget.status = "on"
				awful.spawn.with_shell("v2raya --lite > /dev/null&")
			else
				awful.spawn.with_shell("killall v2raya; killall v2ray")
				vpn.widget.status = "off"
			end
		end),
		awful.button({}, 3, function() 
			local wdg = vpn.widget:get_children_by_id("status")[1]
			wdg.visible = not wdg.visible
		end)
	))

	gears.timer({
		timeout   = 10,
		call_now  = true,
		autostart = true,
		callback  = vpn.update
	})

	return vpn.widget
end


return vpn
