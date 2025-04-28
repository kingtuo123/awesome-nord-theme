local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local v2ray = {}


v2ray.widget = wibox.widget{
	{
		{
			{
				{
					id = "icon",
					image = theme.v2ray_icon,
					widget = wibox.widget.imagebox,
				},
				valign = "center",
				halign = "center",
				--forced_height = dpi(16),
				--forced_width = dpi(16),
				widget = wibox.container.place,
			},
			--{
			--	left = dpi(5),
			--	widget	= wibox.container.margin,
			--},
			--{
			--	{
			--		{
			--			id		= "status",
			--			text 	= "OFF",
			--			font = "Terminus Bold 7",
			--			widget	= wibox.widget.textbox,
			--		},
			--		valign = "bottom",
			--		halign = "left",
			--		widget = wibox.container.place,
			--	},
			--	{
			--		{
			--			id		= "icon",
			--			image	= theme.switch_off_icon,
			--			forced_width = dpi(15),
			--			widget = wibox.widget.imagebox,
			--		},
			--		valign = "top",
			--		halign = "left",
			--		widget = wibox.container.place,
			--	},
			--	layout = wibox.layout.fixed.vertical,
			--},
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

	backup_status = "off",
	set_status = function(self,value)
		if value == "on" then
			v2ray.widget:get_children_by_id("icon")[1].image = theme.v2ray_icon
			self.backup_status = "on"
		else
			v2ray.widget:get_children_by_id("icon")[1].image = theme.v2ray_off_icon
			self.backup_status = "off"
		end
	end,
	get_status = function(self)
		return self.backup_status
	end,
}


function v2ray:update()
	awful.spawn.easy_async_with_shell("pgrep v2raya", function(out)
		if #out > 1 then
			v2ray.widget.status = "on"
		else
			v2ray.widget.status = "off"
		end
	end)
end


function v2ray:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	self.widget:connect_signal('mouse::enter',function() 
		self.widget.bg = theme.widget_bg_hover
		v2ray:update()
	end)
	self.widget:connect_signal('mouse::leave',function() 
		self.widget.bg = theme.widget_bg
	end)

	self.widget:buttons(awful.util.table.join(
		awful.button({}, 2, nil, function() 
			if self.widget.status == "off" then
				self.widget.status = "on"
				awful.spawn.with_shell("v2raya --lite > /dev/null&")
			else
				awful.spawn.with_shell("killall v2raya &> /dev/null ; killall xray &> /dev/null")
				self.widget.status = "off"
			end
		end)
	))

	gears.timer({
		timeout   = 10,
		call_now  = true,
		autostart = true,
		callback  = function()
			self:update()
		end
	})

	--return self.widget
	return wibox.widget{
		self.widget,
		left = 0-theme.widget_border_width,
		widget = wibox.container.margin
	}
end


return v2ray
