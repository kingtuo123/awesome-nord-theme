local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local volume		= {}
-- device = "pactl get-default-sink" 
local device		= "alsa_output.pci-0000_c6_00.1.hdmi-stereo-extra3"
local cmd_get_vol	= "pactl get-sink-volume " .. device
local cmd_get_mute	= "pactl get-sink-mute " .. device
local cmd_set_mute	= "pactl set-sink-mute " .. device .. " yes"
local cmd_unset_mute	= "pactl set-sink-mute " .. device .. " no"
local cmd_toggle_mute	= "pactl set-sink-mute " .. device .. " toggle"
local cmd_set_vol	= function(vol) return "pactl set-sink-volume " .. device .. " " .. vol .. "%" end


volume.widget = wibox.widget {
	{
		{
			wibox.widget.textbox(" "),
			{
				{
					id		= "mute",
					resize	= true,
					image	= theme.vol_0_icon,
					visible	= false,
					widget	= wibox.widget.imagebox,
				},
				{
					id		= "volume",
					resize	= true,
					visible	= true,
					image	= theme.vol_70_icon,
					widget	= wibox.widget.imagebox,
				},
				id		= "icon",
				layout	= wibox.layout.stack,
			},
			{
				id		= "value",
				text	= "100%  ",
				font	= theme.font,
				visible	= false,
				widget	= wibox.widget.textbox,
			},
			wibox.widget.textbox(" "),
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

	backup_value	= 0,
	backup_mute		= false,
	backup_icon = "",

	set_value = function(self,vol)
		vol = tonumber(vol or 0)
		if vol >=0 and vol <= 100 then
			if vol >= 80 then
				self.backup_icon = theme.vol_100_icon
			elseif vol >= 40 then
				self.backup_icon = theme.vol_70_icon
			elseif vol >= 20 then
				self.backup_icon = theme.vol_40_icon
			else
				self.backup_icon = theme.vol_10_icon
			end
			self:get_children_by_id("volume")[1].image = self.backup_icon
			self:get_children_by_id("value")[1].text   = "  " .. vol .. "%"
			self.backup_value = vol
			awful.spawn.with_shell(cmd_set_vol(vol))
		end
	end,
	get_value = function(self)
		return self.backup_value
	end,
	set_mute = function(self,mute)
		self.backup_mute = mute
		if mute == true then
			awful.spawn.with_shell(cmd_set_mute)
			self:get_children_by_id("mute")[1].visible = true
			self:get_children_by_id("volume")[1].visible = false
		else
			awful.spawn.with_shell(cmd_unset_mute)
			self:get_children_by_id("mute")[1].visible = false
			self:get_children_by_id("volume")[1].visible = true
		end
	end,
	get_mute = function(self)
		return self.backup_mute
	end,
	get_icon = function(self)
		if self.mute then
			return theme.vol_0_icon
		else
			return self.backup_icon
		end
	end
}


volume.update = function()
	awful.spawn.easy_async_with_shell(cmd_get_vol, function(out)
		volume.widget.value = string.match(out,"(%d+)%%")
	end)
	awful.spawn.easy_async_with_shell(cmd_get_mute, function(out)
		if string.match(out,": (%a+)") == "yes" then
			volume.widget.mute = true
		else
			volume.widget.mute = false
		end
	end)
end


volume.progressbar = wibox.widget{
	{
		top = dpi(10),
		widget = wibox.container.margin 
	},
	{
		{
			id		= "value",
			text	= "100",
			font	= theme.font,
			widget	= wibox.widget.textbox,
		},
		valign = "center",
		halign = "center",
		widget = wibox.container.place,
	},
	{
		{
			id					= "bar",
			value				= 0.5,
			forced_height		= dpi(45),
			forced_width		= dpi(150),
			margins             = {top = dpi(16), left = dpi(15), right = dpi(15), bottom = dpi(16)},
			color				= theme.popup_fg_progressbar,
			background_color	= theme.popup_bg_progressbar,
			paddings			= dpi(1),
			border_width		= dpi(1),
			border_color 		= "#dddddd",
			widget				= wibox.widget.progressbar,
		},
		direction	= "east",
		widget		= wibox.container.rotate,
	},
	{
		{
			{
				id	   = "icon",
				image  = theme.vol_bar0_icon,
				--resize = true,
				forced_width = dpi(20),
				forced_height = dpi(20),
				halign = "center",
				valign = "center",
				widget = wibox.widget.imagebox,
			},
			halign = "center",
			valign = "center",
			layout = wibox.container.place
		},
		top    = dpi(0),
		left   = dpi(0),
		right  = dpi(0),
		bottom = dpi(10),
		widget = wibox.container.margin 
	},
	layout = wibox.layout.fixed.vertical,
	set_value	= function(self,val)
		self:get_children_by_id('icon')[1].image = volume.widget.icon
		self:get_children_by_id('bar')[1].value = val / 100
		self:get_children_by_id('value')[1].text = val
	end,
}


volume.popup = awful.popup{
	widget			= volume.progressbar,
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.popup_bg,
	fg              = theme.popup_fg,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end,
    placement		= function(wdg,args)  
		awful.placement.top_right(wdg, {margins = { top = theme.popup_margin_top ,right = dpi(6)}}) 
	end,
}


volume.popup_close_timer = gears.timer {
	timeout   = 2,
	call_now  = false,
	autostart = false,
	callback  = function(self)
		print("clean popup")
		self:stop()
		volume.popup.visible = false
	end
}


volume.popup_enable = true
volume.popup_close_count_down = function()
	volume.popup.visible = volume.popup_enable
	if volume.popup.visible then
		volume.popup_close_timer:again()
	end
end




volume.toggle = function()
	volume.widget.mute		 = not volume.widget.mute
	volume.progressbar.value = volume.widget.value
	volume.popup_close_count_down()
end


volume.up = function()
	volume.widget.value	 = volume.widget.value + 5
	volume.progressbar.value = volume.widget.value
	volume.popup_close_count_down()
end


volume.down = function()
	volume.widget.value	 = volume.widget.value - 5
	volume.progressbar.value = volume.widget.value
	volume.popup_close_count_down()
end



volume.setup = function(mt,ml,mr,mb)
	volume.widget.margin.top    = dpi(mt or 0)
	volume.widget.margin.left   = dpi(ml or 0)
	volume.widget.margin.right  = dpi(mr or 0)
	volume.widget.margin.bottom = dpi(mb or 0)

	volume.widget:buttons(awful.util.table.join (
		awful.button({}, 2, function() 
			volume.toggle()
		end),
		awful.button({}, 3, function() 
			local wdg = volume.widget:get_children_by_id("value")[1]
			wdg.visible = not wdg.visible
		end),
		awful.button({}, 4, function() 
			volume.up()
		end),
		awful.button({}, 5, function() 
			volume.down()
		end)
	))

	volume.popup:buttons(gears.table.join(
		awful.button({ }, 3, function ()
			volume.popup.visible = false
		end)
	))

	volume.widget:connect_signal('mouse::enter',function() 
		volume.widget.bg = theme.widget_bg_hover
	end)

	volume.widget:connect_signal('mouse::leave',function() 
		volume.widget.bg = ""
	end)

	gears.timer({
		timeout   = 60,
		call_now  = true,
		autostart = true,
		callback  = volume.update
	})

	return volume.widget
end





return volume
