local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local volume  = require("widgets.volume")
local battery = require("widgets.battery")

local panel_battery = require("widgets.panel.battery")
local panel_avatar  = require("widgets.panel.avatar")
local panel_volume  = require("widgets.panel.volume")
local panel_brightness = require("widgets.panel.brightness")


local panel = {}


panel.widget = wibox.widget{
	{
		id      = "margin",
		widget	= wibox.container.margin
	},
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
	end,
	shape_border_width = theme.widget_border_width,
	shape_border_color = theme.widget_border_color,
	widget = wibox.container.background,
}


panel.controls = wibox.widget{
	{
		{
			panel_avatar.widget,
			nil,
			nil,
			layout = wibox.layout.align.horizontal,
		},
		{
			top = dpi(10),
			widget = wibox.container.margin
		},
		{
			panel_volume.widget,	
			layout = wibox.layout.fixed.horizontal,
		},
		{
			panel_brightness.widget,
			layout = wibox.layout.fixed.horizontal,
		},
		layout = wibox.layout.fixed.vertical,
	},
	margins = dpi(10),
	widget  = wibox.container.margin
}


panel.popup = awful.popup{
	widget			= panel.controls,
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.bg,
	fg              = theme.fg,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end,
    placement		= function(wdg,args)  
		awful.placement.top_right(wdg, {margins = { top = theme.popup_margin_top ,right = dpi(5)}}) 
	end,
}


panel.update = function()
	if panel.popup.visible then
		panel_battery.update()
		panel_volume.update()
		panel_brightness.update()
	end
end


panel.setup = function(mt,ml,mr,mb)
	panel.widget.margin.top    = dpi(mt or 0)
	panel.widget.margin.left   = dpi(ml or 0)
	panel.widget.margin.right  = dpi(mr or 0)
	panel.widget.margin.bottom = dpi(mb or 0)

	panel.widget:connect_signal('mouse::enter',function() 
		if panel.popup.visible then
			panel.widget.bg = theme.widget_bg_press
		else
			panel.widget.bg = theme.widget_bg_hover
		end
	end)

	panel.widget:connect_signal('mouse::leave',function() 
		if panel.popup.visible then
			panel.widget.bg = theme.widget_bg_press
		else
			panel.widget.bg = ""
		end
	end)

	panel.widget:connect_signal('button::press',function() 
		volume.popup_enable = not panel.popup.visible
		battery.popup_enable = volume.popup_enable
	end)

	panel.widget:connect_signal('button::release',function() 
		panel.update()
	end)

	panel.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			panel.popup.visible = not panel.popup.visible
			if panel.popup.visible then
				panel.widget.bg = theme.widget_bg_press
			else
				panel.widget.bg = theme.widget_bg_hover
			end
			volume.popup.visible = false
			battery.popup.visible = false
		end)
	))

	panel.popup:buttons(gears.table.join(
		awful.button({ }, 3, function ()
			panel.popup.visible = false
			volume.popup_enable = true
			battery.popup_enable = true
			panel.widget.bg = ""
		end)
	))

	return panel.widget
end







return panel
