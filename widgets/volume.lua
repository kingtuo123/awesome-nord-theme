local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local beautiful	 = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi 		 = xresources.apply_dpi







local volume		= {}
local device		= "alsa_output.pci-0000_00_1f.3.analog-stereo"
local cmd_get_vol	= "pactl get-sink-volume " .. device
local cmd_get_mute	= "pactl get-sink-mute " .. device
local cmd_set_mute	= "pactl set-sink-mute " .. device .. " toggle"
local cmd_set_vol	= function(vol) return "pactl set-sink-volume " .. device .. " " .. vol .. "%" end


volume.widget = wibox.widget {
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
	backup_volume	= 0,
	backup_mute		= false,
	set_volume = function(self,vol)
		vol = tonumber(vol)
		if vol >=0 and vol <= 100 then
			if vol >= 80 then
				self.icon.volume.image = theme.vol_100_icon
			elseif vol >= 40 then
				self.icon.volume.image = theme.vol_70_icon
			elseif vol >= 20 then
				self.icon.volume.image = theme.vol_40_icon
			else
				self.icon.volume.image = theme.vol_10_icon
			end
			self.value.text = "  " .. vol .. "%"
			self.backup_volume = vol
			awful.spawn.with_shell(cmd_set_vol(vol))
		end
	end,
	get_volume = function(self)
		return self.backup_volume
	end,
	set_mute = function(self,mute)
		if self.backup_mute ~= mute then
			awful.spawn.with_shell(cmd_set_mute)
		end
		self.backup_mute = mute
		if mute == true then
			self.icon.mute.visible = true
			self.icon.volume.visible = false
		else
			self.icon.mute.visible = false
			self.icon.volume.visible = true
		end
	end,
	get_mute = function(self)
		return self.backup_mute
	end,
}


volume.buttons = awful.util.table.join (
	awful.button({}, 1, function() 
		volume.progressbar.value = volume.widget.volume
		volume.popup.visible	 = true
		volume.clean_popup()
	end),
	awful.button({}, 2, function() 
		volume.toggle()
	end),
	awful.button({}, 3, function() 
		volume.widget.value.visible = not volume.widget.value.visible
	end),
	awful.button({}, 4, function() 
		volume.up()
	end),
	awful.button({}, 5, function() 
		volume.down()
	end)
)


volume.update = function()
	awful.spawn.easy_async_with_shell(cmd_get_vol, function(out)
		volume.widget.volume = string.match(out,"(%d+)%%")
	end)
	awful.spawn.easy_async_with_shell(cmd_get_mute, function(out)
		if string.match(out,": (%a+)") == "yes" then
			volume.widget.backup_mute = true
			volume.widget.mute = true
		else
			volume.widget.backup_mute = false
			volume.widget.mute = false
		end
	end)
end


volume.timer = {
	timeout   = 60,
    call_now  = true,
    autostart = true,
    callback  = volume.update
}


volume.progressbar = wibox.widget{
	{
		{
			id					= "bar",
			value				= 0.5,
			forced_height		= dpi(50),
			forced_width		= dpi(100),
			color				= "#eceff4",
			background_color	= "#2e3440",
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
				forced_width = dpi(25),
				forced_height = dpi(25),
				halign = "center",
				valign = "center",
				widget = wibox.widget.imagebox,
			},
			halign = "center",
			valign = "center",
			layout = wibox.container.place
		},
		top = dpi(100),
		bottom = dpi(12),
		widget = wibox.container.margin 
	},
	layout = wibox.layout.stack,
	set_value	= function(self,val)
		icon = self:get_children_by_id('icon')[1]
		if volume.widget.mute == true then
			icon.image = theme.vol_bar0_icon
		elseif val >= 80 then
			icon.image = theme.vol_bar100_icon
		elseif val >= 40 then
			icon.image = theme.vol_bar70_icon
		elseif val >= 20 then
			icon.image = theme.vol_bar40_icon
		else
			icon.image = theme.vol_bar10_icon
		end
		self:get_children_by_id('bar')[1].value = val / 100
	end,
}


volume.popup = awful.popup{
	widget			= volume.progressbar,
	border_color	= theme.color3,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.color0,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, dpi(10))
	end,
    placement		= function(wdg,args)  
		awful.placement.top_right(wdg, {margins = { top = theme.popup_margin_top ,right = dpi(5)}}) 
	end,
}


volume.auto_clean_popup = true
volume.clean_popup_timer = gears.timer {
	timeout   = 2,
	call_now  = false,
	autostart = false,
	callback  = function(self)
		print("clean popup")
		self:stop()
		volume.popup.visible = false
	end
}
volume.clean_popup = function()
	if volume.popup.visible then
		volume.clean_popup_timer:again()
	end
end


volume.toggle = function()
	volume.widget.mute		 = not volume.widget.mute
	volume.progressbar.value = volume.widget.volume
	volume.popup.visible	 = true
	volume.clean_popup()
end


volume.up = function()
	volume.widget.volume	 = volume.widget.volume + 5
	volume.progressbar.value = volume.widget.volume
	volume.popup.visible	 = true
	volume.clean_popup()
end


volume.down = function()
	volume.widget.volume	 = volume.widget.volume - 5
	volume.progressbar.value = volume.widget.volume
	volume.popup.visible	 = true
	volume.clean_popup()
end









return volume
