local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local json  = require("lib.json")
local dpi	= require("beautiful.xresources").apply_dpi
local naughty = require("naughty")


local disk = {}
local colors = {
	"#7aa2f7",
	"#7aa2f7",
	"#7dcfff",
	"#7dcfff",
	"#9ece6a",
	"#9ece6a",
	"#e0af68",
	"#e0af68",
	"#f7768e",
	"#f7768e",
}


local cmd_lsblk	       = "lsblk -o NAME,SIZE,MOUNTPOINTS,FSAVAIL,FSUSE%,FSUSED,FSTYPE,HOTPLUG,LABEL,MODEL,PARTLABEL,UUID,PARTUUID -x NAME -J|sed s/%//g"
local cmd_mount        = function(name) return "udisksctl mount     -b /dev/" .. name end
local cmd_umount       = function(name) return "udisksctl unmount   -b /dev/" .. name end
local cmd_poweroff     = function(name) return "udisksctl power-off -b /dev/" .. name end
local cmd_open         = function(mountpoint) return "alacritty --working-directory " .. "\"" .. mountpoint .. "\""end
local partition_ignore = {"nvme0n1p4","nvme1n1p4"}
local plugout_poweroff = true


disk.widget = wibox.widget{
	{
		{
			id    = "icon",
			image = theme.disk_icon,
			widget = wibox.widget.imagebox,
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
}


local dashboard = wibox.widget{
	{
		id     = "device",
		layout = wibox.layout.fixed.vertical,
	},
	layout = wibox.layout.fixed.vertical,

	backup_parts = {},
	backup_args = {},

	umount = function(self, name, hotplug)
		if hotplug and plugout_poweroff then
			cmd = cmd_umount(name) .. " &> /dev/null && (" .. cmd_poweroff(name) .. " &> /dev/null ; " .. cmd_lsblk .. ")"
			print("unmount and poweroff " .. name)
		else
			cmd = cmd_umount(name) .. " &> /dev/null && " .. cmd_lsblk
			print("unmount " .. name)
		end
		awful.spawn.easy_async_with_shell(cmd, function(out)
			if #out < 10 then
				naughty.notify({ 
					preset = naughty.config.presets.critical,
					position = "top_middle",
					title = "Oops, an error happened!",
					text = "unmount failed",
				})
			else
				self.data = json.decode(out).blockdevices
			end
		end)
	end,

	mount = function(self, name)
		local cmd = cmd_mount(name) .. " &> /dev/null && " .. cmd_lsblk
		awful.spawn.easy_async_with_shell(cmd, function(out)
			print("mount " .. name)
			if #out < 10 then
				naughty.notify({ 
					preset = naughty.config.presets.critical,
					position = "top_middle",
					title = "Oops, an error happened!",
					text = "mount failed",
				})
			else
				self.data = json.decode(out).blockdevices
			end
		end)
	end,

	add_model = function(self,index,model,hotplug)
		if hotplug then
			model_icon = theme.serial_icon
		else
			model_icon = theme.disk_icon
		end
		local wdg = wibox.widget{
			{
				-- device icon
				{
					{
						image		  = model_icon,
						forced_width  = dpi(18),
						forced_height = dpi(18),
						valign		  = "center",
						halign		  = "center",
						widget		  = wibox.widget.imagebox,
					},
					left	= dpi(-5),
					right	= dpi(12),
					top		= dpi(0),
					bottom	= dpi(0),
					widget	= wibox.container.margin,
				},
				{
					{
						text   = model,
						font   = theme.disk_title_font,
						widget = wibox.widget.textbox,
					},
					fg = theme.popup_fg,
					widget = wibox.container.background,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			top	   = dpi(15),
			left   = dpi(20),
			right  = dpi(20),
			bottom = dpi(10),
			widget = wibox.container.margin,
		}
		if self.backup_parts[index] == nil then
			self.device:insert(index,wdg)
		else
			self.device:replace_widget(self.backup_parts[index],wdg)
		end
		self.backup_parts[index] = wdg
	end,

	add_partition = function(self,index)
		local wdg = wibox.widget{
			{
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
									bg     = self.backup_args[index].line_bg,
									shape = function(cr, width, height)
										gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
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
								{
									id     = "title",
									text   = self.backup_args[index].title,
									font   = theme.disk_font,
									valign = "center",
									halign = "left",
									wrap   = "world",
									forced_width = self.backup_args[index].title_width,
									forced_height = dpi(15),
									widget = wibox.widget.textbox, 
								},
								valign = "center",
								halign = "left",
								widget = wibox.container.place,
							},
							top = dpi(10),
							left = dpi(15),
							bottom = dpi(10),
							widget = wibox.container.margin,
						},
						{
							{
								{
									id               = "progressbar",
									max_value     	 = 25,
									value         	 = self.backup_args[index].fsuse,
									color			 = self.backup_args[index].bar_color,
									background_color = theme.disk_bg_progressbar_normal,
									forced_height	 = dpi(10),
									forced_width	 = dpi(50),
									border_width	 = 0,
									opacity          = self.backup_args[index].bar_opacity,
									margins			 = {top = dpi(0), right = dpi(0), left = dpi(0), bottom = dpi(0)},
									paddings		 = dpi(0),
									border_width	 = dpi(0),
									shape = function(cr, width, height)
										gears.shape.rounded_rect(cr, width, height, dpi(3))
									end,
									bar_shape = function(cr, width, height)
										gears.shape.rounded_rect(cr, width, height, dpi(3))
									end,
									widget = wibox.widget.progressbar,
								},
								valign = "center",
								halign = "left",
								widget = wibox.container.place,
							},
							left   = dpi(105),
							right  = dpi(105),
							widget = wibox.container.margin,
						},
						{
							{
								{
									id     = "size",
									text   = self.backup_args[index].size,
									font   = theme.disk_font,
									valign = "center",
									halign = "right",
									wrap   = "word",
									forced_width = dpi(100),
									widget = wibox.widget.textbox, 
								},
								valign = "center",
								halign = "right",
								widget = wibox.container.place,
							},
							right  = dpi(10),
							widget = wibox.container.margin,
						},
						layout = wibox.layout.stack,
					},
					id = "partition",
					bg = self.backup_args[index].bg,
					shape = function(cr, width, height)
						gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
					end,
					widget = wibox.container.background,
					buttons	= awful.util.table.join(
					awful.button({}, 1, function()
						if not self.backup_args[index].mounted then
							self:mount(self.backup_args[index].name)
						end
					end)),
				},
				{
					{
						{
							{
								{
									{
										{
											image			= theme.folder_icon,
											forced_width	= dpi(13),
											forced_height	= dpi(13),
											widget			= wibox.widget.imagebox,
										},
										top = dpi(1),
										right = dpi(5),
										widget	= wibox.container.margin
									},
									{
										text   = "open",
										font   = theme.disk_bold_font,
										valign = "center",
										halign = "center",
										widget = wibox.widget.textbox, 
									},
									layout = wibox.layout.fixed.horizontal,
								},
								valign = "center",
								halign = "right",
								widget = wibox.container.place,
								buttons	= awful.util.table.join(
								awful.button({}, 1, function()
									if self.backup_args[index].mounted then
										awful.spawn.with_shell(cmd_open(self.backup_args[index].mountpoints[#self.backup_args[index].mountpoints]))
									end
								end)),
							},
							{
								text   = "|",
								font   = theme.disk_bold_font,
								valign = "center",
								halign = "center",
								widget = wibox.widget.textbox, 
							},
							{
								{
									{
										{
											image			= theme.eject_icon,
											forced_width	= dpi(10),
											forced_height	= dpi(10),
											widget			= wibox.widget.imagebox,
										},
										top = dpi(2),
										right = dpi(5),
										widget	= wibox.container.margin
									},
									{
										text   = "eject",
										font   = theme.disk_bold_font,
										valign = "center",
										halign = "center",
										widget = wibox.widget.textbox, 
									},
									layout = wibox.layout.fixed.horizontal,
								},
								valign = "center",
								halign = "left",
								widget = wibox.container.place,
								buttons	= awful.util.table.join(
								awful.button({}, 1, function()
									if self.backup_args[index].mounted then
										self:umount(self.backup_args[index].name, self.backup_args[index].hotplug)
									end
								end)),
							},
							layout = wibox.layout.flex.horizontal,
						},
						id = "open_unmount",
						visible = false,
						bg = theme.disk_button_bg,
						widget = wibox.container.background,
					},
					top	   = dpi(0),
					left   = dpi(10),
					right  = dpi(10),
					bottom = dpi(0),
					widget = wibox.container.margin,
				},
				layout = wibox.layout.stack,
			},
			top	   = dpi(0),
			left   = dpi(5),
			right  = dpi(5),
			bottom = dpi(5),
			widget = wibox.container.margin,
			get_title = function(self)
				return self:get_children_by_id("title")[1].text
			end,
			update = function(self, v)
				self:get_children_by_id("line")[1].bg = v.line_bg
				self:get_children_by_id("title")[1].title = v.title
				self:get_children_by_id("title")[1].forced_width = v.title_width
				self:get_children_by_id("size")[1].text = v.size
				self:get_children_by_id("progressbar")[1].value = v.fsuse
				self:get_children_by_id("progressbar")[1].color = v.bar_color
				self:get_children_by_id("progressbar")[1].opacity = v.bar_opacity
				self:get_children_by_id("partition")[1].bg = v.bg
			end
		}
		local w1 = wdg:get_children_by_id("open_unmount")[1]
		w1:connect_signal('mouse::enter',function() 
			w1.visible = self.backup_args[index].mounted
			w1.bg = theme.disk_button_bg
		end)
		local w2 = wdg:get_children_by_id("open_unmount")[1]
		w2:connect_signal('mouse::leave',function() 
			w2.visible = false
			w2.bg = theme.popup_bg
		end)

		if self.backup_parts[index] == nil then
			self.device:insert(index,wdg)
		else
			self.device:replace_widget(self.backup_parts[index],wdg)
		end
		self.backup_parts[index] = wdg
	end,

	set_data = function(self,device)
		local cnt = 0
		for _,v in pairs(device) do
			if v.model ~= nil then
				cnt = cnt + 1
				self:add_model(cnt, v.model, v.hotplug)
			elseif (v.uuid ~= nil and v.partuuid ~= nil and v.fstype ~= nil and v.fstype ~= "swap") then
				local skip = false
				for _,p in pairs(partition_ignore) do
					if string.match(v.name, p) ~= nil then
						skip = true
						break
					end
				end
				if not skip then
					cnt = cnt + 1
					local args = v
					args.title = v.label or v.partlabel or v.name or "Unknow "
					if #v.mountpoints > 0 then
						args.mounted   = true
						args.bg        = theme.disk_part_bg_mounted
						args.size	    = v.fsused .. "/" .. v.size
						args.bar_color = colors[math.ceil(tonumber(v.fsuse)/10)]
						args.line_bg   = theme.disk_line_mounted_bg
						args.bar_opacity = 1
						args.title_width = dpi(70)
						args.fsuse = math.ceil(tonumber(v.fsuse) / 4)
					else
						args.mounted   = false
						args.bg        = theme.disk_part_bg_normal
						args.size	    = v.size
						args.bar_color = colors[1]
						args.line_bg   = theme.disk_line_unmounted_bg
						args.bar_opacity = 0
						args.title_width = dpi(130)
						args.fsuse = 0
					end
					if self.backup_args[cnt] == nil then
						self.backup_args[cnt] = args
						self:add_partition(cnt)
					elseif self.backup_args[cnt].model == nil and args.mounted == true then
						self.backup_args[cnt] = args
						self.backup_parts[cnt]:update(args)
					else
						self.backup_args[cnt] = args
						self:add_partition(cnt)
					end
				end
			end
		end
		old_cnt = #self.backup_parts
		if old_cnt > cnt then
			for i = cnt + 1, old_cnt do
				self.device:remove_widgets(self.backup_parts[i])
				self.backup_parts[i] = nil
			end
		end
	end,
}


disk.popup = awful.popup{
	widget			= dashboard,
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.popup_bg,
	fg				= theme.popup_fg,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end,
    placement		= function(wdg,args)  
		awful.placement.top_right(wdg, {margins = { top = theme.popup_margin_top ,right = theme.popup_margin_right}}) 
	end,
}


local popup_timer = gears.timer {
	timeout   = 2,
	call_now  = false,
	autostart = false,
	callback  = function(self)
		if disk.popup.visible then
			disk.update()
			self:again()
		else
			self:stop()
		end
	end
}


disk.update = function()
	awful.spawn.easy_async_with_shell(cmd_lsblk, function(out)
		--print(os.date("%X") .. ": update disk data")
		dashboard.data = json.decode(out).blockdevices
	end)
end


disk.setup = function(mt,ml,mr,mb)
	disk.widget.margin.top    = dpi(mt or 0)
	disk.widget.margin.left   = dpi(ml or 0)
	disk.widget.margin.right  = dpi(mr or 0)
	disk.widget.margin.bottom = dpi(mb or 0)

	disk.widget:connect_signal('mouse::enter',function() 
		if disk.popup.visible then
			disk.widget.bg = theme.widget_bg_press
		else
			disk.widget.bg = theme.widget_bg_hover
		end
	end)

	disk.widget:connect_signal('mouse::leave',function() 
		if disk.popup.visible then
			disk.widget.bg = theme.widget_bg_press
		else
			disk.widget.bg = theme.topbar_bg
		end
	end)

	disk.popup:buttons(gears.table.join(
		awful.button({ }, 3, function ()
			disk.popup.visible = false
			disk.widget.bg = theme.topbar_bg
		end)))

	disk.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			disk.popup.visible = not disk.popup.visible
			if disk.popup.visible then
				disk.widget.bg = theme.widget_bg_press
			else
				disk.widget.bg = theme.widget_bg_hover
			end
			--disk.popup.x = mouse.coords().x - dpi(135)
			--disk.popup.y = theme.popup_margin_top

			if disk.popup.visible then
				disk.update()
				popup_timer:again()
			end
		end)))

	return disk.widget
end


return disk
