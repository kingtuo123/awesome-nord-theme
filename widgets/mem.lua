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
	shape_border_color = theme.widget_border_color,
	bg = theme.widget_bg,
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




mem.popup = awful.popup{
	widget = wibox.widget{
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
						gears.shape.rounded_rect(cr, width, height, dpi(3))
					end,
					shape_border_width = dpi(1),
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




function mem:update()
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
    mem_now.used = mem_now.total - mem_now.free - mem_now.buf_cache
    self.widget.mem = mem_now
	self.popup.widget.mem = mem_now
end




function mem:setup(mt,ml,mr,mb)
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
			self.widget.bg = theme.widget_bg
			self.widget.shape_border_color = theme.widget_border_color
		end)
	))

	self.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			if self.popup.visible then
				self.popup.visible = false
				self.widget.bg = theme.widget_bg_press
			else
				self.popup.x = mouse.coords().x - dpi(126)
				self.popup.y = theme.popup_margin_top
				self.popup.visible = true
				self.widget.bg = theme.widget_bg_hover
			end
			self.widget.shape_border_color = theme.widget_border_color
		end)
	))

	self.widget:connect_signal('mouse::enter',function() 
		if self.popup.visible then
			self.widget.bg = theme.widget_bg_press
		else
			self.widget.bg = theme.widget_bg_hover
		end
		self.widget.shape_border_color = theme.widget_border_color
	end)

	self.widget:connect_signal('mouse::leave',function() 
		if self.popup.visible then
			self.widget.bg = theme.widget_bg_press
			self.widget.shape_border_color = theme.widget_border_color
		else
			self.widget.bg = theme.widget_bg
			self.widget.shape_border_color = theme.widget_border_color
		end
	end)

	gears.timer({
		timeout   = update_timeout,
		call_now  = true,
		autostart = true,
		callback  = function()
			self:update()
		end
	})

	--return self.widget
	return wibox.widget{
		self.widget,
		left = dpi(0-theme.widget_border_width/2),
		widget = wibox.container.margin
	}
end




return mem
