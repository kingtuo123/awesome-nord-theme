local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local beautiful	 = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi 		 = xresources.apply_dpi





local netspeed = {}
local net_interval = 2
local tx_path = "/sys/class/net/wlp2s0/statistics/tx_bytes"
local rx_path = "/sys/class/net/wlp2s0/statistics/rx_bytes"

local get_line = function(file)
    file = io.open(file,"r")
    line = file:read()
    file:close()
    return line
end


netspeed.widget = wibox.widget{
	{
		{
			{
				id   = "up",
				image = theme.netspeed_up_active_icon,
				valign = "top",
				forced_width = dpi(6),
				widget = wibox.widget.imagebox,
			},
			top = dpi(2),
			widget = wibox.container.margin,
		},
		{
			{
				id   = "down",
				image = theme.netspeed_down_active_icon,
				valign = "bottom",
				forced_width = dpi(6),
				widget = wibox.widget.imagebox,
			},
			top = dpi(11),
			widget = wibox.container.margin,
		},
		layout  = wibox.layout.stack,
	},
	wibox.widget.textbox("  "),
	{
		{
			id   = "sent",
			text = "0 KB/s ",
			valign = "top",
			halign = "right",
			font = "Terminus Bold 7",
			forced_width = dpi(50),
			widget = wibox.widget.textbox,
		},
		{
			id   = "recv",
			text = "0 KB/s ",
			valign = "bottom",
			halign = "right",
			font = "Terminus Bold 7",
			forced_width = dpi(50),
			widget = wibox.widget.textbox,
		},
		layout  = wibox.layout.stack,
	},
	layout = wibox.layout.fixed.horizontal,
	set_sent = function(self,value)
		local text = ""
		if value < 1024 then
			self:get_children_by_id('up')[1].image = theme.netspeed_up_icon
		else
			self:get_children_by_id('up')[1].image = theme.netspeed_up_active_icon
		end
		if value < 1048576 then
			text = string.format("%d", value / 1024) .. " KB/s "
		else
			text = string.format("%.1f", value / 1048576) .. " MB/s "
		end
		self:get_children_by_id('sent')[1].text = text
	end,
	set_recv = function(self,value)
		local text = ""
		if value < 1024 then
			self:get_children_by_id('down')[1].image = theme.netspeed_down_icon
		else
			self:get_children_by_id('down')[1].image = theme.netspeed_down_active_icon
		end
		if value < 1048576 then
			text = string.format("%d", value / 1024) .. " KB/s "
		else
			text = string.format("%.1f", value / 1048576) .. " MB/s "
		end
		self:get_children_by_id('recv')[1].text = text
	end,
}


local sent_old      = tonumber(get_line(tx_path)) 
local recive_old    = tonumber(get_line(rx_path)) 
local status_old    = 0
netspeed.update	= function()
	local sent   = tonumber(get_line(tx_path))
	local recive = tonumber(get_line(rx_path))
	local dsent  = (sent - sent_old) / net_interval
	local drecive = (recive - recive_old) / net_interval
	recive_old = recive
	sent_old   = sent
	netspeed.widget.sent = dsent
	netspeed.widget.recv = drecive
end


netspeed.timer = {
    timeout   = net_interval,
    call_now  = false,
    autostart = true,
    callback  = netspeed.update
}









return netspeed
