local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi




local wifi = {}
local device          = "wlp4s0"
local cmd_get_signal  = "iw dev " ..  device .. " link|grep signal|sed 's/[^0-9]//g'"
local cmd_get_ssid    = "iw dev " ..  device .. " link|grep SSID|sed 's/.*SSID: //'"
local cmd_get_gateway = "ip route list|grep default|sed -E 's/^default via (.*) dev.*/\1/'"
local cmd_get_ip      = "ifconfig wlp4s0 | grep inet"




wifi.widget = wibox.widget{
	{
		{
			{
				{
					id			= "icon",
					image		= theme.wifi_signal_0_icon,
					widget		= wibox.widget.imagebox,
				},
				left = dpi(0),
				right = dpi(2),
				widget  = wibox.container.margin,
			},
			{
				id			= "ssid",
				text		= "",
				font        = theme.wifi_widget_font,
				visible		= true,
				widget		= wibox.widget.textbox,
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

	set_signal = function(self,value)
		local icon = self:get_children_by_id("icon")[1]
		if value <= 50 then
			icon.image = theme.wifi_signal_3_icon
		elseif value <= 70 then
			icon.image = theme.wifi_signal_2_icon
		elseif value <= 110 then 
			icon.image = theme.wifi_signal_1_icon
		else
			icon.image = theme.wifi_signal_0_icon
		end
	end,
	set_ssid = function(self,str)
		self:get_children_by_id("ssid")[1].text = " " .. str
	end,
}




wifi.popup = awful.popup{
	widget = wibox.widget{
		{
			{
				{
					{
						{
							{
								image		= theme.wifi_signal_3_icon,
								forced_width  = dpi(14),
								forced_height = dpi(14),
								valign		  = "center",
								halign		  = "center",
								widget		= wibox.widget.imagebox,
							},
							left = dpi(-5),
							right = dpi(10),
							widget = wibox.container.margin,
						},
						{
							text = device,
							font = theme.wifi_title_font,
							widget = wibox.widget.textbox,
						},
						layout = wibox.layout.fixed.horizontal,
					},
					{
						bottom = dpi(10),
						widget = wibox.container.margin,
					},
					{
						{
							{
								{
									text = "SSID",
									font = theme.wifi_bold_font,
									widget = wibox.widget.textbox,
								},
								halign = "left",
								valign = "center",
								forced_height = dpi(22),
								widget = wibox.container.place,
							},
							{
								{
									text = "SIGNAL",
									font = theme.wifi_bold_font,
									widget = wibox.widget.textbox,
								},
								halign = "left",
								valign = "center",
								forced_height = dpi(22),
								widget = wibox.container.place,
							},
							{
								{
									text = "IP",
									font = theme.wifi_bold_font,
									widget = wibox.widget.textbox,
								},
								halign = "left",
								valign = "center",
								forced_height = dpi(22),
								widget = wibox.container.place,
							},
							layout = wibox.layout.fixed.vertical,
						},
						{
							right = dpi(35),
							widget = wibox.container.margin,
						},
						{
							{
								{
									id = "ssid",
									text = "Lost",
									font = theme.wifi_font,
									widget = wibox.widget.textbox,
								},
								halign = "left",
								valign = "center",
								forced_height = dpi(22),
								widget = wibox.container.place,
							},
							{
								{
										id = "signal",
										color        = theme.wifi_bar_fg,
										background_color = theme.popup_bg_progressbar,
										max_value    = 100,
										value        = 0,
										--ticks        = true,
										--ticks_size   = dpi(2),
										--ticks_gap    = dpi(2),
										forced_height		= dpi(20),
										forced_width = dpi(4*25),
										border_width = 0,
										margins             = {top = dpi(4), left = dpi(0), right = dpi(0), bottom = dpi(4)},
										paddings		 = dpi(3),
										border_width	 = dpi(0),
										widget = wibox.widget.progressbar,
										shape			= function(cr, width, height)
											gears.shape.rounded_rect(cr, width, height, dpi(10))
										end,
										bar_shape			= function(cr, width, height)
											gears.shape.rounded_rect(cr, width, height, dpi(10))
										end,
										--shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, dpi(3)) end,
										--bar_shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, dpi(3)) end,
								},
								{
									right = dpi(10),
									widget = wibox.container.margin,
								},
								{
									{
										id = "percent",
										text = "-- %",
										font = theme.wifi_font,
										widget = wibox.widget.textbox,
									},
									halign = "left",
									valign = "center",
									forced_height = dpi(22),
									widget = wibox.container.place,
								},
								layout = wibox.layout.fixed.horizontal,
							},
							{
								{
									id = "ip",
									text = "--",
									font = theme.wifi_font,
									widget = wibox.widget.textbox,
								},
								halign = "left",
								valign = "center",
								forced_height = dpi(22),
								widget = wibox.container.place,
							},
							layout = wibox.layout.fixed.vertical,
						},
						layout = wibox.layout.fixed.horizontal,
					},
					--forced_width = dpi(220),
					layout = wibox.layout.fixed.vertical,
				},
				top    = dpi(5),
				left   = dpi(10),
				right  = dpi(10),
				bottom = dpi(5),
				id     = "margin",
				widget = wibox.container.margin,
			},
			bg = theme.popup_bg,
			widget = wibox.container.background,
		},
		top    = dpi(10),
		left   = dpi(10),
		right  = dpi(10),
		bottom = dpi(10),
		id     = "margin",
		widget = wibox.container.margin,
		set_signal = function(self, s)
			local p = math.ceil(100*(110-s)/70)
			self:get_children_by_id("signal")[1].value = math.ceil(p/4)*4
			if p < 0 then
				self:get_children_by_id("percent")[1].text = "0 %"
			elseif p > 100 then
				self:get_children_by_id("percent")[1].text = "100 %"
			else
				self:get_children_by_id("percent")[1].text = p .. " %"
			end
		end,
		set_ssid = function(self, str)
			self:get_children_by_id("ssid")[1].text = str
		end,
		set_ip = function(self, str)
			self:get_children_by_id("ip")[1].text = str
		end,
	},
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.popup_bg,
	fg				= theme.popup_fg,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end,
    --placement		= function(wdg,args)  
	--	awful.placement.top_left(wdg, {margins = { top = theme.popup_margin_top ,left = theme.popup_margin_right}}) 
	--end,
}




function wifi:update()
	--print(os.date("%X") .. ": update wifi popup")
	awful.spawn.easy_async_with_shell(cmd_get_signal, function(out)
		self.widget.signal = tonumber(out) or 999
	end)
	awful.spawn.easy_async_with_shell(cmd_get_ssid, function(out)
		if #out > 1 then
			self.widget.ssid = out
		else
			self.widget.ssid = "Disconnect"
		end
	end)
	if self.popup.visible then
		awful.spawn.easy_async_with_shell(cmd_get_signal, function(out)
			local out = tonumber(out) or 999
			self.widget.signal = out
			self.popup.widget.signal = out
		end)
		awful.spawn.easy_async_with_shell(cmd_get_ssid, function(out)
			if #out > 1 then
				self.widget.ssid = out
				self.popup.widget.ssid = out
			else
				self.widget.ssid = "Disconnect"
				self.popup.widget.ssid = "--"
			end
		end)
		awful.spawn.easy_async_with_shell(cmd_get_ip, function(out)
			local ip = string.match(out,"(%d+%.%d+%.%d+%.%d+)") or "--"
			self.popup.widget.ip = ip
		end)
	end
end




function wifi:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	local function popup_move()	
		local m = mouse.coords()
		self.popup.x = m.x - self.popup_offset.x
		self.popup.y = m.y - self.popup_offset.y
		mousegrabber.stop()
	end

	self.popup:buttons(gears.table.join(
		awful.button({ }, 1, function()
			self.popup:connect_signal('mouse::move',popup_move)
			local m = mouse.coords()
			self.popup_offset = {
				x = m.x - self.popup.x,
				y = m.y - self.popup.y
			}
			self.popup:emit_signal('mouse::move', popup_move)
		end,function()
			self.popup:disconnect_signal ('mouse::move',popup_move)
		end),
		awful.button({ }, 3, function ()
			--self.popup:disconnect_signal ('mouse::move',popup_move)
			self.popup.visible = false
			self.widget.bg = theme.widget_bg
			self.widget.shape_border_color = theme.topbar_bg
		end)
	))

	self.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			if not self.popup.visible then
				self.popup.x = -999
				self.popup.y = -999
			end
			self.popup.visible = not self.popup.visible 
		end,function()
			if self.popup.visible then
				local s = awful.screen.focused()
				local x =  mouse.coords().x - math.ceil(self.popup.width / 2)
				if x + self.popup.width > s.geometry.width - (theme.useless_gap + theme.border_width)*dpi(1) then
					x = s.geometry.width - self.popup.width - (theme.useless_gap + theme.border_width)*dpi(1)
				end
				if x < theme.useless_gap*dpi(1) then
					x = theme.useless_gap*dpi(1)
				end
				self.popup.x = x
				self.popup.y = theme.popup_margin_top
				self:update()
				self.popup.timer:again()
			end
		end),
		awful.button({}, 3, function() 
			local wdg = self.widget:get_children_by_id("ssid")[1]
			wdg.visible = not wdg.visible
		end)
	))


	self.widget:connect_signal('mouse::enter',function() 
		if self.popup.visible then
			self.widget.bg = theme.widget_bg_press
		else
			self.widget.bg = theme.widget_bg_hover
		end
		self.widget.shape_border_color = theme.widget_border_color
	end)

	self.widget:connect_signal('mouse::leave',function() 
		if self.popup.visible then
			self.widget.bg = theme.widget_bg_press
			self.widget.shape_border_color = theme.widget_border_color
		else
			self.widget.bg = theme.widget_bg
			self.widget.shape_border_color = theme.widget_border_color
		end
	end)

	self.timer = gears.timer({
		timeout   = 10,
		call_now  = true,
		autostart = true,
		callback  = function()
			self:update()
		end
	})

	self.popup.timer = gears.timer {
		timeout   = 4,
		call_now  = false,
		autostart = false,
		callback  = function()
			--print("wifi popup timer")
			if self.popup.visible then
				self:update()
				--self.popup.timer:again()
			else
				self.popup.timer:stop()
			end
		end
	}

	--return self.widget
	return wibox.widget{
		self.widget,
		left = dpi(0-theme.widget_border_width/2),
		widget = wibox.container.margin
	}
end




return wifi
