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
local titlebar = require("widgets.titlebar")
local focus    = require("widgets.focus")





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
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
		awful.layout.suit.max,
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


local anchor_point = {}
anchor_point[1] = {}
anchor_point[1][1] = function(c) awful.placement.top_left(c, {margins = {top = theme.topbar_height}}) end
anchor_point[1][2] = function(c) awful.placement.left(c, {margins = {top = theme.topbar_height}}) end
anchor_point[1][3] = awful.placement.bottom_left
anchor_point[2] = {}
anchor_point[2][1] = function(c) awful.placement.top(c, {margins = {top = theme.topbar_height}}) end
anchor_point[2][2] = function(c) awful.placement.centered(c, {margins = {top = theme.topbar_height}}) end
anchor_point[2][3] = awful.placement.bottom
anchor_point[3] = {}
anchor_point[3][1] = function(c) awful.placement.top_right(c, {margins = {top = theme.topbar_height}}) end
anchor_point[3][2] = function(c) awful.placement.right(c, {margins = {top = theme.topbar_height}}) end
anchor_point[3][3] = awful.placement.bottom_right


function anchor_move(c, direct)
	local s = awful.screen.focused()
	local dx = c.x - (s.geometry.width - (c.x + c.width + theme.border_width * 2))
	local dy = (c.y - theme.topbar_height) - (s.geometry.height - (c.y + c.height + theme.border_width * 2))
	if c.x < 0 then
		cx = 0
	elseif c.x + c.width > s.geometry.width then
		cx = 4
	elseif dx < (c.width - s.geometry.width) / 3 then
		cx = 1
	elseif dx > (s.geometry.width - c.width) / 3 then
		cx = 3
	else
		cx = 2
	end
	if c.y < theme.topbar_height then
		cy = 0
	elseif c.y + c.height > s.geometry.height then
		cy = 4
	elseif dy < (c.height - s.geometry.height + theme.topbar_height) / 3 then
		cy = 1
	elseif dy > (s.geometry.height - c.height - theme.topbar_height) / 3 then
		cy = 3
	else
		cy = 2
	end
	if direct == "left" then
		cx = cx - 1
	elseif direct == "right" then
		cx = cx + 1
	elseif direct == "up" then
		cy = cy - 1
	elseif direct == "down" then
		cy = cy + 1
	end
	if cx < 1 then cx = 1 end
	if cx > 3 then cx = 3 end
	if cy < 1 then cy = 1 end
	if cy > 3 then cy = 3 end
	anchor_point[cx][cy](c)
end


function client_resize(c, m, t)
	local s = awful.screen.focused() 
	local d = dpi(50)
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
		cx = 2
	elseif c.x <= 0 then
		cx = 1
	elseif c.x + c.width + theme.border_width * 2 >= s.geometry.width then
		cx = 3
	elseif c.y + c.height + theme.border_width * 2 >= s.geometry.height then 
		cx = 2
	elseif c.y <= theme.topbar_height then
		cx = 2
	else
		cx = 0
	end
	if c.height + theme.border_width *  2 >= s.geometry.height - theme.topbar_height then
		cy = 2
	elseif c.y <= theme.topbar_height then
		cy = 1
	elseif c.y + c.height + theme.border_width * 2 >= s.geometry.height then 
		cy = 3
	elseif c.x + c.width + theme.border_width * 2 >= s.geometry.width then
		cy = 2
	elseif c.x <= 0 then
		cy = 2
	else
		cy = 0
	end
	print(c.x .. " , " .. c.y)
	print("cx = " .. cx .. ", cy = " .. cy)
	if c.width + w + theme.border_width * 2 > s.geometry.width then
		c.width = s.geometry.width - theme.border_width * 2
	else
		c.width = c.width + w
	end
	if c.height + h + theme.border_width * 2 > s.geometry.height - theme.topbar_height then
		c.height = s.geometry.height - theme.topbar_height - theme.border_width * 2
	else
		c.height = c.height + h
	end
	if cx == 0 or cy == 0 then
		dx = math.floor(c.x - w / 2 + 0.5)
		dy = math.floor(c.y - h / 2 + 0.5)
		if dx <= 0 then
			c.x = 0
		else
			c.x = dx
		end
		if dy <= theme.topbar_height then
			c.y = theme.topbar_height
		else
			c.y = dy
		end
	else
		anchor_point[cx][cy](c)
	end
end

function client_setwfact(c, m, t)
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
	awful.key({                   }, "XF86AudioRaiseVolume" , function() volume.up() end),
	awful.key({                   }, "XF86AudioLowerVolume" , function() volume.down() end),
	awful.key({                   }, "XF86AudioMute"        , function() volume.toggle() end),
	awful.key({                   }, "XF86MonBrightnessUp"  , function() battery.brightness_up() end),
	awful.key({                   }, "XF86MonBrightnessDown", function() battery.brightness_down() end),
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
    awful.key({ modkey, "Control" }, "n"     , function() local c = awful.client.restore() if c then c:emit_signal( "request::activate", "key.unminimize", {raise = true}) end end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f"     , function(c) c.fullscreen = not c.fullscreen c:raise() end),
    awful.key({ modkey, "Shift"   }, "c"     , function(c) c:kill() end),
    awful.key({ modkey, "Control" }, "space" , function(c) awful.client.floating.toggle(c) end),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "s"     , function(c) c.sticky = not c.sticky focus.setup(c) end),
    awful.key({ modkey,           }, "t"     , function(c) c.ontop = not c.ontop focus.setup(c) end),
    awful.key({ modkey,           }, "m"     , function(c) c.maximized = not c.maximized c:raise() end),
    awful.key({ modkey,           }, "n"     , function(c) c.minimized = true end),
    awful.key({ modkey,           }, "h"     , function(c) awful.client.focus.bydirection("left", client.focus) end),
    awful.key({ modkey,           }, "l"     , function(c) awful.client.focus.bydirection("right", client.focus) end),
    awful.key({ modkey,           }, "j"     , function(c) awful.client.focus.byidx(1) end),
    awful.key({ modkey,           }, "k"     , function(c) awful.client.focus.byidx(-1) end),
    awful.key({ modkey,           }, "`"     , function(c) if focus.top_lv.visible then awful.titlebar.toggle(c) end focus.setup(c) end),
    awful.key({ modkey,           }, "c"     , function(c) awful.placement.centered(c, {margins = {top = theme.topbar_height}}) end),

    awful.key({ modkey,           }, "="     , function(c) 
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
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			anchor_move(c, "left")
		end
	end),
    awful.key({ modkey, "Shift"   }, "l"     , function(c)
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			anchor_move(c, "right")
		end
	end),
    awful.key({ modkey, "Shift"   }, "j"     , function(c)
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			anchor_move(c, "down")
		else
			awful.client.swap.byidx( 1)
		end
	end),
    awful.key({ modkey, "Shift"   }, "k"     , function(c)
		local s = awful.screen.focused()
		local layout = awful.layout.get(s)
		if c.floating or layout == awful.layout.suit.floating then
			anchor_move(c, "up")
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
		end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
		function ()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
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
			floating     = false,
			titlebars_enabled = false,
			size_hints_honor = true
		}
    },
    ----------------------------------
    { 
		rule_any = {
			class = {"lxappearance", "Lxappearance"},
			type = { "dialog" }
		}, 
		properties = {
			titlebars_enabled = true,
			ontop = true,
			floating = true
		}
    },
    ----------------------------------
    { 
		rule_any = {
			name = {"Picture-in-Picture", "Picture in picture"}
		}, 
		properties = {
			titlebars_enabled = true,
			ontop = true,
			floating = true,
			sticky = true
		}
    },
    ----------------------------------
    { 
		rule_any = {
			class  = { "flameshot", "mpv", "feh"},
			name   = { "floating-terminal"},
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
screen.connect_signal("request::desktop_decoration", function(s)
	topbar.setup(s) 
end)
