-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local socket = require "socket"
local hotkeys_popup = require("awful.hotkeys_popup")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
require "mywibox"

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "uxterm"
floating_terminal = "uxterm -class floating-terminal"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


-- {{{ Mouse bindings
root.buttons(gears.table.join(
    --awful.button({ }, 3, function () mymainmenu:toggle() end),
    --awful.button({ }, 4, awful.tag.viewnext),
    --awful.button({ }, 5, awful.tag.viewprev),
    awful.button({ }, 9, awful.tag.viewnext),
    awful.button({ }, 8, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
	awful.key({                   }, "XF86AudioRaiseVolume",  myvolume.up),
	awful.key({                   }, "XF86AudioLowerVolume",  myvolume.down),
	awful.key({                   }, "XF86AudioMute"       ,  myvolume.toggle),
	awful.key({                   }, "XF86MonBrightnessUp" ,  mybattery.brightness_up),
	awful.key({                   }, "XF86MonBrightnessDown" ,  mybattery.brightness_down),
	awful.key({ modkey,           }, "r"                   , 
		function() 
			s = awful.screen.focused()
			s.mypromptbox_popup.visible = not s.mypromptbox_popup.visible
			s.mypromptbox:run() 
		end
	),
    --awful.key({ modkey,           }, "Left",   awful.tag.viewprev),
    --awful.key({ modkey,           }, "Right",  awful.tag.viewnext),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    --awful.key({ modkey,           }, "j",      function () awful.client.focus.byidx( 1) end),
    --awful.key({ modkey,           }, "k",      function () awful.client.focus.byidx(-1) end),
    awful.key({ modkey,           }, "Tab",    function () awful.client.focus.byidx(1) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "`",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end
	),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(floating_terminal) end),
    awful.key({ modkey,           }, "s"     , function () awful.spawn("flameshot gui") end),
    awful.key({ modkey, "Control" }, "r"     , awesome.restart),
    awful.key({ modkey, "Shift"   }, "q"     , awesome.quit),
    --awful.key({ modkey,           }, "l"     , function () awful.tag.incmwfact( 0.02) end),
    --awful.key({ modkey,           }, "h"     , function () awful.tag.incmwfact(-0.02) end),
    awful.key({ modkey, "Shift"   }, "Right" , function () awful.tag.incmwfact( 0.02) end),
    awful.key({ modkey, "Shift"   }, "Left"  , function () awful.tag.incmwfact(-0.02) end),
    awful.key({ modkey, "Shift"   }, "h"     , function () awful.tag.incnmaster( 1, nil, true) end),
    awful.key({ modkey, "Shift"   }, "l"     , function () awful.tag.incnmaster(-1, nil, true) end),
    awful.key({ modkey, "Control" }, "h"     , function () awful.tag.incncol( 1, nil, true) end),
    awful.key({ modkey, "Control" }, "l"     , function () awful.tag.incncol(-1, nil, true) end),
    awful.key({ modkey,           }, "space" , function () awful.layout.inc( 1) end),
    awful.key({ modkey, "Shift"   }, "space" , function () awful.layout.inc(-1) end),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f"     , function (c) c.fullscreen = not c.fullscreen c:raise() end),
    awful.key({ modkey, "Shift"   }, "c"     , function (c) c:kill() end),
    awful.key({ modkey, "Control" }, "space" , awful.client.floating.toggle),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Shift"   }, "Up"    , function (c) awful.client.incwfact(0.03) end),
    awful.key({ modkey, "Shift"   }, "Down"  , function (c) awful.client.incwfact(-0.03) end),
    awful.key({ modkey,           }, "o"     , function (c) c:move_to_screen()               end),
    awful.key({ modkey,           }, "t"     , function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n"     , function (c) c.minimized = true end),
    awful.key({ modkey,           }, "m"     , function (c) c.maximized = not c.maximized c:raise() end),
    awful.key({ modkey, "Control" }, "m"     , function (c) c.maximized_vertical = not c.maximized_vertical c:raise() end),
    awful.key({ modkey, "Shift"   }, "m"     , function (c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end),
    awful.key({ modkey,           }, "h"     , function (c) awful.client.focus.bydirection("left", client.focus) end),
    awful.key({ modkey,           }, "l"     , function (c) awful.client.focus.bydirection("right", client.focus) end),
    awful.key({ modkey,           }, "j"     , function (c) awful.client.focus.byidx(1) end),
    awful.key({ modkey,           }, "k"     , function (c) awful.client.focus.byidx(-1) end),
    awful.key({ modkey,           }, "Up"    , function (c) awful.client.focus.bydirection("up", client.focus) end),
    awful.key({ modkey,           }, "Down"  , function (c) awful.client.focus.bydirection("down", client.focus) end),
    awful.key({ modkey,           }, "Right" , function (c) awful.client.focus.bydirection("right", client.focus) end),
    awful.key({ modkey,           }, "Left"  , function (c) awful.client.focus.bydirection("left", client.focus) end),
    awful.key({ modkey, "Shift"   }, "="     , function (c) c.width = c.width + dpi(100) end),
    awful.key({ modkey, "Shift"   }, "-"     , function (c) c.width = c.width - dpi(100) end),
    awful.key({ modkey, "Control" }, "="     , function (c) c.height = c.height + dpi(100) end),
    awful.key({ modkey, "Control" }, "-"     , function (c) c.height = c.height - dpi(100) end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
		if (mouse.screen.selected_tag.layout.name == "floating" or c.floating) and not c.maximized then
			awful.mouse.client.resize(c)
		end
    end),
	awful.button({ modkey }, 4, function(c)
		c:emit_signal("request::activate", "titlebar", {raise = true})
		if mouse.screen.selected_tag.layout.name ~= "floating" and not c.maximized and not c.floating then
			if awful.client.getmaster() == c then
				awful.tag.incmwfact(0.02)
			else
				awful.client.incwfact(0.03)
			end
		end
	end),
	awful.button({ modkey }, 5, function(c)
		c:emit_signal("request::activate", "titlebar", {raise = true})
		if mouse.screen.selected_tag.layout.name ~= "floating" and not c.maximized and not c.floating then
			if awful.client.getmaster() == c then
				awful.tag.incmwfact(-0.02)
			else
				awful.client.incwfact(-0.03)
			end
		end
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.centered  + awful.placement.no_overlap + awful.placement.no_offscreen,
					 size_hints_honor = false 
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
		  "Places",
          "Wpa_gui",
          "feh",
          },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
		  "Library",
		  "Save As",
		  "About Mozilla Firefox",
        },
        role = {
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true ,
	  					ontop = true }
	},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    { rule_any = {class = { "floating-terminal", "thunar", "Thunar", "flameshot"}
      }, properties = { floating = true , ontop = true}
    },
    { rule_any = {class = {"xarchiver", "Xarchiver"}
      }, properties = { floating = true , ontop = true, width = dpi(1000), height = dpi(700)}
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
first_click = 0
awful.titlebar.enable_tooltip = false
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
			
			if socket.gettime() - first_click <= 0.3 then
				c.maximized = not c.maximized
				first_click = 0
				return
			else
				first_click = socket.gettime()
			end

            awful.mouse.client.move(c)
        end),
        awful.button({ }, 2, function()
			c.maximized = not c.maximized
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
			if (mouse.screen.selected_tag.layout.name == "floating" or c.floating) and not c.maximized then
				awful.mouse.client.resize(c)
			end
        end),
		awful.button({  }, 4, function()
			c:emit_signal("request::activate", "titlebar", {raise = true})
			if mouse.screen.selected_tag.layout.name ~= "floating" and not c.maximized and not c.floating then
				if awful.client.getmaster() == c then
					awful.tag.incmwfact(0.02)
				else
					awful.client.incwfact(0.03)
				end
			end
		end),
		awful.button({  }, 5, function()
			c:emit_signal("request::activate", "titlebar", {raise = true})
			if mouse.screen.selected_tag.layout.name ~= "floating" and not c.maximized and not c.floating then
				if awful.client.getmaster() == c then
					awful.tag.incmwfact(-0.02)
				else
					awful.client.incwfact(-0.03)
				end
			end
		end)
    )


	local top_titlebar = awful.titlebar(c, {
		size      = theme.titlebar_height,
	})

	top_titlebar : setup {
		{ -- Left
			--{
			--	awful.titlebar.widget.iconwidget(c),
			--	buttons = buttons,
			--	layout  = wibox.layout.fixed.horizontal
			--},
			{
				--image = theme.titlebar_ontop,
				--resize = true,
				--widget = wibox.widget.imagebox(),
				awful.titlebar.widget.floatingbutton (c),
				wibox.widget.textbox("  "),
				awful.titlebar.widget.ontopbutton    (c),
				wibox.widget.textbox("  "),
				awful.titlebar.widget.stickybutton   (c),
				layout = wibox.layout.fixed.horizontal(),
			},
			top = 13,
			left = 13,
			bottom = 13,
			--forced_width = 300,
			widget = wibox.container.margin,
		},
		{ -- Middle
			{ -- Title
				align  = 'center',
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout  = wibox.layout.flex.horizontal
		},
		{ -- Right
			{
					awful.titlebar.widget.minimizebutton (c),
					wibox.widget.textbox("  "),
					awful.titlebar.widget.maximizedbutton(c),
					wibox.widget.textbox("  "),
					awful.titlebar.widget.closebutton    (c),
					layout = wibox.layout.fixed.horizontal(),
				},
				top = 13,
				left = 13,
				right = 13,
				bottom = 13,
				widget = wibox.container.margin,
		},
		layout = wibox.layout.align.horizontal
	}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    --c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("unfocus", function(c) 
	c.border_color = beautiful.border_normal
end)

client.connect_signal("focus", function(c) 
	c.border_color = beautiful.border_focus 
end)


--client.connect_signal("none", function(c)
--    local icon = menubar.utils.lookup_icon(c.instance)
--    local lower_icon = menubar.utils.lookup_icon(c.instance:lower())
--
--    --Check if the icon exists
--    if icon ~= nil then
--		print(icon)
--		local new_icon = gears.surface(icon)
--        c.icon = new_icon._native
--        --c.icon = gears.surface(icon)._native
--
--    --Check if the icon exists in the lowercase variety
--    elseif lower_icon ~= nil then
--		local new_icon = gears.surface(lower_icon)
--        c.icon = new_icon._native
--        --c.icon = gears.surface(lower_icon)._native
--
--    --Check if the client already has an icon. If not, give it a default.
--    elseif c.icon == nil then
--		local new_icon = gears.surface(menubar.utils.lookup_icon("application-default-icon"))
--        c.icon = new_icon._native
--        --c.icon = gears.surface(menubar.utils.lookup_icon("application-default-icon"))._native
--    end
--end)

--client.connect_signal("request::manage", function(c)
--	if c.maximized then
--		c.border_width = 0
--		c.shape = function(cr,w,h)
--			gears.shape.rounded_rect(cr,w,h,0)
--		end
--	else
--		c.border_width = theme.border_width
--		c.shape = function(cr,w,h)
--			gears.shape.rounded_rect(cr,w,h,theme.border_rounded)
--		end
--	end
--end)

-- }}}

--client.connect_signal("button::press", function(c) 
--        naughty.notify({ preset = naughty.config.presets.critical,
--                         title = "Oops, an error happened!",
--                         text = tostring(err) })
--end)


-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) at_screen_connect(s) end)
-- }}}
