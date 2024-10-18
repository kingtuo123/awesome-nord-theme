local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi




local netspeed = {}
local update_timeout = 2
local device = "wlp4s0"
local tx_path = "/sys/class/net/" .. device .. "/statistics/tx_bytes"
local rx_path = "/sys/class/net/" .. device .. "/statistics/rx_bytes"




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
					font = theme.netspeed_font,
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
					font = theme.netspeed_font,
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
			text = string.format("%d KB/s", math.floor(value / 1024))
		else
			text = string.format("%.1f MB/s", value / 1048576)
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
			text = string.format("%d KB/s", math.floor(value / 1024))
		else
			text = string.format("%.1f MB/s", value / 1048576)
		end
		self:get_children_by_id('recv')[1].text = text
	end,
}




local function get_line(file)
    file = io.open(file,"r")
    line = file:read()
    file:close()
    return line
end




local sent_old   = tonumber(get_line(tx_path)) 
local recive_old = tonumber(get_line(rx_path)) 
local status_old = 0




function netspeed:update()
	local sent    = tonumber(get_line(tx_path))
	local recive  = tonumber(get_line(rx_path))
	local dsent   = (sent - sent_old) / update_timeout
	local drecive = (recive - recive_old) / update_timeout
	recive_old    = recive
	sent_old      = sent
	self.widget.sent = dsent
	self.widget.recv = drecive
end




function netspeed:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	gears.timer({
		timeout   = update_timeout,
		call_now  = false,
		autostart = true,
		callback  = function()
			self:update()
		end
	})

	return self.widget
end




return netspeed
