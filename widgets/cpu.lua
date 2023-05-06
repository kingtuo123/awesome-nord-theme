local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local beautiful	 = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi 		 = xresources.apply_dpi



local cpu = {}
local core_num = 8
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


cpu.widget = wibox.widget{
	{
		id = "bars",
		layout = wibox.layout.fixed.horizontal,
	},
	{
		id = "cputb",
		text = "",
		font = theme.font,
		forced_width = dpi(45),
		 halign = "left",
		 visible = false,
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal,
	set_total = function(self,value)
		self.cputb.text = "  " .. value .. "%"
	end
}


cpu.buttons = awful.util.table.join (
	awful.button({}, 2, function() 
		awful.spawn("uxterm -e htop")
	end),
	awful.button({}, 3, function() 
		cpu.widget.cputb.visible = not cpu.widget.cputb.visible
	end)
)


single_cpu_bar = function() 
	return wibox.widget {
		{
			id				 = "usage",
			margins 		 = {top = dpi(1), bottom = dpi(1), right = 0, left = 0 },
			max_value		 = 100,
			value			 = 0,
			bar_border_width = 0,
			forced_height	 = dpi(8),
			color			 = theme.color10,
			background_color = theme.color3,
			shape			 = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, dpi(2))
			end,
			widget			 = wibox.widget.progressbar,
		},
		direction	= "east",
		layout		= wibox.container.rotate,
		set_value	= function(self,value)
			self.usage.value = value
			self.usage.color = colors[math.ceil(value/10)]
		end,
	}
end


local bars = {}
for i = 1, core_num do
	bars[i] = single_cpu_bar()
	cpu.widget.bars:insert(i,bars[i])
end


local active_old = {}
local total_old  = {}
local usage_old  = {}
for i = 1,core_num + 1 do
	active_old[i] = 0
	total_old[i]  = 0
	usage_old[i]  = 0
end
function cpu_usage_cal(index,line)
    local total = 0
    local idle = 0
    local at = 1 
    for field in string.gmatch(line,"[%s]+([^%s]+)") do
        if at == 4 or at == 5 then
            idle = idle + field
        end
        total = total + field
        at = at + 1
    end
    if active_old[index] ~= active or total_old[index] ~= total then
        local active = total - idle
        local dactive = active - active_old[index]
        local dtotal = total - total_old[index]
        local usage = math.ceil((dactive/dtotal) * 100)
        total_old[index] = total
        active_old[index] = active 
		usage_old[index] = usage
		return usage
	else
		return usage_old[index]
    end
end


cpu.timer = {
    timeout   = 2,
    call_now  = true,
    autostart = true,
    callback  = function()
		local file = io.open("/proc/stat","r")
		local line = file:read()
		cpu.widget.total = cpu_usage_cal(core_num + 1,line)
		for i = 1,core_num do
			line = file:read()
			bars[i].value = cpu_usage_cal(i,line)
		end
		file:close()
    end
}






return cpu
