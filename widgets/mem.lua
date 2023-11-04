local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local mem = {}
local colors = {
	theme.blue3,
	theme.blue2,
	theme.blue1,
	theme.blue0,
	theme.green,
	theme.green,
	theme.yellow,
	theme.orange,
	theme.orange,
	theme.red,
	theme.red,
}


mem.widget = wibox.widget {
	{
		{
			{
				id					= "bar",
				margins				= { top = dpi(11), bottom = 0, right = 0, left = 0 },
				max_value			= 100,
				value				= 0,
				bar_border_width	= 0,
				forced_width  		= dpi(60),
				color				= colors[1],
				background_color	= theme.widget_bg_progressbar,
				shape				= function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, dpi(0))
				end,
				widget				= wibox.widget.progressbar,
			},
			{
				{
					{
						id		= "used",
						text	= "",
						font	= "Terminus Bold 7",
						widget	= wibox.widget.textbox,
					},
					valign = "top",
					halign = "left",
					layout = wibox.container.place,
				},
				{
					{
						{
							text	= "|",
							font	= "Terminus Bold 7",
							widget	= wibox.widget.textbox,
						},
						fg		= theme.dark4,
						widget	= wibox.container.background,
					},
					valign = "top",
					halign = "center",
					layout = wibox.container.place,
				},
				{
					{
						id		= "total",
						text	= "",
						font	= "Terminus Bold 7",
						widget	= wibox.widget.textbox,
					},
					valign = "top",
					halign = "right",
					layout = wibox.container.place,
				},
				layout = wibox.layout.stack,
			},
			layout = wibox.layout.stack,
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
	set_mem = function(self,v)
		idx		= math.ceil(10*v.used/v.total)
		v.used	= string.format("%.1f",v.used/1048576)
		v.total	= string.format("%.1f",v.total/1048576)
		self:get_children_by_id('bar')[1].value		= math.floor(v.used * 10)
		self:get_children_by_id('bar')[1].max_value	= math.floor(v.total * 10)
		self:get_children_by_id('used')[1].text		= v.used
		self:get_children_by_id('total')[1].text	= v.total
		self:get_children_by_id('bar')[1].color		= colors[idx]
	end,
}


mem.update = function()
    mem_now = {}
	lines 	= {}
    file	= io.open("/proc/meminfo","r")
    lines[1] = file:read()
    lines[2] = file:read()
    lines[3] = file:read()
    file:close()
    for _, line in pairs(lines) do
        for k, v in string.gmatch(line, "([%a]+):[%s]+(%d+)%s") do
            if     k == "MemTotal"     then mem_now.total  = v
            elseif k == "MemFree"      then mem_now.free   = v
            elseif k == "MemAvailable" then mem_now.avail  = v
            end
        end
    end
    mem_now.used = mem_now.total - mem_now.avail
    mem.widget.mem = mem_now
end


mem.setup = function(mt,ml,mr,mb)
	mem.widget.margin.top    = dpi(mt or 0)
	mem.widget.margin.left   = dpi(ml or 0)
	mem.widget.margin.right  = dpi(mr or 0)
	mem.widget.margin.bottom = dpi(mb or 0)

	mem.widget:connect_signal('mouse::enter',function(self) 
		self.bg = theme.widget_bg_hover
	end)

	mem.widget:connect_signal('mouse::leave',function(self) 
		self.bg = ""
	end)

	gears.timer({
		timeout   = 5,
		call_now  = true,
		autostart = true,
		callback  = mem.update
	})

	return mem.widget
end







return mem
