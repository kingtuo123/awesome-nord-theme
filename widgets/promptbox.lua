local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local promptbox = {}


promptbox.widget = awful.widget.prompt{
	prompt        = "   ",
	bg_cursor     = theme.popup_fg,
	font          = "Microsoft YaHei UI Bold 9",
	with_shell    = true,
	done_callback = function()
		promptbox.popup.visible = false
	end
}


promptbox.popup = awful.popup{
	widget = wibox.widget{
		{
			{
				{
					image         = theme.terminal_icon,
					resize        = true,
					forced_height = dpi(17),
					forced_width  = dpi(17),
					widget        = wibox.widget.imagebox
				},
				halign = 'left',
				valign = 'center',
				widget = wibox.container.place,
			},
			left   = dpi(15),
			widget = wibox.container.margin 
		},
		promptbox.widget,
		{
			right = dpi(15),
			widget = wibox.container.margin 
		},
		layout = wibox.layout.fixed.horizontal,
	},
	border_color	= theme.popup_border_color,
	bg				= theme.popup_bg,
	fg              = theme.popup_fg,
	border_width	= theme.popup_border_width,
	visible			= false,
	ontop			= true,
	minimum_width	= dpi(180),
	minimum_height  = dpi(50),
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end,
	placement		= function(wdg,args)  
		awful.placement.top(wdg, { margins = { top = theme.popup_margin_top}}) 
	end,
}


promptbox.setup = function(s)
	s.promptbox = promptbox
end


return promptbox
