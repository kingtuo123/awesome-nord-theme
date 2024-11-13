local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi




local volume		    = {}
local sinks             = {}
local sink_def_idx      = 0
local cmd_get_sinks     = "pactl list sinks | grep -E 'Name:|alsa.card_name|type:'"
local cmd_get_def_sink  = "pactl get-default-sink"
local cmd_set_def_sink  = function(name) return "pactl set-default-sink " .. name end
local cmd_get_vol	    = function(name) return "pactl get-sink-volume  " .. name end
local cmd_get_mute	    = function(name) return "pactl get-sink-mute    " .. name end
local cmd_set_mute	    = function() return "pactl set-sink-mute  " .. sinks[sink_def_idx].name .. " yes" end
local cmd_set_unmute	= function() return "pactl set-sink-mute  " .. sinks[sink_def_idx].name .. " no" end
local cmd_toggle_mute	= function() return "pactl set-sink-mute  " .. sinks[sink_def_idx].name .. " toggle" end
local cmd_set_vol	    = function(vol) return string.format("pactl set-sink-volume %s %d%%", sinks[sink_def_idx].name, vol) end




volume.widget = wibox.widget {
	{
		{
			wibox.widget.textbox(" "),
			{
				id		= "icon",
				resize	= true,
				image	= theme.vol_10_icon,
				widget	= wibox.widget.imagebox,
			},
			{
				id					= "bar",
				value				= 0.5,
				forced_height		= dpi(10),
				forced_width		= dpi(80),
				margins             = {top = dpi(1), left = dpi(5), right = dpi(5), bottom = dpi(1)},
				color				= theme.vol_widget_bar_fg,
				background_color	= theme.vol_widget_bar_bg,
				paddings			= dpi(3),
				border_width		= dpi(0),
				border_color 		= theme.popup_progress_border_color,
				widget				= wibox.widget.progressbar,
				shape			= function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, dpi(10))
				end,
				bar_shape			= function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, dpi(10))
				end,
			},
			{
				id		= "value",
				text	= " --%",
				font	= theme.vol_widget_font,
				visible	= true,
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
	bg = theme.widget_bg,
	widget = wibox.container.background,
	set_icon = function(self, icon)
		self:get_children_by_id("icon")[1].image = icon
	end,
	set_value = function(self,v)
		--self:get_children_by_id("value")[1].text = " " .. v .. "%"
		self:get_children_by_id("value")[1].text = v
		self:get_children_by_id("bar")[1].value = v / 100
	end,
}




volume.popup_outputdevice = awful.popup{
	widget = wibox.widget{
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
					awful.button({}, 1, nil, function()
						if i ~= sink_def_idx then
							volume.popup_outputdevice.timer:again()
							awful.spawn.easy_async_with_shell(cmd_set_def_sink(args.name), function(out)
								volume:update()
							end)
						end
					end),
					awful.button({}, 2, function()
						if i == sink_def_idx then
							volume:toggle()
						end
					end),
					awful.button({}, 4, function()
						if i == sink_def_idx then
							volume:up()
						end
					end),
					awful.button({}, 5, function()
						if i == sink_def_idx then
							volume:down()
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
	},
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.popup_bg,
	fg              = theme.popup_fg,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end,
    --placement		= function(wdg,args)  
	--	awful.placement.top_right(wdg, {margins = { top = theme.popup_margin_top ,right = theme.popup_margin_right}}) 
	--end,
}





volume.popup_notification = awful.popup{
	widget = wibox.widget{
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
			top    = dpi(15),
			left   = dpi(15),
			right  = dpi(15),
			bottom = dpi(15),
			widget = wibox.container.margin 
		},
		{
			id					= "bar",
			value				= 0.5,
			forced_height		= dpi(45),
			forced_width		= dpi(120),
			margins             = {top = dpi(16), left = dpi(0), right = dpi(0), bottom = dpi(16)},
			color				= theme.popup_fg_progressbar,
			background_color	= theme.popup_bg_progressbar,
			paddings			= dpi(3),
			border_width		= dpi(0),
			border_color 		= theme.popup_progress_border_color,
			widget				= wibox.widget.progressbar,
			shape			= function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, dpi(10))
			end,
			bar_shape			= function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, dpi(10))
			end,
		},
		{
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
			top    = dpi(15),
			left   = dpi(15),
			right  = dpi(15),
			bottom = dpi(15),
			widget = wibox.container.margin 
		},
		layout = wibox.layout.align.horizontal,
		set_value = function(self, val)
			self:get_children_by_id('bar')[1].value = val / 100
			self:get_children_by_id('value')[1].text = val
		end,
		set_icon = function(self, icon)
			self:get_children_by_id('icon')[1].image = icon
		end,
	},
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.popup_bg,
	fg              = theme.popup_fg,
	ontop			= true,
	type            = "desktop",
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end,
    placement		= function(wdg,args)  
		--awful.placement.top_right(wdg, {margins = { top = theme.popup_margin_top ,right = theme.popup_margin_right}}) 
		awful.placement.top(wdg, {margins = { top = theme.popup_margin_top}}) 
	end,
}



function volume:fresh_data()
	local value = sinks[sink_def_idx].value
	local mute  = sinks[sink_def_idx].mute
	local icon
	if mute then
		icon = theme.vol_mute_icon
	elseif value >= 65 then
		icon = theme.vol_100_icon
	elseif value >= 35 then
		icon = theme.vol_70_icon
	elseif value >= 5 then
		icon = theme.vol_40_icon
	else
		icon = theme.vol_10_icon
	end
	if mute then
		self.widget:get_children_by_id("bar")[1].color = theme.vol_widget_bar_mute_fg
		self.popup_notification.widget:get_children_by_id("bar")[1].color = theme.vol_widget_bar_mute_fg
	else
		self.widget:get_children_by_id("bar")[1].color = theme.vol_widget_bar_fg
		self.popup_notification.widget:get_children_by_id("bar")[1].color = theme.vol_widget_bar_fg
	end
	self.widget.value = value
	self.widget.icon = icon
	self.popup_notification.widget.value = value
	self.popup_notification.widget.icon = icon
	self.popup_outputdevice.widget.backup_sinks[sink_def_idx].value = value
	self.popup_outputdevice.widget.backup_sinks[sink_def_idx].mute = mute
end



function volume:increase(value)
	if sinks[sink_def_idx] == nil then
		return
	end
	value = sinks[sink_def_idx].value + value
	if value < 0 then
		value = 0
	elseif value > 100 then
		value = 100
	end
	awful.spawn.with_shell(cmd_set_vol(value))
	sinks[sink_def_idx].value = value
	self:fresh_data()
	if not self.popup_outputdevice.visible then
		self.popup_notification.visible = true
		self.popup_notification.timer:again()
	end
end




function volume:toggle()
	if sinks[sink_def_idx] == nil then
		return
	end
	local mute
	if sinks[sink_def_idx].mute then
		awful.spawn.with_shell(cmd_set_unmute())
		mute = false
	else
		awful.spawn.with_shell(cmd_set_mute())
		mute = true
	end
	sinks[sink_def_idx].mute = mute
	self:fresh_data()
	if not self.popup_outputdevice.visible then
		self.popup_notification.visible = true
		self.popup_notification.timer:again()
	end
end




function volume:up()
	self:increase(2)
end




function volume:down()
	self:increase(-2)
end


function volume:update()
	--print(os.date("%X") .. ": volume update")
	awful.spawn.easy_async_with_shell("echo Default=`pactl get-default-sink` && pactl list sinks | grep -E 'State:|Name:|Mute:|front-left:|alsa.card_name|type:'", function(out)
		--print(out)
		local n = 1
		local backup_sinks = {}
		local default_sink = string.match(out, 'Default=(.-)%c')
		--print("default_sink = " .. default_sink)
		if default_sink == nil or default_sink == "@DEFAULT_SINK@" then
			sink_def_idx = 0
			self.reconnect_timer:start()
			return
		end
		n = 1
		for v in string.gmatch(out, 'Name: (.-)%c') do
			backup_sinks[n] = {}
			backup_sinks[n].name = v
			if v == default_sink then
				sink_def_idx = n
			end
			--print("name = " .. v)
			n = n + 1
		end
		n = 1
		for v in string.gmatch(out, 'Mute: (.-)%c') do
			if v == "yes" then
				backup_sinks[n].mute = true
			else
				backup_sinks[n].mute = false
			end
			--print("mute = " .. v)
			n = n + 1
		end
		n = 1
		for v in string.gmatch(out, 'Volume: .-(%d+)%%.- dB%c') do
			backup_sinks[n].value = tonumber(v)
			--print("volume = " .. v)
			n = n + 1
		end
		n = 1
		for v in string.gmatch(out, 'card_name = "(.-)"%c') do
			backup_sinks[n].card = v
			--print("card = " .. v)
			n = n + 1
		end
		n = 1
		for v in string.gmatch(out, 'type: (.-),') do
			backup_sinks[n].type = v
			--print("type = " .. v)
			n = n + 1
		end
		sinks = backup_sinks
		self.popup_outputdevice.widget.sinks = sinks
		self:fresh_data()
	end)
end





function volume:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	--self.widget:buttons(awful.util.table.join (
	--	awful.button({}, 1, function() 
	--		self.popup_notification.visible = false
	--		self.popup_outputdevice.visible = not self.popup_outputdevice.visible
	--		self:update()
	--	end),
	--	awful.button({}, 2, function() 
	--		self:toggle()
	--	end),
	--	awful.button({}, 3, function() 
	--		local wdg = self.widget:get_children_by_id("value")[1]
	--		wdg.visible = not wdg.visible
	--	end),
	--	awful.button({}, 4, function() 
	--		self:up()
	--	end),
	--	awful.button({}, 5, function() 
	--		self:down()
	--	end)
	--))

	self.widget:connect_signal('mouse::enter',function() 
		if self.popup_outputdevice.visible then
			self.widget.bg = theme.widget_bg_press
		else
			self.widget.bg = theme.widget_bg_hover
		end
		self.widget.shape_border_color = theme.widget_border_color
		self.widget:get_children_by_id("bar")[1].background_color = theme.vol_widget_bar_bg_hover
	end)

	self.widget:connect_signal('mouse::leave',function() 
		if self.popup_outputdevice.visible then
			self.widget.bg = theme.widget_bg_press
			self.widget.shape_border_color = theme.widget_border_color
			self.widget:get_children_by_id("bar")[1].background_color = theme.vol_widget_bar_bg_hover
		else
			self.widget.bg = theme.widget_bg
			self.widget.shape_border_color = theme.widget_border_color
			self.widget:get_children_by_id("bar")[1].background_color = theme.vol_widget_bar_bg
		end
	end)

	self.popup_notification:buttons(gears.table.join(
		awful.button({ }, 3, function ()
			self.popup_notification.visible = false
		end)
	))

	--self.popup_outputdevice:buttons(gears.table.join(
	--	awful.button({ }, 3, function ()
	--		self.popup_outputdevice.visible = false
	--		self.widget.bg = theme.widget_bg
	--		self.widget.shape_border_color = theme.widget_border_color
	--	end)
	--))

	local function popup_outputdevice_move()	
		local m = mouse.coords()
		self.popup_outputdevice.x = m.x - self.popup_outputdevice_offset.x
		self.popup_outputdevice.y = m.y - self.popup_outputdevice_offset.y
		mousegrabber.stop()
	end

	self.popup_outputdevice:buttons(gears.table.join(
		awful.button({ }, 1, function()
			self.popup_outputdevice:connect_signal('mouse::move',popup_outputdevice_move)
			local m = mouse.coords()
			self.popup_outputdevice_offset = {
				x = m.x - self.popup_outputdevice.x,
				y = m.y - self.popup_outputdevice.y
			}
			self.popup_outputdevice:emit_signal('mouse::move', popup_outputdevice_move)
		end,function()
			self.popup_outputdevice:disconnect_signal ('mouse::move',popup_outputdevice_move)
		end),
		awful.button({ }, 3, function ()
			self.popup_outputdevice:disconnect_signal ('mouse::move',popup_outputdevice_move)
			self.popup_outputdevice.visible = false
			self.widget.bg = theme.widget_bg
			self.widget.shape_border_color = theme.widget_border_color
			self.widget:get_children_by_id("bar")[1].background_color = theme.vol_widget_bar_bg
		end)
	))

	self.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			if sink_def_idx == 0 then return end
			if self.popup_outputdevice.visible then
				self.popup_outputdevice.visible = false
				--self.widget.bg = theme.widget_bg_press
			else
				self.popup_notification.visible = false
				self.popup_outputdevice.x = mouse.coords().x - dpi(126)
				self.popup_outputdevice.y = theme.popup_margin_top
				self.popup_outputdevice.visible = true
				self:update()
				self.popup_outputdevice.timer:again()
				--self.widget.bg = theme.widget_bg_hover
			end
			self.widget.shape_border_color = theme.widget_border_color
		end),
		awful.button({}, 2, function() 
			self:toggle()
		end),
		awful.button({}, 3, function() 
			local wdg = self.widget:get_children_by_id("value")[1]
			wdg.visible = not wdg.visible
		end),
		awful.button({}, 4, function() 
			self:up()
		end),
		awful.button({}, 5, function() 
			self:down()
		end)
	))

	self.timer = gears.timer({
		timeout   = 60,
		call_now  = true,
		autostart = true,
		callback  = function()
			self:update()
		end
	})

	self.reconnect_timer = gears.timer({
		timeout   = 2,
		call_now  = false,
		autostart = false,
		single_shot = true,
		callback  = function()
			print(os.date("%X") .. ": volume reconnect")
			self:update()
		end
	})

	self.popup_outputdevice.timer = gears.timer({
		timeout   = 2,
		call_now  = false,
		autostart = false,
		callback  = function()
			--print("popup_outputdevice timer")
			if not self.popup_outputdevice.visible then
				self.popup_outputdevice.timer:stop()
			else
				self:update()
			end
		end
	})

	self.popup_notification.timer = gears.timer({
		timeout   = 2,
		call_now  = false,
		autostart = false,
		callback  = function()
			--print("stop timer")
			self.popup_notification.timer:stop()
			self.popup_notification.visible = false
		end
	})

	--return self.widget
	return wibox.widget{
		self.widget,
		left = dpi(0-theme.widget_border_width/2),
		widget = wibox.container.margin
	}
end




return volume
