local awful = require("awful")
local gears = require("gears")
local dpi	= require("beautiful.xresources").apply_dpi


theme = {}


theme.style     = "dark"
--theme.style     = "light"
theme.icon_dir  = os.getenv("HOME") .. "/.config/awesome/icons/" .. theme.style .. "/"


local function sc(...)
	local arg = {...}
	if theme.style == "light" then return arg[1] end
	if theme.style == "dark"  then return arg[2] end
end


---------------------------------------------------------------------------------------
------------------------------------- basic -------------------------------------------
---------------------------------------------------------------------------------------
theme.useless_gap       = dpi(4)
theme.gap_single_client = true
theme.border_width      = dpi(2)
theme.border_rounded    = dpi(8)
theme.font				= "Microsoft YaHei UI 9"
theme.fg                = "#e0def4"
theme.bg                = "#191724"
theme.border_normal     = "#26233a"
theme.border_focus      = "#c4a7e7"

awful.mouse.snap.client_enabled = true
awful.mouse.snap.edge_enabled = false
awful.mouse.snap.default_distance = dpi(5)
awful.mouse.snap.aerosnap_distance = dpi(5)
theme.snap_border_width = dpi(2)
theme.snap_bg           = sc("#86e1fc", "#c099ff")
theme.snap_shape        = gears.shape.rectangle



---------------------------------------------------------------------------------------
--------------------------------- topbar widget ---------------------------------------
---------------------------------------------------------------------------------------
theme.topbar_height         = dpi(33)
theme.topbar_border_width   = dpi(0)
theme.topbar_fg 			= theme.fg
theme.topbar_bg				= theme.bg
theme.topbar_border_color   = "#3b4261"

theme.widget_rounded        = dpi(4)
theme.widget_border_width   = dpi(3)
theme.widget_border_color   = theme.bg
theme.widget_fg             = theme.fg
theme.widget_bg             = "#1f1d2e"
theme.widget_bg_hover       = "#26233a"
theme.widget_bg_press       = "#26233a"
theme.widget_fg_press       = theme.fg
theme.widget_bg_graph       = "#131415"



---------------------------------------------------------------------------------------
------------------------------------ popup --------------------------------------------
---------------------------------------------------------------------------------------
theme.popup_fg 			   = theme.fg
theme.popup_bg 			   = theme.bg
theme.popup_rounded		   = dpi(0)
theme.popup_border_width   = dpi(2)
theme.popup_border_color   = theme.border_normal
theme.popup_margin_top	   = theme.topbar_height + theme.useless_gap * 2
theme.popup_margin_right   = theme.useless_gap * 2
theme.popup_fg_progressbar = "#c4a7e7"
theme.popup_bg_progressbar = "#1f1d2e"
theme.popup_bg_graph       = "#131415"
theme.popup_graph_border_color = "#26233a66"
theme.popup_progress_border_color = "#26233a"



---------------------------------------------------------------------------------------
--------------------------------- corner widget ---------------------------------------
---------------------------------------------------------------------------------------
theme.corner_icon = theme.icon_dir .. "corner/corner.svg"
theme.corner_size = dpi(15)



---------------------------------------------------------------------------------------
--------------------------------- caps lock -------------------------------------------
---------------------------------------------------------------------------------------
theme.caps_on_icon = theme.icon_dir .. "caps/caps-on.svg"
theme.caps_off_icon = theme.icon_dir .. "caps/caps-off.svg"
theme.caps_on_bg = "#eb6f92"
theme.caps_on_fg = theme.bg
theme.caps_widget_on_font  = "JetBrainsMono NFP Bold 8.5"
theme.caps_widget_off_font  = "JetBrainsMono NFP 8.5"





---------------------------------------------------------------------------------------
--------------------------------- indicator -------------------------------------------
---------------------------------------------------------------------------------------
theme.indicator_fg = theme.bg
theme.indicator_bg = theme.fg
theme.indicator_bg_inactive = "#393552"
theme.indicator_rounded = dpi(3)
theme.indicator_font = "Microsoft YaHei UI Bold 8"
theme.indicator_width = dpi(16)
theme.indicator_margin_top = dpi(9)
theme.indicator_margin_bottom = dpi(9)
theme.indicator_margin_left = dpi(3)
theme.indicator_margin_right = dpi(3)





---------------------------------------------------------------------------------------
--------------------------------- close -----------------------------------------------
---------------------------------------------------------------------------------------
--theme.close_icon = theme.icon_dir .. "close/close.svg"
--theme.close_mask_bg = "#eb6f92"
--theme.close_mask_opacity = 0.3




---------------------------------------------------------------------------------------
--------------------------------- taglist ---------------------------------------------
---------------------------------------------------------------------------------------
theme.taglist_font              = "JetBrainsMono NFP 9"
theme.taglist_width        		= dpi(24)
theme.taglist_spacing      		= dpi(2)
theme.taglist_fg_focus     		= theme.bg
theme.taglist_bg_focus     		= "#c4a7e7"
theme.taglist_fg_occupied  		= theme.fg
theme.taglist_bg_occupied  		= "#26233a"
theme.taglist_fg_empty     		= "#393552"
theme.taglist_bg_empty     		= "#1f1d2e"
--theme.taglist_squares_resize	= true
--theme.taglist_squares_sel  		= theme.icon_dir .. "taglist/tag_sel.svg"
--theme.taglist_squares_sel_empty = theme.icon_dir .. "taglist/tag_sel.svg"
--theme.taglist_squares_unsel 	= theme.icon_dir .. "taglist/tag_sel_occ.svg"



---------------------------------------------------------------------------------------
--------------------------------- tasklist --------------------------------------------
---------------------------------------------------------------------------------------
theme.icon_theme		         = "Fluent-dark"
theme.tasklist_icon_size         = dpi(22)
theme.tasklist_width        	 = dpi(33)
theme.tasklist_spacing           = dpi(0)
theme.tasklist_bg_focus          = theme.bg
theme.tasklist_bg_normal         = theme.bg
theme.tasklist_bg_minimize       = theme.bg --"#1f1d2e"
--theme.tasklist_bg_image_focus    = theme.icon_dir .. "taglist/tag_sel.svg"
--theme.tasklist_bg_image_normal   = theme.icon_dir .. "taglist/tag_sel_occ.svg"



---------------------------------------------------------------------------------------
---------------------------------- calendar -------------------------------------------
---------------------------------------------------------------------------------------
theme.clock_font	 = "Microsoft YaHei UI 9"
theme.clock_icon     = theme.icon_dir .. "clock/clock.svg"
--theme.clock_font     = "JetBrainsMono NFP 8.5"
theme.cal_font       = "JetBrainsMono NFP 9"
theme.cal_header_fg  = theme.fg
theme.cal_weekday_fg = "#c4a7e7"
theme.cal_fg_normal  = theme.fg
theme.cal_fg_focus   = theme.popup_bg
theme.cal_bg_focus   = "#c4a7e7"
theme.cal_week_06_bg = "#1f1d2e"
theme.cal_rounded    = dpi(5)
theme.cal_default_padding = {top = dpi(6), bottom = dpi(6), left = dpi(8), right = dpi(8)}



---------------------------------------------------------------------------------------
----------------------------------- music -----------------------------------------------
---------------------------------------------------------------------------------------
theme.music_title_font = "Microsoft YaHei UI 10"
theme.music_artist_font = "Microsoft YaHei UI 9"
theme.music_popup_width = dpi(250)
theme.music_popup_height = dpi(80)
theme.music_popup_margin = dpi(0)
theme.music_icon = theme.icon_dir .. "music/music.svg"
theme.music_off_icon = theme.icon_dir .. "music/music-off.svg"
theme.music_next_icon = theme.icon_dir .. "music/next.svg"
theme.music_prev_icon = theme.icon_dir .. "music/prev.svg"
theme.music_play_icon = theme.icon_dir .. "music/play.svg"
theme.music_pause_icon = theme.icon_dir .. "music/pause.svg"
theme.music_cover_image = theme.icon_dir .. "music/cover.svg"
theme.music_random_icon = theme.icon_dir .. "music/random.svg"
theme.music_repeat_icon = theme.icon_dir .. "music/repeat.svg"
theme.music_single_icon = theme.icon_dir .. "music/single.svg"
theme.music_icon_opacity = 0.7
theme.music_title_opacity = 0.8
theme.music_artist_opacity = 0.5
theme.music_bg_opacity = 0.5
theme.music_cover_round = dpi(0)
theme.music_cover_margin = dpi(0)
theme.music_notify_timeout = 2




---------------------------------------------------------------------------------------
------------------------------------ fcitx --------------------------------------------
---------------------------------------------------------------------------------------
--theme.fcitx_icon = theme.icon_dir .. "fcitx/keyboard.svg"
----theme.fcitx_font = "JetBrainsMono NFP 8.5"
--theme.fcitx_font = "Microsoft YaHei UI 9"
--theme.fcitx_bg = theme.widget_bg
--theme.fcitx_fg = theme.fg
--theme.fcitx_pinyin_icon = theme.icon_dir .. "fcitx/pinyin.svg"
--theme.fcitx_pinyin_font = "Microsoft YaHei UI Bold 9"
--theme.fcitx_pinyin_bg = "#f6c177"
--theme.fcitx_pinyin_fg = theme.bg



---------------------------------------------------------------------------------------
------------------------------------ weather ------------------------------------------
---------------------------------------------------------------------------------------
theme.weather_font	 = "Microsoft YaHei UI 9"
theme.weather_icon = theme.icon_dir .. "weather/weather.svg"
theme.temperature_icon = theme.icon_dir .. "weather/temperature.svg"
theme.humidity_icon = theme.icon_dir .. "weather/humidity.svg"



---------------------------------------------------------------------------------------
----------------------------------- netspeed ------------------------------------------
---------------------------------------------------------------------------------------
theme.netspeed_up_icon			= theme.icon_dir .. "netspeed/netspeed-up.svg"
theme.netspeed_up_active_icon	= theme.icon_dir .. "netspeed/netspeed-up-active.svg"
theme.netspeed_down_icon		= theme.icon_dir .. "netspeed/netspeed-down.svg"
theme.netspeed_down_active_icon	= theme.icon_dir .. "netspeed/netspeed-down-active.svg"
theme.netspeed_font             = "Terminus Bold 7"



---------------------------------------------------------------------------------------
----------------------------------- cpu -----------------------------------------------
---------------------------------------------------------------------------------------
theme.cpu_graph_mask_img   = theme.icon_dir .. "cpu/cpu_graph_mask.svg"
theme.cpu_title_font       = "JetBrainsMono NFP Bold 9"
theme.cpu_font             = "JetBrainsMono NFP 8"



---------------------------------------------------------------------------------------
----------------------------------- mem -----------------------------------------------
---------------------------------------------------------------------------------------
theme.mem_graph_mask_img   = theme.cpu_graph_mask_img
theme.mem_buffer_color     = "#393552"
theme.mem_title_font       = "JetBrainsMono NFP Bold 9"
theme.mem_font             = "JetBrainsMono NFP 8"



---------------------------------------------------------------------------------------
-------------------------------------- disk -------------------------------------------
---------------------------------------------------------------------------------------
theme.disk_title_font            = "JetBrainsMono NFP Bold 9"
theme.disk_font                  = "JetBrainsMono NFP 8"
theme.disk_bold_font             = "JetBrainsMono NFP Bold 8"
theme.disk_part_bg_normal        = theme.popup_bg
theme.disk_part_bg_hover         = theme.widget_bg_hover
theme.disk_part_bg_mounted       = "#1f1d2e"
theme.disk_bg_progressbar_normal = "#26233a"
theme.disk_line_mounted_bg       = "#c4a7e7"
theme.disk_line_unmounted_bg     = theme.popup_bg
theme.disk_button_bg             = "#1f1d2e"
theme.disk_icon					 = theme.icon_dir .. "disk/disk.svg"
theme.hhd_icon					 = theme.icon_dir .. "disk/hhd.svg"
theme.usb_icon					 = theme.icon_dir .. "disk/usb.svg"
theme.ssd_icon					 = theme.icon_dir .. "disk/ssd.svg"
theme.mount_icon				 = theme.icon_dir .. "disk/mount.svg"
theme.eject_icon				 = theme.icon_dir .. "disk/eject.svg"
theme.folder_icon                = theme.icon_dir .. "disk/folder.svg"
theme.serial_icon				 = theme.icon_dir .. "disk/serial.svg"



---------------------------------------------------------------------------------------
----------------------------------- v2ray icon ----------------------------------------
---------------------------------------------------------------------------------------
theme.v2ray_icon			= theme.icon_dir .. "v2ray/v2ray.svg"
theme.v2ray_off_icon			= theme.icon_dir .. "v2ray/v2ray-off.svg"
theme.switch_on_icon			= theme.icon_dir .. "v2ray/switch-on.svg"
theme.switch_off_icon			= theme.icon_dir .. "v2ray/switch-off.svg"



---------------------------------------------------------------------------------------
---------------------------------- wifi icon ------------------------------------------
---------------------------------------------------------------------------------------
theme.wifi_widget_font          = "JetBrainsMono NFP 8.5"
theme.wifi_title_font           = "JetBrainsMono NFP Bold 9"
theme.wifi_font                 = "JetBrainsMono NFP 8"
theme.wifi_bold_font            = "JetBrainsMono NFP Bold 8"
theme.wifi_bar_fg               = sc("#9ece6a", "#9ece6a")
theme.wifi_bar_bg               = sc("#222436", "#222436")
theme.wifi_signal_0_icon		= theme.icon_dir .. "wifi/wifi-0.svg"
theme.wifi_signal_1_icon		= theme.icon_dir .. "wifi/wifi-1.svg"
theme.wifi_signal_2_icon		= theme.icon_dir .. "wifi/wifi-2.svg"
theme.wifi_signal_3_icon		= theme.icon_dir .. "wifi/wifi-3.svg"
theme.wifi_disconnect_icon		= theme.icon_dir .. "wifi/wifi-disconnect.svg"



---------------------------------------------------------------------------------------
--------------------------------battery / brightness ----------------------------------
---------------------------------------------------------------------------------------
theme.brightness_icon			= theme.icon_dir .. "brightness/brightness.svg"
theme.brightness_1_icon			= theme.icon_dir .. "brightness/brightness-1.svg"
theme.brightness_2_icon			= theme.icon_dir .. "brightness/brightness-2.svg"
theme.brightness_3_icon			= theme.icon_dir .. "brightness/brightness-3.svg"



---------------------------------------------------------------------------------------
----------------------------------- volume --------------------------------------------
---------------------------------------------------------------------------------------
theme.vol_widget_font           = "JetBrainsMono NFP 8.5"
theme.vol_title_font            = "JetBrainsMono NFP Bold 9"
theme.vol_font                  = "JetBrainsMono NFP 8"
theme.vol_bold_font             = "JetBrainsMono NFP Bold 8"
theme.vol_widget_bar_fg         = "#c4a7e7"
theme.vol_widget_bar_mute_fg    = "#eb6f92"
theme.vol_widget_bar_bg         = "#26233a"
theme.vol_widget_bar_bg_hover   = "#393552"
theme.vol_sink_sel_bg           = "#1f1d2e"
theme.vol_sink_mute_line_bg     = "#eb6f92"
theme.vol_sink_sel_line_bg      = "#c4a7e7"
theme.vol_sink_unsel_line_bg    = theme.popup_bg
theme.vol_sink_unsel_bg         = theme.popup_bg
theme.vol_mute_icon		        = theme.icon_dir .. "volume/vol_mute.svg"
theme.vol_100_icon		        = theme.icon_dir .. "volume/vol-100.svg"
theme.vol_70_icon		        = theme.icon_dir .. "volume/vol-70.svg"
theme.vol_40_icon		        = theme.icon_dir .. "volume/vol-40.svg"
theme.vol_10_icon		        = theme.icon_dir .. "volume/vol-10.svg"
theme.vol_0_icon		        = theme.icon_dir .. "volume/vol-0.svg"
theme.vol_bar_0_icon	        = theme.icon_dir .. "volume/vol-bar-0.svg"
theme.vol_bar_10_icon	        = theme.icon_dir .. "volume/vol-bar-10.svg"
theme.vol_bar_40_icon	        = theme.icon_dir .. "volume/vol-bar-40.svg"
theme.vol_bar_70_icon	        = theme.icon_dir .. "volume/vol-bar-70.svg"
theme.vol_bar_100_icon	        = theme.icon_dir .. "volume/vol-bar-100.svg"
theme.vol_speaker_icon	        = theme.icon_dir .. "volume/speaker.svg"



---------------------------------------------------------------------------------------
----------------------------------- layoutbox -----------------------------------------
---------------------------------------------------------------------------------------
theme.layout_floating			= theme.icon_dir .. "layouts/floating.svg"
theme.layout_max				= theme.icon_dir .. "layouts/tilemax.svg"
theme.layout_tile				= theme.icon_dir .. "layouts/tile.svg"
theme.layout_tileleft 			= theme.icon_dir .. "layouts/tileleft.svg"
theme.layout_tilebottom			= theme.icon_dir .. "layouts/tilebottom.svg"
theme.layout_tiletop			= theme.icon_dir .. "layouts/tiletop.svg"
theme.layout_fairv				= theme.icon_dir .. "layouts/fairv.svg"
theme.layout_fairh 				= theme.icon_dir .. "layouts/fairh.svg"



---------------------------------------------------------------------------------------
----------------------------------- promptbox -----------------------------------------
---------------------------------------------------------------------------------------
theme.prompt_font				= "JetBrainsMono NFP 9"
theme.terminal_icon				= theme.icon_dir .. "promptbox/terminal.svg"



---------------------------------------------------------------------------------------
----------------------------------- titlebar ------------------------------------------
---------------------------------------------------------------------------------------
theme.titlebar_fg_focus  = theme.fg
theme.titlebar_bg_focus  = theme.bg
theme.titlebar_height    = dpi(30)
theme.titlebar_fg_normal = sc("#aaaaaa", "#3b4261")
theme.titlebar_bg_normal = sc("#f1f1f1", theme.bg)

theme.titlebar_close_button_normal                     = theme.icon_dir .. "titlebar/titlebutton-close-normal.svg"
theme.titlebar_close_button_focus                      = theme.icon_dir .. "titlebar/titlebutton-close.svg"
theme.titlebar_close_button_focus_hover                = theme.icon_dir .. "titlebar/titlebutton-close-hover.svg"
theme.titlebar_close_button_focus_press                = theme.icon_dir .. "titlebar/titlebutton-close-active.svg"
theme.titlebar_close_button_normal_hover               = theme.icon_dir .. "titlebar/titlebutton-close-hover.svg"
theme.titlebar_close_button_normal_press               = theme.icon_dir .. "titlebar/titlebutton-close-active.svg"

theme.titlebar_maximized_button_normal_inactive        = theme.icon_dir .. "titlebar/titlebutton-maximize-normal.svg"
theme.titlebar_maximized_button_focus_inactive         = theme.icon_dir .. "titlebar/titlebutton-maximize.svg"
theme.titlebar_maximized_button_focus_inactive_hover   = theme.icon_dir .. "titlebar/titlebutton-maximize-hover.svg"
theme.titlebar_maximized_button_focus_inactive_press   = theme.icon_dir .. "titlebar/titlebutton-maximize-active.svg"
theme.titlebar_maximized_button_normal_inactive_hover  = theme.icon_dir .. "titlebar/titlebutton-maximize-hover.svg"
theme.titlebar_maximized_button_normal_inactive_press  = theme.icon_dir .. "titlebar/titlebutton-maximize-active.svg"

theme.titlebar_maximized_button_normal_active          = theme.icon_dir .. "titlebar/titlebutton-maximize-normal.svg"
theme.titlebar_maximized_button_focus_active           = theme.icon_dir .. "titlebar/titlebutton-maximize.svg"
theme.titlebar_maximized_button_focus_active_hover     = theme.icon_dir .. "titlebar/titlebutton-unmaximize-hover.svg"
theme.titlebar_maximized_button_focus_active_press     = theme.icon_dir .. "titlebar/titlebutton-unmaximize-active.svg"
theme.titlebar_maximized_button_normal_active_hover    = theme.icon_dir .. "titlebar/titlebutton-unmaximize-hover.svg"
theme.titlebar_maximized_button_normal_active_press    = theme.icon_dir .. "titlebar/titlebutton-unmaximize-active.svg"

theme.titlebar_minimize_button_normal                  = theme.icon_dir .. "titlebar/titlebutton-minimize-normal.svg"
theme.titlebar_minimize_button_focus                   = theme.icon_dir .. "titlebar/titlebutton-minimize.svg"
theme.titlebar_minimize_button_focus_hover             = theme.icon_dir .. "titlebar/titlebutton-minimize-hover.svg"
theme.titlebar_minimize_button_focus_press             = theme.icon_dir .. "titlebar/titlebutton-minimize-active.svg"
theme.titlebar_minimize_button_normal_hover            = theme.icon_dir .. "titlebar/titlebutton-minimize-hover.svg"
theme.titlebar_minimize_button_normal_press            = theme.icon_dir .. "titlebar/titlebutton-minimize-active.svg"

theme.titlebar_floating_button_normal_inactive         = theme.icon_dir .. "titlebar/floating-normal-inactive.svg"
theme.titlebar_floating_button_focus_inactive          = theme.icon_dir .. "titlebar/floating-normal.svg"
theme.titlebar_floating_button_focus_inactive_hover    = theme.icon_dir .. "titlebar/floating.svg"
theme.titlebar_floating_button_focus_inactive_press    = theme.icon_dir .. "titlebar/floating-normal.svg"
theme.titlebar_floating_button_normal_active           = theme.icon_dir .. "titlebar/floating-normal-active.svg"
theme.titlebar_floating_button_focus_active            = theme.icon_dir .. "titlebar/floating.svg"
theme.titlebar_floating_button_normal_inactive_hover   = theme.icon_dir .. "titlebar/floating-normal-active.svg"

theme.titlebar_ontop_button_normal_inactive            = theme.icon_dir .. "titlebar/ontop-normal-inactive.svg"
theme.titlebar_ontop_button_focus_inactive             = theme.icon_dir .. "titlebar/ontop-normal.svg"
theme.titlebar_ontop_button_focus_inactive_hover       = theme.icon_dir .. "titlebar/ontop.svg"
theme.titlebar_ontop_button_focus_inactive_press       = theme.icon_dir .. "titlebar/ontop-normal.svg"
theme.titlebar_ontop_button_normal_active              = theme.icon_dir .. "titlebar/ontop-normal-active.svg"
theme.titlebar_ontop_button_focus_active               = theme.icon_dir .. "titlebar/ontop.svg"
theme.titlebar_ontop_button_normal_inactive_hover      = theme.icon_dir .. "titlebar/ontop-normal-active.svg"

theme.titlebar_sticky_button_normal_inactive           = theme.icon_dir .. "titlebar/sticky-normal-inactive.svg"
theme.titlebar_sticky_button_focus_inactive            = theme.icon_dir .. "titlebar/sticky-normal.svg"
theme.titlebar_sticky_button_focus_inactive_hover      = theme.icon_dir .. "titlebar/sticky.svg"
theme.titlebar_sticky_button_focus_inactive_press      = theme.icon_dir .. "titlebar/sticky-normal.svg"
theme.titlebar_sticky_button_normal_active             = theme.icon_dir .. "titlebar/sticky-normal-active.svg"
theme.titlebar_sticky_button_focus_active              = theme.icon_dir .. "titlebar/sticky.svg"
theme.titlebar_sticky_button_normal_inactive_hover     = theme.icon_dir .. "titlebar/sticky-normal-active.svg"



return theme
