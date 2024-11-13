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
--local titlebar = require("widgets.titlebar")
local quake    = require("widgets.quake")
local corner   = require("widgets.corner")
local indicator = require("widgets.indicator")

local smart_move = require("widgets.move")
local smart_resize = require("widgets.resize")
local close = require("widgets.close")




terminal          = "alacritty"
floating_terminal = "alacritty --title='floating-terminal'"
modkey            = "Mod4"





----------------------------------------------------------------------------------------------
--------------------------------- layouts setting --------------------------------------------
----------------------------------------------------------------------------------------------
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        --awful.layout.suit.tile.bottom,
        --awful.layout.suit.tile.top,
        --awful.layout.suit.fair,
        --awful.layout.suit.fair.horizontal,
		--awful.layout.suit.max,
    })
end)
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
	--awful.key({                   }, "XF86MonBrightnessUp"  , function() battery.brightness_up() end),
	--awful.key({                   }, "XF86MonBrightnessDown", function() battery.brightness_down() end),
	awful.key({                   }, "XF86AudioPlay"        , function()  awful.spawn.with_shell("mpc toggle &> /dev/null") end),
	awful.key({                   }, "XF86AudioRaiseVolume" , function() volume:up() end),
	awful.key({                   }, "XF86AudioLowerVolume" , function() volume:down() end),
	awful.key({                   }, "XF86AudioMute"        , function() volume:toggle() end),
    --awful.key({ nil   , "Control" }, "space"     , function() volume:toggle()end),
    awful.key({ modkey, "Control" }, "r"     , awesome.restart),
    awful.key({ modkey, "Shift"   }, "q"     , awesome.quit),
    awful.key({ modkey,           }, "["     , awful.tag.viewprev),
    awful.key({ modkey,           }, "]"     , awful.tag.viewnext),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "Tab"   , function() awful.client.focus.byidx(1) end),
    awful.key({ modkey,           }, "Return", function() awful.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "Return", function() awful.spawn(floating_terminal) end),
    awful.key({ modkey, "Control" }, "s"     , function() awful.spawn("flameshot gui") end),
    awful.key({ modkey,           }, "space" , function() awful.layout.inc( 1) end),
    awful.key({ modkey, "Shift"   }, "space" , function() awful.layout.inc(-1) end),
	awful.key({ modkey,           }, "r"     , function() s = awful.screen.focused() s.promptbox.popup.visible = not s.promptbox.popup.visible s.promptbox.widget:run() end),
    awful.key({ modkey, "Control" }, "n"     , function() local c = awful.client.restore() if c then c:emit_signal( "request::activate", "key.unminimize", {raise = true}) end end),
    awful.key({ modkey,           }, "b"	 , function() local s = awful.screen.focused() s.topbar.visible = not s.topbar.visible end),
	awful.key({ modkey,           }, "z"     , function() awful.screen.focused().quake:toggle() end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f"     , function(c) c.fullscreen = not c.fullscreen c:raise() end),
    awful.key({ modkey, "Shift"   }, "c"     , function(c) c:kill() end),
    awful.key({ modkey, "Control" }, "space" , function(c) awful.client.floating.toggle(c)  indicator:update() end),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "s"     , function(c) c.sticky = not c.sticky  indicator:update() end),
    awful.key({ modkey,           }, "t"     , function(c) c.ontop = not c.ontop  indicator:update() end),
    awful.key({ modkey,           }, "m"     , function(c) c.maximized = not c.maximized c:raise() indicator:update() end),
    awful.key({ modkey,           }, "n"     , function(c) if c.class ~= "QuakeDD" then c.minimized = true else awful.screen.focused().quake:toggle() end end),
    awful.key({ modkey,           }, "h"     , function(c) awful.client.focus.bydirection("left", client.focus) end),
    awful.key({ modkey,           }, "l"     , function(c) awful.client.focus.bydirection("right", client.focus) end),
	awful.key({ modkey,           }, "j"     , function(c) awful.client.focus.bydirection("down", client.focus) end),
    awful.key({ modkey,           }, "k"     , function(c) awful.client.focus.bydirection("up", client.focus) end),
    --awful.key({ modkey,           }, "`"     , function(c) awful.titlebar.toggle(c) end),
    awful.key({ modkey,           }, "`"     , function(c) awful.client.floating.toggle(c)  indicator:update() end),
    awful.key({ modkey,           }, "c"     , function(c) 
		local s = awful.screen.focused() 
		if s.topbar.visible then
			margin_top = theme.topbar_height + theme.topbar_border_width
		else
			margin_top = 0
		end
		awful.placement.centered(c, {margins = {top = margin_top}}) 
	end),

    awful.key({ modkey,           }, "="     , function(c) smart_resize(c, "inc", "both") end),
    awful.key({ modkey,           }, "-"     , function(c) smart_resize(c, "dec", "both") end),
    awful.key({ modkey, "Shift"   }, "="     , function(c) smart_resize(c, "inc", "width") end),
    awful.key({ modkey, "Shift"   }, "-"     , function(c) smart_resize(c, "dec", "width") end),
    awful.key({ modkey, "Control" }, "="     , function(c) smart_resize(c, "inc", "height") end),
    awful.key({ modkey, "Control" }, "-"     , function(c) smart_resize(c, "dec", "height") end),
    awful.key({ modkey, "Shift"   }, "h"     , function(c) smart_move(c, "left") end),
    awful.key({ modkey, "Shift"   }, "l"     , function(c) smart_move(c, "right") end),
    awful.key({ modkey, "Shift"   }, "j"     , function(c) smart_move(c, "down") end),
    awful.key({ modkey, "Shift"   }, "k"     , function(c) smart_move(c, "up") end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 0, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, i,
		function ()
			if i == 0 then
				i = 10
			end
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, i,
		function ()
			if i == 0 then
				i = 10
			end
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
					--tag:view_only()
				end
			end
		end),
        -- Swap two tags 
        awful.key({ modkey, "Ctrl" },  i,
		function ()
			if i == 0 then
				i = 10
			end
			if client.focus then
				local s = awful.screen.focused()
				s.tags[i].name = client.focus.first_tag.name
				client.focus.first_tag.name = i
				client.focus.first_tag:swap(s.tags[i])
				--awful.tag.move(i,client.focus.first_tag)
			end
		end)
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
	awful.button({ modkey }, 4, function(c) smart_resize(c, "inc", "both") end),
	awful.button({ modkey }, 5, function(c) smart_resize(c, "dec", "both") end),
    awful.button({ modkey, "Shift"   }, 4, function(c) smart_resize(c, "inc", "width") end),
    awful.button({ modkey, "Shift"   }, 5, function(c) smart_resize(c, "dec", "width") end),
    awful.button({ modkey, "Control" }, 4, function(c) smart_resize(c, "inc", "height") end),
    awful.button({ modkey, "Control" }, 5, function(c) smart_resize(c, "dec", "height") end)
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
			floating     = true,
			titlebars_enabled = false,
			size_hints_honor = true
		}
    },
    ----------------------------------
    --{ 
	--	rule_any = {
	--		class = {"lxappearance", "Lxappearance", "flameshot", "Jsss"},
	--	}, 
	--	properties = {
	--		titlebars_enabled = true,
	--		ontop = false,
	--		floating = true
	--	}
    --},
    ----------------------------------
    { 
		rule_any = {
			type   = { "dialog" },
    	},
		properties = { 
			--titlebars_enabled = true,
			floating = true,
			ontop    = true
		}
    },
    ----------------------------------
    { 
		rule_any = {
			class  = {"Alacritty", "firefox", "Microsoft-edge", "Google-chrome", "Xephyr"},
    	},
		properties = { 
			titlebars_enabled = false,
			floating = false,
			ontop    = false
		}
    },
    ----------------------------------
    { 
		rule_any = {
			name   = { "floating-terminal", "feh", "QuakeDD"},
    	},
		properties = { 
			titlebars_enabled = false,
			floating = true,
			ontop    = true
		}
    },
    ----------------------------------
    { 
		rule_any = {
			name = {"Picture-in-Picture", "Picture in picture"}
		}, 
		properties = {
			titlebars_enabled = false,
			ontop = true,
			floating = true,
			sticky = true,
			size_hints_honor = false
		}
    },
    ----------------------------------
    { 
		rule_any = {
			class  = {"mpv"},
    	},
		properties = { 
			titlebars_enabled = false,
			floating = true,
			ontop    = false,
			sticky = false
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
	--titlebar:setup(c)
end)

--client.connect_signal("property::size", function(c) 
--end)

client.connect_signal("untagged", function(c) 
	local s = awful.screen.focused()
	if #s.clients == 0 then
		indicator:clear()
	end
end)

client.connect_signal("unfocus", function(c) 
	c.border_color = theme.border_normal
	--c.border_width = theme.border_width
end)

client.connect_signal("focus", function(c) 
	c.border_color = theme.border_focus
	local s = awful.screen.focused()
	if #s.clients == 1 then
		c.border_color = theme.border_normal
		--local l = awful.layout.get(s)
		--if c.floating or c.maximized or l == awful.layout.suit.floating then
		--	c.border_width = theme.border_width
		--else
		--	c.border_width = 0
		--end
	end
	indicator:update()
	if close.hover then
		close.widget:emit_signal("mouse::enter")
	end
end)

-- client.connect_signal("mouse::enter", function(c)
-- 	c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

client.connect_signal("manage", function (c)
	c:to_secondary_section()
    --c.shape = function(cr,w,h)
    --    gears.shape.rounded_rect(cr,w,h,theme.border_rounded)
    --end
end)

----------------------------------------------------------------------------------------------
---------------------------------- end of signal ---------------------------------------------
----------------------------------------------------------------------------------------------





-- setup topbar
screen.connect_signal("request::desktop_decoration", function(s)
	topbar:setup(s)
	corner:setup(s)
	s.quake = quake({
		app = "alacritty",
		argname = "--title %s",
		extra = "--class QuakeDD -e tmux-attach.sh",
		vert = "top",
		horiz = "center",
		visible = true,
		height = 0.388,
		width = 0.520,
		border = theme.border_width,
		margin_top = theme.useless_gap*2,
		screen = s
	})
end)
