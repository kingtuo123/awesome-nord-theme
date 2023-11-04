local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local cpu = {}
cpu.update_timeout = 2
local core_num = 8


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


cpu.widget = wibox.widget{
	{
		{
			{
				id     = "bars",
				layout = wibox.layout.fixed.horizontal,
			},
			{
				id      = "cputb",
				text    = "1%",
				font    = theme.font,
				halign  = "left",
				visible = false,
				forced_width = dpi(35),
				widget  = wibox.widget.textbox,
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

	set_total = function(self,value)
		self:get_children_by_id("cputb")[1].text = "  " .. value .. "%"
	end
}


local function single_cpu_bar() 
	return wibox.widget {
		{
			id				 = "usage",
			margins 		 = {top = dpi(1), bottom = dpi(1), right = 0, left = 0 },
			max_value		 = 100,
			value			 = 0,
			bar_border_width = 0,
			forced_height	 = dpi(7),
			color			 = colors[1],
			background_color = theme.widget_bg_progressbar,
			--shape			 = function(cr, width, height)
			--	gears.shape.rounded_rect(cr, width, height, dpi(2))
			--end,
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
local active_old = {}
local total_old  = {}
local usage_old  = {}


for i = 1, core_num do
	bars[i] = single_cpu_bar()
	cpu.widget:get_children_by_id("bars")[1]:insert(i,bars[i])
end


for i = 1, core_num + 1 do
	active_old[i] = 0
	total_old[i]  = 0
	usage_old[i]  = 0
end


local function cpu_usage_cal(index,line)
    local total = 0
    local idle  = 0
    local at    = 1 
    for field in string.gmatch(line,"[%s]+([^%s]+)") do
        if at == 4 or at == 5 then
            idle = idle + field
        end
        total = total + field
        at = at + 1
    end
    if active_old[index] ~= active or total_old[index] ~= total then
        local active      = total - idle
        local dactive     = active - active_old[index]
        local dtotal      = total - total_old[index]
        local usage       = math.ceil((dactive/dtotal) * 100)
        total_old[index]  = total
        active_old[index] = active 
		usage_old[index]  = usage
		return usage
	else
		return usage_old[index]
    end
end


cpu.update = function()
	local file = io.open("/proc/stat","r")
	local line = file:read() or "0" 
	cpu.widget.total = cpu_usage_cal(core_num + 1,line)
	for i = 1,core_num do
		line = file:read() or "0" 
		bars[i].value = cpu_usage_cal(i,line)
	end
	file:close()
end


cpu.setup = function(mt,ml,mr,mb)
	cpu.widget.margin.top    = dpi(mt or 0)
	cpu.widget.margin.left   = dpi(ml or 0)
	cpu.widget.margin.right  = dpi(mr or 0)
	cpu.widget.margin.bottom = dpi(mb or 0)

	cpu.widget:connect_signal('mouse::enter',function(self) 
		self.bg = theme.widget_bg_hover
	end)

	cpu.widget:connect_signal('mouse::leave',function(self) 
		self.bg = ""
	end)

	cpu.widget:buttons(awful.util.table.join (
	--awful.button({}, 2, function() 
	--	awful.spawn("uxterm -e htop")
	--end),
	awful.button({}, 3, function() 
		local wdg = cpu.widget:get_children_by_id("cputb")[1]
		wdg.visible = not wdg.visible
	end)))

	gears.timer({
		timeout   = cpu.update_timeout,
		call_now  = false,
		autostart = true,
		callback  = cpu.update
	})

	return cpu.widget
end




return cpu
