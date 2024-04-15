local dpi	= require("beautiful.xresources").apply_dpi


theme = {}


theme.style     = "dark"
--theme.style     = "light"
theme.dir       = os.getenv("HOME") .. "/.config/awesome/"
theme.icon_dir  = os.getenv("HOME") .. "/.config/awesome/icons/light/"


theme.dark0  = "#242933"
theme.dark1  = "#2e3440"
theme.dark2  = "#3b4252"
theme.dark3  = "#434c5e"
theme.dark4  = "#4c566a"

theme.light0 = "#ffffff"
theme.light1 = "#eceff4"
theme.light2 = "#e5e9f0"
theme.light3 = "#d8dee9"

theme.blue0  = "#8fbcbb"
theme.blue1  = "#88c0d0"
theme.blue2  = "#81a1c1"
theme.blue3  = "#5e81ac"

theme.red    = "#bf616a"
theme.orange = "#d08770"
theme.yellow = "#ebcb8b"
theme.green  = "#a3be8c"
theme.purple = "#b48ead"



--theme.black   = '#654735'
--theme.red     = '#c14a4a'
--theme.green   = '#6c782e'
--theme.yellow  = '#b47109'
--theme.blue    = '#45707a'
--theme.magenta = '#945e80'
--theme.cyan    = '#4c7a5d'
--theme.white   = '#eee0b7'


local function sel_col(...)
	local arg = {...}
	if theme.style == "dark" then
		return arg[1]
	elseif theme.style == "light" then
		return arg[2]
	else
		return ""
	end
end








theme.font				= "Microsoft YaHei 9"
--theme.font 				= "DejaVu Serif Book 9"
theme.prompt_font		= "Microsoft YaHei 10"
theme.useless_gap       = dpi(-0.5)
theme.border_width      = dpi(1)
theme.border_rounded    = dpi(0)
theme.titlebar_height   = dpi(30)
theme.snap_border_width = dpi(2)

theme.fg                = "#222f3e"
theme.bg                = theme.red


--theme.border_normal     = "#33333366"
--theme.border_focus      = "#33333366"
theme.border_normal     = "#bbbbbb"
theme.border_focus      = "#bbbbbb"
theme.snap_bg           = "#0067c0"



---------------------------------------------------------------------------------------
--------------------------------- topbar widget ---------------------------------------
---------------------------------------------------------------------------------------
theme.topbar_height         = dpi(31+1)
theme.topbar_fg				= sel_col( "#000000"     , "#FFFFFF" )
theme.topbar_bg				= sel_col( "#eeeeee"     , "#000000" )
theme.widget_border_width   = dpi(0)
theme.widget_border_color   = "#e8e8e8"
theme.widget_rounded        = dpi(0)
theme.widget_bg_hover       = sel_col( "#f1f1f1"  , "#FFFFFF22" )
theme.widget_bg_press       = sel_col( "#ffffff"  , "#FFFFFF22" )
theme.widget_fg_press       = sel_col( "#000000"    , "#FFFFFF"   )
--theme.widget_bg_progressbar = sel_col( theme.dark1          , theme.light1         )



---------------------------------------------------------------------------------------
--------------------------------- taglist ---------------------------------------------
---------------------------------------------------------------------------------------
theme.taglist_width = dpi(31)
theme.taglist_border_width = dpi(0)
theme.taglist_shape_border_color_focus = "#33333314"
theme.taglist_shape_border_color = ""
theme.taglist_shape_border_color_empty = ""
theme.taglist_spacing      = dpi(0)
theme.taglist_fg_focus     = sel_col( "#000000"      , theme.bg     )
theme.taglist_bg_focus     = sel_col( "#ffffff"   , theme.fg     )
theme.taglist_fg_occupied  = sel_col( "#000000"  , theme.dark4  )
theme.taglist_bg_occupied  = sel_col( "#eeeeee"   , theme.light1 )
theme.taglist_bg_empty     = sel_col( "#eeeeee"      , theme.bg     )
theme.taglist_fg_empty     = sel_col( "#33333344"   , theme.light1 )
theme.taglist_bg_hover 	   = sel_col( "#f9f9f9"   , theme.light1 )
theme.taglist_squares_sel = theme.icon_dir .. "taglist/tag_sel.svg"
theme.taglist_squares_sel_empty = theme.icon_dir .. "taglist/tag_sel.svg"
theme.taglist_squares_unsel = theme.icon_dir .. "taglist/tag_sel_occ.svg"
theme.taglist_squares_resize = true



---------------------------------------------------------------------------------------
------------------------------------ popup --------------------------------------------
---------------------------------------------------------------------------------------
theme.popup_margin_top	 = theme.topbar_height + dpi(6)
theme.popup_border_width = dpi(1)
theme.popup_rounded		 = dpi(0)
theme.popup_border_color = theme.border_normal
theme.popup_bg = "#f2f2f2"
theme.popup_fg = "#222f3e"



---------------------------------------------------------------------------------------
----------------------------------- volume --------------------------------------------
---------------------------------------------------------------------------------------
theme.popup_fg_progressbar = theme.blue3
theme.popup_bg_progressbar = "#ffffff"



---------------------------------------------------------------------------------------
----------------------------------- cpu -----------------------------------------------
---------------------------------------------------------------------------------------
theme.cpu_graph_mask_img = theme.icon_dir .. "cpu/cpu_graph_mask.svg"
theme.thread_graph_mask_img = theme.icon_dir .. "cpu/thread_graph_mask.svg"
theme.bg_graph = sel_col( "#222f3e" , theme.dark3 )
theme.widget_bg_graph = sel_col( "#222f3e" , theme.dark3 )


---------------------------------------------------------------------------------------
--------------------------------- tasklist --------------------------------------------
---------------------------------------------------------------------------------------
theme.icon_theme		         = "Fluent"
theme.tasklist_icon_size         = dpi(20)
theme.tasklist_width        	 = dpi(32)
theme.tasklist_line_width        = dpi(16)
theme.tasklist_spacing           = dpi(0)
theme.tasklist_disable_task_name = true
theme.tasklist_bg_focus          = sel_col( "#ffffff"  , theme.light1 )
theme.tasklist_bg_normal         = sel_col( "#eeeeee"     , theme.bg     )
theme.tasklist_bg_minimize       = sel_col( "#eeeeee"     , theme.bg     )
theme.tasklist_bg_line           = theme.red
theme.tasklist_bg_hover          = "#f9f9f9"
theme.tasklist_shape_border_color = ""
theme.tasklist_shape_border_color_focus = "#33333314"
theme.tasklist_bg_image_focus = theme.icon_dir .. "taglist/tag_sel.svg"
theme.tasklist_bg_image_normal = theme.icon_dir .. "taglist/tag_sel_occ.svg"



---------------------------------------------------------------------------------------
----------------------------------- titlebar ------------------------------------------
---------------------------------------------------------------------------------------
theme.titlebar_fg_normal = sel_col( "#33333366"  , theme.light3 )
theme.titlebar_bg_normal = sel_col( "#f1f1f1"  , theme.light1 )
theme.titlebar_fg_focus  = sel_col( "#000000"     , theme.fg     )
theme.titlebar_bg_focus  = sel_col( "#e8e8e8"  , theme.bg     )



---------------------------------------------------------------------------------------
---------------------------------- calendar -------------------------------------------
---------------------------------------------------------------------------------------
theme.cal_header_fg  = sel_col( "#000000"      , theme.fg     ) 
theme.cal_weekday_fg = sel_col( "#0067c0"   , theme.blue3 )
theme.cal_fg_normal  = sel_col( "#000000"     , theme.fg     ) 
theme.cal_fg_focus   = sel_col( "#ffffff"   , theme.red     ) 
theme.cal_bg_focus   = sel_col( "#0067c0"   , theme.red     ) 
--theme.cal_bg_focus   = sel_col( "#0067c0"   , theme.red     ) 
theme.cal_week_06_bg = sel_col( "#ffffff"   , theme.light1 ) 



---------------------------------------------------------------------------------------
----------------------------------- panel ---------------------------------------------
---------------------------------------------------------------------------------------
theme.panel_avatar_img 	   = theme.icon_dir .. "panel/avatar.jpg"
theme.panel_border_width   = dpi(10)
theme.panel_bg_normal      = sel_col( theme.dark1         , theme.light1 )
theme.panel_bg_press       = sel_col( theme.dark1         , theme.light1 )
theme.panel_bg_hover       = sel_col( theme.dark2 .. "aa" , theme.light0 )
theme.panel_fg_progressbar = sel_col( theme.blue3         , theme.blue3  )
theme.panel_bg_progressbar = sel_col( theme.dark3         , theme.light3 )




---------------------------------------------------------------------------------------
----------------------------------- disk popup ----------------------------------------
---------------------------------------------------------------------------------------
theme.disk_part_bg_normal        = sel_col( "#f2f2f2"  , theme.light1 )
theme.disk_part_bg_hover         = sel_col( "#f9f9f9"          , theme.light0 )
theme.disk_part_bg_mounted       = sel_col( "#e8e8e8"          , theme.light0 )
theme.disk_eject_bg_normal       = sel_col( "#fbfbfb"          , theme.light3 )
theme.disk_eject_bg_hover        = sel_col( "#f6f6f6"          , theme.blue2  )
theme.disk_bg_progressbar_normal = sel_col( "#eeeeee"          , theme.light1 )
theme.disk_bg_progressbar_hover  = sel_col( "#ffffff"          , theme.light1 )
theme.disk_shape_border_color    = "#d9d9d9"








---------------------------------------------------------------------------------------
---------------------------------- wifi icon ------------------------------------------
---------------------------------------------------------------------------------------
theme.wifi_signal_0_icon		= theme.icon_dir .. "wifi/wifi-0.svg"
theme.wifi_signal_1_icon		= theme.icon_dir .. "wifi/wifi-1.svg"
theme.wifi_signal_2_icon		= theme.icon_dir .. "wifi/wifi-2.svg"
theme.wifi_signal_3_icon		= theme.icon_dir .. "wifi/wifi-3.svg"
theme.wifi_disconnect_icon		= theme.icon_dir .. "wifi/wifi-disconnect.svg"



---------------------------------------------------------------------------------------
----------------------------------- brightness icon -----------------------------------
---------------------------------------------------------------------------------------
theme.brightness_icon			= theme.icon_dir .. "brightness/brightness.svg"
theme.brightness_1_icon			= theme.icon_dir .. "brightness/brightness-1.svg"
theme.brightness_2_icon			= theme.icon_dir .. "brightness/brightness-2.svg"
theme.brightness_3_icon			= theme.icon_dir .. "brightness/brightness-3.svg"



---------------------------------------------------------------------------------------
----------------------------------- vpn icon ------------------------------------------
---------------------------------------------------------------------------------------
theme.vpn_on_icon				= theme.icon_dir .. "vpn/vpn-on.svg"
theme.vpn_off_icon				= theme.icon_dir .. "vpn/vpn-off.svg"
theme.switch_on_icon			= theme.icon_dir .. "vpn/switch-on.svg"
theme.switch_off_icon			= theme.icon_dir .. "vpn/switch-off.svg"



---------------------------------------------------------------------------------------
----------------------------------- netspeed icon -------------------------------------
---------------------------------------------------------------------------------------
theme.netspeed_up_icon			= theme.icon_dir .. "netspeed/netspeed-up.svg"
theme.netspeed_up_active_icon	= theme.icon_dir .. "netspeed/netspeed-up-active.svg"
theme.netspeed_down_icon		= theme.icon_dir .. "netspeed/netspeed-down.svg"
theme.netspeed_down_active_icon	= theme.icon_dir .. "netspeed/netspeed-down-active.svg"



---------------------------------------------------------------------------------------
----------------------------------- disk icon -----------------------------------------
---------------------------------------------------------------------------------------
theme.disk_icon					= theme.icon_dir .. "disk/disk.svg"
theme.hhd_icon					= theme.icon_dir .. "disk/hhd.svg"
theme.usb_icon					= theme.icon_dir .. "disk/usb.svg"
theme.ssd_icon					= theme.icon_dir .. "disk/ssd.svg"
theme.mount_icon				= theme.icon_dir .. "disk/mount.svg"
theme.eject_icon				= theme.icon_dir .. "disk/eject.svg"
theme.folder_icon               = theme.icon_dir .. "disk/folder.svg"
theme.serial_icon				= theme.icon_dir .. "disk/serial.svg"



---------------------------------------------------------------------------------------
----------------------------------- volume icon ---------------------------------------
---------------------------------------------------------------------------------------
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
----------------------------------- layout icon ---------------------------------------
---------------------------------------------------------------------------------------
theme.layout_floating			= theme.icon_dir .. "layouts/floating.svg"
theme.layout_tile				= theme.icon_dir .. "layouts/tile.svg"
theme.layout_tileleft 			= theme.icon_dir .. "layouts/tileleft.svg"
theme.layout_tilebottom			= theme.icon_dir .. "layouts/tilebottom.svg"
theme.layout_tiletop			= theme.icon_dir .. "layouts/tiletop.svg"
theme.layout_fairv				= theme.icon_dir .. "layouts/fairv.svg"
theme.layout_fairh 				= theme.icon_dir .. "layouts/fairh.svg"



---------------------------------------------------------------------------------------
----------------------------------- promptbox icon ------------------------------------
---------------------------------------------------------------------------------------
theme.terminal_icon				= theme.icon_dir .. "promptbox/terminal.svg"



---------------------------------------------------------------------------------------
----------------------------------- titlebar icon -------------------------------------
---------------------------------------------------------------------------------------
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

--theme.tasklist_bg_image_focus    = theme.icon_dir .. "tasklist/bg_focus.svg"
--theme.tasklist_bg_image_normal   = theme.icon_dir .. "tasklist/bg_normal.svg"
--theme.tasklist_bg_image_minimize = theme.icon_dir .. "tasklist/bg_minimize.svg"











return theme
