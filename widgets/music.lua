local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme")
local mpc   = require("libs.mpc")
local dpi	= require("beautiful.xresources").apply_dpi


local music = {}
music.status = {}
music.currentsong = {}
music.lyrics = {}
music.lyrics_curr_idx = 1
music.lyrics_next_idx = 1


local music_dir = os.getenv("HOME") .. "/Music/"
local lyric_dir = os.getenv("HOME") .. "/Music/Lyrics/"
local music_icon_size = dpi(17)

local last_id
local last_state
local last_elapsed


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
			music:update()
		end
		if music.status.state == "stop" then
			return
		end
		if last_elapsed ~= music.status.elapsed then
			--print(tonumber(music.status.elapsed))
			last_elapsed = music.status.elapsed
			--music:set_lyric(music.status.elapsed)
		end
		--for i,v in pairs(result) do
		--	print(i .. " = " .. v)
		--end
    end,
    "currentsong", function(_, result)
		music.currentsong = result
		if last_id ~= music.currentsong.id then
			last_id = music.currentsong.id
			last_elapsed = 0
			--music:get_lyric()
			music:update()
			--print(music.currentsong.id)
		end
		--for i,v in pairs(result) do
		--	print(i .. " = " .. v)
		--end
    end)


music.widget = wibox.widget{
	{
		{
			{
				{
					id = "music_icon",
					image = theme.music_icon,
					forced_height = music_icon_size,
					forced_width = music_icon_size,
					widget = wibox.widget.imagebox,
				},
				valign = "center",
				halign = "center",
				widget = wibox.container.place,
			},
			{
				{
					id = "title",
					text = "--",
					font = theme.music_font,
					widget = wibox.widget.textbox,
				},
				valign = "center",
				halign = "left",
				widget = wibox.container.place,
			},
			{
				left = dpi(5),
				widget	= wibox.container.margin,
			},
			layout = wibox.layout.fixed.horizontal,
		},
		id      = "margin",
		widget	= wibox.container.margin
	},
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, theme.widget_rounded)
	end,
	shape_border_width = theme.widget_border_width,
	shape_border_color = theme.widget_border_color,
	widget = wibox.container.background,
}


function music:get_lyric()
	local lyric_name = string.gsub(self.currentsong.file, "[.]%a+$",".lrc")
	lyric_name = string.gsub(lyric_name, " ","\\ ")
	local file = io.open(lyric_dir .. lyric_name)
	if file ~= nil then
		print(lyric_dir .. lyric_name)
		self.lyrics = {}
		self.lyrics.time = {}
		self.lyrics.text = {}
		local line = file:read()
		while line ~= nil do
			if string.match(line, "[[]00:00[.]") then
				print(line)
				break
			end
			line = file:read()
		end
		while line ~= nil do
			local m = tonumber(string.match(line, "[[](%d+):"))
			local s = tonumber(string.match(line, ":(%d+[.]%d+)[]]"))
			local time = m * 60 + s
			local text = string.match(line, "[]](.+)$")
			table.insert(self.lyrics.time, time)
			table.insert(self.lyrics.text, text)
			line = file:read()
		end
		--for i,v in pairs(self.lyrics.time) do
		--	print(v .. self.lyrics.text[i])
		--end
		file:close()
	else
		self.lyrics.time = {}
		self.lyrics.text = {}
		print("lyric not exist")
	end
end


function music:set_lyric(elapsed)
	if self.lyrics.text == nil then
		return
	end
	local p
	local delay
	if elapsed ~= nil then
		p = elapsed
		self.status.elapsed = elapsed
	else
		return
	end
	p = tonumber(p)
	for i,v in pairs(self.lyrics.time) do
		self.lyrics_curr_idx = i
		if p >= v and self.lyrics.time[i+1] ~= nil and p < self.lyrics.time[i+1] then
			break
		end
	end
	print(music.lyrics.text[music.lyrics_curr_idx])
	--if self.lyrics.time[self.lyrics_curr_idx + 1] ~= nil then
	--	self.lyrics_next_idx = self.lyrics_curr_idx + 1
	--	delay = self.lyrics.time[self.lyrics_next_idx] - self.lyrics.time[self.lyrics_curr_idx]
	--	awful.spawn.with_shell(string.format("sleep %ss && awesome-client \"require('widgets.music'):set_lyric(%s)\"", delay, self.lyrics.time[self.lyrics_next_idx]))
	--end
end


function music:update()
	if self.status.state ~= "play" then
		self.widget:get_children_by_id("title")[1].text = "  " .. string.upper(self.status.state) .. "  "
	else
		--self.widget:get_children_by_id("title")[1].text = "  " .. self.currentsong.title or " -- "
		self.widget:get_children_by_id("title")[1].text = string.format("  %s - %s", self.currentsong.title or "unknow", self.currentsong.artist or "unknow")
		--self.widget:get_children_by_id("title")[1].text = string.format("  %s", self.currentsong.title or "Unknow")
	end
end


function music:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	self.widget:connect_signal('mouse::enter',function() 
		self.widget.bg = theme.widget_bg_hover
	end)
	self.widget:connect_signal('mouse::leave',function() 
		self.widget.bg = theme.topbar_bg
	end)

	self.widget:buttons(awful.util.table.join(
		awful.button({}, 1, function() 
			--self.widget:get_children_by_id("music_icon")[1].forced_width = music_icon_size - dpi(2)
			--self.widget:get_children_by_id("music_icon")[1].forced_height = music_icon_size - dpi(2)
			--self.widget:get_children_by_id("title")[1].font = theme.music_font1
		end,
		function()
			--self.widget:get_children_by_id("music_icon")[1].forced_width = music_icon_size
			--self.widget:get_children_by_id("music_icon")[1].forced_height = music_icon_size
			--self.widget:get_children_by_id("title")[1].font = theme.music_font
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

	--gears.timer({
	--	timeout   = 2,
	--	call_now  = true,
	--	autostart = true,
	--	callback  = function()
	--	end
	--})

	return self.widget
end


return music
