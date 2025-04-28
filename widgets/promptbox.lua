local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi




local promptbox = {}




promptbox.widget = awful.widget.prompt{
	prompt        = "",
	bg_cursor     = theme.popup_fg,
	font          = theme.prompt_font,
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
					forced_height = dpi(16),
					forced_width  = dpi(16),
					widget        = wibox.widget.imagebox
				},
				halign = 'left',
				valign = 'center',
				widget = wibox.container.place,
			},
			left   = dpi(15),
			right  = dpi(12),
			widget = wibox.container.margin 
		},
		promptbox.widget,
		{
			right = dpi(15),
			widget = wibox.container.margin 
		},
		layout = wibox.layout.fixed.horizontal,
	},
	border_color	= theme.border_focus,
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




function promptbox:setup(s)
	s.promptbox = self
end




return promptbox
