local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local json  = require("libs.json")
local theme = require("theme")
local dpi	= require("beautiful.xresources").apply_dpi




local weather = {}
local update_timeout = 300
local cmd_get_weather = "curl --connect-timeout 5 \"https://restapi.amap.com/v3/weather/weatherInfo?key=`cat ~/.config/Amap/key`&city=330382\" || echo failed"




weather.widget = wibox.widget{
	{
		{
			{
				{
					id   = "weather_icon",
					image = theme.weather_icon,
					forced_height = dpi(14),
					forced_width = dpi(14),
					widget = wibox.widget.imagebox,
				},
				valign = "center",
				widget = wibox.container.place,
			},
			{
				left = dpi(8),
				widget	= wibox.container.margin,
			},
			{
				id   = "weather",
				text = " -- ",
				font = theme.weather_font,
				--forced_width = dpi(55),
				widget = wibox.widget.textbox,
			},
			{
				left = dpi(20),
				widget	= wibox.container.margin,
			},
			{
				{
					id   = "temperature_icon",
					image = theme.temperature_icon,
					forced_height = dpi(16),
					forced_width = dpi(16),
					widget = wibox.widget.imagebox,
				},
				valign = "center",
				widget = wibox.container.place,
			},
			{
				left = dpi(1),
				widget	= wibox.container.margin,
			},
			{
				id   = "temperature",
				text = " -- ",
				font = theme.weather_font,
				--forced_width = dpi(55),
				widget = wibox.widget.textbox,
			},
			{
				left = dpi(15),
				widget	= wibox.container.margin,
			},
			{
				{
					id   = "humidity_icon",
					image = theme.humidity_icon,
					forced_height = dpi(14),
					forced_width = dpi(14),
					widget = wibox.widget.imagebox,
				},
				valign = "center",
				widget = wibox.container.place,
			},
			{
				left = dpi(3),
				widget	= wibox.container.margin,
			},
			{
				id   = "humidity",
				text = " -- ",
				font = theme.weather_font,
				--forced_width = dpi(55),
				widget = wibox.widget.textbox,
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
	shape_border_color = "",
	widget = wibox.container.background,
}


function weather:update()
	awful.spawn.easy_async_with_shell(cmd_get_weather, function(out)
		--print(os.date("%X") .. ": update weather")
		--print(out)
		if string.match(out,"failed") then
			print("weather: curl failed")
			self.reconnect_timer:start()
			return
		end
		local data = json.decode(out)
		if data.status == "0" then
			print("weather: status failed")
			return
		end
		if data.lives[1].weather ~= nil then
			self.widget:get_children_by_id("weather")[1].text = data.lives[1].weather
			--self.widget:get_children_by_id("weather")[1].text = string.format("%s • %s℃  • %s%%", data.lives[1].weather, data.lives[1].temperature, data.lives[1].humidity)
		end
		if data.lives[1].temperature ~= nil then
			self.widget:get_children_by_id("temperature")[1].text = data.lives[1].temperature .. "℃ "
		end
		if data.lives[1].humidity ~= nil then
			self.widget:get_children_by_id("humidity")[1].text = data.lives[1].humidity .. "%"
		end
	end)
end



function weather:setup(mt,ml,mr,mb)
	self.widget.margin.top    = dpi(mt or 0)
	self.widget.margin.left   = dpi(ml or 0)
	self.widget.margin.right  = dpi(mr or 0)
	self.widget.margin.bottom = dpi(mb or 0)

	self.timer = gears.timer({
		timeout   = update_timeout,
		call_now  = false,
		autostart = true,
		callback  = function()
			--print("weather: update")
			self:update()
		end
	})

	self.reconnect_timer = gears.timer({
		timeout   = 5,
		call_now  = false,
		autostart = true,
		single_shot = true,
		callback  = function()
			--print("weather: reconnect")
			self:update()
		end
	})

	return self.widget
end




return weather
