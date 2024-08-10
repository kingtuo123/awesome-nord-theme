local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi


local volume		    = {}
local sinks             = {}
local sink_def_idx      = 1
local cmd_get_sinks     = "pactl list sinks | grep -E 'Name:|alsa.card_name|type:'"
local cmd_get_def_sink  = "pactl get-default-sink"
local cmd_set_def_sink  = function(name) return "pactl set-default-sink " .. name end
local cmd_get_vol	    = function(name) return "pactl get-sink-volume  " .. name end
local cmd_get_mute	    = function(name) return "pactl get-sink-mute    " .. name end
local cmd_set_mute	    = "pactl set-sink-mute  `pactl get-default-sink` yes"
local cmd_unset_mute	= "pactl set-sink-mute  `pactl get-default-sink` no"
local cmd_toggle_mute	= "pactl set-sink-mute  `pactl get-default-sink` toggle"
local cmd_set_vol	    = function(vol) return "pactl set-sink-volume `pactl get-default-sink` " .. vol .. "%" end


volume.widget = wibox.widget {
	{
		{
			wibox.widget.textbox(" "),
			{
				{
					id		= "mute_icon",
					resize	= true,
					image	= theme.vol_0_icon,
					visible	= false,
					widget	= wibox.widget.imagebox,
				},
				{
					id		= "volume_icon",
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
				font	= theme.vol_widget_font,
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
			self:get_children_by_id("volume_icon")[1].image = self.backup_icon
			self:get_children_by_id("value")[1].text   = " " .. vol .. "%"
			sinks[sink_def_idx].value = vol
			awful.spawn.with_shell(cmd_set_vol(vol))
		end
	end,
	get_value = function(self)
		return sinks[sink_def_idx].value
	end,
	set_mute = function(self,mute)
		sinks[sink_def_idx].mute = mute
		if mute == true then
			awful.spawn.with_shell(cmd_set_mute)
			self:get_children_by_id("mute_icon")[1].visible = true
			self:get_children_by_id("volume_icon")[1].visible = false
		else
			awful.spawn.with_shell(cmd_unset_mute)
			self:get_children_by_id("mute_icon")[1].visible = false
			self:get_children_by_id("volume_icon")[1].visible = true
		end
	end,
	get_mute = function(self)
		return sinks[sink_def_idx].mute
	end,
	get_icon = function(self)
		if self.mute then
			return theme.vol_0_icon
		else
			return self.backup_icon
		end
	end
}

local sinks_sources = wibox.widget{
	{
		{
			{
				{
					image		  = theme.vol_speaker_icon,
					forced_width  = dpi(16),
					forced_height = dpi(16),
					valign		  = "center",
					halign		  = "center",
					widget		  = wibox.widget.imagebox,
				},
				left	= dpi(-8),
				right	= dpi(10),
				top		= dpi(0),
				bottom	= dpi(0),
				widget	= wibox.container.margin,
			},
			{
				text = "Output device",
				font = theme.vol_title_font,
				valign = "center",
				halign = "left",
				widget = wibox.widget.textbox, 
			},
			layout = wibox.layout.fixed.horizontal,
		},
		top	   = dpi(15),
		left   = dpi(20),
		right  = dpi(20),
		bottom = dpi(10),
		widget = wibox.container.margin,
	},
	{
		id     = "sink",
		layout = wibox.layout.fixed.vertical,
	},
	{
		bottom = dpi(0),
		widget = wibox.container.margin,
	},
	backup_sinks = {},
	add_sinks = function(self, i, args)
		if i == sink_def_idx then
			sink_bg = theme.vol_sink_sel_bg
			if args.mute then
				line_bg = theme.vol_sink_mute_line_bg
			else
				line_bg = theme.vol_sink_sel_line_bg
			end
		else
			sink_bg = theme.vol_sink_unsel_bg
			line_bg = theme.vol_sink_unsel_line_bg
		end
		local wdg = wibox.widget{
			{
				{
					{
						{
							{
								{
									forced_width  = dpi(3),
									forced_height = dpi(20),
									widget        = wibox.widget.textbox,
								},
								id     = "line",
								bg     = line_bg,
								shape = function(cr, width, height)
									gears.shape.rounded_rect(cr, width, height, dpi(3))
								end,
								widget = wibox.container.background,
							},
							valign = "center",
							halign = "left",
							widget  = wibox.container.place,
						},
						left   = dpi(5),
						widget = wibox.container.margin,
					},
					{
						{
							text = args.card .. " - " .. args.type,
							font = theme.vol_font,
							valign = "center",
							halign = "left",
							--forced_width = dpi(200),
							forced_height = dpi(35),
							widget = wibox.widget.textbox, 
						},
						left   = dpi(16),
						right  = dpi(80),
						widget = wibox.container.margin,
					},
					{
						{
							{
								id     = "volume",
								text   = args.value .. "%",
								font = theme.vol_font,
								valign = "center",
								halign = "center",
								forced_width = dpi(35),
								widget = wibox.widget.textbox, 
							},
							right  = dpi(4),
							widget = wibox.container.margin,
						},
						valign = "center",
						halign = "right",
						widget = wibox.container.place,
					},
					layout = wibox.layout.stack,
				},
				bg = sink_bg,
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
				end,
				widget = wibox.container.background,
			},
			top	   = dpi(0),
			left   = dpi(5),
			right  = dpi(5),
			bottom = dpi(5),
			widget = wibox.container.margin,
			buttons	= awful.util.table.join(
				awful.button({}, 1, function()
					awful.spawn.easy_async_with_shell(cmd_set_def_sink(args.name), function(out)
						volume.update()
					end)
				end),
				awful.button({}, 2, function()
					if i == sink_def_idx then
						volume.toggle()
					end
				end),
				awful.button({}, 4, function()
					if i == sink_def_idx then
						volume.up()
					end
				end),
				awful.button({}, 5, function()
					if i == sink_def_idx then
						volume.down()
					end
				end)
			),
			set_value = function(self, v)
				self:get_children_by_id("volume")[1].text = v .. "%"
			end,
			set_mute = function(self, v)
				if v then
					self:get_children_by_id("line")[1].bg = theme.vol_sink_mute_line_bg
				else
					self:get_children_by_id("line")[1].bg = theme.vol_sink_sel_line_bg
				end
			end,
		}
		if self.backup_sinks[i] == nil then
			self.sink:insert(i,wdg)
		else
			self.sink:replace_widget(self.backup_sinks[i],wdg)
		end
		self.backup_sinks[i] = wdg
	end,
	set_sinks = function(self, args)
		local cnt = 0
		for i,v in pairs(args) do 
			self:add_sinks(i, v)
			cnt = cnt + 1
		end
		local old_cnt = #self.backup_sinks 
		if old_cnt > cnt then
			for i = cnt + 1, old_cnt do
				self.sink:remove_widgets(self.backup_sinks[i])
				self.backup_sinks[i] = nil
			end
		end
	end,
	layout = wibox.layout.fixed.vertical,
}

volume.popup_sinks_sources = awful.popup{
	widget			= sinks_sources,
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
		awful.placement.top_right(wdg, {margins = { top = theme.popup_margin_top ,right = theme.popup_margin_right}}) 
	end,
}


local popup_vertical_bar = wibox.widget{
	{
		top = dpi(12),
		widget = wibox.container.margin 
	},
	{
		{
			id		= "value",
			text	= "100",
			font = theme.vol_title_font,
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
			margins             = {top = dpi(17), left = dpi(10), right = dpi(10), bottom = dpi(17)},
			color				= theme.popup_fg_progressbar,
			background_color	= theme.popup_bg_progressbar,
			paddings			= dpi(0),
			border_width		= dpi(0),
			border_color 		= theme.popup_progress_border_color,
			widget				= wibox.widget.progressbar,
			shape			= function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, dpi(3))
			end,
			bar_shape			= function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, dpi(3))
			end,
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
				forced_width = dpi(18),
				forced_height = dpi(18),
				halign = "center",
				valign = "center",
				widget = wibox.widget.imagebox,
			},
			halign = "center",
			valign = "center",
			widget = wibox.container.place
		},
		top    = dpi(2),
		left   = dpi(0),
		right  = dpi(0),
		bottom = dpi(12),
		widget = wibox.container.margin 
	},
	layout = wibox.layout.fixed.vertical,
	set_value	= function(self,val)
		self:get_children_by_id('icon')[1].image = volume.widget.icon
		self:get_children_by_id('bar')[1].value = val / 100
		self:get_children_by_id('value')[1].text = val
	end,
}


local vertical_bar_close_timer = gears.timer {
	timeout   = 2,
	call_now  = false,
	autostart = false,
	callback  = function(self)
		volume.popup_vertical_bar.visible = false
		self:stop()
		print("stop timer")
	end
}



volume.popup_vertical_bar = awful.popup{
	widget			= popup_vertical_bar,
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
		awful.placement.top_right(wdg, {margins = { top = theme.popup_margin_top ,right = theme.popup_margin_right}}) 
	end,
}



volume.update = function()
	--print(os.date("%X") .. ": volume update")
	awful.spawn.easy_async_with_shell(cmd_get_def_sink, function(out)
		local default_sink = string.match(out, '(.-)%c')
		awful.spawn.easy_async_with_shell(cmd_get_sinks, function(out)
			local n = 1
			local backup_sinks = {}
			for v in string.gmatch(out, 'Name: (.-)%c') do
				backup_sinks[n] = {}
				backup_sinks[n].name = v
				n = n + 1
			end
			n = 1
			for v in string.gmatch(out, 'card_name = "(.-)"%c') do
				backup_sinks[n].card = v
				n = n + 1
			end
			n = 1
			for v in string.gmatch(out, 'type: (.-),') do
				backup_sinks[n].type = v
				n = n + 1
			end
			for i,v in pairs(backup_sinks) do 
				awful.spawn.easy_async_with_shell(cmd_get_vol(v.name), function(out)
					v.value = tonumber(string.match(out,"(%d+)%%"))
					awful.spawn.easy_async_with_shell(cmd_get_mute(v.name), function(out)
						if string.match(out,": (%a+)") == "yes" then
							v.mute = true
						else
							v.mute = false
						end
						if v.name == default_sink then
							sink_def_idx = i
						end
						if i == n - 1 then
							sinks = backup_sinks
							sinks_sources.sinks	= sinks
							volume.widget.value = sinks[sink_def_idx].value
							volume.widget.mute = sinks[sink_def_idx].mute
						end
					end)
				end)
			end
		end)
	end)
end



volume.toggle = function()
	volume.widget.mute		 = not volume.widget.mute
	popup_vertical_bar.value = volume.widget.value
	sinks_sources.backup_sinks[sink_def_idx].mute = sinks[sink_def_idx].mute
	--if volume.popup_sinks_sources.visible then
	--else
	--	volume.popup_vertical_bar.visible = true
	--	vertical_bar_close_timer:again()
	--end
end


volume.up = function()
	volume.widget.value	 = volume.widget.value + 5
	popup_vertical_bar.value = volume.widget.value
	if volume.popup_sinks_sources.visible then
		sinks_sources.backup_sinks[sink_def_idx].value = sinks[sink_def_idx].value
	else
		volume.popup_vertical_bar.visible = true
		vertical_bar_close_timer:again()
	end
end


volume.down = function()
	volume.widget.value	 = volume.widget.value - 5
	popup_vertical_bar.value = volume.widget.value
	if volume.popup_sinks_sources.visible then
		sinks_sources.backup_sinks[sink_def_idx].value = sinks[sink_def_idx].value
	else
		volume.popup_vertical_bar.visible = true
		vertical_bar_close_timer:again()
	end
end



volume.setup = function(mt,ml,mr,mb)
	volume.widget.margin.top    = dpi(mt or 0)
	volume.widget.margin.left   = dpi(ml or 0)
	volume.widget.margin.right  = dpi(mr or 0)
	volume.widget.margin.bottom = dpi(mb or 0)

	volume.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			volume.popup_vertical_bar.visible = false
			volume.popup_sinks_sources.visible = not volume.popup_sinks_sources.visible
			volume.update()
		end),
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

	volume.widget:connect_signal('mouse::enter',function(self) 
		--volume.update()
		if volume.popup_sinks_sources.visible then
			volume.widget.bg = theme.widget_bg_press
		else
			volume.widget.bg = theme.widget_bg_hover
		end
		volume.widget.shape_border_color = theme.widget_border_color
	end)

	volume.widget:connect_signal('mouse::leave',function(self) 
		if volume.popup_sinks_sources.visible then
			volume.widget.bg = theme.widget_bg_press
			volume.widget.shape_border_color = theme.widget_border_color
		else
			volume.widget.bg = theme.topbar_bg
			volume.widget.shape_border_color = theme.topbar_bg
		end
	end)



	volume.popup_vertical_bar:buttons(gears.table.join(
		awful.button({ }, 3, function ()
			volume.popup_vertical_bar.visible = false
		end)
	))

	volume.popup_sinks_sources:buttons(gears.table.join(
		awful.button({ }, 3, function ()
			volume.popup_sinks_sources.visible = false
			volume.widget.bg = theme.topbar_bg
			volume.widget.shape_border_color = theme.topbar_bg
		end)
	))

	gears.timer({
		timeout   = 60,
		call_now  = true,
		autostart = true,
		callback  = volume.update
	})

	return volume.widget
end





return volume
