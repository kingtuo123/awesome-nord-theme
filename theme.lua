local gears		 = require("gears")
local beautiful  = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi 		 = xresources.apply_dpi


theme					= {}
theme.style 			= "light"
--theme.style 			= "dark"
theme.dir               = os.getenv("HOME") .. "/.config/awesome/"
theme.icon_dir          = os.getenv("HOME") .. "/.config/awesome/icons/" .. theme.style .. "/"


--dark
theme.color0  = "#2e3440"
theme.color1  = "#3b4252"
theme.color2  = "#434c5e"
theme.color3  = "#4c566a"

--light
theme.color4  = "#d8dee9"
theme.color5  = "#e5e9f0"
theme.color6  = "#eceff4"

--green to blue
theme.color7  = "#8fbcbb"
theme.color8  = "#88c0d0"
theme.color9  = "#81a1c1"
theme.color10 = "#5e81ac"

--red to purple
theme.color11 = "#bf616a"
theme.color12 = "#d08770"
theme.color13 = "#ebcb8b"
theme.color14 = "#a3be8c"
theme.color15 = "#b48ead"

theme.color16 = "#242933"
theme.color17 = "#ffffff"


if theme.style == "dark" then
	theme.fg	 = theme.color6
	theme.bg	 = theme.color16
	theme.border_normal = theme.color1
	theme.border_focus  = theme.color16
	theme.titlebar_fg_normal = theme.color3
	theme.titlebar_bg_normal = theme.color1
	theme.titlebar_fg_focus  = theme.fg
	theme.titlebar_bg_focus  = theme.color16

	theme.taglist_fg_focus    = theme.color6
	theme.taglist_bg_focus    = theme.color2
	theme.taglist_fg_occupied = theme.color4
	theme.taglist_bg_occupied = theme.color0
	theme.taglist_bg_empty    = theme.bg
	theme.taglist_fg_empty    = theme.color1
	theme.taglist_bg_hover 	  = theme.color3

	theme.tasklist_bg_focus    = theme.color1
	theme.tasklist_bg_normal   = theme.bg
	theme.tasklist_bg_minimize = theme.bg
	theme.tasklist_bg_line     = theme.color3
	theme.tasklist_bg_hover    = theme.color2

	theme.promptbox_bg = theme.color0
	theme.promptbox_border = theme.color3
	theme.prompt_fg = theme.fg
	theme.prompt_bg = theme.promptbox_bg

	theme.widget_bg_hover = theme.color0
	theme.popup_border_color	  = theme.color3

	theme.widget_bg = theme.color3
else
	theme.fg	 = theme.color2
	theme.bg	 = theme.color6
	theme.border_normal = theme.color4
	theme.border_focus  = theme.color6
	theme.titlebar_fg_normal = theme.color6
	theme.titlebar_bg_normal = theme.color4
	theme.titlebar_fg_focus  = theme.fg
	theme.titlebar_bg_focus  = theme.color6

	theme.taglist_fg_focus    = theme.color2
	theme.taglist_bg_focus    = theme.color2 .. "44"
	theme.taglist_fg_occupied = theme.color2
	theme.taglist_bg_occupied = theme.color4
	theme.taglist_bg_empty    = theme.bg
	theme.taglist_fg_empty    = theme.color4
	theme.taglist_bg_hover 	  = theme.color2 .. "55"

	theme.tasklist_bg_focus    = theme.color4
	theme.tasklist_bg_normal   = theme.bg
	theme.tasklist_bg_minimize = theme.bg
	theme.tasklist_bg_line     = theme.color10
	theme.tasklist_bg_hover    = theme.color2 .. "33"

	theme.promptbox_bg = theme.color6
	theme.promptbox_border = theme.color4
	theme.prompt_fg = theme.fg
	theme.prompt_bg = theme.promptbox_bg

	theme.widget_bg_hover = theme.color17 .. "dd"
	theme.popup_border_color	  = theme.color4

	theme.widget_bg = theme.color4
end


theme.wibar_height		 = dpi(30)

theme.popup_margin_top	 = theme.wibar_height + dpi(5)
theme.popup_border_width = dpi(2)
theme.popup_rounded		 = dpi(5)

theme.titlebar_height = dpi(30)

theme.taglist_spacing                           = dpi(0)

theme.tasklist_icon_size  = dpi(30)
theme.tasklist_line_width = dpi(50)
theme.tasklist_spacing    = dpi(3)
theme.tasklist_disable_task_name = true














--theme.icon_theme		= "Tela-nord"
theme.icon_theme		= "Fluent"

theme.font				= "Microsoft YaHei Bold 9"
theme.prompt_font		= "Microsoft YaHei Bold 10"

theme.useless_gap   = dpi(3)
theme.border_width  = dpi(4)






theme.wifi_signal_0_icon		= theme.icon_dir .. "wifi/wifi-0.svg"
theme.wifi_signal_1_icon		= theme.icon_dir .. "wifi/wifi-1.svg"
theme.wifi_signal_2_icon		= theme.icon_dir .. "wifi/wifi-2.svg"
theme.wifi_signal_3_icon		= theme.icon_dir .. "wifi/wifi-3.svg"
theme.wifi_disconnect_icon		= theme.icon_dir .. "wifi/wifi-disconnect.svg"


theme.brightness_1_icon			= theme.icon_dir .. "brightness/brightness-1.svg"
theme.brightness_2_icon			= theme.icon_dir .. "brightness/brightness-2.svg"
theme.brightness_3_icon			= theme.icon_dir .. "brightness/brightness-3.svg"

theme.vpn_on_icon				= theme.icon_dir .. "vpn/vpn-on.svg"
theme.vpn_off_icon				= theme.icon_dir .. "vpn/vpn-off.svg"
theme.switch_on_icon			= theme.icon_dir .. "vpn/switch-on.svg"
theme.switch_off_icon			= theme.icon_dir .. "vpn/switch-off.svg"


theme.netspeed_up_icon				= theme.icon_dir .. "netspeed/netspeed-up.svg"
theme.netspeed_up_active_icon				= theme.icon_dir .. "netspeed/netspeed-up-active.svg"
theme.netspeed_down_icon				= theme.icon_dir .. "netspeed/netspeed-down.svg"
theme.netspeed_down_active_icon				= theme.icon_dir .. "netspeed/netspeed-down-active.svg"


theme.disk_icon					= theme.icon_dir .. "disk/disk.svg"
theme.hhd_icon					= theme.icon_dir .. "disk/hhd.svg"
theme.usb_icon					= theme.icon_dir .. "disk/usb.svg"
theme.mount_icon					= theme.icon_dir .. "disk/mount.svg"
theme.eject_icon					= theme.icon_dir .. "disk/eject.svg"


theme.vol_100_icon		= theme.icon_dir .. "volume/vol-100.svg"
theme.vol_70_icon		= theme.icon_dir .. "volume/vol-70.svg"
theme.vol_40_icon		= theme.icon_dir .. "volume/vol-40.svg"
theme.vol_10_icon		= theme.icon_dir .. "volume/vol-10.svg"
theme.vol_0_icon		= theme.icon_dir .. "volume/vol-0.svg"
theme.vol_bar0_icon		= theme.icon_dir .. "volume/vol-bar0.svg"
theme.vol_bar10_icon	= theme.icon_dir .. "volume/vol-bar10.svg"
theme.vol_bar40_icon	= theme.icon_dir .. "volume/vol-bar40.svg"
theme.vol_bar70_icon	= theme.icon_dir .. "volume/vol-bar70.svg"
theme.vol_bar100_icon	= theme.icon_dir .. "volume/vol-bar100.svg"






theme.layout_floating  = theme.icon_dir .. "layouts/floating.svg"
theme.layout_tile = theme.icon_dir .. "layouts/tile.svg"
theme.layout_tileleft = theme.icon_dir .. "layouts/tileleft.svg"
theme.layout_tilebottom = theme.icon_dir .. "layouts/tilebottom.svg"
theme.layout_tiletop = theme.icon_dir .. "layouts/tiletop.svg"
theme.layout_fairv = theme.icon_dir .. "layouts/fairv.svg"
theme.layout_fairh = theme.icon_dir .. "layouts/fairh.svg"

--theme.taglist_squares_sel   = theme.icon_dir .. "layouts/fairv.svg"
--theme.taglist_squares_unsel = theme.icon_dir .. "layouts/fairh.svg"



theme.snap_bg = "#eceff4"
theme.snap_border_width = dpi(2)



theme.titlebar_close_button_normal = theme.icon_dir .. "titlebar/titlebutton-close-normal.svg"
theme.titlebar_close_button_focus  = theme.icon_dir .. "titlebar/titlebutton-close.svg"
theme.titlebar_close_button_focus_hover = theme.icon_dir .. "titlebar/titlebutton-close-hover.svg"
theme.titlebar_close_button_focus_press = theme.icon_dir .. "titlebar/titlebutton-close-active.svg"
theme.titlebar_close_button_normal_hover = theme.icon_dir .. "titlebar/titlebutton-close-hover.svg"
theme.titlebar_close_button_normal_press = theme.icon_dir .. "titlebar/titlebutton-close-active.svg"




theme.titlebar_maximized_button_normal_inactive = theme.icon_dir .. "titlebar/titlebutton-maximize-normal.svg"
theme.titlebar_maximized_button_focus_inactive  = theme.icon_dir .. "titlebar/titlebutton-maximize.svg"
theme.titlebar_maximized_button_focus_inactive_hover  = theme.icon_dir .. "titlebar/titlebutton-maximize-hover.svg"
theme.titlebar_maximized_button_focus_inactive_press  = theme.icon_dir .. "titlebar/titlebutton-maximize-active.svg"
theme.titlebar_maximized_button_normal_inactive_hover  = theme.icon_dir .. "titlebar/titlebutton-maximize-hover.svg"
theme.titlebar_maximized_button_normal_inactive_press  = theme.icon_dir .. "titlebar/titlebutton-maximize-active.svg"

theme.titlebar_maximized_button_normal_active = theme.icon_dir .. "titlebar/titlebutton-maximize-normal.svg"
theme.titlebar_maximized_button_focus_active  = theme.icon_dir .. "titlebar/titlebutton-maximize.svg"
theme.titlebar_maximized_button_focus_active_hover  = theme.icon_dir .. "titlebar/titlebutton-unmaximize-hover.svg"
theme.titlebar_maximized_button_focus_active_press  = theme.icon_dir .. "titlebar/titlebutton-unmaximize-active.svg"
theme.titlebar_maximized_button_normal_active_hover  = theme.icon_dir .. "titlebar/titlebutton-unmaximize-hover.svg"
theme.titlebar_maximized_button_normal_active_press  = theme.icon_dir .. "titlebar/titlebutton-unmaximize-active.svg"


theme.titlebar_minimize_button_normal = theme.icon_dir .. "titlebar/titlebutton-minimize-normal.svg"
theme.titlebar_minimize_button_focus = theme.icon_dir .. "titlebar/titlebutton-minimize.svg"
theme.titlebar_minimize_button_focus_hover = theme.icon_dir .. "titlebar/titlebutton-minimize-hover.svg"
theme.titlebar_minimize_button_focus_press = theme.icon_dir .. "titlebar/titlebutton-minimize-active.svg"
theme.titlebar_minimize_button_normal_hover = theme.icon_dir .. "titlebar/titlebutton-minimize-hover.svg"
theme.titlebar_minimize_button_normal_press = theme.icon_dir .. "titlebar/titlebutton-minimize-active.svg"


theme.titlebar_floating_button_normal_inactive = theme.icon_dir .. "titlebar/floating-normal.svg"
theme.titlebar_floating_button_focus_inactive = theme.icon_dir .. "titlebar/floating-normal.svg"
theme.titlebar_floating_button_focus_inactive_hover = theme.icon_dir .. "titlebar/floating.svg"
theme.titlebar_floating_button_focus_inactive_press = theme.icon_dir .. "titlebar/floating-normal.svg"
theme.titlebar_floating_button_normal_active = theme.icon_dir .. "titlebar/floating-normal-active.svg"
theme.titlebar_floating_button_focus_active = theme.icon_dir .. "titlebar/floating.svg"
theme.titlebar_floating_button_normal_inactive_hover = theme.icon_dir .. "titlebar/floating-normal-active.svg"




theme.titlebar_ontop_button_normal_inactive = theme.icon_dir .. "titlebar/ontop-normal.svg"
theme.titlebar_ontop_button_focus_inactive = theme.icon_dir .. "titlebar/ontop-normal.svg"
theme.titlebar_ontop_button_focus_inactive_hover = theme.icon_dir .. "titlebar/ontop.svg"
theme.titlebar_ontop_button_focus_inactive_press = theme.icon_dir .. "titlebar/ontop-normal.svg"
theme.titlebar_ontop_button_normal_active = theme.icon_dir .. "titlebar/ontop-normal-active.svg"
theme.titlebar_ontop_button_focus_active = theme.icon_dir .. "titlebar/ontop.svg"
theme.titlebar_ontop_button_normal_inactive_hover = theme.icon_dir .. "titlebar/ontop-normal-active.svg"



theme.titlebar_sticky_button_normal_inactive = theme.icon_dir .. "titlebar/sticky-normal.svg"
theme.titlebar_sticky_button_focus_inactive = theme.icon_dir .. "titlebar/sticky-normal.svg"
theme.titlebar_sticky_button_focus_inactive_hover = theme.icon_dir .. "titlebar/sticky.svg"
theme.titlebar_sticky_button_focus_inactive_press = theme.icon_dir .. "titlebar/sticky-normal.svg"
theme.titlebar_sticky_button_normal_active = theme.icon_dir .. "titlebar/sticky-normal-active.svg"
theme.titlebar_sticky_button_focus_active = theme.icon_dir .. "titlebar/sticky.svg"
theme.titlebar_sticky_button_normal_inactive_hover = theme.icon_dir .. "titlebar/sticky-normal-active.svg"




theme.terminal_icon	= theme.icon_dir .. "promptbox/terminal.svg"


--theme.tasklist_bg_image_focus = theme.icon_dir .. "tasklist/bg_focus.svg"
--theme.tasklist_bg_image_normal = theme.icon_dir .. "tasklist/bg_normal.svg"
--theme.tasklist_bg_image_minimize = theme.icon_dir .. "tasklist/bg_minimize.svg"





return theme
