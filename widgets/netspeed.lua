local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local get_line = function(file)
    file = io.open(file,"r")
    line = file:read()
    file:close()
    return line
end


local netspeed = {}
local update_interval = 2
local tx_path = "/sys/class/net/wlp2s0/statistics/tx_bytes"
local rx_path = "/sys/class/net/wlp2s0/statistics/rx_bytes"


netspeed.widget = wibox.widget{
	{
		{
			{
				{
					{
						id   = "up",
						image = theme.netspeed_up_active_icon,
						forced_width = dpi(6.5),
						widget = wibox.widget.imagebox,
					},
					valign = "center",
					widget = wibox.container.place,
				},
				{
					left = dpi(5),
					widget	= wibox.container.margin,
				},
				{
					id   = "sent",
					text = "0 KB/s",
					font = "Terminus Bold 7",
					forced_width = dpi(55),
					widget = wibox.widget.textbox,
				},
				forced_height = dpi(10),
				layout = wibox.layout.align.horizontal,
			},
			nil,
			{
				{
					{
						id   = "down",
						image = theme.netspeed_down_active_icon,
						forced_width = dpi(6.5),
						widget = wibox.widget.imagebox,
					},
					valign = "center",
					widget = wibox.container.place,
				},
				{
					left = dpi(5),
					widget	= wibox.container.margin,
				},
				{
					id   = "recv",
					text = "0 KB/s",
					font = "Terminus Bold 7",
					forced_width = dpi(55),
					widget = wibox.widget.textbox,
				},
				forced_height = dpi(10),
				layout = wibox.layout.align.horizontal,
			},
			layout = wibox.layout.align.vertical,
		},
		id      = "margin",
		widget	= wibox.container.margin
	},
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
	end,
	shape_border_width = theme.widget_border_width,
	shape_border_color = "",
	widget = wibox.container.background,

	set_sent = function(self,value)
		local text = ""
		if value < 1024 then
			self:get_children_by_id('up')[1].image = theme.netspeed_up_icon
		else
			self:get_children_by_id('up')[1].image = theme.netspeed_up_active_icon
		end
		if value < 1048576 then
			text = string.format("%d", math.floor(value / 1024)) .. " KB/s"
		else
			text = string.format("%.1f", value / 1048576) .. " MB/s"
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
			text = string.format("%d", math.floor(value / 1024)) .. " KB/s"
		else
			text = string.format("%.1f", value / 1048576) .. " MB/s"
		end
		self:get_children_by_id('recv')[1].text = text
	end,
}



local sent_old   = tonumber(get_line(tx_path)) 
local recive_old = tonumber(get_line(rx_path)) 
local status_old = 0

netspeed.update	= function()
	local sent    = tonumber(get_line(tx_path))
	local recive  = tonumber(get_line(rx_path))
	local dsent   = (sent - sent_old) / update_interval
	local drecive = (recive - recive_old) / update_interval
	recive_old    = recive
	sent_old      = sent
	netspeed.widget.sent = dsent
	netspeed.widget.recv = drecive
end


netspeed.setup = function(mt,ml,mr,mb)
	netspeed.widget.margin.top    = dpi(mt or 0)
	netspeed.widget.margin.left   = dpi(ml or 0)
	netspeed.widget.margin.right  = dpi(mr or 0)
	netspeed.widget.margin.bottom = dpi(mb or 0)

	--netspeed.widget:connect_signal('mouse::enter',function(self) 
	--	self.bg = theme.widget_bg_hover
	--	netspeed.widget.shape_border_color = theme.widget_border_color
	--end)

	--netspeed.widget:connect_signal('mouse::leave',function(self) 
	--	self.bg = ""
	--	netspeed.widget.shape_border_color = ""
	--end)

	gears.timer({
		timeout   = update_interval,
		call_now  = false,
		autostart = true,
		callback  = netspeed.update
	})

	return netspeed.widget
end








return netspeed
