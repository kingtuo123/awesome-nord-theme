local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi
local mem   = require("widgets.mem")

local cpu = {}
cpu.update_timeout = 2
cpu.threads = 8
-- select zone which -> /sys/class/thermal/thermal_zone2/type = x86_pkg_temp
cpu.temp_path = "/sys/class/thermal/thermal_zone2/temp"
cpu.stat_path = "/proc/stat"
cpu.freq_path = function(i) return "/sys/devices/system/cpu/cpu" .. i .. "/cpufreq/scaling_cur_freq" end


local colors = {
	theme.blue3,
	theme.blue2,
	theme.blue1,
	theme.blue0,
	"#8bc34a",
	"#8bc34a",
	theme.orange,
	theme.orange,
	theme.orange,
	theme.red,
}


cpu.widget = wibox.widget{
	{
		{
			{
				{
					{
						text = "C",
						font = "Terminus Bold 6",
						widget = wibox.widget.textbox,
					},
					{
						text = "P",
						font = "Terminus Bold 6",
						widget = wibox.widget.textbox,
					},
					{
						text = "U",
						font = "Terminus Bold 6",
						widget = wibox.widget.textbox,
					},
					forced_width = dpi(7),
					layout = wibox.layout.fixed.vertical,
				},
				fg = theme.popup_fg,
				widget = wibox.container.background,
			},
			{
				{
					{
						id     = "vertical_bars",
						layout = wibox.layout.fixed.horizontal,
					},
					margins = dpi(1.5),
					widget	= wibox.container.margin
				},
				bg = theme.widget_bg_graph,
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, dpi(0))
				end,
				widget = wibox.container.background,
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
	shape_border_color = "",
	widget = wibox.container.background,
}


cpu.dashboard = wibox.widget{
	{
		{
			{
				{
					{
						{
							text = "Load",
							font = "Microsoft YaHei Bold 9",
							widget = wibox.widget.textbox,
						},
						fg = theme.popup_fg,
						widget = wibox.container.background,
					},
					top    = dpi(0),
					bottom = dpi(5),
					widget = wibox.container.margin,
				},
				{
					{
						{
							{
								{
									id = "load graph",
									color = colors[1],
									min_value = 0,
									max_value = 20,
									step_width = dpi(3),
									step_spacing = 0,
									scale  = false,
									background_color = theme.bg_graph,
									widget = wibox.widget.graph
								},
								{
									image	= theme.cpu_graph_mask_img,
									resize  = true,
									widget	= wibox.widget.imagebox,
								},
								layout	= wibox.layout.stack,
							},
							reflection = {horizontal = true, vertical = false},
							forced_height = dpi(59),  -- 2x20+19
							forced_width  = dpi(210), -- 3x70
							widget = wibox.container.mirror
						},
						top = dpi(1.5),
						bottom = dpi(1.5),
						left = dpi(1.5),
						right = dpi(0.5),
						widget	= wibox.container.margin,
					},
					bg = theme.bg_graph,
					widget = wibox.container.background,
				},
				{
					{
						{
							{
								id   = "cpu load",
								text = "-- %",
								font = theme.font,
								widget = wibox.widget.textbox,
							},
							halign = "right",
							widget = wibox.container.place,
						},
						fg = theme.popup_fg,
						widget = wibox.container.background,
					},
					top    = dpi(3),
					bottom = dpi(0),
					widget = wibox.container.margin,
				},
				{
					{
						{
							text = "Temperature",
							font = "Microsoft YaHei Bold 9",
							widget = wibox.widget.textbox,
						},
						fg = theme.popup_fg,
						widget = wibox.container.background,
					},
					top    = dpi(0),
					bottom = dpi(5),
					widget = wibox.container.margin,
				},
				{
					{
						{
							{
								{
									id = "temp graph",
									color = colors[1],
									min_value = 0,
									max_value = 20,
									step_width = dpi(3),
									step_spacing = 0,
									scale  = false,
									background_color = theme.bg_graph,
									widget = wibox.widget.graph
								},
								{
									image	= theme.cpu_graph_mask_img,
									resize  = true,
									widget	= wibox.widget.imagebox,
								},
								layout	= wibox.layout.stack,
							},
							reflection = {horizontal = true, vertical = false},
							forced_height = dpi(59),
							forced_width  = dpi(210),
							widget = wibox.container.mirror,
						},
						top = dpi(1.5),
						bottom = dpi(1.5),
						left = dpi(1.5),
						right = dpi(0.5),
						widget	= wibox.container.margin,
					},
					bg = theme.bg_graph,
					widget = wibox.container.background,
				},
				{
					{
						{
							{
								id   = "cpu temp",
								text = "-- °C",
								font = theme.font,
								widget = wibox.widget.textbox,
							},
							halign = "right",
							widget = wibox.container.place,
						},
						fg = theme.popup_fg,
						widget = wibox.container.background,
					},
					top    = dpi(3),
					bottom = dpi(0),
					widget = wibox.container.margin,
				},
				{
					{
						{
							text = "Threads",
							font = "Microsoft YaHei Bold 9",
							widget = wibox.widget.textbox,
						},
						fg = theme.popup_fg,
						widget = wibox.container.background,
					},
					top    = dpi(0),
					bottom = dpi(5),
					widget = wibox.container.margin,
				},
				{
					id = "horizontal_bars",
					layout = wibox.layout.fixed.vertical,
				},
				layout = wibox.layout.fixed.vertical,
			},
			top    = dpi(5),
			left   = dpi(10),
			right  = dpi(10),
			bottom = dpi(5),
			id     = "margin",
			widget = wibox.container.margin,
		},
		bg = theme.popup_bg,
		widget = wibox.container.background,
	},
	top    = dpi(10),
	left   = dpi(10),
	right  = dpi(10),
	bottom = dpi(10),
	id     = "margin",
	widget = wibox.container.margin,

	set_load = function(self, value)
		self:get_children_by_id("load graph")[1]:add_value(math.ceil(value / 5))
		self:get_children_by_id("load graph")[1].color = colors[math.ceil(value / 10)]
		self:get_children_by_id("cpu load")[1].text    = value .. " %"
	end,
	set_temp = function(self, value)
		self:get_children_by_id("temp graph")[1]:add_value(math.ceil(value / 5000))
		self:get_children_by_id("temp graph")[1].color = colors[math.ceil(value / 10000)]
		self:get_children_by_id("cpu temp")[1].text    = math.ceil(value / 1000) .. " °C"
	end
}


cpu.popup = awful.popup{
	widget			= cpu.dashboard,
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.popup_bg,
	fg				= theme.popup_fg,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end
}


local function single_vertical_bar() 
	return wibox.widget {
		{
			id				 = "usage",
			--margins 		 = {top = dpi(1), bottom = dpi(1), right = 0, left = 0 },
			max_value		 = 20,
			value			 = 0,
			bar_border_width = 0,
			forced_height	 = dpi(4.5),
			color			 = colors[1],
			background_color = "",--theme.widget_bg_graph,
			--shape			 = function(cr, width, height)
			--	gears.shape.rounded_rect(cr, width, height, dpi(2))
			--end,
			widget			 = wibox.widget.progressbar,
		},
		direction	= "east",
		layout		= wibox.container.rotate,
		set_value	= function(self,value)
			self.usage.value = math.ceil(value/5)
			self.usage.color = colors[math.ceil(value/10)]
		end,
	}
end


local function single_horizontal_bar() 
	return wibox.widget{ 
		{
				id            = "bar",
				value         = 0,
				max_value     = 50,
				forced_height = dpi(20),
				forced_width  = dpi(100),
				margins       = {top = dpi(4.5), left = dpi(0), right = dpi(5), bottom = dpi(4.5)},
				color         = colors[1],
				background_color = theme.popup_bg_progressbar,
				paddings			= dpi(1),
				border_width		= dpi(1),
				border_color 		= "#dddddd",
				widget = wibox.widget.progressbar,	
		},
		{
			{
				{
					id   = "Usage",
					text = "--%",
					font = theme.font,
					font = "Microsoft YaHei 8",
					widget = wibox.widget.textbox,
				},
				halign = "left",
				valign = "center",
				forced_height = dpi(20),
				widget = wibox.container.place,
			},
			fg = theme.popup_fg,
			widget = wibox.container.background,
		},
		{
			nil,
			nil,
			{
				{
					{
						id   = "Freq",
						text = "-- MHz",
						font = theme.font,
						font = "Microsoft YaHei 8",
						widget = wibox.widget.textbox,
					},
					halign = "right",
					valign = "center",
					forced_height = dpi(20),
					widget = wibox.container.place,
				},
				fg = theme.popup_fg,
				widget = wibox.container.background,
			},
			--forced_width  = dpi(70),
			layout = wibox.layout.align.horizontal,
		},
		layout = wibox.layout.align.horizontal,
		set_value = function(self, value)
			self:get_children_by_id("bar")[1].value  = math.ceil(value / 2)
			self:get_children_by_id("bar")[1].color  = colors[math.ceil(value/10)]
			self:get_children_by_id("Usage")[1].text = value .. " %"
		
		end,
		set_freq = function(self, freq)
			self:get_children_by_id("Freq")[1].text  = math.ceil(freq / 1000) .. " MHz"
		end
	}
end


local vertical_bars = {}
local horizontal_bars = {}
local active_old = {}
local total_old  = {}
local usage_old  = {}


for i = 1, cpu.threads do
	vertical_bars[i] = single_vertical_bar()
	horizontal_bars[i] = single_horizontal_bar()
	cpu.widget:get_children_by_id("vertical_bars")[1]:insert(i,vertical_bars[i])
	cpu.dashboard:get_children_by_id("horizontal_bars")[1]:insert(i,horizontal_bars[i])
end


for i = 1, cpu.threads + 1 do
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
	local f1 = io.open(cpu.stat_path,"r")
	cpu.dashboard.load = cpu_usage_cal(cpu.threads + 1, f1:read() or "0")
	for i = 1, cpu.threads do
		local v = cpu_usage_cal(i, f1:read() or "0")
		vertical_bars[i].value = v
		horizontal_bars[i].value = v
		if cpu.popup.visible then
			local f2 = io.open(cpu.freq_path(i - 1))
			horizontal_bars[i].freq = f2:read() or "0"
			f2:close()
		end
	end
	f1:close()
	local f3 = io.open(cpu.temp_path)
	cpu.dashboard.temp = f3:read() or "0"
	f3:close()
end


cpu.setup = function(mt,ml,mr,mb)
	cpu.widget.margin.top    = dpi(mt or 0)
	cpu.widget.margin.left   = dpi(ml or 0)
	cpu.widget.margin.right  = dpi(mr or 0)
	cpu.widget.margin.bottom = dpi(mb or 0)

	cpu.widget:connect_signal('mouse::enter',function(self) 
		if cpu.popup.visible then
			cpu.widget.bg = theme.widget_bg_press
		else
			cpu.widget.bg = theme.widget_bg_hover
		end
		cpu.widget.shape_border_color = theme.widget_border_color
	end)

	cpu.widget:connect_signal('mouse::leave',function(self) 
		if cpu.popup.visible then
			cpu.widget.bg = theme.widget_bg_press
			cpu.widget.shape_border_color = theme.widget_border_color
		else
			cpu.widget.bg = ""
			cpu.widget.shape_border_color = ""
		end
	end)

	local function popup_move()	
		local m = mouse.coords()
		cpu.popup.x = m.x - cpu.popup_offset.x
		cpu.popup.y = m.y - cpu.popup_offset.y
		mousegrabber.stop()
	end

	cpu.popup:buttons(gears.table.join(
		awful.button({ }, 1, function()
			cpu.popup:connect_signal('mouse::move',popup_move)
			local m = mouse.coords()
			cpu.popup_offset = {
				x = m.x - cpu.popup.x,
				y = m.y - cpu.popup.y
			}
			cpu.popup:emit_signal('mouse::move', popup_move)
		end,function()
			cpu.popup:disconnect_signal ('mouse::move',popup_move)
		end),
		awful.button({ }, 3, function ()
			cpu.popup.visible = false
			cpu.widget.bg = ""
			cpu.widget.shape_border_color = ""
		end)
	))

	cpu.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			cpu.popup.x = mouse.coords().x - dpi(125)
			cpu.popup.y = theme.popup_margin_top
			cpu.popup.visible = not cpu.popup.visible
			if cpu.popup.visible then
				cpu.widget.bg = theme.widget_bg_press
			else
				cpu.widget.bg = theme.widget_bg_hover
			end
		end)
	))

	gears.timer({
		timeout   = cpu.update_timeout,
		call_now  = false,
		autostart = true,
		callback  = cpu.update
	})

	return cpu.widget
end




return cpu
