local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi
local battery = require("widgets.panel.battery")


local avatar = {}
local cmd_user   = "whoami"
local cmd_uptime = "uptime -p"


avatar.widget = wibox.widget{
	{
		{
			id     = "photo",
			image  = theme.panel_avatar_img,
			resize = true,
			forced_height = dpi(50),
			forced_width  = dpi(50),
			widget = wibox.widget.imagebox,
		},
		top    = dpi(0),
		left   = dpi(0),
		right  = dpi(0),
		bottom = dpi(0),
		id     = "margin",
		widget = wibox.container.margin
	},
	{
		{
			{
				id = "user",
				text   = "unknow",
				font   = "Microsoft YaHei Bold 10",
				fg	   = theme.fg,
				valign = "top",
				widget = wibox.widget.textbox
			},
			nil,
			battery.widget,
			forced_width = dpi(250),
			layout = wibox.layout.align.horizontal,
		},
		nil,
		{
			id = "uptime",
			text   = "uptime unknow",
			font   = "Microsoft YaHei 9",
			--font = "Terminus Bold 10",
			fg	   = theme.fg,
			valign = "bottom",
			--forced_width = dpi(170),
			widget = wibox.widget.textbox
		},
		--forced_width = dpi(230),
		layout = wibox.layout.fixed.vertical,
	},
	forced_height = dpi(50),
	layout = wibox.layout.fixed.horizontal,

	set_user   = function(self,str)
		self:get_children_by_id("user")[1].text = "   " .. str
	end,
	set_uptime = function(self,str)
		self:get_children_by_id("uptime")[1].text = "   " .. str
	end
}


awful.spawn.easy_async_with_shell(cmd_user, function(out)
	avatar.widget.user = string.gsub(out, "\n", "")
end)


gears.timer({
	timeout   = 60,
	call_now  = true,
	autostart = true,
	callback  = function()
		awful.spawn.easy_async_with_shell(cmd_uptime, function(out)
			avatar.widget.uptime = string.gsub(out, "\n", "")
		end)
	end
})







return avatar
