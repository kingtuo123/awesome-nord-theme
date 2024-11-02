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
theme.useless_gap       = dpi(-0.5)
--theme.gap_single_client = false
theme.border_width      = dpi(1)
theme.border_rounded    = dpi(8)
theme.font				= "Microsoft YaHei UI 9"
theme.fg                = sc("#000000", "#c8d3f5")
theme.bg                = sc("#eeeeee", "#1b1d2b")
theme.border_normal     = sc("#bbbbbb", "#3b4261")
theme.border_focus      = sc("#bbbbbb", "#3b4261")

awful.mouse.snap.client_enabled = true
awful.mouse.snap.edge_enabled = false
awful.mouse.snap.default_distance = dpi(20)
awful.mouse.snap.aerosnap_distance = dpi(20)
theme.snap_border_width = dpi(2)
theme.snap_bg           = sc("#86e1fc", "#c099ff")
theme.snap_shape        = gears.shape.rectangle



---------------------------------------------------------------------------------------
--------------------------------- topbar widget ---------------------------------------
---------------------------------------------------------------------------------------
theme.topbar_height         = dpi(33)
theme.topbar_border_width   = dpi(1)
theme.topbar_fg 			= theme.fg
theme.topbar_bg				= sc(theme.bg, "#1b1d2b")
theme.topbar_border_color   = sc("#bbbbbb", "#3b4261")
theme.widget_rounded        = dpi(5)
theme.widget_border_width   = dpi(3)
theme.widget_border_color   = sc(""       , "")
theme.widget_bg_hover       = sc("#ffffff", "#222436")
theme.widget_bg_press       = sc("#ffffff", "#222436")
theme.widget_fg_press       = sc("#000000", theme.fg)
theme.widget_bg_graph       = sc("#222436", "#12131d")



---------------------------------------------------------------------------------------
------------------------------------ popup --------------------------------------------
---------------------------------------------------------------------------------------
theme.popup_fg 			   = theme.fg
theme.popup_bg 			   = sc("#f2f2f2", theme.bg)
theme.popup_rounded		   = dpi(8)
theme.popup_border_width   = dpi(1)
theme.popup_border_color   = theme.border_normal
theme.popup_margin_top	   = theme.topbar_height + dpi(6)
theme.popup_margin_right   = dpi(5)
theme.popup_fg_progressbar = sc("#0067c0", "#86e1fc")
theme.popup_bg_progressbar = sc("#ffffff", "#222436")
theme.popup_bg_graph       = sc("#222436", "#12131d" )
theme.popup_progress_border_color = sc("#dddddd", "#3b4261")



---------------------------------------------------------------------------------------
--------------------------------- taglist ---------------------------------------------
---------------------------------------------------------------------------------------
theme.taglist_font              = "JetBrainsMono NFP 9"
theme.taglist_width        		= dpi(33)
theme.taglist_spacing      		= dpi(0)
theme.taglist_fg_focus     		= sc("#000000", theme.fg)
theme.taglist_bg_focus     		= sc("#ffffff", "#222436")
theme.taglist_fg_occupied  		= sc("#000000", theme.fg)
theme.taglist_bg_occupied  		= sc("#eeeeee", theme.bg )
theme.taglist_bg_empty     		= sc("#eeeeee", theme.bg )
theme.taglist_fg_empty     		= sc("#b9b9b9", "#3b4261")
theme.taglist_squares_resize	= true
theme.taglist_squares_sel  		= theme.icon_dir .. "taglist/tag_sel.svg"
theme.taglist_squares_sel_empty = theme.icon_dir .. "taglist/tag_sel.svg"
theme.taglist_squares_unsel 	= theme.icon_dir .. "taglist/tag_sel_occ.svg"



---------------------------------------------------------------------------------------
--------------------------------- tasklist --------------------------------------------
---------------------------------------------------------------------------------------
theme.icon_theme		         = "Fluent-dark"
theme.tasklist_icon_size         = dpi(20)
theme.tasklist_width        	 = dpi(33)
theme.tasklist_spacing           = dpi(0)
theme.tasklist_bg_focus          = sc("#ffffff", "#222436")
theme.tasklist_bg_normal         = theme.bg
theme.tasklist_bg_minimize       = theme.bg
theme.tasklist_bg_image_focus    = theme.icon_dir .. "taglist/tag_sel.svg"
theme.tasklist_bg_image_normal   = theme.icon_dir .. "taglist/tag_sel_occ.svg"



---------------------------------------------------------------------------------------
---------------------------------- calendar -------------------------------------------
---------------------------------------------------------------------------------------
theme.clock_font	 = "Microsoft YaHei UI 9"
theme.cal_font       = "JetBrainsMono NFP 9"
theme.cal_header_fg  = theme.fg
theme.cal_weekday_fg = sc("#0067c0", "#86e1fc")
theme.cal_fg_normal  = theme.fg
theme.cal_fg_focus   = theme.popup_bg
theme.cal_bg_focus   = sc("#0067c0", "#86e1fc") 
theme.cal_week_06_bg = sc("#ffffff", "#222436" ) 
theme.cal_rounded    = dpi(5)
theme.cal_default_padding = {top = dpi(6), bottom = dpi(6), left = dpi(8), right = dpi(8)}



---------------------------------------------------------------------------------------
----------------------------------- music -----------------------------------------------
---------------------------------------------------------------------------------------
theme.music_font	 = "Microsoft YaHei UI 9"
theme.music_font1	 = "Microsoft YaHei UI 8.5"
theme.music_icon = theme.icon_dir .. "music/music.svg"
theme.music_off_icon = theme.icon_dir .. "music/music-off.svg"
theme.music_next_icon = theme.icon_dir .. "music/next.svg"
theme.music_prev_icon = theme.icon_dir .. "music/prev.svg"
theme.music_play_icon = theme.icon_dir .. "music/play.svg"
theme.music_pause_icon = theme.icon_dir .. "music/pause.svg"
theme.music_cover_image = theme.icon_dir .. "music/cover.svg"
theme.music_lyric_icon = theme.icon_dir .. "music/lyric.svg"
theme.music_lyric_press_icon = theme.icon_dir .. "music/lyric-press.svg"
theme.music_playlist_icon = theme.icon_dir .. "music/playlist.svg"



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
theme.mem_buffer_color     = "#3b4261"
theme.mem_title_font       = "JetBrainsMono NFP Bold 9"
theme.mem_font             = "JetBrainsMono NFP 8"



---------------------------------------------------------------------------------------
-------------------------------------- disk -------------------------------------------
---------------------------------------------------------------------------------------
theme.disk_title_font            = "JetBrainsMono NFP Bold 9"
theme.disk_font                  = "JetBrainsMono NFP 8"
theme.disk_bold_font             = "JetBrainsMono NFP Bold 8"
theme.disk_part_bg_normal        = sc("#f2f2f2", theme.popup_bg)
theme.disk_part_bg_hover         = sc("#ffffff", theme.widget_bg_hover)
theme.disk_part_bg_mounted       = sc("#e8e8e8", "#222436" )
theme.disk_shape_border_color    = sc("#d9d9d9", "#3b4261")
theme.disk_bg_progressbar_normal = sc("#ffffff", "#2d3146")
theme.disk_line_mounted_bg       = "#86e1fc"
theme.disk_line_unmounted_bg       = theme.popup_bg
theme.disk_button_bg             = "#222436"
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
theme.vol_sink_sel_bg           = "#222436"
theme.vol_sink_mute_line_bg     = "#ff757f"
theme.vol_sink_sel_line_bg      = "#86e1fc"
theme.vol_sink_unsel_line_bg    = theme.popup_bg
theme.vol_sink_unsel_bg         = theme.popup_bg
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
