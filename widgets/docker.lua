local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local json  = require("lib.json")
local theme = require("theme")
local json		 = require("lib.json")
local beautiful	 = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi 		 = xresources.apply_dpi






local docker = {}
local cmd_status = "docker container ls -a --format '{{.Names}}'|xargs docker container inspect --format '{name:'{{.Name}}',status:'{{.State.Status}}'},'|sed 's@/@@g'|sed '$s@,$@]}@'|sed '1s@^@{container:[@'"

docker.widget = wibox.widget{
	image  = theme.docker_icon,
	widget = wibox.widget.imagebox,
}


docker.update = function()
	awful.spawn.easy_async_with_shell(cmd_status, function(out)
		print("update docker")
		docker.panel.data = json.decode(out).container
	end)
end



docker.panel = wibox.widget{
	{
		{
			id	   = "head",
			widget = wibox.widget.textbox,
		},
		top = dpi(0),
		widget = wibox.container.margin,
	},
	{
		id = "container",
		layout = wibox.layout.fixed.vertical,
	},
	{
		{
			id	   = "footer",
			widget = wibox.widget.textbox,
		},
		bottom = dpi(10),
		widget = wibox.container.margin,
	},
	layout = wibox.layout.fixed.vertical,

	add_container = function(self,name)
		local wdg = wibox.widget{
			
		}
	end,
}































return docker
