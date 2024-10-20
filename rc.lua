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
--local battery  = require("widgets.battery")
local titlebar = require("widgets.titlebar")
local focus    = require("widgets.focus")
local quake    = require("libs.quake")





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
        --awful.layout.suit.tile.left,
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


local anchor_set = {}
anchor_set[1] = {}
anchor_set[1][1] = function(c,t) awful.placement.top_left(c, {margins = {top = t}}) end
anchor_set[1][2] = function(c,t) awful.placement.left(c, {margins = {top = t}}) end
anchor_set[1][3] = function(c,t) awful.placement.bottom_left(c) end
anchor_set[2] = {}
anchor_set[2][1] = function(c,t) awful.placement.top(c, {margins = {top = t}}) end
anchor_set[2][2] = function(c,t) awful.placement.centered(c, {margins = {top = t}}) end
anchor_set[2][3] = function(c,t) awful.placement.bottom(c) end
anchor_set[3] = {}
anchor_set[3][1] = function(c,t) awful.placement.top_right(c, {margins = {top = t}}) end
anchor_set[3][2] = function(c,t) awful.placement.right(c, {margins = {top = t}}) end
anchor_set[3][3] = function(c,t) awful.placement.bottom_right(c) end


function anchor_get(c, direct)
	local a = {}
	local s = awful.screen.focused()
	if s.topbar.visible then
		margin_top = theme.topbar_height
	else
		margin_top = 0
	end
	local dx = c.x - (s.geometry.width - (c.x + c.width + theme.border_width * 2))
	local dy = (c.y - margin_top) - (s.geometry.height - (c.y + c.height + theme.border_width * 2))
	if c.x < 0 then
		a.x = 0
	elseif c.x + c.width > s.geometry.width then
		a.x = 4
	elseif dx < (c.width - s.geometry.width) / 3 then
		a.x = 1
	elseif dx > (s.geometry.width - c.width) / 3 then
		a.x = 3
	else
		a.x = 2
	end
	if c.y < margin_top then
		a.y = 0
	elseif c.y + c.height > s.geometry.height then
		a.y = 4
	elseif dy < (c.height - s.geometry.height + margin_top) / 3 then
		a.y = 1
	elseif dy > (s.geometry.height - c.height - margin_top) / 3 then
		a.y = 3
	else
		a.y = 2
	end
	if direct == "left" then
		a.x = a.x - 1
	elseif direct == "right" then
		a.x = a.x + 1
	elseif direct == "up" then
		a.y = a.y - 1
	elseif direct == "down" then
		a.y = a.y + 1
	end
	if a.x < 1 then a.x = 1 end
	if a.x > 3 then a.x = 3 end
	if a.y < 1 then a.y = 1 end
	if a.y > 3 then a.y = 3 end
	return a
end


function client_move(c, direct)
	local s = awful.screen.focused() 
	local a = anchor_get(c, direct)
	if s.topbar.visible then
		anchor_set[a.x][a.y](c, theme.topbar_height)
	else
		anchor_set[a.x][a.y](c, 0)
	end
end


function client_resize(c, m, t)
	local s = awful.screen.focused() 
	local d = dpi(50)
	if s.topbar.visible then
		margin_top = theme.topbar_height
	else
		margin_top = 0
	end
	if t == "width" then
		w = d
		h = 0
	elseif t == "height" then
		w = 0
		h = d
	else
		w = d
		h = math.floor(d * (c.height / c.width) + 0.5)
	end
	if m == "dec" then
		w = 0 - w
		h = 0 - h
	end
	if c.width + theme.border_width * 2 >= s.geometry.width then
		ax = 2
	elseif c.x <= 0 then
		ax = 1
	elseif c.x + c.width + theme.border_width * 2 >= s.geometry.width then
		ax = 3
	elseif c.y + c.height + theme.border_width * 2 >= s.geometry.height then 
		ax = 2
	elseif c.y <= margin_top then
		ax = 2
	else
		ax = 0
	end
	if c.height + theme.border_width *  2 >= s.geometry.height - margin_top then
		ay = 2
	elseif c.y <= margin_top then
		ay = 1
	elseif c.y + c.height + theme.border_width * 2 >= s.geometry.height then 
		ay = 3
	elseif c.x + c.width + theme.border_width * 2 >= s.geometry.width then
		ay = 2
	elseif c.x <= 0 then
		ay = 2
	else
		ay = 0
	end
	c.oldw = c.width
	c.oldh = c.height
	if c.width + w + theme.border_width * 2 > s.geometry.width then
		c.width = s.geometry.width - theme.border_width * 2
	else
		c.width = c.width + w
	end
	if c.height + h + theme.border_width * 2 > s.geometry.height - margin_top then
		c.height = s.geometry.height - margin_top - theme.border_width * 2
	else
		c.height = c.height + h
	end
	w = c.width - c.oldw
	h = c.height - c.oldh
	if ax == 0 or ay == 0 then
		dx = math.floor(c.x - w / 2 + 0.5)
		dy = math.floor(c.y - h / 2 + 0.5)
		if dx <= 0 then
			c.x = 0
		else
			c.x = dx
		end
		if dy <= margin_top then
			c.y = margin_top
		else
			c.y = dy
		end
	else
		anchor_set[ax][ay](c, margin_top)
	end
end

function client_setwfact(c, m, t)
	local s = awful.screen.focused()
	if m == "inc" then
		d = 1
	elseif m == "dec" then
		d = -1
	end
	if t == "height" then
		f = (math.floor(math.floor(100 * c.height / s.tiling_area.height) / 5 + 0.5) + d) * 5
	elseif t == "width" then
		f = (math.floor(math.floor(100 * c.width / s.tiling_area.width) / 5 + 0.5) + d) * 5
	end
	if f < 10 then
		f = 10
	elseif f > 90 then
		f = 90
	end
	awful.client.setwfact(f/100)
end

----------------------------------------------------------------------------------------------
----------------------------------- Key bindings ---------------------------------------------
----------------------------------------------------------------------------------------------
globalkeys = gears.table.join(
	awful.key({                   }, "XF86AudioRaiseVolume" , function() volume:up() end),
	awful.key({                   }, "XF86AudioLowerVolume" , function() volume:down() end),
	awful.key({                   }, "XF86AudioMute"        , function() volume:toggle() end),
	--awful.key({                   }, "XF86MonBrightnessUp"  , function() battery.brightness_up() end),
	--awful.key({                   }, "XF86MonBrightnessDown", function() battery.brightness_down() end),
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
	--awful.key({                   }, "F1"    , function() awful.screen.focused().quake:toggle() end),
	--awful.key({                   }, "F2"    , function() awful.screen.focused().quake:toggle() end),
	awful.key({ modkey,           }, "z"     , function() awful.screen.focused().quake:toggle() end)
)

clientkeys = gears.table.join(
	--awful.key({         "Shift"   }, "XF86AudioRaiseVolume" , function(c) awful.spawn.with_shell("sleep 0.1; xdotool key --window " .. tostring(c.window) .. "--clearmodifiers Insert") end),
    awful.key({ modkey,           }, "f"     , function(c) c.fullscreen = not c.fullscreen c:raise() end),
    awful.key({ modkey, "Shift"   }, "c"     , function(c) c:kill() end),
    awful.key({ modkey, "Control" }, "space" , function(c) awful.client.floating.toggle(c) end),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "s"     , function(c) c.sticky = not c.sticky focus:update(c, true) end),
    awful.key({ modkey,           }, "t"     , function(c) c.ontop = not c.ontop focus:update(c, true) end),
    awful.key({ modkey,           }, "m"     , function(c) c.maximized = not c.maximized c:raise() focus:update(c, true)  end),
    awful.key({ modkey,           }, "n"     , function(c) c.minimized = true end),
    awful.key({ modkey,           }, "h"     , function(c) awful.client.focus.bydirection("left", client.focus) end),
    awful.key({ modkey,           }, "l"     , function(c) awful.client.focus.bydirection("right", client.focus) end),
	awful.key({ modkey,           }, "j"     , function(c) awful.client.focus.bydirection("down", client.focus) end),
    awful.key({ modkey,           }, "k"     , function(c) awful.client.focus.bydirection("up", client.focus) end),
    awful.key({ modkey,           }, "`"     , function(c) if focus.top_lv.visible then awful.titlebar.toggle(c) end focus:update(c, true) end),
    awful.key({ modkey,           }, "c"     , function(c) 
		local s = awful.screen.focused() 
		if s.topbar.visible then
			margin_top = theme.topbar_height + theme.topbar_border_width
		else
			margin_top = 0
		end
		awful.placement.centered(c, {margins = {top = margin_top}}) 
	end),

    awful.key({ modkey,           }, "="     , function(c) 
		if c.fullscreen or c.maximized then return end
		local s = awful.screen.focused() 
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_resize(c, "inc", "width_height")
		elseif layout == awful.layout.suit.tile or layout == awful.layout.suit.tile.left then
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "inc", "height")
			else
				awful.tag.incmwfact(0.05)
			end
		else
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "inc", "width")
			else
				awful.tag.incmwfact(0.05)
			end
		end
	end),

    awful.key({ modkey,           }, "-"     , function(c) 
		if c.fullscreen or c.maximized then return end
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_resize(c, "dec", "width_height")
		elseif layout == awful.layout.suit.tile or layout == awful.layout.suit.tile.left then
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "dec", "height")
			else
				awful.tag.incmwfact(-0.05)
			end
		else
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "dec", "width")
			else
				awful.tag.incmwfact(-0.05)
			end
		end
	end),

    awful.key({ modkey, "Shift"   }, "="     , function(c) 
		if c.fullscreen or c.maximized then return end
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_resize(c, "inc", "width")
		elseif layout ~= awful.layout.suit.tile and layout ~= awful.layout.suit.tile.left then
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "inc", "width")
			end
		elseif c == awful.client.getmaster() then
			awful.tag.incmwfact(0.05)
		else
			awful.tag.incmwfact(-0.05)
		end
	end),
    awful.key({ modkey, "Shift"   }, "-"     , function(c) 
		if c.fullscreen or c.maximized then return end
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_resize(c, "dec", "width")
		elseif layout ~= awful.layout.suit.tile and layout ~= awful.layout.suit.tile.left then
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "dec", "width")
			end
		elseif c == awful.client.getmaster() then
			awful.tag.incmwfact(-0.05)
		else
			awful.tag.incmwfact(0.05)
		end
	end),
    awful.key({ modkey, "Control" }, "="     , function(c) 
		if c.fullscreen or c.maximized then return end
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_resize(c, "inc", "height")
		elseif layout == awful.layout.suit.tile or layout == awful.layout.suit.tile.left then
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "inc", "height")
			end
		elseif c == awful.client.getmaster() then
			awful.tag.incmwfact(0.05)
		else
			awful.tag.incmwfact(-0.05)
		end
	end),
    awful.key({ modkey, "Control" }, "-"     , function(c) 
		if c.fullscreen or c.maximized then return end
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_resize(c, "dec", "height")
		elseif layout == awful.layout.suit.tile or layout == awful.layout.suit.tile.left then
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "dec", "height")
			end
		elseif c == awful.client.getmaster() then
			awful.tag.incmwfact(-0.05)
		else
			awful.tag.incmwfact(0.05)
		end
	end),

    awful.key({ modkey, "Shift"   }, "h"     , function(c)
		if c.fullscreen or c.maximized then return end
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		local m = awful.client.getmaster()
		if c.floating or layout == awful.layout.suit.floating then
			client_move(c, "left")
		else
			awful.client.swap.bydirection("left")
		end
	end),
    awful.key({ modkey, "Shift"   }, "l"     , function(c)
		if c.fullscreen or c.maximized then return end
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		local m = awful.client.getmaster()
		if c.floating or layout == awful.layout.suit.floating then
			client_move(c, "right")
		else
			awful.client.swap.bydirection("right")
		end
	end),
    awful.key({ modkey, "Shift"   }, "j"     , function(c)
		if c.fullscreen or c.maximized then return end
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_move(c, "down")
		else
			awful.client.swap.bydirection("down")
		end
	end),
    awful.key({ modkey, "Shift"   }, "k"     , function(c)
		if c.fullscreen or c.maximized then return end
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_move(c, "up")
		else
			awful.client.swap.bydirection("up")
		end
	end)
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
	awful.button({ modkey }, 4, function(c)
		if c.fullscreen or c.maximized then return end
        c:emit_signal("request::activate", "mouse_click", {raise = true})
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_resize(c, "inc", "width_height")
		elseif layout == awful.layout.suit.tile or layout == awful.layout.suit.tile.left then
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "inc", "height")
			else
				awful.tag.incmwfact(0.05)
			end
		else
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "inc", "width")
			else
				awful.tag.incmwfact(0.05)
			end
		end
	end),
	awful.button({ modkey }, 5, function(c)
		if c.fullscreen or c.maximized then return end
        c:emit_signal("request::activate", "mouse_click", {raise = true})
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_resize(c, "dec", "width_height")
		elseif layout == awful.layout.suit.tile or layout == awful.layout.suit.tile.left then
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "dec", "height")
			else
				awful.tag.incmwfact(-0.05)
			end
		else
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "dec", "width")
			else
				awful.tag.incmwfact(-0.05)
			end
		end
	end),
    awful.button({ modkey, "Shift"   }, 4, function(c) 
		if c.fullscreen or c.maximized then return end
        c:emit_signal("request::activate", "mouse_click", {raise = true})
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_resize(c, "inc", "width")
		elseif layout ~= awful.layout.suit.tile and layout ~= awful.layout.suit.tile.left then
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "inc", "width")
			end
		elseif c == awful.client.getmaster() then
			awful.tag.incmwfact(0.05)
		else
			awful.tag.incmwfact(-0.05)
		end
	end),
    awful.button({ modkey, "Shift"   }, 5, function(c) 
		if c.fullscreen or c.maximized then return end
        c:emit_signal("request::activate", "mouse_click", {raise = true})
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_resize(c, "dec", "width")
		elseif layout ~= awful.layout.suit.tile and layout ~= awful.layout.suit.tile.left then
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "dec", "width")
			end
		elseif c == awful.client.getmaster() then
			awful.tag.incmwfact(-0.05)
		else
			awful.tag.incmwfact(0.05)
		end
	end),
    awful.button({ modkey, "Control" }, 4, function(c) 
		if c.fullscreen or c.maximized then return end
        c:emit_signal("request::activate", "mouse_click", {raise = true})
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_resize(c, "inc", "height")
		elseif layout == awful.layout.suit.tile or layout == awful.layout.suit.tile.left then
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "inc", "height")
			end
		elseif c == awful.client.getmaster() then
			awful.tag.incmwfact(0.05)
		else
			awful.tag.incmwfact(-0.05)
		end
	end),
    awful.button({ modkey, "Control" }, 5, function(c) 
		if c.fullscreen or c.maximized then return end
        c:emit_signal("request::activate", "mouse_click", {raise = true})
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			client_resize(c, "dec", "height")
		elseif layout == awful.layout.suit.tile or layout == awful.layout.suit.tile.left then
			if c ~= awful.client.getmaster() then
				client_setwfact(c, "dec", "height")
			end
		elseif c == awful.client.getmaster() then
			awful.tag.incmwfact(-0.05)
		else
			awful.tag.incmwfact(0.05)
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
			floating     = true,
			titlebars_enabled = true,
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
			type   = { "dialog" }
    	},
		properties = { 
			titlebars_enabled = true,
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
			sticky = true
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
	titlebar:setup(c)
end)

client.connect_signal("property::size", function(c) 
	--print("size")
	if c.pid == current_focus then
		focus:update(c, true)
	end
end)

client.connect_signal("property::position", function(c) 
	--print("position")
	if c.y == theme.topbar_height + theme.topbar_border_width then
		c.y = theme.topbar_height
		if c.maximized then
			c.height = c.height + theme.topbar_border_width
		end
		
	end
	if c.pid == current_focus then
		focus:update(c, true)
	end
end)

client.connect_signal("unfocus", function(c) 
	--print("unfocus ")
	if #awful.screen.focused().clients <= 1 then
		focus:update(c, false)
	end
	c.border_color = beautiful.border_normal
end)

client.connect_signal("focus", function(c) 
	--print("focus")
	current_focus = c.pid
	if #awful.screen.focused().clients > 1 then
		c.border_color = theme.border_focus
		focus:update(c, true)
	else
		c.border_color = theme.border_normal
		focus:update(c, false)
	end
	c.border_width = beautiful.border_width
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
	s.quake = quake({
		app = "alacritty",
		argname = "--title %s",
		extra = "--class QuakeDD -e tmux-attach.sh",
		vert = "top",
		horiz = "center",
		visible = true,
		height = 0.388,
		width = 0.510,
		screen = s
	})
end)
