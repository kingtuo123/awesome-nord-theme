local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local mpc   = require("libs.mpc")
local dpi	= require("beautiful.xresources").apply_dpi


local fcitx = {}


fcitx.widget = wibox.widget{
	{
		{
			{
				{
					id = "icon",
					image = theme.fcitx_icon,
					widget = wibox.widget.imagebox,
				},
				valign = "center",
				halign = "center",
				forced_height = dpi(17),
				forced_width = dpi(17),
				widget = wibox.container.place,
			},
			wibox.container.margin(_,dpi(5)),
			{
				id = "method",
				text = " -- ",
				valign = "center",
				halign = "left",
				widget = wibox.widget.textbox,
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
}



function fcitx:toggle()
	awful.spawn.easy_async_with_shell("fcitx5-remote -t", function(out)
		self:update()
	end)
end



function fcitx:update()
	awful.spawn.easy_async_with_shell("fcitx5-remote -n", function(out)
		if string.match(out, "pinyin.*") then
			self.widget:get_children_by_id("method")[1].text = "拼音"
			self.widget:get_children_by_id("method")[1].font = theme.fcitx_pinyin_font
			self.widget:get_children_by_id("icon")[1].image = theme.fcitx_pinyin_icon
			self.widget.bg = theme.fcitx_pinyin_bg
			self.widget.fg = theme.fcitx_pinyin_fg
		else
			self.widget:get_children_by_id("method")[1].text = "英文"
			self.widget:get_children_by_id("method")[1].font = theme.fcitx_font
			self.widget:get_children_by_id("icon")[1].image = theme.fcitx_icon
			self.widget.bg = theme.fcitx_bg
			self.widget.fg = theme.fcitx_fg
		end
	end)
end



function fcitx:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	self.widget:buttons(gears.table.join(
		awful.button({}, 1, nil, function()
			--self:update()
			self:toggle()
		end)
	))

	self.timer = gears.timer({
		timeout   = 0.5,
		call_now  = false,
		autostart = true,
		single_shot = true,
		callback  = function()
			self:update()
		end
	})

	return wibox.widget{
		self.widget,
		left = 0-theme.widget_border_width,
		widget = wibox.container.margin
	}
end

return fcitx
