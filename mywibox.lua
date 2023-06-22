local gears 	 = require("gears")
local awful		 = require("awful")
local wibox		 = require("wibox")
local beautiful  = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi		 = xresources.apply_dpi
local menubar = require("menubar")










local theme		 = require("theme")
local myclock    = require("widgets.clock")
local mydisk     = require("widgets.disk")
local mycpu	     = require("widgets.cpu")
local mymem	     = require("widgets.mem")
local mywifi     = require("widgets.wifi")
local myvpn      = require("widgets.vpn")
local mynetspeed = require("widgets.netspeed")
--local mydocker	 = require("widgets.docker")
myvolume 		 = require("widgets.volume")
mybattery		 = require("widgets.battery")










local popup_list = {}
local widget_list = {}
local clean_popup_exclude = function (p)
	for i,v in pairs(popup_list) do
		if v ~= p then
			v.visible = false
			widget_list[i].bg = theme.bg
		end
	end
end

local add_wdg = function(d,t,l,r,b)
	local ret = wibox.widget {
		{
			d.widget,
            top		= dpi(t or 0),
			left	= dpi(l or 0),
			right	= dpi(r or 0),
			bottom	= dpi(b or 0),
            widget	= wibox.container.margin
		},
		--shape = function(cr, width, height)
		--	gears.shape.rounded_rect(cr, width, height, dpi(3))
		--end,
		--shape_border_width = dpi(5),
		--shape_border_color = "",
		widget = wibox.container.background,
	}

	ret:connect_signal('mouse::enter',function() 
		ret.bg = theme.widget_bg_hover
	end)
	ret:connect_signal('mouse::leave',function(self) 
		if d.popup ~= nil then
			if d.popup.visible then
				ret.bg = theme.widget_bg_hover
			else
				ret.bg = theme.bg
			end
			if d.auto_clean_popup then
				ret.bg = theme.bg
			end
		else
			ret.bg = theme.bg
		end
	end)


	if d.buttons ~= nil then
		ret:buttons(d.buttons)
	end

	if d.popup ~= nil then
		table.insert(popup_list,d.popup)
		table.insert(widget_list,ret)
		ret:connect_signal('button::press',function() 
			clean_popup_exclude(d.popup)
		end)
		d.popup:buttons(gears.table.join(
			awful.button({ }, 3, function ()
				d.popup.visible = false
				ret.bg = theme.bg
			end)
		))
	end

	if d.timer ~= nil then
		gears.timer(d.timer)
	end

	return ret
end










function at_screen_connect(s)
	--mytaglist
	local tag_clicked = false
	local taglist_buttons = gears.table.join(
		awful.button({        }, 1, function(t)
			t:view_only() 
			tag_clicked = true 
		end),
		awful.button({ modkey }, 1, function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
			t:view_only() 
			tag_clicked = true 
		end),
		--awful.button({        }, 3, awful.tag.viewtoggle),
		--awful.button({ modkey }, 3, function(t)
		--	if client.focus then
		--		client.focus:toggle_tag(t)
		--	end
		--end),
		awful.button({        }, 4, function(t) awful.tag.viewnext(t.screen) end),
		awful.button({        }, 5, function(t) awful.tag.viewprev(t.screen) end)
	)

    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
	s.mytaglist = awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.all,
		style   = {
			--shape_border_width = theme.widget_shape_border_width,
			--shape_border_color = theme.widget_shape_border_color,
			--shape = function(cr, width, height)
			--	gears.shape.rounded_rect(cr, width, height, dpi(2))
			--end,
		},
		widget_template = {
			{
				{
					{
						{
							id     = 'text_role',
							widget = wibox.widget.textbox,
						},
						--left  = theme.wibar_height / 2.5,
						--right = theme.wibar_height / 2.5,
						--left  = theme.wibar_height / 3.4,
						--right = theme.wibar_height / 3.4,
						--widget = wibox.container.margin,
						valign = 'center',
						halign = 'center',
						widget = wibox.container.place,
					},
					{
						{
							{
								id = "line",
								text = "",
								forced_width = dpi(30),
								forced_height = dpi(2),
								widget = wibox.widget.textbox,
							},
							id = "linebg",
							bg = "#00000000",
							widget = wibox.container.background,
						},
						halign = 'center',
						valign = 'top',
						widget = wibox.container.place,
					},
					layout = wibox.layout.stack,
				},
				id     = "background_role",
				widget = wibox.container.background,
			},
			top	   = dpi(0),
			bottom = dpi(0),
			left   = dpi(0),
            widget = wibox.container.margin,
			create_callback = function(self, c3, index, objects)
				self:connect_signal("mouse::enter", function()
					if self.background_role.bg ~= theme.taglist_bg_hover  then
						self.backup     = self.background_role.bg
						self.has_backup = true
					end
					self.background_role.bg = theme.taglist_bg_hover 
				end)
				self:connect_signal("mouse::leave", function()
					if self.has_backup then 
						if tag_clicked == false then
							self.background_role.bg = self.backup 
						else
							tag_clicked = false
						end
					end
				end)
			end,
		},
		buttons = taglist_buttons
	}
	--end of mytaglist










	-- mylayoutbox
	mylayoutbox = {}
    mylayoutbox.widget = awful.widget.layoutbox(s)
    mylayoutbox.buttons = gears.table.join(
		awful.button({ }, 1, function () awful.layout.inc( 1) end),
		awful.button({ }, 2, function () awful.layout.set(awful.layout.suit.floating) end),
		awful.button({ }, 3, function () awful.layout.inc(-1) end),
		awful.button({ }, 4, function () awful.layout.inc( 1) end),
		awful.button({ }, 5, function () awful.layout.inc(-1) end)
	)
	-- end of mylayoutbox










	-- mypromptbox
	s.mypromptbox = awful.widget.prompt{
		prompt = "  ",
		--bg	= theme.color0,
		--fg	= theme.color6,
		bg_cursor = theme.prompt_fg,
		done_callback = function() s.mypromptbox_popup.visible = false
	end}

    s.mypromptbox_popup = awful.popup{
		widget = wibox.widget{
			{
				{
					{
						image  = theme.terminal_icon,
						resize = true,
						forced_height = dpi(20),
						forced_width = dpi(20),
						widget = wibox.widget.imagebox
					},
					halign = 'center',
					valign = 'center',
					widget = wibox.container.place,
				},
				left = dpi(10),
				widget = wibox.container.margin 
			},
			s.mypromptbox,
			layout = wibox.layout.fixed.horizontal,
		},
		border_color	= theme.promptbox_border,
		bg				= theme.promptbox_bg,
		border_width	= theme.popup_border_width,
		visible			= false,
		ontop			= true,
		minimum_width	= dpi(150),
		minimum_height  = dpi(50),
		shape			= function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
		end,
		placement		= function(wdg,args)  
			awful.placement.top(wdg, { margins = { top = theme.popup_margin_top}}) 
		end,
	}
	-- end of mypromptbox










	-- tasklist
	tasklist_buttons = gears.table.join(
		awful.button({ }, 1, function (c)
			if c == client.focus then
				c.minimized = true
			else
				c:emit_signal( "request::activate", "tasklist", {raise = true})
			end
		end),
		awful.button({ }, 2, function(c)
			--c.hidden = true

			--timer = gears.timer{
			--	timeout   = 1,
			--	call_now  = false,
			--	autostart = false,
			--	callback  = function(self)
			--		local x1 = mouse.coords().x
			--		mouse.coords {
			--			x = x1 - 10
			--		}
			--		print("kill client")
			--		c:kill()
			--		self:stop()
			--	end}
			--	timer:start()
			c:kill() 
		end),
		awful.button({ }, 3, function()
			--awful.menu.client_list()
		end),
		awful.button({ }, 4, function ()
			awful.client.focus.byidx(1)
		end),
		awful.button({ }, 5, function ()
			awful.client.focus.byidx(-1)
		end)
	)

	s.mytasklist = awful.widget.tasklist {
		screen   = s,
		filter   = awful.widget.tasklist.filter.currenttags,
		buttons  = tasklist_buttons,
		widget_template = {
			{
				{
					{
						{
							{
								id     = 'my_icon_role',
								widget = wibox.widget.imagebox,
							},
							halign = 'center',
							valign = 'center',
							widget = wibox.container.place,
						},
						margins = dpi(2),
						widget  = wibox.container.margin,
					},
					{
						{
							{
								id = "line",
								text = "",
								forced_width = theme.tasklist_line_width,
								forced_height = dpi(2),
								widget = wibox.widget.textbox,
							},
							id = "linebg",
							bg = theme.tasklist_bg_line,
							widget = wibox.container.background,
						},
						halign = 'center',
						valign = 'top',
						widget = wibox.container.place,
					},
					{
						{
							{
								text = "",
								forced_width = theme.tasklist_line_width,
								forced_height = dpi(2),
								widget = wibox.widget.textbox,
							},
							bg = "#00000000",
							widget = wibox.container.background,
						},
						halign = 'center',
						valign = 'top',
						widget = wibox.container.place,
					},
					layout = wibox.layout.stack,
				},
				--left  = dpi(10),
				--right = dpi(10),
				widget = wibox.container.margin
			},
			id     = 'background_role',
			border_width = dpi(5),
			border_strategy = "inner",
			widget = wibox.container.background,
			create_callback = function(self,c)
				local lookup = menubar.utils.lookup_icon
				--local icon = lookup(c.class) or lookup(c.class:lower())
				local icon = lookup(c.instance) or lookup(c.instance:lower())
				local my_icon_role = self:get_children_by_id('my_icon_role')[1]
				local line = self:get_children_by_id('line')[1]
				local linebg = self:get_children_by_id('linebg')[1]

				if icon ~= nil then
					my_icon_role.image = icon
				else
					my_icon_role.image = menubar.utils.lookup_icon("application-default-icon")
				end
				local background_role = self:get_children_by_id('background_role')[1]
				self:connect_signal("mouse::enter", function()
					if c == client.focus then
						background_role.bg = theme.tasklist_bg_hover
						linebg.opacity = 1
					elseif c.minimized then
						background_role.bg = theme.tasklist_bg_focus
						linebg.opacity = 0
					else
						background_role.bg = theme.tasklist_bg_focus
					end
					line.forced_width = theme.tasklist_line_width
				end)
				local leave = function()
					if c.minimized then
						background_role.bg = theme.tasklist_bg_minimize
						--line.forced_width = theme.tasklist_line_width - dpi(15)
						linebg.opacity = 0
					elseif c == client.focus then
						background_role.bg = theme.tasklist_bg_focus
						line.forced_width = theme.tasklist_line_width
						linebg.opacity = 1
					else
						line.forced_width = theme.tasklist_line_width - dpi(10)
						background_role.bg = theme.tasklist_bg_normal
					end
				end
				self:connect_signal("mouse::leave", leave)
				c:connect_signal("untagged", function()
					self:disconnect_signal("mouse::leave", leave)
				end)
				c:connect_signal("unfocus", function()
					if c.minimized then
						--line.forced_width = theme.tasklist_line_width - dpi(15)
						linebg.opacity = 0
					else
						line.forced_width = theme.tasklist_line_width - dpi(10)
					end
				end)
				c:connect_signal("focus", function()
					line.forced_width = theme.tasklist_line_width
					linebg.opacity = 1
				end)
			end,
		},
	}
	-- end of tasklist










    s.mywibox = awful.wibar({ position = "top", screen = s, height = theme.wibar_height, fg = theme.fg, bg = theme.bg})
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
			-- Left widgets
            layout = wibox.layout.fixed.horizontal,
			forced_width = dpi(870),
            s.mytaglist,
			wibox.widget.textbox("  "),
			s.mytasklist,
			wibox.widget.textbox("  "),
        },

				add_wdg(myclock,_,5,5,_),

        { 
				forced_width = dpi(870),
				layout = wibox.layout.align.horizontal,
				nil,
				nil,
				{
					layout = wibox.layout.fixed.horizontal,
					--wibox.widget.systray(),
					add_wdg(mynetspeed,6,7,0,6),
					add_wdg(mymem,7,7,7,7),
					add_wdg(mycpu,7,7,7,7),
					--add_wdg(mydocker,7,7,7,7),
					add_wdg(mydisk,9,8,8,9),
					add_wdg(myvpn,8,8,8,8),
					add_wdg(mywifi,9,7,7,9),
					add_wdg(myvolume,7,3,3,7),
					add_wdg(mybattery,8,6,5,8),
					add_wdg(mylayoutbox,8,8,8,8),
				}
        }
    }
end

--  docker container ls -a --format "{{.Names}}"|xargs docker container inspect --format '{name:"{{.Name}}",status:"{{.State.Status}}"},'|sed 's@/@@g'|sed '$s@,$@]}@'|sed '1s@^@{container:[@'
