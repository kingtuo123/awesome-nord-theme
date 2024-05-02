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
theme.border_width      = dpi(1)
theme.border_rounded    = dpi(0)
theme.font				= "Microsoft YaHei UI 9"
theme.fg                = sc("#000000", "#c0caf5")
theme.bg                = sc("#eeeeee", "#1d202f")
theme.border_normal     = sc("#bbbbbb", "#404666")
theme.border_focus      = sc("#bbbbbb", "#404666")

awful.mouse.snap.client_enabled = false
awful.mouse.snap.edge_enabled = false
theme.snap_border_width = dpi(2)
theme.snap_bg           = sc("#7dcfff", "#bb9af7")
theme.snap_shape        = gears.shape.rectangle



---------------------------------------------------------------------------------------
--------------------------------- topbar widget ---------------------------------------
---------------------------------------------------------------------------------------
theme.topbar_height         = dpi(31)
theme.topbar_border_width   = dpi(1)
theme.topbar_fg 			= theme.fg
theme.topbar_bg				= theme.bg
theme.topbar_border_color   = sc("#bbbbbb", "#404666")
theme.widget_rounded        = dpi(0)
theme.widget_border_width   = dpi(0)
theme.widget_border_color   = sc(""       , "#404666")
theme.widget_bg_hover       = sc("#ffffff", "#24283b")
theme.widget_bg_press       = sc("#ffffff", "#24283b")
theme.widget_fg_press       = sc("#000000", "#c0caf5")
theme.widget_bg_graph       = sc("#24283b", "#131620")



---------------------------------------------------------------------------------------
------------------------------------ popup --------------------------------------------
---------------------------------------------------------------------------------------
theme.popup_fg 			   = theme.fg
theme.popup_bg 			   = sc("#f2f2f2", theme.bg)
theme.popup_rounded		   = dpi(0)
theme.popup_border_width   = dpi(1)
theme.popup_border_color   = theme.border_normal
theme.popup_margin_top	   = theme.topbar_height + dpi(6)
theme.popup_margin_right   = dpi(5)
theme.popup_fg_progressbar = sc("#0067c0", "#7aa2f7")
theme.popup_bg_progressbar = sc("#ffffff", "#24283b")
theme.popup_bg_graph       = sc("#24283b", "#131620" )
theme.popup_progress_border_color = sc("#dddddd", "#404666")



---------------------------------------------------------------------------------------
--------------------------------- taglist ---------------------------------------------
---------------------------------------------------------------------------------------
theme.taglist_width        		= dpi(31)
theme.taglist_spacing      		= dpi(0)
theme.taglist_fg_focus     		= sc("#000000", "#c0caf5")
theme.taglist_bg_focus     		= sc("#ffffff", "#24283b")
theme.taglist_fg_occupied  		= sc("#000000", "#c0caf5")
theme.taglist_bg_occupied  		= sc("#eeeeee", theme.bg )
theme.taglist_bg_empty     		= sc("#eeeeee", theme.bg )
theme.taglist_fg_empty     		= sc("#b9b9b9", "#404666")
theme.taglist_squares_resize	= true
theme.taglist_squares_sel  		= theme.icon_dir .. "taglist/tag_sel.svg"
theme.taglist_squares_sel_empty = theme.icon_dir .. "taglist/tag_sel.svg"
theme.taglist_squares_unsel 	= theme.icon_dir .. "taglist/tag_sel_occ.svg"



---------------------------------------------------------------------------------------
--------------------------------- tasklist --------------------------------------------
---------------------------------------------------------------------------------------
theme.icon_theme		         = "Fluent-dark"
theme.tasklist_icon_size         = dpi(20)
theme.tasklist_width        	 = dpi(31)
theme.tasklist_spacing           = dpi(0)
theme.tasklist_bg_focus          = sc("#ffffff", "#24283b")
theme.tasklist_bg_normal         = theme.bg
theme.tasklist_bg_minimize       = theme.bg
theme.tasklist_bg_image_focus    = theme.icon_dir .. "taglist/tag_sel.svg"
theme.tasklist_bg_image_normal   = theme.icon_dir .. "taglist/tag_sel_occ.svg"



---------------------------------------------------------------------------------------
---------------------------------- calendar -------------------------------------------
---------------------------------------------------------------------------------------
theme.cal_header_fg  = theme.fg
theme.cal_weekday_fg = sc("#0067c0", "#7aa2f7")
theme.cal_fg_normal  = theme.fg
theme.cal_fg_focus   = theme.popup_bg
theme.cal_bg_focus   = sc("#0067c0", "#82aaff") 
theme.cal_week_06_bg = sc("#ffffff", "#24283b" ) 
theme.cal_default_padding = {top = dpi(6), bottom = dpi(6), left = dpi(4), right = dpi(4)}



---------------------------------------------------------------------------------------
----------------------------------- netspeed ------------------------------------------
---------------------------------------------------------------------------------------
theme.netspeed_up_icon			= theme.icon_dir .. "netspeed/netspeed-up.svg"
theme.netspeed_up_active_icon	= theme.icon_dir .. "netspeed/netspeed-up-active.svg"
theme.netspeed_down_icon		= theme.icon_dir .. "netspeed/netspeed-down.svg"
theme.netspeed_down_active_icon	= theme.icon_dir .. "netspeed/netspeed-down-active.svg"



---------------------------------------------------------------------------------------
----------------------------------- cpu -----------------------------------------------
---------------------------------------------------------------------------------------
theme.cpu_graph_mask_img   = theme.icon_dir .. "cpu/cpu_graph_mask.svg"



---------------------------------------------------------------------------------------
----------------------------------- mem -----------------------------------------------
---------------------------------------------------------------------------------------
theme.mem_graph_mask_img   = theme.cpu_graph_mask_img



---------------------------------------------------------------------------------------
-------------------------------------- disk -------------------------------------------
---------------------------------------------------------------------------------------
theme.disk_part_bg_normal        = sc("#f2f2f2", theme.popup_bg)
theme.disk_part_bg_hover         = sc("#ffffff", theme.widget_bg_hover)
theme.disk_part_bg_mounted       = sc("#e8e8e8", "#24283b" )
theme.disk_eject_bg_normal       = sc("#fbfbfb", "#333852" )
theme.disk_eject_bg_hover        = sc("#f6f6f6", "#404666"  )
theme.disk_bg_progressbar_normal = sc("#ffffff", "#24283b")
theme.disk_shape_border_color    = sc("#d9d9d9", "#404666")
theme.disk_icon					 = theme.icon_dir .. "disk/disk.svg"
theme.hhd_icon					 = theme.icon_dir .. "disk/hhd.svg"
theme.usb_icon					 = theme.icon_dir .. "disk/usb.svg"
theme.ssd_icon					 = theme.icon_dir .. "disk/ssd.svg"
theme.mount_icon				 = theme.icon_dir .. "disk/mount.svg"
theme.eject_icon				 = theme.icon_dir .. "disk/eject.svg"
theme.folder_icon                = theme.icon_dir .. "disk/folder.svg"
theme.serial_icon				 = theme.icon_dir .. "disk/serial.svg"



---------------------------------------------------------------------------------------
----------------------------------- vpn icon ------------------------------------------
---------------------------------------------------------------------------------------
theme.vpn_on_icon				= theme.icon_dir .. "vpn/vpn-on.svg"
theme.vpn_off_icon				= theme.icon_dir .. "vpn/vpn-off.svg"
theme.switch_on_icon			= theme.icon_dir .. "vpn/switch-on.svg"
theme.switch_off_icon			= theme.icon_dir .. "vpn/switch-off.svg"



---------------------------------------------------------------------------------------
---------------------------------- wifi icon ------------------------------------------
---------------------------------------------------------------------------------------
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
theme.vol_sink_sel_bg           = "#24283b"
theme.vol_sink_mute_line_bg     = "#f7768e"
theme.vol_sink_sel_line_bg      = "#7dcfff"
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
theme.prompt_font				= "Microsoft YaHei 10"
theme.terminal_icon				= theme.icon_dir .. "promptbox/terminal.svg"



---------------------------------------------------------------------------------------
----------------------------------- titlebar ------------------------------------------
---------------------------------------------------------------------------------------
theme.titlebar_fg_focus  = theme.fg
theme.titlebar_bg_focus  = theme.bg
theme.titlebar_height    = dpi(30)
theme.titlebar_fg_normal = sc("#aaaaaa", "#404666")
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
