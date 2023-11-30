local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local gpu = {}
gpu.update_timeout = 2
cmd_gpu_info = "nvidia-smi|sed -n 10p"


local colors = {
	theme.blue0,
	theme.blue0,
	theme.green,
	theme.green,
	theme.green,
	theme.yellow,
	theme.yellow,
	theme.orange,
	theme.orange,
	theme.red,
	theme.red,
}


gpu.widget = wibox.widget {
	{
		{
			{
				{
					{
						text = "G",
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
				fg = theme.fg,
				widget = wibox.container.background,
			},
			{
				{
					{
						{
							id = "gpu graph",
							color = colors[5],
							min_value = 0,
							max_value = 20,
							step_width = dpi(2),
							step_spacing = 0,
							scale  = false,
							background_color = "",
							widget = wibox.widget.graph
						},
						reflection = {horizontal = true, vertical = false},
						forced_width = dpi(35),
						widget = wibox.container.mirror
					},
					margins = dpi(2),
					widget	= wibox.container.margin,
				},
				bg = theme.widget_bg_graph,
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, dpi(2))
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
	shape_border_color = theme.widget_border_color,
	widget = wibox.container.background,

	set_gpu = function(self,gpu)
		self:get_children_by_id("gpu graph")[1]:add_value(math.ceil(gpu.util / 5))
		self:get_children_by_id("gpu graph")[1].color = colors[math.ceil(gpu.util / 10)] or theme.blue0
	end,
}


gpu.dashboard = wibox.widget{
	{
		{
			{
				{
					{
						text = "Utilization",
						font = theme.font,
						widget = wibox.widget.textbox,
					},
					fg = theme.fg .. "aa",
					widget = wibox.container.background,
				},
				top    = dpi(0),
				bottom = dpi(5),
				widget = wibox.container.margin,
			},
			{
				{
					{
						id = "util graph",
						color = colors[5],
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
			{
				{
					{
						{
							id   = "util",
							text = "-- %",
							font = theme.font,
							widget = wibox.widget.textbox,
						},
						halign = "right",
						widget = wibox.container.place,
					},
					fg = theme.fg,
					widget = wibox.container.background,
				},
				top    = dpi(3),
				bottom = dpi(0),
				widget = wibox.container.margin,
			},
			{
				{
					{
						text = "Memory",
						font = theme.font,
						widget = wibox.widget.textbox,
					},
					fg = theme.fg .. "aa",
					widget = wibox.container.background,
				},
				top    = dpi(0),
				bottom = dpi(5),
				widget = wibox.container.margin,
			},
			{
				{
					{
						id = "mem graph",
						color = colors[5],
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
			{
				{
					{
						{
							id   = "mem",
							text = "-- MB",
							font = theme.font,
							widget = wibox.widget.textbox,
						},
						halign = "right",
						widget = wibox.container.place,
					},
					fg = theme.fg,
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
						font = theme.font,
						widget = wibox.widget.textbox,
					},
					fg = theme.fg .. "aa",
					widget = wibox.container.background,
				},
				top    = dpi(0),
				bottom = dpi(5),
				widget = wibox.container.margin,
			},
			{
				{
					{
						id = "temp graph",
						color = colors[5],
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
			{
				{
					{
						{
							id   = "temp",
							text = "-- °C",
							font = theme.font,
							widget = wibox.widget.textbox,
						},
						halign = "right",
						widget = wibox.container.place,
					},
					fg = theme.fg,
					widget = wibox.container.background,
				},
				top    = dpi(3),
				bottom = dpi(0),
				widget = wibox.container.margin,
			},
			layout = wibox.layout.fixed.vertical,
		},
		top    = dpi(15),
		left   = dpi(20),
		right  = dpi(20),
		bottom = dpi(15),
		id     = "margin",
		widget = wibox.container.margin,
	},
	bg = theme.bg,
	widget = wibox.container.background,
	set_gpu = function(self, gpu)
		self:get_children_by_id("util graph")[1]:add_value(math.ceil(gpu.util / 5))
		self:get_children_by_id("util")[1].text = gpu.util .. " %"
		self:get_children_by_id("util graph")[1].color = colors[math.ceil(gpu.util / 10)] or theme.blue0

		self:get_children_by_id("mem graph")[1]:add_value(math.ceil(20 * gpu.mem / gpu.mem_total))
		self:get_children_by_id("mem")[1].text = gpu.mem .. " MB"
		self:get_children_by_id("mem graph")[1].color = colors[math.ceil(10 * gpu.mem / gpu.mem_total)] or theme.blue0

		self:get_children_by_id("temp graph")[1]:add_value(math.ceil(gpu.temp / 5))
		self:get_children_by_id("temp")[1].text = gpu.temp .. " °C"
		self:get_children_by_id("temp graph")[1].color = colors[math.ceil(gpu.temp / 10)] or theme.blue0
	end
}



gpu.popup = awful.popup{
	widget			= gpu.dashboard,
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.bg,
	fg				= theme.fg,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end
}



gpu.update = function()
	awful.spawn.easy_async_with_shell(cmd_gpu_info, function(out)
		local v = {}
		v.temp = string.match(out,"(%d+)C")
		v.mem  = string.match(out,"(%d+)MiB")
		v.util = string.match(out,"(%d+)%%")
		v.mem_total = string.match(out,"/%s+(%d+)MiB")
		gpu.widget.gpu = v
		gpu.dashboard.gpu = v
	end)
end


gpu.setup = function(mt,ml,mr,mb)
	gpu.widget.margin.top    = dpi(mt or 0)
	gpu.widget.margin.left   = dpi(ml or 0)
	gpu.widget.margin.right  = dpi(mr or 0)
	gpu.widget.margin.bottom = dpi(mb or 0)

	gpu.widget:connect_signal('mouse::enter',function(self) 
		if gpu.popup.visible then
			gpu.widget.bg = theme.widget_bg_press
		else
			gpu.widget.bg = theme.widget_bg_hover
		end
	end)

	gpu.widget:connect_signal('mouse::leave',function(self) 
		if gpu.popup.visible then
			gpu.widget.bg = theme.widget_bg_press
		else
			gpu.widget.bg = ""
		end
	end)

	local function popup_move()	
		local m = mouse.coords()
		gpu.popup.x = m.x - gpu.popup_offset.x
		gpu.popup.y = m.y - gpu.popup_offset.y
		mousegrabber.stop()
	end

	gpu.popup:buttons(gears.table.join(
		awful.button({ }, 1, function()
			gpu.popup:connect_signal('mouse::move',popup_move)
			local m = mouse.coords()
			gpu.popup_offset = {
				x = m.x - gpu.popup.x,
				y = m.y - gpu.popup.y
			}
			gpu.popup:emit_signal('mouse::move', popup_move)
		end,function()
			gpu.popup:disconnect_signal ('mouse::move',popup_move)
		end),
		awful.button({ }, 3, function ()
			gpu.popup.visible = false
			gpu.widget.bg = ""
		end)
	))

	gpu.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			gpu.popup.visible = not gpu.popup.visible
			if gpu.popup.visible then
				gpu.widget.bg = theme.widget_bg_press
			else
				gpu.widget.bg = theme.widget_bg_hover
			end
			gpu.popup.x = mouse.coords().x - dpi(125)
			gpu.popup.y = theme.popup_margin_top
		end)
	))

	gears.timer({
		timeout   = gpu.update_timeout,
		call_now  = true,
		autostart = true,
		callback  = gpu.update
	})

	return gpu.widget
end







return gpu
