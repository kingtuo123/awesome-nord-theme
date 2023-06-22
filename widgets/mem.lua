local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local beautiful	 = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi 		 = xresources.apply_dpi



local mem = {}
local colors = {
	theme.color10,
	theme.color9,
	theme.color8,
	theme.color7,
	theme.color14,
	theme.color14,
	theme.color13,
	theme.color12,
	theme.color12,
	theme.color11,
	theme.color11,
}

mem.widget = wibox.widget {
	{
		id					= "bar",
		margins				= { top = dpi(10), bottom = 0, right = 0, left = 0 },
		max_value			= 100,
		value				= 0,
		bar_border_width	= 0,
		forced_width  		= dpi(55),
		color				= theme.color10,
		background_color	= theme.widget_bg,
		shape				= function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, dpi(2))
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
				fg		= theme.color3,
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
	set_mem = function(self,v)
		idx		= math.ceil(10*v.used/v.total)
		v.used	= string.format("%.1f",v.used/1048576)
		v.total	= string.format("%.1f",v.total/1048576)
		self:get_children_by_id('bar')[1].value		= v.used
		self:get_children_by_id('bar')[1].max_value	= v.total
		self:get_children_by_id('used')[1].text		= v.used
		self:get_children_by_id('total')[1].text	= v.total
		self:get_children_by_id('bar')[1].color		= colors[idx]
	end,
}


function mem_update()
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


mem.timer = {
    timeout   = 5,
    call_now  = true,
    autostart = true,
    callback  = mem_update
}







return mem
