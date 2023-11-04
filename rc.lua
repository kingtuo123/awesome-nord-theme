pcall(require, "luarocks.loader")
local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local xresources    = require("beautiful.xresources")
local dpi           = xresources.apply_dpi
require("awful.autofocus")
require("awful.hotkeys_popup.keys")
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")





local topbar   = require("topbar")
local volume   = require("widgets.volume")
local battery  = require("widgets.battery")
local panel	   = require("widgets.panel")
local titlebar = require("widgets.titlebar")





terminal          = "alacritty"
floating_terminal = "alacritty --title='floating-terminal'"
modkey            = "Mod4"





----------------------------------------------------------------------------------------------
--------------------------------- layouts setting --------------------------------------------
----------------------------------------------------------------------------------------------
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
----------------------------------------------------------------------------------------------
--------------------------------- end of layouts ---------------------------------------------
----------------------------------------------------------------------------------------------





----------------------------------------------------------------------------------------------
--------------------------------- Desktop mouse bindings -------------------------------------
----------------------------------------------------------------------------------------------
root.buttons(gears.table.join(
    awful.button({ }, 9, awful.tag.viewnext),
    awful.button({ }, 8, awful.tag.viewprev)
))
----------------------------------------------------------------------------------------------
--------------------------------- end of mouse bindings --------------------------------------
----------------------------------------------------------------------------------------------





----------------------------------------------------------------------------------------------
----------------------------------- Key bindings ---------------------------------------------
----------------------------------------------------------------------------------------------
globalkeys = gears.table.join(
	awful.key({                   }, "XF86AudioRaiseVolume" , function() volume.up() panel.update() end),
	awful.key({                   }, "XF86AudioLowerVolume" , function() volume.down() panel.update() end),
	awful.key({                   }, "XF86AudioMute"        , function() volume.toggle() panel.update() end),
	awful.key({                   }, "XF86MonBrightnessUp"  , function() battery.brightness_up() panel.update() end),
	awful.key({                   }, "XF86MonBrightnessDown", function() battery.brightness_down() panel.update() end),
	awful.key({ modkey,           }, "r"                    , 
		function() 
			s = awful.screen.focused()
			s.promptbox.popup.visible = not s.promptbox.popup.visible
			s.promptbox.widget:run() 
		end
	),
    awful.key({ modkey,           }, "[",   awful.tag.viewprev),
    awful.key({ modkey,           }, "]",  awful.tag.viewnext),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    --awful.key({ modkey,           }, "j",      function () awful.client.focus.byidx( 1) end),
    --awful.key({ modkey,           }, "k",      function () awful.client.focus.byidx(-1) end),
    awful.key({ modkey,           }, "Tab",    function () awful.client.focus.byidx(1) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    --awful.key({ modkey,           }, "`", function () awful.client.focus.history.previous() if client.focus then client.focus:raise() end end),

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
    awful.key({ modkey, "Control" }, "-"     , function (c) c.height = c.height - dpi(100) end),
    awful.key({ modkey,           }, "`"     , awful.titlebar.toggle)
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

root.keys(globalkeys)
----------------------------------------------------------------------------------------------
---------------------------------- end of key bindings ---------------------------------------
----------------------------------------------------------------------------------------------





----------------------------------------------------------------------------------------------
---------------------------------- client buttons --------------------------------------------
----------------------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------------------
------------------------------------- end of client buttons ----------------------------------
----------------------------------------------------------------------------------------------





----------------------------------------------------------------------------------------------
------------------------------------- Rules --------------------------------------------------
----------------------------------------------------------------------------------------------
awful.rules.rules = {
    -- All clients will match this rule.
    {
		rule = { },
		properties = { 
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus        = awful.client.focus.filter,
			raise        = true,
			keys         = clientkeys,
			buttons      = clientbuttons,
			screen       = awful.screen.preferred,
			placement    = awful.placement.centered  + awful.placement.no_overlap + awful.placement.no_offscreen,
			size_hints_honor = false 
		}
    },
    ----------------------------------
    { 
		rule_any = {
			type = { "normal", "dialog" }
		}, 
		properties = {
			titlebars_enabled = true
		}
    },
    ----------------------------------
    { 
		rule_any = {
			class = {"firefox-esr"}
		}, 
		properties = {
			titlebars_enabled = false
		}
    },
    ----------------------------------
    { 
		rule_any = {
			class  = { "flameshot", "mpv", "feh"},
			name   = { "floating-terminal", "Library", "Save As", "About Mozilla Firefox"},
			type   = { "dialog" }
    	},
		properties = { 
			floating = true,
			ontop    = true
		}
    },
}
----------------------------------------------------------------------------------------------
------------------------------- end of rules -------------------------------------------------
----------------------------------------------------------------------------------------------





----------------------------------------------------------------------------------------------
---------------------------------- Signal ----------------------------------------------------
----------------------------------------------------------------------------------------------
-- client.connect_signal("manage", function (c)
--     if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
-- 	  awful.placement.no_offscreen(c)
--     end
-- end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	titlebar.setup(c)
end)

-- client.connect_signal("mouse::enter", function(c)
-- 	c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

client.connect_signal("unfocus", function(c) 
	c.border_color = beautiful.border_normal
end)

client.connect_signal("focus", function(c) 
	c.border_color = beautiful.border_focus 
end)
----------------------------------------------------------------------------------------------
---------------------------------- end of signal ---------------------------------------------
----------------------------------------------------------------------------------------------





-- create topbar
awful.screen.connect_for_each_screen(function(s)
	topbar.setup(s) 
end)
