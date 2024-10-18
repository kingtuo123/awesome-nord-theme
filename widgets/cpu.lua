local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi




local cpu = {}
local update_timeout = 2
local threads = 16
local stat_path = "/proc/stat"
local freq_path = function(i) return "/sys/devices/system/cpu/cpu" .. i .. "/cpufreq/scaling_cur_freq" end


-- select temp file which -> /sys/class/thermal/thermal_zone2/type == x86_pkg_temp
local temp_enable = true
local temp_path = "/sys/class/thermal/thermal_zone1/temp"
local cmd_get_temp = "sensors k10temp-pci-00c3|grep Tctl"
local colors = {
	"#7aa2f7",
	"#7aa2f7",
	"#7dcfff",
	"#7dcfff",
	"#9ece6a",
	"#9ece6a",
	"#e0af68",
	"#e0af68",
	"#f7768e",
	"#f7768e",
}




cpu.widget = wibox.widget{
	{
		{
			{
				{
					{
						text = " C",
						font = " Terminus Bold 6",
						widget = wibox.widget.textbox,
					},
					{
						text = " P",
						font = "Terminus Bold 6",
						widget = wibox.widget.textbox,
					},
					{
						text = " U",
						font = "Terminus Bold 6",
						widget = wibox.widget.textbox,
					},
					forced_width = dpi(10),
					layout = wibox.layout.flex.vertical,
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
					margins = dpi(1),
					widget	= wibox.container.margin
				},
				bg = theme.widget_bg_graph,
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, dpi(2))
				end,
				shape_border_width = dpi(1),
				shape_border_color = theme.border_normal .. "99",
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




cpu.popup = awful.popup{
	widget = wibox.widget{
		{
			{
				{
					{
						{
							{
								text = "Load",
								font = theme.cpu_title_font,
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
										max_value = 25,
										step_width = dpi(3),
										step_spacing = 0,
										scale  = false,
										background_color = theme.popup_bg_graph,
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
								forced_height = dpi(74),
								forced_width  = dpi(210), -- 3x70
								widget = wibox.container.mirror
							},
							top = dpi(2),
							bottom = dpi(2),
							left = dpi(2),
							right = dpi(1),
							widget	= wibox.container.margin,
						},
						bg = theme.popup_bg_graph,
						shape = function(cr, width, height)
							gears.shape.rounded_rect(cr, width, height, dpi(3))
						end,
						shape_border_width = dpi(1),
						shape_border_color = theme.widget_border_color,
						widget = wibox.container.background,
					},
					{
						{
							{
								{
									id   = "cpu load",
									text = "-- %",
									font = theme.cpu_font,
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
								font = theme.cpu_title_font,
								widget = wibox.widget.textbox,
							},
							fg = theme.popup_fg,
							widget = wibox.container.background,
						},
						top     = dpi(0),
						bottom  = dpi(5),
						visible = temp_enable,
						widget  = wibox.container.margin,
					},
					{
						{
							{
								{
									{
										id = "temp graph",
										color = colors[1],
										min_value = 0,
										max_value = 25,
										step_width = dpi(3),
										step_spacing = 0,
										scale  = false,
										background_color = theme.popup_bg_graph,
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
								forced_height = dpi(74),
								forced_width  = dpi(210),
								widget = wibox.container.mirror,
							},
							top = dpi(2),
							bottom = dpi(2),
							left = dpi(2),
							right = dpi(1),
							widget	= wibox.container.margin,
						},
						bg = theme.popup_bg_graph,
						shape = function(cr, width, height)
							gears.shape.rounded_rect(cr, width, height, dpi(3))
						end,
						shape_border_width = dpi(1),
						shape_border_color = theme.widget_border_color,
						visible = temp_enable,
						widget = wibox.container.background,
					},
					{
						{
							{
								{
									id   = "cpu temp",
									text = "-- °C",
									font = theme.cpu_font,
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
						visible = temp_enable,
						widget = wibox.container.margin,
					},
					{
						{
							{
								text = "Threads",
								font = theme.cpu_title_font,
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
			self:get_children_by_id("load graph")[1]:add_value(math.ceil(value / 4))
			self:get_children_by_id("load graph")[1].color = colors[math.ceil(value / 10)]
			self:get_children_by_id("cpu load")[1].text    = value .. " %"
		end,
		set_temp = function(self, value)
			--self:get_children_by_id("temp graph")[1]:add_value(math.ceil(value / 5000))
			--self:get_children_by_id("temp graph")[1].color = colors[math.ceil(value / 10000)]
			--self:get_children_by_id("cpu temp")[1].text    = math.ceil(value / 1000) .. " °C"
			self:get_children_by_id("temp graph")[1]:add_value(math.ceil(25 * value / 100))
			self:get_children_by_id("temp graph")[1].color = colors[math.ceil((value-5) / 10)]
			self:get_children_by_id("cpu temp")[1].text    = value .. " °C"
		end
	},
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
			margins 		 = {top = dpi(0), bottom = dpi(0), right = 0, left = 0 },
			max_value		 = 20,
			value			 = 0,
			bar_border_width = 0,
			forced_height	 = dpi(2.5),
			color			 = colors[1],
			background_color = theme.widget_bg_graph,
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
			forced_height = dpi(22),
			forced_width  = dpi(105),
			margins       = {top = dpi(6), left = dpi(0), right = dpi(5), bottom = dpi(7)},
			color         = colors[1],
			paddings	  = dpi(0),
			border_width  = dpi(0),
			border_color  = theme.popup_progress_border_color,
			background_color = theme.popup_bg_progressbar,
			widget = wibox.widget.progressbar,	
			shape			= function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, dpi(3))
			end,
			bar_shape		= function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, dpi(3))
			end
		},
		{
			{
				{
					{
						id   = "Usage",
						text = "--%",
						font = theme.cpu_font,
						widget = wibox.widget.textbox,
					},
					halign = "left",
					valign = "center",
					forced_height = dpi(22),
					widget = wibox.container.place,
				},
				fg = theme.popup_fg,
				widget = wibox.container.background,
			},
			{
				{
					{
						id   = "Freq",
						text = "-- MHz",
						font = theme.cpu_font,
						widget = wibox.widget.textbox,
					},
					halign = "right",
					valign = "center",
					forced_height = dpi(22),
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




for i = 1, threads do
	vertical_bars[i] = single_vertical_bar()
	horizontal_bars[i] = single_horizontal_bar()
	cpu.widget:get_children_by_id("vertical_bars")[1]:insert(i,vertical_bars[i])
	cpu.popup.widget:get_children_by_id("horizontal_bars")[1]:insert(i,horizontal_bars[i])
end




for i = 1, threads + 1 do
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




function cpu:update()
	local f1 = io.open(stat_path,"r")
	cpu.popup.widget.load = cpu_usage_cal(threads + 1, f1:read() or "0")
	for i = 1, threads do
		local v = cpu_usage_cal(i, f1:read() or "0")
		vertical_bars[i].value = v
		horizontal_bars[i].value = v
		if self.popup.visible then
			local f2 = io.open(freq_path(i - 1))
			horizontal_bars[i].freq = f2:read() or "0"
			f2:close()
		end
	end
	f1:close()
	if temp_enable then
		--local f3 = io.open(temp_path)
		--self.popup.widget.temp = f3:read() or "0"
		--f3:close()
		awful.spawn.easy_async_with_shell(cmd_get_temp, function(out)
			self.popup.widget.temp = tonumber(string.match(out,"%d+"))
		end)
	end
end




function cpu:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	local function popup_move()	
		local m = mouse.coords()
		self.popup.x = m.x - self.popup_offset.x
		self.popup.y = m.y - self.popup_offset.y
		mousegrabber.stop()
	end

	self.popup:buttons(gears.table.join(
		awful.button({ }, 1, function()
			self.popup:connect_signal('mouse::move',popup_move)
			local m = mouse.coords()
			self.popup_offset = {
				x = m.x - self.popup.x,
				y = m.y - self.popup.y
			}
			self.popup:emit_signal('mouse::move', popup_move)
		end,function()
			self.popup:disconnect_signal ('mouse::move',popup_move)
		end),
		awful.button({ }, 3, function ()
			self.popup:disconnect_signal ('mouse::move',popup_move)
			self.popup.visible = false
			self.widget.bg = ""
			self.widget.shape_border_color = ""
		end)
	))

	self.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			if self.popup.visible then
				self.popup.visible = false
				--self.widget.bg = theme.widget_bg_press
			else
				self.popup.x = mouse.coords().x - dpi(125)
				self.popup.y = theme.popup_margin_top
				self.popup.visible = true
				--self.widget.bg = theme.widget_bg_hover
			end
		end)
	))

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




return cpu
