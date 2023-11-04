local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local json  = require("lib.json")
local dpi	= require("beautiful.xresources").apply_dpi


local disk = {}
local colors = {
	theme.blue1,
	theme.blue1,
	theme.blue0,
	theme.blue0,
	theme.green,
	theme.green,
	theme.yellow,
	theme.orange,
	theme.orange,
	theme.red,
	theme.red,
}


local partition_ignore = {"sda4"}
local eject_ignore = {"nvme0n1"}
local cmd_lsblk	   = "lsblk -o NAME,SIZE,MOUNTPOINTS,FSAVAIL,FSUSE%,FSUSED,FSTYPE,HOTPLUG,LABEL,MODEL,PARTLABEL,UUID,PARTUUID -x NAME -J|sed s/%//g"
local cmd_mount    = function(name) return "udisksctl   mount -b /dev/" .. name end
local cmd_umount   = function(name) return "udisksctl unmount -b /dev/" .. name end
local cmd_open     = function(mountpoint) return "alacritty --working-directory " .. mountpoint end
--local cmd_open     = function(mountpoint) return "uxterm -e 'cd " .. mountpoint .. " && /bin/bash'" end


disk.widget = wibox.widget{
	{
		{
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


disk.umount = function(name)
		local cmd = cmd_umount(name) .. " > /dev/null && " .. cmd_lsblk
		awful.spawn.easy_async_with_shell(cmd, function(out)
			print("umount " .. name)
			if #out < 10 then
				print("umount failed")
			else
				disk.device.data = json.decode(out).blockdevices
			end
		end)
end


disk.mount = function(name)
		local cmd = cmd_mount(name) .. " > /dev/null && " .. cmd_lsblk
		awful.spawn.easy_async_with_shell(cmd, function(out)
			print("mount " .. name)
			if #out < 10 then
				print("mount failed")
			else
				disk.device.data = json.decode(out).blockdevices
			end
		end)
end




disk.device = wibox.widget{
	{
		id	   = "head",
		top    = dpi(0),
		widget = wibox.container.margin,
	},
	{
		id     = "device",
		layout = wibox.layout.fixed.vertical,
	},
	{
		id	   = "footer",
		bottom = dpi(10),
		widget = wibox.container.margin,
	},
	layout = wibox.layout.fixed.vertical,

	parts = {},
	add_model = function(self,index,model)
		local wdg = wibox.widget{
			{
				{
					text   = model,
					font   = "Microsoft YaHei Bold 9",
					widget = wibox.widget.textbox,
				},
				top	   = dpi(10),
				left   = dpi(10),
				right  = dpi(10),
				bottom = dpi(5),
				widget = wibox.container.margin,
			},
			layout = wibox.layout.fixed.horizontal,
		}
		if self.parts[index] == nil then
			--print("insert new")
			self.device:insert(index,wdg)
		else
			--print("replace old")
			self.device:replace_widget(self.parts[index],wdg)
		end
		self.parts[index] = wdg
	end,

	add_partition = function(self,index,args)
		local part = {}
		part.title = args.label or args.partlabel or args.name or "Unknow Device"

		if args.hotplug then
			part.icon = theme.usb_icon
		else
			part.icon = theme.hhd_icon
		end

		if #args.mountpoints > 0 then
			-- mounted partition
			part.font	  = "Microsoft YaHei 8"
			part.opacity  = 1
			part.valign   = "top"
			part.top	  = dpi(6)
			part.eject  = true
			-- dpi(40) = width of eject_button
			part.barwidth = dpi(300) - dpi(40)
			part.size	  = args.fsused .. " / " .. args.size
			part.barcolor = colors[math.ceil(args.fsuse/10)]
		else
			-- not mounted partition
			part.font	  = "Microsoft YaHei 9"
			part.valign   = "center"
			part.opacity  = 0
			part.top	  = dpi(0)
			part.eject  = false
			part.barwidth = dpi(300)
			part.size	  = args.size
			part.barcolor = colors[1]
		end
	
		-- system partition
		for _,v in pairs(eject_ignore) do
			if string.match(args.name, v) ~= nil then
				-- disable eject icon
				part.eject  = false
				part.barwidth = dpi(300)
				break
			end
		end

		if part.eject then
			part.bg = theme.disk_part_bg_mounted
		else
			part.bg = theme.disk_part_bg_normal
		end

		local wdg = wibox.widget{
			{
				{
					-- device icon
					{
						{
							image		  = part.icon,
							forced_width  = dpi(25),
							forced_height = dpi(25),
							valign		  = "center",
							halign		  = "center",
							widget		  = wibox.widget.imagebox,
						},
						left	= dpi(10),
						right	= dpi(5),
						top		= dpi(10),
						bottom	= dpi(10),
						widget	= wibox.container.margin,
					},
					{
						-- partition name
						{
							{
								text	= part.title,
								valign	= part.valign,
								halign	= "left",
								font	= part.font,
								widget	= wibox.widget.textbox,
							},
							top		= part.top,
							widget	= wibox.container.margin,
						},
						-- partition size
						{
							{
								{
									text	= part.size,
									valign	= part.valign,
									halign	= "right",
									font	= part.font,
									widget	= wibox.widget.textbox,
								},
								right	= dpi(10),
								top		= part.top,
								widget	= wibox.container.margin,
							},
							valign = part.valign,
							halign = "right",
							layout = wibox.container.place,
						},
						-- partition progressbar
						{
							max_value     	 = 100,
							value         	 = math.floor(args.fsuse or 0),
							color			 = part.barcolor,
							background_color = theme.disk_bg_progressbar,
							forced_height	 = dpi(5),
							forced_width	 = part.barwidth,
							border_width	 = 0,
							opacity			 = part.opacity,
							margins			 = {top = dpi(25), right = dpi(10), left = dpi(0), bottom = dpi(11)},
							shape			 = function(cr, width, height)
								gears.shape.rounded_rect(cr, width, height, dpi(0))
							end,
							widget = wibox.widget.progressbar,
						},
						layout	= wibox.layout.stack,
						buttons	= awful.util.table.join (
						awful.button({}, 1, function()
							if #args.mountpoints > 0 then
								awful.spawn.with_shell(cmd_open(args.mountpoints[#args.mountpoints]))
							else
								disk.mount(args.name)
							end
						end)),
					},
					-- eject icon
					{
						{
							{
								image			= theme.eject_icon,
								forced_width	= dpi(20),
								forced_height	= dpi(20),
								valign			= "center",
								halign			= "center",
								widget			= wibox.widget.imagebox,
							},
							id		= "eject_icon",
							left	= dpi(10),
							right	= dpi(10),
							top		= dpi(10),
							bottom	= dpi(5),
							widget	= wibox.container.margin,
							buttons	= awful.util.table.join (
							awful.button({}, 1, function()
								if #args.mountpoints > 0 then
									disk.umount(args.name)
								end
							end)),
						},
						id      = "eject_button",
						visible	= part.eject,
						bg      = theme.disk_eject_bg_normal,
						widget  = wibox.container.background,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				id = "background",
				bg = part.bg,
				widget = wibox.container.background,
			},
			top    = dpi(0),
			left   = dpi(10),
			right  = dpi(10),
			bottom = dpi(0),
			widget = wibox.container.margin,
		}
		wdg:connect_signal('mouse::enter',function (self) 
			wdg:get_children_by_id("background")[1].bg = theme.disk_part_bg_hover
		end)
		wdg:connect_signal('mouse::leave',function (self) 
			if wdg:get_children_by_id("eject_button")[1].visible then
				wdg:get_children_by_id("background")[1].bg = theme.disk_part_bg_mounted
			else
				wdg:get_children_by_id("background")[1].bg = theme.disk_part_bg_normal
			end
		end)
		wdg:get_children_by_id("eject_button")[1]:connect_signal('mouse::enter',function (self) 
			self.bg = theme.disk_eject_bg_hover
		end)
		wdg:get_children_by_id("eject_button")[1]:connect_signal('mouse::leave',function (self) 
			self.bg = theme.disk_eject_bg_normal
		end)
		if self.parts[index] == nil then
			--print("insert new")
			self.device:insert(index,wdg)
		else
			--print("replace old")
			self.device:replace_widget(self.parts[index],wdg)
		end
		self.parts[index] = wdg
	end,

	set_data = function(self,device)
		local cnt = 0
		for _,v in pairs(device) do
			if v.model ~= nil then
				cnt = cnt + 1
				self:add_model(cnt,v.model)
			--elseif (v.fstype ~= nil and v.fstype ~= "swap" and v.fstype ~= "ntfs") or (v.fstype == "ntfs" and (v.label ~= nil or v.partlabel ~= nil)) then
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
					self:add_partition(cnt,v)
				end
			end
		end
		old_cnt = #self.parts
		if old_cnt > cnt then
			for i = cnt + 1, old_cnt do
				--print("remove old")
				self.device:remove_widgets(self.parts[i])
				self.parts[i] = nil
			end
		end
	end,
}


disk.popup = awful.popup{
	widget			= disk.device,
	border_color	= theme.popup_border_color,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.bg,
	fg				= theme.fg,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end,
    placement		= function(wdg,args)  
		awful.placement.top_right(wdg, {margins = { top = theme.popup_margin_top ,right = dpi(5)}}) 
	end,
}


disk.update = function()
	awful.spawn.easy_async_with_shell(cmd_lsblk, function(out)
		print("update disk data")
		disk.device.data = json.decode(out).blockdevices
	end)
end


--disk.popup_timer = gears.timer {
--	timeout   = 3,
--	call_now  = false,
--	autostart = false,
--	callback  = function(self)
--		if disk.popup.visible then
--			disk.update()
--			self:again()
--		else
--			self:stop()
--		end
--	end
--}


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
			disk.widget.bg = ""
		end
	end)

	disk.popup:buttons(gears.table.join(
		awful.button({ }, 3, function ()
			disk.popup.visible = false
			disk.widget.bg = ""
		end)))

	disk.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			disk.popup.visible = not disk.popup.visible
			if disk.popup.visible then
				disk.widget.bg = theme.widget_bg_press
			else
				disk.widget.bg = theme.widget_bg_hover
			end
			if disk.popup.visible then
				disk.update()
				--disk.popup_timer:again()
			end
		end)))

	return disk.widget
end





return disk
