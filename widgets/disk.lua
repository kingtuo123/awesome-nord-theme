local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local json  = require("lib.json")
local theme = require("theme")
local beautiful	 = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi 		 = xresources.apply_dpi









--disk
local disk = {}
local colors = {
	--theme.color10,
	--theme.color9,
	theme.color8,
	theme.color8,
	theme.color7,
	theme.color7,
	theme.color14,
	theme.color13,
	theme.color13,
	theme.color12,
	theme.color12,
	theme.color11,
	theme.color11,
}

local mount_ignore = "nvme0n1"
local cmd_lsblk	   = "lsblk -o NAME,SIZE,MOUNTPOINTS,FSAVAIL,FSUSE%,FSUSED,FSTYPE,HOTPLUG,LABEL,MODEL,PARTLABEL,UUID -x NAME -J|sed s/%//g"
local cmd_mount    = function(name) return "udisksctl   mount -b /dev/" .. name end
local cmd_umount   = function(name) return "udisksctl unmount -b /dev/" .. name end
local cmd_open     = function(mountpoint) return "uxterm -e 'cd " .. mountpoint .. " && /bin/bash'" end

disk.widget = wibox.widget{
	image = theme.disk_icon,
	widget = wibox.widget.imagebox,
}

disk.update = function()
	awful.spawn.easy_async_with_shell(cmd_lsblk, function(out)
		print("update disks")
		disk.panel.data = json.decode(out).blockdevices
	end)
end

disk.umount = function(name)
		local cmd = cmd_umount(name) .. " > /dev/null && " .. cmd_lsblk
		awful.spawn.easy_async_with_shell(cmd, function(out)
			print("umount " .. name)
			if #out < 10 then
				print("umount failed")
			else
				disk.panel.data = json.decode(out).blockdevices
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
				disk.panel.data = json.decode(out).blockdevices
			end
		end)
end

disk.buttons = awful.util.table.join (
	awful.button({}, 1, function() 
		disk.popup.visible = not disk.popup.visible
		if disk.popup.visible then
			disk.update()
		end
	end)
)


disk.panel = wibox.widget{
	{
		{
			id	   = "head",
			widget = wibox.widget.textbox,
		},
		top = dpi(0),
		widget = wibox.container.margin,
	},
	{
		id = "device",
		layout = wibox.layout.fixed.vertical,
	},
	{
		{
			id	   = "footer",
			widget = wibox.widget.textbox,
		},
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
		part.title = args.label or args.partlabel or args.name

		if args.hotplug then
			part.icon = theme.usb_icon
		else
			part.icon = theme.hhd_icon
		end

		if #args.mountpoints > 0 then
			part.font	  = "Microsoft YaHei 8"
			part.opacity  = 1
			part.valign   = "top"
			part.top	  = dpi(3)
			part.size	  = args.fsused .. "/" .. args.size
			part.barcolor = colors[math.ceil(args.fsuse/10)]
		else
			part.font	  = "Microsoft YaHei 9"
			part.valign   = "center"
			part.opacity  = 0
			part.top	  = dpi(0)
			part.size	  = args.size
			part.barcolor = colors[1]
		end
		
		if string.match(args.name, mount_ignore) ~= nil then
			part.visible  = false
			part.barwidth = dpi(300)
		else
			if #args.mountpoints > 0 then
				part.visible  = true
				part.barwidth = dpi(300) - dpi(25)
			else
				part.visible  = false
				part.barwidth = dpi(300)
			end
		end

		local wdg = wibox.widget{
			{
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
					top		= dpi(5),
					bottom	= dpi(5),
					widget	= wibox.container.margin,
				},
				{
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
					{
						{
							{
								text	= part.size,
								valign	= part.valign,
								halign	= "right",
								font	= part.font,
								widget	= wibox.widget.textbox,
							},
							right	= dpi(5),
							top		= part.top,
							widget	= wibox.container.margin,
						},
						valign = part.valign,
						halign = "right",
						layout = wibox.container.place,
					},
					{
						max_value     	 = 100,
						value         	 = args.fsuse,
						color			 = part.barcolor,
						background_color = theme.color3,
						forced_height	 = dpi(5),
						forced_width	 = part.barwidth,
						border_width	 = 0,
						opacity			 = part.opacity,
						margins			 = {top = dpi(20), right = dpi(5), left = dpi(0), bottom = dpi(6)},
						shape			 = function(cr, width, height)
							gears.shape.rounded_rect(cr, width, height, dpi(5))
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
				{
					{
						image			= theme.eject_icon,
						forced_width	= dpi(20),
						forced_height	= dpi(20),
						valign			= "center",
						halign			= "center",
						visible			= part.visible,
						widget			= wibox.widget.imagebox,
					},
					id		= "eject",
					margins = dpi(5),
					widget	= wibox.container.margin,
					buttons	= awful.util.table.join (
					awful.button({}, 1, function()
						if #args.mountpoints > 0 then
							disk.umount(args.name)
						end
					end)),
				},

				layout = wibox.layout.fixed.horizontal,
			},
			bg = theme.color0,
			widget = wibox.container.background,
		}
		wdg:connect_signal('mouse::enter',function (self) 
			wdg.bg = theme.color1
		end)
		wdg:connect_signal('mouse::leave',function (self) 
			wdg.bg = theme.color0
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
				cnt = cnt +1
				self:add_model(cnt,v.model)
			elseif (v.fstype ~= nil and v.fstype ~= "swap" and v.fstype ~= "ntfs") or (v.fstype == "ntfs" and (v.label ~= nil or v.partlabel ~= nil)) then
				cnt = cnt +1
				self:add_partition(cnt,v)
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
	widget			= disk.panel,
	border_color	= theme.color3,
    border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.color0,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	end,
    placement		= function(wdg,args)  
		awful.placement.top_right(wdg, {margins = { top = theme.popup_margin_top ,right = dpi(5)}}) 
	end,
}
--end of disk








return disk
