local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local mem = {}
local update_timeout = 2


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


mem.widget = wibox.widget {
	{
		{
			{
				{
					{
						text = " M",
						font = "Terminus Bold 6",
						widget = wibox.widget.textbox,
					},
					{
						text = " E",
						font = "Terminus Bold 6",
						widget = wibox.widget.textbox,
					},
					{
						text = " M",
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
						{
							{
								id = "buff graph",
								color = theme.mem_buffer_color,
								min_value = 0,
								max_value = 25,
								step_width = dpi(2),
								step_spacing = 0,
								scale  = false,
								background_color = "",
								widget = wibox.widget.graph
							},
							{
								id = "used graph",
								color = colors[1],
								min_value = 0,
								max_value = 25,
								step_width = dpi(2),
								step_spacing = 0,
								scale  = false,
								background_color = "",
								widget = wibox.widget.graph
							},
							layout	= wibox.layout.stack,
						},
						reflection = {horizontal = true, vertical = false},
						forced_width = dpi(40),
						widget = wibox.container.mirror
					},
					margins = dpi(1),
					widget	= wibox.container.margin,
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
	set_mem = function(self,mem)
		local used = math.ceil(25 * mem.used / mem.total)
		local buff = math.ceil(25 * mem.buf_cache / mem.total) + used
		self:get_children_by_id("buff graph")[1]:add_value(buff)
		self:get_children_by_id("used graph")[1]:add_value(used)
		local color = colors[math.ceil(10 * mem.used / mem.total)]
		self:get_children_by_id("used graph")[1].color = color
	end,
}


local dashboard = wibox.widget{
	{
		{
			{
				{
					{
						text = "Memory",
						font = theme.mem_title_font,
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
								id = "buff graph",
								color = theme.mem_buffer_color,
								min_value = 0,
								max_value = 25,
								step_width = dpi(3),
								step_spacing = 0,
								scale  = false,
								background_color = theme.popup_bg_graph,
								widget = wibox.widget.graph
							},
							{
								id = "used graph",
								color = colors[1],
								min_value = 0,
								max_value = 25,
								step_width = dpi(3),
								step_spacing = 0,
								scale  = false,
								background_color = "",
								widget = wibox.widget.graph
							},
							{
								image	= theme.mem_graph_mask_img,
								resize  = true,
								widget	= wibox.widget.imagebox,
							},
							layout	= wibox.layout.stack,
						},
						reflection = {horizontal = true, vertical = false},
						forced_height = dpi(74),  -- 3x25-1
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
					gears.shape.rounded_rect(cr, width, height, dpi(5))
				end,
				shape_border_width = dpi(0),
				shape_border_color = theme.widget_border_color,
				widget = wibox.container.background,
			},
			{
				margins = dpi(5),
				widget = wibox.container.margin,
			},
			{
				{
					{
						check_border_width = 0,
						border_color  = "",
						forced_height = dpi(10),
						forced_width  = dpi(10),
						widget        = wibox.widget.checkbox,
					},
					id = "fc",
					bg = theme.popup_bg_graph,
					shape = function(cr, width, height)
						gears.shape.rounded_rect(cr, width, height, dpi(3))
					end,
					shape_border_width = dpi(0),
					shape_border_color = "", --theme.widget_border_color,
					widget = wibox.container.background,
				},
				{
					{
						text = " free",
						font = theme.mem_font,
						widget = wibox.widget.textbox,
					},
					fg = theme.popup_fg,
					widget = wibox.container.background,
				},
				{
					{
						{
							id   = "free",
							text = "-- MB",
							font = theme.mem_font,
							widget = wibox.widget.textbox,
						},
						halign = "right",
						widget = wibox.container.place,
					},
					fg = theme.popup_fg,
					widget = wibox.container.background,
				},
				forced_height = dpi(10),
				layout = wibox.layout.align.horizontal,
			},
			{
				margins = dpi(5),
				widget = wibox.container.margin,
			},
			{
				{
					{
						check_border_width = 0,
						border_color  = "",
						forced_height = dpi(10),
						forced_width  = dpi(10),
						widget        = wibox.widget.checkbox,
					},
					id = "bc",
					bg = theme.mem_buffer_color,
					shape = function(cr, width, height)
						gears.shape.rounded_rect(cr, width, height, dpi(3))
					end,
					shape_border_width = dpi(0),
					shape_border_color = theme.popup_bg,
					widget = wibox.container.background,
				},
				{
					{
						text = " buff/cache",
						font = theme.mem_font,
						widget = wibox.widget.textbox,
					},
					fg = theme.popup_fg,
					widget = wibox.container.background,
				},
				{
					{
						{
							id   = "buff",
							text = "-- MB",
							font = theme.mem_font,
							widget = wibox.widget.textbox,
						},
						halign = "right",
						widget = wibox.container.place,
					},
					fg = theme.popup_fg,
					widget = wibox.container.background,
				},
				forced_height = dpi(10),
				layout = wibox.layout.align.horizontal,
			},
			{
				margins = dpi(5),
				widget = wibox.container.margin,
			},
			{
				{
					{
						check_border_width = 0,
						border_color  = "",
						forced_height = dpi(10),
						forced_width  = dpi(10),
						widget        = wibox.widget.checkbox,
					},
					id = "uc",
					shape = function(cr, width, height)
						gears.shape.rounded_rect(cr, width, height, dpi(3))
					end,
					shape_border_width = dpi(0),
					shape_border_color = theme.popup_bg,
					widget = wibox.container.background,
				},
				{
					{
						text = " used",
						font = theme.mem_font,
						widget = wibox.widget.textbox,
					},
					fg = theme.popup_fg,
					widget = wibox.container.background,
				},
				{
					{
						{
							id   = "used",
							text = "-- MB",
							font = theme.mem_font,
							widget = wibox.widget.textbox,
						},
						halign = "right",
						widget = wibox.container.place,
					},
					fg = theme.popup_fg,
					widget = wibox.container.background,
				},
				forced_height = dpi(10),
				layout = wibox.layout.align.horizontal,
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
	bg = theme.popup_bg,
	widget = wibox.container.background,
	set_mem = function(self, all)
		local used = math.ceil(25 * all.used / all.total)
		local buff = math.ceil(25 * all.buf_cache / all.total) + used
		self:get_children_by_id("buff graph")[1]:add_value(buff)
		self:get_children_by_id("used graph")[1]:add_value(used)
		local color = colors[math.ceil(10 * all.used / all.total)]
		self:get_children_by_id("used graph")[1].color = color
		self:get_children_by_id("uc")[1].bg = color
		if tonumber(all.free) >= 1048576 then
			self:get_children_by_id("free")[1].text = string.format("%.1f GiB", all.free / 1048576)
		else
			self:get_children_by_id("free")[1].text = string.format("%d MiB", math.ceil(all.free / 1024))
		end
		if tonumber(all.buf_cache) >= 1048576 then
			self:get_children_by_id("buff")[1].text = string.format("%.1f GiB", all.buf_cache / 1048576)
		else
			self:get_children_by_id("buff")[1].text = string.format("%d MiB", math.ceil(all.buf_cache / 1024))
		end
		if tonumber(all.used) >= 1048576 then
			self:get_children_by_id("used")[1].text = string.format("%.1f GiB", all.used / 1048576)
		else
			self:get_children_by_id("used")[1].text = string.format("%d MiB", math.ceil(all.used / 1024))
		end
	end
}


mem.popup = awful.popup{
	widget			= dashboard,
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


mem.update = function()
    mem_now = {}
    file = io.open("/proc/meminfo","r")
	-- run 'cat -n /proc/meminfo' to get line number
	lines = {
		{  1, "total"  },
		{  2, "free"   },
		{  3, "avail"  },
		{  4, "buffer" },
		{  5, "cached" },
		{ 24, "srec"   }
	}
	n = 1
	for _,v in pairs(lines) do
		while n < v[1] do
			file:read()
			n = n + 1
		end
		mem_now[v[2]] = string.match(file:read(), "(%d+)")
		n = n + 1
	end
    file:close()
	mem_now.buf_cache = mem_now.buffer + mem_now.cached + mem_now.srec
    mem_now.used      = mem_now.total - mem_now.free - mem_now.buf_cache
    mem.widget.mem    = mem_now
	dashboard.mem     = mem_now
end


mem.setup = function(mt,ml,mr,mb)
	mem.widget.margin.top    = dpi(mt or 0)
	mem.widget.margin.left   = dpi(ml or 0)
	mem.widget.margin.right  = dpi(mr or 0)
	mem.widget.margin.bottom = dpi(mb or 0)

	--[[
	mem.widget:connect_signal('mouse::enter',function(self) 
		if mem.popup.visible then
			mem.widget.bg = theme.widget_bg_press
		else
			mem.widget.bg = theme.widget_bg_hover
		end
		mem.widget.shape_border_color = theme.widget_border_color
	end)

	mem.widget:connect_signal('mouse::leave',function(self) 
		if mem.popup.visible then
			mem.widget.bg = theme.widget_bg_press
			mem.widget.shape_border_color = theme.widget_border_color
		else
			mem.widget.bg = theme.topbar_bg
			mem.widget.shape_border_color = theme.topbar_bg
		end
	end)
	--]]

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
			mem.popup:disconnect_signal ('mouse::move',popup_move)
			mem.popup.visible = false
			mem.widget.bg = theme.topbar_bg
			mem.widget.shape_border_color = theme.topbar_bg
		end)
	))

	mem.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			if mem.popup.visible then
				mem.popup.visible = false
				--mem.widget.bg = theme.widget_bg_press
			else
				mem.popup.x = mouse.coords().x - dpi(126)
				mem.popup.y = theme.popup_margin_top
				mem.popup.visible = true
				--mem.widget.bg = theme.widget_bg_hover
			end
			--mem.widget.shape_border_color = theme.widget_border_color
		end)
	))

	gears.timer({
		timeout   = update_timeout,
		call_now  = true,
		autostart = true,
		callback  = mem.update
	})

	return mem.widget
end







return mem
