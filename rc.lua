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
local focus    = require("widgets.focus")





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
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev),
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
    awful.key({ modkey,           }, "Tab",    function () awful.client.focus.byidx(1) end),
    awful.key({ modkey, "Shift"   }, "Tab",    function () awful.client.focus.byidx(-1) end),

    -- Layout manipulation
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    --awful.key({ modkey,           }, "`", function () awful.client.focus.history.previous() if client.focus then client.focus:raise() end end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(floating_terminal) end),
    awful.key({ modkey, "Control" }, "s"     , function () awful.spawn("flameshot gui") end),
    awful.key({ modkey, "Control" }, "r"     , awesome.restart),
    awful.key({ modkey, "Shift"   }, "q"     , awesome.quit),
    --awful.key({ modkey,           }, "l"     , function () awful.tag.incmwfact( 0.02) end),
    --awful.key({ modkey,           }, "h"     , function () awful.tag.incmwfact(-0.02) end),
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
    awful.key({ modkey,           }, "`"     , function (c) focus.setup(c) end),
    awful.key({ modkey, "Shift"   }, "t"     , awful.titlebar.toggle),
    awful.key({ modkey,           }, "c"     , function (c)
		s = awful.screen.focused()
		cx = s.geometry.width / 2
		cy = (s.geometry.height + theme.topbar_height) / 2
		c.x = cx - c.width / 2 - theme.border_width
		c.y = cy - c.height / 2 - theme.border_width
	end),
    awful.key({ modkey,           }, "="     , function (c) 
		layout = awful.layout.get(awful.screen.focused())
		if c.floating or layout == awful.layout.suit.floating then
			w = c.width * 0.1  
			h = c.height * 0.1  
			c.width = c.width + w  
			c.height = c.height + h  
			c.x = c.x - (w / 2)  
			c.y = c.y - (h / 2) 
		elseif c == awful.client.getmaster() then
			awful.tag.incmwfact(0.05)
		else
			awful.client.incwfact(0.1)
		end
	end),
    awful.key({ modkey,           }, "-"     , function (c) 
		layout = awful.layout.get(awful.screen.focused())
		if c.floating or layout == awful.layout.suit.floating then
			w = c.width * 0.1  
			h = c.height * 0.1  
			c.width = c.width - w  
			c.height = c.height - h  
			c.x = c.x + (w / 2)  
			c.y = c.y + (h / 2) 
		elseif c == awful.client.getmaster() then
			awful.tag.incmwfact(-0.05)
		else
			awful.client.incwfact(-0.1)
		end
	end),
    awful.key({ modkey, "Shift"   }, "="     , function (c) 
		w = c.width * 0.1
		c.width = c.width + w 
		c.x = c.x - (w / 2)
	end),
    awful.key({ modkey, "Shift"   }, "-"     , function (c) 
		w = c.width * 0.1
		c.width = c.width - w 
		c.x = c.x + (w / 2)
	end),
    awful.key({ modkey, "Control" }, "="     , function (c) 
		h = c.height * 0.1
		c.height = c.height + h 
		c.y = c.y - (h / 2)
	end),
    awful.key({ modkey, "Control" }, "-"     , function (c) 
		h = c.height * 0.1
		c.height = c.height - h 
		c.y = c.y + (h / 2)
	end),
    awful.key({ modkey, "Shift"   }, "h"     , function (c)
		s = awful.screen.focused()
		layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			left = c.x - dpi(50)
			if left > 0 then
				c.x = c.x - dpi(50)
			else
				c.x = 0
			end
		else
			awful.tag.incnmaster( 1, nil, true)
		end
	end),
    awful.key({ modkey, "Shift"   }, "l"     , function (c)
		s = awful.screen.focused()
		layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			right = c.x + dpi(50)
			if right < s.geometry.width - c.width then
				c.x = c.x + dpi(50)
			else
				c.x = s.geometry.width - c.width
			end
		else
			awful.tag.incnmaster( -1, nil, true)
		end
	end),
    awful.key({ modkey, "Shift"   }, "j"     , function (c)
		s = awful.screen.focused()
		layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			bottom = c.y + c.height + dpi(50)
			if bottom < s.geometry.height then
				c.y = c.y + dpi(50)
			else
				c.y = s.geometry.height - c.height
			end
		else
			awful.client.swap.byidx( 1)
		end
	end),
    awful.key({ modkey, "Shift"   }, "k"     , function (c)
		s = awful.screen.focused()
		layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			top = c.y - dpi(50)
			if top > s.workarea.y then
				c.y = c.y - dpi(50)
			else
				c.y = s.workarea.y
			end
		else
			awful.client.swap.byidx( -1)
		end
	end)
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
				awful.tag.incmwfact(0.05)
			else
				awful.client.incwfact(0.1)
			end
		end
	end),
	awful.button({ modkey }, 5, function(c)
		c:emit_signal("request::activate", "titlebar", {raise = true})
		if mouse.screen.selected_tag.layout.name ~= "floating" and not c.maximized and not c.floating then
			if awful.client.getmaster() == c then
				awful.tag.incmwfact(-0.05)
			else
				awful.client.incwfact(-0.1)
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
			placement    = awful.placement.centered,
			maximized	 = false,
			titlebars_enabled = false,
			size_hints_honor = true
		}
    },
    ----------------------------------
    --{ 
	--	rule_any = {
	--		type = { "normal", "dialog" }
	--	}, 
	--	properties = {
	--		titlebars_enabled = true
	--	}
    --},
    ----------------------------------
    --{ 
	--	rule_any = {
	--		class = {"firefox-esr","Alacritty"}
	--	}, 
	--	properties = {
	--		titlebars_enabled = true
	--	}
    --},
    ----------------------------------
    { 
		rule_any = {
			class  = { "flameshot", "mpv", "feh", "Browser"},
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
local current_focus = 0

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	titlebar.setup(c)
end)

client.connect_signal("property::size", function(c) 
	--print("size")
	if c.pid == current_focus then
		focus.setup(c)
	end
end)

client.connect_signal("property::position", function(c) 
	--print("position")
	if c.pid == current_focus then
		focus.setup(c)
	end
end)

client.connect_signal("unfocus", function(c) 
	--print("unfocus ")
	if #awful.screen.focused().clients <= 1 then
		focus.invisible()
	end
	c.border_color = beautiful.border_normal
end)

client.connect_signal("focus", function(c) 
	--print("focus")
	current_focus = c.pid
	if #awful.screen.focused().clients > 1 then
		c.border_color = theme.border_focus
	else
		c.border_color = theme.border_normal
	end
	c.border_width = beautiful.border_width
	focus.setup(c)
end)

-- client.connect_signal("mouse::enter", function(c)
-- 	c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

--client.connect_signal("manage", function (c)
--    c.shape = function(cr,w,h)
--        gears.shape.rounded_rect(cr,w,h,theme.border_rounded)
--    end
--end)
----------------------------------------------------------------------------------------------
---------------------------------- end of signal ---------------------------------------------
----------------------------------------------------------------------------------------------





-- setup topbar
awful.screen.connect_for_each_screen(function(s)
	topbar.setup(s) 
end)
