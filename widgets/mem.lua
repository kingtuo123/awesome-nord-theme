local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local mem = {}
mem.update_timeout = 2


local colors = {
	theme.blue0,
	theme.blue0,
	theme.green,
	theme.green,
	theme.yellow,
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
				{
					{
						text = "M",
						font = "Terminus Bold 6",
						widget = wibox.widget.textbox,
					},
					{
						text = "E",
						font = "Terminus Bold 6",
						widget = wibox.widget.textbox,
					},
					{
						text = "M",
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
							{
								id = "buff graph",
								color = colors[5],
								min_value = 0,
								max_value = 20,
								step_width = dpi(1),
								step_spacing = 0,
								scale  = false,
								background_color = "",
								widget = wibox.widget.graph
							},
							{
								id = "used graph",
								color = colors[1],
								min_value = 0,
								max_value = 20,
								step_width = dpi(1),
								step_spacing = 0,
								scale  = false,
								background_color = "",
								widget = wibox.widget.graph
							},
							layout	= wibox.layout.stack,
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
	set_mem = function(self,mem)
		local buff = math.ceil(20 * (mem.buf_cache + mem.used) / mem.total)
		local used = math.ceil(20 * mem.used / mem.total)
		self:get_children_by_id("buff graph")[1]:add_value(buff)
		self:get_children_by_id("used graph")[1]:add_value(used)
		local color = colors[math.ceil(10 * mem.used / mem.total)]
		self:get_children_by_id("used graph")[1].color = color
		if color == theme.yellow then
			color = theme.orange
		else
			color = theme.yellow
		end
		self:get_children_by_id("buff graph")[1].color = color
	end,
}


mem.dashboard = wibox.widget{
	{
		{
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
						id = "buff graph",
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
						id = "used graph",
						color = colors[1],
						min_value = 0,
						max_value = 20,
						step_width = dpi(3),
						step_spacing = 0,
						scale  = false,
						background_color = "",
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
				--forced_height = dpi(149),  -- 2x50+49
				forced_height = dpi(59),  -- 2x20+19
				forced_width  = dpi(210), -- 3x70
				widget = wibox.container.mirror
			},
			{
				{
					{
						{
							id   = "used",
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
						check_border_width = 0,
						border_color = "",
						forced_height = dpi(10),
						forced_width = dpi(10),
						widget        = wibox.widget.checkbox,
					},
					id = "bc",
					bg = theme.yellow,
					widget = wibox.container.background,
				},
				{
					{
						text = "  buff/cache",
						font = "Microsoft YaHei Bold 8",
						widget = wibox.widget.textbox,
					},
					fg = theme.fg .. "aa",
					forced_height = dpi(10),
					widget = wibox.container.background,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			{
				margins = dpi(5),
				widget = wibox.container.margin,
			},
			{
				{
					{
						check_border_width = 0,
						border_color = "",
						forced_height = dpi(10),
						forced_width = dpi(10),
						widget        = wibox.widget.checkbox,
					},
					id = "uc",
					bg = theme.blue0,
					widget = wibox.container.background,
				},
				{
					{
						text = "  used",
						font = "Microsoft YaHei Bold 8",
						widget = wibox.widget.textbox,
					},
					fg = theme.fg .. "aa",
					forced_height = dpi(10),
					widget = wibox.container.background,
				},
				layout = wibox.layout.fixed.horizontal,
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
	set_mem = function(self, mem)
		local buff = math.ceil(20 * (mem.buf_cache + mem.used) / mem.total)
		local used = math.ceil(20 * mem.used / mem.total)
		self:get_children_by_id("buff graph")[1]:add_value(buff)
		self:get_children_by_id("used graph")[1]:add_value(used)
		local color = colors[math.ceil(10 * mem.used / mem.total)]
		self:get_children_by_id("used graph")[1].color = color
		self:get_children_by_id("uc")[1].bg = color
		if color == theme.yellow then
			color = theme.orange
		else
			color = theme.yellow
		end
		self:get_children_by_id("buff graph")[1].color = color
		self:get_children_by_id("bc")[1].bg = color
		self:get_children_by_id("used")[1].text = math.ceil(mem.used / 1024) .. " MB"
	end
}


mem.popup = awful.popup{
	widget			= mem.dashboard,
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


mem.update = function()
    mem_now = {}
    file	= io.open("/proc/meminfo","r")
	-- exec 'cat -n /proc/meminfo' to get line number
	lines = {
		{  1, "total"  },
		{  2, "free"   },
		{  3, "avail"  },
		{  4, "buffer" },
		{  5, "cached" },
		{ 24, "srec"   }
	}
	n = 1
	for i,v in pairs(lines) do
		if n == v[1] then
			mem_now[v[2]] = string.match(file:read(), "(%d+)")
			n = n + 1
		else
			while n < v[1] do
				file:read()
				n = n + 1
			end
			mem_now[v[2]] = string.match(file:read(), "(%d+)")
			n = n + 1
		end
	end
    file:close()
	mem_now.buf_cache = mem_now.buffer + mem_now.cached + mem_now.srec
    mem_now.used      = mem_now.total - mem_now.free - mem_now.buf_cache
    mem.widget.mem    = mem_now
	mem.dashboard.mem = mem_now
end


mem.setup = function(mt,ml,mr,mb)
	mem.widget.margin.top    = dpi(mt or 0)
	mem.widget.margin.left   = dpi(ml or 0)
	mem.widget.margin.right  = dpi(mr or 0)
	mem.widget.margin.bottom = dpi(mb or 0)

	mem.widget:connect_signal('mouse::enter',function(self) 
		if mem.popup.visible then
			mem.widget.bg = theme.widget_bg_press
		else
			mem.widget.bg = theme.widget_bg_hover
		end
	end)

	mem.widget:connect_signal('mouse::leave',function(self) 
		if mem.popup.visible then
			mem.widget.bg = theme.widget_bg_press
		else
			mem.widget.bg = ""
		end
	end)

	local function popup_move()	
		local m = mouse.coords()
		mem.popup.x = m.x - mem.popup_offset.x
		mem.popup.y = m.y - mem.popup_offset.y
		mousegrabber.stop()
	end

	mem.popup:buttons(gears.table.join(
		awful.button({ }, 1, function()
			mem.popup:connect_signal('mouse::move',popup_move)
			local m = mouse.coords()
			mem.popup_offset = {
				x = m.x - mem.popup.x,
				y = m.y - mem.popup.y
			}
			mem.popup:emit_signal('mouse::move', popup_move)
		end,function()
			mem.popup:disconnect_signal ('mouse::move',popup_move)
		end),
		awful.button({ }, 3, function ()
			mem.popup.visible = false
			mem.widget.bg = ""
		end)
	))

	mem.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			mem.popup.visible = not mem.popup.visible
			if mem.popup.visible then
				mem.widget.bg = theme.widget_bg_press
			else
				mem.widget.bg = theme.widget_bg_hover
			end
			mem.popup.x = mouse.coords().x - dpi(125)
			mem.popup.y = theme.popup_margin_top
		end)
	))

	gears.timer({
		timeout   = mem.update_timeout,
		call_now  = true,
		autostart = true,
		callback  = mem.update
	})

	return mem.widget
end







return mem
