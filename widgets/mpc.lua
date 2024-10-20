local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi
local mpd   = require("libs.mpc")




local mpc = {}




local playlist_row_num = 15
local lastsong = ""
local lastelapsed = 999
local laststate = ""
local connection
local function error_handler(err)
    mpd_widget:set_text("Error: " .. tostring(err))
    timer.start_new(10, function()
        connection:send("ping")
    end)
end
connection = mpd.new("localhost", 6600, nil, error_handler,
    "status", function(_, result)
		mpc.status = result
		local m = mpc.popup.widget:get_children_by_id("cv_margin")[1]
		if mpc.status.state ~= "play" then
			mpc.popup.widget:get_children_by_id("pause_icon")[1].visible = false
			mpc.popup.widget:get_children_by_id("play_icon")[1].visible = true
			m.top = dpi(40)
			m.left = dpi(40)
			m.right = dpi(40)
			m.bottom = dpi(25)
		else
			mpc.popup.widget:get_children_by_id("pause_icon")[1].visible = true
			mpc.popup.widget:get_children_by_id("play_icon")[1].visible = false
			m.top = dpi(15)
			m.left = dpi(15)
			m.right = dpi(15)
			m.bottom = dpi(0)
		end
		if lastelapsed ~= result.elapsed then
			lastelapsed = result.elapsed
			if mpc.popup.visible then
				--mpc:update_time()
				mpc.elapsed_timer:again()
			end
		end
		--for i,v in pairs(result) do
		--	print(i .. " = " .. v)
		--end
    end,
    "currentsong", function(_, result)
		if lastsong ~= result.id then
			lastsong = result.id
			mpc.currentsong = result
			mpc:update_song()
			mpc.elapsed_timer:again()
			mpc:update_time()
			if mpc.playlist ~= nil then
				mpc:set_playlist(playlist_mid)
			end
		end
    end)

-- ffmpeg -y -loglevel quiet -i ~/Music/see\ you\ again.wav -c:v copy test.png
-- magick test.png -resize 30x30 -gravity center -extent 15x20 -blur 0x8 blur.jpg

-- ffmpeg -y -loglevel quiet -i ~/Music/拯救.wav test.jpg
-- magick test.jpg -resize 30x30 -gravity center -extent 15x25 -blur 0x8 blur.jpg

-- mpc playlist | awk -F ' - ' '{print $2}' | sed -n 1,3p




local cache_dir = "/tmp/mpc/"
local music_dir = "~/Music/"
local cmd_get_cover = function(file) return "mkdir -p " .. cache_dir ..  "&& ffmpeg -y -loglevel quiet -i " .. music_dir .. file .. " -c:v copy " .. cache_dir .. file .. ".jpg && echo -n ok" end
--local cmd_blur_cover = function(file) return "magick " .. cache_dir .. file .. ".jpg -resize 20x20 -gravity center -extent 12x20 -blur 0x8 " .. cache_dir .. file .. ".blur.jpg && echo -n ok" end
local cmd_blur_cover = function(file) return "magick " .. cache_dir .. file .. ".jpg -resize 30x30 -gravity center -extent 25x21 -blur 0x8 " .. cache_dir .. file .. ".blur.jpg && echo -n ok" end
local cmd_get_time = "mpc | grep '#'"
local cmd_seek = function(percent) return "mpc seek " .. percent .. "%" end
local cmd_pause = "mpc pause"
local cmd_play = "mpc play"
local cmd_next = "mpc next"
local cmd_prev = "mpc prev"





mpc.widget = wibox.widget{
	{
		{
			id			= "icon",
			image		= theme.mpc_off_icon,
			widget		= wibox.widget.imagebox,
		},
		id      = "margin",
		widget	= wibox.container.margin
	},
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
	end,
	shape_border_width = theme.widget_border_width,
	shape_border_color = "",
	widget = wibox.container.background,
}


local main_width = dpi(235)
local main_height = dpi(400)

mpc.popup = awful.popup{
	widget = wibox.widget{
			{
				{
					{
						id     = "bg_image",
						scaling_quality = "good",
						resize = true,
						upscale = true,
						vertical_fit_policy = "fit",
						horizontal_fit_policy = "fit",
						forced_width  = main_width,
						forced_height = main_height,
						widget = wibox.widget.imagebox,
					},
					{
						{
							widget = wibox.widget.textbox,
						},
						bg = "#000000",
						opacity = 0.3,
						widget = wibox.container.background,
					},
					layout	= wibox.layout.stack,
				},
				top    = dpi(-10),
				left   = dpi(-10),
				right  = dpi(-10),
				bottom = dpi(-10),
				id     = "margin",
				widget = wibox.container.margin,
			},
		{
			{
				{
					{
							{
								id     = "cv_image",
								resize = true,
								upscale = true,
								clip_shape			= function(cr, width, height)
									gears.shape.rounded_rect(cr, width, height, dpi(9))
								end,
								widget = wibox.widget.imagebox,
							},
							halign = "center",
							valign = "center",
							widget = wibox.container.place,
					},
					id = "cv_margin",
					top    = dpi(15),
					left   = dpi(15),
					right  = dpi(15),
					bottom = dpi(0),
					forced_width  = dpi(200),
					forced_height = dpi(220),
					widget = wibox.container.margin,
				},
				{
					top = dpi(10),
					widget = wibox.container.margin,
				},
				{
					{
						{
							id = "title",
							text = "--",
							font = "Microsoft YaHei UI Bold 12",
							widget = wibox.widget.textbox,
						},
						fg = "#ffffff",
						opacity = 0.9,
						--forced_height = dpi(15),
						widget = wibox.container.background,
					},
					halign = "center",
					valign = "center",
					widget = wibox.container.place,
				},
				{
					top = dpi(0),
					widget = wibox.container.margin,
				},
				{
					{
						{
							id = "artist",
							text = "--",
							font = "Microsoft YaHei UI Bold 10",
							widget = wibox.widget.textbox,
						},
						fg = "#ffffff",
						opacity = 0.6,
						--forced_height = dpi(15),
						widget = wibox.container.background,
					},
					halign = "center",
					valign = "center",
					widget = wibox.container.place,
				},
				{
					top = dpi(20),
					widget = wibox.container.margin,
				},
				{
					{
						{
							id            = "bar",
							value         = 0,
							max_value     = 100,
							forced_height = dpi(7),
							forced_width  = dpi(50),
							color         = "#ffffffcc",
							paddings	  = dpi(0),
							border_width  = dpi(0),
							border_color  = "#ffffff",
							background_color = "#ffffff44",
							widget = wibox.widget.progressbar,	
							shape			= function(cr, width, height)
								gears.shape.rounded_rect(cr, width, height, dpi(4))
							end,
							bar_shape		= function(cr, width, height)
								gears.shape.rounded_rect(cr, width, height, dpi(4))
							end
						},
						{
							id = "slider",
							bar_shape           = gears.shape.rounded_rect,
							bar_height          = dpi(7),
							bar_color           = "",
							handle_color        = "",
							handle_border_color = "",
							handle_border_width = 0,
							value               = 0,
							forced_height       = dpi(7),
							forced_width        = dpi(50),
							widget              = wibox.widget.slider,
						},
						layout	= wibox.layout.stack,
					},
					right = dpi(15),
					left = dpi(15),
					widget = wibox.container.margin,
					buttons	= awful.util.table.join(
					awful.button({}, 1, nil, function()
							local percent = mpc.popup.widget:get_children_by_id("slider")[1].value
							mpc.popup.widget:get_children_by_id("bar")[1].value = percent
							awful.spawn.easy_async_with_shell(cmd_seek(percent), function(out)
						end)
					end)),
				},
				{
					top = dpi(2),
					widget = wibox.container.margin,
				},
				{
					{
						{
							{
								{
									id = "elapsed",
									text = "0:00",
									font = "Microsoft YaHei UI Bold 9",
									widget = wibox.widget.textbox,
								},
								fg = "#ffffff",
								opacity = 0.5,
								--forced_height = dpi(15),
								widget = wibox.container.background,
							},
							halign = "left",
							valign = "center",
							widget = wibox.container.place,
						},
						{
							{
								{
									id = "time",
									text = "9:99",
									font = "Microsoft YaHei UI Bold 9",
									widget = wibox.widget.textbox,
								},
								fg = "#ffffff",
								opacity = 0.5,
								--forced_height = dpi(15),
								widget = wibox.container.background,
							},
							halign = "right",
							valign = "center",
							widget = wibox.container.place,
						},
						layout	= wibox.layout.stack,
					},
					right = dpi(15),
					left = dpi(15),
					widget = wibox.container.margin,
				},
				{
					{
						{
							{
								{
									image  = theme.mpc_prev_icon,
									forced_width = dpi(30),
									forced_height = dpi(30),
									widget = wibox.widget.imagebox,
								},
								opacity = 0.9,
								widget = wibox.container.background,
							},
							halign = "left",
							valign = "center",
							--forced_width = dpi(30),
							widget = wibox.container.place,
							buttons	= awful.util.table.join(
							awful.button({}, 1, nil, function()
								awful.spawn.easy_async_with_shell(cmd_prev, function(out)
								end)
							end)),
						},
						{
							{
								{
									{
										id = "pause_icon",
										image  = theme.mpc_pause_icon,
										forced_width = dpi(30),
										forced_height = dpi(30),
										visible = false,
										widget = wibox.widget.imagebox,
									},
									opacity = 0.9,
									widget = wibox.container.background,
								},
								halign = "center",
								valign = "center",
								--forced_width = dpi(30),
								widget = wibox.container.place,
								buttons	= awful.util.table.join(
								awful.button({}, 1, nil, function()
									if mpc.status.state == "play" then
										awful.spawn.easy_async_with_shell(cmd_pause, function(out)
											mpc.popup.widget:get_children_by_id("pause_icon")[1].visible = false
											mpc.popup.widget:get_children_by_id("play_icon")[1].visible = true
										end)
									end
								end)),
							},
							{
								{
									{
										id = "play_icon",
										image  = theme.mpc_play_icon,
										forced_width = dpi(30),
										forced_height = dpi(30),
										widget = wibox.widget.imagebox,
									},
									opacity = 0.9,
									widget = wibox.container.background,
								},
								halign = "center",
								valign = "center",
								--forced_width = dpi(30),
								widget = wibox.container.place,
								buttons	= awful.util.table.join(
								awful.button({}, 1, nil, function()
									if mpc.status.state ~= "play" then
										awful.spawn.easy_async_with_shell(cmd_play, function(out)
											mpc.popup.widget:get_children_by_id("pause_icon")[1].visible = true
											mpc.popup.widget:get_children_by_id("play_icon")[1].visible = false
										end)
									end
								end)),
							},
							layout	= wibox.layout.stack,
						},
						{
							{
								{
									image  = theme.mpc_next_icon,
									forced_width = dpi(30),
									forced_height = dpi(30),
									widget = wibox.widget.imagebox,
								},
								opacity = 0.9,
								widget = wibox.container.background,
							},
							halign = "right",
							valign = "center",
							--forced_width = dpi(30),
							widget = wibox.container.place,
							buttons	= awful.util.table.join(
							awful.button({}, 1, nil, function()
								awful.spawn.easy_async_with_shell(cmd_next, function(out)
								end)
							end)),
						},
						layout = wibox.layout.align.horizontal,
					},
					top = dpi(0),
					right = dpi(40),
					left = dpi(40),
					forced_height = dpi(40),
					widget = wibox.container.margin,
				},
				{
					{
						{
							{
								{
									image  = theme.mpc_lyric_icon,
									forced_width = dpi(25),
									forced_height = dpi(25),
									widget = wibox.widget.imagebox,
								},
								id = "lyric_icon",
								opacity = 0.5,
								widget = wibox.container.background,
							},
							halign = "left",
							valign = "center",
							forced_width = dpi(30),
							widget = wibox.container.place,
							buttons	= awful.util.table.join(
							awful.button({}, 1, nil, function()
								local icon = mpc.popup.widget:get_children_by_id("lyric_icon")[1]
								if icon.opacity == 0.5 then
									icon.opacity = 0.9
								else
									icon.opacity = 0.5
								end
							end)),
						},
						nil,
						{
							{
								{
									image  = theme.mpc_playlist_icon,
									forced_width = dpi(18),
									forced_height = dpi(18),
									widget = wibox.widget.imagebox,
								},
								id = "playlist_icon",
								opacity = 0.5,
								widget = wibox.container.background,
							},
							halign = "right",
							valign = "center",
							forced_width = dpi(30),
							widget = wibox.container.place,
							buttons	= awful.util.table.join(
							awful.button({}, 1, nil, function()
								local icon = mpc.popup.widget:get_children_by_id("playlist_icon")[1]
								local side = mpc.popup.widget:get_children_by_id("sidepage")[1]
								if icon.opacity == 0.5 then
									icon.opacity = 0.9
									side.visible = true
								else
									icon.opacity = 0.5
									side.visible = false
								end
								if mpc.status.state == "play" then
									mpc.popup.widget:get_children_by_id("pause_icon")[1].visible = false
									mpc.popup.widget:get_children_by_id("pause_icon")[1].visible = true
								else
									mpc.popup.widget:get_children_by_id("play_icon")[1].visible = false
									mpc.popup.widget:get_children_by_id("play_icon")[1].visible = true
								end
								playlist_mid = tonumber(mpc.status.song) + 1
								if playlist_mid <= math.floor(playlist_row_num/2) then
									playlist_mid = math.floor(playlist_row_num/2) + 1
								elseif playlist_mid > tonumber(mpc.status.playlistlength) - math.floor(playlist_row_num / 2) then
									playlist_mid = tonumber(mpc.status.playlistlength) - math.floor(playlist_row_num / 2)
								end
								mpc:update_playlist()
							end)),
						},
						layout = wibox.layout.align.horizontal,
					},
					top = dpi(10),
					right = dpi(15),
					left = dpi(15),
					bottom = dpi(10),
					--forced_height = dpi(60),
					widget = wibox.container.margin,
				},
				forced_width  = main_width,
				forced_height = main_height,
				layout = wibox.layout.fixed.vertical,
		},
		{
			{
				id = "playlist_container",
				layout	= wibox.layout.flex.vertical,
			},
			id = "sidepage",
			top    = dpi(15),
			left   = dpi(15),
			right  = dpi(15),
			bottom = dpi(15),
			visible = false,
			forced_width  = main_width,
			forced_height = main_height,
			widget = wibox.container.margin,
		},
		layout = wibox.layout.align.horizontal,
	},
	layout	= wibox.layout.stack,
		set_bg_image = function(self, bg_image)
			self:get_children_by_id("bg_image")[1].image = bg_image
		end,
		set_cv_image = function(self, cv_image)
			self:get_children_by_id("cv_image")[1].image = cv_image
		end,
		set_title = function(self, title)
			self:get_children_by_id("title")[1].text = title
		end,
		set_artist = function(self, artist)
			self:get_children_by_id("artist")[1].text = artist
		end,
		set_bar = function(self, val)
			self:get_children_by_id("bar")[1].value = val
		end,
		set_elapsed = function(self, elapsed)
			self:get_children_by_id("elapsed")[1].text = elapsed
		end,
		set_time = function(self, time)
			self:get_children_by_id("time")[1].text = time
		end,
	},
	border_color	= theme.popup_border_color,
    --border_width	= theme.popup_border_width,
    border_width	= 0,
	visible			= false,
	bg				= theme.popup_bg,
	fg				= theme.popup_fg,
	ontop			= true,
	shape			= function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, dpi(16))
	end,
}

local playlist_list = {}
local add_playlist_row = function() 
	return wibox.widget{
		{
			{
				id = "playlist",
				text = "",
				font = "Microsoft YaHei UI 10",
				widget = wibox.widget.textbox,
			},
			id = "p",
			halign = "center",
			valign = "center",
			widget = wibox.container.place,
		},
		fg = "#ffffff",
		opacity = 0.9,
		widget = wibox.container.background,
		buttons	= awful.util.table.join(
			awful.button({}, 4, function()
				playlist_mid = playlist_mid - 1
				if playlist_mid <= math.floor(playlist_row_num/2) then
					playlist_mid = math.floor(playlist_row_num/2) + 1
				elseif playlist_mid > tonumber(mpc.status.playlistlength) - math.floor(playlist_row_num / 2) then
					playlist_mid = tonumber(mpc.status.playlistlength) - math.floor(playlist_row_num / 2)
				end
				--print(playlist_mid)
				mpc:set_playlist(playlist_mid)
			end),
			awful.button({}, 5, function()
				playlist_mid = playlist_mid + 1
				if playlist_mid <= math.floor(playlist_row_num/2) then
					playlist_mid = math.floor(playlist_row_num/2) + 1
				elseif playlist_mid > tonumber(mpc.status.playlistlength) - math.floor(playlist_row_num / 2) then
					playlist_mid = tonumber(mpc.status.playlistlength) - math.floor(playlist_row_num / 2)
				end
				--print(playlist_mid)
				mpc:set_playlist(playlist_mid)
			end)
		)
	}
end

for i = 1,playlist_row_num do
	container = mpc.popup.widget:get_children_by_id("playlist_container")[1]
	playlist_list[i] = add_playlist_row()
	playlist_list[i].idx = i
	playlist_list[i]:add_button(
			awful.button({}, 1, function(self)
				awful.spawn.easy_async_with_shell("mpc play " .. playlist_list[i].idx , function(out)
				end)
			end)
	)
	container:insert(i, playlist_list[i])
end

local playlist_mid = 1

function mpc:set_playlist(mid) 
	local current = mid or tonumber(mpc.status.song) + 1
	local all = tonumber(mpc.status.playlistlength)
	local prev = math.floor(current - math.floor(playlist_row_num / 2))
	if prev < 1 then
		prev = 1
	elseif prev > all then
		prev = all
	end
	if current + math.floor(playlist_row_num / 2) > all then
		prev = all - playlist_row_num + 1
	end
	for i = 1,playlist_row_num do
		local idx = i + prev - 1
		if idx <= all then
			playlist_list[i].p.playlist.text = mpc.playlist[idx]
			playlist_list[i].idx = idx
			if idx == tonumber(mpc.status.song) + 1 then
				playlist_list[i].p.playlist.font = "Microsoft YaHei UI Bold 11"
				playlist_list[i].opacity = 0.9
			else
				playlist_list[i].p.playlist.font = "Microsoft YaHei UI 10"
				playlist_list[i].opacity = 0.5
			end
		else
			playlist_list[i].p.playlist.text = ""
		end
	end
	--return "mpc playlist | awk -F ' - ' '{print $2}' | sed -n " .. prev .. "," .. next .. "p  >  " .. cache_dir .. "playlist" 
end

function mpc:update_playlist()
	awful.spawn.easy_async_with_shell("mpc playlist | awk -F ' - ' '{print $2}' > " .. cache_dir .. "playlist", function(out)
		mpc.playlist = {}
		file = io.open(cache_dir .. "playlist","r")
		for i = 1,tonumber(mpc.status.playlistlength) do 
			 mpc.playlist[i] = file:read() or " "
		end
		file:close()
		mpc:set_playlist()
	end)
end


function mpc:update_time()
	awful.spawn.easy_async_with_shell(cmd_get_time, function(out)
		if #out > 1 then
			--print(os.date("%X") .. ": update time")
			mpc.popup.widget.bar = tonumber(string.match(out, "(%d+)%%"))
			mpc.popup.widget.elapsed = string.match(out, " (%d+:%d+)/")
			mpc.popup.widget.time = string.match(out, "/(%d+:%d+) ")
		else
			mpc.popup.widget.bar = 0
			mpc.popup.widget.elapsed = "0:00"
			mpc.popup.widget.time = "0:00"
		end
	end)
end


function mpc:update_song()
	--print(os.date("%X") .. ": update currentsong")
	mpc.popup.widget.title = mpc.currentsong.title
	mpc.popup.widget.artist = mpc.currentsong.artist
	awful.spawn.easy_async_with_shell(cmd_get_cover(string.gsub(mpc.currentsong.file, " ","\\ ")), function(out)
		--print(cmd_get_cover(mpc.currentsong.file))
		if out == "ok\n" then
			--print(cmd_blur_cover(mpc.currentsong.file))
			mpc.popup.widget:get_children_by_id("bg_image")[1].visible = true
			mpc.popup.widget.cv_image = cache_dir .. mpc.currentsong.file .. ".jpg"
			awful.spawn.easy_async_with_shell(cmd_blur_cover(string.gsub(mpc.currentsong.file, " ","\\ ")), function(out)
				if out == "ok\n" then
					mpc.popup.widget.bg_image = cache_dir .. mpc.currentsong.file .. ".blur.jpg"
				end
			end)
		else
			mpc.popup.widget.cv_image = theme.mpc_cover_image
			mpc.popup.widget:get_children_by_id("bg_image")[1].visible = false
			mpc.popup.bg = "#aaaaaa"
		end
	end)
end




function mpc:setup(mt,ml,mr,mb)
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
			local icon = mpc.popup.widget:get_children_by_id("playlist_icon")[1]
			local side = mpc.popup.widget:get_children_by_id("sidepage")[1]
			icon.opacity = 0.5
			side.visible = false
			self.popup:disconnect_signal ('mouse::move',popup_move)
			self.popup.visible = false
			self.widget.bg = theme.topbar_bg
			self.widget.shape_border_color = theme.topbar_bg
		end)
	))

	self.widget:buttons(awful.util.table.join (
		awful.button({}, 1, function() 
			if self.popup.visible then
				local icon = mpc.popup.widget:get_children_by_id("playlist_icon")[1]
				local side = mpc.popup.widget:get_children_by_id("sidepage")[1]
				icon.opacity = 0.5
				side.visible = false
				self.popup.visible = false
				self.widget.bg = theme.widget_bg_press
			else
				self.popup.x = mouse.coords().x - dpi(120)
				self.popup.y = theme.popup_margin_top
				self.popup.visible = true
				self.widget.bg = theme.widget_bg_hover
				self.elapsed_timer:again()
				mpc:update_time()
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
			self.widget.bg = theme.topbar_bg
			self.widget.shape_border_color = theme.topbar_bg
		end
	end)

	self.elapsed_timer = gears.timer {
		timeout   = 1,
		call_now  = false,
		autostart = true,
		callback  = function()
			--print(os.date("%X") .. ": update elapsed_timer")
			if self.popup.visible and self.status.state == "play" then
				self:update_time()
			else
				self.elapsed_timer:stop()
			end
		end
	}

	return self.widget
end




return mpc
