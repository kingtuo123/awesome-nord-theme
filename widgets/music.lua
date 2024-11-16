local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local mpc   = require("libs.mpc")
local dpi	= require("beautiful.xresources").apply_dpi


local music = {}
music.status = {}
music.currentsong = {}


local music_dir = os.getenv("HOME") .. "/Music/"
local cache_dir = "/tmp/mpc/"
local cmd_get_cover = function(file) return "mkdir -p " .. cache_dir ..  "&& ffmpeg -y -loglevel quiet -i " .. music_dir .. file .. " -c:v copy " .. cache_dir .. file .. ".jpg && echo -n ok" end
local cmd_blur_cover = function(file) return "magick " .. cache_dir .. file .. ".jpg -resize 30x30 -gravity center -extent 25x8 -blur 0x8 " .. cache_dir .. file .. ".blur.jpg && echo -n ok" end

local last_id
local last_state


local connection
local function error_handler(err)
    mpd_widget:set_text("Error: " .. tostring(err))
    timer.start_new(10, function()
        connection:send("ping")
    end)
end
connection = mpc.new("localhost", 6600, nil, error_handler,
    "status", function(_, result)
		music.status = result
		if last_state ~= music.status.state then
			last_state = music.status.state
			music:set_icon()
		end
		--for i,v in pairs(result) do
		--	print(i .. " = " .. v)
		--end
    end,
    "currentsong", function(_, result)
		music.currentsong = result
		if last_id ~= music.currentsong.id then
			last_id = music.currentsong.id
			music:set_title()
			music:set_cover()
			music:notify()
		end
		--for i,v in pairs(result) do
		--	print(i .. " = " .. v)
		--end
    end
)




music.widget = wibox.widget{
	{
		{
			{
				id = "icon",
				image = theme.music_icon,
				forced_height = dpi(17),
				forced_width = dpi(17),
				widget = wibox.widget.imagebox,
			},
			valign = "center",
			halign = "center",
			widget = wibox.container.place,
		},
		id      = "margin",
		widget	= wibox.container.margin
	},
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
	end,
	shape_border_width = theme.widget_border_width,
	shape_border_color = theme.widget_border_color,
	bg = theme.widget_bg,
	widget = wibox.container.background,
}


music.popup = awful.popup{
	widget = wibox.widget{
		{
			{
				id = "blur",
				image = theme.music_cover_image,
				scaling_quality = "good",
				resize = true,
				upscale = true,
				vertical_fit_policy = "fit",
				horizontal_fit_policy = "fit",
				opacity = theme.music_bg_opacity,
				widget = wibox.widget.imagebox,
			},
			top = dpi(-5),
			left = dpi(-5),
			right = dpi(-5),
			bottom = dpi(-5),
			forced_width = theme.music_popup_width,
			forced_height = theme.music_popup_height,
			widget	= wibox.container.margin
		},
		{
			{
				{
					{
						{
							id = "cover",
							image = theme.music_cover_image,
							resize = true,
							upscale = true,
							vertical_fit_policy = "fit",
							horizontal_fit_policy = "fit",
							widget = wibox.widget.imagebox,
							clip_shape = function(cr, width, height)
								gears.shape.rounded_rect(cr, width, height, theme.music_cover_round)
							end,
						},
						valign = "center",
						halign = "center",
						widget = wibox.container.place,
					},
					top = theme.music_cover_margin,
					left = theme.music_cover_margin,
					right = dpi(0),
					bottom = theme.music_cover_margin,
					forced_width = theme.music_popup_height - theme.music_popup_margin * 2,
					forced_height = theme.music_popup_height - theme.music_popup_margin * 2,
					widget	= wibox.container.margin
				},
				{
					wibox.container.margin(_,_,_,dpi(10)),
					{
						{
							{
								{
									id = "title",
									text = "--",
									valign = "center",
									halign = "left",
									opacity = theme.music_title_opacity,
									wrap = "char",
									ellipsize = "end",
									font = theme.music_title_font,
									forced_width = theme.music_popup_width - theme.music_popup_height - dpi(20),
									widget = wibox.widget.textbox,
								},
								wibox.container.margin(_,_,_,dpi(0)),
								{
									id = "artist",
									text = "--",
									valign = "center",
									halign = "left",
									opacity = theme.music_artist_opacity,
									wrap = "char",
									ellipsize = "end",
									font = theme.music_artist_font,
									widget = wibox.widget.textbox,
								},
								layout = wibox.layout.fixed.vertical,
							},
							left = dpi(12),
							widget	= wibox.container.margin
						},
						nil,
						{
							{
								{
									id = "mode",
									--image  = theme.music_random_icon,
									--image  = theme.music_repeat_icon,
									image  = theme.music_single_icon,
									forced_width = dpi(15),
									forced_height = dpi(15),
									opacity = theme.music_icon_opacity,
									widget = wibox.widget.imagebox,
								},
								valign = "top",
								halign = "center",
								widget = wibox.container.place,
							},
							top = dpi(2),
							right = dpi(12),
							widget = wibox.container.margin,
						},
						layout = wibox.layout.align.horizontal,
					},
					wibox.container.margin(_,_,_,dpi(7)),
					{
						{
							{
								id = "prev",
								image  = theme.music_prev_icon,
								forced_width = dpi(20),
								forced_height = dpi(20),
								opacity = theme.music_icon_opacity,
								widget = wibox.widget.imagebox,
							},
							valign = "center",
							halign = "center",
							widget = wibox.container.place,
						},
						{
							{
								id = "play",
								image  = theme.music_play_icon,
								forced_width = dpi(20),
								forced_height = dpi(20),
								opacity = theme.music_icon_opacity,
								widget = wibox.widget.imagebox,
							},
							valign = "center",
							halign = "center",
							widget = wibox.container.place,
						},
						{
							{
								id = "next",
								image  = theme.music_next_icon,
								forced_width = dpi(20),
								forced_height = dpi(20),
								opacity = theme.music_icon_opacity,
								widget = wibox.widget.imagebox,
							},
							valign = "center",
							halign = "center",
							widget = wibox.container.place,
						},
						forced_width = theme.music_popup_width - theme.music_popup_height,
						forced_height = dpi(20),
						layout = wibox.layout.flex.horizontal,
					},
					layout = wibox.layout.fixed.vertical,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			top = theme.music_popup_margin,
			bottom = theme.music_popup_margin,
			left = theme.music_popup_margin,
			right = theme.music_popup_margin,
			widget = wibox.container.margin,
		},
		layout = wibox.layout.stack,
	},
	--border_color	= theme.popup_border_color,
    --border_width	= theme.popup_border_width,
	visible			= false,
	bg				= theme.popup_bg,
	fg				= "#ffffff",
	ontop			= true,
	--shape			= function(cr, width, height)
	--	gears.shape.rounded_rect(cr, width, height, theme.popup_rounded)
	--end
}

function music:notify()
	
	if self.status.state == "play" and (not self.popup.visible or self.notify_timer.started) then
		local s = awful.screen.focused()
		self.popup.x = (s.geometry.width - theme.music_popup_width)/2 - theme.useless_gap * 2
		self.popup.y = theme.popup_margin_top
		self.popup.visible = true
		self.notify_timer:again()
	end
end


function music:set_cover()
	--print(cmd_get_cover(music.currentsong.file))
	awful.spawn.easy_async_with_shell(cmd_get_cover(string.gsub(music.currentsong.file, " ","\\ ")), function(out)
		if out == "ok\n" then
			music.popup.widget:get_children_by_id("cover")[1].image = cache_dir .. music.currentsong.file .. ".jpg"
			awful.spawn.easy_async_with_shell(cmd_blur_cover(string.gsub(music.currentsong.file, " ","\\ ")), function(out)
				if out == "ok\n" then
					local blur = music.popup.widget:get_children_by_id("blur")[1]
					blur.opacity = theme.music_bg_opacity
					blur.image = cache_dir .. music.currentsong.file .. ".blur.jpg"
				end
			end)
		else
			music.popup.widget:get_children_by_id("blur")[1].opacity = 0
			music.popup.widget:get_children_by_id("cover")[1].image = theme.music_cover_image
		end
	end)
end


function music:set_title()
	self.popup.widget:get_children_by_id("title")[1].text = self.currentsong.title or "unknow"
	self.popup.widget:get_children_by_id("artist")[1].text = self.currentsong.artist or "unknow"
end


function music:set_icon()
	if self.status.state == "play" then
		self.popup.widget:get_children_by_id("play")[1].image = theme.music_pause_icon
		self.widget:get_children_by_id("icon")[1].opacity = 1
	else
		self.popup.widget:get_children_by_id("play")[1].image = theme.music_play_icon
		self.widget:get_children_by_id("icon")[1].opacity = 0.8
	end
	local mode_button =	self.popup.widget:get_children_by_id("mode")[1]
	if tonumber(self.status.consume) == 1 then
		awful.spawn.with_shell("mpc consume off &> /dev/null&")
	end
	if tonumber(self.status.single) == 1 then
		mode_button.image = theme.music_single_icon
	elseif tonumber(self.status.random) == 1 then
		mode_button.image = theme.music_random_icon
	else
		mode_button.image = theme.music_repeat_icon
	end
end


function music:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	local function popup_move()	
		local m = mouse.coords()
		self.popup.x = m.x - self.popup_offset.x
		self.popup.y = m.y - self.popup_offset.y
		mousegrabber.stop()
	end

	self.popup:buttons(gears.table.join(
		awful.button({ }, 1, function()
			self.popup:connect_signal('mouse::move',popup_move)
			local m = mouse.coords()
			self.popup_offset = {
				x = m.x - self.popup.x,
				y = m.y - self.popup.y
			}
			self.popup:emit_signal('mouse::move', popup_move)
		end,function()
			self.popup:disconnect_signal ('mouse::move',popup_move)
		end),
		awful.button({ }, 3, function ()
			self.popup:disconnect_signal ('mouse::move',popup_move)
			self.popup.visible = false
			self.widget.bg = theme.widget_bg
			self.widget.shape_border_color = theme.widget_border_color
		end)
	))

	self.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			if self.popup.visible then
				self.popup.visible = false
				self.widget.bg = theme.widget_bg_press
			else
				self.popup.x = mouse.coords().x - theme.music_popup_width / 2 - theme.useless_gap * 4
				self.popup.y = theme.popup_margin_top
				self.popup.visible = true
				self.widget.bg = theme.widget_bg_hover
			end
			self.widget.shape_border_color = theme.widget_border_color
		end),
		awful.button({}, 3, nil, function()
			if self.status.state ~= "stop" then
				awful.spawn.with_shell("mpc toggle &> /dev/null&")
			end
		end),
		awful.button({}, 4, nil, function()
			if self.status.state ~= "stop" then
				awful.spawn.with_shell("mpc seek +5% &> /dev/null&")
			end
		end),
		awful.button({}, 5, nil, function()
			if self.status.state ~= "stop" then
				awful.spawn.with_shell("mpc seek -5% &> /dev/null&")
			end
		end),
		awful.button({}, 8, nil, function()
			if self.status.state ~= "stop" then
				awful.spawn.with_shell("mpc prev &> /dev/null&")
			end
		end),
		awful.button({}, 9, nil, function()
			if self.status.state ~= "stop" then
				awful.spawn.with_shell("mpc next &> /dev/null&")
			end
		end)
	))

	self.widget:connect_signal('mouse::enter',function() 
		if self.popup.visible then
			self.widget.bg = theme.widget_bg_press
		else
			self.widget.bg = theme.widget_bg_hover
		end
		self.widget.shape_border_color = theme.widget_border_color
	end)

	self.widget:connect_signal('mouse::leave',function() 
		if self.popup.visible then
			self.widget.bg = theme.widget_bg_press
			self.widget.shape_border_color = theme.widget_border_color
		else
			self.widget.bg = theme.widget_bg
			self.widget.shape_border_color = theme.widget_border_color
		end
	end)

	self.popup:connect_signal('mouse::enter',function() 
		self.notify_timer:stop()
	end)



	local prev_button =	self.popup.widget:get_children_by_id("prev")[1]
	prev_button:buttons(gears.table.join(
		awful.button({}, 1, nil, function()
			if self.status.state ~= "stop" then
				awful.spawn.with_shell("mpc prev &> /dev/null&")
			end
		end)
	))

	local play_button =	self.popup.widget:get_children_by_id("play")[1]
	play_button:buttons(gears.table.join(
		awful.button({}, 1, nil, function()
			if self.status.state ~= "stop" then
				awful.spawn.with_shell("mpc toggle &> /dev/null&")
			end
		end)
	))

	local next_button =	self.popup.widget:get_children_by_id("next")[1]
	next_button:buttons(gears.table.join(
		awful.button({}, 1, nil, function()
			if self.status.state ~= "stop" then
				awful.spawn.with_shell("mpc next &> /dev/null&")
			end
		end)
	))

	local mode_button =	self.popup.widget:get_children_by_id("mode")[1]
	mode_button:buttons(gears.table.join(
		awful.button({}, 1, nil, function()
			if self.status.state ~= "stop" then
				if tonumber(self.status.single) == 1 then
					awful.spawn.with_shell("mpc single off &> /dev/null && mpc random on &> /dev/null&")
					mode_button.image = theme.music_random_icon
				elseif tonumber(self.status.random) == 1 then
					awful.spawn.with_shell("mpc random off &> /dev/null && mpc repeat on &> /dev/null&")
					mode_button.image = theme.music_repeat_icon
				else
					awful.spawn.with_shell("mpc single on &> /dev/null&")
					mode_button.image = theme.music_single_icon
				end
			end
		end)
	))

	self.notify_timer = gears.timer({
		timeout   = theme.music_notify_timeout,
		call_now  = false,
		autostart = false,
		single_shot = true,
		callback  = function()
			self.popup.visible = false
		end
	})

	return wibox.widget{
		self.widget,
		left = 0-theme.widget_border_width,
		widget = wibox.container.margin
	}
end


return music
